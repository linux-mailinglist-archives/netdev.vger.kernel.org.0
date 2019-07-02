Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAF25C802
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 06:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfGBD77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGBD77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 23:59:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C477130872C6;
        Tue,  2 Jul 2019 03:59:57 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11BDB5C28D;
        Tue,  2 Jul 2019 03:59:47 +0000 (UTC)
Subject: Re: [PATCH bpf-next v2] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <455941f9-aadb-ab70-2745-34f8fd893e89@gmail.com>
 <20190702031542.5096-1-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e703c548-6615-c830-3b8b-ead9346a6bb5@redhat.com>
Date:   Tue, 2 Jul 2019 11:59:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702031542.5096-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 02 Jul 2019 03:59:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/2 上午11:15, Yuya Kusakabe wrote:
> This adds XDP meta data support to both receive_small() and
> receive_mergeable().
>
> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> ---
> v2:
>   - keep copy untouched in page_to_skb().
>   - preserve the vnet header in receive_small().
>   - fix indentation.
> ---
>   drivers/net/virtio_net.c | 39 +++++++++++++++++++++++++++------------
>   1 file changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4f3de0ac8b0b..2ebabb08b824 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   				   struct receive_queue *rq,
>   				   struct page *page, unsigned int offset,
>   				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid)
> +				   bool hdr_valid, unsigned int metasize)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>   
> -	if (hdr_valid)
> +	if (hdr_valid && !metasize)
>   		memcpy(hdr, p, hdr_len);
>   
>   	len -= hdr_len;
> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		copy = skb_tailroom(skb);
>   	skb_put_data(skb, p, copy);
>   
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +	}
> +
>   	len -= copy;
>   	offset += copy;
>   
> @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	unsigned int delta = 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	len -= vi->hdr_len;
>   	stats->bytes += len;
> @@ -683,8 +689,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   
>   		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data = xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + len;
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   		orig_data = xdp.data;
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,9 +701,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta = orig_data - xdp.data;
>   			len = xdp.data_end - xdp.data;
> +			metasize = xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;
>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -740,6 +748,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */


I wonder whether or not it's as simple as this. Consider bpf may adjust 
meta, it looks to me that the vnet header will be overwrite here? If 
yes, we probably need to have a device specific value then bpf can move 
the device metadata like vnet header for us?

Thanks


>   
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>   
> @@ -760,8 +771,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>   				   struct virtnet_rq_stats *stats)
>   {
>   	struct page *page = buf;
> -	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
> -					  PAGE_SIZE, true);
> +	struct sk_buff *skb =
> +		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>   
>   	stats->bytes += len - vi->hdr_len;
>   	if (unlikely(!skb))
> @@ -793,6 +804,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	unsigned int truesize;
>   	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	head_skb = NULL;
>   	stats->bytes += len - vi->hdr_len;
> @@ -839,8 +851,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		data = page_address(xdp_page) + offset;
>   		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>   		xdp.data = data + vi->hdr_len;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + (len - vi->hdr_len);
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -852,8 +864,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   			 * adjustments. Note other cases do not build an
>   			 * skb and avoid using offset
>   			 */
> -			offset = xdp.data -
> -					page_address(xdp_page) - vi->hdr_len;
> +			metasize = xdp.data - xdp.data_meta;
> +			offset = xdp.data - page_address(xdp_page) -
> +				 vi->hdr_len - metasize;
>   
>   			/* recalculate len if xdp.data or xdp.data_end were
>   			 * adjusted
> @@ -863,14 +876,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   			if (unlikely(xdp_page != page)) {
>   				rcu_read_unlock();
>   				put_page(page);
> -				head_skb = page_to_skb(vi, rq, xdp_page,
> -						       offset, len,
> -						       PAGE_SIZE, false);
> +				head_skb = page_to_skb(vi, rq, xdp_page, offset,
> +						       len, PAGE_SIZE, false,
> +						       metasize);
>   				return head_skb;
>   			}
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;
>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -921,7 +935,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		goto err_skb;
>   	}
>   
> -	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
> +	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> +			       metasize);
>   	curr_skb = head_skb;
>   
>   	if (unlikely(!curr_skb))
