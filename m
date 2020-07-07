Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF08217A3B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGGVYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgGGVYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 17:24:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 401FA20773;
        Tue,  7 Jul 2020 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594157087;
        bh=kDDMBB2f9oxv/Wr43KFwekMBBUl44Cs6Vp+0PJBwO8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVao9QpPMgchNPIjqbCoc9/AvcdoqYaje5fUmMZWPeUob4B0IIRY9l4xORy2eWcFp
         MiXshMWrJIWSG7mAh4hSn7U4rLk/tBWO93mH/nq1vlZfsJYDkbDwNuEL0iS7+k4S1P
         5T7fnLm3yKh9n9KQuFrJfNXekUqXI620GTSLq9Vk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 7/9] ixgbe: convert to new udp_tunnel_nic infra
Date:   Tue,  7 Jul 2020 14:24:32 -0700
Message-Id: <20200707212434.3244001-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707212434.3244001-1-kuba@kernel.org>
References: <20200707212434.3244001-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of new common udp_tunnel_nic infra. ixgbe supports
IPv4 only, and only single VxLAN and Geneve ports (one each).

I'm dropping the confusing piece of code in ixgbe_set_features().
ndo_udp_tunnel_add and ndo_udp_tunnel_del did not check if RXCSUM
is enabled, so this code was either unnecessary or buggy anyway.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 195 ++++--------------
 2 files changed, 37 insertions(+), 161 deletions(-)

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
index f5d3d6230786..29f1313b5ab0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4994,25 +4994,40 @@ static void ixgbe_napi_disable_all(struct ixgbe_adapter *adapter)
 		napi_disable(&adapter->q_vector[q_idx]->napi);
 }
 
-static void ixgbe_clear_udp_tunnel_port(struct ixgbe_adapter *adapter, u32 mask)
+static int ixgbe_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct ixgbe_hw *hw = &adapter->hw;
-	u32 vxlanctrl;
-
-	if (!(adapter->flags & (IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE |
-				IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)))
-		return;
+	struct udp_tunnel_info ti;
 
-	vxlanctrl = IXGBE_READ_REG(hw, IXGBE_VXLANCTRL) & ~mask;
-	IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL, vxlanctrl);
-
-	if (mask & IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK)
-		adapter->vxlan_port = 0;
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	if (!table)
+		adapter->vxlan_port = ti.port;
+	else
+		adapter->geneve_port = ti.port;
 
-	if (mask & IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK)
-		adapter->geneve_port = 0;
+	IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL,
+			ntohs(adapter->vxlan_port) |
+			ntohs(adapter->geneve_port) <<
+				IXGBE_VXLANCTRL_GENEVE_UDPPORT_SHIFT);
+	return 0;
 }
 
+static const struct udp_tunnel_nic_info ixgbe_udp_tunnels_x550 = {
+	.sync_table	= ixgbe_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+	},
+}, ixgbe_udp_tunnels_x550em_a = {
+	.sync_table	= ixgbe_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
+
 #ifdef CONFIG_IXGBE_DCB
 /**
  * ixgbe_configure_dcb - Configure DCB hardware
@@ -6227,6 +6242,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
 /**
  * ixgbe_sw_init - Initialize general software structures (struct ixgbe_adapter)
  * @adapter: board private structure to initialize
+ * @netdev: network interface device structure
  * @ii: pointer to ixgbe_info for device
  *
  * ixgbe_sw_init initializes the Adapter private data structure.
@@ -6234,6 +6250,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
  * OS network device settings (MTU size).
  **/
 static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
+			 struct net_device *netdev,
 			 const struct ixgbe_info *ii)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
@@ -6332,7 +6349,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 			adapter->flags2 |= IXGBE_FLAG2_TEMP_SENSOR_CAPABLE;
 		break;
 	case ixgbe_mac_x550em_a:
-		adapter->flags |= IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE;
+		netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550em_a;
 		switch (hw->device_id) {
 		case IXGBE_DEV_ID_X550EM_A_1G_T:
 		case IXGBE_DEV_ID_X550EM_A_1G_T_L:
@@ -6359,7 +6376,8 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 #ifdef CONFIG_IXGBE_DCA
 		adapter->flags &= ~IXGBE_FLAG_DCA_CAPABLE;
 #endif
-		adapter->flags |= IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
+		if (!netdev->udp_tunnel_nic_info)
+			netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550;
 		break;
 	default:
 		break;
@@ -6798,8 +6816,7 @@ int ixgbe_open(struct net_device *netdev)
 
 	ixgbe_up_complete(adapter);
 
-	ixgbe_clear_udp_tunnel_port(adapter, IXGBE_VXLANCTRL_ALL_UDPPORT_MASK);
-	udp_tunnel_get_rx_info(netdev);
+	udp_tunnel_nic_reset_ntf(netdev);
 
 	return 0;
 
@@ -7921,12 +7938,6 @@ static void ixgbe_service_task(struct work_struct *work)
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
@@ -9784,26 +9795,6 @@ static int ixgbe_set_features(struct net_device *netdev,
 
 	netdev->features = features;
 
-	if ((adapter->flags & IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE)) {
-		if (features & NETIF_F_RXCSUM) {
-			adapter->flags2 |= IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-		} else {
-			u32 port_mask = IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK;
-
-			ixgbe_clear_udp_tunnel_port(adapter, port_mask);
-		}
-	}
-
-	if ((adapter->flags & IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)) {
-		if (features & NETIF_F_RXCSUM) {
-			adapter->flags2 |= IXGBE_FLAG2_UDP_TUN_REREG_NEEDED;
-		} else {
-			u32 port_mask = IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK;
-
-			ixgbe_clear_udp_tunnel_port(adapter, port_mask);
-		}
-	}
-
 	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
 		ixgbe_reset_l2fw_offload(adapter);
 	else if (need_reset)
@@ -9815,118 +9806,6 @@ static int ixgbe_set_features(struct net_device *netdev,
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
@@ -10416,8 +10295,8 @@ static const struct net_device_ops ixgbe_netdev_ops = {
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
@@ -10858,7 +10737,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->phy.mdio.mdio_write = ixgbe_mdio_write;
 
 	/* setup the private structure */
-	err = ixgbe_sw_init(adapter, ii);
+	err = ixgbe_sw_init(adapter, netdev, ii);
 	if (err)
 		goto err_sw_init;
 
-- 
2.26.2

