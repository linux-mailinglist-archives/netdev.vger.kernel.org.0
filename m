Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC012ABFA
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfEZUHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:07:09 -0400
Received: from onstation.org ([52.200.56.107]:35478 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfEZUHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 16:07:09 -0400
Received: from localhost (c-98-239-145-235.hsd1.wv.comcast.net [98.239.145.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: masneyb)
        by onstation.org (Postfix) with ESMTPSA id 700773E8E5;
        Sun, 26 May 2019 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onstation.org;
        s=default; t=1558900699;
        bh=TUA6JZfxlSWxScOkrxtzPe5Lg4052BmxFjSCN9g7SFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=arAvVpaK+44wOAy5qVFzIZwPh7Ay0WJtubuRhnwKqMWngLaGGx9nzHmsKyQiIJSg5
         z/WXRjyrYtVo/N2GnBQwbTeIfe8RQJYzRqDaARN4AIP+yHx4lhzksz1bWE0pfreNci
         Q45Kd85n/VHdFbdvfU3xa/SOtyPpHQOhJOMKO/8s=
Date:   Sun, 26 May 2019 15:58:19 -0400
From:   Brian Masney <masneyb@onstation.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Franky Lin <franky.lin@broadcom.com>,
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
Message-ID: <20190526195819.GA29665@basecamp>
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp>
 <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 26, 2019 at 08:42:21PM +0200, Arend Van Spriel wrote:
> On 5/26/2019 2:21 PM, Brian Masney wrote:
> > + Broadcom wireless maintainers
> > 
> > On Fri, May 24, 2019 at 11:49:58AM -0400, Brian Masney wrote:
> > > On Fri, May 24, 2019 at 03:17:13PM +0300, Adrian Hunter wrote:
> > > > On 24/05/19 2:10 PM, Brian Masney wrote:
> > > > > WiFi stopped working on the LG Nexus 5 phone and the issue was bisected
> > > > > to the commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet") that
> > > > > moved from using a tasklet to a work queue. That patch also changed
> > > > > sdhci_irq() to return IRQ_WAKE_THREAD instead of finishing the work when
> > > > > sdhci_defer_done() is true. Change it to queue work to the complete work
> > > > > queue if sdhci_defer_done() is true so that the functionality is
> > > > > equilivent to what was there when the finish_tasklet was present. This
> > > > > corrects the WiFi breakage on the Nexus 5 phone.
> > > > > 
> > > > > Signed-off-by: Brian Masney <masneyb@onstation.org>
> > > > > Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
> > > > > ---
> > > > > [ ... ]
> > > > > 
> > > > >   drivers/mmc/host/sdhci.c | 2 +-
> > > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > > > > index 97158344b862..3563c3bc57c9 100644
> > > > > --- a/drivers/mmc/host/sdhci.c
> > > > > +++ b/drivers/mmc/host/sdhci.c
> > > > > @@ -3115,7 +3115,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
> > > > >   			continue;
> > > > >   		if (sdhci_defer_done(host, mrq)) {
> > > > > -			result = IRQ_WAKE_THREAD;
> > > > > +			queue_work(host->complete_wq, &host->complete_work);
> > > > 
> > > > The IRQ thread has a lot less latency than the work queue, which is why it
> > > > is done that way.
> > > > 
> > > > I am not sure why you say this change is equivalent to what was there
> > > > before, nor why it fixes your problem.
> > > > 
> > > > Can you explain some more?
> > > 
> > > [ ... ]
> > > 
> > > drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
> > > sdio_claim_host() and it appears to never return.
> > 
> > When the brcmfmac driver is loaded, the firmware is requested from disk,
> > and that's when the deadlock occurs in 5.2rc1. Specifically:
> > 
> > 1) brcmf_sdio_download_firmware() in
> >     drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
> >     sdio_claim_host()
> > 
> > 2) brcmf_sdio_firmware_callback() is called and brcmf_sdiod_ramrw()
> >     tries to claim the host, but has to wait since its already claimed
> >     in #1 and the deadlock occurs.
> 
> This does not make any sense to me. brcmf_sdio_download_firmware() is called
> from brcmf_sdio_firmware_callback() so they are in the same context. So #2
> is not waiting for #1, but something else I would say. Also #2 calls
> sdio_claim_host() after brcmf_sdio_download_firmware has completed so
> definitely not waiting for #1.

I attached a patch that shows how I was able to determine what had
already claimed the host. It's messy; please don't judge me negatively
for this. :) Anyways, sdio_claim_host() is mostly a wrapper for
__mmc_claim_host() and there is a mmc_ctx structure that contains a
task struct. This context can be NULL. I added a description field
to the context structure and put the function name that claimed the
host in there. The mmc_host structure already contained a 'claimer'
member, so that made it easy.

I see the following messages in dmesg that shows what has already
claimed the host when loading the brcmfmac module in 5.2rc1:

cfg80211: Loading compiled-in X.509 certificates for regulatory database
cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
cfg80211: failed to load regulatory.db
brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4339-sdio for chip BCM4339/2
brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4339-sdio.lge,hammerhead.txt failed with error -2
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5 at drivers/mmc/core/core.c:819 __mmc_claim_host+0x28c/0x2c0
Modules linked in: brcmfmac brcmutil cfg80211 dm_mod
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.2.0-rc1-00175-g9899510d2cd1-dirty #420
Hardware name: Generic DT based system
Workqueue: events request_firmware_work_func
[<c03122dc>] (unwind_backtrace) from [<c030d5dc>] (show_stack+0x10/0x14)
[<c030d5dc>] (show_stack) from [<c0ac284c>] (dump_stack+0x78/0x8c)
[<c0ac284c>] (dump_stack) from [<c0321438>] (__warn.part.3+0xb8/0xd4)
[<c0321438>] (__warn.part.3) from [<c03215b0>] (warn_slowpath_null+0x44/0x4c)
[<c03215b0>] (warn_slowpath_null) from [<c093e608>] (__mmc_claim_host+0x28c/0x2c0)
[<c093e608>] (__mmc_claim_host) from [<bf115018>] (brcmf_sdiod_ramrw+0x9c/0x200 [brcmfmac])
[<bf115018>] (brcmf_sdiod_ramrw [brcmfmac]) from [<bf110508>] (brcmf_sdio_firmware_callback+0xe8/0x7b4 [brcmfmac])
[<bf110508>] (brcmf_sdio_firmware_callback [brcmfmac]) from [<bf108830>] (brcmf_fw_request_done+0xf0/0x110 [brcmfmac])
[<bf108830>] (brcmf_fw_request_done [brcmfmac]) from [<c081a4e8>] (request_firmware_work_func+0x4c/0x88)
[<c081a4e8>] (request_firmware_work_func) from [<c033c260>] (process_one_work+0x1fc/0x564)
[<c033c260>] (process_one_work) from [<c033ceb8>] (worker_thread+0x44/0x584)
[<c033ceb8>] (worker_thread) from [<c034226c>] (kthread+0x148/0x150)
[<c034226c>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xee8bdfb0 to 0xee8bdff8)
dfa0:                                     00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 4ab1b01efc876120 ]---
mmc_host mmc1: __mmc_claim_host: FIXME - before schedule() - descr=brcmf_sdiod_ramrw, claimer=brcmf_sdio_download_firmware

The 'after schedule()' line is not shown and WiFi doesn't work.

> > I tried to release the host before the firmware is requested, however
> > parts of brcmf_chip_set_active() needs the host to be claimed, and a
> > similar deadlock occurs in brcmf_sdiod_ramrw() if I claim the host
> > before calling brcmf_chip_set_active().
> > 
> > I started to look at moving the sdio_{claim,release}_host() calls out of
> > brcmf_sdiod_ramrw() but there's a fair number of callers, so I'd like to
> > get feedback about the best course of action here.
> 
> Long ago Franky reworked the sdio critical sections requiring sdio
> claim/release and I am pretty sure they are correct.
> 
> Could you try with lockdep kernel and see if that brings any more
> information. In the mean time I will update my dev branch to 5.2-rc1 and see
> if I can find any clues.

My .config has CONFIG_LOCKDEP_SUPPORT enabled. I haven't used lockdep
but my understanding is that it should print something in dmesg if a
deadlock occurs. I assume it won't pick up cases like this where
schedule() is called.

Brian

--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-troubleshoot-broadcom-wireless-lockup-in-5.2rc1.patch"

From 496c4deaa3787bf619baff58493142e11cd6757f Mon Sep 17 00:00:00 2001
From: Brian Masney <masneyb@onstation.org>
Date: Sun, 26 May 2019 15:36:40 -0400
Subject: [PATCH] troubleshoot broadcom wireless lockup in 5.2rc1

Signed-off-by: Brian Masney <masneyb@onstation.org>
---
 drivers/mmc/core/core.c                       | 15 ++++
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 32 ++++---
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 85 ++++++++++++-------
 include/linux/mmc/host.h                      |  1 +
 4 files changed, 93 insertions(+), 40 deletions(-)

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
index 60aede5abb4d..aa947fcea736 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -47,6 +47,8 @@
 #include "sdio.h"
 #include "core.h"
 #include "common.h"
+#include "../../../../../mmc/core/host.h"
+#include "../../../../../mmc/core/core.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
@@ -59,6 +61,16 @@
 
 #define BRCMF_DEFAULT_RXGLOM_SIZE	32  /* max rx frames in glom chain */
 
+static void sdio_claim_host_with_descr(struct sdio_func *func,
+				       const char *descr)
+{
+	struct mmc_ctx mmc_ctx;
+
+	mmc_ctx.task = NULL;
+	mmc_ctx.descr = descr;
+	__mmc_claim_host(func->card->host, &mmc_ctx, NULL);
+}
+
 struct brcmf_sdiod_freezer {
 	atomic_t freezing;
 	atomic_t thread_count;
@@ -132,7 +144,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		}
 		sdiodev->irq_wake = true;
 
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host_with_descr(sdiodev->func1, __func__);
 
 		if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
 			/* assign GPIO to SDIO core */
@@ -162,7 +174,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		sdio_release_host(sdiodev->func1);
 	} else {
 		brcmf_dbg(SDIO, "Entering\n");
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host_with_descr(sdiodev->func1, __func__);
 		sdio_claim_irq(sdiodev->func1, brcmf_sdiod_ib_irqhandler);
 		sdio_claim_irq(sdiodev->func2, brcmf_sdiod_dummy_irqhandler);
 		sdio_release_host(sdiodev->func1);
@@ -183,7 +195,7 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		struct brcmfmac_sdio_pd *pdata;
 
 		pdata = &sdiodev->settings->bus.sdio;
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host_with_descr(sdiodev->func1, __func__);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
 		sdio_release_host(sdiodev->func1);
@@ -199,7 +211,7 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	if (sdiodev->sd_irq_requested) {
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host_with_descr(sdiodev->func1, __func__);
 		sdio_release_irq(sdiodev->func2);
 		sdio_release_irq(sdiodev->func1);
 		sdio_release_host(sdiodev->func1);
@@ -695,7 +707,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	else
 		dsize = size;
 
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 
 	/* Do the transfer(s) */
 	while (size) {
@@ -827,7 +839,7 @@ static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_trigger_dpc(sdiodev->bus);
 	wait_event(sdiodev->freezer->thread_freeze,
 		   atomic_read(expect) == sdiodev->freezer->frozen_count);
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 	res = brcmf_sdio_sleep(sdiodev->bus, true);
 	sdio_release_host(sdiodev->func1);
 	return res;
@@ -835,7 +847,7 @@ static int brcmf_sdiod_freezer_on(struct brcmf_sdio_dev *sdiodev)
 
 static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 {
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 	brcmf_sdio_sleep(sdiodev->bus, false);
 	sdio_release_host(sdiodev->func1);
 	atomic_set(&sdiodev->freezer->freezing, 0);
@@ -887,12 +899,12 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdiod_freezer_detach(sdiodev);
 
 	/* Disable Function 2 */
-	sdio_claim_host(sdiodev->func2);
+	sdio_claim_host_with_descr(sdiodev->func2, __func__);
 	sdio_disable_func(sdiodev->func2);
 	sdio_release_host(sdiodev->func2);
 
 	/* Disable Function 1 */
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 	sdio_disable_func(sdiodev->func1);
 	sdio_release_host(sdiodev->func1);
 
@@ -915,7 +927,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret = 0;
 
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 
 	ret = sdio_set_block_size(sdiodev->func1, SDIO_FUNC1_BLOCKSIZE);
 	if (ret) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 22b73da42822..31acdb347e59 100644
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
@@ -651,6 +653,16 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
 };
 
+static void sdio_claim_host_with_descr(struct sdio_func *func,
+				       const char *descr)
+{
+	struct mmc_ctx mmc_ctx;
+
+	mmc_ctx.task = NULL;
+	mmc_ctx.descr = descr;
+	__mmc_claim_host(func->card->host, &mmc_ctx, NULL);
+}
+
 static void pkt_align(struct sk_buff *p, int len, int align)
 {
 	uint datalign;
@@ -995,7 +1007,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/*
@@ -1583,7 +1595,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		 * read directly into the chained packet, or allocate a large
 		 * packet and and copy into the chain.
 		 */
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
 						 &bus->glom, dlen);
 		sdio_release_host(bus->sdiodev->func1);
@@ -1594,7 +1606,8 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
@@ -1608,7 +1621,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
 		sdio_release_host(bus->sdiodev->func1);
@@ -1626,7 +1639,8 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
 						     BRCMF_SDIO_FT_SUB);
 			sdio_release_host(bus->sdiodev->func1);
@@ -1638,7 +1652,8 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		if (errcode) {
 			/* Terminate frame on error */
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
@@ -1849,7 +1864,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		rd->len_left = rd->len;
 		/* read header first for unknow frame length */
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 		if (!rd->len) {
 			ret = brcmf_sdiod_recv_buf(bus->sdiodev,
 						   bus->rxhdr, BRCMF_FIRSTREAD);
@@ -1916,7 +1931,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			brcmf_err("read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			brcmf_sdio_rxfail(bus, true,
 					    RETRYCHAN(rd->channel));
 			sdio_release_host(bus->sdiodev->func1);
@@ -1930,7 +1946,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		} else {
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
@@ -1963,7 +1980,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host_with_descr(bus->sdiodev->func1,
+							   __func__);
 				brcmf_sdio_rxfail(bus, false, true);
 				sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
@@ -1988,7 +2006,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			} else {
 				brcmf_err("%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host_with_descr(bus->sdiodev->func1,
+							   __func__);
 				brcmf_sdio_rxfail(bus, false, false);
 				sdio_release_host(bus->sdiodev->func1);
 			}
@@ -2267,7 +2286,7 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	if (ret)
 		goto done;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
@@ -2330,7 +2349,8 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr) {
 			/* Check device status, signal pending interrupt */
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			intstatus = brcmf_sdiod_readl(bus->sdiodev,
 						      intstat_addr, &ret);
 			sdio_release_host(bus->sdiodev->func1);
@@ -2442,7 +2462,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	}
 
 	if (sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-		sdio_claim_host(sdiodev->func1);
+		sdio_claim_host_with_descr(sdiodev->func1, __func__);
 
 		/* Enable clock for device interrupts */
 		brcmf_sdio_bus_sleep(bus, false, false);
@@ -2552,7 +2572,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	brcmf_dbg(SDIO, "Enter\n");
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 
 	/* If waiting for HTAVAIL, check status */
 	if (!bus->sr_enabled && bus->clkstate == CLK_PENDING) {
@@ -2658,7 +2678,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	if (bus->ctrl_frame_stat && (bus->clkstate == CLK_AVAIL) &&
 	    data_ok(bus)) {
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 		if (bus->ctrl_frame_stat) {
 			err = brcmf_sdio_tx_ctrlframe(bus,  bus->ctrl_frame_buf,
 						      bus->ctrl_frame_len);
@@ -2682,7 +2702,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			if (bus->ctrl_frame_stat) {
 				bus->ctrl_frame_err = -ENODEV;
 				wmb();
@@ -2904,7 +2925,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 					 CTL_DONE_TIMEOUT);
 	ret = 0;
 	if (bus->ctrl_frame_stat) {
-		sdio_claim_host(bus->sdiodev->func1);
+		sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 		if (bus->ctrl_frame_stat) {
 			brcmf_dbg(SDIO, "ctrl_frame timeout\n");
 			bus->ctrl_frame_stat = false;
@@ -3048,7 +3069,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 		return 0;
 	}
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 	if (sh->assert_file_addr != 0) {
 		error = brcmf_sdiod_ramrw(bus->sdiodev, false,
 					  sh->assert_file_addr, (u8 *)file, 80);
@@ -3340,7 +3361,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	int bcmerror;
 	u32 rstvec;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	rstvec = get_unaligned_le32(fw->data);
@@ -3564,7 +3585,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 
 	address = bus->ci->rambase;
 	offset = err = 0;
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 	while (offset < mem_size) {
 		len = ((offset + MEMBLOCK) < mem_size) ? MEMBLOCK :
 		      mem_size - offset;
@@ -3637,7 +3658,8 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (!bus->dpc_triggered) {
 				u8 devpend;
 
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host_with_descr(bus->sdiodev->func1,
+							   __func__);
 				devpend = brcmf_sdiod_func0_rb(bus->sdiodev,
 						  SDIO_CCCR_INTx, NULL);
 				sdio_release_host(bus->sdiodev->func1);
@@ -3666,7 +3688,8 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 		bus->console.count += jiffies_to_msecs(BRCMF_WD_POLL);
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
-			sdio_claim_host(bus->sdiodev->func1);
+			sdio_claim_host_with_descr(bus->sdiodev->func1,
+						   __func__);
 			/* Make sure backplane clock is on */
 			brcmf_sdio_bus_sleep(bus, false, false);
 			if (brcmf_sdio_readconsole(bus) < 0)
@@ -3685,7 +3708,8 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			bus->idlecount++;
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host_with_descr(bus->sdiodev->func1,
+							   __func__);
 				brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
@@ -3903,7 +3927,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	u32 drivestrength;
 
 	sdiodev = bus->sdiodev;
-	sdio_claim_host(sdiodev->func1);
+	sdio_claim_host_with_descr(sdiodev->func1, __func__);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
 		 brcmf_sdiod_readl(sdiodev, SI_ENUM_BASE, NULL));
@@ -4147,7 +4171,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdio_wd_timer(bus, true);
 
-	sdio_claim_host(sdiod->func1);
+	sdio_claim_host_with_descr(sdiod->func1, __func__);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
@@ -4255,7 +4279,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	err = brcmf_attach(sdiod->dev, sdiod->settings);
 	if (err != 0) {
 		brcmf_err("brcmf_attach failed\n");
-		sdio_claim_host(sdiod->func1);
+		sdio_claim_host_with_descr(sdiod->func1, __func__);
 		goto checkdied;
 	}
 
@@ -4361,7 +4385,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	sdio_disable_func(bus->sdiodev->func2);
@@ -4428,7 +4452,8 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 
 		if (bus->ci) {
 			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
-				sdio_claim_host(bus->sdiodev->func1);
+				sdio_claim_host_with_descr(bus->sdiodev->func1,
+							   __func__);
 				brcmf_sdio_wd_timer(bus, false);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4485,7 +4510,7 @@ int brcmf_sdio_sleep(struct brcmf_sdio *bus, bool sleep)
 {
 	int ret;
 
-	sdio_claim_host(bus->sdiodev->func1);
+	sdio_claim_host_with_descr(bus->sdiodev->func1, __func__);
 	ret = brcmf_sdio_bus_sleep(bus, sleep, false);
 	sdio_release_host(bus->sdiodev->func1);
 
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


--SLDf9lqlvOQaIe6s--
