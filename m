Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A9968B63
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbfGONjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730711AbfGONjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:39:44 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9280E2080A;
        Mon, 15 Jul 2019 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197983;
        bh=Amwpqgnf93a0rJcavWw4hRlUB2lPym+RocOUdQVB50o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFQqJPKxsqyP2NPDR2GbgWSCf9dt3o9i6pQtPIDig/u5zhpVxYUpJxPcwAZJCMjrf
         h48tMswdwK1gjtn4SbOwscdfXAHCEmcVsOfxPiLmviZnMlS1LmUbBcxUfUlmFCpoGq
         D4TE1ihfw3vTgA1c+6JfNJNdg7+i1FBZvztsyMPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 007/158] wil6210: fix spurious interrupts in 3-msi
Date:   Mon, 15 Jul 2019 09:36:52 -0400
Message-Id: <20190715133923.2890-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133923.2890-1-sashal@kernel.org>
References: <20190715133923.2890-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit e10b0eddd5235aa5aef4e40b970e34e735611a80 ]

Interrupt is set in ICM (ICR & ~IMV) rising trigger.
As the driver masks the IRQ after clearing it, there can
be a race where an additional spurious interrupt is triggered
when the driver unmask the IRQ.
This can happen in case HW triggers an interrupt after the clear
and before the mask.

To prevent the second spurious interrupt the driver needs to mask the
IRQ before reading and clearing it.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 65 ++++++++++++--------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5d287a8e1b45..0655cd884514 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -296,21 +296,24 @@ void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx(wil);
-
 	/* RX_DONE and RX_HTRSH interrupts are the same if interrupt
 	 * moderation is not used. Interrupt moderation may cause RX
 	 * buffer overflow while RX_DONE is delayed. The required
@@ -355,21 +358,24 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx_edma(wil);
-
 	if (likely(isr & BIT_RX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "RX status ring\n");
 		isr &= ~BIT_RX_STATUS_IRQ;
@@ -403,21 +409,24 @@ static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx_edma(wil);
-
 	if (likely(isr & BIT_TX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "TX status ring\n");
 		isr &= ~BIT_TX_STATUS_IRQ;
@@ -446,21 +455,24 @@ static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx(wil);
-
 	if (likely(isr & BIT_DMA_EP_TX_ICR_TX_DONE)) {
 		wil_dbg_irq(wil, "TX done\n");
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
@@ -532,20 +544,23 @@ static bool wil_validate_mbox_regs(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
+
+	wil6210_mask_irq_misc(wil, false);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
 
 	trace_wil6210_irq_misc(isr);
 	wil_dbg_irq(wil, "ISR MISC 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: MISC\n");
+		wil6210_unmask_irq_misc(wil, false);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_misc(wil, false);
-
 	if (isr & ISR_MISC_FW_ERROR) {
 		u32 fw_assert_code = wil_r(wil, wil->rgf_fw_assert_code_addr);
 		u32 ucode_assert_code =
-- 
2.20.1

