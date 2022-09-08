Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077F65B22F9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiIHQBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiIHQBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:01:02 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D54BC59D9
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:01:01 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k80so15800116ybk.10
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EPyL5LIKUa2efNWe6fJnw/KgS0gXvJqz6I7bAFWMaCY=;
        b=bjz/hCcBv9KWiX9ZxEuIcT4w9A3ljJgjCZ06AomwhGJOv8+BViRzE4DjyvOuKVatgH
         dyU6BSH6FwGe3jcc5hlMot6uT37BitlGxbPvur7MyOc9X2WLJAMp/vOdAM4PGk8hZZNn
         vrFP3w9gim3WhRzmWAksxKMDWxEiu/FzfGJU8Oony1At6pwgxO+AwFZieFhsp5pVcwIx
         ZocJXwOLrROi+M6NiHZbZYl7ISpU7DlGbRJft4929yaizxRMV6QbO56o984g3xx6F5X/
         8HsqEXbvQfVbq5dh9aafgVCGJEgsLoDr6ubT4qkwtfwpO4BUG7NrGUv+wp1S6P7yh97u
         MM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EPyL5LIKUa2efNWe6fJnw/KgS0gXvJqz6I7bAFWMaCY=;
        b=isrIOOP6JfOAoezr258c02cjYUJ9/0NvOC6atTuq8CofQuZLpmw8+Acmd5CcvtyO6v
         P5/0b8gP3yTtFgzhtqBcbAsXcQJkH+SQx7EZCB5nW8UGTXrKrVbWpPGRFVO35feaZPvZ
         rCGQFbkcXg4WBv2e2JKobOeJqaJ+uVBV7rVKGCASWIO18o9LOf1p4XuQoK8pvMzqYWBX
         t0y+vpSvLvJPpJ8Cp9+Q1x0YMqsrULmZbfZqeuxAUeNrUdIJEWjI2u+sll2GeoiD5V2r
         PFIHFatfhI1aRpwN+vVnP8lNs2UeswG5pr4SogurY8L8amJWo7mC76vz8vmhh63fstFs
         1riA==
X-Gm-Message-State: ACgBeo050sNRBjHtUIdiIswNNpneCzONQWLl+vcNWjkexubwkYxMWzSy
        WCb7zHPIH5+lrQeEZKiwhrDD+Ftv3fGq33wBLfXf7PPtu/RV8g==
X-Google-Smtp-Source: AA6agR7wwiE3vNSGNqLjZSrlm8ZD64AmrWk5yH+4N7DTEpoqmAVfozL1sx496g1L1WREvzZEILiDFSMTkLUP6UDqeg0=
X-Received: by 2002:a5b:888:0:b0:6ad:480c:9b66 with SMTP id
 e8-20020a5b0888000000b006ad480c9b66mr6630998ybq.231.1662652860227; Thu, 08
 Sep 2022 09:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
 <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com> <fff6a18ddb74423cd31918802e4001f8bd7e27c5.camel@redhat.com>
 <CANn89iJzSgdQg3BO0ifEKOAaptBVfyH1kxKLOW=oMfojCiUvSg@mail.gmail.com> <0ad4ba2bc157a2d1fa8a898056bea431fc244122.camel@redhat.com>
In-Reply-To: <0ad4ba2bc157a2d1fa8a898056bea431fc244122.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Sep 2022 09:00:48 -0700
Message-ID: <CANn89iL7iHOvkCYG1iGDpHkx1vg1KeDqh_FtrPa5mvxeo3JJtw@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 7:26 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-09-08 at 05:20 -0700, Eric Dumazet wrote:
> > On Thu, Sep 8, 2022 at 3:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Wed, 2022-09-07 at 13:40 -0700, Eric Dumazet wrote:
> > > > On 9/7/22 13:19, Paolo Abeni wrote:
> > > > > reviving an old thread...
> > > > > On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> > > > > > While using page fragments instead of a kmalloc backed skb->head might give
> > > > > > a small performance improvement in some cases, there is a huge risk of
> > > > > > under estimating memory usage.
> > > > > [...]
> > > > >
> > > > > > Note that we might in the future use the sk_buff napi cache,
> > > > > > instead of going through a more expensive __alloc_skb()
> > > > > >
> > > > > > Another idea would be to use separate page sizes depending
> > > > > > on the allocated length (to never have more than 4 frags per page)
> > > > > I'm investigating a couple of performance regressions pointing to this
> > > > > change and I'd like to have a try to the 2nd suggestion above.
> > > > >
> > > > > If I read correctly, it means:
> > > > > - extend the page_frag_cache alloc API to allow forcing max order==0
> > > > > - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> > > > > page_small)
> > > > > - in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
> > > > > page_small cache with order 0 allocation.
> > > > > (all the above constrained to host with 4K pages)
> > > > >
> > > > > I'm not quite sure about the "never have more than 4 frags per page"
> > > > > part.
> > > > >
> > > > > What outlined above will allow for 10 min size frags in page_order0, as
> > > > > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> > > > > not sure that anything will allocate such small frags.
> > > > > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.
> > > >
> > > > Well, some arches have PAGE_SIZE=65536 :/
> > >
> > > Yes, the idea is to implement all the above only for arches with
> > > PAGE_SIZE==4K. Would that be reasonable?
> >
> > Well, we also have changed MAX_SKB_FRAGS from 17 to 45 for BIG TCP.
> >
> > And locally we have
> >
> > #define GRO_MAX_HEAD 192
>
> default allocation size for napi_get_frags() is ~960b in google kernel,
> right? It looks like it should fit the above quite nicely with 4 frags
> per page?!?
>

Yes, using order-0 pages on x86 would avoid problems.
But if this adds yet another tests in fast path, increasing icache
pressure, I am unsure.
So I will comment when I see actual code/implementation.

("Extending" page_frag_cache alloc API seems overkill to me. Just use
separate code maybe ?)

> Vanilla kernel may hit a larger number of fragments per page, even if
> very likely not as high as the theoretical maximum mentioned in my
> previous email (as noted by Alex).
>
> If in that case excessive truesize underestimation would still be
> problematic (with a order0 4k page) __napi_alloc_skb() could be patched
> to increase smaller sizes to some reasonable minimum.
>
> Likely there is some point in your reply I did not get. Luckily LPC is
> coming :)
>
> > Reference:
> >
> > commit fd9ea57f4e9514f9d0f0dec505eefd99a8faa148
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Wed Jun 8 09:04:38 2022 -0700
> >
> >     net: add napi_get_frags_check() helper
>
> I guess such check should be revisited with all the above.
>
> Thanks,
>
> Paolo
>
