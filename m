Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44C36399E
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 05:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhDSDKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 23:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229845AbhDSDKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 23:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618801816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1xUe+MYJDbBFqVKD9wI/DGM7y7MGyU5lLHv4fHfJN3k=;
        b=c4EOQQHh694OTdxwmm7L79EpTWQ6e/ZxQUhHwp7hgrTW6eSit4/pWcUBBVOInINEpSYfTD
        eEe1vz/G00ZYOBbmugsHXZLcaLa0zGNis8VjmOnWiPBg4h7OoDFfmHpvrcHK9FFt+cmMFS
        1+ZXoUXj4EsO9GQVGKCp1oUyIL8tYPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-zD5P6VJKMXSXDPAUZv5Fdw-1; Sun, 18 Apr 2021 23:10:12 -0400
X-MC-Unique: zD5P6VJKMXSXDPAUZv5Fdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC348180486D;
        Mon, 19 Apr 2021 03:10:10 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 573E619D9D;
        Mon, 19 Apr 2021 03:10:05 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <023dcd7f-5896-8175-545f-44af935e9e45@redhat.com>
Date:   Mon, 19 Apr 2021 11:10:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/16 下午5:16, Xuan Zhuo 写道:
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


I suggess to test the case of XDP_PASS in this case as well.


>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>
> v3: fix the truesize when headroom > 0
>
> v2: conflict resolution
>
>   drivers/net/virtio_net.c | 69 ++++++++++++++++++++++++++++------------
>   1 file changed, 48 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 101659cd4b87..8cd76037c724 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -379,21 +379,17 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   				   struct receive_queue *rq,
>   				   struct page *page, unsigned int offset,
>   				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid, unsigned int metasize)
> +				   bool hdr_valid, unsigned int metasize,
> +				   unsigned int headroom)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
>   	unsigned int copy, hdr_len, hdr_padded_len;
> -	char *p;
> +	int tailroom, shinfo_size;
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
> @@ -401,14 +397,38 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
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


I think the comment in receive_mergeable() is better:

                 /* Buffers with headroom use PAGE_SIZE as alloc size,
                  * see add_recvbuf_mergeable() + get_mergeable_buf_len()
                  */


> +		truesize = PAGE_SIZE;
> +		tailroom = truesize - len - offset;
> +	} else {
> +		tailroom = truesize - len;
> +	}
>
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
>
> +	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +	if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {


Any reason that you don't use build_skb() for len < GOOD_COPY_LEN?

Other looks good.

Thanks


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
> @@ -418,11 +438,6 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
> @@ -431,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>   		else
>   			put_page(page);
> -		return skb;
> +		goto ok;
>   	}
>
>   	/*
> @@ -458,6 +473,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
> @@ -808,7 +835,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>   {
>   	struct page *page = buf;
>   	struct sk_buff *skb =
> -		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
> +		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
>
>   	stats->bytes += len - vi->hdr_len;
>   	if (unlikely(!skb))
> @@ -922,7 +949,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   				put_page(page);
>   				head_skb = page_to_skb(vi, rq, xdp_page, offset,
>   						       len, PAGE_SIZE, false,
> -						       metasize);
> +						       metasize, headroom);
>   				return head_skb;
>   			}
>   			break;
> @@ -980,7 +1007,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	}
>
>   	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> -			       metasize);
> +			       metasize, headroom);
>   	curr_skb = head_skb;
>
>   	if (unlikely(!curr_skb))
> --
> 2.31.0
>

