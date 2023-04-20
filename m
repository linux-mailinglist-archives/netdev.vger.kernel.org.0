Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CD16E8D78
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjDTJEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjDTJDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:03:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3489ECA
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681980987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pY0N+dEzvSEwAValJ3zirlHbOZcRLBGk4H3+IIf9M2s=;
        b=ZolVapA4s19DZRMYL110x3284v60ptdMrFEjZSQJw4rao+K0wmYnXzqHeJA6L0rAdB5oWM
        9sS6Rdi4KSYDP7fr5vghT7qmoP1jJCYflXE4OCnWNz2JpoVLSM+tgBg5lSacezkUooAUFq
        cJ8sP3fMljWo/CdFzRg/PkycogZ0MYo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-cseOUKoJMDej3vDnZjrovw-1; Thu, 20 Apr 2023 04:56:25 -0400
X-MC-Unique: cseOUKoJMDej3vDnZjrovw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-505070d2502so468874a12.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980984; x=1684572984;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pY0N+dEzvSEwAValJ3zirlHbOZcRLBGk4H3+IIf9M2s=;
        b=No3XLqe7k4GmnG877gRuP9siGQiRFnaZephz/pi3FhUXt4VniE7gL0tJrN++GPWMrp
         qIozoVxh5n7USMU5n8LYWxft7wy9AAuU7FL6wyl+LNktlPEGcTQfsBAFyuFB4j2CDaMp
         ZDoLkY4GeDVE2nE6W2KtSHXHYmMZZxLVDFYALVG7H9ip+0WBIm9LNz6v/CYOFPnpc2qQ
         YANWqnlAw0Q+MRqD/IFhIOAB0eZLxgtRUl7Tn2sQLVihr1V1zRsS+9es8bLoh85DS5zy
         UZM1Wt/xX38WYsbH6wftEGYKMqmane8bhpEAPndiUJK/uD9hKF3pV//sB7e6cZKkT4dn
         hsNg==
X-Gm-Message-State: AAQBX9f+pQSRyK5QQRFbsTpXsCeX+2f4jaRPn9yKiOvXZVWvsZw4/WHI
        riDAt2WLRCVBt7c6/mM4fI1JSOMaxAz1V7maSO13DogjhwW02PIUJ4eyDKzpkJOw7Trq6SgTRd2
        HKUCi38VslE2QWD+O
X-Received: by 2002:a05:6402:1a57:b0:506:94ea:9af1 with SMTP id bf23-20020a0564021a5700b0050694ea9af1mr1447976edb.8.1681980984625;
        Thu, 20 Apr 2023 01:56:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bgpbJJytQP/x1rpI5Ql/6XCAMPEiGCWAUxJmVAH85leWysNc49213UF5VmaokmhvlgmrUG1g==
X-Received: by 2002:a05:6402:1a57:b0:506:94ea:9af1 with SMTP id bf23-20020a0564021a5700b0050694ea9af1mr1447956edb.8.1681980984283;
        Thu, 20 Apr 2023 01:56:24 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id k12-20020a05640212cc00b005083db60635sm514712edx.34.2023.04.20.01.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 01:56:23 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <66aaf22e-5b0b-b67c-bb71-c61b966c0d5c@redhat.com>
Date:   Thu, 20 Apr 2023 10:56:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        hawk@kernel.org, ilias.apalodimas@linaro.org, tariqt@nvidia.com
Subject: Re: [PATCH net-next] page_pool: unlink from napi during destroy
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
References: <20230419182006.719923-1-kuba@kernel.org>
In-Reply-To: <20230419182006.719923-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/04/2023 20.20, Jakub Kicinski wrote:
> Jesper points out that we must prevent recycling into cache
> after page_pool_destroy() is called, because page_pool_destroy()
> is not synchronized with recycling (some pages may still be
> outstanding when destroy() gets called).
> 
> I assumed this will not happen because NAPI can't be scheduled
> if its page pool is being destroyed. But I missed the fact that
> NAPI may get reused. For instance when user changes ring configuration
> driver may allocate a new page pool, stop NAPI, swap, start NAPI,
> and then destroy the old pool. The NAPI is running so old page
> pool will think it can recycle to the cache, but the consumer
> at that point is the destroy() path, not NAPI.
> 
> To avoid extra synchronization let the drivers do "unlinking"
> during the "swap" stage while NAPI is indeed disabled.
> 
> Fixes: 8c48eea3adf3 ("page_pool: allow caching from safely localized NAPI")
> Reported-by: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Link: https://lore.kernel.org/all/e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> bnxt does not do the live swap so no need to change it.
> But let's export the API, anyway, I'm sure others will
> need it. And knowing driver authors they will hack some
> workaround into the driver rather than export the helper.
> 
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> CC: tariqt@nvidia.com
> ---
>   include/net/page_pool.h |  5 +++++
>   net/core/page_pool.c    | 18 +++++++++++++++++-
>   2 files changed, 22 insertions(+), 1 deletion(-)
> 

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for fixing this.

