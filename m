Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD02674094
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjASSJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjASSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1478C93F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674151743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/gO3d3tfSy1H0tWMkbcVJW8vhTKCMyI1UuEUKguo/Y=;
        b=ZI83TLxk3oozqVive3rSkHj5RwSvFfZZhMfHfipXysxACNN9htd1N9BpxNdhr0GQ2ZjAkw
        fZwvrRPfgz7nFslwISM8E2n5D4JZjglbavwWdvP7wqENB7aQQ0qzw2YbEm9d9S5CW7r3cO
        TUR5Tx0l/Xm5ZKpetqmRqHmqDXR8u5g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-232-aa3d7rN5P5a7XgB9BRML0A-1; Thu, 19 Jan 2023 13:09:02 -0500
X-MC-Unique: aa3d7rN5P5a7XgB9BRML0A-1
Received: by mail-ed1-f69.google.com with SMTP id z20-20020a05640240d400b0049e1b5f6175so2137666edb.8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/gO3d3tfSy1H0tWMkbcVJW8vhTKCMyI1UuEUKguo/Y=;
        b=ei2WaZOoi4bXAEqhe6WWdeBTQ2u3GbZ1NetQCUOhayKvO+GB0vt145oP4UHQfafgt5
         W1h//Dl+sS0roskDWZVcUGjIvlnVzeIEnWZmmthmLwi1+gDWkXrEgz5IE0tYTwAGwEiR
         cLGNYST1P9iJJiTXrSZH+1CmLKxqwoDxi0HJP1C9VVRS4xCujoJm+H72DAI87Smx7Qh5
         ovLoL9j1ce4Z/tp7HweIkH3F13XAXv5R5LwcI1NVIosL+XAm1ed4Fc32tSfUwoFAKX14
         XP3pg9mDJovW5gLYR+YVVsDnc1UqYHz4T0Ro+WdSYtItXWGmJM33eT3y3wlgHDNBSfVL
         QhDA==
X-Gm-Message-State: AFqh2kqJsvZ3LczTpe8axehD3dZvfKOimSZ6F0aYfmkNSmsARe8hex+9
        /mi2sAZ5rMNj5WnSy9Yg2BsEU8T6DKusKU8SLpmk3Dqo1cyj5bHNgz7mIN/CpPeMr3sOS9zK08f
        WoyP8b8/2z7/cFzxa
X-Received: by 2002:a17:906:6313:b0:872:6508:190 with SMTP id sk19-20020a170906631300b0087265080190mr13152918ejc.6.1674151740741;
        Thu, 19 Jan 2023 10:09:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXskSUFliZvu7tLh4HONJuC8MzSqGjXFZUGF0GwT6v3T+8rLu4AkXCUJD4g5uFbFtEzsZMuhpA==
X-Received: by 2002:a17:906:6313:b0:872:6508:190 with SMTP id sk19-20020a170906631300b0087265080190mr13152901ejc.6.1674151740535;
        Thu, 19 Jan 2023 10:09:00 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id k22-20020a17090646d600b0085fc3dec567sm11281206ejs.175.2023.01.19.10.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 10:08:59 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <a1887f2d-fc3a-116e-6d52-fdc62e51b074@redhat.com>
Date:   Thu, 19 Jan 2023 19:08:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        vbabka@suse.cz, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Christoph Lameter <cl@gentwo.de>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
 <Y8eA2xZ0KC2ZDinu@casper.infradead.org>
In-Reply-To: <Y8eA2xZ0KC2ZDinu@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 06.17, Matthew Wilcox wrote:
> On Tue, Jan 17, 2023 at 03:54:34PM +0100, Christoph Lameter wrote:
>> On Tue, 17 Jan 2023, Jesper Dangaard Brouer wrote:
>>
>>> When running different network performance microbenchmarks, I started
>>> to notice that performance was reduced (slightly) when machines had
>>> longer uptimes. I believe the cause was 'skbuff_head_cache' got
>>> aliased/merged into the general slub for 256 bytes sized objects (with
>>> my kernel config, without CONFIG_HARDENED_USERCOPY).
>>
>> Well that is a common effect that we see in multiple subsystems. This is
>> due to general memory fragmentation. Depending on the prior load the
>> performance could actually be better after some runtime if the caches are
>> populated avoiding the page allocator etc.
> 
> The page allocator isn't _that_ expensive.  I could see updating several
> slabs being more expensive than allocating a new page.
> 

For 10Gbit/s wirespeed small frames I have 201 cycles as budget.

I prefer to measure things, so lets see what page alloc cost, but also
relate this to how much this is per 4096 bytes.

  alloc_pages order:0(4096B/x1)    246 cycles per-4096B 246 cycles
  alloc_pages order:1(8192B/x2)    300 cycles per-4096B 150 cycles
  alloc_pages order:2(16384B/x4)   328 cycles per-4096B 82 cycles
  alloc_pages order:3(32768B/x8)   357 cycles per-4096B 44 cycles
  alloc_pages order:4(65536B/x16)  516 cycles per-4096B 32 cycles
  alloc_pages order:5(131072B/x32) 801 cycles per-4096B 25 cycles

I looked back at my MM-presentation[2016][2017], and notice that in
[2017] I reported that Mel have improved order-0 page cost to 143 cycles
in kernel 4.11-rc1.  According to above measurements kernel have
regressed in performance.


[2016] 
https://people.netfilter.org/hawk/presentations/MM-summit2016/generic_page_pool_mm_summit2016.pdf
[2017] 
https://people.netfilter.org/hawk/presentations/MM-summit2017/MM-summit2017-JesperBrouer.pdf


>> The merging could actually be beneficial since there may be more partial
>> slabs to allocate from and thus avoiding expensive calls to the page
>> allocator.
> 
> What might be more effective is allocating larger order slabs.  I see
> that kmalloc-256 allocates a pair of pages and manages 32 objects within
> that pair.  It should perform better in Jesper's scenario if it allocated
> 4 pages and managed 64 objects per slab.
> 
> Simplest way to test that should be booting a kernel with
> 'slub_min_order=2'.  Does that help matters at all, Jesper?  You could
> also try slub_min_order=3.  Going above that starts to get a bit sketchy.
> 

I have tried this slub_min_order trick before, and it did help.  I've
not tested it is recently.

--Jesper

