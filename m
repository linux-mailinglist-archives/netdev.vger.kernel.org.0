Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE10A479E44
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhLRXyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:32 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25784 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbhLRXy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=wXJ8jyflf28hczVeoapfI+zLJtAIzw0kgB1Rd3nDo68=;
        b=OcMZkzSnIyZf0KSpnqQwypUXzWinuVHeNC7ddpKhOuTIW9fiwGKr7i7CUe+dttX1Y/Me
        H0Rvyk11XUQTJb0vmQlvif1nGeYHfUdfVcT1ME1Y96nAA5EhCVv9ti09caxzhwdnEgBlz/
        q0eywJcWnkZ6y9Vw5wmhM5AbISMwmm3cdu3hMr8Hhantxlvh4llDislyyJCt/1k0Pw8M5v
        03RuqSEAO/BvdrvO0v8Pa1ca9DsrOcYUybYfj5Z00+oug2Hz1UWobDBKR6tIzLTOmsAgLc
        2INLXU3TKYE6JovigKC/rQCwwO7BPpt1iGh2hxm1gK3wRZTfMHwSRUeshsEyop6Q==
Received: by filterdrecv-75ff7b5ffb-t2q6v with SMTP id filterdrecv-75ff7b5ffb-t2q6v-1-61BE74A9-5
        2021-12-18 23:54:17.337370383 +0000 UTC m=+9336822.611466926
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id 1rnIf73FSYCcOAi5N-JBDw
        Sat, 18 Dec 2021 23:54:17.118 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B58607013A0; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 15/23] wilc1000: Add struct wilc_skb_tx_cb as an alias of
 struct txq_entry_t
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-16-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKY38+15DLPpdGiaQ?=
 =?us-ascii?Q?qaVf5xb7LxNXaarsCTetHxyMvozt3vxaQkztXwb?=
 =?us-ascii?Q?TSM1nvDlpUbjxiuIr2AJslMA3TLSH5xt6kT5qOh?=
 =?us-ascii?Q?erQ22M9=2FYAWVOKFFTSaw=2FHpREFo6mclwS4MhWMt?=
 =?us-ascii?Q?7TV+rzx8ZUyXTqm+2FtwFqmhrCLQb8QY4N91Pv?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
index 8e8f0e1de7c4c..5aa7bcf82054f 100644
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

