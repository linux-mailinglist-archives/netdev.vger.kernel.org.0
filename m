Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58B22B46E
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfE0MI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:08:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:54736 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbfE0MI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 08:08:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 05:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,519,1549958400"; 
   d="scan'208";a="178857715"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2019 05:08:22 -0700
Subject: Re: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc:
 sdhci: queue work after sdhci_defer_done())
To:     Brian Masney <masneyb@onstation.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>, ulf.hansson@linaro.org,
        faiz_abbas@ti.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp> <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
 <20190526195819.GA29665@basecamp> <20190527093711.GA853@basecamp>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ead7f268-b730-3541-31f7-4499556efec0@intel.com>
Date:   Mon, 27 May 2019 15:08:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527093711.GA853@basecamp>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/05/19 12:37 PM, Brian Masney wrote:
> On Sun, May 26, 2019 at 03:58:19PM -0400, Brian Masney wrote:
>> I attached a patch that shows how I was able to determine what had
>> already claimed the host.
> On Mon, May 27, 2019 at 10:48:24AM +0300, Adrian Hunter wrote:
>> This is because SDHCI is using the IRQ thread to process the SDIO card
>> interrupt (sdio_run_irqs()).  When the card driver tries to use the card, it
>> causes interrupts which deadlocks since c07a48c26519 ("mmc: sdhci: Remove
>> finish_tasklet") has moved the tasklet processing to the IRQ thread.
>>
>> I would expect to be able to use the IRQ thread to complete requests, and it
>> is desirable to do so because it is lower latency.
>>
>> Probably, SDHCI should use sdio_signal_irq() which queues a work item, and
>> is what other drivers are doing.
>>
>> I will investigate some more and send a patch.

Please try the patch below:

From: Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 27 May 2019 14:45:55 +0300
Subject: [PATCH] mmc: sdhci: Fix SDIO IRQ thread deadlock

Since commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet"), the IRQ
thread might be used to complete requests, but the IRQ thread is also used
to process SDIO card interrupts. This can cause a deadlock when the SDIO
processing tries to access the card since that would also require the IRQ
thread. Change SDHCI to use sdio_signal_irq() to schedule a work item
instead. That also requires implementing the ->ack_sdio_irq() mmc host op.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
---
 drivers/mmc/host/sdhci.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 97158344b862..0cd5f2ce98df 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2137,6 +2137,17 @@ void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 }
 EXPORT_SYMBOL_GPL(sdhci_enable_sdio_irq);
 
+static void sdhci_ack_sdio_irq(struct mmc_host *mmc)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (host->flags & SDHCI_SDIO_IRQ_ENABLED)
+		sdhci_enable_sdio_irq_nolock(host, true);
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
 int sdhci_start_signal_voltage_switch(struct mmc_host *mmc,
 				      struct mmc_ios *ios)
 {
@@ -2585,6 +2596,7 @@ static const struct mmc_host_ops sdhci_ops = {
 	.get_ro		= sdhci_get_ro,
 	.hw_reset	= sdhci_hw_reset,
 	.enable_sdio_irq = sdhci_enable_sdio_irq,
+	.ack_sdio_irq    = sdhci_ack_sdio_irq,
 	.start_signal_voltage_switch	= sdhci_start_signal_voltage_switch,
 	.prepare_hs400_tuning		= sdhci_prepare_hs400_tuning,
 	.execute_tuning			= sdhci_execute_tuning,
@@ -3087,8 +3099,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 		if ((intmask & SDHCI_INT_CARD_INT) &&
 		    (host->ier & SDHCI_INT_CARD_INT)) {
 			sdhci_enable_sdio_irq_nolock(host, false);
-			host->thread_isr |= SDHCI_INT_CARD_INT;
-			result = IRQ_WAKE_THREAD;
+			sdio_signal_irq(host->mmc);
 		}
 
 		intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE |
@@ -3160,15 +3171,6 @@ static irqreturn_t sdhci_thread_irq(int irq, void *dev_id)
 		mmc_detect_change(mmc, msecs_to_jiffies(200));
 	}
 
-	if (isr & SDHCI_INT_CARD_INT) {
-		sdio_run_irqs(host->mmc);
-
-		spin_lock_irqsave(&host->lock, flags);
-		if (host->flags & SDHCI_SDIO_IRQ_ENABLED)
-			sdhci_enable_sdio_irq_nolock(host, true);
-		spin_unlock_irqrestore(&host->lock, flags);
-	}
-
 	return IRQ_HANDLED;
 }
 
-- 
2.17.1
