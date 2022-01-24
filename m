Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6267C497AD7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 09:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiAXI55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 03:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiAXI5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 03:57:55 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81018C06173B;
        Mon, 24 Jan 2022 00:57:55 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id b14so4806402ljb.0;
        Mon, 24 Jan 2022 00:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mSKXyc98nYLlNnODsXW67iNaHjhwuGUH6qhzM605fN4=;
        b=PCd9xx8GHchBs73B7IKdooCUpV1yfFBvt+aZThklWhAIVftOL2III86q03e40OYuR4
         l/1BiZwj2tGJ46+91Wf8dAkOv1gZOux+Jr94pbuSHub4WIuYBAnm29P3jlHIc+kStokl
         HBy9Wa+qpalOgEhVAf60Pl9TSbuv6gd6pw7mowPWpGB7v4fymAxfZP1moUl3+f3CkUhi
         MsLxh5y05K02NgoTkVSSAdGyfFZ4RBQNkgpF1aJuZg+XHp429epfMwBB7+//MgOFsNl2
         qbbkJwHepfe8+zoGa3t+M/M5gqIKVQjTpqe9RAKwqwinEOhS7FRiSQxzwXlvtoUBK6oi
         1mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mSKXyc98nYLlNnODsXW67iNaHjhwuGUH6qhzM605fN4=;
        b=wV1gGYFfxWqjCp8xilZicOoTDhiO1zQ1W0vIlFGKa0NLuAk6Zro8Z0p1wz6oqBdhsY
         99sqMfdMjh/D+kagL58oGzvXZP0uYYf7IAlA7qWnmHmXsR3yV/Nnp26G64DAgdr62uly
         yvUZgBuiV21fWZ/p7pLjfw4Bv99qIfqZ/B0dFjj3SI3PrRT78ISQhkUSxDuX276ujE6w
         9NTTlt68fry5Nf/gfPkG9XKgqrkd5C2/nZufcAr2pDwFL9+CgMnsWzFLtIJ6Dp3QWiCj
         /8CGq7oxrza9BgnGFEpjVyo0crKQjhjQ1LS2k401IzFKRQYOIM0VymVPf/JS6kReqms3
         S8Bw==
X-Gm-Message-State: AOAM531sUT+oiUj5sicKUgum44ISaVWJXRGveR0Z32KRf8+7tmUl2DJP
        e0fOSPY/VVEixJCjJWEGxn8=
X-Google-Smtp-Source: ABdhPJzapDw1xK0D+2skY071iWUkjaj7XLWYugtvI7+czEPcLVZWrvbKqS2TAjz7uU6jjxh9S5rlyQ==
X-Received: by 2002:a05:651c:10d2:: with SMTP id l18mr4866693ljn.39.1643014673828;
        Mon, 24 Jan 2022 00:57:53 -0800 (PST)
Received: from [192.168.8.103] (m91-129-103-86.cust.tele2.ee. [91.129.103.86])
        by smtp.gmail.com with ESMTPSA id w21sm1099073lfu.249.2022.01.24.00.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 00:57:53 -0800 (PST)
Message-ID: <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
Date:   Mon, 24 Jan 2022 10:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Content-Language: en-US
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, netdev@vger.kernel.org
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <20220123115623.94843-1-42.hyeyoo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.01.22 13:56, Hyeonggon Yoo wrote:
> By profiling, discovered that ena device driver allocates skb by
> build_skb() and frees by napi_skb_cache_put(). Because the driver
> does not use napi skb cache in allocation path, napi skb cache is
> periodically filled and flushed. This is waste of napi skb cache.
> 
> As ena_alloc_skb() is called only in napi, Use napi_build_skb()
> instead of build_skb() to when allocating skb.
> 
> This patch was tested on aws a1.metal instance.
> 
> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index c72f0c7ff4aa..2c67fb1703c5 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -1407,7 +1407,7 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
>  		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
>  						rx_ring->rx_copybreak);

To keep things consistent, this should then also be napi_alloc_skb().

>  	else
> -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
> +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
>  
>  	if (unlikely(!skb)) {
>  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,

