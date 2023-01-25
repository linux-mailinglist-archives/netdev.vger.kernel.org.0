Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA94867BA15
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbjAYTC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbjAYTC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:02:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAE7CDCB;
        Wed, 25 Jan 2023 11:02:27 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id jm10so18735638plb.13;
        Wed, 25 Jan 2023 11:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3Gjiwk9VE8PjWYn/UriZFfIOdOHF6bRm9QYR8SHcIg0=;
        b=gpB6sK0k1ZFZcvTrRd4mdxHZRJsw+Czg4QEs0PSGYGBhBkH6uGKoqvqyloMWdLhjjR
         xhlsrYkzKAy09unrrPcFp1MlvT2/lQykVQ64QnFMDhBHM4lnUfJ5K4O2FBRa9K9Ti7Qq
         T5a4lsBk8CZ9r5cv0D4xPCiJfsr89BaYOpgVW5oXgRlRIpYXyweEOemlK26LXbpoFxI1
         spav/kSoYGUeTBEuA8n+O4al7z/EIuwGiCol3Dd9mKlBuvZjg7EQQpwTPtjlVqHnO/xz
         onPc/rLQbdxdoJes0FEAX/mXIBW7ko1NJUp2cRU96AqHrK0dfkX5ICYnEYJr8eFSyGkZ
         5BWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Gjiwk9VE8PjWYn/UriZFfIOdOHF6bRm9QYR8SHcIg0=;
        b=CgYovQtq7QHaBo/1M1CH+AFO2DdczLsw2VO432mTqUnkpOLIB2tRD7JWBIX8lAJEan
         4hyVHSyFgtU7UHeN2R2ihg9ePZLrPF5/TBO4wpga832fzA3Lg+uZQjArN5MBXa/D/WRp
         b+OLQW+S5dMHlphmn9GBMl+qI5MK23MpB7GPoRUrOr2jkD3jrg7dAIuKlMHgbyl1KRxv
         jSy53LEtdQ1NibSRpjtLn5GFOACfPv68d1P8r9Q1Lvmy3W51TNXgqMHiiPvVf0Mt6Uzx
         ov/UHZuKjnrjlf4AoC1U7LuZUspF4lcit71b39dwvRzjCcMkJT/pawWP6hHhGbg7kjlF
         JVOg==
X-Gm-Message-State: AFqh2kovbKd/AC45lSeTDQI0Fnn9JcUVZNRAuX8kG+msyUeV5YAc1fGv
        xdUJ0x0rMDTJyJksmhxh1OM=
X-Google-Smtp-Source: AMrXdXt87IhsiE2916UdtAmT1ibbRHkqsCBuWD3u9GAUtYqBROIW+VZdz/kKMbki3IG9+z7FeiIAhQ==
X-Received: by 2002:a17:902:9690:b0:193:6520:739a with SMTP id n16-20020a170902969000b001936520739amr52313413plp.46.1674673346458;
        Wed, 25 Jan 2023 11:02:26 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id je15-20020a170903264f00b001960642b460sm3533458plb.260.2023.01.25.11.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:02:25 -0800 (PST)
Message-ID: <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
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
Date:   Wed, 25 Jan 2023 11:02:24 -0800
In-Reply-To: <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
         <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
         <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
         <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
         <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
         <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
         <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name>
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

On Wed, 2023-01-25 at 19:42 +0100, Felix Fietkau wrote:
> On 25.01.23 19:26, Alexander H Duyck wrote:
> > On Wed, 2023-01-25 at 18:32 +0100, Felix Fietkau wrote:
> > > On 25.01.23 18:11, Alexander H Duyck wrote:
> > > > On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
> > > > > On 24.01.23 22:10, Alexander H Duyck wrote:
> > > > > > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> > > > > > > On 24.01.23 15:11, Ilias Apalodimas wrote:
> > > > > > > > Hi Felix,
> > > > > > > >=20
> > > > > > > > ++cc Alexander and Yunsheng.
> > > > > > > >=20
> > > > > > > > Thanks for the report
> > > > > > > >=20
> > > > > > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> =
wrote:
> > > > > > > > >=20
> > > > > > > > > While testing fragmented page_pool allocation in the mt76=
 driver, I was able
> > > > > > > > > to reliably trigger page refcount underflow issues, which=
 did not occur with
> > > > > > > > > full-page page_pool allocation.
> > > > > > > > > It appears to me, that handling refcounting in two separa=
te counters
> > > > > > > > > (page->pp_frag_count and page refcount) is racy when page=
 refcount gets
> > > > > > > > > incremented by code dealing with skb fragments directly, =
and
> > > > > > > > > page_pool_return_skb_page is called multiple times for th=
e same fragment.
> > > > > > > > >=20
> > > > > > > > > Dropping page->pp_frag_count and relying entirely on the =
page refcount makes
> > > > > > > > > these underflow issues and crashes go away.
> > > > > > > > >=20
> > > > > > > >=20
> > > > > > > > This has been discussed here [1].  TL;DR changing this to p=
age
> > > > > > > > refcount might blow up in other colorful ways.  Can we look=
 closer and
> > > > > > > > figure out why the underflow happens?
> > > > > > > I don't see how the approch taken in my patch would blow up. =
From what I=20
> > > > > > > can tell, it should be fairly close to how refcount is handle=
d in=20
> > > > > > > page_frag_alloc. The main improvement it adds is to prevent i=
t from=20
> > > > > > > blowing up if pool-allocated fragments get shared across mult=
iple skbs=20
> > > > > > > with corresponding get_page and page_pool_return_skb_page cal=
ls.
> > > > > > >=20
> > > > > > > - Felix
> > > > > > >=20
> > > > > >=20
> > > > > > Do you have the patch available to review as an RFC? From what =
I am
> > > > > > seeing it looks like you are underrunning on the pp_frag_count =
itself.
> > > > > > I would suspect the issue to be something like starting with a =
bad
> > > > > > count in terms of the total number of references, or deducing t=
he wrong
> > > > > > amount when you finally free the page assuming you are tracking=
 your
> > > > > > frag count using a non-atomic value in the driver.
> > > > > The driver patches for page pool are here:
> > > > > https://patchwork.kernel.org/project/linux-wireless/patch/64abb23=
f4867c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
> > > > > https://patchwork.kernel.org/project/linux-wireless/patch/68081e0=
2cbe2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
> > > > >=20
> > > > > They are also applied in my mt76 tree at:
> > > > > https://github.com/nbd168/wireless
> > > > >=20
> > > > > - Felix
> > > >=20
> > > > So one thing I am thinking is that we may be seeing an issue where =
we
> > > > are somehow getting a mix of frag and non-frag based page pool page=
s.
> > > > That is the only case I can think of where we might be underflowing
> > > > negative. If you could add some additional debug info on the underf=
low
> > > > WARN_ON case in page_pool_defrag_page that might be useful.
> > > > Specifically I would be curious what the actual return value is. I'=
m
> > > > assuming we are only hitting negative 1, but I would want to verify=
 we
> > > > aren't seeing something else.
> > > I'll try to run some more tests soon. However, I think I found the pi=
ece=20
> > > of code that is incompatible with using pp_frag_count.
> > > When receiving an A-MSDU packet (multiple MSDUs within a single 802.1=
1=20
> > > packet), and it is not split by the hardware, a cfg80211 function=20
> > > extracts the individual MSDUs into separate skbs. In that case, a=20
> > > fragment can be shared across multiple skbs, and get_page is used to=
=20
> > > increase the refcount.
> > > You can find this in net/wireless/util.c: ieee80211_amsdu_to_8023s (a=
nd=20
> > > its helper functions).
> >=20
> > I'm not sure if it is problematic or not. Basically it is trading off
> > by copying over the frags, calling get_page on each frag, and then
> > using dev_kfree_skb to disassemble and release the pp_frag references.
> > There should be other paths in the kernel that are doing something
> > similar.
> >=20
> > > This code also has a bug where it doesn't set pp_recycle on the newly=
=20
> > > allocated skb if the previous one has it, but that's a separate matte=
r=20
> > > and fixing it doesn't make the crash go away.
> >=20
> > Adding the recycle would cause this bug. So one thing we might be
> > seeing is something like that triggering this error. Specifically if
> > the page is taken via get_page when assembling the new skb then we
> > cannot set the recycle flag in the new skb otherwise it will result in
> > the reference undercount we are seeing. What we are doing is shifting
> > the references away from the pp_frag_count to the page reference count
> > in this case. If we set the pp_recycle flag then it would cause us to
> > decrement pp_frag_count instead of the page reference count resulting
> > in the underrun.
> Couldn't leaving out the pp_recycle flag potentially lead to a case=20
> where the last user of the page drops it via page_frag_free instead of=
=20
> page_pool_return_skb_page? Is that valid?

No. What will happen is that when the pp_frag_count is exhausted the
page will be unmapped and evicted from the page pool. When the page is
then finally freed it will end up going back to the page allocator
instead of page pool.

Basically the idea is that until pp_frag_count reaches 0 there will be
at least 1 page reference held.

> > > Is there any way I can make that part of the code work with the curre=
nt=20
> > > page pool frag implementation?
> >=20
> > The current code should work. Basically as long as the references are
> > taken w/ get_page and skb->pp_recycle is not set then we shouldn't run
> > into this issue because the pp_frag_count will be dropped when the
> > original skb is freed and the page reference count will be decremented
> > when the new one is freed.
> >=20
> > For page pool page fragments the main thing to keep in mind is that if
> > pp_recycle is set it will update the pp_frag_count and if it is not
> > then it will just decrement the page reference count.
> What takes care of DMA unmap and other cleanup if the last reference to=
=20
> the page is dropped via page_frag_free?
>=20
> - Felix

When the page is freed on the skb w/ pp_recycle set it will unmap the
page and evict it from the page pool. Basically in these cases the page
goes from the page pool back to the page allocator.

The general idea with this is that if we are using fragments that there
will be enough of them floating around that if one or two frags have a
temporeary detour through a non-recycling path that hopefully by the
time the last fragment is freed the other instances holding the
additional page reference will have let them go. If not then the page
will go back to the page allocator and it will have to be replaced in
the page pool.
