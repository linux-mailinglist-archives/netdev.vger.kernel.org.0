Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1C9228709
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbgGURPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:15:42 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:20665 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730733AbgGURPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:15:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351701; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=h4XrQmS1jTUM0qC0Ip95PyLtIHFfuNdHLgMI5cV20Ck=; b=W+s2xD3rpu+4d9llFp0goDRLw7yzyMNQoRvW7SkKrLz5GgcWHyVf7RhDxMT/QDvLdcq2qEMS
 TWTwcpvP3v5SymD1cCCTAUWMKYEkJ+hvl4TEkkItvM5GJfsq3GK4HlfAVuUNowmHhJUn5Jkp
 ZsXi8nUGnyAAZVmQWwE7omqccEY=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-west-2.postgun.com with SMTP id
 5f17228b3dbcb593a96a8949 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:14:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CC58DC433CA; Tue, 21 Jul 2020 17:14:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2DBEC43395;
        Tue, 21 Jul 2020 17:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2DBEC43395
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 2/7] ath10k: Add support to process rx packet in thread
Date:   Tue, 21 Jul 2020 22:44:21 +0530
Message-Id: <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI instance gets scheduled on a CPU core on which
the IRQ was triggered. The processing of rx packets
can be CPU intensive and since NAPI cannot be moved
to a different CPU core, to get better performance,
its better to move the gist of rx packet processing
in a high priority thread.

Add the init/deinit part for a thread to process the
receive packets.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 33 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h | 23 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c | 41 ++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9104496..2b520a0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -668,6 +668,39 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
 	return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
 }
 
+int ath10k_core_thread_shutdown(struct ath10k *ar,
+				struct ath10k_thread *thread)
+{
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "shutting down %s\n", thread->name);
+	set_bit(ATH10K_THREAD_EVENT_SHUTDOWN, thread->event_flags);
+	wake_up_process(thread->task);
+	wait_for_completion(&thread->shutdown);
+	ath10k_info(ar, "thread %s exited\n", thread->name);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_thread_shutdown);
+
+int ath10k_core_thread_init(struct ath10k *ar,
+			    struct ath10k_thread *thread,
+			    int (*handler)(void *data),
+			    char *thread_name)
+{
+	thread->task = kthread_create(handler, thread, thread_name);
+	if (IS_ERR(thread->task))
+		return -EINVAL;
+
+	init_waitqueue_head(&thread->wait_q);
+	init_completion(&thread->shutdown);
+	memcpy(thread->name, thread_name, ATH10K_THREAD_NAME_SIZE_MAX);
+	clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN, thread->event_flags);
+	ath10k_info(ar, "Starting thread %s\n", thread_name);
+	wake_up_process(thread->task);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_thread_init);
+
 void ath10k_core_get_fw_features_str(struct ath10k *ar,
 				     char *buf,
 				     size_t buf_len)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5c18f6c..96919e8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -970,6 +970,22 @@ struct ath10k_bus_params {
 	bool hl_msdu_ids;
 };
 
+#define ATH10K_THREAD_NAME_SIZE_MAX	32
+
+enum ath10k_thread_events {
+	ATH10K_THREAD_EVENT_SHUTDOWN,
+	ATH10K_THREAD_EVENT_MAX,
+};
+
+struct ath10k_thread {
+	struct ath10k *ar;
+	struct task_struct *task;
+	struct completion shutdown;
+	wait_queue_head_t wait_q;
+	DECLARE_BITMAP(event_flags, ATH10K_THREAD_EVENT_MAX);
+	char name[ATH10K_THREAD_NAME_SIZE_MAX];
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -982,6 +998,7 @@ struct ath10k {
 	} msa;
 	u8 mac_addr[ETH_ALEN];
 
+	struct ath10k_thread rx_thread;
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
@@ -1276,6 +1293,12 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 
 extern unsigned long ath10k_coredump_mask;
 
+int ath10k_core_thread_shutdown(struct ath10k *ar,
+				struct ath10k_thread *thread);
+int ath10k_core_thread_init(struct ath10k *ar,
+			    struct ath10k_thread *thread,
+			    int (*handler)(void *data),
+			    char *thread_name);
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  enum ath10k_bus bus,
 				  enum ath10k_hw_rev hw_rev,
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 1ef5fdb..463c34e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -909,6 +909,31 @@ static void ath10k_snoc_buffer_cleanup(struct ath10k *ar)
 	}
 }
 
+int ath10k_snoc_rx_thread_loop(void *data)
+{
+	struct ath10k_thread *rx_thread = data;
+	struct ath10k *ar = rx_thread->ar;
+	bool shutdown = false;
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread started\n");
+	set_user_nice(current, -1);
+
+	while (!shutdown) {
+		wait_event_interruptible(
+			rx_thread->wait_q,
+			(test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
+				  rx_thread->event_flags)));
+		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
+				       rx_thread->event_flags))
+			shutdown = true;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread exiting\n");
+	complete(&rx_thread->shutdown);
+
+	do_exit(0);
+}
+
 static void ath10k_snoc_hif_stop(struct ath10k *ar)
 {
 	if (!test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
@@ -916,6 +941,7 @@ static void ath10k_snoc_hif_stop(struct ath10k *ar)
 
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
+	ath10k_core_thread_shutdown(ar, &ar->rx_thread);
 	ath10k_snoc_buffer_cleanup(ar);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 }
@@ -923,9 +949,19 @@ static void ath10k_snoc_hif_stop(struct ath10k *ar)
 static int ath10k_snoc_hif_start(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int ret;
 
 	bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
 	napi_enable(&ar->napi);
+
+	ret = ath10k_core_thread_init(ar, &ar->rx_thread,
+				      ath10k_snoc_rx_thread_loop,
+				      "ath10k_rx_thread");
+	if (ret) {
+		ath10k_err(ar, "failed to start rx thread\n");
+		goto rx_thread_fail;
+	}
+
 	ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
@@ -934,6 +970,10 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	return 0;
+
+rx_thread_fail:
+	napi_disable(&ar->napi);
+	return ret;
 }
 
 static int ath10k_snoc_init_pipes(struct ath10k *ar)
@@ -1652,6 +1692,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	ar->rx_thread.ar = ar;
 	ar_snoc = ath10k_snoc_priv(ar);
 	ar_snoc->dev = pdev;
 	platform_set_drvdata(pdev, ar);
-- 
2.7.4

