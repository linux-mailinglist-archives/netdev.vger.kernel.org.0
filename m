Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04C92A998
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEZMVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:21:38 -0400
Received: from onstation.org ([52.200.56.107]:34294 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfEZMVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 08:21:38 -0400
Received: from localhost (c-98-239-145-235.hsd1.wv.comcast.net [98.239.145.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: masneyb)
        by onstation.org (Postfix) with ESMTPSA id 3D8283E8DE;
        Sun, 26 May 2019 12:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onstation.org;
        s=default; t=1558873297;
        bh=+pZchRi39jPHP0qQqNkASaPmePyovKRsrhb/epkA3O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3WM8l28X85rNtXbObGWCc0HVfSkpKpZ4nzWbVIS8dppFuFhg/AlCGbCqvRRNgC8a
         e8Cj3LHOIuzlbWyJrije+DpG8X8yUbh2/xsmoKgL+auQ0VxtR7cWL3ZJjUe3uPZXTe
         TgOkNqLbnLUq7YQEo1PjCt7ljwsFbS4hgb/UxgmI=
Date:   Sun, 26 May 2019 08:21:36 -0400
From:   Brian Masney <masneyb@onstation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     ulf.hansson@linaro.org, faiz_abbas@ti.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc: sdhci:
 queue work after sdhci_defer_done())
Message-ID: <20190526122136.GA26456@basecamp>
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524154958.GB16322@basecamp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Broadcom wireless maintainers

On Fri, May 24, 2019 at 11:49:58AM -0400, Brian Masney wrote:
> On Fri, May 24, 2019 at 03:17:13PM +0300, Adrian Hunter wrote:
> > On 24/05/19 2:10 PM, Brian Masney wrote:
> > > WiFi stopped working on the LG Nexus 5 phone and the issue was bisected
> > > to the commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet") that
> > > moved from using a tasklet to a work queue. That patch also changed
> > > sdhci_irq() to return IRQ_WAKE_THREAD instead of finishing the work when
> > > sdhci_defer_done() is true. Change it to queue work to the complete work
> > > queue if sdhci_defer_done() is true so that the functionality is
> > > equilivent to what was there when the finish_tasklet was present. This
> > > corrects the WiFi breakage on the Nexus 5 phone.
> > > 
> > > Signed-off-by: Brian Masney <masneyb@onstation.org>
> > > Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
> > > ---
> > > [ ... ]
> > > 
> > >  drivers/mmc/host/sdhci.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > > index 97158344b862..3563c3bc57c9 100644
> > > --- a/drivers/mmc/host/sdhci.c
> > > +++ b/drivers/mmc/host/sdhci.c
> > > @@ -3115,7 +3115,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
> > >  			continue;
> > >  
> > >  		if (sdhci_defer_done(host, mrq)) {
> > > -			result = IRQ_WAKE_THREAD;
> > > +			queue_work(host->complete_wq, &host->complete_work);
> > 
> > The IRQ thread has a lot less latency than the work queue, which is why it
> > is done that way.
> > 
> > I am not sure why you say this change is equivalent to what was there
> > before, nor why it fixes your problem.
> > 
> > Can you explain some more?
>
> [ ... ]
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
> sdio_claim_host() and it appears to never return.

When the brcmfmac driver is loaded, the firmware is requested from disk,
and that's when the deadlock occurs in 5.2rc1. Specifically:

1) brcmf_sdio_download_firmware() in
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
   sdio_claim_host()

2) brcmf_sdio_firmware_callback() is called and brcmf_sdiod_ramrw()
   tries to claim the host, but has to wait since its already claimed
   in #1 and the deadlock occurs.

I tried to release the host before the firmware is requested, however
parts of brcmf_chip_set_active() needs the host to be claimed, and a
similar deadlock occurs in brcmf_sdiod_ramrw() if I claim the host
before calling brcmf_chip_set_active().

I started to look at moving the sdio_{claim,release}_host() calls out of
brcmf_sdiod_ramrw() but there's a fair number of callers, so I'd like to
get feedback about the best course of action here.

Brian
