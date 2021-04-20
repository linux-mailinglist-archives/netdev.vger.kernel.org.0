Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC0C36555B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhDTJ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhDTJ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:29:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D35C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:28:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h4so27824940wrt.12
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wROCMm76wNlr3GUjS33+liYup7xQt+ZVK0kHL95H1yo=;
        b=c6yuN29Gq5Cs3b7lLBYspvNQjvcmVJZB/+A/vm5ZEnWqVmTkt+KjwY1Kl+uvMEFG/4
         pVsuHmdhCmZjrsMJbag0ph4mrsXN/dDOy6/Oh00MTSTTuYAmAx56nxwhA+jdC2egSAvn
         v9SjsTrbmG/wvau7/MA+qAd6NtPyfdPj9jW97i/KwITwAHk5Tez/4EzDHC2cISDdIKp2
         J/sguzIhzM4JB4UswdVq8zTOkTzUqwRCzxJ5DFAnSQ/hKevYtuOcrJ64CS/O/5202/LU
         KBJDoph8uw3RE05WcyZrHKCk3Yk+vRPOwffJU21LuqpzgF1vMrqQ/SgKRpYJaY+zjKkZ
         Qonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wROCMm76wNlr3GUjS33+liYup7xQt+ZVK0kHL95H1yo=;
        b=hiAzPKCMuSMRifsurMrD5ebrhZXw3iwi5yE0fuczcOdlAVEnn1JbgQ1wNq0HnA+bNV
         yGjqsF7qEq41hgv6yEtno3RT5+49y1tGHRPnCmeSMdV1FsDol7hXV1HjGca5k+0XGtBf
         07zGf7/46gRgh7M1/4FKNx6oULCWcTuR64Ui+SVdOffKKzQxY/RjczA6hAhPmD2nRGrt
         cuTeOHSoHRD+CQXoT1UzUvRxRlgsWsD14P9UFz5b6CNZFfQak4oeMCmpNrxkfQKPZ4oQ
         Mn+mHV0JlAYx6epyF1eiTIBUJIelURY59wmVP+NxL17LuedYAYe+FglKKQybNDs4Hsw9
         t15A==
X-Gm-Message-State: AOAM530bCYryp6ryZV9tiXyYtKfrb7Hln4auaxiwU7XqmalGcOboOAXK
        wnLddwRsc9dhV6VMoM1zajjV0WnYmNM=
X-Google-Smtp-Source: ABdhPJyukdY9VwVZQehtKCXhQFuOsFtqcT6SONwSNBIYV2SGIsgb6KHMjsahSwQge57HuF9DMHDRtw==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr18889936wru.276.1618910935811;
        Tue, 20 Apr 2021 02:28:55 -0700 (PDT)
Received: from [192.168.156.98] (114.199.23.93.rev.sfr.net. [93.23.199.114])
        by smtp.gmail.com with ESMTPSA id f23sm2620236wmf.37.2021.04.20.02.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:28:55 -0700 (PDT)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bd5d5488-1449-d1a9-9e5a-822d97229f84@gmail.com>
Date:   Tue, 20 Apr 2021 11:28:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 11:16 AM, Xuan Zhuo wrote:
> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
> can use build_skb to create skb directly. No need to alloc for
> additional space. And it can save a 'frags slot', which is very friendly
> to GRO.
> 
> Here, if the payload of the received package is too small (less than
> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
> napi_alloc_skb. So we can reuse these pages.
> 
> Testing Machine:
>     The four queues of the network card are bound to the cpu1.
> 
> Test command:
>     for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
> 
> The size of the udp package is 1000, so in the case of this patch, there
> will always be enough tailroom to use build_skb. The sent udp packet
> will be discarded because there is no port to receive it. The irqsoftd
> of the machine is 100%, we observe the received quantity displayed by
> sar -n DEV 1:
> 
> no build_skb:  956864.00 rxpck/s
> build_skb:    1158465.00 rxpck/s
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
> 
> v3: fix the truesize when headroom > 0
> 
> v2: conflict resolution
> 
>  drivers/net/virtio_net.c | 69 ++++++++++++++++++++++++++++------------
>  1 file changed, 48 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 101659cd4b87..8cd76037c724 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -379,21 +379,17 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  				   struct receive_queue *rq,
>  				   struct page *page, unsigned int offset,
>  				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid, unsigned int metasize)
> +				   bool hdr_valid, unsigned int metasize,
> +				   unsigned int headroom)
>  {
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  	unsigned int copy, hdr_len, hdr_padded_len;
> -	char *p;
> +	int tailroom, shinfo_size;
> +	char *p, *hdr_p;
> 
>  	p = page_address(page) + offset;
> -
> -	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> -	if (unlikely(!skb))
> -		return NULL;
> -
> -	hdr = skb_vnet_hdr(skb);
> +	hdr_p = p;
> 
>  	hdr_len = vi->hdr_len;
>  	if (vi->mergeable_rx_bufs)
> @@ -401,14 +397,38 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> 
> -	/* hdr_valid means no XDP, so we can copy the vnet header */
> -	if (hdr_valid)
> -		memcpy(hdr, p, hdr_len);
> +	/* If headroom is not 0, there is an offset between the beginning of the
> +	 * data and the allocated space, otherwise the data and the allocated
> +	 * space are aligned.
> +	 */
> +	if (headroom) {
> +		/* The actual allocated space size is PAGE_SIZE. */
> +		truesize = PAGE_SIZE;
> +		tailroom = truesize - len - offset;
> +	} else {
> +		tailroom = truesize - len;
> +	}
> 
>  	len -= hdr_len;
>  	offset += hdr_padded_len;
>  	p += hdr_padded_len;
> 
> +	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +	if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> +		skb = build_skb(p, truesize);
> +		if (unlikely(!skb))
> +			return NULL;
> +
> +		skb_put(skb, len);
> +		goto ok;
> +	}
> +
> +	/* copy small packet so we can reuse these pages for small data */
> +	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> +	if (unlikely(!skb))
> +		return NULL;
> +
>  	/* Copy all frame if it fits skb->head, otherwise
>  	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
>  	 */
> @@ -418,11 +438,6 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		copy = ETH_HLEN + metasize;
>  	skb_put_data(skb, p, copy);
> 
> -	if (metasize) {
> -		__skb_pull(skb, metasize);
> -		skb_metadata_set(skb, metasize);
> -	}
> -
>  	len -= copy;
>  	offset += copy;
> 
> @@ -431,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>  		else
>  			put_page(page);

Here the struct page has been freed..

> -		return skb;
> +		goto ok;
>  	}
> 
>  	/*
> @@ -458,6 +473,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	if (page)
>  		give_pages(rq, page);
> 
> +ok:
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
> +	if (hdr_valid) {
> +		hdr = skb_vnet_hdr(skb);
> +		memcpy(hdr, hdr_p, hdr_len);

But here you are reading its content.

This is a use-after-free.

> +	}
> +

I will test something like :


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
        struct sk_buff *skb;
        struct virtio_net_hdr_mrg_rxbuf *hdr;
        unsigned int copy, hdr_len, hdr_padded_len;
+       struct page *page_to_free = NULL;
        int tailroom, shinfo_size;
        char *p, *hdr_p;
 
@@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
                if (len)
                        skb_add_rx_frag(skb, 0, page, offset, len, truesize);
                else
-                       put_page(page);
+                       page_to_free = page;
                goto ok;
        }
 
@@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
                hdr = skb_vnet_hdr(skb);
                memcpy(hdr, hdr_p, hdr_len);
        }
+       if (page_to_free)
+               put_page(page_to_free);
 
        if (metasize) {
                __skb_pull(skb, metasize);




