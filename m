Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831193C9C49
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240873AbhGOKDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbhGOKDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:03:39 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD123C061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 03:00:45 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id p22so8115554yba.7
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 03:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLbz9Om8YwfCedcIibToMxrf3a5LzyV5p0V0SRKWaOE=;
        b=NYQjawfLIf9gL9Sic9FgZzcxVAnjibSHyOgm2MN+ZpERD41dML7PynkJm605Vn9xsZ
         stN6ACVBVwMJtlRSbHTY8H2hRSnlcHaHt5Twl7b9TMMUlMjJDWl4eNqzcNWYJKg6UOVP
         K+y6lwx61HQnp08s73+zWywYd92QT9PgBDTzsVCslhcXkRvj6d8/V7okioWHKggct18j
         jGUpJOipWbe9gtBs8gy0gEl2XWekA2BJqjCYwjrXr+MltP9ZLyl7mH8zupVfPh/DhkEo
         xVhfhHEdXPTZY6FWrkpt77H2taPAOVzF35LR0wqRL5kIztUqzB/5PtRvJFfWo3siBH5T
         fQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLbz9Om8YwfCedcIibToMxrf3a5LzyV5p0V0SRKWaOE=;
        b=VXIFH+wN70mL8VW3d7FiLfF85QR9ckW5PhYKyg1DpiCoj1qqbc2r/pHy2XD0ixmt9E
         4/tYpUjiQmXn/Rjv0cSTAVIsLjHqXdKHjdNOisiRvD1YFSNFAFPANwU3Uu6OdNiI3VFl
         UnFHocSa5sGwXbBP59NTc0QZIWU9ixBGOCRmYHVZwg+fsUDFy/yjXG1gLRPFT4xvdg3W
         bbEz5kub7cbGQhI12pOqWzMGZPNAddGXNRaVvr1jYsD84FtCUYI9yVuOMTHn5M2Nb/eN
         1slA/2UXindITcEn0fAs7rAkXoYIUVbMK5qE1jY6gud2ozl+jXZjLLmdampLrL0feGgH
         w3iQ==
X-Gm-Message-State: AOAM531y7PVGtDM0zRdRs1GqFmRatBU1JXHixU7S3ZjHqrwQN/BejgFD
        WEZiRTZrrNPlFIWYFffsPMgwfEzQVPUrVLvbwimqlQ==
X-Google-Smtp-Source: ABdhPJwOl8WPscJsIj8FQ4n+aUxrTWZzSpZGzrTRgrQVmhISzgToZEb6pOBgmY3unbllE6yBnAH7m2RMl1RYHq4fA5g=
X-Received: by 2002:a25:2589:: with SMTP id l131mr4326897ybl.259.1626343244886;
 Thu, 15 Jul 2021 03:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org> <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
In-Reply-To: <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 15 Jul 2021 13:00:08 +0300
Message-ID: <CAC_iWjLypqTGMxw_1ng1H8r5Yiv83G3yxUW8T1863XzFM-ShpA@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
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

On Thu, 15 Jul 2021 at 07:01, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/9 14:29, Ilias Apalodimas wrote:
> > As Alexander points out, when we are trying to recycle a cloned/expanded
> > SKB we might trigger a race.  The recycling code relies on the
> > pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> > If that cloned SKB gets expanded or if we get references to the frags,
> > call skbb_release_data() and overwrite skb->head, we are creating separate
> > instances accessing the same page frags.  Since the skb_release_data()
> > will first try to recycle the frags,  there's a potential race between
> > the original and cloned SKB, since both will have the pp_recycle bit set.
> >
> > Fix this by explicitly those SKBs not recyclable.
> > The atomic_sub_return effectively limits us to a single release case,
> > and when we are calling skb_release_data we are also releasing the
> > option to perform the recycling, or releasing the pages from the page pool.
> >
> > Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> > Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> > Changes since v1:
> > - Set the recycle bit to 0 during skb_release_data instead of the
> >   individual fucntions triggering the issue, in order to catch all
> >   cases
> >  net/core/skbuff.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12aabcda6db2..f91f09a824be 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
> >       if (skb->cloned &&
> >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >                             &shinfo->dataref))
> > -             return;
> > +             goto exit;
>
> Is it possible this patch may break the head frag page for the original skb,
> supposing it's head frag page is from the page pool and below change clears
> the pp_recycle for original skb, causing a page leaking for the page pool?
>

So this would leak eventually dma mapping if the skb is cloned (and
the dataref is now +1) and we are freeing the original skb first?

> >
> >       skb_zcopy_clear(skb, true);
> >
> > @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> >               kfree_skb_list(shinfo->frag_list);
> >
> >       skb_free_head(skb);
> > +exit:
> > +     skb->pp_recycle = 0;
> >  }
> >
> >  /*
> >
