Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D971DB2
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391090AbfGWR2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:28:47 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39376 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732740AbfGWR2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:28:46 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 536412000AF;
        Tue, 23 Jul 2019 19:28:44 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 45CDD200088;
        Tue, 23 Jul 2019 19:28:44 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 049A3205DD;
        Tue, 23 Jul 2019 19:28:43 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, vladimir.oltean@nxp.com
Subject: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for TCP frames
Date:   Tue, 23 Jul 2019 20:28:43 +0300
Message-Id: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using Rx skb bulking for all frames may negatively impact the
performance in some TCP termination scenarios, as it effectively
bypasses GRO.

Look at the hardware parse results of each ingress frame to see
if a TCP header is present or not; for TCP frames fall back to
the old implementation.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 15 ++++++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 51 ++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0acb115..412f87f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -348,6 +348,16 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	return xdp_act;
 }
 
+static bool frame_is_tcp(const struct dpaa2_fd *fd, struct dpaa2_fas *fas)
+{
+	struct dpaa2_fapr *fapr = dpaa2_get_fapr(fas, false);
+
+	if (!(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FAPRV))
+		return false;
+
+	return !!(fapr->faf_hi & DPAA2_FAF_HI_TCP_PRESENT);
+}
+
 /* Main Rx frame processing routine */
 static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			 struct dpaa2_eth_channel *ch,
@@ -435,7 +445,10 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	percpu_stats->rx_packets++;
 	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
 
-	list_add_tail(&skb->list, ch->rx_list);
+	if (frame_is_tcp(fd, fas))
+		napi_gro_receive(&ch->napi, skb);
+	else
+		list_add_tail(&skb->list, ch->rx_list);
 
 	return;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9af18c2..d723ae7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -155,6 +155,49 @@ struct dpaa2_fas {
  */
 #define DPAA2_TS_OFFSET			0x8
 
+/* Frame annotation parse results */
+struct dpaa2_fapr {
+	/* 64-bit word 1 */
+	__le32 faf_lo;
+	__le16 faf_ext;
+	__le16 nxt_hdr;
+	/* 64-bit word 2 */
+	__le64 faf_hi;
+	/* 64-bit word 3 */
+	u8 last_ethertype_offset;
+	u8 vlan_tci_offset_n;
+	u8 vlan_tci_offset_1;
+	u8 llc_snap_offset;
+	u8 eth_offset;
+	u8 ip1_pid_offset;
+	u8 shim_offset_2;
+	u8 shim_offset_1;
+	/* 64-bit word 4 */
+	u8 l5_offset;
+	u8 l4_offset;
+	u8 gre_offset;
+	u8 l3_offset_n;
+	u8 l3_offset_1;
+	u8 mpls_offset_n;
+	u8 mpls_offset_1;
+	u8 pppoe_offset;
+	/* 64-bit word 5 */
+	__le16 running_sum;
+	__le16 gross_running_sum;
+	u8 ipv6_frag_offset;
+	u8 nxt_hdr_offset;
+	u8 routing_hdr_offset_2;
+	u8 routing_hdr_offset_1;
+	/* 64-bit word 6 */
+	u8 reserved[5]; /* Soft-parsing context */
+	u8 ip_proto_offset_n;
+	u8 nxt_hdr_frag_offset;
+	u8 parse_error_code;
+};
+
+#define DPAA2_FAPR_OFFSET		0x10
+#define DPAA2_FAPR_SIZE			sizeof((struct dpaa2_fapr))
+
 /* Frame annotation egress action descriptor */
 #define DPAA2_FAEAD_OFFSET		0x58
 
@@ -185,6 +228,11 @@ static inline __le64 *dpaa2_get_ts(void *buf_addr, bool swa)
 	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_TS_OFFSET;
 }
 
+static inline struct dpaa2_fapr *dpaa2_get_fapr(void *buf_addr, bool swa)
+{
+	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_FAPR_OFFSET;
+}
+
 static inline struct dpaa2_faead *dpaa2_get_faead(void *buf_addr, bool swa)
 {
 	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_FAEAD_OFFSET;
@@ -236,6 +284,9 @@ static inline struct dpaa2_faead *dpaa2_get_faead(void *buf_addr, bool swa)
 					 DPAA2_FAS_L3CE		| \
 					 DPAA2_FAS_L4CE)
 
+/* TCP indication in Frame Annotation Parse Results */
+#define DPAA2_FAF_HI_TCP_PRESENT	BIT(23)
+
 /* Time in milliseconds between link state updates */
 #define DPAA2_ETH_LINK_STATE_REFRESH	1000
 
-- 
2.7.4

