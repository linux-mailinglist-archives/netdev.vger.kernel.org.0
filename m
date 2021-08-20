Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9473F275A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhHTHNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:13:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233073AbhHTHNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629443553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GoNPZi9qrBQcCL3gakdQwO2nPqTgYHaAONgLRbdpqM=;
        b=U87S2oV58bxbag6XL0FoXbQRf33lVpFDKkBn8lHjFApzPHlIMFVhlaiffazVc2hS3k4IHO
        ns2EWZ4uRz8fxDo9+rzg+Ey+3cloz5NkjZHwPE1NDFH7LHdzhTPT3MdbAx8Lt1GAP62OHD
        JkVvIUpoTqDk5Mg4Z4SpnKYRm5deOjM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-aXJw0NThOPWLHYJ5fblNFw-1; Fri, 20 Aug 2021 03:12:31 -0400
X-MC-Unique: aXJw0NThOPWLHYJ5fblNFw-1
Received: by mail-wr1-f71.google.com with SMTP id x18-20020a5d49120000b0290154e9dcf3dbso2522597wrq.7
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 00:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2GoNPZi9qrBQcCL3gakdQwO2nPqTgYHaAONgLRbdpqM=;
        b=pwLp/EYtxlml3sYDB4hvU2cV7VYrUQf0Cr+NgbDNlKXP98JCS1W30HyDHqptA0K+1g
         ckyTSyg2zbNEseup8ejMOTPkps+fyLtTTCBDBXyrMCbtD62YPSg4DK+XY5FdMlvdt+Tn
         DZA4LaCwp08tfJXyUyOT5RdQcx2s3lL5+9+a6dkgSINHlNoeB9LtNzMmVrQnsckLpUOA
         1MfrvI0Pyi0XH/4KHji89y093UN0IbNANAiOdZdLWLVeON5u9JAI7jFEU8mdziYJu/Ft
         XBX+wazw6gYRWQOlWWJVRykNwJkw3OkCu/l1hL65Lb4vczyOhURvK0tsL3sXy3iz0ftV
         l2Rg==
X-Gm-Message-State: AOAM532nTceors2EgDhGmi4UkG6jjYV3en7quAwXRxTqMUbRZTyTQ8sL
        Yh1xEotK4xhGdeCWZjLTyQch3h+R8TFJINUgzvCad+aDPY0ghuTg74HoXubrjpw5qWr9O3W/sQx
        rDHVcJpTld39eHNSH
X-Received: by 2002:a5d:5305:: with SMTP id e5mr8230881wrv.243.1629443550551;
        Fri, 20 Aug 2021 00:12:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1ka/XH/E2ChCX6u+2m7dnx/k73Zseqx1DsN/ARQ+EguZGs7f1VYaoN97NBfkeQmjufl8bcQ==
X-Received: by 2002:a5d:5305:: with SMTP id e5mr8230862wrv.243.1629443550414;
        Fri, 20 Aug 2021 00:12:30 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id r4sm4064242wmq.10.2021.08.20.00.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 00:12:30 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 1/2] page_pool: use relaxed atomic for release
 side accounting
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-2-git-send-email-linyunsheng@huawei.com>
Message-ID: <9363880e-4ed2-5acd-87da-d669b68d0134@redhat.com>
Date:   Fri, 20 Aug 2021 09:12:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1629442611-61547-2-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/08/2021 08.56, Yunsheng Lin wrote:
> There is no need to synchronize the account updating, so
> use the relaxed atomic to avoid some memory barrier in the
> data path.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
>   net/core/page_pool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e140905..1a69784 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -370,7 +370,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>   	/* This may be the last page returned, releasing the pool, so
>   	 * it is not safe to reference pool afterwards.
>   	 */
> -	count = atomic_inc_return(&pool->pages_state_release_cnt);
> +	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
>   	trace_page_pool_state_release(pool, page, count);
>   }
>   EXPORT_SYMBOL(page_pool_release_page);
> 

