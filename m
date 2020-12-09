Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7061A2D487C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgLISBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgLISBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:01:44 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5590C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 10:01:03 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id fh13so1306009pjb.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=np6y/90WZ0jov8mQi+nBfEvz1hgvvktXYNQalTN2VOA=;
        b=z2OaNa0ZCJay85YKUnmgykcwdwgU529ig8NEhpJl4gi8tTJYO22Wv1PX4faCZqxRFm
         ngS8OCYbEwNHWyaazGl3Vx27plBCYWXFHVCg6tQHYUlFoCXd47gzgmV9bNDhg1Wbsf2t
         xxWfidLgAibRrDl8Pizvru/KHa93taeyVsmQY2INyTAF02jKertWJnw6EuWVd+Usxzvc
         5BFbhJfDDmLWTiVH8u7/MNLzujS7euBb2VqD3blTlMPpeZpCGZhAXsnECcA5mTM5rCat
         AJWsGZJe9LKYBnKdMzkXMSVr2ObpKuSwC+rhYyvDNy6WmmPPbWjSp7e/S2pP339Uaopj
         73Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=np6y/90WZ0jov8mQi+nBfEvz1hgvvktXYNQalTN2VOA=;
        b=P5lo9RHL/9hclckXIYbxZYhuxAoPQmrh/AftZ+LfHxGFbsF7rnBAqaxnoyirWRW/8W
         RAE8vSdufbQhBRw+j+yVP57jpH3r9oW8LIuJAY18Wi9XJPZL3eHoA0Z56FI5qnBtmRyG
         GPGqds5T+v3WwnNq4p1tFkS/0IpLCIMZ3+3kejbsMkmbMzQqhXG4+cLvHFgkywmsHKgz
         vdm1HzLGpVVq42yTPzF72i0fs6/tGKjRO0JOg2ljsfupuLNwi7/B6sNdI3XFOmCiMCVL
         cuDO4NXxqYRvEjiV8uTA8cTkS83w+RcDpi4NtnVOMaZgctW2ZCXjm4rtDvi39hA3Tx53
         km0w==
X-Gm-Message-State: AOAM532+QLCgdIHLM7PI2fFdAKT0aeZ8uk6eb9NdFW7satSXLPLJItSV
        lsD6Kz2EhgMezJ/2qNzttOBaBg==
X-Google-Smtp-Source: ABdhPJzhG8+Gjb+Rl8ulzdWuzOtn6Rg5AAbTLhU/msat9UkjDbjuN9Ma1kT0DktaZoaLkcOWqxkzGA==
X-Received: by 2002:a17:902:aa8b:b029:da:ef22:8675 with SMTP id d11-20020a170902aa8bb02900daef228675mr3228705plr.15.1607536863321;
        Wed, 09 Dec 2020 10:01:03 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 14sm2806685pjm.21.2020.12.09.10.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 10:01:02 -0800 (PST)
Subject: Re: [PATCH 1/1] fix possible array overflow on receiving too many
 fragments for a packet
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pensando Drivers <drivers@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201208040638.40627-1-ruc_zhangxiaohui@163.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fcf79346-5463-b736-c109-44db76eec1c9@pensando.io>
Date:   Wed, 9 Dec 2020 10:01:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201208040638.40627-1-ruc_zhangxiaohui@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 8:06 PM, Xiaohui Zhang wrote:
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> If the hardware receives an oversized packet with too many rx fragments,
> skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
> This becomes especially visible if it corrupts the freelist pointer of
> a slab page.
> I found these two code fragments were very similar to the vulnerable code
> in CVE-2020-12465, so I submitted these two patches.
>
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_txrx.c        | 4 +++-
>   drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 4 +++-
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index eae75260f..f0a252208 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -821,9 +821,11 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
>   	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
>   #endif
>   
> +	struct skb_shared_info *shinfo = skb_shinfo(skb);

This declaration should be up directly below the #endif and a blank line 
inserted before the code.

>   	if (!size)
>   		return;
> -	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
> +	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags))
> +		skb_add_rx_frag(skb, shinfo, rx_buf->page,
>   			rx_buf->page_offset, size, truesize);
>   
>   	/* page is being used so we must update the page offset */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index 169ac4f54..d30e83a4b 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -74,6 +74,7 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>   	struct device *dev = q->lif->ionic->dev;
>   	struct ionic_page_info *page_info;
>   	struct sk_buff *skb;
> +	struct skb_shared_info *shinfo = skb_shinfo(skb);

As the kernel test robot has suggested, this is using an uninitialized 
skb and will likely cause great unhappiness.

Also, this needs to follow the "reverse xmas tree" formatting style for 
declarations.


>   	unsigned int i;
>   	u16 frag_len;
>   	u16 len;
> @@ -102,7 +103,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>   
>   		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>   			       PAGE_SIZE, DMA_FROM_DEVICE);
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> +		if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags))
> +			skb_add_rx_frag(skb, shinfo->nr_frags,
>   				page_info->page, 0, frag_len, PAGE_SIZE);

I'm still not convinced this is necessary here, and I'm still not 
thrilled with the result of just quietly dropping the fragments.

A better answer here might be to check the ARRAY_SIZE against 
comp->num_sg_elements before allocating the skb, and if too big, then 
return NULL - this gets the check done before any allocations are made, 
and the packet will be properly dropped and the drop statistic incremented.

sln

>   		page_info->page = NULL;
>   		page_info++;

