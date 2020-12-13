Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC41C2D8F88
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 19:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405072AbgLMSqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 13:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404978AbgLMSqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 13:46:05 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712B5C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:45:09 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id y19so24587375lfa.13
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BcLd2eTMUQnWTe1iSx4OMGuFlGDBW9OQlhSlZiNkXtY=;
        b=S0UFrA2SiiXTUKQvFPhNSeMERL22Ktxp5KkJbZuLAyZnLHHVbYuhIeOFdkUvQjqhM+
         SgBcaWJVxYfm6oijCl5QeAZKYY3uqf4tOpJOeKtiyXCQsYPbb5zuXQ5qf2QSQgx/OFvF
         O0oR9utGEJwmj48uPpQPRv8rNyJ291j0a34+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BcLd2eTMUQnWTe1iSx4OMGuFlGDBW9OQlhSlZiNkXtY=;
        b=gJ0F4YwiCxPMq8hhNoCaV7McYBVQVyy+0EyRgoaRw2XSkFTGXMDDIAIsYQzgOIlavG
         1wBHdujc3BBG60cf02mgeTKwfGdVqFjqu6Gg94vWoTLWe1wToXX//H6FwNmhwKAWtIEF
         9/lkvhG80MSBypaBHp32Bq2BkDsxI8ygtoqxoYHA0rxXQ/Q2QA+gwjLvHUHaBRsnH1N1
         YBMM6EdGl5e4NMZTzwuCbArxuHoAT/ZPdy7Ts2rb714vQ6MfNp8H3kFJJ2AfB0nQ4g8n
         dYJdlI+j27lNguLAsaxBDZU+SdMmNnANCdL+w65kfCY4GXADb7D4Y3VJ2m6N4mUQcg9o
         eOWw==
X-Gm-Message-State: AOAM5334KTe1m6Bi5O+g9Z7WCqmHBrRYqlBxbiQ106RtqKcC0SUmZx4u
        CiHgyCiklndSqsWHv46LSM4TWGECQkol5YPpiJ8kiPIKleTxNg==
X-Google-Smtp-Source: ABdhPJy1YJ/dKTescrTDhY4aBPVAhK2GOQm4jFEhlrXsYLooMmor6KkFIwYVbViDfSJU6oWAq0jxw4U/AU0uorvboa4=
X-Received: by 2002:a05:651c:2105:: with SMTP id a5mr9054508ljq.170.1607885107811;
 Sun, 13 Dec 2020 10:45:07 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
 <20201213122305.kpg5tb6dppq3ow42@gmail.com>
In-Reply-To: <20201213122305.kpg5tb6dppq3ow42@gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Sun, 13 Dec 2020 10:44:56 -0800
Message-ID: <CABWYdi1VWaOOhOx6wOAd0DjSXMGaPvL_x6d=M0jtX15naecBWA@mail.gmail.com>
Subject: Re: [PATCH net-next] sfc: backport XDP EV queue sharing from the
 out-of-tree driver
To:     Ivan Babrou <ivan@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 4:23 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
>
> On Thu, Dec 10, 2020 at 04:18:53PM -0800, Ivan Babrou wrote:
> > Queue sharing behaviour already exists in the out-of-tree sfc driver,
> > available under xdp_alloc_tx_resources module parameter.
>
> This comment is not relevant for in-tree patches. I'd also like to
> make clear that we never intend to upstream any module parameters.

Would the following commit message be acceptable?

sfc: reduce the number of requested xdp ev queues

Without this change the driver tries to allocate too many queues,
breaching the number of available msi-x interrupts on machines
with many logical cpus and default adapter settings:

Insufficient resources for 12 XDP event queues (24 other channels, max 32)

Which in turn triggers EINVAL on XDP processing:

sfc 0000:86:00.0 ext0: XDP TX failed (-22)

> > This avoids the following issue on machines with many cpus:
> >
> > Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> >
> > Which in turn triggers EINVAL on XDP processing:
> >
> > sfc 0000:86:00.0 ext0: XDP TX failed (-22)
>
> The code changes themselves are good.
> The real limit that is hit here is with the number of MSI-X interrupts.
> Reducing the number of event queues needed also reduces the number of
> interrupts required, so this is a good thing.
> Another way to get around this issue is to increase the number of
> MSI-X interrupts allowed bu the NIC using the sfboot tool.

I've tried that, but on 5.10-rc7 with the in-tree driver both ethtool -l
and sfboot are unable to work for some reason with sfc adapter.

The docs about the setting itself says you need to contact support
to figure out the right values to use to make sure it works properly.

What is your overall verdict on the patch? Should it be in the kernel
or should users change msix-limit configuration? The configuration
change requires breaking pcie lockdown measures as well, which is
why I'd prefer for things to work out of the box.

Thanks!

>
> Best regards,
> Martin
>
> > Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> > ---
> >  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/efx_channels.c
> > b/drivers/net/ethernet/sfc/efx_channels.c
> > index a4a626e9cd9a..1bfeee283ea9 100644
> > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > @@ -17,6 +17,7 @@
> >  #include "rx_common.h"
> >  #include "nic.h"
> >  #include "sriov.h"
> > +#include "workarounds.h"
> >
> >  /* This is the first interrupt mode to try out of:
> >   * 0 => MSI-X
> > @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> >  {
> >   unsigned int n_channels = parallelism;
> >   int vec_count;
> > + int tx_per_ev;
> >   int n_xdp_tx;
> >   int n_xdp_ev;
> >
> > @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> >   * multiple tx queues, assuming tx and ev queues are both
> >   * maximum size.
> >   */
> > -
> > + tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
> >   n_xdp_tx = num_possible_cpus();
> > - n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> > + n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
> >
> >   vec_count = pci_msix_vec_count(efx->pci_dev);
> >   if (vec_count < 0)
> > --
> > 2.29.2
>
> --
> Martin Habets <habetsm.xilinx@gmail.com>
