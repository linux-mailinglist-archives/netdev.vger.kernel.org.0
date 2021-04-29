Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32936ECBE
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 16:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhD2Oup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 10:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbhD2Oun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 10:50:43 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83430C06138C
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:49:56 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c18so54293699iln.7
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMXBB0mtowmIq4BfuFowr4lSHLcPlY4SXVjJUp3YxqQ=;
        b=ptZl9o/GsGvjfGcKd+/unVlMS8Pp/LPv4ZnMUa7VuQSr0U97ajQTl207BKj8muGCSg
         yVZM/oq/aVXLeV5FIJHZMYLBpiHgMmTrXNDphaiLHFQpoxa0lWlLEBkdW6+QjJ/d765Z
         hy7s2LOoVHA5iyk4J4Yes27UHQtPYA1UXmzko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMXBB0mtowmIq4BfuFowr4lSHLcPlY4SXVjJUp3YxqQ=;
        b=CaEZSyHiRW0FpKzGTpA7bRLBdjf5wdmvhWyr7gyGKqJezTjDop8tI83AbAQgA4aMH4
         ATJu31xmcUbXVAItes6Nup4uL1cvmhJA+6ihyl+HdbH4z+KTcm8bj2c72+lkKJ6TDd/W
         e1yEzV+MeXLuy6/0J/7pHa96f9dcE8i39/lhvg1GylBlTSLTonSn8yD6IA6Ab//SXfka
         iM2/xxRQf5Kn3y8qJcubK2WkTZcB0m7/NkQEBIg50ag8Q/YgGNlYppQK4ydzCK0mR8yj
         xr4lnEXJZ8ZQaAeybnlyZymDfgpugOR11f+u/JvFVim2qIzY1xA79Fg+/y2+pvRS1T9E
         b7Ug==
X-Gm-Message-State: AOAM531ORvWu/62JeuxNEPWdlUrwnPZ22yDE2cx6ccte+kiQrhKvqIg9
        YAi1kohXzNGNAjB6QhbeXQVZewEKP2PU80ss7VB/Iw==
X-Google-Smtp-Source: ABdhPJwqvsA9WigFaKV6yePTdN9B5ArhsIWzBY55CUmGufPYQQx32uxU8AkpdYJ4ex0PyE34V5vunqkeGTKc5iaBCi4=
X-Received: by 2002:a92:320f:: with SMTP id z15mr55885ile.231.1619707795874;
 Thu, 29 Apr 2021 07:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210427210938.661700-1-ignat@cloudflare.com> <a56546ee-87a1-f13d-8b2f-25497828f299@gmail.com>
In-Reply-To: <a56546ee-87a1-f13d-8b2f-25497828f299@gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Thu, 29 Apr 2021 15:49:45 +0100
Message-ID: <CALrw=nF+rD+GdWAZndKGxTW4cpao+x2W0dvDfUacXjD=A5mCKA@mail.gmail.com>
Subject: Re: [PATCH] sfc: adjust efx->xdp_tx_queue_count with the real number
 of initialized queues
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     habetsm.xilinx@gmail.com, "David S. Miller" <davem@davemloft.net>,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 3:22 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
>
> On 27/04/2021 22:09, Ignat Korchagin wrote:
> > efx->xdp_tx_queue_count is initially initialized to num_possible_cpus() and is
> > later used to allocate and traverse efx->xdp_tx_queues lookup array. However,
> > we may end up not initializing all the array slots with real queues during
> > probing. This results, for example, in a NULL pointer dereference, when running
> > "# ethtool -S <iface>", similar to below
> ...
> > diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> > index 1bfeee283ea9..a3ca406a3561 100644
> > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > @@ -914,6 +914,8 @@ int efx_set_channels(struct efx_nic *efx)
> >                       }
> >               }
> >       }
> > +     if (xdp_queue_number)
> Wait, why is this guard condition needed?
> What happens if we had nonzero efx->xdp_tx_queue_count initially, but we end up
>  with no TXQs available for XDP at all (so xdp_queue_number == 0)?
>
> -ed

My thoughts were: efx->xdp_tx_queue_count is originally used to
allocate efx->xdp_tx_queues.
So, if xdp_queue_number ends up being 0, we should keep
efx->xdp_tx_queue_count positive not
to forget to release efx->xdp_tx_queues (because most checks are
efx->xdp_tx_queue_count && efx->xdp_tx_queues).

I'm not familiar enough with SFC internals to definitely say if it is
even possible to have
xdp_queue_number == 0 while having efx->xdp_tx_queue_count > 0, but my
understanding is that
it should not be possible due to the checks in the driver init path,
when we actually determine the number
of queues, channels, events per channel etc.

Ignat

> > +             efx->xdp_tx_queue_count = xdp_queue_number;
> >
> >       rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
> >       if (rc)
> >
>
