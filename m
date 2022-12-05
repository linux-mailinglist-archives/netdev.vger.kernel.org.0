Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B9A642BE5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiLEPfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiLEPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:35:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7FBDC0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670254456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muzN8WEUVh1Z0hOwGhW5wqwCu57eFzBWrtNL2xNCBTc=;
        b=Ol5Zl0kpwY/pMr16AJQc//IIQEfUW8RuEtafPPmKY56HoDl5ylkNogkIDgo4vIMMLNc26N
        q/yUti072DBG2gGtfuWMnhLtfly3E/NgJ0KKs8fzVaOMr3gYQar1hMBLFVROSEymXTGb6g
        2yCPmDx69UpvPsBQmZEMQkn4lXz4jig=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-x_ipDhHiNdup3tjNP9ufbA-1; Mon, 05 Dec 2022 10:34:14 -0500
X-MC-Unique: x_ipDhHiNdup3tjNP9ufbA-1
Received: by mail-ej1-f70.google.com with SMTP id ga41-20020a1709070c2900b007aef14e8fd7so7737561ejc.21
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:34:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=muzN8WEUVh1Z0hOwGhW5wqwCu57eFzBWrtNL2xNCBTc=;
        b=XCF4z1vUifLqaauLF3TUbcu1aSY05b7GxoF7WM9aC8kb5sLQeEQqbFHJAh81f8Tw4A
         BY9U+IANwdoBQ+HodF4EuRVWd982PTTuf1XveLpqojrwWi+anipAGx2+Xay+IMxbDQoS
         /r+eYNILJvgUjRj/NxBOWXGv2NkeruQK1Zc3Cgwgo9E9CzMyDImmFtt1QdLrWhAWuhHb
         APhH6vH2z/257f8MxossIJMm2J1Pr9HghB/ZKndUH6qQPJDGsAQCsG41lNfRNF/QI7jO
         T6s/Z5Pih10ho3qdxxuNl2b4SErQ/VE/GFIxe9HhKmtnU00q8YWTB4T3DxJ85eKven4w
         W+KQ==
X-Gm-Message-State: ANoB5pnqV8rDhzxEQ5ObE4VIItTpTFkN6zf+F++OheLwS2OVpB5AEGrb
        ZHsGYBo3U2Gf35vu8jK0u7ELsbiFbNJbfftLxqJSJxCJDW9HladNNTX8IBjtgW0n+NaVNm+Kfyx
        V+bxbVH5UbXUaQEva
X-Received: by 2002:a17:906:7244:b0:7ae:2964:72dc with SMTP id n4-20020a170906724400b007ae296472dcmr45976476ejk.111.1670254452824;
        Mon, 05 Dec 2022 07:34:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4YSL+fUvabB9FXexYRha1NrlEMMAkmKnUeYM8sAueMcqb0lGmkqOQXVjTmnT31HWfW7O5Gpg==
X-Received: by 2002:a17:906:7244:b0:7ae:2964:72dc with SMTP id n4-20020a170906724400b007ae296472dcmr45976464ejk.111.1670254452609;
        Mon, 05 Dec 2022 07:34:12 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id si1-20020a170906cec100b007c0dcb30103sm2659470ejb.103.2022.12.05.07.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 07:34:12 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
Date:   Mon, 5 Dec 2022 16:34:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20221130220803.3657490-1-willy@infradead.org>
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/11/2022 23.07, Matthew Wilcox (Oracle) wrote:
> The MM subsystem is trying to reduce struct page to a single pointer.
> The first step towards that is splitting struct page by its individual
> users, as has already been done with folio and slab.  This attempt chooses
> 'netmem' as a name, but I am not even slightly committed to that name,
> and will happily use another.

I've not been able to come-up with a better name, so I'm okay with
'netmem'.  Others are of-cause free to bikesheet this ;-)

> There are some relatively significant reductions in kernel text
> size from these changes.  I'm not qualified to judge how they
> might affect performance, but every call to put_page() includes
> a call to compound_head(), which is now rather more complex
> than it once was (at least in a distro config which enables
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP).
> 

I have a micro-benchmark [1][2], that I want to run on this patchset.
Reducing the asm code 'text' size is less likely to improve a
microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
run a packet benchmark that can show the (expected) performance improvement.

[1] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
[2] 
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c

> I've only converted one user of the page_pool APIs to use the new netmem
> APIs, all the others continue to use the page based ones.
> 

I guess we/netdev-devels need to update the NIC drivers that uses page_pool.

> Uh, I see I left netmem_to_virt() as its own commit instead of squashing
> it into "netmem: Add utility functions".  I'll fix that in the next
> version, because I'm sure you'll want some changes anyway.
> 
> Happy to answer questions.
> 
> Matthew Wilcox (Oracle) (24):
>    netmem: Create new type
>    netmem: Add utility functions
>    page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
>    page_pool: Convert page_pool_release_page() to
>      page_pool_release_netmem()
>    page_pool: Start using netmem in allocation path.
>    page_pool: Convert page_pool_return_page() to
>      page_pool_return_netmem()
>    page_pool: Convert __page_pool_put_page() to __page_pool_put_netmem()
>    page_pool: Convert pp_alloc_cache to contain netmem
>    page_pool: Convert page_pool_defrag_page() to
>      page_pool_defrag_netmem()
>    page_pool: Convert page_pool_put_defragged_page() to netmem
>    page_pool: Convert page_pool_empty_ring() to use netmem
>    page_pool: Convert page_pool_alloc_pages() to page_pool_alloc_netmem()
>    page_pool: Convert page_pool_dma_sync_for_device() to take a netmem
>    page_pool: Convert page_pool_recycle_in_cache() to netmem
>    page_pool: Remove page_pool_defrag_page()
>    page_pool: Use netmem in page_pool_drain_frag()
>    page_pool: Convert page_pool_return_skb_page() to use netmem
>    page_pool: Convert frag_page to frag_nmem
>    xdp: Convert to netmem
>    mm: Remove page pool members from struct page
>    netmem_to_virt
>    page_pool: Pass a netmem to init_callback()
>    net: Add support for netmem in skb_frag
>    mvneta: Convert to netmem
> 
>   drivers/net/ethernet/marvell/mvneta.c |  48 ++---
>   include/linux/mm_types.h              |  22 ---
>   include/linux/skbuff.h                |  11 ++
>   include/net/page_pool.h               | 181 ++++++++++++++---
>   include/trace/events/page_pool.h      |  28 +--
>   net/bpf/test_run.c                    |   4 +-
>   net/core/page_pool.c                  | 274 +++++++++++++-------------
>   net/core/xdp.c                        |   7 +-
>   8 files changed, 344 insertions(+), 231 deletions(-)
> 
> 
> base-commit: 13ee7ef407cfcf63f4f047460ac5bb6ba5a3447d

