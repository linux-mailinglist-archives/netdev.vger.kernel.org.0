Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98135F0EA
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhDNJiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhDNJiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618393077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=31nI9rEM3AksD9/z0IQbYLKi4TSPs5CKGKrvk7XFaw0=;
        b=B6N8QnnkQRygLX0Kz8Z3Ef/eC0dtmUYLIrhibNLGbY5gyZRnM6GPR5XhkYR0qEwgpLax6z
        /s6orzkx/WN3irBeQnl1/CLIsZvZE2l2PFUS1xDQ7y5IYcfLBWNPH67QEMiVDXkVKrZ3tV
        O9sx6WV+i76fWhFX78I5Bt28P8QnSWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-vXNknX-HOLSmBsd9ZJVxZA-1; Wed, 14 Apr 2021 05:37:53 -0400
X-MC-Unique: vXNknX-HOLSmBsd9ZJVxZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35F0F83DD20;
        Wed, 14 Apr 2021 09:37:52 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AD1C5D9D0;
        Wed, 14 Apr 2021 09:37:46 +0000 (UTC)
Subject: Re: [PATCH net-next v2] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4c049eea-e00e-0c5f-9b52-95925a178dd1@redhat.com>
Date:   Wed, 14 Apr 2021 17:37:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/14 上午9:52, Xuan Zhuo 写道:
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
>      The four queues of the network card are bound to the cpu1.
>
> Test command:
>      for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
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
> v2: conflict resolution
>
>   drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++--------------
>   1 file changed, 33 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 101659cd4b87..d7142b508bd0 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -383,17 +383,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> -	unsigned int copy, hdr_len, hdr_padded_len;
> -	char *p;
> +	unsigned int copy, hdr_len, hdr_padded_len, tailroom, shinfo_size;
> +	char *p, *hdr_p;
>
>   	p = page_address(page) + offset;
> -
> -	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> -	if (unlikely(!skb))
> -		return NULL;
> -
> -	hdr = skb_vnet_hdr(skb);
> +	hdr_p = p;
>
>   	hdr_len = vi->hdr_len;
>   	if (vi->mergeable_rx_bufs)
> @@ -401,14 +395,28 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>
> -	/* hdr_valid means no XDP, so we can copy the vnet header */
> -	if (hdr_valid)
> -		memcpy(hdr, p, hdr_len);
> +	tailroom = truesize - len;


The math looks not correct in the case of XDP. Since the eBPF pgoram can 
choose to adjust the header and insert meta which will cause the 
truesize is less than len.

Note that in the case of XDP, we always reserve sufficient tailroom for 
shinfo, see add_recvbuf_mergeable():

         unsigned int tailroom = headroom ? sizeof(struct 
skb_shared_info) : 0;

Thanks


>
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
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
>   	/* Copy all frame if it fits skb->head, otherwise
>   	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
>   	 */
> @@ -418,11 +426,6 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		copy = ETH_HLEN + metasize;
>   	skb_put_data(skb, p, copy);
>
> -	if (metasize) {
> -		__skb_pull(skb, metasize);
> -		skb_metadata_set(skb, metasize);
> -	}
> -
>   	len -= copy;
>   	offset += copy;
>
> @@ -431,7 +434,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>   		else
>   			put_page(page);
> -		return skb;
> +		goto ok;
>   	}
>
>   	/*
> @@ -458,6 +461,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	if (page)
>   		give_pages(rq, page);
>
> +ok:
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
> +	if (hdr_valid) {
> +		hdr = skb_vnet_hdr(skb);
> +		memcpy(hdr, hdr_p, hdr_len);
> +	}
> +
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +	}
> +
>   	return skb;
>   }
>
> --
> 2.31.0
>

