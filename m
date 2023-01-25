Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96B467BB90
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbjAYUCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbjAYUCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:02:18 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B0E3AAC;
        Wed, 25 Jan 2023 12:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dxdbEA0qoy4DlpJVBj0ckc3783ZrTHHbARPoLsUpHDY=; b=e8pz2Vyh1v3e3WRRjdjkLaOApV
        z++kG11oZTvqYO+MS7i/bCHF4VPMPjapp/ywT2kHSLBqLwZMJ74UZyd231IeiePFnD797Tcd72TPI
        qhDG+j1vTBK+8vggl6RqlldJVaO0kc4FXyINlDSZxCFzWp4raxQYZAHO2do6nj4eTTWE=;
Received: from p4ff1378e.dip0.t-ipconnect.de ([79.241.55.142] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pKlyB-002Qst-1V; Wed, 25 Jan 2023 21:02:07 +0100
Message-ID: <b0dd5e80-f5c3-677e-f553-7d1de5d03f4c@nbd.name>
Date:   Wed, 25 Jan 2023 21:02:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
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
In-Reply-To: <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.23 20:40, Felix Fietkau wrote:
> On 25.01.23 20:10, Felix Fietkau wrote:
>> On 25.01.23 20:02, Alexander H Duyck wrote:
>>> On Wed, 2023-01-25 at 19:42 +0100, Felix Fietkau wrote:
>>>> On 25.01.23 19:26, Alexander H Duyck wrote:
>>>> > On Wed, 2023-01-25 at 18:32 +0100, Felix Fietkau wrote:
>>>> > > On 25.01.23 18:11, Alexander H Duyck wrote:
>>>> > > > On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
>>>> > > > > On 24.01.23 22:10, Alexander H Duyck wrote:
>>>> > > > > > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
>>>> > > > > > > On 24.01.23 15:11, Ilias Apalodimas wrote:
>>>> > > > > > > > Hi Felix,
>>>> > > > > > > > 
>>>> > > > > > > > ++cc Alexander and Yunsheng.
>>>> > > > > > > > 
>>>> > > > > > > > Thanks for the report
>>>> > > > > > > > 
>>>> > > > > > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
>>>> > > > > > > > > 
>>>> > > > > > > > > While testing fragmented page_pool allocation in the mt76 driver, I was able
>>>> > > > > > > > > to reliably trigger page refcount underflow issues, which did not occur with
>>>> > > > > > > > > full-page page_pool allocation.
>>>> > > > > > > > > It appears to me, that handling refcounting in two separate counters
>>>> > > > > > > > > (page->pp_frag_count and page refcount) is racy when page refcount gets
>>>> > > > > > > > > incremented by code dealing with skb fragments directly, and
>>>> > > > > > > > > page_pool_return_skb_page is called multiple times for the same fragment.
>>>> > > > > > > > > 
>>>> > > > > > > > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
>>>> > > > > > > > > these underflow issues and crashes go away.
>>>> > > > > > > > > 
>>>> > > > > > > > 
>>>> > > > > > > > This has been discussed here [1].  TL;DR changing this to page
>>>> > > > > > > > refcount might blow up in other colorful ways.  Can we look closer and
>>>> > > > > > > > figure out why the underflow happens?
>>>> > > > > > > I don't see how the approch taken in my patch would blow up. From what I 
>>>> > > > > > > can tell, it should be fairly close to how refcount is handled in 
>>>> > > > > > > page_frag_alloc. The main improvement it adds is to prevent it from 
>>>> > > > > > > blowing up if pool-allocated fragments get shared across multiple skbs 
>>>> > > > > > > with corresponding get_page and page_pool_return_skb_page calls.
>>>> > > > > > > 
>>>> > > > > > > - Felix
>>>> > > > > > > 
>>>> > > > > > 
>>>> > > > > > Do you have the patch available to review as an RFC? From what I am
>>>> > > > > > seeing it looks like you are underrunning on the pp_frag_count itself.
>>>> > > > > > I would suspect the issue to be something like starting with a bad
>>>> > > > > > count in terms of the total number of references, or deducing the wrong
>>>> > > > > > amount when you finally free the page assuming you are tracking your
>>>> > > > > > frag count using a non-atomic value in the driver.
>>>> > > > > The driver patches for page pool are here:
>>>> > > > > https://patchwork.kernel.org/project/linux-wireless/patch/64abb23f4867c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
>>>> > > > > https://patchwork.kernel.org/project/linux-wireless/patch/68081e02cbe2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
>>>> > > > > 
>>>> > > > > They are also applied in my mt76 tree at:
>>>> > > > > https://github.com/nbd168/wireless
>>>> > > > > 
>>>> > > > > - Felix
>>>> > > > 
>>>> > > > So one thing I am thinking is that we may be seeing an issue where we
>>>> > > > are somehow getting a mix of frag and non-frag based page pool pages.
>>>> > > > That is the only case I can think of where we might be underflowing
>>>> > > > negative. If you could add some additional debug info on the underflow
>>>> > > > WARN_ON case in page_pool_defrag_page that might be useful.
>>>> > > > Specifically I would be curious what the actual return value is. I'm
>>>> > > > assuming we are only hitting negative 1, but I would want to verify we
>>>> > > > aren't seeing something else.
>>>> > > I'll try to run some more tests soon. However, I think I found the piece 
>>>> > > of code that is incompatible with using pp_frag_count.
>>>> > > When receiving an A-MSDU packet (multiple MSDUs within a single 802.11 
>>>> > > packet), and it is not split by the hardware, a cfg80211 function 
>>>> > > extracts the individual MSDUs into separate skbs. In that case, a 
>>>> > > fragment can be shared across multiple skbs, and get_page is used to 
>>>> > > increase the refcount.
>>>> > > You can find this in net/wireless/util.c: ieee80211_amsdu_to_8023s (and 
>>>> > > its helper functions).
>>>> > 
>>>> > I'm not sure if it is problematic or not. Basically it is trading off
>>>> > by copying over the frags, calling get_page on each frag, and then
>>>> > using dev_kfree_skb to disassemble and release the pp_frag references.
>>>> > There should be other paths in the kernel that are doing something
>>>> > similar.
>>>> > 
>>>> > > This code also has a bug where it doesn't set pp_recycle on the newly 
>>>> > > allocated skb if the previous one has it, but that's a separate matter 
>>>> > > and fixing it doesn't make the crash go away.
>>>> > 
>>>> > Adding the recycle would cause this bug. So one thing we might be
>>>> > seeing is something like that triggering this error. Specifically if
>>>> > the page is taken via get_page when assembling the new skb then we
>>>> > cannot set the recycle flag in the new skb otherwise it will result in
>>>> > the reference undercount we are seeing. What we are doing is shifting
>>>> > the references away from the pp_frag_count to the page reference count
>>>> > in this case. If we set the pp_recycle flag then it would cause us to
>>>> > decrement pp_frag_count instead of the page reference count resulting
>>>> > in the underrun.
>>>> Couldn't leaving out the pp_recycle flag potentially lead to a case 
>>>> where the last user of the page drops it via page_frag_free instead of 
>>>> page_pool_return_skb_page? Is that valid?
>>> 
>>> No. What will happen is that when the pp_frag_count is exhausted the
>>> page will be unmapped and evicted from the page pool. When the page is
>>> then finally freed it will end up going back to the page allocator
>>> instead of page pool.
>>> 
>>> Basically the idea is that until pp_frag_count reaches 0 there will be
>>> at least 1 page reference held.
>>> 
>>>> > > Is there any way I can make that part of the code work with the current 
>>>> > > page pool frag implementation?
>>>> > 
>>>> > The current code should work. Basically as long as the references are
>>>> > taken w/ get_page and skb->pp_recycle is not set then we shouldn't run
>>>> > into this issue because the pp_frag_count will be dropped when the
>>>> > original skb is freed and the page reference count will be decremented
>>>> > when the new one is freed.
>>>> > 
>>>> > For page pool page fragments the main thing to keep in mind is that if
>>>> > pp_recycle is set it will update the pp_frag_count and if it is not
>>>> > then it will just decrement the page reference count.
>>>> What takes care of DMA unmap and other cleanup if the last reference to 
>>>> the page is dropped via page_frag_free?
>>>> 
>>>> - Felix
>>> 
>>> When the page is freed on the skb w/ pp_recycle set it will unmap the
>>> page and evict it from the page pool. Basically in these cases the page
>>> goes from the page pool back to the page allocator.
>>> 
>>> The general idea with this is that if we are using fragments that there
>>> will be enough of them floating around that if one or two frags have a
>>> temporeary detour through a non-recycling path that hopefully by the
>>> time the last fragment is freed the other instances holding the
>>> additional page reference will have let them go. If not then the page
>>> will go back to the page allocator and it will have to be replaced in
>>> the page pool.
>> Thanks for the explanation, it makes sense to me now. Unfortunately it
>> also means that I have no idea what could cause this issue. I will
>> finish my mt76 patch rework which gets rid of the pp vs non-pp
>> allocation mix and re-run my tests to provide updated traces.
> Here's the updated mt76 page pool support commit:
> https://github.com/nbd168/wireless/commit/923cdab6d4c92a0acb3536b3b0cc4af9fee7c808
> 
> And here is the trace that I'm getting with 6.1:
> https://nbd.name/p/a16957f2
> 
> If you have any debug patch you'd like me to test, please let me know.
To answer your earlier question: When pp_frag_count goes below zero, 
it's at -1 as suspected.

Here are some more completely different traces that I got during other 
test runs. I hope they provide some kind of clue:
https://nbd.name/p/8e46b6eb

- Felix

