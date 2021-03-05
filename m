Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7032E2CC
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCEHIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:08:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEHIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614928120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NEKrOKBQjNeh6xpfaaDnnWjqElQJhMWyC0KTnixxBgY=;
        b=HBPr5sODzX8TAag4Ykd/AtJbiVdpjrN8u/7wkXPjYMnY7oz//cJRLGnMCCvz1stV3yXEjI
        LJOi6Y7t98FBQxXbAMCLkxeCUa6Qquph3eM0+GVK7kERtDUsnkgqyULUUv6n0rN+NciyZ9
        NJmy/9pNvAfAWNjcX9WoHyLUeWZzQow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-djdlyYmFP6OzVYBOTlM1Ew-1; Fri, 05 Mar 2021 02:08:38 -0500
X-MC-Unique: djdlyYmFP6OzVYBOTlM1Ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B2457;
        Fri,  5 Mar 2021 07:08:36 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 049F25D9C0;
        Fri,  5 Mar 2021 07:08:28 +0000 (UTC)
Subject: Re: [PATCH v5 net-next] virtio-net: support XDP when not more queues
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <1614568959-107464-1-git-send-email-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7010e921-dd66-dc6c-220b-09144800d9d5@redhat.com>
Date:   Fri, 5 Mar 2021 15:08:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1614568959-107464-1-git-send-email-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/1 11:22 上午, Xuan Zhuo wrote:
> The number of queues implemented by many virtio backends is limited,
> especially some machines have a large number of CPUs. In this case, it
> is often impossible to allocate a separate queue for
> XDP_TX/XDP_REDIRECT, then xdp cannot be loaded to work, even xdp does
> not use the XDP_TX/XDP_REDIRECT.
>
> This patch allows XDP_TX/XDP_REDIRECT to run by reuse the existing SQ
> with __netif_tx_lock() hold when there are not enough queues.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
> v5: change subject from 'support XDP_TX when not more queues'
>
> v4: make sparse happy
>      suggested by Jakub Kicinski
>
> v3: add warning when no more queues
>      suggested by Jesper Dangaard Brouer
>
>   drivers/net/virtio_net.c | 53 ++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 44 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba8e637..55f1dd1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -195,6 +195,9 @@ struct virtnet_info {
>   	/* # of XDP queue pairs currently used by the driver */
>   	u16 xdp_queue_pairs;
>
> +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> +	bool xdp_enabled;
> +
>   	/* I like... big packets and I cannot lie! */
>   	bool big_packets;
>
> @@ -481,14 +484,42 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>   	return 0;
>   }
>
> -static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
> +static struct send_queue *virtnet_get_xdp_sq(struct virtnet_info *vi)
> +	__acquires(lock)
>   {
> +	struct netdev_queue *txq;
>   	unsigned int qp;
>
> -	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
> +	if (vi->curr_queue_pairs > nr_cpu_ids) {
> +		qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
> +
> +		/* tell sparse we took the lock, but don't really take it */
> +		__acquire(lock);


The code can explain itself but you need to explain why we don't need to 
hold tx lock here.

And it looks to me we should use __netif_tx_acquire()/__netif_tx_release()?

Btw, is it better to refactor the code then we can annote the code with 
something like __acquire(txq->xmit_lock)?

Thanks



> +	} else {
> +		qp = smp_processor_id() % vi->curr_queue_pairs;
> +		txq = netdev_get_tx_queue(vi->dev, qp);
> +		__netif_tx_lock(txq, raw_smp_processor_id());
> +	}
> +
>   	return &vi->sq[qp];
>   }
>
> +static void virtnet_put_xdp_sq(struct virtnet_info *vi, struct send_queue *sq)
> +	__releases(lock)
> +{
> +	struct netdev_queue *txq;
> +	unsigned int qp;
> +
> +	if (vi->curr_queue_pairs <= nr_cpu_ids) {
> +		qp = sq - vi->sq;
> +		txq = netdev_get_tx_queue(vi->dev, qp);
> +		__netif_tx_unlock(txq);
> +	} else {
> +		/* make sparse happy */
> +		__release(lock);
> +	}
> +}
> +
>   static int virtnet_xdp_xmit(struct net_device *dev,
>   			    int n, struct xdp_frame **frames, u32 flags)
>   {
> @@ -512,7 +543,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	if (!xdp_prog)
>   		return -ENXIO;
>
> -	sq = virtnet_xdp_sq(vi);
> +	sq = virtnet_get_xdp_sq(vi);
>
>   	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>   		ret = -EINVAL;
> @@ -560,12 +591,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	sq->stats.kicks += kicks;
>   	u64_stats_update_end(&sq->stats.syncp);
>
> +	virtnet_put_xdp_sq(vi, sq);
>   	return ret;
>   }
>
>   static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>   {
> -	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
> +	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
>   }
>
>   /* We copy the packet for XDP in the following cases:
> @@ -1457,12 +1489,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>   		xdp_do_flush();
>
>   	if (xdp_xmit & VIRTIO_XDP_TX) {
> -		sq = virtnet_xdp_sq(vi);
> +		sq = virtnet_get_xdp_sq(vi);
>   		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
>   			u64_stats_update_begin(&sq->stats.syncp);
>   			sq->stats.kicks++;
>   			u64_stats_update_end(&sq->stats.syncp);
>   		}
> +		virtnet_put_xdp_sq(vi, sq);
>   	}
>
>   	return received;
> @@ -2417,10 +2450,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>
>   	/* XDP requires extra queues for XDP_TX */
>   	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> -		netdev_warn(dev, "request %i queues but max is %i\n",
> +		netdev_warn(dev, "XDP request %i queues but max is %i. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.\n",
>   			    curr_qp + xdp_qp, vi->max_queue_pairs);
> -		return -ENOMEM;
> +		xdp_qp = 0;
>   	}
>
>   	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
> @@ -2454,11 +2486,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   	vi->xdp_queue_pairs = xdp_qp;
>
>   	if (prog) {
> +		vi->xdp_enabled = true;
>   		for (i = 0; i < vi->max_queue_pairs; i++) {
>   			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
>   			if (i == 0 && !old_prog)
>   				virtnet_clear_guest_offloads(vi);
>   		}
> +	} else {
> +		vi->xdp_enabled = false;
>   	}
>
>   	for (i = 0; i < vi->max_queue_pairs; i++) {
> @@ -2526,7 +2561,7 @@ static int virtnet_set_features(struct net_device *dev,
>   	int err;
>
>   	if ((dev->features ^ features) & NETIF_F_LRO) {
> -		if (vi->xdp_queue_pairs)
> +		if (vi->xdp_enabled)
>   			return -EBUSY;
>
>   		if (features & NETIF_F_LRO)
> --
> 1.8.3.1
>

