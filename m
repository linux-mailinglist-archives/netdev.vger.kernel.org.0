Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531B4217A3E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgGGVY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbgGGVYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 17:24:49 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C634220775;
        Tue,  7 Jul 2020 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594157088;
        bh=cudzDCq6yWYARtxPMcu4Awr204hokikWctOb/xo9uqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMgBpwGAp/6YToAzfnhO3sQq8QZFm46e1ZBhxnpsmwWifQMBnp+laQY6HwdfqZEZw
         Qt3ImUBKRYC/k0+9bxZSwWRiAlUQDv9YgoP1MkrCkoUecjzU82nRAtFb+n/rQRhZ0W
         NF8U7XfddxoqYGxQF1FsOmXD2v3qkZN7cZxibLso=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/9] bnxt: convert to new udp_tunnel_nic infra
Date:   Tue,  7 Jul 2020 14:24:33 -0700
Message-Id: <20200707212434.3244001-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707212434.3244001-1-kuba@kernel.org>
References: <20200707212434.3244001-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to new infra, taking advantage of sleeping in callbacks.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 133 ++++++----------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   6 -
 2 files changed, 34 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a884df44612..b8c1bfeca572 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7470,16 +7470,15 @@ static int bnxt_hwrm_pcie_qstats(struct bnxt *bp)
 
 static void bnxt_hwrm_free_tunnel_ports(struct bnxt *bp)
 {
-	if (bp->vxlan_port_cnt) {
+	if (bp->vxlan_port)
 		bnxt_hwrm_tunnel_dst_port_free(
 			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN);
-	}
-	bp->vxlan_port_cnt = 0;
-	if (bp->nge_port_cnt) {
+	bp->vxlan_port = 0;
+
+	if (bp->nge_port)
 		bnxt_hwrm_tunnel_dst_port_free(
 			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE);
-	}
-	bp->nge_port_cnt = 0;
+	bp->nge_port = 0;
 }
 
 static int bnxt_set_tpa(struct bnxt *bp, bool set_tpa)
@@ -9194,7 +9193,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	}
 
 	if (irq_re_init)
-		udp_tunnel_get_rx_info(bp->dev);
+		udp_tunnel_nic_reset_ntf(bp->dev);
 
 	set_bit(BNXT_STATE_OPEN, &bp->state);
 	bnxt_enable_int(bp);
@@ -10353,24 +10352,6 @@ static void bnxt_sp_task(struct work_struct *work)
 		bnxt_cfg_ntp_filters(bp);
 	if (test_and_clear_bit(BNXT_HWRM_EXEC_FWD_REQ_SP_EVENT, &bp->sp_event))
 		bnxt_hwrm_exec_fwd_req(bp);
-	if (test_and_clear_bit(BNXT_VXLAN_ADD_PORT_SP_EVENT, &bp->sp_event)) {
-		bnxt_hwrm_tunnel_dst_port_alloc(
-			bp, bp->vxlan_port,
-			TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN);
-	}
-	if (test_and_clear_bit(BNXT_VXLAN_DEL_PORT_SP_EVENT, &bp->sp_event)) {
-		bnxt_hwrm_tunnel_dst_port_free(
-			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN);
-	}
-	if (test_and_clear_bit(BNXT_GENEVE_ADD_PORT_SP_EVENT, &bp->sp_event)) {
-		bnxt_hwrm_tunnel_dst_port_alloc(
-			bp, bp->nge_port,
-			TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE);
-	}
-	if (test_and_clear_bit(BNXT_GENEVE_DEL_PORT_SP_EVENT, &bp->sp_event)) {
-		bnxt_hwrm_tunnel_dst_port_free(
-			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE);
-	}
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp);
 		bnxt_hwrm_port_qstats_ext(bp);
@@ -11294,85 +11275,37 @@ static void bnxt_cfg_ntp_filters(struct bnxt *bp)
 
 #endif /* CONFIG_RFS_ACCEL */
 
-static void bnxt_udp_tunnel_add(struct net_device *dev,
-				struct udp_tunnel_info *ti)
+static int bnxt_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 {
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (ti->sa_family != AF_INET6 && ti->sa_family != AF_INET)
-		return;
-
-	if (!netif_running(dev))
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (bp->vxlan_port_cnt && bp->vxlan_port != ti->port)
-			return;
-
-		bp->vxlan_port_cnt++;
-		if (bp->vxlan_port_cnt == 1) {
-			bp->vxlan_port = ti->port;
-			set_bit(BNXT_VXLAN_ADD_PORT_SP_EVENT, &bp->sp_event);
-			bnxt_queue_sp_work(bp);
-		}
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (bp->nge_port_cnt && bp->nge_port != ti->port)
-			return;
+	struct bnxt *bp = netdev_priv(netdev);
+	struct udp_tunnel_info ti;
+	unsigned int cmd;
 
-		bp->nge_port_cnt++;
-		if (bp->nge_port_cnt == 1) {
-			bp->nge_port = ti->port;
-			set_bit(BNXT_GENEVE_ADD_PORT_SP_EVENT, &bp->sp_event);
-		}
-		break;
-	default:
-		return;
+	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
+	if (!table) {
+		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
+		bp->vxlan_port = ti.port;
+	} else {
+		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
+		bp->nge_port = ti.port;
 	}
 
-	bnxt_queue_sp_work(bp);
-}
-
-static void bnxt_udp_tunnel_del(struct net_device *dev,
-				struct udp_tunnel_info *ti)
-{
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (ti->sa_family != AF_INET6 && ti->sa_family != AF_INET)
-		return;
-
-	if (!netif_running(dev))
-		return;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (!bp->vxlan_port_cnt || bp->vxlan_port != ti->port)
-			return;
-		bp->vxlan_port_cnt--;
-
-		if (bp->vxlan_port_cnt != 0)
-			return;
-
-		set_bit(BNXT_VXLAN_DEL_PORT_SP_EVENT, &bp->sp_event);
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!bp->nge_port_cnt || bp->nge_port != ti->port)
-			return;
-		bp->nge_port_cnt--;
-
-		if (bp->nge_port_cnt != 0)
-			return;
-
-		set_bit(BNXT_GENEVE_DEL_PORT_SP_EVENT, &bp->sp_event);
-		break;
-	default:
-		return;
-	}
+	if (ti.port)
+		return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti.port, cmd);
 
-	bnxt_queue_sp_work(bp);
+	return bnxt_hwrm_tunnel_dst_port_free(bp, cmd);
 }
 
+static const struct udp_tunnel_nic_info bnxt_udp_tunnels = {
+	.sync_table	= bnxt_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+			  UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
+
 static int bnxt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 			       struct net_device *dev, u32 filter_mask,
 			       int nlflags)
@@ -11469,8 +11402,8 @@ static const struct net_device_ops bnxt_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= bnxt_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= bnxt_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= bnxt_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_bpf		= bnxt_xdp,
 	.ndo_xdp_xmit		= bnxt_xdp_xmit,
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
@@ -11958,6 +11891,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
 			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
 			NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_PARTIAL;
+	dev->udp_tunnel_nic_info = &bnxt_udp_tunnels;
+
 	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				    NETIF_F_GSO_GRE_CSUM;
 	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 78e2fd63ac3d..352a56a18916 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1752,10 +1752,8 @@ struct bnxt {
 #define BNXT_FW_MAJ(bp)		((bp)->fw_ver_code >> 48)
 
 	__be16			vxlan_port;
-	u8			vxlan_port_cnt;
 	__le16			vxlan_fw_dst_port_id;
 	__be16			nge_port;
-	u8			nge_port_cnt;
 	__le16			nge_fw_dst_port_id;
 	u8			port_partition_type;
 	u8			port_count;
@@ -1776,16 +1774,12 @@ struct bnxt {
 #define BNXT_RX_NTP_FLTR_SP_EVENT	1
 #define BNXT_LINK_CHNG_SP_EVENT		2
 #define BNXT_HWRM_EXEC_FWD_REQ_SP_EVENT	3
-#define BNXT_VXLAN_ADD_PORT_SP_EVENT	4
-#define BNXT_VXLAN_DEL_PORT_SP_EVENT	5
 #define BNXT_RESET_TASK_SP_EVENT	6
 #define BNXT_RST_RING_SP_EVENT		7
 #define BNXT_HWRM_PF_UNLOAD_SP_EVENT	8
 #define BNXT_PERIODIC_STATS_SP_EVENT	9
 #define BNXT_HWRM_PORT_MODULE_SP_EVENT	10
 #define BNXT_RESET_TASK_SILENT_SP_EVENT	11
-#define BNXT_GENEVE_ADD_PORT_SP_EVENT	12
-#define BNXT_GENEVE_DEL_PORT_SP_EVENT	13
 #define BNXT_LINK_SPEED_CHNG_SP_EVENT	14
 #define BNXT_FLOW_STATS_SP_EVENT	15
 #define BNXT_UPDATE_PHY_SP_EVENT	16
-- 
2.26.2

