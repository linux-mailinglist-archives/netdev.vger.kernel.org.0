Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7C73C9CF4
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbhGOKlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbhGOKli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:41:38 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0968C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 03:38:45 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id y38so8306491ybi.1
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 03:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XFYcji550HYtqpGml52HF9Ker4jPqPp7oBMbaMj4XAw=;
        b=Q5c/Ai4GgArz4t67eHsHrrkbmuwf2BtOsrIrY95J4QgKeP+4J+aPiw3TdTuERQXh7a
         DXN7QD6MbjQ9Yogq+LCTo8ePKlu95ChrQSPQ3IE9qk0LtTkdSAKtGiE737u7gMm6/yVk
         LfeQlg0eTEmjOTLf7UO+ZPQStqdAtKv06w3WxKzqp/CoGLVz+sgtDPWaA4RpZprwplYT
         rhcfrbZBHloYZ87sJ2rPGIN4+AXKWFhfZche+6WJVkZqrIdZKOGGn829WoebmhL0l4rc
         Du5wIm32cNEbaltkeFkfh7TI79sptxwxDY9w5H73uF3TFjh62KMDKWIyqtNiFkt6C3Ru
         hcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XFYcji550HYtqpGml52HF9Ker4jPqPp7oBMbaMj4XAw=;
        b=WpTGc+fPVyBOF2brZJwfuXIfTo9ZsVBlOGyqHVYOgaj/UwZ/86RlqgeOrDOl0mQIrX
         rVN1Vj/HHrAO+PadZJ7ny0AIHpw8JWh9vtdhgBt6t4rvJIuDGv51/MTfgU8ZzLD8lmtX
         KBcrzAJqiHR/LktN15rK0/+M4NUmppCIANPMB9E+zsntt5nyk5SkHOHq69XvpPBXDqdL
         PZ25eCUnXbero0OwWoiVcyYpxL+WdIfnJcx3Rrnby97jivBu1wRhZP5LBIBBx8dnC/yu
         Pas6rZF4Q5KOmrC6H4PfhdpqDz+mHAc3Ucp7CGvOQ83xNGuEwwXQ3MaNENnnY/En1fbs
         QL1w==
X-Gm-Message-State: AOAM530SL/Tp83xCNry9/Hz4ehw05G+/UtOCXI8MRioRNUxlwbY6V/kE
        nh+sAAcDMEGc8kEmgl+KsjWXTtzSZFFTzafyYBywyQ==
X-Google-Smtp-Source: ABdhPJxBcQOKHD07R2/OtEh3a6KqCV3jUpBAJwH1FAEBUxgXE4903UF437AA8l/ko3y/fwGkCoVYbS7DitCwwPHe8zE=
X-Received: by 2002:a25:41c7:: with SMTP id o190mr4468817yba.256.1626345525162;
 Thu, 15 Jul 2021 03:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com> <CAC_iWjLypqTGMxw_1ng1H8r5Yiv83G3yxUW8T1863XzFM-ShpA@mail.gmail.com>
In-Reply-To: <CAC_iWjLypqTGMxw_1ng1H8r5Yiv83G3yxUW8T1863XzFM-ShpA@mail.gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 15 Jul 2021 13:38:07 +0300
Message-ID: <CAC_iWjLfsvr_Z2te=ABfEAecAOkQBiu22QZ8GhorA4MYnt4Uxg@mail.gmail.com>
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

On Thu, 15 Jul 2021 at 13:00, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, 15 Jul 2021 at 07:01, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >
> > On 2021/7/9 14:29, Ilias Apalodimas wrote:
> > > As Alexander points out, when we are trying to recycle a cloned/expanded
> > > SKB we might trigger a race.  The recycling code relies on the
> > > pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> > > If that cloned SKB gets expanded or if we get references to the frags,
> > > call skbb_release_data() and overwrite skb->head, we are creating separate
> > > instances accessing the same page frags.  Since the skb_release_data()
> > > will first try to recycle the frags,  there's a potential race between
> > > the original and cloned SKB, since both will have the pp_recycle bit set.
> > >
> > > Fix this by explicitly those SKBs not recyclable.
> > > The atomic_sub_return effectively limits us to a single release case,
> > > and when we are calling skb_release_data we are also releasing the
> > > option to perform the recycling, or releasing the pages from the page pool.
> > >
> > > Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> > > Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> > > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > ---
> > > Changes since v1:
> > > - Set the recycle bit to 0 during skb_release_data instead of the
> > >   individual fucntions triggering the issue, in order to catch all
> > >   cases
> > >  net/core/skbuff.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 12aabcda6db2..f91f09a824be 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
> > >       if (skb->cloned &&
> > >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> > >                             &shinfo->dataref))
> > > -             return;
> > > +             goto exit;
> >
> > Is it possible this patch may break the head frag page for the original skb,
> > supposing it's head frag page is from the page pool and below change clears
> > the pp_recycle for original skb, causing a page leaking for the page pool?
> >
>
> So this would leak eventually dma mapping if the skb is cloned (and
> the dataref is now +1) and we are freeing the original skb first?
>

Apologies for the noise, my description was not complete.
The case you are thinking is clone an SKB and then expand the original?

thanks
/Ilias


> > >
> > >       skb_zcopy_clear(skb, true);
> > >
> > > @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> > >               kfree_skb_list(shinfo->frag_list);
> > >
> > >       skb_free_head(skb);
> > > +exit:
> > > +     skb->pp_recycle = 0;
> > >  }
> > >
> > >  /*
> > >
