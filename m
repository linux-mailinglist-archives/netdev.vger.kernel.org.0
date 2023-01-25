Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9A667BFC3
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 23:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjAYWPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 17:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbjAYWPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 17:15:07 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85C05D104;
        Wed, 25 Jan 2023 14:14:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r18so14370055pgr.12;
        Wed, 25 Jan 2023 14:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r8fBRoSD9KdKKe87+AsPF4515jZrVkrWQf1L8yf15XY=;
        b=FhXCp3XlD4JRt/BFSCdffwjdxerji9ue5sAQc8DLIGt0SkZFt9fCFnCeew8T4n69kX
         2P36smckPE8xpobwJOwl8+mze+WkDnjSxj6a0gMFEuecWbTJWf9zQ83ZbR47oPr0nQa2
         v8iBrKRzR1ie0GZ3aIq5zoVJDyTwcKZTJagSnbRAjKVJvbt1SM7hZ+loYKvfPwbunxy+
         UJa80LoQyj4OPlbMbUxfGbZNy+9AhguDW/OVWsaU37/kG9A6tO88qhaapHBoFQi5+PMo
         vgbjhImntqH/g1a2CWhihKzZaCQLtNJoJ6OHTIpVhjOzQfA6nIIPs5W6o24vTeHke/u5
         q5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r8fBRoSD9KdKKe87+AsPF4515jZrVkrWQf1L8yf15XY=;
        b=SeXo7gtNbe7ZGbfslXDZBmsDAVOot2QI9P+EvEADbrEbofYE2eLo1iipQDK4OwYGxq
         PF0U/VgvmdPOZuVZmGNijBye6blcjVU4vUWz6HNZOUOZsuHH2KJhT9h7ok0u/teM+SUm
         Rh85AffD76pY5pt+axvCngidlNRpQyibVEdH7b6Otg+tUGkjTem+f3WbmGGLjbhi3fSG
         JV0nmbGVj4pP3JrvqrUU1XZzPHdeohE79JgSFeiV0h1xe6ObgX9ivemYoGO8nKbLbTDH
         pV8qOHlatUZmtoquAYU1kk2vfT0AK08KltEQ4HTjlsuhWPP8bhjG5cAkSBfhVjQ9HYqs
         i5SA==
X-Gm-Message-State: AFqh2kq2UoNOuoHtHxRrkziC4UmqPy6AuVM5oCtavpI2R1UxJsJl6GvB
        1xU+Ne6yF1dRGLuX86wA8Uo=
X-Google-Smtp-Source: AMrXdXts65Imo8paZ0DA1V5jCReRvE6fPH29YXUQwKIueHf1r86u7WdTUcmkvZuSEgrg7aBjnljlZA==
X-Received: by 2002:a05:6a00:4ac8:b0:581:bae0:d5d5 with SMTP id ds8-20020a056a004ac800b00581bae0d5d5mr30359050pfb.9.1674684895117;
        Wed, 25 Jan 2023 14:14:55 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id i24-20020aa78d98000000b005813f365afcsm4115581pfr.189.2023.01.25.14.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 14:14:54 -0800 (PST)
Message-ID: <148028e75d720091caa56e8b0a89544723fda47e.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Wed, 25 Jan 2023 14:14:53 -0800
In-Reply-To: <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
         <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
         <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
         <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
         <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
         <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
         <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name>
         <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
         <9992e7b5-7f2b-b79d-9c48-cf689807f185@nbd.name>
         <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-25 at 20:40 +0100, Felix Fietkau wrote:
> On 25.01.23 20:10, Felix Fietkau wrote:
> > On 25.01.23 20:02, Alexander H Duyck wrote:
> > > On Wed, 2023-01-25 at 19:42 +0100, Felix Fietkau wrote:
> > > > On 25.01.23 19:26, Alexander H Duyck wrote:
> > > > > On Wed, 2023-01-25 at 18:32 +0100, Felix Fietkau wrote:
> > > > > > On 25.01.23 18:11, Alexander H Duyck wrote:
> > > > > > > On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
> > > > > > > > On 24.01.23 22:10, Alexander H Duyck wrote:
> > > > > > > > > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> > > > > > > > > > On 24.01.23 15:11, Ilias Apalodimas wrote:
> > > > > > > > > > > Hi Felix,
> > > > > > > > > > >=20
> > > > > > > > > > > ++cc Alexander and Yunsheng.
> > > > > > > > > > >=20
> > > > > > > > > > > Thanks for the report
> > > > > > > > > > >=20
> > > > > > > > > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.=
name> wrote:
> > > > > > > > > > > >=20
> > > > > > > > > > > > While testing fragmented page_pool allocation in th=
e mt76 driver, I was able
> > > > > > > > > > > > to reliably trigger page refcount underflow issues,=
 which did not occur with
> > > > > > > > > > > > full-page page_pool allocation.
> > > > > > > > > > > > It appears to me, that handling refcounting in two =
separate counters
> > > > > > > > > > > > (page->pp_frag_count and page refcount) is racy whe=
n page refcount gets
> > > > > > > > > > > > incremented by code dealing with skb fragments dire=
ctly, and
> > > > > > > > > > > > page_pool_return_skb_page is called multiple times =
for the same fragment.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Dropping page->pp_frag_count and relying entirely o=
n the page refcount makes
> > > > > > > > > > > > these underflow issues and crashes go away.
> > > > > > > > > > > >=20
> > > > > > > > > > >=20
> > > > > > > > > > > This has been discussed here [1].  TL;DR changing thi=
s to page
> > > > > > > > > > > refcount might blow up in other colorful ways.  Can w=
e look closer and
> > > > > > > > > > > figure out why the underflow happens?
> > > > > > > > > > I don't see how the approch taken in my patch would blo=
w up. From what I=20
> > > > > > > > > > can tell, it should be fairly close to how refcount is =
handled in=20
> > > > > > > > > > page_frag_alloc. The main improvement it adds is to pre=
vent it from=20
> > > > > > > > > > blowing up if pool-allocated fragments get shared acros=
s multiple skbs=20
> > > > > > > > > > with corresponding get_page and page_pool_return_skb_pa=
ge calls.
> > > > > > > > > >=20
> > > > > > > > > > - Felix
> > > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > Do you have the patch available to review as an RFC? From=
 what I am
> > > > > > > > > seeing it looks like you are underrunning on the pp_frag_=
count itself.
> > > > > > > > > I would suspect the issue to be something like starting w=
ith a bad
> > > > > > > > > count in terms of the total number of references, or dedu=
cing the wrong
> > > > > > > > > amount when you finally free the page assuming you are tr=
acking your
> > > > > > > > > frag count using a non-atomic value in the driver.
> > > > > > > > The driver patches for page pool are here:
> > > > > > > > https://patchwork.kernel.org/project/linux-wireless/patch/6=
4abb23f4867c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
> > > > > > > > https://patchwork.kernel.org/project/linux-wireless/patch/6=
8081e02cbe2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
> > > > > > > >=20
> > > > > > > > They are also applied in my mt76 tree at:
> > > > > > > > https://github.com/nbd168/wireless
> > > > > > > >=20
> > > > > > > > - Felix
> > > > > > >=20
> > > > > > > So one thing I am thinking is that we may be seeing an issue =
where we
> > > > > > > are somehow getting a mix of frag and non-frag based page poo=
l pages.
> > > > > > > That is the only case I can think of where we might be underf=
lowing
> > > > > > > negative. If you could add some additional debug info on the =
underflow
> > > > > > > WARN_ON case in page_pool_defrag_page that might be useful.
> > > > > > > Specifically I would be curious what the actual return value =
is. I'm
> > > > > > > assuming we are only hitting negative 1, but I would want to =
verify we
> > > > > > > aren't seeing something else.
> > > > > > I'll try to run some more tests soon. However, I think I found =
the piece=20
> > > > > > of code that is incompatible with using pp_frag_count.
> > > > > > When receiving an A-MSDU packet (multiple MSDUs within a single=
 802.11=20
> > > > > > packet), and it is not split by the hardware, a cfg80211 functi=
on=20
> > > > > > extracts the individual MSDUs into separate skbs. In that case,=
 a=20
> > > > > > fragment can be shared across multiple skbs, and get_page is us=
ed to=20
> > > > > > increase the refcount.
> > > > > > You can find this in net/wireless/util.c: ieee80211_amsdu_to_80=
23s (and=20
> > > > > > its helper functions).
> > > > >=20
> > > > > I'm not sure if it is problematic or not. Basically it is trading=
 off
> > > > > by copying over the frags, calling get_page on each frag, and the=
n
> > > > > using dev_kfree_skb to disassemble and release the pp_frag refere=
nces.
> > > > > There should be other paths in the kernel that are doing somethin=
g
> > > > > similar.
> > > > >=20
> > > > > > This code also has a bug where it doesn't set pp_recycle on the=
 newly=20
> > > > > > allocated skb if the previous one has it, but that's a separate=
 matter=20
> > > > > > and fixing it doesn't make the crash go away.
> > > > >=20
> > > > > Adding the recycle would cause this bug. So one thing we might be
> > > > > seeing is something like that triggering this error. Specifically=
 if
> > > > > the page is taken via get_page when assembling the new skb then w=
e
> > > > > cannot set the recycle flag in the new skb otherwise it will resu=
lt in
> > > > > the reference undercount we are seeing. What we are doing is shif=
ting
> > > > > the references away from the pp_frag_count to the page reference =
count
> > > > > in this case. If we set the pp_recycle flag then it would cause u=
s to
> > > > > decrement pp_frag_count instead of the page reference count resul=
ting
> > > > > in the underrun.
> > > > Couldn't leaving out the pp_recycle flag potentially lead to a case=
=20
> > > > where the last user of the page drops it via page_frag_free instead=
 of=20
> > > > page_pool_return_skb_page? Is that valid?
> > >=20
> > > No. What will happen is that when the pp_frag_count is exhausted the
> > > page will be unmapped and evicted from the page pool. When the page i=
s
> > > then finally freed it will end up going back to the page allocator
> > > instead of page pool.
> > >=20
> > > Basically the idea is that until pp_frag_count reaches 0 there will b=
e
> > > at least 1 page reference held.
> > >=20
> > > > > > Is there any way I can make that part of the code work with the=
 current=20
> > > > > > page pool frag implementation?
> > > > >=20
> > > > > The current code should work. Basically as long as the references=
 are
> > > > > taken w/ get_page and skb->pp_recycle is not set then we shouldn'=
t run
> > > > > into this issue because the pp_frag_count will be dropped when th=
e
> > > > > original skb is freed and the page reference count will be decrem=
ented
> > > > > when the new one is freed.
> > > > >=20
> > > > > For page pool page fragments the main thing to keep in mind is th=
at if
> > > > > pp_recycle is set it will update the pp_frag_count and if it is n=
ot
> > > > > then it will just decrement the page reference count.
> > > > What takes care of DMA unmap and other cleanup if the last referenc=
e to=20
> > > > the page is dropped via page_frag_free?
> > > >=20
> > > > - Felix
> > >=20
> > > When the page is freed on the skb w/ pp_recycle set it will unmap the
> > > page and evict it from the page pool. Basically in these cases the pa=
ge
> > > goes from the page pool back to the page allocator.
> > >=20
> > > The general idea with this is that if we are using fragments that the=
re
> > > will be enough of them floating around that if one or two frags have =
a
> > > temporeary detour through a non-recycling path that hopefully by the
> > > time the last fragment is freed the other instances holding the
> > > additional page reference will have let them go. If not then the page
> > > will go back to the page allocator and it will have to be replaced in
> > > the page pool.
> > Thanks for the explanation, it makes sense to me now. Unfortunately it
> > also means that I have no idea what could cause this issue. I will
> > finish my mt76 patch rework which gets rid of the pp vs non-pp
> > allocation mix and re-run my tests to provide updated traces.
> Here's the updated mt76 page pool support commit:
> https://github.com/nbd168/wireless/commit/923cdab6d4c92a0acb3536b3b0cc4af=
9fee7c808

Yeah, so I don't see anything wrong with the patch in terms of page
pool.

> And here is the trace that I'm getting with 6.1:
> https://nbd.name/p/a16957f2
>=20
> If you have any debug patch you'd like me to test, please let me know.
>=20
> - Felix

So looking at the traces I am assuming what we are seeing is the
deferred freeing from the TCP Rx path since I don't see a driver
anywhere between net_rx_action and napi_consume skb. So it seems like
the packets are likely making it all the way up the network stack.

Is this the first wireless driver to add support for page pool? I'm
thinking we must be seeing something in the wireless path that is
causing an issue such as the function you called out earlier but I
can't see anything obvious.

One thing we need to be on the lookout for is cloned skbs. When an skb
is cloned the pp_recycle gets copied over. In that case the reference
is moved over to the skb dataref count. What comes to mind is something
like commit 1effe8ca4e34c ("skbuff: fix coalescing for page_pool
fragment recycling").





