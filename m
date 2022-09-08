Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6D5B214F
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiIHOxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiIHOxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:53:37 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D69B5302
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:53:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so2603466pjm.1
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=1eeO1Pj9F81ivsmmw7WnfwI33g1hkZ6IFjDp/jgOBvM=;
        b=W3DDTV5BMAj67ipuh/Gg2a3vh5wlNanQJOzDEdFdGFfin+GyFsyNnneQKY2QkVBu9d
         QsBxLFXPzNm7ShT932KLSM3F3Jrn8MWSWaLUdYP2wOkJpiP3RlL4OqOswLLmgmV8YYHN
         D+Smt4B1lcmgxCt5f/bEhRkYQq6bykTXFIdaNxM7uun/dCQp0pBqv2KXnV2RrYcqXrdb
         ljpmQonrdELavmKOHQuB6Bj6pe4yrzrIvJQ0IxHxsT/0AkE9XEIgEpVjBM/T/9uTOo5+
         6h8oBVcmlkwsmVvpSZsyCHoAxR7Er86EZDrkECucFh2gYV7gbJ28DxW5FxWaM8NfZ+5F
         XzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=1eeO1Pj9F81ivsmmw7WnfwI33g1hkZ6IFjDp/jgOBvM=;
        b=K8ttEJzVt91xgFHpJWLcQhGNHYPYqYc17mtf4Pa98BwFxJKnLCz0+b3WJeodxj7FNz
         Hixt6YfN405Sojk4U/LWGRVikDQCUm9jhYe4FRhYT3TfIfsKK8MeLUAfJoUCEi0F724K
         6V1hBFfm6kvdhuFxn7Ha/3MGIl5acNWUz6XJ75Stu7hu7oXm2rK/MYTlLup7SO+g3bkU
         1xqxAWMIJEVKEvQ655hOqcTs+UrOs8MC0+29O6tHqj+nZU2e7Tr/yEU9cmQcIyXppd6F
         zdgnpvouGjTpfqD4NR8JjjVm6VPKL1rpkO/kfAy5ldcQ0fdaGwCmE7464noH6/XiyuFQ
         F1sg==
X-Gm-Message-State: ACgBeo28LmgNyyY5iejnKkCm6Go5udCGYedcAAOqnrA7FZ/lucMcTeY2
        4hnrtkqt1ovWAd3oS7f/+Fo=
X-Google-Smtp-Source: AA6agR7sZ6WXV1SjpWecWeKwUl4oU4Dj2NNiCijsPnR8mR7u5U0HXBvzGj5SZqm1/Y274SqABJoYiQ==
X-Received: by 2002:a17:90b:4d8a:b0:1fb:5e0c:67fd with SMTP id oj10-20020a17090b4d8a00b001fb5e0c67fdmr4702800pjb.75.1662648814871;
        Thu, 08 Sep 2022 07:53:34 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.38.208])
        by smtp.googlemail.com with ESMTPSA id rj9-20020a17090b3e8900b001df264610c4sm8792468pjb.0.2022.09.08.07.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:53:34 -0700 (PDT)
Message-ID: <cf264865cb1613c0e7acf4bbc1ed345533767822.camel@gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Thu, 08 Sep 2022 07:53:32 -0700
In-Reply-To: <498a25e4f7ba4e21d688ca74f335b28cadcb3381.camel@redhat.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
         <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
         <498a25e4f7ba4e21d688ca74f335b28cadcb3381.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-08 at 13:00 +0200, Paolo Abeni wrote:
> On Wed, 2022-09-07 at 14:36 -0700, Alexander H Duyck wrote:
> > On Wed, 2022-09-07 at 22:19 +0200, Paolo Abeni wrote:
> > > What outlined above will allow for 10 min size frags in page_order0, =
as
> > > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) =3D=3D 38=
4. I'm
> > > not sure that anything will allocate such small frags.
> > > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.=
=C2=A0
> >=20
> > That doesn't account for any headroom though.=C2=A0
>=20
> Yes, the 0-size data packet was just a theoretical example to make the
> really worst case scenario.
>=20
> > Most of the time you have
> > to reserve some space for headroom so that if this buffer ends up
> > getting routed off somewhere to be tunneled there is room for adding to
> > the header. I think the default ends up being NET_SKB_PAD, though many
> > NICs use larger values. So adding any data onto that will push you up
> > to a minimum of 512 per skb for the first 64B for header data.
> >=20
> > With that said it would probably put you in the range of 8 or fewer
> > skbs per page assuming at least 1 byte for data:
> >   512 =3D	SKB_DATA_ALIGN(NET_SKB_PAD + 1) +
> > 	SKB_DATA_ALIGN(struct skb_shared_info)
>=20
> In most build GRO_MAX_HEAD packets are even larger (should be 640)

Right, which is why I am thinking we may want to default to a 1K slice.

> > > The maximum truesize underestimation in both cases will be lower than
> > > what we can get with the current code in the worst case (almost 32x
> > > AFAICS).=C2=A0
> > >=20
> > > Is the above schema safe enough or should the requested size
> > > artificially inflatted to fit at most 4 allocations per page_order0?
> > > Am I miss something else? Apart from omitting a good deal of testing =
in
> > > the above list ;)=20
> >=20
> > If we are working with an order 0 page we may just want to split it up
> > into a fixed 1K fragments and not bother with a variable pagecnt bias.
> > Doing that we would likely simplify this quite a bit and avoid having
> > to do as much page count manipulation which could get expensive if we
> > are not getting many uses out of the page. An added advantage is that
> > we can get rid of the pagecnt_bias and just work based on the page
> > offset.
> >=20
> > As such I am not sure the page frag cache would really be that good of
> > a fit since we have quite a bit of overhead in terms of maintaining the
> > pagecnt_bias which assumes the page is a bit longer lived so the ratio
> > of refcnt updates vs pagecnt_bias updates is better.
>=20
> I see. With the above schema there will be 4-6 frags per packet. I'm
> wild guessing that the pagecnt_bias optimization still give some gain
> in that case, but I really shold collect some data points.

As I recall one of the big advantages of the 32k page was that we were
reducing the atomic ops by nearly half. Essentially we did a
page_ref_add at the start and a page_ref_sub_and_test when we were out
of space. Whereas a single 4K allocation would be 2 atomic ops per
allocation, we were only averaging 1.13 per 2k slice. With the Intel
NICs I was able to get even closer to 1 since I was able to do the 2k
flip/flop setup and could get up to 64K uses off of a single page.

Then again though I am not sure now much the atomic ops penalty will be
for your use case. Where it came into play is that MMIO writes to the
device will block atomic ops until they can be completed so in a device
driver atomic ops become very expensive and so we want to batch them as
much as possible.

> If the pagecnt optimization should be dropped, it would be probably
> more straight-forward to use/adapt 'page_frag' for the page_order0
> allocator.

That would make sense. Basically we could get rid of the pagecnt bias
and add the fixed number of slices to the count at allocation so we
would just need to track the offset to decide when we need to allocate
a new page. In addtion if we are flushing the page when it is depleted
we don't have to mess with the pfmemalloc logic.

> BTW it's quite strange/confusing having to very similar APIs (page_frag
> and page_frag_cache) with very similar names and no references between
> them.

I'm not sure what you are getting at here. There are plenty of
references between them, they just aren't direct. I viewed it as being
more like the get_free_pages() type logic where you end up allocating a
page but what you get is an address to the page fragment instead of the
page_frag struct.
