Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77A6E5FC5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDRLYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDRLYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:24:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752E91A4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681817029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eW2HJ/hWgV6GMo9eudAySZb1AravgW3aPWGJ85AI+7g=;
        b=aS3btEnhDPs1a/LGhYohGr/927dOcslr3WGSaxHG+qd49Rtob05j4st+q7WWSGN15i7LNX
        J80rBo6SCh6ZcSjVBKy5D1GmV01paXldLG0GwrR3CDq0qFsNB4yk6PrkdmGePgu4rRAcbc
        8FdQ62XtoiqIMW0Dz+cy6bLEuVB++xg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-Y3oTtVkkPoq5aPH6cOXf_g-1; Tue, 18 Apr 2023 07:23:48 -0400
X-MC-Unique: Y3oTtVkkPoq5aPH6cOXf_g-1
Received: by mail-ed1-f71.google.com with SMTP id k24-20020a508ad8000000b005068d942d3fso5337689edk.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681817027; x=1684409027;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eW2HJ/hWgV6GMo9eudAySZb1AravgW3aPWGJ85AI+7g=;
        b=HNv4UPX5xb6+s59VJOCBeuWnqKzHUcu61F6sn23YLIInqjhpryxSXqO6W1YNmNYrre
         MFqrf1SxZx1q5GG01ePmIIKWsjlFV0soI/uNikqFPUIR1aQU6skBS3IpqrDkBcKdOZTx
         R8WNMNid1xAhAJDo6ZX4kbd7geA8q4AMHEX9UrbdPUZp4TA95LtepWexHHK1biAvSyVs
         NJA0qAqGSB9HaxnprMqOkvRNRysVRa/ITElQQ4fRrH4yDKvmwXYCX/qEVuyChFdH78+Z
         54FerEc1aGdk41RMkp9ja0p0V90GwQFP8yiJWSvSria38XShIcrJT2aATpDo/F/RUczB
         SIuw==
X-Gm-Message-State: AAQBX9eNgloMpzCgSLDwe1Tp8gUMFWSA7HkUHAR2ICUsZxm0o9mZnFdT
        13J3A0vhnlVTHcz9Y7Rb2SydzMCnf5cwisKd8iu1pYRawVsk0a8f79YaX6yGvYtL3pNRgmFip3E
        dWBC4H0zLYEzlgwJJ
X-Received: by 2002:a17:906:a211:b0:94e:f9b:2b14 with SMTP id r17-20020a170906a21100b0094e0f9b2b14mr9837319ejy.62.1681817027141;
        Tue, 18 Apr 2023 04:23:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350YO77OzXBJWFiuaCg+Hi3J7qQfOb2s30+ejMyMYxDVnQj82qj8xsiueD03W0GMRggyFB2YMJw==
X-Received: by 2002:a17:906:a211:b0:94e:f9b:2b14 with SMTP id r17-20020a170906a21100b0094e0f9b2b14mr9837302ejy.62.1681817026708;
        Tue, 18 Apr 2023 04:23:46 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id vt2-20020a170907a60200b0094f257e3e05sm4730588ejc.168.2023.04.18.04.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 04:23:46 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6bd4adc4-8d0f-85c2-fa6a-8ce277e52f4e@redhat.com>
Date:   Tue, 18 Apr 2023 13:23:45 +0200
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
In-Reply-To: <20230417152805.331865-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To Hellwig,

On 17/04/2023 17.28, Jakub Kicinski wrote:
> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
> to a few more drivers (possibly as a copy'n'paste).
> 
> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
> the rarity of these platforms is likely why we never bothered adding
> the attribute in the page pool, even though it should be safe to add.
> 
> To make the page pool migration in drivers which set this flag less
> of a risk (of regressing the precious sparc database workloads or
> whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
> page pool DMA mappings.
> 

This sounds reasonable to me, but I don't know the DMA APIs well enough.
Thus, I would like to hear if Hellwig thinks this is okay?

> We could make this a driver opt-in but frankly I don't think it's
> worth complicating the API. I can't think of a reason why device
> accesses to packet memory would have to be ordered.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> ---
>   net/core/page_pool.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 2f6bf422ed30..97f20f7ff4fc 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>   	 */
>   	dma = dma_map_page_attrs(pool->p.dev, page, 0,
>   				 (PAGE_SIZE << pool->p.order),
> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC |
> +						  DMA_ATTR_WEAK_ORDERING);
>   	if (dma_mapping_error(pool->p.dev, dma))
>   		return false;
>   
> @@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>   	/* When page is unmapped, it cannot be returned to our pool */
>   	dma_unmap_page_attrs(pool->p.dev, dma,
>   			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
> -			     DMA_ATTR_SKIP_CPU_SYNC);
> +			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
>   	page_pool_set_dma_addr(page, 0);
>   skip_dma_unmap:
>   	page_pool_clear_pp_info(page);

