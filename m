Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A8271DBA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIUIRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIUIRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:17:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D3CC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 01:17:53 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y13so14464451iow.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 01:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wriII4q3u887tBtFEfsKFmvW4EmMFQouEZqnm0Btsk=;
        b=VLkZtbBtckpA5qGvxWJzj3bBlSod37e1B3ZyxGiwL66gvgqNp1C8GBj42t97n/VTx1
         xnvLZmEpTzkrHD+8c9SyBmCWOl7mh+Qm0i94XB9Vtkh81MG2Q1V4UqjYUFERV25RFQzD
         AGl5MFH+/0rdreZqyKRi9XS22SxwKP0VWaP9kjMS00Yf2dhOMI5j9g3D8NvoXHtxjYnd
         gX7tmJWbf0cmHlhRX+zcC2nL1BMnWYII9b4nNwdZaHDNybFkQOBJvtUjkSRVrkjegu3j
         cQNsNfeDnWMI5cMNcPN9+aMu4Hbbhu9RlpLsrtJjuXFcRWYp4Ktw0gIq+KcBMVoqatbA
         C6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wriII4q3u887tBtFEfsKFmvW4EmMFQouEZqnm0Btsk=;
        b=ANxMv3A6IEolTWliqyK/aPpII0GB86Yme8atIwFOJqbpQNhetP7D1/wRVPoQGN+fxu
         r0uUOTSjdiBISWx0MHsu+He1y7un1g/1nluneQZUwhK6hY7RRHDqfQ1Aexq5g6908sbN
         tMttoC70cnYjMX0wbHVFCdEeKLfd2fbtBTfOIgu0Mfck4fT90Ot1VCXvzTlKw49q/AM5
         B+nV77N3dx5io6S5NScxbbEuupxvomkHT6gwrM4o09hxb8LjMgrdPoe0/ThLNekVKMzA
         rImycTxBq6eseVg7/9T6SKWKJpH9suL7a5zCN+2p3OpogWsxAGEWmspnCdfDSGWaBJj+
         tvtQ==
X-Gm-Message-State: AOAM530yzvxiBdJFsEb7L/8GhOKN5aAVsCwqRZ8+2UFib0D/3v1twP7/
        jbKskLLPA34ormRxI1ffjKqloW08nU/137IpXki92Q==
X-Google-Smtp-Source: ABdhPJwkdOwPNhgGKJL2BUf2UCgleUZdOWZKpNTS6GTyOADWkTcTfxEAORBiqaBPaITu17ZOzso8quah2F3RGmqGDaM=
X-Received: by 2002:a6b:3bd3:: with SMTP id i202mr35806508ioa.145.1600676272222;
 Mon, 21 Sep 2020 01:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iLHH=CRzz5tavy_KEg0mhgXkhD9DBfh9bhcqSkcZ2xaaA@mail.gmail.com> <2102eba1-eeea-bf95-2df5-7fcfa3141694@huawei.com>
In-Reply-To: <2102eba1-eeea-bf95-2df5-7fcfa3141694@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Sep 2020 10:17:40 +0200
Message-ID: <CANn89i+ADkkEFDM=zpm3nHu6XjcACwPrhvG-eZ8GfWot9eo57w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use in_softirq() to indicate the NAPI
 context in napi_consume_skb()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linmiaohe <linmiaohe@huawei.com>, martin.varghese@nokia.com,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, kyk.segfault@gmail.com,
        Saeed Mahameed <saeed@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 10:10 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/21 15:19, Eric Dumazet wrote:
> > On Mon, Sep 21, 2020 at 4:08 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> When napi_consume_skb() is called in the tx desc cleaning process,
> >> it is usually in the softirq context(BH disabled, or are processing
> >> softirqs), but it may also be in the task context, such as in the
> >> netpoll or loopback selftest process.
> >>
> >> Currently napi_consume_skb() uses non-zero budget to indicate the
> >> NAPI context, the driver writer may provide the wrong budget when
> >> tx desc cleaning function is reused for both NAPI and non-NAPI
> >> context, see [1].
> >>
> >> So this patch uses in_softirq() to indicate the NAPI context, which
> >> doesn't necessarily mean in NAPI context, but it shouldn't care if
> >> NAPI context or not as long as it runs in softirq context or with BH
> >> disabled, then _kfree_skb_defer() will push the skb to the particular
> >> cpu' napi_alloc_cache atomically.
> >>
> >> [1] https://lkml.org/lkml/2020/9/15/38
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >> note that budget parameter is not removed in this patch because it
> >> involves many driver changes, we can remove it in separate patch if
> >> this patch is accepted.
> >> ---
> >>  net/core/skbuff.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >> index e077447..03d0d28 100644
> >> --- a/net/core/skbuff.c
> >> +++ b/net/core/skbuff.c
> >> @@ -895,8 +895,10 @@ void __kfree_skb_defer(struct sk_buff *skb)
> >>
> >>  void napi_consume_skb(struct sk_buff *skb, int budget)
> >>  {
> >> -       /* Zero budget indicate non-NAPI context called us, like netpoll */
> >> -       if (unlikely(!budget)) {
> >> +       /* called by non-softirq context, which usually means non-NAPI
> >> +        * context, like netpoll.
> >> +        */
> >> +       if (unlikely(!in_softirq())) {
> >>                 dev_consume_skb_any(skb);
> >>                 return;
> >>         }
> >> --
> >
> >
> > I do not think we should add this kind of fuzzy logic, just because
> > _one_ driver author made a mistake.
> >
> > Add a disable_bh() in the driver slow path, and accept the _existing_
> > semantic, the one that was understood by dozens.
>
> As my understanding, this patch did not change _existing_ semantic,
> it still only call _kfree_skb_defer() in softirq context. This patch
> just remove the requirement that a softirq context hint need to be
> provided to decide whether calling _kfree_skb_defer().

I do not want to remove the requirement.

>
> Yes, we can add DEBUG_NET() clauses to catch this kind of error as
> you suggested.
>
> But why we need such a debug clauses, when we can decide if delaying
> skb freeing is possible in napi_consume_skb(), why not just use
> in_softirq() to make this API more easy to use? Just as __dev_kfree_skb_any()
> API use "in_irq() || irqs_disabled()" checking to handle the irq context
> and non-irq context.


I just do not like your patch.

Copying another piece of fuzzy logic, inherited from legacy code is
not an excuse.

Add a local_bh_disable() in the driver slow path to meet _existing_
requirement, so that we can keep the hot path fast.
