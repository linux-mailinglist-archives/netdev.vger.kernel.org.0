Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C332286FE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgGURPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:15:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31410 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbgGURPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:15:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351704; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=z+QV2LXb5rbvImIDmNfj9kPQzvqQTO89wCls0vl+oAI=; b=qwi1HOvkz1frPb1kkchVktCZRkkU0dtRK0/Rxh/WAa9tRwuIVkA2tpY7s4cVWa8bq7p1ClsS
 LbhNBpfHd8R+mrrvJH7Lb5MhUg8Uib8ZCShrihzQVYBGlGwFRdT6wsuspx8IPnrRFwdXug77
 44swAm6OxSbKge8mkSsNMA6AIAU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f172297eef925b694dc15da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:15:03
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3AF6DC43395; Tue, 21 Jul 2020 17:15:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB288C4339C;
        Tue, 21 Jul 2020 17:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB288C4339C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 5/7] ath10k: Handle the rx packet processing in thread
Date:   Tue, 21 Jul 2020 22:44:24 +0530
Message-Id: <1595351666-28193-6-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support to handle the receive packet and
the tx completion processing in a thread context
if the feature has been enabled via module parameter.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c   |  8 ++++++
 drivers/net/wireless/ath/ath10k/core.h   |  4 +++
 drivers/net/wireless/ath/ath10k/htt.h    |  2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 46 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/snoc.c   | 12 +++++++--
 5 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2b520a0..4064fa2 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -668,6 +668,14 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
 	return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
 }
 
+void ath10k_core_thread_post_event(struct ath10k_thread *thread,
+				   enum ath10k_thread_events event)
+{
+	set_bit(event, thread->event_flags);
+	wake_up(&thread->wait_q);
+}
+EXPORT_SYMBOL(ath10k_core_thread_post_event);
+
 int ath10k_core_thread_shutdown(struct ath10k *ar,
 				struct ath10k_thread *thread)
 {
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 59bdf11..596d31b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -974,6 +974,8 @@ struct ath10k_bus_params {
 
 enum ath10k_thread_events {
 	ATH10K_THREAD_EVENT_SHUTDOWN,
+	ATH10K_THREAD_EVENT_RX_POST,
+	ATH10K_THREAD_EVENT_TX_POST,
 	ATH10K_THREAD_EVENT_MAX,
 };
 
@@ -1294,6 +1296,8 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 
 extern unsigned long ath10k_coredump_mask;
 
+void ath10k_core_thread_post_event(struct ath10k_thread *thread,
+				   enum ath10k_thread_events event);
 int ath10k_core_thread_shutdown(struct ath10k *ar,
 				struct ath10k_thread *thread);
 int ath10k_core_thread_init(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index cad5949..e3cb723 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1970,6 +1970,8 @@ struct ath10k_htt {
 		spinlock_t lock;
 	} rx_ring;
 
+	/* Protects access to in order indication queue */
+	spinlock_t rx_in_ord_q_lock;
 	unsigned int prefetch_len;
 
 	/* Protects access to pending_tx, num_pending_tx */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a4a6618..becbd56 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -796,6 +796,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	timer_setup(timer, ath10k_htt_rx_ring_refill_retry, 0);
 
 	spin_lock_init(&htt->rx_ring.lock);
+	spin_lock_init(&htt->rx_in_ord_q_lock);
 
 	htt->rx_ring.fill_cnt = 0;
 	htt->rx_ring.sw_rd_idx.msdu_payld = 0;
@@ -2702,10 +2703,17 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		 */
 		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
 			ath10k_txrx_tx_unref(htt, &tx_done);
-		} else if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
-			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
-				    tx_done.msdu_id, tx_done.status);
-			ath10k_txrx_tx_unref(htt, &tx_done);
+		} else {
+			if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+				ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
+					    tx_done.msdu_id, tx_done.status);
+				ath10k_txrx_tx_unref(htt, &tx_done);
+				continue;
+			}
+			if (ar->rx_thread_enable)
+				ath10k_core_thread_post_event(
+					&ar->rx_thread,
+					ATH10K_THREAD_EVENT_TX_POST);
 		}
 	}
 
@@ -3903,7 +3911,16 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND: {
-		skb_queue_tail(&htt->rx_in_ord_compl_q, skb);
+		if (!ar->rx_thread_enable) {
+			skb_queue_tail(&htt->rx_in_ord_compl_q, skb);
+		} else {
+			spin_lock_bh(&htt->rx_in_ord_q_lock);
+			skb_queue_tail(&htt->rx_in_ord_compl_q, skb);
+			spin_unlock_bh(&htt->rx_in_ord_q_lock);
+			ath10k_core_thread_post_event(
+				&ar->rx_thread,
+				ATH10K_THREAD_EVENT_RX_POST);
+		}
 		return false;
 	}
 	case HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND: {
@@ -4032,6 +4049,23 @@ int ath10k_htt_rx_hl_indication(struct ath10k *ar, int budget)
 }
 EXPORT_SYMBOL(ath10k_htt_rx_hl_indication);
 
+static inline struct sk_buff *
+ath10k_htt_dequeue_in_ord_q(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	struct sk_buff *skb = NULL;
+
+	if (ar->rx_thread_enable) {
+		spin_lock_bh(&htt->rx_in_ord_q_lock);
+		skb = skb_dequeue(&htt->rx_in_ord_compl_q);
+		spin_unlock_bh(&htt->rx_in_ord_q_lock);
+	} else {
+		skb = skb_dequeue(&htt->rx_in_ord_compl_q);
+	}
+
+	return skb;
+}
+
 int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -4053,7 +4087,7 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 		goto exit;
 	}
 
-	while ((skb = skb_dequeue(&htt->rx_in_ord_compl_q))) {
+	while ((skb = ath10k_htt_dequeue_in_ord_q(htt))) {
 		spin_lock_bh(&htt->rx_ring.lock);
 		ret = ath10k_htt_rx_in_ord_ind(ar, skb);
 		spin_unlock_bh(&htt->rx_ring.lock);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index f01725b..3eb5eac 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -920,6 +920,7 @@ int ath10k_snoc_rx_thread_loop(void *data)
 	struct ath10k_thread *rx_thread = data;
 	struct ath10k *ar = rx_thread->ar;
 	bool shutdown = false;
+	u32 thread_budget = 8192;
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread started\n");
 	set_user_nice(current, -1);
@@ -927,8 +928,14 @@ int ath10k_snoc_rx_thread_loop(void *data)
 	while (!shutdown) {
 		wait_event_interruptible(
 			rx_thread->wait_q,
-			(test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
+			(test_and_clear_bit(ATH10K_THREAD_EVENT_RX_POST,
+					    rx_thread->event_flags) ||
+			 test_and_clear_bit(ATH10K_THREAD_EVENT_TX_POST,
+					    rx_thread->event_flags) ||
+			 test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
 				  rx_thread->event_flags)));
+
+		ath10k_htt_txrx_compl_task(ar, thread_budget);
 		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
 				       rx_thread->event_flags))
 			shutdown = true;
@@ -1235,7 +1242,8 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 			ath10k_ce_enable_interrupt(ar, ce_id);
 		}
 
-	done = ath10k_htt_txrx_compl_task(ar, budget);
+	if (!ar->rx_thread_enable)
+		done = ath10k_htt_txrx_compl_task(ar, budget);
 
 	if (done < budget)
 		napi_complete(ctx);
-- 
2.7.4

