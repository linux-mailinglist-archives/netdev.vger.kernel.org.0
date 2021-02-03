Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7E30DD39
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhBCOua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhBCOuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 09:50:24 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D298EC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 06:49:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b9so16604574ejy.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CmTJn2HIv4rmFGOduYDN/dPmqnJgnI6sG4UukIxnbMo=;
        b=W44GrDW+19gnNpJbH5rgwdMzf4j5uS5l18ImmzPp+02QazKvT7gJJZbw50NDl51ib6
         rtJii8xyYdlZHm+emPaU54+OyN6A/a4Id9NxEY/nfk3HATEMUFzCSETyRY8oE0b25+bd
         2EAaxXzgnnzd7k5wb/ImvF5nPSHdsOm9o/IntRGOiM596YK1FECg5JHvLsvyNGaVQM8d
         jSKhqZV/Qyk0QeeRnWl5Ry1AbgaEHUZrF9bpGuDb2akEQ1QbD+3Ycyj2yvgbXjrkGkUK
         EYiDiqDEFh8DF51POxuZHYtXqLZpPmYBabnTeLrp2NaXQieJh27h7REdaENl7HApATQh
         rQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CmTJn2HIv4rmFGOduYDN/dPmqnJgnI6sG4UukIxnbMo=;
        b=kgTLdUuOSVjtNN4+NO4DikhSx+4n4ohIW/D5kRD9EugGNeJkiUvvIY9de0xV6ItkCn
         JCB+DNpLwylCqc0eiMyMUFMOsAKAAeks0YbIZmLO8J8YZzO2iRQdA3AIlRpd+v6AgM61
         BZK+2r8GowTdwPMcJqXXgtuzmIMZJre11F0tFLuWIxEQt/9dDFWGBeB51Lt0iXzmuFl7
         wy7qrBc7ug2pcxHXnfUKqFe2YfV36NyR3XXRUQqw7q2LdUeIdRAhY8puySiwusuUuiSu
         UNjR/w5I1w+jxQb5l7oe3kLgF/US+LQIEd5VAJcMvndO95I+tzaIG5hgpcDKwJTRZIY8
         a92Q==
X-Gm-Message-State: AOAM530AqohGwABjbJmcufISo510hqw5k5t260dLhWSWBUU0qBAXYRQ9
        5vHiKavZ2JuDiYdPY89NV4fdthRIUAtyrJbvCzxtwlxnYzA=
X-Google-Smtp-Source: ABdhPJy77HWB2Sg5Nz3X3FRpdaoHwR+6exaI3ykIl87tYg91/LVNW/Jfk0JN1yw8QFDAZsv46WeDFOKlCpr1oyfzNL8=
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr3562883ejk.510.1612363782562;
 Wed, 03 Feb 2021 06:49:42 -0800 (PST)
MIME-Version: 1.0
References: <1612358476-19556-1-git-send-email-loic.poulain@linaro.org>
 <1612358476-19556-2-git-send-email-loic.poulain@linaro.org> <CA+FuTSfw0wWmpY27BVMxtKL3moL+X+rq27DJuJKi7-OkLwJxwA@mail.gmail.com>
In-Reply-To: <CA+FuTSfw0wWmpY27BVMxtKL3moL+X+rq27DJuJKi7-OkLwJxwA@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 3 Feb 2021 15:56:50 +0100
Message-ID: <CAMZdPi8CPrWvLCnxoaA_f1cUcu=amvSjFb5BVFrG4X1DSCrthg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: qualcomm: rmnet: Fix rx_handler for
 non-linear skbs
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 at 15:04, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Feb 3, 2021 at 8:17 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> >
> > There is no guarantee that rmnet rx_handler is only fed with linear
> > skbs, but current rmnet implementation does not check that, leading
> > to crash in case of non linear skbs processed as linear ones.
> >
> > Fix that by ensuring skb linearization before processing.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> > ---
> >  v2: Add this patch to the series to prevent crash
> >  v3: no change
> >
> >  drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > index 3d7d3ab..2776c32 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > @@ -180,7 +180,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
> >         struct rmnet_port *port;
> >         struct net_device *dev;
> >
> > -       if (!skb)
> > +       if (!skb || skb_linearize(skb))
> >                 goto done;
>
> Actually, if skb_linearize fails, the skb must be freed.

Ouch, you're right.

Regards,
Loic
