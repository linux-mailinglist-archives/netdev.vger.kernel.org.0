Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3FA679F57
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjAXQ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjAXQ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:59:32 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1802C45F65;
        Tue, 24 Jan 2023 08:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vrvS0O+llQYRil9ynaqdlGzYPZUKr/Kefp2saemjElA=; b=r91OGRXZXRjjZnruATKKz9uTSr
        R/cd+xuX5Px9QghPWmqICtdInXIbG64l4jATDAx/zf9qL4xqeY6wSfbotvyyS0IUSjHRey3W1+e5c
        P0umuKEzVy949cz6gbSC6WAY3wWjP7NmuVaDfBSG+IJ+1maKwV9n0OfY1oD4RqkYnLOk=;
Received: from [2a01:598:b1ac:c6:f0db:950f:e1fc:548d] (helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pKMdm-0025sj-5u; Tue, 24 Jan 2023 17:59:22 +0100
Message-ID: <1976fa04-5298-6028-0086-abd51161f2f7@nbd.name>
Date:   Tue, 24 Jan 2023 17:59:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
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
 <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
In-Reply-To: <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
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

On 24.01.23 16:57, Alexander H Duyck wrote:
> On Tue, 2023-01-24 at 16:11 +0200, Ilias Apalodimas wrote:
>> Hi Felix,
>> 
>> ++cc Alexander and Yunsheng.
>> 
>> Thanks for the report
>> 
>> On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
>> > 
>> > While testing fragmented page_pool allocation in the mt76 driver, I was able
>> > to reliably trigger page refcount underflow issues, which did not occur with
>> > full-page page_pool allocation.
>> > It appears to me, that handling refcounting in two separate counters
>> > (page->pp_frag_count and page refcount) is racy when page refcount gets
>> > incremented by code dealing with skb fragments directly, and
>> > page_pool_return_skb_page is called multiple times for the same fragment.
>> > 
>> > Dropping page->pp_frag_count and relying entirely on the page refcount makes
>> > these underflow issues and crashes go away.
>> > 
>> 
>> This has been discussed here [1].  TL;DR changing this to page
>> refcount might blow up in other colorful ways.  Can we look closer and
>> figure out why the underflow happens?
>> 
>> [1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-linyunsheng@huawei.com/
>> 
>> Thanks
>> /Ilias
>> 
>> 
> 
> The logic should be safe in terms of the page pool itself as it should
> be holding one reference to the page while the pp_frag_count is non-
> zero. That one reference is what keeps the two halfs in sync as the
> page shouldn't be able to be freed until we exhaust the pp_frag_count.
> 
> To have an underflow there are two possible scenarios. One is that
> either put_page or free_page is being called somewhere that the
> page_pool freeing functions should be used. The other possibility is
> that a pp_frag_count reference was taken somewhere a page reference
> should have.
> 
> Do we have a backtrace for the spots that are showing this underrun? If
> nothing else we may want to look at tracking down the spots that are
> freeing the page pool pages via put_page or free_page to determine what
> paths these pages are taking.
Here's an example of the kind of traces that I was seeing with v6.1:
https://nbd.name/p/61a6617e
On v5.15 I also occasionally got traces like this:
https://nbd.name/p/0b9e4f0d

 From what I can tell, it also triggered the warning that shows up when 
page->pp_frag_count underflows. Unfortunately these traces don't 
directly point to the place where things go wrong.
I do wonder if the pp_frag_count is maybe racy when we have a mix of 
get_page + page_pool_put_page calls.

In case you're wondering what I was doing to trigger the crash: I simply 
create 4 wireless client mode interfaces on the same card and pushed TCP 
traffic from an AP to all 4 simultaneously. I can trigger it pretty much 
immediately after TCP traffic ramps up.

- Felix
