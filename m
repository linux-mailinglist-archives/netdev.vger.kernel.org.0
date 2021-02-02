Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9EA30B5A7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBBDId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:08:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229819AbhBBDIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612235224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYZ9+aRJ8bVLHVHjWPczPcqQ8T3GglKCO0MI3Vvvxx4=;
        b=JnD7jhx7KSrNzFll2giITjLkvHTtJJaH1INPlP5Sw/0YDoYmdFvzUyBQwrasTx9n/zEX2k
        l2l/GptlObfXh/LrwvQm/oRZfeE879ToUggAMhg7xo/3omSm9IeECv9bEz2XXInPCI/OLj
        n9lM5NU4flWrWCyiwMTbavsUyYKmE5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-AAfjKhMDO0mF1p6SU-u6-Q-1; Mon, 01 Feb 2021 22:07:01 -0500
X-MC-Unique: AAfjKhMDO0mF1p6SU-u6-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEED659;
        Tue,  2 Feb 2021 03:06:59 +0000 (UTC)
Received: from [10.72.13.250] (ovpn-13-250.pek2.redhat.com [10.72.13.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1C6360BE5;
        Tue,  2 Feb 2021 03:06:57 +0000 (UTC)
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210129002136.70865-1-weiwan@google.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
Date:   Tue, 2 Feb 2021 11:06:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210129002136.70865-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/29 上午8:21, Wei Wang wrote:
> With the implementation of napi-tx in virtio driver, we clean tx
> descriptors from rx napi handler, for the purpose of reducing tx
> complete interrupts. But this could introduce a race where tx complete
> interrupt has been raised, but the handler found there is no work to do
> because we have done the work in the previous rx interrupt handler.
> This could lead to the following warning msg:
> [ 3588.010778] irq 38: nobody cared (try booting with the
> "irqpoll" option)
> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> 5.3.0-19-generic #20~18.04.2-Ubuntu
> [ 3588.017940] Call Trace:
> [ 3588.017942]  <IRQ>
> [ 3588.017951]  dump_stack+0x63/0x85
> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> [ 3588.017957]  handle_irq_event+0x3b/0x60
> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> [ 3588.017961]  handle_irq+0x20/0x30
> [ 3588.017964]  do_IRQ+0x50/0xe0
> [ 3588.017966]  common_interrupt+0xf/0xf
> [ 3588.017966]  </IRQ>
> [ 3588.017989] handlers:
> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> [ 3588.025099] Disabling IRQ #38
>
> This patch adds a new param to struct vring_virtqueue, and we set it for
> tx virtqueues if napi-tx is enabled, to suppress the warning in such
> case.
>
> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> Reported-by: Rick Jones <jonesrick@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>


Please use get_maintainer.pl to make sure Michael and me were cced.


> ---
>   drivers/net/virtio_net.c     | 19 ++++++++++++++-----
>   drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
>   include/linux/virtio.h       |  2 ++
>   3 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78f..e9a3f30864e8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
>   		return;
>   	}
>   
> +	/* With napi_tx enabled, free_old_xmit_skbs() could be called from
> +	 * rx napi handler. Set work_steal to suppress bad irq warning for
> +	 * IRQ_NONE case from tx complete interrupt handler.
> +	 */
> +	virtqueue_set_work_steal(vq, true);
> +
>   	return virtnet_napi_enable(vq, napi);


Do we need to force the ordering between steal set and napi enable?


>   }
>   
> -static void virtnet_napi_tx_disable(struct napi_struct *napi)
> +static void virtnet_napi_tx_disable(struct virtqueue *vq,
> +				    struct napi_struct *napi)
>   {
> -	if (napi->weight)
> +	if (napi->weight) {
>   		napi_disable(napi);
> +		virtqueue_set_work_steal(vq, false);
> +	}
>   }
>   
>   static void refill_work(struct work_struct *work)
> @@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
>   	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>   		napi_disable(&vi->rq[i].napi);
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> +		virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>   	}
>   
>   	return 0;
> @@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>   	if (netif_running(vi->dev)) {
>   		for (i = 0; i < vi->max_queue_pairs; i++) {
>   			napi_disable(&vi->rq[i].napi);
> -			virtnet_napi_tx_disable(&vi->sq[i].napi);
> +			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>   		}
>   	}
>   }
> @@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   	if (netif_running(dev)) {
>   		for (i = 0; i < vi->max_queue_pairs; i++) {
>   			napi_disable(&vi->rq[i].napi);
> -			virtnet_napi_tx_disable(&vi->sq[i].napi);
> +			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>   		}
>   	}
>   
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..f7c5d697c302 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -105,6 +105,9 @@ struct vring_virtqueue {
>   	/* Host publishes avail event idx */
>   	bool event;
>   
> +	/* Tx side napi work could be done from rx side. */
> +	bool work_steal;


So vring_vritqueue is a general structure, let's avoid mentioning 
network specific stuffs here. And we need a better name like 
"no_interrupt_check"?

And we need a separate patch for virtio core changes.


> +
>   	/* Head of free buffer list. */
>   	unsigned int free_head;
>   	/* Number we've added since last sync. */
> @@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
>   	vq->broken = false;
> +	vq->work_steal = false;
>   	vq->last_used_idx = 0;
>   	vq->num_added = 0;
>   	vq->packed_ring = true;
> @@ -2038,6 +2042,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>   
>   	if (!more_used(vq)) {
>   		pr_debug("virtqueue interrupt with no work for %p\n", vq);


Do we still need to keep this warning?


> +		if (vq->work_steal)
> +			return IRQ_HANDLED;


So I wonder instead of doing trick like this, maybe it's time to unify 
TX/RX NAPI with the help of[1] (virtio-net use queue pairs).

Thanks

[1] https://lkml.org/lkml/2014/12/25/169

> +
>   		return IRQ_NONE;
>   	}
>   
> @@ -2082,6 +2089,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
>   	vq->broken = false;
> +	vq->work_steal = false;
>   	vq->last_used_idx = 0;
>   	vq->num_added = 0;
>   	vq->use_dma_api = vring_use_dma_api(vdev);
> @@ -2266,6 +2274,14 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
>   }
>   EXPORT_SYMBOL_GPL(virtqueue_is_broken);
>   
> +void virtqueue_set_work_steal(struct virtqueue *_vq, bool val)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	vq->work_steal = val;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_set_work_steal);
> +
>   /*
>    * This should prevent the device from being used, allowing drivers to
>    * recover.  You may need to grab appropriate locks to flush.
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 55ea329fe72a..091c30f21ff9 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -84,6 +84,8 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
>   
>   bool virtqueue_is_broken(struct virtqueue *vq);
>   
> +void virtqueue_set_work_steal(struct virtqueue *vq, bool val);
> +
>   const struct vring *virtqueue_get_vring(struct virtqueue *vq);
>   dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
>   dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);

