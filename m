Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4562B16A
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfE0JhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 05:37:15 -0400
Received: from onstation.org ([52.200.56.107]:36356 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfE0JhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 05:37:15 -0400
Received: from localhost (c-98-239-145-235.hsd1.wv.comcast.net [98.239.145.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: masneyb)
        by onstation.org (Postfix) with ESMTPSA id 313EA3E8DE;
        Mon, 27 May 2019 09:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onstation.org;
        s=default; t=1558949832;
        bh=stAsFT+wzMVTXb2+v1Bu+TN0aoQUNCPAflRtc0M8Mzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoOC4f8ud+YVCtVfJEYJDv5TFa/dl8mi4yxnSk20MRIg1DGIUXJx86NIFHPUDLyyM
         rMb0JCe7htlCthjz8aJ3tU1hxXAEtBOHSHbM0iqetGn5TYaHXKAKDBdOqsRlXpJAws
         0j1o6Yxl3lMF/FeeHskyocYmIyrTytjPqkEn58tY=
Date:   Mon, 27 May 2019 05:37:11 -0400
From:   Brian Masney <masneyb@onstation.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Adrian Hunter <adrian.hunter@intel.com>
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
Subject: Re: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc:
 sdhci: queue work after sdhci_defer_done())
Message-ID: <20190527093711.GA853@basecamp>
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp>
 <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
 <20190526195819.GA29665@basecamp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20190526195819.GA29665@basecamp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 26, 2019 at 03:58:19PM -0400, Brian Masney wrote:
> I attached a patch that shows how I was able to determine what had
> already claimed the host.

I realized this morning that I had a flaw with my test patch that
diagnosed what was deadlocked. The mmc_ctx structure was allocated on
the stack. I attached a second version of that patch that uses
kmalloc() for that structure. It didn't change what I reported
yesterday: brcmf_sdiod_ramrw is deadlocked by
brcmf_sdio_download_firmware.


On Mon, May 27, 2019 at 10:48:24AM +0300, Adrian Hunter wrote:
> This is because SDHCI is using the IRQ thread to process the SDIO card
> interrupt (sdio_run_irqs()).  When the card driver tries to use the card, it
> causes interrupts which deadlocks since c07a48c26519 ("mmc: sdhci: Remove
> finish_tasklet") has moved the tasklet processing to the IRQ thread.
> 
> I would expect to be able to use the IRQ thread to complete requests, and it
> is desirable to do so because it is lower latency.
> 
> Probably, SDHCI should use sdio_signal_irq() which queues a work item, and
> is what other drivers are doing.
> 
> I will investigate some more and send a patch.

Thank you!

Brian


--bp/iNruPH9dso1Pn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-troubleshoot-broadcom-wireless-lockup-in-5.2rc1-v2.patch"

From acc78b5e581d2c3ebc994a6ad6e7b367f2b81935 Mon Sep 17 00:00:00 2001
From: Brian Masney <masneyb@onstation.org>
Date: Sun, 26 May 2019 15:36:40 -0400
Subject: [PATCH] troubleshoot broadcom wireless lockup in 5.2rc1 (v2)

Signed-off-by: Brian Masney <masneyb@onstation.org>
---
 drivers/mmc/core/core.c                       |  15 ++
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  46 ++---
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 160 ++++++++++--------
 .../broadcom/brcm80211/brcmfmac/sdio.h        |   3 +
 include/linux/mmc/host.h                      |   1 +
 5 files changed, 136 insertions(+), 89 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6db36dc870b5..768acabf029b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -814,7 +814,22 @@ int __mmc_claim_host(struct mmc_host *host, struct mmc_ctx *ctx,
 		if (stop || !host->claimed || mmc_ctx_matches(host, ctx, task))
 			break;
 		spin_unlock_irqrestore(&host->lock, flags);
+
+		if (ctx != NULL && ctx->descr != NULL) {
+			WARN_ON(1);
+			dev_info(&host->class_dev, "%s: FIXME - before schedule() - descr=%s, claimer=%s\n",
+				 __func__, ctx->descr,
+				 host->claimer != NULL ? host->claimer->descr : NULL);
+		}
+
 		schedule();
+
+		if (ctx != NULL && ctx->descr != NULL) {
+			dev_info(&host->class_dev, "%s: FIXME - after schedule() - descr=%s, claimer=%s\n",
+				 __func__, ctx->descr,
+				 host->claimer != NULL ? host->claimer->descr : NULL);
+		}
+
 		spin_lock_irqsave(&host->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 60aede5abb4d..fdeaeb1353af 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -47,6 +47,8 @@
 #include "sdio.h"
 #include "core.h"
 #include "common.h"
+#include "../../../../../mmc/core/host.h"
+#include "../../../../../mmc/core/core.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
@@ -132,7 +134,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		}
 		sdiodev->irq_wake = true;
 
-		sdio_claim_host(sdiodev->func1);
+		brcmf_sdio_claim_host(sdiodev->func1, __func__);
 
 		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
 			/* assign GPIO to SDIO core */
@@ -159,13 +161,13 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 			data |= SDIO_CCCR_BRCM_SEPINT_ACT_HI;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT,
 				     data, &ret);
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
-		sdio_claim_host(sdiodev->func1);
+		brcmf_sdio_claim_host(sdiodev->func1, __func__);
 		sdio_claim_irq(sdiodev->func1, brcmf_sdiod_ib_irqhandler);
 		sdio_claim_irq(sdiodev->func2, brcmf_sdiod_dummy_irqhandler);
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 		sdiodev->sd_irq_requested = true;
 	}
 
@@ -183,10 +185,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		struct brcmfmac_sdio_pd *pdata;
 
 		pdata = &sdiodev->settings->bus.sdio;
-		sdio_claim_host(sdiodev->func1);
+		brcmf_sdio_claim_host(sdiodev->func1, __func__);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 
 		sdiodev->oob_irq_requested = false;
 		if (sdiodev->irq_wake) {
@@ -199,10 +201,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	if (sdiodev->sd_irq_requested) {
-		sdio_claim_host(sdiodev->func1);
+		brcmf_sdio_claim_host(sdiodev->func1, __func__);
 		sdio_release_irq(sdiodev->func2);
 		sdio_release_irq(sdiodev->func1);
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 		sdiodev->sd_irq_requested = false;
 	}
 }
@@ -695,7 +697,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	else
 		dsize = size;
 
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 
 	/* Do the transfer(s) */
 	while (size) {
@@ -742,7 +744,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	dev_kfree_skb(pkt);
 
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 
 	return err;
 }
@@ -827,17 +829,17 @@ static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_trigger_dpc(sdiodev->bus);
 	wait_event(sdiodev->freezer->thread_freeze,
 		   atomic_read(expect) == sdiodev->freezer->frozen_count);
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 	res = brcmf_sdio_sleep(sdiodev->bus, true);
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 	return res;
 }
 
 static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 {
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 	brcmf_sdio_sleep(sdiodev->bus, false);
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 	atomic_set(&sdiodev->freezer->freezing, 0);
 	complete_all(&sdiodev->freezer->resumed);
 }
@@ -887,14 +889,14 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdiod_freezer_detach(sdiodev);
 
 	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func2);
+	brcmf_sdio_claim_host(sdiodev->func2, __func__);
 	sdio_disable_func(sdiodev->func2);
-	sdio_release_host(sdiodev->func2);
+	brcmf_sdio_release_host(sdiodev->func2);
 
 	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 	sdio_disable_func(sdiodev->func1);
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 
 	sg_free_table(&sdiodev->sgtable);
 	sdiodev->sbwad = 0;
@@ -915,18 +917,18 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 
 	ret = sdio_set_block_size(sdiodev->func1, SDIO_FUNC1_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F1 blocksize\n");
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 		goto out;
 	}
 	ret = sdio_set_block_size(sdiodev->func2, SDIO_FUNC2_BLOCKSIZE);
 	if (ret) {
 		brcmf_err("Failed to set F2 blocksize\n");
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 		goto out;
 	}
 
@@ -935,7 +937,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 
 	/* Enable Function 1 */
 	ret = sdio_enable_func(sdiodev->func1);
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 	if (ret) {
 		brcmf_err("Failed to enable F1: err=%d\n", ret);
 		goto out;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 22b73da42822..ba836aa5da78 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -45,6 +45,8 @@
 #include "core.h"
 #include "common.h"
 #include "bcdc.h"
+#include "../../../../../mmc/core/host.h"
+#include "../../../../../mmc/core/core.h"
 
 #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
 #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
@@ -651,6 +653,25 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
 };
 
+void brcmf_sdio_claim_host(struct sdio_func *func, const char *descr)
+{
+	struct mmc_ctx *mmc_ctx;
+
+	mmc_ctx = kmalloc(sizeof(*mmc_ctx), GFP_KERNEL);
+	mmc_ctx->task = NULL;
+	mmc_ctx->descr = descr;
+	__mmc_claim_host(func->card->host, mmc_ctx, NULL);
+}
+
+void brcmf_sdio_release_host(struct sdio_func *func)
+{
+	struct mmc_ctx *tofree;
+
+	tofree = func->card->host->claimer;
+	sdio_release_host(func);
+	kfree(tofree);
+}
+
 static void pkt_align(struct sk_buff *p, int len, int align)
 {
 	uint datalign;
@@ -995,7 +1016,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/*
@@ -1029,7 +1050,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	if (rv < 0)
 		goto fail;
 
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 	/* Endianness */
 	sh->flags = le32_to_cpu(sh_le.flags);
@@ -1051,7 +1072,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 fail:
 	brcmf_err("unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
 		  rv, addr);
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 	return rv;
 }
 
@@ -1583,10 +1604,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
-		sdio_claim_host(bus->sdiodev->func1);
+		brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
 						 &bus->glom, dlen);
-		sdio_release_host(bus->sdiodev->func1);
+		brcmf_sdio_release_host(bus->sdiodev->func1);
 		bus->sdcnt.f2rxdata++;
 
 		/* On failure, kill the superframe */
@@ -1594,11 +1615,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			return 0;
 		}
 
@@ -1608,10 +1629,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
-		sdio_claim_host(bus->sdiodev->func1);
+		brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
-		sdio_release_host(bus->sdiodev->func1);
+		brcmf_sdio_release_host(bus->sdiodev->func1);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */
@@ -1626,10 +1647,10 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
 						     BRCMF_SDIO_FT_SUB);
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
 
@@ -1638,11 +1659,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		if (errcode) {
 			/* Terminate frame on error */
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			bus->cur_read.len = 0;
 			return 0;
 		}
@@ -1849,7 +1870,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		rd->len_left = rd->len;
 		/* read header first for unknow frame length */
-		sdio_claim_host(bus->sdiodev->func1);
+		brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 		if (!rd->len) {
 			ret = brcmf_sdiod_recv_buf(bus->sdiodev,
 						   bus->rxhdr, BRCMF_FIRSTREAD);
@@ -1859,7 +1880,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  ret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdio_rxfail(bus, true, true);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				continue;
 			}
 
@@ -1869,7 +1890,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, rd,
 					       BRCMF_SDIO_FT_NORMAL)) {
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				if (!bus->rxpending)
 					break;
 				else
@@ -1885,7 +1906,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				rd->len_nxtfrm = 0;
 				/* treat all packet as event if we don't know */
 				rd->channel = SDPCM_EVENT_CHANNEL;
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				continue;
 			}
 			rd->len_left = rd->len > BRCMF_FIRSTREAD ?
@@ -1902,7 +1923,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
 			brcmf_sdio_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			continue;
 		}
 		skb_pull(pkt, head_read);
@@ -1910,16 +1931,16 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		ret = brcmf_sdiod_recv_pkt(bus->sdiodev, pkt);
 		bus->sdcnt.f2rxdata++;
-		sdio_release_host(bus->sdiodev->func1);
+		brcmf_sdio_release_host(bus->sdiodev->func1);
 
 		if (ret < 0) {
 			brcmf_err("read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			brcmf_sdio_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			continue;
 		}
 
@@ -1930,7 +1951,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		} else {
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
@@ -1943,11 +1964,11 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
 				brcmf_sdio_rxfail(bus, true, true);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 			rd->len_nxtfrm = rd_new.len_nxtfrm;
 			rd->channel = rd_new.channel;
 			rd->dat_offset = rd_new.dat_offset;
@@ -1963,9 +1984,10 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
-				sdio_claim_host(bus->sdiodev->func1);
+				brcmf_sdio_claim_host(bus->sdiodev->func1,
+						      __func__);
 				brcmf_sdio_rxfail(bus, false, true);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
@@ -1988,9 +2010,10 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			} else {
 				brcmf_err("%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
-				sdio_claim_host(bus->sdiodev->func1);
+				brcmf_sdio_claim_host(bus->sdiodev->func1,
+						      __func__);
 				brcmf_sdio_rxfail(bus, false, false);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 			}
 			/* prepare the descriptor for the next read */
 			rd->len = rd->len_nxtfrm << 4;
@@ -2267,14 +2290,14 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	if (ret)
 		goto done;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0)
 		brcmf_sdio_txfail(bus);
 
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 done:
 	brcmf_sdio_txpkt_postp(bus, pktq);
@@ -2330,10 +2353,10 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			intstatus = brcmf_sdiod_readl(bus->sdiodev,
 						      intstat_addr, &ret);
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 
 			bus->sdcnt.f2txdata++;
 			if (ret != 0)
@@ -2442,7 +2465,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	}
 
 	if (sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-		sdio_claim_host(sdiodev->func1);
+		brcmf_sdio_claim_host(sdiodev->func1, __func__);
 
 		/* Enable clock for device interrupts */
 		brcmf_sdio_bus_sleep(bus, false, false);
@@ -2477,7 +2500,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		brcmf_sdiod_writel(sdiodev, core->base + SD_REG(intstatus),
 				   local_hostintmask, NULL);
 
-		sdio_release_host(sdiodev->func1);
+		brcmf_sdio_release_host(sdiodev->func1);
 	}
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
@@ -2552,7 +2575,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(SDIO, "Enter\n");
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 
 	/* If waiting for HTAVAIL, check status */
 	if (!bus->sr_enabled && bus->clkstate == CLK_PENDING) {
@@ -2615,7 +2638,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		intstatus |= brcmf_sdio_hostmail(bus);
 	}
 
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
@@ -2658,7 +2681,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
 	    data_ok(bus)) {
-		sdio_claim_host(bus->sdiodev->func1);
+		brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 		if (bus->ctrl_frame_stat) {
 			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
 						      bus->ctrl_frame_len);
@@ -2666,7 +2689,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 			wmb();
 			bus->ctrl_frame_stat = false;
 		}
-		sdio_release_host(bus->sdiodev->func1);
+		brcmf_sdio_release_host(bus->sdiodev->func1);
 		brcmf_sdio_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
@@ -2682,14 +2705,14 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			if (bus->ctrl_frame_stat) {
 				bus->ctrl_frame_err = -ENODEV;
 				wmb();
 				bus->ctrl_frame_stat = false;
 				brcmf_sdio_wait_event_wakeup(bus);
 			}
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 		}
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
@@ -2904,13 +2927,13 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 					 CTL_DONE_TIMEOUT);
 	ret = 0;
 	if (bus->ctrl_frame_stat) {
-		sdio_claim_host(bus->sdiodev->func1);
+		brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 		if (bus->ctrl_frame_stat) {
 			brcmf_dbg(SDIO, "ctrl_frame timeout\n");
 			bus->ctrl_frame_stat = false;
 			ret = -ETIMEDOUT;
 		}
-		sdio_release_host(bus->sdiodev->func1);
+		brcmf_sdio_release_host(bus->sdiodev->func1);
 	}
 	if (!ret) {
 		brcmf_dbg(SDIO, "ctrl_frame complete, err=%d\n",
@@ -3048,7 +3071,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		return 0;
 	}
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 	if (sh->assert_file_addr != 0) {
 		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
 					  sh->assert_file_addr, (u8 *)file, 80);
@@ -3061,7 +3084,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		if (error < 0)
 			return error;
 	}
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 	seq_printf(seq, "dongle assert: %s:%d: assert(%s)\n",
 		   file, sh->assert_line, expr);
@@ -3340,7 +3363,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	int bcmerror;
 	u32 rstvec;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	rstvec = get_unaligned_le32(fw->data);
@@ -3369,7 +3392,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 
 err:
 	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 	return bcmerror;
 }
 
@@ -3564,7 +3587,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 
 	address = bus->ci->rambase;
 	offset = err = 0;
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 	while (offset < mem_size) {
 		len = ((offset + MEMBLOCK) < mem_size) ? MEMBLOCK :
 		      mem_size - offset;
@@ -3580,7 +3603,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 	}
 
 done:
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 	return err;
 }
 
@@ -3637,10 +3660,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (!bus->dpc_triggered) {
 				u8 devpend;
 
-				sdio_claim_host(bus->sdiodev->func1);
+				brcmf_sdio_claim_host(bus->sdiodev->func1,
+						      __func__);
 				devpend = brcmf_sdiod_func0_rb(bus->sdiodev,
 						  SDIO_CCCR_INTx, NULL);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 				intstatus = devpend & (INTR_STATUS_FUNC1 |
 						       INTR_STATUS_FUNC2);
 			}
@@ -3666,13 +3690,13 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 		bus->console.count += jiffies_to_msecs(BRCMF_WD_POLL);
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
-			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 			/* Make sure backplane clock is on */
 			brcmf_sdio_bus_sleep(bus, false, false);
 			if (brcmf_sdio_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
-			sdio_release_host(bus->sdiodev->func1);
+			brcmf_sdio_release_host(bus->sdiodev->func1);
 		}
 	}
 #endif				/* DEBUG */
@@ -3685,11 +3709,12 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			bus->idlecount++;
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
-				sdio_claim_host(bus->sdiodev->func1);
+				brcmf_sdio_claim_host(bus->sdiodev->func1,
+						      __func__);
 				brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 			}
 		} else {
 			bus->idlecount = 0;
@@ -3903,7 +3928,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	u32 drivestrength;
 
 	sdiodev = bus->sdiodev;
-	sdio_claim_host(sdiodev->func1);
+	brcmf_sdio_claim_host(sdiodev->func1, __func__);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
 		 brcmf_sdiod_readl(sdiodev, SI_ENUM_BASE, NULL));
@@ -4010,7 +4035,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	if (err)
 		goto fail;
 
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
@@ -4031,7 +4056,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	return true;
 
 fail:
-	sdio_release_host(sdiodev->func1);
+	brcmf_sdio_release_host(sdiodev->func1);
 	return false;
 }
 
@@ -4147,7 +4172,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdio_wd_timer(bus, true);
 
-	sdio_claim_host(sdiod->func1);
+	brcmf_sdio_claim_host(sdiod->func1, __func__);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
@@ -4243,7 +4268,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		goto checkdied;
 	}
 
-	sdio_release_host(sdiod->func1);
+	brcmf_sdio_release_host(sdiod->func1);
 
 	/* Assign bus interface call back */
 	sdiod->bus_if->dev = sdiod->dev;
@@ -4255,7 +4280,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	err = brcmf_attach(sdiod->dev, sdiod->settings);
 	if (err != 0) {
 		brcmf_err("brcmf_attach failed\n");
-		sdio_claim_host(sdiod->func1);
+		brcmf_sdio_claim_host(sdiod->func1, __func__);
 		goto checkdied;
 	}
 
@@ -4265,7 +4290,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 checkdied:
 	brcmf_sdio_checkdied(bus);
 release:
-	sdio_release_host(sdiod->func1);
+	brcmf_sdio_release_host(sdiod->func1);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
 	device_release_driver(&sdiod->func2->dev);
@@ -4361,7 +4386,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	sdio_disable_func(bus->sdiodev->func2);
@@ -4371,7 +4396,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Done with backplane-dependent accesses, can drop clock... */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
@@ -4428,7 +4453,8 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 
 		if (bus->ci) {
 			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-				sdio_claim_host(bus->sdiodev->func1);
+				brcmf_sdio_claim_host(bus->sdiodev->func1,
+						      __func__);
 				brcmf_sdio_wd_timer(bus, false);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4438,7 +4464,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 				msleep(20);
 				brcmf_chip_set_passive(bus->ci);
 				brcmf_sdio_clkctl(bus, CLK_NONE, false);
-				sdio_release_host(bus->sdiodev->func1);
+				brcmf_sdio_release_host(bus->sdiodev->func1);
 			}
 			brcmf_chip_detach(bus->ci);
 		}
@@ -4485,9 +4511,9 @@ int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
 {
 	int ret;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	brcmf_sdio_claim_host(bus->sdiodev->func1, __func__);
 	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
-	sdio_release_host(bus->sdiodev->func1);
+	brcmf_sdio_release_host(bus->sdiodev->func1);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 34b031154da9..51ade937f5b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -388,4 +388,7 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
 int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep);
 void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus);
 
+void brcmf_sdio_claim_host(struct sdio_func *func, const char *descr);
+void brcmf_sdio_release_host(struct sdio_func *func);
+
 #endif /* BRCMFMAC_SDIO_H */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43d0f0c496f6..6ccc76150f45 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -267,6 +267,7 @@ struct mmc_supply {
 };
 
 struct mmc_ctx {
+	const char *descr;
 	struct task_struct *task;
 };
 
-- 
2.20.1


--bp/iNruPH9dso1Pn--
