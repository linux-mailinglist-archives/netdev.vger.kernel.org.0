Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4844621FD22
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgGNTSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbgGNTSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:18:44 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50BED22AAF;
        Tue, 14 Jul 2020 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594754323;
        bh=CfUWEYA6zwFKdhdldkwSoVCp58fM7z42qWSL/EqBQFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAGUZu0akdJouV+MlrEVCRfxNp2FtYnJzZex4R2+EisUW15scEl+sduK1XBiVtp0t
         BLu9fCJKCRjQhEy/P7Y2QihIG0Haef66sJevDVSigegIogSqreWS7UluSWAmULVCsE
         Sv/gVeDdLU0ppVci8+SYncIYm4DtZRBKCBHaJJ08=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 04/12] xgbe: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 12:18:22 -0700
Message-Id: <20200714191830.694674-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714191830.694674-1-kuba@kernel.org>
References: <20200714191830.694674-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the new udp_tunnel_nic infra. Don't clear the features
when VxLAN port is not present to make all drivers behave the same.
Driver will now (until we address the problem in the core) leave
the RX UDP tunnel feature always on, since this is what most drivers
do.

Remove the list of VxLAN ports, just program the one core told us to.

The driver seem to want to clear the VxLAN ports on close but it
doesn't seem to flush the port list properly so it'd get wrong
use counts after close/open. Again since it calls its own open
handler we need the reset notification hack.

v2:
 - fix kbuild warning

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 248 +++-------------------
 drivers/net/ethernet/amd/xgbe/xgbe-main.c |  12 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h      |  13 +-
 3 files changed, 30 insertions(+), 243 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index dfeddf5fbf78..43294a148f8a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -904,114 +904,40 @@ void xgbe_get_all_hw_features(struct xgbe_prv_data *pdata)
 	}
 }
 
-static void xgbe_disable_vxlan_offloads(struct xgbe_prv_data *pdata)
+static int xgbe_vxlan_set_port(struct net_device *netdev, unsigned int table,
+			       unsigned int entry, struct udp_tunnel_info *ti)
 {
-	struct net_device *netdev = pdata->netdev;
-
-	if (!pdata->vxlan_offloads_set)
-		return;
-
-	netdev_info(netdev, "disabling VXLAN offloads\n");
-
-	netdev->hw_enc_features &= ~(NETIF_F_SG |
-				     NETIF_F_IP_CSUM |
-				     NETIF_F_IPV6_CSUM |
-				     NETIF_F_RXCSUM |
-				     NETIF_F_TSO |
-				     NETIF_F_TSO6 |
-				     NETIF_F_GRO |
-				     NETIF_F_GSO_UDP_TUNNEL |
-				     NETIF_F_GSO_UDP_TUNNEL_CSUM);
+	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
-	netdev->features &= ~(NETIF_F_GSO_UDP_TUNNEL |
-			      NETIF_F_GSO_UDP_TUNNEL_CSUM);
+	pdata->vxlan_port = be16_to_cpu(ti->port);
+	pdata->hw_if.enable_vxlan(pdata);
 
-	pdata->vxlan_offloads_set = 0;
+	return 0;
 }
 
-static void xgbe_disable_vxlan_hw(struct xgbe_prv_data *pdata)
+static int xgbe_vxlan_unset_port(struct net_device *netdev, unsigned int table,
+				 unsigned int entry, struct udp_tunnel_info *ti)
 {
-	if (!pdata->vxlan_port_set)
-		return;
+	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
 	pdata->hw_if.disable_vxlan(pdata);
-
-	pdata->vxlan_port_set = 0;
 	pdata->vxlan_port = 0;
-}
-
-static void xgbe_disable_vxlan_accel(struct xgbe_prv_data *pdata)
-{
-	xgbe_disable_vxlan_offloads(pdata);
 
-	xgbe_disable_vxlan_hw(pdata);
-}
-
-static void xgbe_enable_vxlan_offloads(struct xgbe_prv_data *pdata)
-{
-	struct net_device *netdev = pdata->netdev;
-
-	if (pdata->vxlan_offloads_set)
-		return;
-
-	netdev_info(netdev, "enabling VXLAN offloads\n");
-
-	netdev->hw_enc_features |= NETIF_F_SG |
-				   NETIF_F_IP_CSUM |
-				   NETIF_F_IPV6_CSUM |
-				   NETIF_F_RXCSUM |
-				   NETIF_F_TSO |
-				   NETIF_F_TSO6 |
-				   NETIF_F_GRO |
-				   pdata->vxlan_features;
-
-	netdev->features |= pdata->vxlan_features;
-
-	pdata->vxlan_offloads_set = 1;
-}
-
-static void xgbe_enable_vxlan_hw(struct xgbe_prv_data *pdata)
-{
-	struct xgbe_vxlan_data *vdata;
-
-	if (pdata->vxlan_port_set)
-		return;
-
-	if (list_empty(&pdata->vxlan_ports))
-		return;
-
-	vdata = list_first_entry(&pdata->vxlan_ports,
-				 struct xgbe_vxlan_data, list);
-
-	pdata->vxlan_port_set = 1;
-	pdata->vxlan_port = be16_to_cpu(vdata->port);
-
-	pdata->hw_if.enable_vxlan(pdata);
+	return 0;
 }
 
-static void xgbe_enable_vxlan_accel(struct xgbe_prv_data *pdata)
-{
-	/* VXLAN acceleration desired? */
-	if (!pdata->vxlan_features)
-		return;
-
-	/* VXLAN acceleration possible? */
-	if (pdata->vxlan_force_disable)
-		return;
-
-	xgbe_enable_vxlan_hw(pdata);
-
-	xgbe_enable_vxlan_offloads(pdata);
-}
+static const struct udp_tunnel_nic_info xgbe_udp_tunnels = {
+	.set_port	= xgbe_vxlan_set_port,
+	.unset_port	= xgbe_vxlan_unset_port,
+	.flags		= UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
 
-static void xgbe_reset_vxlan_accel(struct xgbe_prv_data *pdata)
+const struct udp_tunnel_nic_info *xgbe_get_udp_tunnel_info(void)
 {
-	xgbe_disable_vxlan_hw(pdata);
-
-	if (pdata->vxlan_features)
-		xgbe_enable_vxlan_offloads(pdata);
-
-	pdata->vxlan_force_disable = 0;
+	return &xgbe_udp_tunnels;
 }
 
 static void xgbe_napi_enable(struct xgbe_prv_data *pdata, unsigned int add)
@@ -1406,7 +1332,7 @@ static int xgbe_start(struct xgbe_prv_data *pdata)
 	hw_if->enable_tx(pdata);
 	hw_if->enable_rx(pdata);
 
-	udp_tunnel_get_rx_info(netdev);
+	udp_tunnel_nic_reset_ntf(netdev);
 
 	netif_tx_start_all_queues(netdev);
 
@@ -1447,7 +1373,7 @@ static void xgbe_stop(struct xgbe_prv_data *pdata)
 	xgbe_stop_timers(pdata);
 	flush_workqueue(pdata->dev_workqueue);
 
-	xgbe_reset_vxlan_accel(pdata);
+	xgbe_vxlan_unset_port(netdev, 0, 0, NULL);
 
 	hw_if->disable_tx(pdata);
 	hw_if->disable_rx(pdata);
@@ -2260,23 +2186,12 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 					   netdev_features_t features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
-	netdev_features_t vxlan_base, vxlan_mask;
+	netdev_features_t vxlan_base;
 
 	vxlan_base = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_RX_UDP_TUNNEL_PORT;
-	vxlan_mask = vxlan_base | NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-	pdata->vxlan_features = features & vxlan_mask;
 
-	/* Only fix VXLAN-related features */
-	if (!pdata->vxlan_features)
-		return features;
-
-	/* If VXLAN isn't supported then clear any features:
-	 *   This is needed because NETIF_F_RX_UDP_TUNNEL_PORT gets
-	 *   automatically set if ndo_udp_tunnel_add is set.
-	 */
 	if (!pdata->hw_feat.vxn)
-		return features & ~vxlan_mask;
+		return features;
 
 	/* VXLAN CSUM requires VXLAN base */
 	if ((features & NETIF_F_GSO_UDP_TUNNEL_CSUM) &&
@@ -2307,15 +2222,6 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		}
 	}
 
-	pdata->vxlan_features = features & vxlan_mask;
-
-	/* Adjust UDP Tunnel based on current state */
-	if (pdata->vxlan_force_disable) {
-		netdev_notice(netdev,
-			      "VXLAN acceleration disabled, turning off udp tunnel features\n");
-		features &= ~vxlan_mask;
-	}
-
 	return features;
 }
 
@@ -2325,14 +2231,12 @@ static int xgbe_set_features(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
 	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
-	netdev_features_t udp_tunnel;
 	int ret = 0;
 
 	rxhash = pdata->netdev_features & NETIF_F_RXHASH;
 	rxcsum = pdata->netdev_features & NETIF_F_RXCSUM;
 	rxvlan = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_RX;
 	rxvlan_filter = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_FILTER;
-	udp_tunnel = pdata->netdev_features & NETIF_F_GSO_UDP_TUNNEL;
 
 	if ((features & NETIF_F_RXHASH) && !rxhash)
 		ret = hw_if->enable_rss(pdata);
@@ -2356,11 +2260,6 @@ static int xgbe_set_features(struct net_device *netdev,
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) && rxvlan_filter)
 		hw_if->disable_rx_vlan_filtering(pdata);
 
-	if ((features & NETIF_F_GSO_UDP_TUNNEL) && !udp_tunnel)
-		xgbe_enable_vxlan_accel(pdata);
-	else if (!(features & NETIF_F_GSO_UDP_TUNNEL) && udp_tunnel)
-		xgbe_disable_vxlan_accel(pdata);
-
 	pdata->netdev_features = features;
 
 	DBGPR("<--xgbe_set_features\n");
@@ -2368,101 +2267,6 @@ static int xgbe_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static void xgbe_udp_tunnel_add(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
-{
-	struct xgbe_prv_data *pdata = netdev_priv(netdev);
-	struct xgbe_vxlan_data *vdata;
-
-	if (!pdata->hw_feat.vxn)
-		return;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	pdata->vxlan_port_count++;
-
-	netif_dbg(pdata, drv, netdev,
-		  "adding VXLAN tunnel, family=%hx/port=%hx\n",
-		  ti->sa_family, be16_to_cpu(ti->port));
-
-	if (pdata->vxlan_force_disable)
-		return;
-
-	vdata = kzalloc(sizeof(*vdata), GFP_ATOMIC);
-	if (!vdata) {
-		/* Can no longer properly track VXLAN ports */
-		pdata->vxlan_force_disable = 1;
-		netif_dbg(pdata, drv, netdev,
-			  "internal error, disabling VXLAN accelerations\n");
-
-		xgbe_disable_vxlan_accel(pdata);
-
-		return;
-	}
-	vdata->sa_family = ti->sa_family;
-	vdata->port = ti->port;
-
-	list_add_tail(&vdata->list, &pdata->vxlan_ports);
-
-	/* First port added? */
-	if (pdata->vxlan_port_count == 1) {
-		xgbe_enable_vxlan_accel(pdata);
-
-		return;
-	}
-}
-
-static void xgbe_udp_tunnel_del(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
-{
-	struct xgbe_prv_data *pdata = netdev_priv(netdev);
-	struct xgbe_vxlan_data *vdata;
-
-	if (!pdata->hw_feat.vxn)
-		return;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	netif_dbg(pdata, drv, netdev,
-		  "deleting VXLAN tunnel, family=%hx/port=%hx\n",
-		  ti->sa_family, be16_to_cpu(ti->port));
-
-	/* Don't need safe version since loop terminates with deletion */
-	list_for_each_entry(vdata, &pdata->vxlan_ports, list) {
-		if (vdata->sa_family != ti->sa_family)
-			continue;
-
-		if (vdata->port != ti->port)
-			continue;
-
-		list_del(&vdata->list);
-		kfree(vdata);
-
-		break;
-	}
-
-	pdata->vxlan_port_count--;
-	if (!pdata->vxlan_port_count) {
-		xgbe_reset_vxlan_accel(pdata);
-
-		return;
-	}
-
-	if (pdata->vxlan_force_disable)
-		return;
-
-	/* See if VXLAN tunnel id needs to be changed */
-	vdata = list_first_entry(&pdata->vxlan_ports,
-				 struct xgbe_vxlan_data, list);
-	if (pdata->vxlan_port == be16_to_cpu(vdata->port))
-		return;
-
-	pdata->vxlan_port = be16_to_cpu(vdata->port);
-	pdata->hw_if.set_vxlan_id(pdata);
-}
-
 static netdev_features_t xgbe_features_check(struct sk_buff *skb,
 					     struct net_device *netdev,
 					     netdev_features_t features)
@@ -2492,8 +2296,8 @@ static const struct net_device_ops xgbe_netdev_ops = {
 	.ndo_setup_tc		= xgbe_setup_tc,
 	.ndo_fix_features	= xgbe_fix_features,
 	.ndo_set_features	= xgbe_set_features,
-	.ndo_udp_tunnel_add	= xgbe_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= xgbe_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= xgbe_features_check,
 };
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 2a70714a791d..a218dc6f2edd 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -192,7 +192,6 @@ struct xgbe_prv_data *xgbe_alloc_pdata(struct device *dev)
 	mutex_init(&pdata->i2c_mutex);
 	init_completion(&pdata->i2c_complete);
 	init_completion(&pdata->mdio_complete);
-	INIT_LIST_HEAD(&pdata->vxlan_ports);
 
 	pdata->msg_enable = netif_msg_init(debug, default_msg_level);
 
@@ -366,17 +365,12 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 					  NETIF_F_TSO6 |
 					  NETIF_F_GRO |
 					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					  NETIF_F_RX_UDP_TUNNEL_PORT;
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				       NETIF_F_RX_UDP_TUNNEL_PORT;
+				       NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
-		pdata->vxlan_offloads_set = 1;
-		pdata->vxlan_features = NETIF_F_GSO_UDP_TUNNEL |
-					NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_RX_UDP_TUNNEL_PORT;
+		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
 
 	netdev->vlan_features |= NETIF_F_SG |
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 5897e46faca5..ba8321ec1ee7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1014,12 +1014,6 @@ struct xgbe_version_data {
 	unsigned int an_cdr_workaround;
 };
 
-struct xgbe_vxlan_data {
-	struct list_head list;
-	sa_family_t sa_family;
-	__be16 port;
-};
-
 struct xgbe_prv_data {
 	struct net_device *netdev;
 	struct pci_dev *pcidev;
@@ -1172,13 +1166,7 @@ struct xgbe_prv_data {
 	u32 rss_options;
 
 	/* VXLAN settings */
-	unsigned int vxlan_port_set;
-	unsigned int vxlan_offloads_set;
-	unsigned int vxlan_force_disable;
-	unsigned int vxlan_port_count;
-	struct list_head vxlan_ports;
 	u16 vxlan_port;
-	netdev_features_t vxlan_features;
 
 	/* Netdev related settings */
 	unsigned char mac_addr[ETH_ALEN];
@@ -1321,6 +1309,7 @@ void xgbe_init_function_ptrs_desc(struct xgbe_desc_if *);
 void xgbe_init_function_ptrs_i2c(struct xgbe_i2c_if *);
 const struct net_device_ops *xgbe_get_netdev_ops(void);
 const struct ethtool_ops *xgbe_get_ethtool_ops(void);
+const struct udp_tunnel_nic_info *xgbe_get_udp_tunnel_info(void);
 
 #ifdef CONFIG_AMD_XGBE_DCB
 const struct dcbnl_rtnl_ops *xgbe_get_dcbnl_ops(void);
-- 
2.26.2

