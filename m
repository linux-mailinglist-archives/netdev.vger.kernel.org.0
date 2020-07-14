Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1BC21F96D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgGNS3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgGNS3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:29:39 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959EE229C5;
        Tue, 14 Jul 2020 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751377;
        bh=ePEhaaEO2PGiDrYSgME/D2Pkt6URFV5jyRtpVsM1YVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kp3Iuhx0rWhA5BLy+7WOYnbqQ66guE3n44g7AmFV3FqR0UzSkdqERntQwGWe7Vgsk
         4bv3JkywYWWaxjafINOs0/tsDRm95hs+c5nAygEdh2/Iwif1BgfbfTjESqyjWZ31bp
         D8Ye9EwBhaTJJFySQB6vz2lBdYUzpuIY4NSM5Q2w=
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
Subject: [PATCH net-next v2 10/12] fm10k: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 11:29:06 -0700
Message-Id: <20200714182908.690108-11-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714182908.690108-1-kuba@kernel.org>
References: <20200714182908.690108-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Straightforward conversion to new infra. Driver restores info
after close/open cycle by calling its internal restore function
so just use that, no need for udp_tunnel_nic_reset_ntf() here.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k.h      |  10 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   9 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   | 164 +++---------------
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |   4 -
 4 files changed, 28 insertions(+), 159 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k.h b/drivers/net/ethernet/intel/fm10k/fm10k.h
index f9be10a04dd6..6119a4108838 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k.h
@@ -221,12 +221,6 @@ struct fm10k_iov_data {
 	struct fm10k_vf_info	vf_info[];
 };
 
-struct fm10k_udp_port {
-	struct list_head	list;
-	sa_family_t		sa_family;
-	__be16			port;
-};
-
 enum fm10k_macvlan_request_type {
 	FM10K_UC_MAC_REQUEST,
 	FM10K_MC_MAC_REQUEST,
@@ -370,8 +364,8 @@ struct fm10k_intfc {
 	u32 rssrk[FM10K_RSSRK_SIZE];
 
 	/* UDP encapsulation port tracking information */
-	struct list_head vxlan_port;
-	struct list_head geneve_port;
+	__be16 vxlan_port;
+	__be16 geneve_port;
 
 	/* MAC/VLAN update queue */
 	struct list_head macvlan_requests;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 34f1f5350f68..d88dd41a9442 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -635,15 +635,8 @@ static int fm10k_clean_rx_irq(struct fm10k_q_vector *q_vector,
 static struct ethhdr *fm10k_port_is_vxlan(struct sk_buff *skb)
 {
 	struct fm10k_intfc *interface = netdev_priv(skb->dev);
-	struct fm10k_udp_port *vxlan_port;
 
-	/* we can only offload a vxlan if we recognize it as such */
-	vxlan_port = list_first_entry_or_null(&interface->vxlan_port,
-					      struct fm10k_udp_port, list);
-
-	if (!vxlan_port)
-		return NULL;
-	if (vxlan_port->port != udp_hdr(skb)->dest)
+	if (interface->vxlan_port != udp_hdr(skb)->dest)
 		return NULL;
 
 	/* return offset of udp_hdr plus 8 bytes for VXLAN header */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 1450a9f98c5a..5c19ff452558 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -366,39 +366,6 @@ static void fm10k_request_glort_range(struct fm10k_intfc *interface)
 	}
 }
 
-/**
- * fm10k_free_udp_port_info
- * @interface: board private structure
- *
- * This function frees both geneve_port and vxlan_port structures
- **/
-static void fm10k_free_udp_port_info(struct fm10k_intfc *interface)
-{
-	struct fm10k_udp_port *port;
-
-	/* flush all entries from vxlan list */
-	port = list_first_entry_or_null(&interface->vxlan_port,
-					struct fm10k_udp_port, list);
-	while (port) {
-		list_del(&port->list);
-		kfree(port);
-		port = list_first_entry_or_null(&interface->vxlan_port,
-						struct fm10k_udp_port,
-						list);
-	}
-
-	/* flush all entries from geneve list */
-	port = list_first_entry_or_null(&interface->geneve_port,
-					struct fm10k_udp_port, list);
-	while (port) {
-		list_del(&port->list);
-		kfree(port);
-		port = list_first_entry_or_null(&interface->vxlan_port,
-						struct fm10k_udp_port,
-						list);
-	}
-}
-
 /**
  * fm10k_restore_udp_port_info
  * @interface: board private structure
@@ -408,131 +375,52 @@ static void fm10k_free_udp_port_info(struct fm10k_intfc *interface)
 static void fm10k_restore_udp_port_info(struct fm10k_intfc *interface)
 {
 	struct fm10k_hw *hw = &interface->hw;
-	struct fm10k_udp_port *port;
 
 	/* only the PF supports configuring tunnels */
 	if (hw->mac.type != fm10k_mac_pf)
 		return;
 
-	port = list_first_entry_or_null(&interface->vxlan_port,
-					struct fm10k_udp_port, list);
-
 	/* restore tunnel configuration register */
 	fm10k_write_reg(hw, FM10K_TUNNEL_CFG,
-			(port ? ntohs(port->port) : 0) |
+			ntohs(interface->vxlan_port) |
 			(ETH_P_TEB << FM10K_TUNNEL_CFG_NVGRE_SHIFT));
 
-	port = list_first_entry_or_null(&interface->geneve_port,
-					struct fm10k_udp_port, list);
-
 	/* restore Geneve tunnel configuration register */
 	fm10k_write_reg(hw, FM10K_TUNNEL_CFG_GENEVE,
-			(port ? ntohs(port->port) : 0));
-}
-
-static struct fm10k_udp_port *
-fm10k_remove_tunnel_port(struct list_head *ports,
-			 struct udp_tunnel_info *ti)
-{
-	struct fm10k_udp_port *port;
-
-	list_for_each_entry(port, ports, list) {
-		if ((port->port == ti->port) &&
-		    (port->sa_family == ti->sa_family)) {
-			list_del(&port->list);
-			return port;
-		}
-	}
-
-	return NULL;
-}
-
-static void fm10k_insert_tunnel_port(struct list_head *ports,
-				     struct udp_tunnel_info *ti)
-{
-	struct fm10k_udp_port *port;
-
-	/* remove existing port entry from the list so that the newest items
-	 * are always at the tail of the list.
-	 */
-	port = fm10k_remove_tunnel_port(ports, ti);
-	if (!port) {
-		port = kmalloc(sizeof(*port), GFP_ATOMIC);
-		if  (!port)
-			return;
-		port->port = ti->port;
-		port->sa_family = ti->sa_family;
-	}
-
-	list_add_tail(&port->list, ports);
+			ntohs(interface->geneve_port));
 }
 
 /**
- * fm10k_udp_tunnel_add
+ * fm10k_udp_tunnel_sync - Called when UDP tunnel ports change
  * @dev: network interface device structure
- * @ti: Tunnel endpoint information
+ * @table: Tunnel table (according to tables of @fm10k_udp_tunnels)
  *
- * This function is called when a new UDP tunnel port has been added.
+ * This function is called when a new UDP tunnel port is added or deleted.
  * Due to hardware restrictions, only one port per type can be offloaded at
- * once.
+ * once. Core will send to the driver a port of its choice.
  **/
-static void fm10k_udp_tunnel_add(struct net_device *dev,
-				 struct udp_tunnel_info *ti)
+static int fm10k_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
 	struct fm10k_intfc *interface = netdev_priv(dev);
+	struct udp_tunnel_info ti;
 
-	/* only the PF supports configuring tunnels */
-	if (interface->hw.mac.type != fm10k_mac_pf)
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		fm10k_insert_tunnel_port(&interface->vxlan_port, ti);
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		fm10k_insert_tunnel_port(&interface->geneve_port, ti);
-		break;
-	default:
-		return;
-	}
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	if (!table)
+		interface->vxlan_port = ti.port;
+	else
+		interface->geneve_port = ti.port;
 
 	fm10k_restore_udp_port_info(interface);
+	return 0;
 }
 
-/**
- * fm10k_udp_tunnel_del
- * @dev: network interface device structure
- * @ti: Tunnel end point information
- *
- * This function is called when a new UDP tunnel port is deleted. The freed
- * port will be removed from the list, then we reprogram the offloaded port
- * based on the head of the list.
- **/
-static void fm10k_udp_tunnel_del(struct net_device *dev,
-				 struct udp_tunnel_info *ti)
-{
-	struct fm10k_intfc *interface = netdev_priv(dev);
-	struct fm10k_udp_port *port = NULL;
-
-	if (interface->hw.mac.type != fm10k_mac_pf)
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		port = fm10k_remove_tunnel_port(&interface->vxlan_port, ti);
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		port = fm10k_remove_tunnel_port(&interface->geneve_port, ti);
-		break;
-	default:
-		return;
-	}
-
-	/* if we did remove a port we need to free its memory */
-	kfree(port);
-
-	fm10k_restore_udp_port_info(interface);
-}
+static const struct udp_tunnel_nic_info fm10k_udp_tunnels = {
+	.sync_table	= fm10k_udp_tunnel_sync,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
 
 /**
  * fm10k_open - Called when a network interface is made active
@@ -580,8 +468,6 @@ int fm10k_open(struct net_device *netdev)
 	if (err)
 		goto err_set_queues;
 
-	udp_tunnel_get_rx_info(netdev);
-
 	fm10k_up(interface);
 
 	return 0;
@@ -615,8 +501,6 @@ int fm10k_close(struct net_device *netdev)
 
 	fm10k_qv_free_irq(interface);
 
-	fm10k_free_udp_port_info(interface);
-
 	fm10k_free_all_tx_resources(interface);
 	fm10k_free_all_rx_resources(interface);
 
@@ -1647,8 +1531,8 @@ static const struct net_device_ops fm10k_netdev_ops = {
 	.ndo_set_vf_rate	= fm10k_ndo_set_vf_bw,
 	.ndo_get_vf_config	= fm10k_ndo_get_vf_config,
 	.ndo_get_vf_stats	= fm10k_ndo_get_vf_stats,
-	.ndo_udp_tunnel_add	= fm10k_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= fm10k_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_dfwd_add_station	= fm10k_dfwd_add_station,
 	.ndo_dfwd_del_station	= fm10k_dfwd_del_station,
 	.ndo_features_check	= fm10k_features_check,
@@ -1695,6 +1579,8 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 				       NETIF_F_SG;
 
 		dev->features |= NETIF_F_GSO_UDP_TUNNEL;
+
+		dev->udp_tunnel_nic_info = &fm10k_udp_tunnels;
 	}
 
 	/* all features defined to this point should be changeable */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index d122d0087191..140212bfe08b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2066,10 +2066,6 @@ static int fm10k_sw_init(struct fm10k_intfc *interface,
 	interface->tx_itr = FM10K_TX_ITR_DEFAULT;
 	interface->rx_itr = FM10K_ITR_ADAPTIVE | FM10K_RX_ITR_DEFAULT;
 
-	/* initialize udp port lists */
-	INIT_LIST_HEAD(&interface->vxlan_port);
-	INIT_LIST_HEAD(&interface->geneve_port);
-
 	/* Initialize the MAC/VLAN queue */
 	INIT_LIST_HEAD(&interface->macvlan_requests);
 
-- 
2.26.2

