Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C48663D7B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjAJKF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAJKF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:05:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA63D89
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673345077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1oSeVU9ewoRTMDNTtzATyBMRUBuwdDAzXDzbPyCwHOU=;
        b=dqBctDP1KQkq+U2n7P6XHOUOBtkRmodnXSyANcDF9oHhCHm/qFuvZW6+H4tRL95i2NlHI7
        l/JU/zWyxWOWFuxi0IXUPhOKwBv+m5S9vk3badr8tcA3SUxktJ+Zt+SDIp+jFeGk8N4Nbl
        9umsk1QnfVatmwbsb79OAEB9y5MXv+c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-7-ueAlAvIjPKa9f1CxGoQB9A-1; Tue, 10 Jan 2023 05:04:36 -0500
X-MC-Unique: ueAlAvIjPKa9f1CxGoQB9A-1
Received: by mail-ej1-f72.google.com with SMTP id hp2-20020a1709073e0200b0084d47e3fe82so3502926ejc.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:04:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oSeVU9ewoRTMDNTtzATyBMRUBuwdDAzXDzbPyCwHOU=;
        b=ujpqcRBcFWhSlB71g4oCw0wT8VmWU0sr0N+y5keFAKqJ54iccxRwzTaGOTVckGSwfW
         HMaY3CcJDXwexOXyUSe9XlOZleksq+unaL/5MM7i48gQwb6U4M8WJOz1qM50nnrcfWeK
         keU0opkIDd7bZbsoCsdfk9FkQ5sU5KlfEIdvORnYyT+1NZwBkujrKWPwjuAvNy+/Uhhk
         C23mjjvFwWfZzpJQvyJ4spt2rcIBsCD7X3b4BDKBVVyCyfUC32ds1leQMXQfydTilpOy
         Vm0SL7QS4QjmbXdRgC7CPuy2c8TyfOire6bnPQawQGrWyLhVvZDNW6+SntFRxiDItHv5
         pB2w==
X-Gm-Message-State: AFqh2koL21pdz6Ccq6RLkontjByGSlPZ4IUytD2v9VFxdB7dqpgb+OI5
        LgGgoQ2L0MhjFWBY+EVcOm/XB47+Lxd5lmnSSE0mebwewUBazyNrV0xZCD5lghAEsbPHO0N4qV/
        shqXcf8dPV/jnISCp
X-Received: by 2002:a05:6402:e87:b0:461:b8bf:ce1b with SMTP id h7-20020a0564020e8700b00461b8bfce1bmr61960027eda.34.1673345074954;
        Tue, 10 Jan 2023 02:04:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtVgVLvkT9o6+p8kfSEIwPVyyh/Hb4X1vxs6dffku0/UNnpLb5Ve+IZOnsSLuA3pZtYGaakBw==
X-Received: by 2002:a05:6402:e87:b0:461:b8bf:ce1b with SMTP id h7-20020a0564020e8700b00461b8bfce1bmr61960006eda.34.1673345074676;
        Tue, 10 Jan 2023 02:04:34 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id b2-20020a0564021f0200b0048c85c5ad30sm4691745edb.83.2023.01.10.02.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 02:04:34 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <67d60543-2f3c-b0ff-b7fb-e44518cf325b@redhat.com>
Date:   Tue, 10 Jan 2023 11:04:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 17/24] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-18-willy@infradead.org>
 <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
 <Y7hR7KAzsOPsXrA1@casper.infradead.org>
 <c0f53cee-aaa7-2fe8-ff5b-0853085b6514@redhat.com>
 <Y7xexniPnKSgCMVE@casper.infradead.org>
In-Reply-To: <Y7xexniPnKSgCMVE@casper.infradead.org>
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


On 09/01/2023 19.36, Matthew Wilcox wrote:
> On Fri, Jan 06, 2023 at 09:16:25PM +0100, Jesper Dangaard Brouer wrote:
>>
>>
>> On 06/01/2023 17.53, Matthew Wilcox wrote:
>>> On Fri, Jan 06, 2023 at 04:49:12PM +0100, Jesper Dangaard Brouer wrote:
>>>> On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
>>>>> This function accesses the pagepool members of struct page directly,
>>>>> so it needs to become netmem.  Add page_pool_put_full_netmem() and
>>>>> page_pool_recycle_netmem().
>>>>>
>>>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>>> ---
>>>>>     include/net/page_pool.h | 14 +++++++++++++-
>>>>>     net/core/page_pool.c    | 13 ++++++-------
>>>>>     2 files changed, 19 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>>>> index fbb653c9f1da..126c04315929 100644
>>>>> --- a/include/net/page_pool.h
>>>>> +++ b/include/net/page_pool.h
>>>>> @@ -464,10 +464,16 @@ static inline void page_pool_put_page(struct page_pool *pool,
>>>>>     }
>>>>>     /* Same as above but will try to sync the entire area pool->max_len */
>>>>> +static inline void page_pool_put_full_netmem(struct page_pool *pool,
>>>>> +		struct netmem *nmem, bool allow_direct)
>>>>> +{
>>>>> +	page_pool_put_netmem(pool, nmem, -1, allow_direct);
>>>>> +}
>>>>> +
>>>>>     static inline void page_pool_put_full_page(struct page_pool *pool,
>>>>>     					   struct page *page, bool allow_direct)
>>>>>     {
>>>>> -	page_pool_put_page(pool, page, -1, allow_direct);
>>>>> +	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
>>>>>     }
>>>>>     /* Same as above but the caller must guarantee safe context. e.g NAPI */
>>>>> @@ -477,6 +483,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>>>>     	page_pool_put_full_page(pool, page, true);
>>>>>     }
>>>>> +static inline void page_pool_recycle_netmem(struct page_pool *pool,
>>>>> +					    struct netmem *nmem)
>>>>> +{
>>>>> +	page_pool_put_full_netmem(pool, nmem, true);
>>>>                                                 ^^^^
>>>>
>>>> It is not clear in what context page_pool_recycle_netmem() will be used,
>>>> but I think the 'true' (allow_direct=true) might be wrong here.
>>>>
>>>> It is only in limited special cases (RX-NAPI context) we can allow
>>>> direct return to the RX-alloc-cache.
>>>
>>> Mmm.  It's a c'n'p of the previous function:
>>>
>>> static inline void page_pool_recycle_direct(struct page_pool *pool,
>>>                                               struct page *page)
>>> {
>>>           page_pool_put_full_page(pool, page, true);
>>> }
>>>
>>> so perhaps it's just badly named?
>>
>> Yes, I think so.
>>
>> Can we name it:
>>   page_pool_recycle_netmem_direct
>>
>> And perhaps add a comment with a warning like:
>>   /* Caller must guarantee safe context. e.g NAPI */
>>
>> Like the page_pool_recycle_direct() function has a comment.
> 
> I don't really like the new name you're proposing here.  Really,
> page_pool_recycle_direct() is the perfect name, it just has the wrong
> type.
> 
> I considered the attached megapatch, but I don't think that's a great
> idea.
> 
> So here's what I'm planning instead:

I do like below patch.
I must admit I had to lookup _Generic() when I started reviewing this
patchset.  I think it makes a lot of sense to use here as it allow us to
easier convert drivers over.

We have 22 call spots in drivers:

  $ git grep page_pool_recycle_direct drivers/net/ethernet/ | wc -l
  22

But approx 9 drivers doing this (as each driver calls it in multiple 
places).


> 
>      page_pool: Allow page_pool_recycle_direct() to take a netmem or a page
> 
>      With no better name for a variant of page_pool_recycle_direct() which
>      takes a netmem instead of a page, use _Generic() to allow it to take
>      either a page or a netmem argument.  It's a bit ugly, but maybe not
>      the worst alternative?
> 
>      Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index abe3822a1125..1eed8ed2dcc1 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -477,12 +477,22 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
>   }
> 
>   /* Same as above but the caller must guarantee safe context. e.g NAPI */
> -static inline void page_pool_recycle_direct(struct page_pool *pool,
> +static inline void __page_pool_recycle_direct(struct page_pool *pool,
> +                                           struct netmem *nmem)
> +{
> +       page_pool_put_full_netmem(pool, nmem, true);
> +}
> +
> +static inline void __page_pool_recycle_page_direct(struct page_pool *pool,
>                                              struct page *page)
>   {
> -       page_pool_put_full_page(pool, page, true);
> +       page_pool_put_full_netmem(pool, page_netmem(page), true);
>   }
> 
> +#define page_pool_recycle_direct(pool, mem)    _Generic((mem),         \
> +       struct netmem *: __page_pool_recycle_direct(pool, (struct netmem *)mem),                \
> +       struct page *:   __page_pool_recycle_page_direct(pool, (struct page *)mem))
> +
>   #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
>                  (sizeof(dma_addr_t) > sizeof(unsigned long))
> 
> 

