Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6B96E7DBA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjDSPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjDSPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935445248
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681917127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9YzcadWNe6TWCoyXK8Cm8YbkSAH7b/Ui/V6DJ5+ewY=;
        b=KAXwqNUt1zEYMBbO4CJwU6FtgsOkVJoX8+n6ylc48pmY059vvv7zGyxry7IwNEMP0TNysQ
        XhUGonb1mEorrnMOkw06daWx3Nn/zTrZhFTxht2tXTxUmcpVZ0MsHMUwjr8mnVp6kC6MoO
        +jqZp2NpU/iLKgbPzbztW0BHapNabg8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-C_XiSLvqOEGmm8xqonqKEQ-1; Wed, 19 Apr 2023 11:12:05 -0400
X-MC-Unique: C_XiSLvqOEGmm8xqonqKEQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94f7a2b21fdso155427466b.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917124; x=1684509124;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B9YzcadWNe6TWCoyXK8Cm8YbkSAH7b/Ui/V6DJ5+ewY=;
        b=Z337uNT2/m9SwDeyUGM5Fj1/UZnuvhyoW+LZB/w0VTV8IBvaz3JNhh/H6rn97Xc4UY
         r96FXVDEmBslzb8/Z5tm0w52n/OGo5dQxCC0omIgqAhKdDKlSC+fLv92DG1r6d6jVE2g
         oSv2eNVnlwvfDUgAj+QZt0mfMrfSCuGufh8gOY+Z//Lb3NJN6n4Kp5YeS7j1M3TZC1Ao
         hVGcaIrR+vh35bE8w5Ul3FOt3S86qgOxPagmsGUpzg4nYnPux4D3yeHyQIj8/CxpY3/K
         Y+1lLcTQ7wqQaZdKa1CyJfxjRsdKm1fV+5H5mGezhCwkBgRXYvKZY0bMbwC6CcbVOCne
         Yl0A==
X-Gm-Message-State: AAQBX9cKMj05EFeOmokM1s0k+B2vx6caGO+eEatkMD2sEIYwcgCQbpPF
        3V3OaWSASJvqqFFQ3sseqoBDe8Cdzaawrmyj8qpNPnuQ6jDpeqJUFXElM0yH3KLDMvKVjaDkGsh
        hig4h3JiBuZaGN8aw
X-Received: by 2002:a05:6402:3458:b0:501:d52d:7f88 with SMTP id l24-20020a056402345800b00501d52d7f88mr6352622edc.10.1681917124024;
        Wed, 19 Apr 2023 08:12:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350bMbYceME7NKOHyKI+g6lO7PF5LCixY2WpJHXz7iekAa7xZyZk/VyrgSmHJUMeq8HaAQRVrNw==
X-Received: by 2002:a05:6402:3458:b0:501:d52d:7f88 with SMTP id l24-20020a056402345800b00501d52d7f88mr6352598edc.10.1681917123701;
        Wed, 19 Apr 2023 08:12:03 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id u15-20020aa7d88f000000b005067d6b06efsm7093379edq.17.2023.04.19.08.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 08:12:03 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fd3be067-3423-a2ed-99c4-c77196dda480@redhat.com>
Date:   Wed, 19 Apr 2023 17:12:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all
 mappings
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417152805.331865-1-kuba@kernel.org>
 <6bd4adc4-8d0f-85c2-fa6a-8ce277e52f4e@redhat.com>
In-Reply-To: <6bd4adc4-8d0f-85c2-fa6a-8ce277e52f4e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/04/2023 13.23, Jesper Dangaard Brouer wrote:
> To Hellwig,
> 
> On 17/04/2023 17.28, Jakub Kicinski wrote:
>> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
>> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
>> to a few more drivers (possibly as a copy'n'paste).
>>
>> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
>> the rarity of these platforms is likely why we never bothered adding
>> the attribute in the page pool, even though it should be safe to add.
>>
>> To make the page pool migration in drivers which set this flag less
>> of a risk (of regressing the precious sparc database workloads or
>> whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
>> page pool DMA mappings.
>>
> 
> This sounds reasonable to me, but I don't know the DMA APIs well enough.
> Thus, I would like to hear if Hellwig thinks this is okay?

Acking this patch, as we can always revert if Hellwig have objections later.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

>> We could make this a driver opt-in but frankly I don't think it's
>> worth complicating the API. I can't think of a reason why device
>> accesses to packet memory would have to be ordered.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> CC: hawk@kernel.org
>> CC: ilias.apalodimas@linaro.org
>> ---
>>   net/core/page_pool.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 2f6bf422ed30..97f20f7ff4fc 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool 
>> *pool, struct page *page)
>>        */
>>       dma = dma_map_page_attrs(pool->p.dev, page, 0,
>>                    (PAGE_SIZE << pool->p.order),
>> -                 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
>> +                 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC |
>> +                          DMA_ATTR_WEAK_ORDERING);
>>       if (dma_mapping_error(pool->p.dev, dma))
>>           return false;
>> @@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool 
>> *pool, struct page *page)
>>       /* When page is unmapped, it cannot be returned to our pool */
>>       dma_unmap_page_attrs(pool->p.dev, dma,
>>                    PAGE_SIZE << pool->p.order, pool->p.dma_dir,
>> -                 DMA_ATTR_SKIP_CPU_SYNC);
>> +                 DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
>>       page_pool_set_dma_addr(page, 0);
>>   skip_dma_unmap:
>>       page_pool_clear_pp_info(page);

