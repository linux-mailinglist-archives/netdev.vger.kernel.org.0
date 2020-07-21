Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFE228704
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgGURPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:15:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57306 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbgGURPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:15:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351714; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=gBDtbC3k7fmgMEBji3WDa1vS2HhVYXF0ZlougiQfyKI=; b=ncAxvilVkU9gUrDXyUsEx9xJXAssKsCSR60F36DDSPER9uA4PMKWz0Qs7zi/EIqCS9YlCWYK
 tysCJVK18psXhLJQzHv2jfnJnlmEC9GVTecwfixd/lgpWt+57wQfPxPse9UD5fD6Bc3AsTJZ
 cH0HU+htpfBs/qWq1CS9CQMs7I8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5f1722a1f9ca681bd08d9cc3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:15:13
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8CB73C433B2; Tue, 21 Jul 2020 17:15:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D497C433A1;
        Tue, 21 Jul 2020 17:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D497C433A1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 7/7] ath10k: Handle rx thread suspend and resume
Date:   Tue, 21 Jul 2020 22:44:26 +0530
Message-Id: <1595351666-28193-8-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the system suspend or resume, the rx thread
also needs to be suspended or resume respectively.

Handle the rx thread as well during the system
suspend and resume.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 23 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  5 ++++
 drivers/net/wireless/ath/ath10k/snoc.c | 44 +++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4064fa2..b82b355 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -668,6 +668,27 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
 	return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
 }
 
+int ath10k_core_thread_suspend(struct ath10k_thread *thread)
+{
+	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Suspending thread %s\n",
+		   thread->name);
+	set_bit(ATH10K_THREAD_EVENT_SUSPEND, thread->event_flags);
+	wait_for_completion(&thread->suspend);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_thread_suspend);
+
+int ath10k_core_thread_resume(struct ath10k_thread *thread)
+{
+	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Resuming thread %s\n",
+		   thread->name);
+	complete(&thread->resume);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_thread_resume);
+
 void ath10k_core_thread_post_event(struct ath10k_thread *thread,
 				   enum ath10k_thread_events event)
 {
@@ -700,6 +721,8 @@ int ath10k_core_thread_init(struct ath10k *ar,
 
 	init_waitqueue_head(&thread->wait_q);
 	init_completion(&thread->shutdown);
+	init_completion(&thread->suspend);
+	init_completion(&thread->resume);
 	memcpy(thread->name, thread_name, ATH10K_THREAD_NAME_SIZE_MAX);
 	clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN, thread->event_flags);
 	ath10k_info(ar, "Starting thread %s\n", thread_name);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 596d31b..df65e75 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -976,6 +976,7 @@ enum ath10k_thread_events {
 	ATH10K_THREAD_EVENT_SHUTDOWN,
 	ATH10K_THREAD_EVENT_RX_POST,
 	ATH10K_THREAD_EVENT_TX_POST,
+	ATH10K_THREAD_EVENT_SUSPEND,
 	ATH10K_THREAD_EVENT_MAX,
 };
 
@@ -983,6 +984,8 @@ struct ath10k_thread {
 	struct ath10k *ar;
 	struct task_struct *task;
 	struct completion shutdown;
+	struct completion suspend;
+	struct completion resume;
 	wait_queue_head_t wait_q;
 	DECLARE_BITMAP(event_flags, ATH10K_THREAD_EVENT_MAX);
 	char name[ATH10K_THREAD_NAME_SIZE_MAX];
@@ -1296,6 +1299,8 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 
 extern unsigned long ath10k_coredump_mask;
 
+int ath10k_core_thread_suspend(struct ath10k_thread *thread);
+int ath10k_core_thread_resume(struct ath10k_thread *thread);
 void ath10k_core_thread_post_event(struct ath10k_thread *thread,
 				   enum ath10k_thread_events event);
 int ath10k_core_thread_shutdown(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 3eb5eac..a373b2b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -932,13 +932,31 @@ int ath10k_snoc_rx_thread_loop(void *data)
 					    rx_thread->event_flags) ||
 			 test_and_clear_bit(ATH10K_THREAD_EVENT_TX_POST,
 					    rx_thread->event_flags) ||
+			 test_bit(ATH10K_THREAD_EVENT_SUSPEND,
+				  rx_thread->event_flags) ||
 			 test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
 				  rx_thread->event_flags)));
 
+		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
+				       rx_thread->event_flags)) {
+			complete(&rx_thread->suspend);
+			ath10k_info(ar, "rx thread suspend\n");
+			wait_for_completion(&rx_thread->resume);
+			ath10k_info(ar, "rx thread resume\n");
+		}
+
 		ath10k_htt_txrx_compl_task(ar, thread_budget);
 		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
 				       rx_thread->event_flags))
 			shutdown = true;
+
+		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
+				       rx_thread->event_flags)) {
+			complete(&rx_thread->suspend);
+			ath10k_info(ar, "rx thread suspend\n");
+			wait_for_completion(&rx_thread->resume);
+			ath10k_info(ar, "rx thread resume\n");
+		}
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread exiting\n");
@@ -1133,15 +1151,30 @@ static int ath10k_snoc_hif_suspend(struct ath10k *ar)
 	if (!device_may_wakeup(ar->dev))
 		return -EPERM;
 
+	if (ar->rx_thread_enable) {
+		ret = ath10k_core_thread_suspend(&ar->rx_thread);
+		if (ret) {
+			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
+				   ret);
+			return ret;
+		}
+	}
+
 	ret = enable_irq_wake(ar_snoc->ce_irqs[ATH10K_SNOC_WAKE_IRQ].irq_line);
 	if (ret) {
 		ath10k_err(ar, "failed to enable wakeup irq :%d\n", ret);
-		return ret;
+		goto fail;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device suspended\n");
 
 	return ret;
+
+fail:
+	if (ar->rx_thread_enable)
+		ath10k_core_thread_resume(&ar->rx_thread);
+
+	return ret;
 }
 
 static int ath10k_snoc_hif_resume(struct ath10k *ar)
@@ -1158,6 +1191,15 @@ static int ath10k_snoc_hif_resume(struct ath10k *ar)
 		return ret;
 	}
 
+	if (ar->rx_thread_enable) {
+		ret = ath10k_core_thread_resume(&ar->rx_thread);
+		if (ret) {
+			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
+				   ret);
+			return ret;
+		}
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device resumed\n");
 
 	return ret;
-- 
2.7.4

