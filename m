Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95E221FD25
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgGNTSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgGNTSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:18:44 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DACB22AB9;
        Tue, 14 Jul 2020 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594754324;
        bh=fpxPYzVVVKebMJ2YG/n0VNddLmyEwgDAeXVQUJ4kMk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrpgLT6UfFhRti0L4Vsc0qL67M5CAdhKZWqF3rbbIB2oKvi4ytfAu0rd1efmgTdwY
         DWsCw+kZlnBzwV0MCVAx1BoieSdT6NS2hJZ113sDK7zYpVLiakgDojUAnqZWKVyfBQ
         P6g/amBNYWU/Gg0lmyn/jqZH/O7/0qITe/C3kCoI=
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
Subject: [PATCH net-next v3 05/12] bnx2x: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 12:18:23 -0700
Message-Id: <20200714191830.694674-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714191830.694674-1-kuba@kernel.org>
References: <20200714191830.694674-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fairly straightforward conversion - no need to keep track
of the use count, and replay when ports get removed, also
callbacks can just sleep.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |   8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 136 ++++--------------
 3 files changed, 29 insertions(+), 123 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index dee61d96680e..d04994840b87 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1287,7 +1287,6 @@ enum sp_rtnl_flag {
 	BNX2X_SP_RTNL_HYPERVISOR_VLAN,
 	BNX2X_SP_RTNL_TX_STOP,
 	BNX2X_SP_RTNL_GET_DRV_VERSION,
-	BNX2X_SP_RTNL_CHANGE_UDP_PORT,
 	BNX2X_SP_RTNL_UPDATE_SVID,
 };
 
@@ -1343,11 +1342,6 @@ enum bnx2x_udp_port_type {
 	BNX2X_UDP_PORT_MAX,
 };
 
-struct bnx2x_udp_tunnel {
-	u16 dst_port;
-	u8 count;
-};
-
 struct bnx2x {
 	/* Fields used in the tx and intr/napi performance paths
 	 * are grouped together in the beginning of the structure
@@ -1855,7 +1849,7 @@ struct bnx2x {
 	bool accept_any_vlan;
 
 	/* Vxlan/Geneve related information */
-	struct bnx2x_udp_tunnel udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
+	u16 udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
 };
 
 /* Tx queues may be less or equal to Rx queues */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index a9817cd283fe..7e4c93be4451 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -960,12 +960,12 @@ static inline int bnx2x_func_start(struct bnx2x *bp)
 		start_params->network_cos_mode = STATIC_COS;
 	else /* CHIP_IS_E1X */
 		start_params->network_cos_mode = FW_WRR;
-	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN].count) {
-		port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN].dst_port;
+	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN]) {
+		port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN];
 		start_params->vxlan_dst_port = port;
 	}
-	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE].count) {
-		port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE].dst_port;
+	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE]) {
+		port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE];
 		start_params->geneve_dst_port = port;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index fd957212bc1b..7f24d2689fdd 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -10152,7 +10152,6 @@ static int bnx2x_udp_port_update(struct bnx2x *bp)
 {
 	struct bnx2x_func_switch_update_params *switch_update_params;
 	struct bnx2x_func_state_params func_params = {NULL};
-	struct bnx2x_udp_tunnel *udp_tunnel;
 	u16 vxlan_port = 0, geneve_port = 0;
 	int rc;
 
@@ -10169,15 +10168,13 @@ static int bnx2x_udp_port_update(struct bnx2x *bp)
 	__set_bit(BNX2X_F_UPDATE_TUNNEL_CFG_CHNG,
 		  &switch_update_params->changes);
 
-	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE].count) {
-		udp_tunnel = &bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE];
-		geneve_port = udp_tunnel->dst_port;
+	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE]) {
+		geneve_port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE];
 		switch_update_params->geneve_dst_port = geneve_port;
 	}
 
-	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN].count) {
-		udp_tunnel = &bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN];
-		vxlan_port = udp_tunnel->dst_port;
+	if (bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN]) {
+		vxlan_port = bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN];
 		switch_update_params->vxlan_dst_port = vxlan_port;
 	}
 
@@ -10197,94 +10194,27 @@ static int bnx2x_udp_port_update(struct bnx2x *bp)
 	return rc;
 }
 
-static void __bnx2x_add_udp_port(struct bnx2x *bp, u16 port,
-				 enum bnx2x_udp_port_type type)
-{
-	struct bnx2x_udp_tunnel *udp_port = &bp->udp_tunnel_ports[type];
-
-	if (!netif_running(bp->dev) || !IS_PF(bp) || CHIP_IS_E1x(bp))
-		return;
-
-	if (udp_port->count && udp_port->dst_port == port) {
-		udp_port->count++;
-		return;
-	}
-
-	if (udp_port->count) {
-		DP(BNX2X_MSG_SP,
-		   "UDP tunnel [%d] -  destination port limit reached\n",
-		   type);
-		return;
-	}
-
-	udp_port->dst_port = port;
-	udp_port->count = 1;
-	bnx2x_schedule_sp_rtnl(bp, BNX2X_SP_RTNL_CHANGE_UDP_PORT, 0);
-}
-
-static void __bnx2x_del_udp_port(struct bnx2x *bp, u16 port,
-				 enum bnx2x_udp_port_type type)
-{
-	struct bnx2x_udp_tunnel *udp_port = &bp->udp_tunnel_ports[type];
-
-	if (!IS_PF(bp) || CHIP_IS_E1x(bp))
-		return;
-
-	if (!udp_port->count || udp_port->dst_port != port) {
-		DP(BNX2X_MSG_SP, "Invalid UDP tunnel [%d] port\n",
-		   type);
-		return;
-	}
-
-	/* Remove reference, and make certain it's no longer in use */
-	udp_port->count--;
-	if (udp_port->count)
-		return;
-	udp_port->dst_port = 0;
-
-	if (netif_running(bp->dev))
-		bnx2x_schedule_sp_rtnl(bp, BNX2X_SP_RTNL_CHANGE_UDP_PORT, 0);
-	else
-		DP(BNX2X_MSG_SP, "Deleted UDP tunnel [%d] port %d\n",
-		   type, port);
-}
-
-static void bnx2x_udp_tunnel_add(struct net_device *netdev,
-				 struct udp_tunnel_info *ti)
+static int bnx2x_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 {
 	struct bnx2x *bp = netdev_priv(netdev);
-	u16 t_port = ntohs(ti->port);
+	struct udp_tunnel_info ti;
 
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		__bnx2x_add_udp_port(bp, t_port, BNX2X_UDP_PORT_VXLAN);
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		__bnx2x_add_udp_port(bp, t_port, BNX2X_UDP_PORT_GENEVE);
-		break;
-	default:
-		break;
-	}
-}
+	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
+	bp->udp_tunnel_ports[table] = be16_to_cpu(ti.port);
 
-static void bnx2x_udp_tunnel_del(struct net_device *netdev,
-				 struct udp_tunnel_info *ti)
-{
-	struct bnx2x *bp = netdev_priv(netdev);
-	u16 t_port = ntohs(ti->port);
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		__bnx2x_del_udp_port(bp, t_port, BNX2X_UDP_PORT_VXLAN);
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		__bnx2x_del_udp_port(bp, t_port, BNX2X_UDP_PORT_GENEVE);
-		break;
-	default:
-		break;
-	}
+	return bnx2x_udp_port_update(bp);
 }
 
+static const struct udp_tunnel_nic_info bnx2x_udp_tunnels = {
+	.sync_table	= bnx2x_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+			  UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
+
 static int bnx2x_close(struct net_device *dev);
 
 /* bnx2x_nic_unload() flushes the bnx2x_wq, thus reset task is
@@ -10407,24 +10337,6 @@ static void bnx2x_sp_rtnl_task(struct work_struct *work)
 	if (test_and_clear_bit(BNX2X_SP_RTNL_UPDATE_SVID, &bp->sp_rtnl_state))
 		bnx2x_handle_update_svid_cmd(bp);
 
-	if (test_and_clear_bit(BNX2X_SP_RTNL_CHANGE_UDP_PORT,
-			       &bp->sp_rtnl_state)) {
-		if (bnx2x_udp_port_update(bp)) {
-			/* On error, forget configuration */
-			memset(bp->udp_tunnel_ports, 0,
-			       sizeof(struct bnx2x_udp_tunnel) *
-			       BNX2X_UDP_PORT_MAX);
-		} else {
-			/* Since we don't store additional port information,
-			 * if no ports are configured for any feature ask for
-			 * information about currently configured ports.
-			 */
-			if (!bp->udp_tunnel_ports[BNX2X_UDP_PORT_VXLAN].count &&
-			    !bp->udp_tunnel_ports[BNX2X_UDP_PORT_GENEVE].count)
-				udp_tunnel_get_rx_info(bp->dev);
-		}
-	}
-
 	/* work which needs rtnl lock not-taken (as it takes the lock itself and
 	 * can be called from other contexts as well)
 	 */
@@ -12620,9 +12532,6 @@ static int bnx2x_open(struct net_device *dev)
 	if (rc)
 		return rc;
 
-	if (IS_PF(bp))
-		udp_tunnel_get_rx_info(dev);
-
 	return 0;
 }
 
@@ -13162,8 +13071,8 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_get_phys_port_id	= bnx2x_get_phys_port_id,
 	.ndo_set_vf_link_state	= bnx2x_set_vf_link_state,
 	.ndo_features_check	= bnx2x_features_check,
-	.ndo_udp_tunnel_add	= bnx2x_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= bnx2x_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 };
 
 static int bnx2x_set_coherency_mask(struct bnx2x *bp)
@@ -13358,6 +13267,9 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 
 		dev->gso_partial_features = NETIF_F_GSO_GRE_CSUM |
 					    NETIF_F_GSO_UDP_TUNNEL_CSUM;
+
+		if (IS_PF(bp))
+			dev->udp_tunnel_nic_info = &bnx2x_udp_tunnels;
 	}
 
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-- 
2.26.2

