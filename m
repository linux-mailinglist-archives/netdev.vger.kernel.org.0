Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A17435EB78
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhDNDcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:32:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233242AbhDNDcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 23:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618371147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+A8H3Xsz8BfiDlAz5Esxp+7ouef9SRzHSQmz/cVmR8k=;
        b=VzdDc9F5mNiDAJJnKx2DrLnYZnWAFTf4l2xOoxPeowc8Yl98XNbCuTp/MpdY0/GL5tzxqv
        3qUPLAfUGKanLHIpOo2fH09SpyFU7K0SYRzCoepHHSrR7xyW/523paqF/HT93Wtp0X5ecQ
        uIwjiPo+WTcBl651lPwqx6CGbb3st4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-jxjyci_WPZOdXCiqRwCDPg-1; Tue, 13 Apr 2021 23:32:25 -0400
X-MC-Unique: jxjyci_WPZOdXCiqRwCDPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F379192AB6D;
        Wed, 14 Apr 2021 03:32:22 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C41785D9CA;
        Wed, 14 Apr 2021 03:32:14 +0000 (UTC)
Subject: Re: [PATCH net-next v4 06/10] virtio-net: unify the code for
 recycling the xmit ptr
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
 <20210413031523.73507-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6a853b6a-be20-cce6-f1c9-9c19f891aac3@redhat.com>
Date:   Wed, 14 Apr 2021 11:32:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413031523.73507-7-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÉÏÎç11:15, Xuan Zhuo Ð´µÀ:
> Now there are two types of "skb" and "xdp frame" during recycling old
> xmit.
>
> There are two completely similar and independent implementations. This
> is inconvenient for the subsequent addition of new types. So extract a
> function from this piece of code and call this function uniformly to
> recover old xmit ptr.
>
> Rename free_old_xmit_skbs() to free_old_xmit().
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 86 ++++++++++++++++++----------------------
>   1 file changed, 38 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 52653e234a20..f3752b254965 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -264,6 +264,30 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>   	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>   }
>   
> +static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> +			    struct virtnet_sq_stats *stats)
> +{
> +	unsigned int len;
> +	void *ptr;
> +
> +	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> +		if (likely(!is_xdp_frame(ptr))) {


So I think we need to drop likely here because it could be called by skb 
path.

Other looks good.

Thanks


> +			struct sk_buff *skb = ptr;
> +
> +			pr_debug("Sent skb %p\n", skb);
> +
> +			stats->bytes += skb->len;
> +			napi_consume_skb(skb, in_napi);
> +		} else {
> +			struct xdp_frame *frame = ptr_to_xdp(ptr);
> +
> +			stats->bytes += frame->len;
> +			xdp_return_frame(frame);
> +		}
> +		stats->packets++;
> +	}
> +}
> +
>   /* Converting between virtqueue no. and kernel tx/rx queue no.
>    * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
>    */
> @@ -525,15 +549,12 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   			    int n, struct xdp_frame **frames, u32 flags)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> +	struct virtnet_sq_stats stats = {};
>   	struct receive_queue *rq = vi->rq;
>   	struct bpf_prog *xdp_prog;
>   	struct send_queue *sq;
> -	unsigned int len;
> -	int packets = 0;
> -	int bytes = 0;
>   	int nxmit = 0;
>   	int kicks = 0;
> -	void *ptr;
>   	int ret;
>   	int i;
>   
> @@ -552,20 +573,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	}
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (likely(is_xdp_frame(ptr))) {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			bytes += frame->len;
> -			xdp_return_frame(frame);
> -		} else {
> -			struct sk_buff *skb = ptr;
> -
> -			bytes += skb->len;
> -			napi_consume_skb(skb, false);
> -		}
> -		packets++;
> -	}
> +	__free_old_xmit(sq, false, &stats);
>   
>   	for (i = 0; i < n; i++) {
>   		struct xdp_frame *xdpf = frames[i];
> @@ -582,8 +590,8 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	}
>   out:
>   	u64_stats_update_begin(&sq->stats.syncp);
> -	sq->stats.bytes += bytes;
> -	sq->stats.packets += packets;
> +	sq->stats.bytes += stats.bytes;
> +	sq->stats.packets += stats.packets;
>   	sq->stats.xdp_tx += n;
>   	sq->stats.xdp_tx_drops += n - nxmit;
>   	sq->stats.kicks += kicks;
> @@ -1406,39 +1414,21 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>   	return stats.packets;
>   }
>   
> -static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> +static void free_old_xmit(struct send_queue *sq, bool in_napi)
>   {
> -	unsigned int len;
> -	unsigned int packets = 0;
> -	unsigned int bytes = 0;
> -	void *ptr;
> -
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (likely(!is_xdp_frame(ptr))) {
> -			struct sk_buff *skb = ptr;
> -
> -			pr_debug("Sent skb %p\n", skb);
> +	struct virtnet_sq_stats stats = {};
>   
> -			bytes += skb->len;
> -			napi_consume_skb(skb, in_napi);
> -		} else {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			bytes += frame->len;
> -			xdp_return_frame(frame);
> -		}
> -		packets++;
> -	}
> +	__free_old_xmit(sq, in_napi, &stats);
>   
>   	/* Avoid overhead when no packets have been processed
>   	 * happens when called speculatively from start_xmit.
>   	 */
> -	if (!packets)
> +	if (!stats.packets)
>   		return;
>   
>   	u64_stats_update_begin(&sq->stats.syncp);
> -	sq->stats.bytes += bytes;
> -	sq->stats.packets += packets;
> +	sq->stats.bytes += stats.bytes;
> +	sq->stats.packets += stats.packets;
>   	u64_stats_update_end(&sq->stats.syncp);
>   }
>   
> @@ -1463,7 +1453,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> -		free_old_xmit_skbs(sq, true);
> +		free_old_xmit(sq, true);
>   		__netif_tx_unlock(txq);
>   	}
>   
> @@ -1548,7 +1538,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   
>   	txq = netdev_get_tx_queue(vi->dev, index);
>   	__netif_tx_lock(txq, raw_smp_processor_id());
> -	free_old_xmit_skbs(sq, true);
> +	free_old_xmit(sq, true);
>   	__netif_tx_unlock(txq);
>   
>   	virtqueue_napi_complete(napi, sq->vq, 0);
> @@ -1617,7 +1607,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	bool use_napi = sq->napi.weight;
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(sq, false);
> +	free_old_xmit(sq, false);
>   
>   	if (use_napi && kick)
>   		virtqueue_enable_cb_delayed(sq->vq);
> @@ -1661,7 +1651,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   		if (!use_napi &&
>   		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>   			/* More just got used, free them then recheck. */
> -			free_old_xmit_skbs(sq, false);
> +			free_old_xmit(sq, false);
>   			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>   				netif_start_subqueue(dev, qnum);
>   				virtqueue_disable_cb(sq->vq);

