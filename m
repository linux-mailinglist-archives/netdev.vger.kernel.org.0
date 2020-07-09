Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74941219590
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgGIBS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgGIBSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:50 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420DE2082E;
        Thu,  9 Jul 2020 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257529;
        bh=KUi9NCu0IpnnuSlHn3ffjRU7JG8ylU1NimfnJhNI7sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+ePJWtx9Jpe/6Mo78ajsWrLDLAggb4YKT+VDKLrm4xd2aLF05mQjAhG/Y3lzL5Bc
         Jx0wMArhWtT8b8F923/4UvTt4AQEtbOhTibbK45ub0eam5F50O16PT+RvIMaVowdzf
         Tj+w+ogbq9FFN+8wzHmEL/8lkOFc+eLdijAxwqd8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/10] ixgbe: convert to new udp_tunnel_nic infra
Date:   Wed,  8 Jul 2020 18:18:12 -0700
Message-Id: <20200709011814.4003186-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of new common udp_tunnel_nic infra. ixgbe supports
IPv4 only, and only single VxLAN and Geneve ports (one each).

v2:
 - split out the RXCSUM feature handling to separate change;
 - declare structs separately;
 - use ti.type instead of assuming table 0 is VxLAN;
 - move setting netdev->udp_tunnel_nic_info to its own switch.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 180 +++++-------------
 2 files changed, 44 insertions(+), 139 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index debbcf216134..1e8a809233a0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -588,11 +588,9 @@ struct ixgbe_adapter {
 #define IXGBE_FLAG_FCOE_ENABLED			BIT(21)
 #define IXGBE_FLAG_SRIOV_CAPABLE		BIT(22)
 #define IXGBE_FLAG_SRIOV_ENABLED		BIT(23)
-#define IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE	BIT(24)
 #define IXGBE_FLAG_RX_HWTSTAMP_ENABLED		BIT(25)
 #define IXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER	BIT(26)
 #define IXGBE_FLAG_DCB_CAPABLE			BIT(27)
-#define IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE	BIT(28)
 
 	u32 flags2;
 #define IXGBE_FLAG2_RSC_CAPABLE			BIT(0)
@@ -606,7 +604,6 @@ struct ixgbe_adapter {
 #define IXGBE_FLAG2_RSS_FIELD_IPV6_UDP		BIT(9)
 #define IXGBE_FLAG2_PTP_PPS_ENABLED		BIT(10)
 #define IXGBE_FLAG2_PHY_INTERRUPT		BIT(11)
-#define IXGBE_FLAG2_UDP_TUN_REREG_NEEDED	BIT(12)
 #define IXGBE_FLAG2_VLAN_PROMISC		BIT(13)
 #define IXGBE_FLAG2_EEE_CAPABLE			BIT(14)
 #define IXGBE_FLAG2_EEE_ENABLED			BIT(15)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index acdf525272a3..4d898ff21a46 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4994,24 +4994,41 @@ static void ixgbe_napi_disable_all(struct ixgbe_adapter *adapter)
 		napi_disable(&adapter->q_vector[q_idx]->napi);
 }
 
-static void ixgbe_clear_udp_tunnel_port(struct ixgbe_adapter *adapter, u32 mask)
+static int ixgbe_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct ixgbe_hw *hw = &adapter->hw;
-	u32 vxlanctrl;
+	struct udp_tunnel_info ti;
 
-	if (!(adapter->flags & (IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE |
-				IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)))
-		return;
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
+		adapter->vxlan_port = ti.port;
+	else
+		adapter->geneve_port = ti.port;
 
-	vxlanctrl = IXGBE_READ_REG(hw, IXGBE_VXLANCTRL) & ~mask;
-	IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL, vxlanctrl);
+	IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL,
+			ntohs(adapter->vxlan_port) |
+			ntohs(adapter->geneve_port) <<
+				IXGBE_VXLANCTRL_GENEVE_UDPPORT_SHIFT);
+	return 0;
+}
 
-	if (mask & IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK)
-		adapter->vxlan_port = 0;
+static const struct udp_tunnel_nic_info ixgbe_udp_tunnels_x550 = {
+	.sync_table	= ixgbe_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+	},
+};
 
-	if (mask & IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK)
-		adapter->geneve_port = 0;
-}
+static const struct udp_tunnel_nic_info ixgbe_udp_tunnels_x550em_a = {
+	.sync_table	= ixgbe_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
 
 #ifdef CONFIG_IXGBE_DCB
 /**
@@ -6332,7 +6349,6 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 			adapter->flags2 |= IXGBE_FLAG2_TEMP_SENSOR_CAPABLE;
 		break;
 	case ixgbe_mac_x550em_a:
-		adapter->flags |= IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE;
 		switch (hw->device_id) {
 		case IXGBE_DEV_ID_X550EM_A_1G_T:
 		case IXGBE_DEV_ID_X550EM_A_1G_T_L:
@@ -6359,7 +6375,6 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 #ifdef CONFIG_IXGBE_DCA
 		adapter->flags &= ~IXGBE_FLAG_DCA_CAPABLE;
 #endif
-		adapter->flags |= IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
 		break;
 	default:
 		break;
@@ -6798,8 +6813,7 @@ int ixgbe_open(struct net_device *netdev)
 
 	ixgbe_up_complete(adapter);
 
-	ixgbe_clear_udp_tunnel_port(adapter, IXGBE_VXLANCTRL_ALL_UDPPORT_MASK);
-	udp_tunnel_get_rx_info(netdev);
+	udp_tunnel_nic_reset_ntf(netdev);
 
 	return 0;
 
@@ -7921,12 +7935,6 @@ static void ixgbe_service_task(struct work_struct *work)
 		ixgbe_service_event_complete(adapter);
 		return;
 	}
-	if (adapter->flags2 & IXGBE_FLAG2_UDP_TUN_REREG_NEEDED) {
-		rtnl_lock();
-		adapter->flags2 &= ~IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-		udp_tunnel_get_rx_info(adapter->netdev);
-		rtnl_unlock();
-	}
 	ixgbe_reset_subtask(adapter);
 	ixgbe_phy_interrupt_subtask(adapter);
 	ixgbe_sfp_detection_subtask(adapter);
@@ -9795,118 +9803,6 @@ static int ixgbe_set_features(struct net_device *netdev,
 	return 1;
 }
 
-/**
- * ixgbe_add_udp_tunnel_port - Get notifications about adding UDP tunnel ports
- * @dev: The port's netdev
- * @ti: Tunnel endpoint information
- **/
-static void ixgbe_add_udp_tunnel_port(struct net_device *dev,
-				      struct udp_tunnel_info *ti)
-{
-	struct ixgbe_adapter *adapter = netdev_priv(dev);
-	struct ixgbe_hw *hw = &adapter->hw;
-	__be16 port = ti->port;
-	u32 port_shift = 0;
-	u32 reg;
-
-	if (ti->sa_family != AF_INET)
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (!(adapter->flags & IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE))
-			return;
-
-		if (adapter->vxlan_port == port)
-			return;
-
-		if (adapter->vxlan_port) {
-			netdev_info(dev,
-				    "VXLAN port %d set, not adding port %d\n",
-				    ntohs(adapter->vxlan_port),
-				    ntohs(port));
-			return;
-		}
-
-		adapter->vxlan_port = port;
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!(adapter->flags & IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE))
-			return;
-
-		if (adapter->geneve_port == port)
-			return;
-
-		if (adapter->geneve_port) {
-			netdev_info(dev,
-				    "GENEVE port %d set, not adding port %d\n",
-				    ntohs(adapter->geneve_port),
-				    ntohs(port));
-			return;
-		}
-
-		port_shift = IXGBE_VXLANCTRL_GENEVE_UDPPORT_SHIFT;
-		adapter->geneve_port = port;
-		break;
-	default:
-		return;
-	}
-
-	reg = IXGBE_READ_REG(hw, IXGBE_VXLANCTRL) | ntohs(port) << port_shift;
-	IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL, reg);
-}
-
-/**
- * ixgbe_del_udp_tunnel_port - Get notifications about removing UDP tunnel ports
- * @dev: The port's netdev
- * @ti: Tunnel endpoint information
- **/
-static void ixgbe_del_udp_tunnel_port(struct net_device *dev,
-				      struct udp_tunnel_info *ti)
-{
-	struct ixgbe_adapter *adapter = netdev_priv(dev);
-	u32 port_mask;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN &&
-	    ti->type != UDP_TUNNEL_TYPE_GENEVE)
-		return;
-
-	if (ti->sa_family != AF_INET)
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (!(adapter->flags & IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE))
-			return;
-
-		if (adapter->vxlan_port != ti->port) {
-			netdev_info(dev, "VXLAN port %d not found\n",
-				    ntohs(ti->port));
-			return;
-		}
-
-		port_mask = IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK;
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!(adapter->flags & IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE))
-			return;
-
-		if (adapter->geneve_port != ti->port) {
-			netdev_info(dev, "GENEVE port %d not found\n",
-				    ntohs(ti->port));
-			return;
-		}
-
-		port_mask = IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK;
-		break;
-	default:
-		return;
-	}
-
-	ixgbe_clear_udp_tunnel_port(adapter, port_mask);
-	adapter->flags2 |= IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-}
-
 static int ixgbe_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			     struct net_device *dev,
 			     const unsigned char *addr, u16 vid,
@@ -10396,8 +10292,8 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_bridge_getlink	= ixgbe_ndo_bridge_getlink,
 	.ndo_dfwd_add_station	= ixgbe_fwd_add,
 	.ndo_dfwd_del_station	= ixgbe_fwd_del,
-	.ndo_udp_tunnel_add	= ixgbe_add_udp_tunnel_port,
-	.ndo_udp_tunnel_del	= ixgbe_del_udp_tunnel_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= ixgbe_features_check,
 	.ndo_bpf		= ixgbe_xdp,
 	.ndo_xdp_xmit		= ixgbe_xdp_xmit,
@@ -10842,6 +10738,18 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
+	switch (adapter->hw.mac.type) {
+	case ixgbe_mac_X550:
+	case ixgbe_mac_X550EM_x:
+		netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550;
+		break;
+	case ixgbe_mac_x550em_a:
+		netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550em_a;
+		break;
+	default:
+		break;
+	}
+
 	/* Make sure the SWFW semaphore is in a valid state */
 	if (hw->mac.ops.init_swfw_sync)
 		hw->mac.ops.init_swfw_sync(hw);
-- 
2.26.2

