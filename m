Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60447DD45
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346202AbhLWBQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:46 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18326 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345752AbhLWBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=6H7NNmKl33EBYWw0z5heLUHxIv7BPWBWa24waKEMcSk=;
        b=ZgFYtDQ61ycVQAPEPH21tNcHpdXveRej1XAmOcA6aSfK1k7Ak+y1+R/9kfG8VlIPBOfB
        yMRvKzFrYskPJjk+Rs0KvYgHlBDLEfoYPshYjiLO3WYYyMdtMVm6cn2fps76nqhjozn7f/
        PTx6/BiJWgyUYqUuGL6B4RF748OCKvssMK2xflrSxFGVuwbQa4+pR6ejqUVWKzA80D80AR
        uQGHzQNABfgSWhnAlPZ9dzQ2BZjuh+8duYsjdVGCSVCM3uXEJOatHXPbnB+Q6pcfKmh9EQ
        lmJBLwHFqu1u0PQhgqf41YGwjjrYzQcWh0nd6Q4yKTO8elDKm5sNGLLM9FobMljg==
Received: by filterdrecv-656998cfdd-phncc with SMTP id filterdrecv-656998cfdd-phncc-1-61C3CD5E-34
        2021-12-23 01:14:06.590646115 +0000 UTC m=+7955207.776892892
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-1 (SG)
        with ESMTP
        id g8xYSwNRSQ2WqdDpKBNqeA
        Thu, 23 Dec 2021 01:14:06.434 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 21BB97011EE; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 15/50] wilc1000: add struct wilc_skb_tx_cb as an alias of
 struct txq_entry_t
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-16-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJVai0WXMG1+HQN6o?=
 =?us-ascii?Q?v2CuUX1YfqzWiuT0Ki8nekpKI3Qgbj3UWNGvbRS?=
 =?us-ascii?Q?OCBP2hth34cttp0FYFVAL1+SeTew=2F1H9ZIzvc7T?=
 =?us-ascii?Q?snQgqaHgx6ncvL7o8ummAAFD2m0ykXXoQgQ5gDm?=
 =?us-ascii?Q?GqpSG1BGGttLAs=2FtLIBBHuhCrJXEHH94Y8ym4P?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation of the next patch, which removes struct
wilc_skb_tx_cb in favor of struct sk_buffs.  That change requires
moving the driver-private state for tx packets from struct txq_entry_t
to the "control buffer" (cb field) of struct sk_buff.  Making that
move now makes the next patch a bit smaller and easier to understand.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 36 +++++++++++--------
 .../net/wireless/microchip/wilc1000/wlan.h    |  7 ++++
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 7106e6be719c1..c352e939f1901 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -67,10 +67,12 @@ wilc_wlan_txq_remove_from_head(struct wilc *wilc, u8 q_num)
 static void init_txq_entry(struct txq_entry_t *tqe, struct wilc_vif *vif,
 			   u8 type, enum ip_pkt_priority q_num)
 {
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
+
 	tqe->vif = vif;
-	tqe->q_num = q_num;
-	tqe->type = type;
-	tqe->ack_idx = NOT_TCP_ACK;
+	tx_cb->type = type;
+	tx_cb->q_num = q_num;
+	tx_cb->ack_idx = NOT_TCP_ACK;
 }
 
 static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
@@ -143,6 +145,7 @@ static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 				       u32 session_index,
 				       struct txq_entry_t *txqe)
 {
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(txqe);
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = f->pending_base + f->pending_acks_idx;
 
@@ -150,7 +153,7 @@ static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 		f->pending_acks[i].ack_num = ack;
 		f->pending_acks[i].txqe = txqe;
 		f->pending_acks[i].session_index = session_index;
-		txqe->ack_idx = i;
+		tx_cb->ack_idx = i;
 		f->pending_acks_idx++;
 	}
 }
@@ -210,7 +213,8 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
 {
 	struct wilc_vif *vif = tqe->vif;
-	int ack_idx = tqe->ack_idx;
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
+	int ack_idx = tx_cb->ack_idx;
 
 	tqe->status = status;
 	if (tqe->tx_complete_func)
@@ -224,10 +228,11 @@ static void wilc_wlan_txq_drop_net_pkt(struct txq_entry_t *tqe)
 {
 	struct wilc_vif *vif = tqe->vif;
 	struct wilc *wilc = vif->wilc;
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 
 	vif->ndev->stats.tx_dropped++;
 
-	wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
+	wilc_wlan_txq_remove(wilc, tx_cb->q_num, tqe);
 	wilc_wlan_tx_packet_done(tqe, 1);
 }
 
@@ -728,6 +733,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	bool max_size_over = 0, ac_exist = 0;
 	int vmm_sz = 0;
 	struct txq_entry_t *tqe_q[NQUEUES];
+	struct wilc_skb_tx_cb *tx_cb;
 	int ret = 0;
 	int counter;
 	int timeout;
@@ -772,9 +778,10 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 					break;
 				}
 
-				if (tqe_q[ac]->type == WILC_CFG_PKT)
+				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
+				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
-				else if (tqe_q[ac]->type == WILC_NET_PKT)
+				else if (tx_cb->type == WILC_NET_PKT)
 					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 				else
 					vmm_sz = HOST_HDR_OFFSET;
@@ -787,7 +794,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 					break;
 				}
 				vmm_table[i] = vmm_sz / 4;
-				if (tqe_q[ac]->type == WILC_CFG_PKT)
+				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_table[i] |= BIT(10);
 
 				cpu_to_le32s(&vmm_table[i]);
@@ -898,6 +905,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
 		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		vif = tqe->vif;
+		tx_cb = WILC_SKB_TX_CB(tqe);
 		if (vmm_table[i] == 0)
 			break;
 
@@ -905,20 +913,20 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		vmm_sz = FIELD_GET(WILC_VMM_BUFFER_SIZE, vmm_table[i]);
 		vmm_sz *= 4;
 
-		if (tqe->type == WILC_MGMT_PKT)
+		if (tx_cb->type == WILC_MGMT_PKT)
 			mgmt_ptk = 1;
 
-		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tqe->type) |
+		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
 			  FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, mgmt_ptk) |
 			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->buffer_size) |
 			  FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
 
 		cpu_to_le32s(&header);
 		memcpy(&txb[offset], &header, 4);
-		if (tqe->type == WILC_CFG_PKT) {
+		if (tx_cb->type == WILC_CFG_PKT) {
 			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-		} else if (tqe->type == WILC_NET_PKT) {
-			int prio = tqe->q_num;
+		} else if (tx_cb->type == WILC_NET_PKT) {
+			int prio = tx_cb->q_num;
 
 			bssid = tqe->vif->bssid;
 			buffer_offset = ETH_ETHERNET_HDR_OFFSET;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 9b33262909e2f..295795a8060ac 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -333,6 +333,13 @@ struct txq_entry_t {
 	void (*tx_complete_func)(void *priv, int status);
 };
 
+#define wilc_skb_tx_cb	txq_entry_t
+
+static inline struct wilc_skb_tx_cb *WILC_SKB_TX_CB(struct txq_entry_t *tqe)
+{
+	return (struct wilc_skb_tx_cb *)tqe;
+}
+
 struct txq_fw_recv_queue_stat {
 	u8 acm;
 	u8 count;
-- 
2.25.1

