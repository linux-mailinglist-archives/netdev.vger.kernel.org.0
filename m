Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC16666F65
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjALKTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbjALKS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:18:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792B3DF1E
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673518559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMNXrvSE2aga+o/RgOoJzujCgiYF9dT+3d+ZakF9oZs=;
        b=N6R5bOkEIG60vaddOfMsLinQ07tap7+MEHWzLl9jHnlOdOWeapAeDhCpIVuVmrIclqOI7/
        y8c1dGqG3/lRIL70Hf3mz8JZxXqcuWJ2cxOu4o4nPqUnONVrjnVIwDk4RSbtR2I0uH4xKV
        yfcMralkbCLZC2xS8XpqviM/MvMK9eg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-rnC8MjG6Msmi8Ufwqg4o0w-1; Thu, 12 Jan 2023 05:15:58 -0500
X-MC-Unique: rnC8MjG6Msmi8Ufwqg4o0w-1
Received: by mail-ej1-f69.google.com with SMTP id nb4-20020a1709071c8400b0084d4712780bso8647083ejc.18
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:15:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMNXrvSE2aga+o/RgOoJzujCgiYF9dT+3d+ZakF9oZs=;
        b=Mj/iG4cSY4cdcBI6vOSnSs1Y+kTjAJiAPv1w8ze3JkR+CjYMNTuEiMFzSwNCWGKR8W
         5ng5DFIKh13JG0rLdndfEnmN5RQ58eyxR29JNrp8S80QYbVevIOx3EzskzB1D745qv/R
         eKZHNF+fyurCIz3yqARUwoBG6khRFiDDUxGyYffTtdpFCBD2o5GldodomWoXzdUCrZIr
         l62WvZoa272DHGQErXPIDqWT8qvGzOsgryO0p4e2xmLq6EMUzyyYfygqIoK6O4K4zUa4
         SiVir0eGG6CE2B1Loj9A381ykCBnGj2I4V5azucnC6yKRwts+B/OZ8VnBJvPbCURAYER
         vS7g==
X-Gm-Message-State: AFqh2koqx+GlXdHWbHjHZsX9a9TcUYrsyDe58BxkCbhvWSOlTrn3r7Aj
        /PSIkmH66aWeVpeSqYVXxbdtzGRInSQWMVKK2FDhzz6qrT8CRZRe3FOWhmPO+Ymh0oDRYgbRJkX
        8k8nDkpp6Uplcn5GN
X-Received: by 2002:a17:906:8506:b0:862:29a8:4f83 with SMTP id i6-20020a170906850600b0086229a84f83mr3993387ejx.44.1673518557456;
        Thu, 12 Jan 2023 02:15:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtkcVajjWWSt7t5RB5kVq1DuuoB94cjPwtzhRey2mV8IYVgluqsU4isz9crCYpqj2FXBovy3g==
X-Received: by 2002:a17:906:8506:b0:862:29a8:4f83 with SMTP id i6-20020a170906850600b0086229a84f83mr3993374ejx.44.1673518557264;
        Thu, 12 Jan 2023 02:15:57 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id nd38-20020a17090762a600b0084d1b34973dsm7267091ejc.61.2023.01.12.02.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:15:56 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9cdc89f3-8c00-3673-5fdb-4f5bebd95d7a@redhat.com>
Date:   Thu, 12 Jan 2023 11:15:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 00/26] Split netmem from struct page
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <20230111042214.907030-1-willy@infradead.org>
 <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
 <Y763vcTFUZvWNgYv@casper.infradead.org>
In-Reply-To: <Y763vcTFUZvWNgYv@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/01/2023 14.21, Matthew Wilcox wrote:
> On Wed, Jan 11, 2023 at 04:25:46PM +0800, Yunsheng Lin wrote:
>> On 2023/1/11 12:21, Matthew Wilcox (Oracle) wrote:
>>> The MM subsystem is trying to reduce struct page to a single pointer.
>>> The first step towards that is splitting struct page by its individual
>>> users, as has already been done with folio and slab.  This patchset does
>>> that for netmem which is used for page pools.
>> As page pool is only used for rx side in the net stack depending on the
>> driver, a lot more memory for the net stack is from page_frag_alloc_align(),
>> kmem cache, etc.
>> naming it netmem seems a little overkill, perhaps a more specific name for
>> the page pool? such as pp_cache.
>>
>> @Jesper & Ilias
>> Any better idea?

I like the 'netmem' name.

>> And it seem some API may need changing too, as we are not pooling 'pages'
>> now.

IMHO it would be overkill to rename the page_pool to e.g. netmem_pool.
as it would generate too much churn and will be hard to follow in git
as the code filename page_pool.c would also have to be renamed.
It guess we keep page_pool for historical reasons ;-)

> I raised the question of naming in v1, six weeks ago, and nobody had
> any better names.  Seems a little unfair to ignore the question at first
> and then bring it up now.  I'd hate to miss the merge window because of
> a late-breaking major request like this.
> 
> https://lore.kernel.org/netdev/20221130220803.3657490-1-willy@infradead.org/
> 
> I'd like to understand what we think we'll do in networking when we trim
> struct page down to a single pointer,  All these usages that aren't from
> page_pool -- what information does networking need to track per-allocation?
> Would it make sense for the netmem to describe all memory used by the
> networking stack, and have allocators other than page_pool also return
> netmem, 

This is also how I see the future, that other netstack "allocators" can
return and work-with 'netmem' objects.   IMHO we are already cramming
too many use-cases into page_pool (like the frag support Yunsheng
added).  IMHO there are room for other netstack "allocators" that can
utilize netmem.  The page_pool is optimized for RX-NAPI workloads, using
it for other purposes is a mistake IMHO.  People should create other
netstack "allocators" that solves their specific use-cases.  E.g. The TX
path likely needs another "allocator" optimized for this TX use-case.

> or does the normal usage of memory in the net stack not need to
> track that information?

The page refcnt is (obviously) used by netstack as tracked information.
I have seen drivers that use the DMA mapping directly in page/'netmem',
instead of having to store this separately in the drivers.

--Jesper

