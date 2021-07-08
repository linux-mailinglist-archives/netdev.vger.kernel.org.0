Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76D43C171E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhGHQfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 12:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGHQff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 12:35:35 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D4C061574;
        Thu,  8 Jul 2021 09:32:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hc16so10678743ejc.12;
        Thu, 08 Jul 2021 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SmfIYM5BRkji+jZAJLgenybRhJU94k7ZQe/cqcnKgms=;
        b=FP14kL3fdUgJAH6v65YadStbB2zN/e3gLf7/EUWlhxLGV64Z+RyK198tzOjx/Q9A6h
         r/KaNRUqVBm0h3RZsTFeJNgmZhlT2aozJ8FNGTWWoNj69uTufncWkogkxVLC4F08JWhJ
         YYk3JLQmTe06JCoPJj3tSSIiBqZXtxpcGtqlEac6AAh6Vaim83ufECs4kW1uSrBjbUjz
         LYyHcvq3NeQ675G9EVqvwZZaYyfaTx50V8dUqwR+eqDy80/ofVLLAoYHuDIonlO+ASpF
         SUZ0+rpYxvm9jCb9vTfv+V+ccLSIoQQzSkeEWuyDEZJJAkxXnDyd6v7BiHis+T6yK5YS
         NI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SmfIYM5BRkji+jZAJLgenybRhJU94k7ZQe/cqcnKgms=;
        b=SRgMh3yHfsxpJkThMCmVN/TrT/M4Q6UcG7HDhGzHV70CG4dyFKjhSeZki/rWvRA8w9
         RrEyNZPurf6k5tPTfOdVFWjK0gd7y8jAveee647dfM5npxQ0LcIqxVmXs8rIWAgAixtu
         Dnh2p+CCRGnCWkj4yf+UAYvvvanbafHlP7kNuMNP8AOoEuXCFsvxP+icea0rCg2wKRZa
         2VgXFlLExHqySSU99fYZQydzD1LvrEIgMDZdTPtWTeUX92DNK/IxgdHCS3wx+tSzuhTw
         OmEki9AiEEcGNcGxJp0KCiN6iIxaxPY/h+n0u/cTZR+9bSUDUZFhKfZoC+JsbD5zPlKg
         X9zA==
X-Gm-Message-State: AOAM531TF0/jvafHWV5KcA5rStWnOuhXO6vCOtfHWHQxf/uw0mL1BbJf
        WSX9DwJQ4vHvRHzcN6FED7SH7XOZSj7rLsB+B20=
X-Google-Smtp-Source: ABdhPJx6duJdlx347N4ban/5Kj6JjSyV5GciMQ83+NRL0e5PGGz5TkZD1KRg4LFiHCmQbdn1oFnG26wBq3O+uV5yq44=
X-Received: by 2002:a17:907:1ca4:: with SMTP id nb36mr31605407ejc.33.1625761972040;
 Thu, 08 Jul 2021 09:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210708162449.98764-1-ilias.apalodimas@linaro.org> <CAC_iWjLsd-hJs1gk3CknJFXb2H4aAeEUUUskzPEugeRHjRuWLg@mail.gmail.com>
In-Reply-To: <CAC_iWjLsd-hJs1gk3CknJFXb2H4aAeEUUUskzPEugeRHjRuWLg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Jul 2021 09:32:41 -0700
Message-ID: <CAKgT0Ue5De_iG4SBTm-DxzZir-2UfXpq7CohayNtWXqh=0Qq=Q@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a potential race while recycling page_pool packets
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 9:31 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> +cc Alexander on his gmail address since the Intel one bounced.
>
> Alexander want me to respin it with you gmail address on the Reported-by?
>
> Sorry for the noise
> /Ilias
>
> On Thu, 8 Jul 2021 at 19:24, Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > As Alexander points out, when we are trying to recycle a cloned/expanded
> > SKB we might trigger a race.  The recycling code relies on the
> > pp_recycle bit to trigger,  which we carry that over to cloned SKBs.
> > When that cloned SKB gets expanded,  we are creating 2 separate instances
> > accessing the page frags.  Since the skb_release_data() will first try to
> > recycle the frags,  there's a potential race between the original and
> > cloned SKB.
> >
> > Fix this by explicitly making the cloned/expanded SKB not recyclable.
> > If the original SKB is freed first the pages are released.
> > If it is released after the clone/expended skb then it can still be
> > recycled.
> >
> > Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> > Reported-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> >  net/core/skbuff.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12aabcda6db2..0cb53c05ed76 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -1718,6 +1718,13 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> >         }
> >         off = (data + nhead) - skb->head;
> >
> > +       /* If it's a cloned skb we expand with frags attached we must prohibit
> > +        * the recycling code from running, otherwise we might trigger a race
> > +        * while trying to recycle the fragments from the original and cloned
> > +        * skb
> > +        */
> > +       if (skb_cloned(skb))
> > +               skb->pp_recycle = 0;
> >         skb->head     = data;
> >         skb->head_frag = 0;
> >         skb->data    += off;

Yeah, I would recommend a respin.

Also I would move this line up to the skb_cloned block just a few
lines before this spot just to avoid a second check.
