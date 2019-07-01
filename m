Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDC35B80E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfGAJap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfGAJao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 05:30:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D1A33082A49;
        Mon,  1 Jul 2019 09:30:39 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 344E019732;
        Mon,  1 Jul 2019 09:30:30 +0000 (UTC)
Subject: Re: [PATCH bpf-next] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>, davem@davemloft.net
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org
References: <20190627080641.3266-1-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fe3070db-ec3a-9c7c-e15e-93032811767f@redhat.com>
Date:   Mon, 1 Jul 2019 17:30:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190627080641.3266-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 01 Jul 2019 09:30:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/27 下午4:06, Yuya Kusakabe wrote:
> This adds XDP meta data support to both receive_small() and
> receive_mergeable().
>
> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> ---
>   drivers/net/virtio_net.c | 40 +++++++++++++++++++++++++++++-----------
>   1 file changed, 29 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4f3de0ac8b0b..e787657fc568 100644
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
> @@ -393,17 +393,25 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>   
> -	if (hdr_valid)
> +	if (hdr_valid && !metasize)
>   		memcpy(hdr, p, hdr_len);
>   
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
>   
> -	copy = len;
> +	copy = len + metasize;
>   	if (copy > skb_tailroom(skb))
>   		copy = skb_tailroom(skb);
> -	skb_put_data(skb, p, copy);
> +
> +	if (metasize) {
> +		skb_put_data(skb, p - metasize, copy);


I would rather keep copy untouched above, and use copy + metasize here, 
then you can save the following decrement  as well. Or tweak the caller 
the count the meta in to offset, then we need only deal with skb_pull() 
and skb_metadata_set() here.


> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +		copy -= metasize;
> +	} else {
> +		skb_put_data(skb, p, copy);
> +	}
>   
>   	len -= copy;
>   	offset += copy;
> @@ -644,6 +652,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	unsigned int delta = 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	len -= vi->hdr_len;
>   	stats->bytes += len;
> @@ -683,8 +692,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   
>   		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data = xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + len;
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   		orig_data = xdp.data;
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,9 +704,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta = orig_data - xdp.data;
>   			len = xdp.data_end - xdp.data;
> +			metasize = xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;


Why need this?


>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -735,11 +746,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	}
>   	skb_reserve(skb, headroom - delta);
>   	skb_put(skb, len);
> -	if (!delta) {
> +	if (!delta && !metasize) {
>   		buf += header_offset;
>   		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */


Is there any method to preserve the vnet header here? We probably don't 
want to lose it for XDP_PASS when packet is not modified.


>   
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>   
> @@ -761,7 +775,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>   {
>   	struct page *page = buf;
>   	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
> -					  PAGE_SIZE, true);
> +					  PAGE_SIZE, true, 0);
>   
>   	stats->bytes += len - vi->hdr_len;
>   	if (unlikely(!skb))
> @@ -793,6 +807,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	unsigned int truesize;
>   	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	head_skb = NULL;
>   	stats->bytes += len - vi->hdr_len;
> @@ -839,8 +854,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		data = page_address(xdp_page) + offset;
>   		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>   		xdp.data = data + vi->hdr_len;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + (len - vi->hdr_len);
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -859,18 +874,20 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   			 * adjusted
>   			 */
>   			len = xdp.data_end - xdp.data + vi->hdr_len;
> +			metasize = xdp.data - xdp.data_meta;
>   			/* We can only create skb based on xdp_page. */
>   			if (unlikely(xdp_page != page)) {
>   				rcu_read_unlock();
>   				put_page(page);
>   				head_skb = page_to_skb(vi, rq, xdp_page,
> -						       offset, len,
> -						       PAGE_SIZE, false);
> +					       offset, len,
> +					       PAGE_SIZE, false, metasize);


Indentation is wired.

Thanks


>   				return head_skb;
>   			}
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;
>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -921,7 +938,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		goto err_skb;
>   	}
>   
> -	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
> +	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> +			       metasize);
>   	curr_skb = head_skb;
>   
>   	if (unlikely(!curr_skb))
