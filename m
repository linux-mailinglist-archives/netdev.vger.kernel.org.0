Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496C567B8A2
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjAYRdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjAYRc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:32:58 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640783FF0F;
        Wed, 25 Jan 2023 09:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3VacIbLBiMOhdjlcuByoG7gGM7xUYGYFkEPVlu6Em48=; b=h2StGSQRKZxe1aFbjtLPsZ5C+K
        jxWy6y3GJKfVnMUmiyqrCM/f+WfvXFKpR3XoA9CoUCahSZJT92fl99XPDslB10zNNe5mPdhbPIbLz
        6gd9mmdA0UGZbz16xYkwWwJBPH1zXvZHwe6HoBg3iKFo/0iL6ZRBuon/zVrVpiJ+7c78=;
Received: from p200300daa720fc00bca81b24a24bb07d.dip0.t-ipconnect.de ([2003:da:a720:fc00:bca8:1b24:a24b:b07d] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pKjdg-002P3e-SW; Wed, 25 Jan 2023 18:32:48 +0100
Message-ID: <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
Date:   Wed, 25 Jan 2023 18:32:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Content-Language: en-US
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
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
In-Reply-To: <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
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

On 25.01.23 18:11, Alexander H Duyck wrote:
> On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
>> On 24.01.23 22:10, Alexander H Duyck wrote:
>> > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
>> > > On 24.01.23 15:11, Ilias Apalodimas wrote:
>> > > > Hi Felix,
>> > > > 
>> > > > ++cc Alexander and Yunsheng.
>> > > > 
>> > > > Thanks for the report
>> > > > 
>> > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
>> > > > > 
>> > > > > While testing fragmented page_pool allocation in the mt76 driver, I was able
>> > > > > to reliably trigger page refcount underflow issues, which did not occur with
>> > > > > full-page page_pool allocation.
>> > > > > It appears to me, that handling refcounting in two separate counters
>> > > > > (page->pp_frag_count and page refcount) is racy when page refcount gets
>> > > > > incremented by code dealing with skb fragments directly, and
>> > > > > page_pool_return_skb_page is called multiple times for the same fragment.
>> > > > > 
>> > > > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
>> > > > > these underflow issues and crashes go away.
>> > > > > 
>> > > > 
>> > > > This has been discussed here [1].  TL;DR changing this to page
>> > > > refcount might blow up in other colorful ways.  Can we look closer and
>> > > > figure out why the underflow happens?
>> > > I don't see how the approch taken in my patch would blow up. From what I 
>> > > can tell, it should be fairly close to how refcount is handled in 
>> > > page_frag_alloc. The main improvement it adds is to prevent it from 
>> > > blowing up if pool-allocated fragments get shared across multiple skbs 
>> > > with corresponding get_page and page_pool_return_skb_page calls.
>> > > 
>> > > - Felix
>> > > 
>> > 
>> > Do you have the patch available to review as an RFC? From what I am
>> > seeing it looks like you are underrunning on the pp_frag_count itself.
>> > I would suspect the issue to be something like starting with a bad
>> > count in terms of the total number of references, or deducing the wrong
>> > amount when you finally free the page assuming you are tracking your
>> > frag count using a non-atomic value in the driver.
>> The driver patches for page pool are here:
>> https://patchwork.kernel.org/project/linux-wireless/patch/64abb23f4867c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
>> https://patchwork.kernel.org/project/linux-wireless/patch/68081e02cbe2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
>> 
>> They are also applied in my mt76 tree at:
>> https://github.com/nbd168/wireless
>> 
>> - Felix
> 
> So one thing I am thinking is that we may be seeing an issue where we
> are somehow getting a mix of frag and non-frag based page pool pages.
> That is the only case I can think of where we might be underflowing
> negative. If you could add some additional debug info on the underflow
> WARN_ON case in page_pool_defrag_page that might be useful.
> Specifically I would be curious what the actual return value is. I'm
> assuming we are only hitting negative 1, but I would want to verify we
> aren't seeing something else.
I'll try to run some more tests soon. However, I think I found the piece 
of code that is incompatible with using pp_frag_count.
When receiving an A-MSDU packet (multiple MSDUs within a single 802.11 
packet), and it is not split by the hardware, a cfg80211 function 
extracts the individual MSDUs into separate skbs. In that case, a 
fragment can be shared across multiple skbs, and get_page is used to 
increase the refcount.
You can find this in net/wireless/util.c: ieee80211_amsdu_to_8023s (and 
its helper functions).
This code also has a bug where it doesn't set pp_recycle on the newly 
allocated skb if the previous one has it, but that's a separate matter 
and fixing it doesn't make the crash go away.
Is there any way I can make that part of the code work with the current 
page pool frag implementation?

> Also just to confirm this is building on 64b kernel correct? Just want
> to make sure we don't have this running on a 32b setup where the frag
> count and the upper 32b of the DMA address are overlapped.
Yes, I'm using a 64b kernel.

> As far as the patch set I only really see a few minor issues which I am
> going to post a few snippets below.
> 
> 
>> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c
>> b/drivers/net/wireless/mediatek/mt76/dma.c
>> index 611769e445fa..7fd9aa9c3d9e 100644
> 
> ...
> 
>> @@ -593,25 +593,28 @@  mt76_dma_rx_fill(struct mt76_dev *dev, struct
>> mt76_queue *q)
>>  
>>  	while (q->queued < q->ndesc - 1) {
>>  		struct mt76_queue_buf qbuf;
>> -		void *buf = NULL;
>> +		dma_addr_t addr;
>> +		int offset;
>> +		void *buf;
>>  
>> -		buf = page_frag_alloc(&q->rx_page, q->buf_size,
>> GFP_ATOMIC);
>> +		buf = mt76_get_page_pool_buf(q, &offset, q-
>> >buf_size);
>>  		if (!buf)
>>  			break;
>>  
>> -		addr = dma_map_single(dev->dma_dev, buf, len,
>> DMA_FROM_DEVICE);
>> +		addr = dma_map_single(dev->dma_dev, buf + offset,
>> len,
>> +				      DMA_FROM_DEVICE);
> 
> Offset was already added to buf in mt76_get_page_pool_buf so the DMA
> mapping offset doesn't look right to me.
Right. This is resolved by the follow-up patch which keeps pages DMA 
mapped. I plan on squashing both patches into one and adding some fixes 
on top when the underlying page pool issue is resolved.

>>  		if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
>> {
>> -			skb_free_frag(buf);
>> +			mt76_put_page_pool_buf(buf, allow_direct);
>>  			break;
>>  		}
>>  
> 
> I'm not a fan of the defensive programming in mt76_put_page_pool_buf.
> If you are in an area that is using page pool you should be using the
> page pool version of the freeing operations instead of adding
> additional overhead that can mess things up by having it have to also
> check for if the page is a page pool page or not.
See below.

>> -		qbuf.addr = addr + offset;
>> -		qbuf.len = len - offset;
>> +		qbuf.addr = addr + q->buf_offset;
>> +		qbuf.len = len - q->buf_offset;
>>  		qbuf.skip_unmap = false;
>>  		if (mt76_dma_add_rx_buf(dev, q, &qbuf, buf) < 0) {
>>  			dma_unmap_single(dev->dma_dev, addr, len,
>>  					 DMA_FROM_DEVICE);
>> -			skb_free_frag(buf);
>> +			mt76_put_page_pool_buf(buf, allow_direct);
>>  			break;
>>  		}
>>  		frames++;
> 
> ...
> 
>> @@ -848,6 +847,8 @@  mt76_dma_rx_process(struct mt76_dev *dev, struct
>> mt76_queue *q, int budget)
>>  			goto free_frag;
>>  
>>  		skb_reserve(skb, q->buf_offset);
>> +		if (mt76_is_page_from_pp(data))
>> +			skb_mark_for_recycle(skb);
>>  
>>  		*(u32 *)skb->cb = info;
>>  
> 
> More defensive programming here. Is there a path that allows for a
> mixed setup?
> 
> The only spot where I can see there being anything like that is in
> /drivers/net/wireless/mediatek/mt76/mt7915/mmio.c. But it doesn't make
> any sense to me as to why it was included in the patch. It might be
> easier to sort out the issue if we were to get rid of some of the
> defensive programming.
This is not defensive programming. In its current state, there is a 
scenario where we can have a mix of pp and non-pp pages (if hardware 
offload support is enabled).
However in my tests, offload support was disabled and all pages are PP 
ones.
I also have some unpublished pending changes to always allocate from the 
pool (even for the initial buffers allocated for offloading).
This did not make a difference in my tests though.

- Felix
