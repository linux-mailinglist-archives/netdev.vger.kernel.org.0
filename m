Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351BB21E484
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGNAbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgGNAbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:31:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9CB2193E;
        Tue, 14 Jul 2020 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686681;
        bh=TM4Lv5JKzRsrWAB51IvWH1f5wpHaUNUIgOafvsHyZ1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WikIvSQ3DpCMyBRJqX6v8uYyn6cpATLWRacKWJLhJrPSP+rZ2530JDu1n+qfzSw41
         KkAXo4srvIGezV4z60cmjkqrf1XNxaXIpnysFhXuVhO8iw/fRhTPO3NNV/idW2VgIU
         f8A22sF21scWWyQe2LZfgUld5khkglV1P71198FQ=
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
Subject: [PATCH net-next 02/12] be2net: convert to new udp_tunnel_nic infra
Date:   Mon, 13 Jul 2020 17:30:27 -0700
Message-Id: <20200714003037.669012-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714003037.669012-1-kuba@kernel.org>
References: <20200714003037.669012-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert be2net to new udp_tunnel_nic infra. NIC only takes one VxLAN
port. Remove the port tracking using a list. The warning in
be_work_del_vxlan_port() looked suspicious - like the driver expected
ports to be removed in order of addition.

be2net unregisters ports when going down and re-registers them (for
skyhawk) when coming up, but it never checks if the device is up
in the add_port / del_port callbacks. Make it use
UDP_TUNNEL_NIC_INFO_OPEN_ONLY. Sadly this driver calls its own
open/close functions directly so the udp_tunnel_nic_reset_ntf()
workaround is needed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be.h      |   5 -
 drivers/net/ethernet/emulex/benet/be_main.c | 198 ++++----------------
 2 files changed, 38 insertions(+), 165 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index 6e9022083004..8689d4a51fe5 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -654,8 +654,6 @@ struct be_adapter {
 	u8 hba_port_num;
 	u16 pvid;
 	__be16 vxlan_port;		/* offloaded vxlan port num */
-	int vxlan_port_count;		/* active vxlan port count */
-	struct list_head vxlan_port_list;	/* vxlan port list */
 	struct phy_info phy;
 	u8 wol_cap;
 	bool wol_en;
@@ -679,9 +677,6 @@ struct be_adapter {
 struct be_cmd_work {
 	struct work_struct work;
 	struct be_adapter *adapter;
-	union {
-		__be16 vxlan_port;
-	} info;
 };
 
 #define be_physfn(adapter)		(!adapter->virtfn)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index e26f59336cfd..676e437d78f6 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3829,8 +3829,8 @@ static int be_open(struct net_device *netdev)
 		be_link_status_update(adapter, link_status);
 
 	netif_tx_start_all_queues(netdev);
-	if (skyhawk_chip(adapter))
-		udp_tunnel_get_rx_info(netdev);
+
+	udp_tunnel_nic_reset_ntf(netdev);
 
 	return 0;
 err:
@@ -3967,18 +3967,23 @@ static void be_cancel_err_detection(struct be_adapter *adapter)
 	}
 }
 
-static int be_enable_vxlan_offloads(struct be_adapter *adapter)
+/* VxLAN offload Notes:
+ *
+ * The stack defines tunnel offload flags (hw_enc_features) for IP and doesn't
+ * distinguish various types of transports (VxLAN, GRE, NVGRE ..). So, offload
+ * is expected to work across all types of IP tunnels once exported. Skyhawk
+ * supports offloads for either VxLAN or NVGRE, exclusively. So we export VxLAN
+ * offloads in hw_enc_features only when a VxLAN port is added. If other (non
+ * VxLAN) tunnels are configured while VxLAN offloads are enabled, offloads for
+ * those other tunnels are unexported on the fly through ndo_features_check().
+ */
+static int be_vxlan_set_port(struct net_device *netdev, unsigned int table,
+			     unsigned int entry, struct udp_tunnel_info *ti)
 {
-	struct net_device *netdev = adapter->netdev;
+	struct be_adapter *adapter = netdev_priv(netdev);
 	struct device *dev = &adapter->pdev->dev;
-	struct be_vxlan_port *vxlan_port;
-	__be16 port;
 	int status;
 
-	vxlan_port = list_first_entry(&adapter->vxlan_port_list,
-				      struct be_vxlan_port, list);
-	port = vxlan_port->port;
-
 	status = be_cmd_manage_iface(adapter, adapter->if_handle,
 				     OP_CONVERT_NORMAL_TO_TUNNEL);
 	if (status) {
@@ -3987,25 +3992,26 @@ static int be_enable_vxlan_offloads(struct be_adapter *adapter)
 	}
 	adapter->flags |= BE_FLAGS_VXLAN_OFFLOADS;
 
-	status = be_cmd_set_vxlan_port(adapter, port);
+	status = be_cmd_set_vxlan_port(adapter, ti->port);
 	if (status) {
 		dev_warn(dev, "Failed to add VxLAN port\n");
 		return status;
 	}
-	adapter->vxlan_port = port;
+	adapter->vxlan_port = ti->port;
 
 	netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				   NETIF_F_TSO | NETIF_F_TSO6 |
 				   NETIF_F_GSO_UDP_TUNNEL;
 
 	dev_info(dev, "Enabled VxLAN offloads for UDP port %d\n",
-		 be16_to_cpu(port));
+		 be16_to_cpu(ti->port));
 	return 0;
 }
 
-static void be_disable_vxlan_offloads(struct be_adapter *adapter)
+static int be_vxlan_unset_port(struct net_device *netdev, unsigned int table,
+			       unsigned int entry, struct udp_tunnel_info *ti)
 {
-	struct net_device *netdev = adapter->netdev;
+	struct be_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->flags & BE_FLAGS_VXLAN_OFFLOADS)
 		be_cmd_manage_iface(adapter, adapter->if_handle,
@@ -4018,8 +4024,19 @@ static void be_disable_vxlan_offloads(struct be_adapter *adapter)
 	adapter->vxlan_port = 0;
 
 	netdev->hw_enc_features = 0;
+	return 0;
 }
 
+static const struct udp_tunnel_nic_info be_udp_tunnels = {
+	.set_port	= be_vxlan_set_port,
+	.unset_port	= be_vxlan_unset_port,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+			  UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
+
 static void be_calculate_vf_res(struct be_adapter *adapter, u16 num_vfs,
 				struct be_resources *vft_res)
 {
@@ -4135,7 +4152,7 @@ static int be_clear(struct be_adapter *adapter)
 					&vft_res);
 	}
 
-	be_disable_vxlan_offloads(adapter);
+	be_vxlan_unset_port(adapter->netdev, 0, 0, NULL);
 
 	be_if_destroy(adapter);
 
@@ -5053,147 +5070,6 @@ static struct be_cmd_work *be_alloc_work(struct be_adapter *adapter,
 	return work;
 }
 
-/* VxLAN offload Notes:
- *
- * The stack defines tunnel offload flags (hw_enc_features) for IP and doesn't
- * distinguish various types of transports (VxLAN, GRE, NVGRE ..). So, offload
- * is expected to work across all types of IP tunnels once exported. Skyhawk
- * supports offloads for either VxLAN or NVGRE, exclusively. So we export VxLAN
- * offloads in hw_enc_features only when a VxLAN port is added. If other (non
- * VxLAN) tunnels are configured while VxLAN offloads are enabled, offloads for
- * those other tunnels are unexported on the fly through ndo_features_check().
- *
- * Skyhawk supports VxLAN offloads only for one UDP dport. So, if the stack
- * adds more than one port, disable offloads and re-enable them again when
- * there's only one port left. We maintain a list of ports for this purpose.
- */
-static void be_work_add_vxlan_port(struct work_struct *work)
-{
-	struct be_cmd_work *cmd_work =
-				container_of(work, struct be_cmd_work, work);
-	struct be_adapter *adapter = cmd_work->adapter;
-	struct device *dev = &adapter->pdev->dev;
-	__be16 port = cmd_work->info.vxlan_port;
-	struct be_vxlan_port *vxlan_port;
-	int status;
-
-	/* Bump up the alias count if it is an existing port */
-	list_for_each_entry(vxlan_port, &adapter->vxlan_port_list, list) {
-		if (vxlan_port->port == port) {
-			vxlan_port->port_aliases++;
-			goto done;
-		}
-	}
-
-	/* Add a new port to our list. We don't need a lock here since port
-	 * add/delete are done only in the context of a single-threaded work
-	 * queue (be_wq).
-	 */
-	vxlan_port = kzalloc(sizeof(*vxlan_port), GFP_KERNEL);
-	if (!vxlan_port)
-		goto done;
-
-	vxlan_port->port = port;
-	INIT_LIST_HEAD(&vxlan_port->list);
-	list_add_tail(&vxlan_port->list, &adapter->vxlan_port_list);
-	adapter->vxlan_port_count++;
-
-	if (adapter->flags & BE_FLAGS_VXLAN_OFFLOADS) {
-		dev_info(dev,
-			 "Only one UDP port supported for VxLAN offloads\n");
-		dev_info(dev, "Disabling VxLAN offloads\n");
-		goto err;
-	}
-
-	if (adapter->vxlan_port_count > 1)
-		goto done;
-
-	status = be_enable_vxlan_offloads(adapter);
-	if (!status)
-		goto done;
-
-err:
-	be_disable_vxlan_offloads(adapter);
-done:
-	kfree(cmd_work);
-	return;
-}
-
-static void be_work_del_vxlan_port(struct work_struct *work)
-{
-	struct be_cmd_work *cmd_work =
-				container_of(work, struct be_cmd_work, work);
-	struct be_adapter *adapter = cmd_work->adapter;
-	__be16 port = cmd_work->info.vxlan_port;
-	struct be_vxlan_port *vxlan_port;
-
-	/* Nothing to be done if a port alias is being deleted */
-	list_for_each_entry(vxlan_port, &adapter->vxlan_port_list, list) {
-		if (vxlan_port->port == port) {
-			if (vxlan_port->port_aliases) {
-				vxlan_port->port_aliases--;
-				goto done;
-			}
-			break;
-		}
-	}
-
-	/* No port aliases left; delete the port from the list */
-	list_del(&vxlan_port->list);
-	adapter->vxlan_port_count--;
-
-	/* Disable VxLAN offload if this is the offloaded port */
-	if (adapter->vxlan_port == vxlan_port->port) {
-		WARN_ON(adapter->vxlan_port_count);
-		be_disable_vxlan_offloads(adapter);
-		dev_info(&adapter->pdev->dev,
-			 "Disabled VxLAN offloads for UDP port %d\n",
-			 be16_to_cpu(port));
-		goto out;
-	}
-
-	/* If only 1 port is left, re-enable VxLAN offload */
-	if (adapter->vxlan_port_count == 1)
-		be_enable_vxlan_offloads(adapter);
-
-out:
-	kfree(vxlan_port);
-done:
-	kfree(cmd_work);
-}
-
-static void be_cfg_vxlan_port(struct net_device *netdev,
-			      struct udp_tunnel_info *ti,
-			      void (*func)(struct work_struct *))
-{
-	struct be_adapter *adapter = netdev_priv(netdev);
-	struct be_cmd_work *cmd_work;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (lancer_chip(adapter) || BEx_chip(adapter) || be_is_mc(adapter))
-		return;
-
-	cmd_work = be_alloc_work(adapter, func);
-	if (cmd_work) {
-		cmd_work->info.vxlan_port = ti->port;
-		queue_work(be_wq, &cmd_work->work);
-	}
-}
-
-static void be_del_vxlan_port(struct net_device *netdev,
-			      struct udp_tunnel_info *ti)
-{
-	be_cfg_vxlan_port(netdev, ti, be_work_del_vxlan_port);
-}
-
-static void be_add_vxlan_port(struct net_device *netdev,
-			      struct udp_tunnel_info *ti)
-{
-	be_cfg_vxlan_port(netdev, ti, be_work_add_vxlan_port);
-}
-
 static netdev_features_t be_features_check(struct sk_buff *skb,
 					   struct net_device *dev,
 					   netdev_features_t features)
@@ -5309,8 +5185,8 @@ static const struct net_device_ops be_netdev_ops = {
 #endif
 	.ndo_bridge_setlink	= be_ndo_bridge_setlink,
 	.ndo_bridge_getlink	= be_ndo_bridge_getlink,
-	.ndo_udp_tunnel_add	= be_add_vxlan_port,
-	.ndo_udp_tunnel_del	= be_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= be_features_check,
 	.ndo_get_phys_port_id   = be_get_phys_port_id,
 };
@@ -5342,6 +5218,9 @@ static void be_netdev_init(struct net_device *netdev)
 
 	netdev->ethtool_ops = &be_ethtool_ops;
 
+	if (!lancer_chip(adapter) && !BEx_chip(adapter) && !be_is_mc(adapter))
+		netdev->udp_tunnel_nic_info = &be_udp_tunnels;
+
 	/* MTU range: 256 - 9000 */
 	netdev->min_mtu = BE_MIN_MTU;
 	netdev->max_mtu = BE_MAX_MTU;
@@ -5819,7 +5698,6 @@ static int be_drv_init(struct be_adapter *adapter)
 	/* Must be a power of 2 or else MODULO will BUG_ON */
 	adapter->be_get_temp_freq = 64;
 
-	INIT_LIST_HEAD(&adapter->vxlan_port_list);
 	return 0;
 
 free_rx_filter:
-- 
2.26.2

