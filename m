Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8836A2B5BD
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfE0Mu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:50:27 -0400
Received: from onstation.org ([52.200.56.107]:36804 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0Mu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 08:50:27 -0400
Received: from localhost (c-98-239-145-235.hsd1.wv.comcast.net [98.239.145.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: masneyb)
        by onstation.org (Postfix) with ESMTPSA id 6DA123E8DE;
        Mon, 27 May 2019 12:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onstation.org;
        s=default; t=1558961426;
        bh=jTtzWSOIGKn0fkQo40d1XpoMwyOF6Fujvlz+J+wVGrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+c4wVstJrtVTNZHM5dBbtBD9KNkr7WRbF2I7N7juKzi4/JKRyvNseklTpSauSpWB
         cRmbY632ruZkf7ziPB+HEQ267L0rg5bMYnijg0fKSF0WebnFvC8mk7OuS+SYxZMD2y
         /h/c1EAvSxZDDNC1lYbtjjVxAYJU7g5YBkxzSINQ=
Date:   Mon, 27 May 2019 08:50:26 -0400
From:   Brian Masney <masneyb@onstation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
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
Message-ID: <20190527125026.GA4272@basecamp>
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp>
 <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
 <20190526195819.GA29665@basecamp>
 <20190527093711.GA853@basecamp>
 <ead7f268-b730-3541-31f7-4499556efec0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead7f268-b730-3541-31f7-4499556efec0@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 03:08:07PM +0300, Adrian Hunter wrote:
> On 27/05/19 12:37 PM, Brian Masney wrote:
> > On Sun, May 26, 2019 at 03:58:19PM -0400, Brian Masney wrote:
> >> I attached a patch that shows how I was able to determine what had
> >> already claimed the host.
> > On Mon, May 27, 2019 at 10:48:24AM +0300, Adrian Hunter wrote:
> >> This is because SDHCI is using the IRQ thread to process the SDIO card
> >> interrupt (sdio_run_irqs()).  When the card driver tries to use the card, it
> >> causes interrupts which deadlocks since c07a48c26519 ("mmc: sdhci: Remove
> >> finish_tasklet") has moved the tasklet processing to the IRQ thread.
> >>
> >> I would expect to be able to use the IRQ thread to complete requests, and it
> >> is desirable to do so because it is lower latency.
> >>
> >> Probably, SDHCI should use sdio_signal_irq() which queues a work item, and
> >> is what other drivers are doing.
> >>
> >> I will investigate some more and send a patch.
> 
> Please try the patch below:
> 
> From: Adrian Hunter <adrian.hunter@intel.com>
> Date: Mon, 27 May 2019 14:45:55 +0300
> Subject: [PATCH] mmc: sdhci: Fix SDIO IRQ thread deadlock
> 
> Since commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet"), the IRQ
> thread might be used to complete requests, but the IRQ thread is also used
> to process SDIO card interrupts. This can cause a deadlock when the SDIO
> processing tries to access the card since that would also require the IRQ
> thread. Change SDHCI to use sdio_signal_irq() to schedule a work item
> instead. That also requires implementing the ->ack_sdio_irq() mmc host op.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")

Yes, this fixes the issue for me. You can add my:

Reported-by: Brian Masney <masneyb@onstation.org>
Tested-by: Brian Masney <masneyb@onstation.org>

Thanks,

Brian
