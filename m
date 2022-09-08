Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2A45B1CA3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiIHMUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiIHMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:20:16 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F674370
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 05:20:16 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id y82so17936120yby.6
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 05:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3Bpy8tokcuEJPvqzWlHV86rwZyQw7UhNONA3HAxAE5c=;
        b=ZlCG4k65MNaPEcEegr68YFRL7cggVr5nndalh7L81/R9VnZjAjil5qFlwRoCRLfInY
         nmaAlsLGfsO7i1oq9ujW+P4RQzlPLixIYKz80BCJd8fe1JJcSXbbDf/a7aRphm09nan6
         uR395r0nFkBl9Tq6Q9EuhVsCiN8xpJUwoARnSdZH2D8A7Y33VVXZIgqzHUhdpa1FP8pO
         +SN3dhrWQHpcq4Vrz0wH3RpUe+KnSVQVxQwH/AVOImJYR/y0D5eCjPbTGb68k1Yyvgcx
         TDUo/rrYlEtwbdOq0HLfjXTzWqiA2V+FD29tPD3wo6oAsXgOnwG2d5BhzbqeomGK/Z8o
         o0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3Bpy8tokcuEJPvqzWlHV86rwZyQw7UhNONA3HAxAE5c=;
        b=1TChfoj6s411xVZmRF9NUBoM12CjJUA3AQ74bbJlmXmkivkkbtixM7ffCGkqsfUNuC
         G9b9Rxx7HVgql9wEQpr6nI1BTM+/HlAxiNS5wBaYjy6rPknP53t7r4ZvqpG9P6BERqwB
         QTbbYtLMScDeyIUHBB7KxoJ6yKF5yl2WaWv0dWHzyiRC66p6LssWv/AHEv89HugRJ2JQ
         9b86+2qoo/9PMpSBOCEe+739U4CeMvqcdvH/lAd3BwJh6wRw/4o5QZR6V/dGyWyTDc6r
         uP7KE1RRxIZlfziqCYZcTS5f+cSVrGjcK9bDFNyToJAqn+RxrrjqQyL5r8LblpFVWgst
         uHAQ==
X-Gm-Message-State: ACgBeo2Cl+unzIKpqjQFcMkAtn8fKPIJBdfOSkXT0waejpGVNJcSTHDo
        xVeFm2Im6/VXKFpC2UHkYTkU6C6EnerwEEvRRSF8Szu6uT5Igg==
X-Google-Smtp-Source: AA6agR6yy8DKqczCm1hmdvbkE9PS/RaJ8mQIdpxkKSSm+jPnEMOif7nEvo4LCjuCgh2y2R0FVXxCQZOinr157V6GaLU=
X-Received: by 2002:a25:e0c4:0:b0:6a8:d8f0:5485 with SMTP id
 x187-20020a25e0c4000000b006a8d8f05485mr6272390ybg.387.1662639614999; Thu, 08
 Sep 2022 05:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
 <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com> <fff6a18ddb74423cd31918802e4001f8bd7e27c5.camel@redhat.com>
In-Reply-To: <fff6a18ddb74423cd31918802e4001f8bd7e27c5.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Sep 2022 05:20:03 -0700
Message-ID: <CANn89iJzSgdQg3BO0ifEKOAaptBVfyH1kxKLOW=oMfojCiUvSg@mail.gmail.com>
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

On Thu, Sep 8, 2022 at 3:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-09-07 at 13:40 -0700, Eric Dumazet wrote:
> > On 9/7/22 13:19, Paolo Abeni wrote:
> > > Hello,
> > >
> > > reviving an old thread...
> > > On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> > > > While using page fragments instead of a kmalloc backed skb->head might give
> > > > a small performance improvement in some cases, there is a huge risk of
> > > > under estimating memory usage.
> > > [...]
> > >
> > > > Note that we might in the future use the sk_buff napi cache,
> > > > instead of going through a more expensive __alloc_skb()
> > > >
> > > > Another idea would be to use separate page sizes depending
> > > > on the allocated length (to never have more than 4 frags per page)
> > > I'm investigating a couple of performance regressions pointing to this
> > > change and I'd like to have a try to the 2nd suggestion above.
> > >
> > > If I read correctly, it means:
> > > - extend the page_frag_cache alloc API to allow forcing max order==0
> > > - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> > > page_small)
> > > - in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
> > > page_small cache with order 0 allocation.
> > > (all the above constrained to host with 4K pages)
> > >
> > > I'm not quite sure about the "never have more than 4 frags per page"
> > > part.
> > >
> > > What outlined above will allow for 10 min size frags in page_order0, as
> > > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> > > not sure that anything will allocate such small frags.
> > > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.
> >
> > Well, some arches have PAGE_SIZE=65536 :/
>
> Yes, the idea is to implement all the above only for arches with
> PAGE_SIZE==4K. Would that be reasonable?

Well, we also have changed MAX_SKB_FRAGS from 17 to 45 for BIG TCP.

And locally we have

#define GRO_MAX_HEAD 192

Reference:

commit fd9ea57f4e9514f9d0f0dec505eefd99a8faa148
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Jun 8 09:04:38 2022 -0700

    net: add napi_get_frags_check() helper


>
> Thanks!
>
> Paolo
>
