Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FE421E48D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGNAbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgGNAbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:31:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80B221924;
        Tue, 14 Jul 2020 00:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686690;
        bh=h2JpwGY9/gWFAW2URUnoWDw+wbo9Eb1ddyIPBP9nnEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSTs8tVpia9N50/mEPQrgIkvetVDlISk0W/Fy/L5Nuc1AI9TnwyiArWaZZQvlBb0y
         aPy4gPNIwf2Q3SiMiTwfFUcLgIwBEIti18Q8Lk3TIMA9zQ/5nY2wwSOLE0y0L3ZYy+
         qhETsbbP04kM20ystdmzUZOcdORQsqLSJjjjmb2E=
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
Subject: [PATCH net-next 12/12] qlcnic: convert to new udp_tunnel_nic infra
Date:   Mon, 13 Jul 2020 17:30:37 -0700
Message-Id: <20200714003037.669012-13-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714003037.669012-1-kuba@kernel.org>
References: <20200714003037.669012-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Straightforward conversion to new infra, 1 VxLAN port, handler
may sleep.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |  7 +-
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 31 ++-------
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 64 +++++++------------
 3 files changed, 32 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index d838774af5a6..d67f8265724a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -536,8 +536,6 @@ struct qlcnic_hardware_context {
 	u8 extend_lb_time;
 	u8 phys_port_id[ETH_ALEN];
 	u8 lb_mode;
-	u8 vxlan_port_count;
-	u16 vxlan_port;
 	struct device *hwmon_dev;
 	u32 post_mode;
 	bool run_post;
@@ -1026,9 +1024,6 @@ struct qlcnic_ipaddr {
 #define QLCNIC_HAS_PHYS_PORT_ID		0x40000
 #define QLCNIC_TSS_RSS			0x80000
 
-#define QLCNIC_ADD_VXLAN_PORT		0x100000
-#define QLCNIC_DEL_VXLAN_PORT		0x200000
-
 #define QLCNIC_VLAN_FILTERING		0x800000
 
 #define QLCNIC_IS_MSI_FAMILY(adapter) \
@@ -1700,6 +1695,8 @@ int qlcnic_init_pci_info(struct qlcnic_adapter *);
 int qlcnic_set_default_offload_settings(struct qlcnic_adapter *);
 int qlcnic_reset_npar_config(struct qlcnic_adapter *);
 int qlcnic_set_eswitch_port_config(struct qlcnic_adapter *);
+int qlcnic_set_vxlan_port(struct qlcnic_adapter *adapter, u16 port);
+int qlcnic_set_vxlan_parsing(struct qlcnic_adapter *adapter, u16 port);
 int qlcnic_83xx_configure_opmode(struct qlcnic_adapter *adapter);
 int qlcnic_read_mac_addr(struct qlcnic_adapter *);
 int qlcnic_setup_netdev(struct qlcnic_adapter *, struct net_device *, int);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index cda5b0a9e948..0e2f2fb6c3a9 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -1028,9 +1028,8 @@ static int qlcnic_83xx_idc_check_state_validity(struct qlcnic_adapter *adapter,
 #define QLCNIC_ENABLE_INGRESS_ENCAP_PARSING 1
 #define QLCNIC_DISABLE_INGRESS_ENCAP_PARSING 0
 
-static int qlcnic_set_vxlan_port(struct qlcnic_adapter *adapter)
+int qlcnic_set_vxlan_port(struct qlcnic_adapter *adapter, u16 port)
 {
-	u16 port = adapter->ahw->vxlan_port;
 	struct qlcnic_cmd_args cmd;
 	int ret = 0;
 
@@ -1057,10 +1056,8 @@ static int qlcnic_set_vxlan_port(struct qlcnic_adapter *adapter)
 	return ret;
 }
 
-static int qlcnic_set_vxlan_parsing(struct qlcnic_adapter *adapter,
-				    bool state)
+int qlcnic_set_vxlan_parsing(struct qlcnic_adapter *adapter, u16 port)
 {
-	u16 vxlan_port = adapter->ahw->vxlan_port;
 	struct qlcnic_cmd_args cmd;
 	int ret = 0;
 
@@ -1071,18 +1068,18 @@ static int qlcnic_set_vxlan_parsing(struct qlcnic_adapter *adapter,
 	if (ret)
 		return ret;
 
-	cmd.req.arg[1] = state ? QLCNIC_ENABLE_INGRESS_ENCAP_PARSING :
-				 QLCNIC_DISABLE_INGRESS_ENCAP_PARSING;
+	cmd.req.arg[1] = port ? QLCNIC_ENABLE_INGRESS_ENCAP_PARSING :
+				QLCNIC_DISABLE_INGRESS_ENCAP_PARSING;
 
 	ret = qlcnic_issue_cmd(adapter, &cmd);
 	if (ret)
 		netdev_err(adapter->netdev,
 			   "Failed to %s VXLAN parsing for port %d\n",
-			   state ? "enable" : "disable", vxlan_port);
+			   port ? "enable" : "disable", port);
 	else
 		netdev_info(adapter->netdev,
 			    "%s VXLAN parsing for port %d\n",
-			    state ? "Enabled" : "Disabled", vxlan_port);
+			    port ? "Enabled" : "Disabled", port);
 
 	qlcnic_free_mbx_args(&cmd);
 
@@ -1093,22 +1090,6 @@ static void qlcnic_83xx_periodic_tasks(struct qlcnic_adapter *adapter)
 {
 	if (adapter->fhash.fnum)
 		qlcnic_prune_lb_filters(adapter);
-
-	if (adapter->flags & QLCNIC_ADD_VXLAN_PORT) {
-		if (qlcnic_set_vxlan_port(adapter))
-			return;
-
-		if (qlcnic_set_vxlan_parsing(adapter, true))
-			return;
-
-		adapter->flags &= ~QLCNIC_ADD_VXLAN_PORT;
-	} else if (adapter->flags & QLCNIC_DEL_VXLAN_PORT) {
-		if (qlcnic_set_vxlan_parsing(adapter, false))
-			return;
-
-		adapter->ahw->vxlan_port = 0;
-		adapter->flags &= ~QLCNIC_DEL_VXLAN_PORT;
-	}
 }
 
 /**
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index e52af092a793..173c7300cdf7 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -471,48 +471,29 @@ static int qlcnic_get_phys_port_id(struct net_device *netdev,
 	return 0;
 }
 
-static void qlcnic_add_vxlan_port(struct net_device *netdev,
-				  struct udp_tunnel_info *ti)
+static int qlcnic_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
-	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	struct qlcnic_hardware_context *ahw = adapter->ahw;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
+	struct qlcnic_adapter *adapter = netdev_priv(dev);
+	struct udp_tunnel_info ti;
+	int err;
 
-	/* Adapter supports only one VXLAN port. Use very first port
-	 * for enabling offload
-	 */
-	if (!qlcnic_encap_rx_offload(adapter))
-		return;
-	if (!ahw->vxlan_port_count) {
-		ahw->vxlan_port_count = 1;
-		ahw->vxlan_port = ntohs(ti->port);
-		adapter->flags |= QLCNIC_ADD_VXLAN_PORT;
-		return;
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	if (ti.port) {
+		err = qlcnic_set_vxlan_port(adapter, ntohs(ti.port));
+		if (err)
+			return err;
 	}
-	if (ahw->vxlan_port == ntohs(ti->port))
-		ahw->vxlan_port_count++;
 
+	return qlcnic_set_vxlan_parsing(adapter, ntohs(ti.port));
 }
 
-static void qlcnic_del_vxlan_port(struct net_device *netdev,
-				  struct udp_tunnel_info *ti)
-{
-	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	struct qlcnic_hardware_context *ahw = adapter->ahw;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (!qlcnic_encap_rx_offload(adapter) || !ahw->vxlan_port_count ||
-	    (ahw->vxlan_port != ntohs(ti->port)))
-		return;
-
-	ahw->vxlan_port_count--;
-	if (!ahw->vxlan_port_count)
-		adapter->flags |= QLCNIC_DEL_VXLAN_PORT;
-}
+static const struct udp_tunnel_nic_info qlcnic_udp_tunnels = {
+	.sync_table	= qlcnic_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
 
 static netdev_features_t qlcnic_features_check(struct sk_buff *skb,
 					       struct net_device *dev,
@@ -540,8 +521,8 @@ static const struct net_device_ops qlcnic_netdev_ops = {
 	.ndo_fdb_del		= qlcnic_fdb_del,
 	.ndo_fdb_dump		= qlcnic_fdb_dump,
 	.ndo_get_phys_port_id	= qlcnic_get_phys_port_id,
-	.ndo_udp_tunnel_add	= qlcnic_add_vxlan_port,
-	.ndo_udp_tunnel_del	= qlcnic_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qlcnic_features_check,
 #ifdef CONFIG_QLCNIC_SRIOV
 	.ndo_set_vf_mac		= qlcnic_sriov_set_vf_mac,
@@ -2017,7 +1998,7 @@ qlcnic_attach(struct qlcnic_adapter *adapter)
 	qlcnic_create_sysfs_entries(adapter);
 
 	if (qlcnic_encap_rx_offload(adapter))
-		udp_tunnel_get_rx_info(netdev);
+		udp_tunnel_nic_reset_ntf(netdev);
 
 	adapter->is_up = QLCNIC_ADAPTER_UP_MAGIC;
 	return 0;
@@ -2335,9 +2316,12 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev,
 					  NETIF_F_TSO6;
 	}
 
-	if (qlcnic_encap_rx_offload(adapter))
+	if (qlcnic_encap_rx_offload(adapter)) {
 		netdev->hw_enc_features |= NETIF_F_RXCSUM;
 
+		netdev->udp_tunnel_nic_info = &qlcnic_udp_tunnels;
+	}
+
 	netdev->hw_features = netdev->features;
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->irq = adapter->msix_entries[0].vector;
-- 
2.26.2

