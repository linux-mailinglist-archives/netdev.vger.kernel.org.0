Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA70217501
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgGGRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbgGGRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:18:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898C9C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 10:18:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so12066209pjb.2
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 10:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8cY0UjCqQW+XSyCWIjc/cIyKo3bTfjDtS/okyB/bgKU=;
        b=HwtUr+jCHgdVdQ/4DQ+mnArfTxmKtDKFK+/dWGDL2hTzGtliqnCvqDjZpUfrNAv3OK
         V0JhsNG/ymULp48sJeuBFYFpZm2cOZvvC05IOQsz4hS3wtspfm0pqZale2pUORJKSzVW
         eG3m6ZIg3foorBvtflPR1PabbzK8xB5PpY5cE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8cY0UjCqQW+XSyCWIjc/cIyKo3bTfjDtS/okyB/bgKU=;
        b=TTjMrfvG1IgUO3yj1O6NJERCgO9J+HMJavg7emhnjwA7aiZdo0YWyFvOK3bYoWdvp9
         pUdE0AN1yoR3SrdF/oQbXaJSCUxBthR/4AlY6ncukJKCdcd60gze8QZWsTbpJVXOujV9
         yfO6jKn7uQJT253b/YKHdFKkT2lFP2WGKjuMevPura4P8YDTfM2c43B8jqCPnSzH+8Mj
         KizqxeS6ymsA6M/8ZmkbNA4zMKFohZ5kijTI/821jOKTx9YDfh1D5D7X8eeRCdRnaYRR
         vG7z2aCyIqzjPvd6MXwbVrx9uv3+rtLVLY+DbhXCXrIG6IKct7hatWxcgx3qYgcdHghP
         JhSw==
X-Gm-Message-State: AOAM532MT//AlUM5khvod2LkIJ78eBro9tVBqnw2UQlLUBuZYM2uzGi3
        b/nEZbxOU+h7afBSJz3NhZ+/lA==
X-Google-Smtp-Source: ABdhPJxGK0bs1Msv9keoWPtVbcaPgpRLF8GJdwuI1T+wvmJQfbWZ1ep2ADN/b+nXgvZNdJNUpND+cA==
X-Received: by 2002:a17:90a:ab96:: with SMTP id n22mr5486082pjq.52.1594142309941;
        Tue, 07 Jul 2020 10:18:29 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:42b0:34ff:fe3d:58e6])
        by smtp.gmail.com with ESMTPSA id 16sm2924230pjb.48.2020.07.07.10.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 10:18:29 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     kvalo@codeaurora.org, ath10k@lists.infradead.org
Cc:     saiprakash.ranjan@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, pillair@codeaurora.org,
        kuabhs@google.com, Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] ath10k: Keep track of which interrupts fired, don't poll them
Date:   Tue,  7 Jul 2020 10:17:34 -0700
Message-Id: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have a per CE (Copy Engine) IRQ then we have no summary
register.  Right now the code generates a summary register by
iterating over all copy engines and seeing if they have an interrupt
pending.

This has a problem.  Specifically if _none_ if the Copy Engines have
an interrupt pending then they might go into low power mode and
reading from their address space will cause a full system crash.  This
was seen to happen when two interrupts went off at nearly the same
time.  Both were handled by a single call of ath10k_snoc_napi_poll()
but, because there were two interrupts handled and thus two calls to
napi_schedule() there was still a second call to
ath10k_snoc_napi_poll() which ran with no interrupts pending.

Instead of iterating over all the copy engines, let's just keep track
of the IRQs that fire.  Then we can effectively generate our own
summary without ever needing to read the Copy Engines.

Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
This patch continues work to try to squash all instances of the crash
we've been seeing while reading CE registers and hopefully this patch
addresses the true root of the issue.

The first patch that attempted to address these problems landed as
commit 8f9ed93d09a9 ("ath10k: Wait until copy complete is actually
done before completing").  After that Rakesh Pillai posted ("ath10k:
Add interrupt summary based CE processing") [1] and this patch is
based atop that one.  Both of those patches significantly reduced the
instances of problems but didn't fully eliminate them.  Crossing my
fingers that they're all gone now.

[1] https://lore.kernel.org/r/1593193967-29897-1-git-send-email-pillair@codeaurora.org

 drivers/net/wireless/ath/ath10k/ce.c   | 84 ++++++++++----------------
 drivers/net/wireless/ath/ath10k/ce.h   | 14 ++---
 drivers/net/wireless/ath/ath10k/snoc.c | 18 ++++--
 drivers/net/wireless/ath/ath10k/snoc.h |  1 +
 4 files changed, 51 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 1e16f263854a..84ec80c6d08f 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -481,38 +481,6 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
 	ath10k_ce_write32(ar, ce_ctrl_addr + wm_regs->addr, mask);
 }
 
-static bool ath10k_ce_engine_int_status_check(struct ath10k *ar, u32 ce_ctrl_addr,
-					      unsigned int mask)
-{
-	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
-
-	return ath10k_ce_read32(ar, ce_ctrl_addr + wm_regs->addr) & mask;
-}
-
-u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar)
-{
-	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
-	struct ath10k_ce_pipe *ce_state;
-	struct ath10k_ce *ce;
-	u32 irq_summary = 0;
-	u32 ctrl_addr;
-	u32 ce_id;
-
-	ce = ath10k_ce_priv(ar);
-
-	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
-		ce_state = &ce->ce_states[ce_id];
-		ctrl_addr = ce_state->ctrl_addr;
-		if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
-						      wm_regs->cc_mask)) {
-			irq_summary |= BIT(ce_id);
-		}
-	}
-
-	return irq_summary;
-}
-EXPORT_SYMBOL(ath10k_ce_gen_interrupt_summary);
-
 /*
  * Guts of ath10k_ce_send.
  * The caller takes responsibility for any needed locking.
@@ -1399,45 +1367,55 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state)
 	ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
 }
 
-int ath10k_ce_disable_interrupts(struct ath10k *ar)
+void ath10k_ce_disable_interrupt(struct ath10k *ar, int ce_id)
 {
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	struct ath10k_ce_pipe *ce_state;
 	u32 ctrl_addr;
-	int ce_id;
 
-	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
-		ce_state  = &ce->ce_states[ce_id];
-		if (ce_state->attr_flags & CE_ATTR_POLL)
-			continue;
+	ce_state  = &ce->ce_states[ce_id];
+	if (ce_state->attr_flags & CE_ATTR_POLL)
+		return;
 
-		ctrl_addr = ath10k_ce_base_address(ar, ce_id);
+	ctrl_addr = ath10k_ce_base_address(ar, ce_id);
 
-		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
-		ath10k_ce_error_intr_disable(ar, ctrl_addr);
-		ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
-	}
+	ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
+	ath10k_ce_error_intr_disable(ar, ctrl_addr);
+	ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
+}
+EXPORT_SYMBOL(ath10k_ce_disable_interrupt);
 
-	return 0;
+void ath10k_ce_disable_interrupts(struct ath10k *ar)
+{
+	int ce_id;
+
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+		ath10k_ce_disable_interrupt(ar, ce_id);
 }
 EXPORT_SYMBOL(ath10k_ce_disable_interrupts);
 
-void ath10k_ce_enable_interrupts(struct ath10k *ar)
+void ath10k_ce_enable_interrupt(struct ath10k *ar, int ce_id)
 {
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
-	int ce_id;
 	struct ath10k_ce_pipe *ce_state;
 
+	ce_state  = &ce->ce_states[ce_id];
+	if (ce_state->attr_flags & CE_ATTR_POLL)
+		return;
+
+	ath10k_ce_per_engine_handler_adjust(ce_state);
+}
+EXPORT_SYMBOL(ath10k_ce_enable_interrupt);
+
+void ath10k_ce_enable_interrupts(struct ath10k *ar)
+{
+	int ce_id;
+
 	/* Enable interrupts for copy engine that
 	 * are not using polling mode.
 	 */
-	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
-		ce_state  = &ce->ce_states[ce_id];
-		if (ce_state->attr_flags & CE_ATTR_POLL)
-			continue;
-
-		ath10k_ce_per_engine_handler_adjust(ce_state);
-	}
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+		ath10k_ce_enable_interrupt(ar, ce_id);
 }
 EXPORT_SYMBOL(ath10k_ce_enable_interrupts);
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index a440aaf74aa4..666ce384a1d8 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -255,12 +255,13 @@ int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 /*==================CE Interrupt Handlers====================*/
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
-int ath10k_ce_disable_interrupts(struct ath10k *ar);
+void ath10k_ce_disable_interrupt(struct ath10k *ar, int ce_id);
+void ath10k_ce_disable_interrupts(struct ath10k *ar);
+void ath10k_ce_enable_interrupt(struct ath10k *ar, int ce_id);
 void ath10k_ce_enable_interrupts(struct ath10k *ar);
 void ath10k_ce_dump_registers(struct ath10k *ar,
 			      struct ath10k_fw_crash_data *crash_data);
 
-u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar);
 void ath10k_ce_alloc_rri(struct ath10k *ar);
 void ath10k_ce_free_rri(struct ath10k *ar);
 
@@ -376,12 +377,9 @@ static inline u32 ath10k_ce_interrupt_summary(struct ath10k *ar)
 {
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 
-	if (!ar->hw_params.per_ce_irq)
-		return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
-			ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
-			CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
-	else
-		return ath10k_ce_gen_interrupt_summary(ar);
+	return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
+		ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
+		CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
 }
 
 /* Host software's Copy Engine configuration. */
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 354d49b1cd45..2fc4dcbab70a 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2018 The Linux Foundation. All rights reserved.
  */
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -1158,7 +1159,9 @@ static irqreturn_t ath10k_snoc_per_engine_handler(int irq, void *arg)
 		return IRQ_HANDLED;
 	}
 
-	ath10k_snoc_irq_disable(ar);
+	ath10k_ce_disable_interrupt(ar, ce_id);
+	set_bit(ce_id, ar_snoc->pending_ce_irqs);
+
 	napi_schedule(&ar->napi);
 
 	return IRQ_HANDLED;
@@ -1167,20 +1170,25 @@ static irqreturn_t ath10k_snoc_per_engine_handler(int irq, void *arg)
 static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 {
 	struct ath10k *ar = container_of(ctx, struct ath10k, napi);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	int done = 0;
+	int ce_id;
 
 	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags)) {
 		napi_complete(ctx);
 		return done;
 	}
 
-	ath10k_ce_per_engine_service_any(ar);
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+		if (test_and_clear_bit(ce_id, ar_snoc->pending_ce_irqs)) {
+			ath10k_ce_per_engine_service(ar, ce_id);
+			ath10k_ce_enable_interrupt(ar, ce_id);
+		}
+
 	done = ath10k_htt_txrx_compl_task(ar, budget);
 
-	if (done < budget) {
+	if (done < budget)
 		napi_complete(ctx);
-		ath10k_snoc_irq_enable(ar);
-	}
 
 	return done;
 }
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index a3dd06f6ac62..5095d1893681 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -78,6 +78,7 @@ struct ath10k_snoc {
 	unsigned long flags;
 	bool xo_cal_supported;
 	u32 xo_cal_data;
+	DECLARE_BITMAP(pending_ce_irqs, CE_COUNT_MAX);
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
-- 
2.27.0.383.g050319c2ae-goog

