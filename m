Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B1642A8F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiLEOnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLEOnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:43:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FE411A15
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 06:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670251378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eM4zhW3ULwVjqLAlsN3191N8vcp7iRGoi/osZC3zlYo=;
        b=WrIiSmH1DHo/meNCKlX4BtOGwEcOyPRzsFHy+qCuAiMigTHWklfAAJwBkjRImzK8wg6dXs
        UHpcsYAdmn6Ncdk9jgVsGhp5Lz8ycJ/SVZxEpAY642K5i7OPdX3ow7OTRldtw6Ff1Zt2DS
        8Te2YZIx6HUjHbB2WrI/saTSGT/K4Wg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-d0nEQq3QOPO4y8QedUGQ8A-1; Mon, 05 Dec 2022 09:42:57 -0500
X-MC-Unique: d0nEQq3QOPO4y8QedUGQ8A-1
Received: by mail-ej1-f72.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so1177369ejc.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 06:42:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eM4zhW3ULwVjqLAlsN3191N8vcp7iRGoi/osZC3zlYo=;
        b=pFX14s6NCdLKePk5VlB2uCDw4ic9h+Ke/IWbL2Fj2bfBMy8Bbz2eLVjndhblzJtlop
         lPIbhvRr4LMaBT2ZmiLGWkelev5kHSfslToCZYwZJQ9mhaPrpaCvHLcQ2AfyU4CcsPTn
         QZwy3NDFnwXnJYxTvx/83VW3ymNTwEBB1RgeM8xJUH92VKCw3OnqhjacZMnAfw9VptOb
         Kwd+Uftpr3tSLSjaa+DjpkL6Wh1rptU5R3xz52Y8OrP5mUrBr1IFpstuRvofGiV1n9zo
         N4lzBjGMpcRC7aFRG2rRxu+5uYTVHpYjpJ92rNqafMbcIQyEf69K3gveLB10/ykX+aYt
         x3Kw==
X-Gm-Message-State: ANoB5pk+HVGbIv62QUuS32KUYSQu7v6Lz+/bxi8cFM8NpfMvoadRK6U2
        W2kijmoIGWBqY/j326BpznQHnovzFKcF8im+6G5F6d2QLZLhyTLK/bSajAHm59c2/+nRq9YL89L
        QgBNOdLeD0dCmib2B
X-Received: by 2002:a17:906:8465:b0:7bd:7253:457a with SMTP id hx5-20020a170906846500b007bd7253457amr15827607ejc.81.1670251376356;
        Mon, 05 Dec 2022 06:42:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4TpgWofZbiz5zOuXQYj4T4dx/JXh04G1jvnEp1n0hEwc1mGr5LlvNNsQnNzrMF3YDoEa/80A==
X-Received: by 2002:a17:906:8465:b0:7bd:7253:457a with SMTP id hx5-20020a170906846500b007bd7253457amr15827594ejc.81.1670251376112;
        Mon, 05 Dec 2022 06:42:56 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ev24-20020a056402541800b0046ab2bd784csm6159784edb.64.2022.12.05.06.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 06:42:55 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d2eb4ff6-1ef4-cc7c-74b1-8d0281c8e17c@redhat.com>
Date:   Mon, 5 Dec 2022 15:42:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/24] netmem: Create new type
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20221130220803.3657490-1-willy@infradead.org>
 <20221130220803.3657490-2-willy@infradead.org>
Content-Language: en-US
In-Reply-To: <20221130220803.3657490-2-willy@infradead.org>
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
> As part of simplifying struct page, create a new netmem type which
> mirrors the page_pool members in struct page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/net/page_pool.h | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 813c93499f20..af6ff8c302a0 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -50,6 +50,47 @@
>   				 PP_FLAG_DMA_SYNC_DEV |\
>   				 PP_FLAG_PAGE_FRAG)
>   
> +/* page_pool used by netstack */

Can we improve the comment, making in more clear that this netmem struct
is mirroring/sharing/using part of struct page?

My proposal:

/* page_pool used by netstack mirrors/uses members in struct page */

> +struct netmem {
> +	unsigned long flags;		/* Page flags */
> +	/**
> +	 * @pp_magic: magic value to avoid recycling non
> +	 * page_pool allocated pages.
> +	 */
> +	unsigned long pp_magic;
> +	struct page_pool *pp;
> +	unsigned long _pp_mapping_pad;
> +	unsigned long dma_addr;
> +	union {
> +		/**
> +		 * dma_addr_upper: might require a 64-bit
> +		 * value on 32-bit architectures.
> +		 */
> +		unsigned long dma_addr_upper;
> +		/**
> +		 * For frag page support, not supported in
> +		 * 32-bit architectures with 64-bit DMA.
> +		 */
> +		atomic_long_t pp_frag_count;
> +	};
> +	atomic_t _mapcount;
> +	atomic_t _refcount;
> +};
> +
> +#define NETMEM_MATCH(pg, nm)						\
> +	static_assert(offsetof(struct page, pg) == offsetof(struct netmem, nm))
> +NETMEM_MATCH(flags, flags);
> +NETMEM_MATCH(lru, pp_magic);
> +NETMEM_MATCH(pp, pp);
> +NETMEM_MATCH(mapping, _pp_mapping_pad);
> +NETMEM_MATCH(dma_addr, dma_addr);
> +NETMEM_MATCH(dma_addr_upper, dma_addr_upper);
> +NETMEM_MATCH(pp_frag_count, pp_frag_count);
> +NETMEM_MATCH(_mapcount, _mapcount);
> +NETMEM_MATCH(_refcount, _refcount);
> +#undef NETMEM_MATCH
> +static_assert(sizeof(struct netmem) <= sizeof(struct page));
> +
>   /*
>    * Fast allocation side cache array/stack
>    *

