Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776E3363979
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 04:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhDSCrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 22:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233084AbhDSCrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 22:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618800392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b26F08PVgTA3dOscswyb3SZYcfYzeEOmbnvHQdwgH28=;
        b=P0UPvH6yxfcKS5oYRnIMBwCfxc0avAm6D6cp/PYpJWPZQC0wtmqSGaI+XdfhWFRBt6tEEq
        w1JXP5hpgHE0LrVAdEEO1qmKraqPc+vpxxMI27WaH+xV2WtGN+kU1bazHbuRbb3oLF+6Rp
        3Yl2P4ySPfiYAags26qxt8k2RY5T5No=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-F8OuntZBNDGF9KV0v4Yozw-1; Sun, 18 Apr 2021 22:46:28 -0400
X-MC-Unique: F8OuntZBNDGF9KV0v4Yozw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88274801814;
        Mon, 19 Apr 2021 02:46:26 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 516935D9C0;
        Mon, 19 Apr 2021 02:46:17 +0000 (UTC)
Subject: Re: [PATCH net-next v4 09/10] virtio-net: xsk zero copy xmit
 implement wakeup and xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        "dust.li" <dust.li@linux.alibaba.com>, netdev@vger.kernel.org
References: <1618554586.8830593-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <376b0b1f-7b66-dea2-cecb-88e030550a72@redhat.com>
Date:   Mon, 19 Apr 2021 10:46:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1618554586.8830593-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/16 下午2:29, Xuan Zhuo 写道:
> On Fri, 16 Apr 2021 13:35:33 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/4/15 下午6:27, Xuan Zhuo 写道:
>>> On Wed, 14 Apr 2021 13:46:45 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/4/13 上午11:15, Xuan Zhuo 写道:
>>>>> This patch implements the core part of xsk zerocopy xmit.
>>>>>
>>>>> When the user calls sendto to consume the data in the xsk tx queue,
>>>>> virtnet_xsk_wakeup() will be called.
>>>>>
>>>>> In wakeup, it will try to send a part of the data directly. There are
>>>>> two purposes for this realization:
>>>>>
>>>>> 1. Send part of the data quickly to reduce the transmission delay of the
>>>>>       first packet.
>>>>> 2. Trigger tx interrupt, start napi to consume xsk tx data.
>>>>>
>>>>> All sent xsk packets share the virtio-net header of xsk_hdr. If xsk
>>>>> needs to support csum and other functions later, consider assigning xsk
>>>>> hdr separately for each sent packet.
>>>>>
>>>>> There are now three situations in free_old_xmit(): skb, xdp frame, xsk
>>>>> desc.  Based on the last two bit of ptr returned by virtqueue_get_buf():
>>>>>        00 is skb by default.
>>>>>        01 represents the packet sent by xdp
>>>>>        10 is the packet sent by xsk
>>>>>
>>>>> If the xmit work of xsk has not been completed, but the ring is full,
>>>>> napi must first exit and wait for the ring to be available, so
>>>>> need_wakeup() is set. If free_old_xmit() is called first by start_xmit(),
>>>>> we can quickly wake up napi to execute xsk xmit task.
>>>>>
>>>>> When recycling, we need to count the number of bytes sent, so put xsk
>>>>> desc->len into the ptr pointer. Because ptr does not point to meaningful
>>>>> objects in xsk.
>>>>>
>>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>>>> ---
>>>>>     drivers/net/virtio_net.c | 296 ++++++++++++++++++++++++++++++++++++++-
>>>>>     1 file changed, 292 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>> index 8242a9e9f17d..c441d6bf1510 100644
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -46,6 +46,11 @@ module_param(napi_tx, bool, 0644);
>>>>>     #define VIRTIO_XDP_REDIR	BIT(1)
>>>>>
>>>>>     #define VIRTIO_XDP_FLAG	BIT(0)
>>>>> +#define VIRTIO_XSK_FLAG	BIT(1)
>>>>> +
>>>>> +#define VIRTIO_XSK_PTR_SHIFT       4
>>>>> +
>>>>> +static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
>>>>>
>>>>>     /* RX packet size EWMA. The average packet size is used to determine the packet
>>>>>      * buffer size when refilling RX rings. As the entire RX ring may be refilled
>>>>> @@ -138,6 +143,12 @@ struct send_queue {
>>>>>     	struct {
>>>>>     		/* xsk pool */
>>>>>     		struct xsk_buff_pool __rcu *pool;
>>>>> +
>>>>> +		/* save the desc for next xmit, when xmit fail. */
>>>>> +		struct xdp_desc last_desc;
>>>> As replied in the pervious version this looks tricky. I think we need to
>>>> make sure to reserve some slots as skb path did.
>>>>
>>>> This looks exactly like what stmmac did which alos shares XDP and skb
>>>> for the same ring.
>>>>
>>>>
>>>>> +
>>>>> +		/* xsk wait for tx inter or softirq */
>>>>> +		bool need_wakeup;
>>>>>     	} xsk;
>>>>>     };
>>>>>
>>>>> @@ -255,6 +266,15 @@ struct padded_vnet_hdr {
>>>>>     	char padding[4];
>>>>>     };
>>>>>
>>>>> +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
>>>>> +			   int budget, bool in_napi);
>>>>> +static void virtnet_xsk_complete(struct send_queue *sq, u32 num);
>>>>> +
>>>>> +static bool is_skb_ptr(void *ptr)
>>>>> +{
>>>>> +	return !((unsigned long)ptr & (VIRTIO_XDP_FLAG | VIRTIO_XSK_FLAG));
>>>>> +}
>>>>> +
>>>>>     static bool is_xdp_frame(void *ptr)
>>>>>     {
>>>>>     	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
>>>>> @@ -265,6 +285,19 @@ static void *xdp_to_ptr(struct xdp_frame *ptr)
>>>>>     	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
>>>>>     }
>>>>>
>>>>> +static void *xsk_to_ptr(struct xdp_desc *desc)
>>>>> +{
>>>>> +	/* save the desc len to ptr */
>>>>> +	u64 p = desc->len << VIRTIO_XSK_PTR_SHIFT;
>>>>> +
>>>>> +	return (void *)((unsigned long)p | VIRTIO_XSK_FLAG);
>>>>> +}
>>>>> +
>>>>> +static void ptr_to_xsk(void *ptr, struct xdp_desc *desc)
>>>>> +{
>>>>> +	desc->len = ((unsigned long)ptr) >> VIRTIO_XSK_PTR_SHIFT;
>>>>> +}
>>>>> +
>>>>>     static struct xdp_frame *ptr_to_xdp(void *ptr)
>>>>>     {
>>>>>     	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>>>>> @@ -273,25 +306,35 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>>>>>     static void __free_old_xmit(struct send_queue *sq, bool in_napi,
>>>>>     			    struct virtnet_sq_stats *stats)
>>>>>     {
>>>>> +	unsigned int xsknum = 0;
>>>>>     	unsigned int len;
>>>>>     	void *ptr;
>>>>>
>>>>>     	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
>>>>> -		if (likely(!is_xdp_frame(ptr))) {
>>>>> +		if (is_skb_ptr(ptr)) {
>>>>>     			struct sk_buff *skb = ptr;
>>>>>
>>>>>     			pr_debug("Sent skb %p\n", skb);
>>>>>
>>>>>     			stats->bytes += skb->len;
>>>>>     			napi_consume_skb(skb, in_napi);
>>>>> -		} else {
>>>>> +		} else if (is_xdp_frame(ptr)) {
>>>>>     			struct xdp_frame *frame = ptr_to_xdp(ptr);
>>>>>
>>>>>     			stats->bytes += frame->len;
>>>>>     			xdp_return_frame(frame);
>>>>> +		} else {
>>>>> +			struct xdp_desc desc;
>>>>> +
>>>>> +			ptr_to_xsk(ptr, &desc);
>>>>> +			stats->bytes += desc.len;
>>>>> +			++xsknum;
>>>>>     		}
>>>>>     		stats->packets++;
>>>>>     	}
>>>>> +
>>>>> +	if (xsknum)
>>>>> +		virtnet_xsk_complete(sq, xsknum);
>>>>>     }
>>>>>
>>>>>     /* Converting between virtqueue no. and kernel tx/rx queue no.
>>>>> @@ -1529,6 +1572,19 @@ static int virtnet_open(struct net_device *dev)
>>>>>     	return 0;
>>>>>     }
>>>>>
>>>>> +static int virtnet_poll_xsk(struct send_queue *sq, int budget)
>>>>> +{
>>>>> +	struct xsk_buff_pool *pool;
>>>>> +	int work_done = 0;
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +	pool = rcu_dereference(sq->xsk.pool);
>>>>> +	if (pool)
>>>>> +		work_done = virtnet_xsk_run(sq, pool, budget, true);
>>>>> +	rcu_read_unlock();
>>>>> +	return work_done;
>>>>> +}
>>>>> +
>>>>>     static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>>>     {
>>>>>     	struct send_queue *sq = container_of(napi, struct send_queue, napi);
>>>>> @@ -1545,6 +1601,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>>>
>>>>>     	txq = netdev_get_tx_queue(vi->dev, index);
>>>>>     	__netif_tx_lock(txq, raw_smp_processor_id());
>>>>> +	work_done += virtnet_poll_xsk(sq, budget);
>>>>>     	free_old_xmit(sq, true);
>>>>>     	__netif_tx_unlock(txq);
>>>>>
>>>>> @@ -2535,6 +2592,234 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>>>>     	return err;
>>>>>     }
>>>>>
>>>>> +static void virtnet_xsk_check_queue(struct send_queue *sq)
>>>>> +{
>>>>> +	struct virtnet_info *vi = sq->vq->vdev->priv;
>>>>> +	struct net_device *dev = vi->dev;
>>>>> +	int qnum = sq - vi->sq;
>>>>> +
>>>>> +	/* If this sq is not the exclusive queue of the current cpu,
>>>>> +	 * then it may be called by start_xmit, so check it running out
>>>>> +	 * of space.
>>>>> +	 *
>>>> I think it's better to move this check after is_xdp_raw_buffer_queue().
>>> Sorry, do not understand.
>>
>> So what I meant is:
>>
>>
>> /* If it is a raw buffer queue, ... */
>>       if (is_xdp_raw_buffer_queue())
>>
>> /* if it is not the exclusive queue */
>>       if (sq->vq->num_free ...)
> I understand.
>
>>
>>>>> +	 * And if it is a raw buffer queue, it does not check whether the status
>>>>> +	 * of the queue is stopped when sending. So there is no need to check
>>>>> +	 * the situation of the raw buffer queue.
>>>>> +	 */
>>>>> +	if (is_xdp_raw_buffer_queue(vi, qnum))
>>>>> +		return;
>>>>> +
>>>>> +	/* Stop the queue to avoid getting packets that we are
>>>>> +	 * then unable to transmit. Then wait the tx interrupt.
>>>>> +	 */
>>>>> +	if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
>>>>> +		netif_stop_subqueue(dev, qnum);
>>>> Is there any way to stop xsk TX here?
>>> xsk tx is driven by tx napi, so stop has no meaning.
>>
>> So NAPI can be stopped.
>>
>>
>>>
>>>>> +}
>>>>> +
>>>>> +static void virtnet_xsk_complete(struct send_queue *sq, u32 num)
>>>>> +{
>>>>> +	struct xsk_buff_pool *pool;
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +
>>>>> +	pool = rcu_dereference(sq->xsk.pool);
>>>>> +	if (!pool) {
>>>>> +		rcu_read_unlock();
>>>>> +		return;
>>>>> +	}
>>>>> +	xsk_tx_completed(pool, num);
>>>>> +	rcu_read_unlock();
>>>>> +
>>>>> +	if (sq->xsk.need_wakeup) {
>>>>> +		sq->xsk.need_wakeup = false;
>>>>> +		virtqueue_napi_schedule(&sq->napi, sq->vq);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
>>>>> +			    struct xdp_desc *desc)
>>>>> +{
>>>>> +	struct virtnet_info *vi;
>>>>> +	u32 offset, n, len;
>>>>> +	struct page *page;
>>>>> +	void *data;
>>>>> +	u64 addr;
>>>>> +	int err;
>>>>> +
>>>>> +	vi = sq->vq->vdev->priv;
>>>>> +	addr = desc->addr;
>>>>> +
>>>>> +	data = xsk_buff_raw_get_data(pool, addr);
>>>>> +	offset = offset_in_page(data);
>>>>> +
>>>>> +	/* xsk unaligned mode, desc may use two pages */
>>>>> +	if (desc->len > PAGE_SIZE - offset)
>>>>> +		n = 3;
>>>>> +	else
>>>>> +		n = 2;
>>>>> +
>>>>> +	sg_init_table(sq->sg, n);
>>>>> +	sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
>>>>> +
>>>>> +	/* handle for xsk first page */
>>>>> +	len = min_t(int, desc->len, PAGE_SIZE - offset);
>>>>> +	page = xsk_buff_xdp_get_page(pool, addr);
>>>>> +	sg_set_page(sq->sg + 1, page, len, offset);
>>>>> +
>>>>> +	/* xsk unaligned mode, handle for the second page */
>>>>> +	if (len < desc->len) {
>>>>> +		page = xsk_buff_xdp_get_page(pool, addr + len);
>>>>> +		len = min_t(int, desc->len - len, PAGE_SIZE);
>>>>> +		sg_set_page(sq->sg + 2, page, len, 0);
>>>>> +	}
>>>>> +
>>>>> +	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, xsk_to_ptr(desc),
>>>>> +				   GFP_ATOMIC);
>>>>> +	if (unlikely(err))
>>>>> +		sq->xsk.last_desc = *desc;
>>>>> +
>>>>> +	return err;
>>>>> +}
>>>>> +
>>>>> +static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>>>>> +				  struct xsk_buff_pool *pool,
>>>>> +				  unsigned int budget,
>>>>> +				  bool in_napi, int *done,
>>>>> +				  struct virtnet_sq_stats *stats)
>>>>> +{
>>>>> +	struct xdp_desc desc;
>>>>> +	int err, packet = 0;
>>>>> +	int ret = -EAGAIN;
>>>>> +
>>>>> +	if (sq->xsk.last_desc.addr) {
>>>>> +		if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
>>>>> +			return -EBUSY;
>>>>> +
>>>>> +		err = virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
>>>>> +		if (unlikely(err))
>>>>> +			return -EBUSY;
>>>>> +
>>>>> +		++packet;
>>>>> +		--budget;
>>>>> +		sq->xsk.last_desc.addr = 0;
>>>> So I think we don't need to do this since we try always to reserve 2 +
>>>> MAX_SKB_FRAGS, then it means we get -EIO/-ENOMEM which is bascially a
>>>> broken device or dma map.
>>>>
>>> Does it mean that when there are enough slots, virtqueue_add_outbuf() returns
>>> failure -EIO/-ENOMEM, which means that the network card is no longer working.
>>
>> Or it could be a bug of the driver. And you don't need to check num_free
>> before if you always try to reserve sufficient slots.
>>
>>
>>> I originally thought that an error was returned, but it may work normally next
>>> time. It should be my fault.
>>>
>>> Thank you very much, I learned it. I will delete the related code.
>>>
>>>>> +	}
>>>>> +
>>>>> +	while (budget-- > 0) {
>>>>> +		if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
>>>>> +			ret = -EBUSY;
>>>>> +			break;
>>>>> +		}
>>>>> +
>>>>> +		if (!xsk_tx_peek_desc(pool, &desc)) {
>>>>> +			/* done */
>>>>> +			ret = 0;
>>>>> +			break;
>>>>> +		}
>>>>> +
>>>>> +		err = virtnet_xsk_xmit(sq, pool, &desc);
>>>>> +		if (unlikely(err)) {
>>>>> +			ret = -EBUSY;
>>>> Since the function will be called by NAPI I think we to report the
>>>> number of packets that is transmitted as well.
>>> A 'desc' points to a packet, so only one packet is sent by virtnet_xsk_xmit().
>>> I have this information in the following variable "packet" statistics. Finally,
>>> use the parameter "done" to pass to the upper layer.
>>
>> I meant you did:
>>
>> virtnet_poll_tx()
>>       work_done += virtnet_poll_xsk()
>>       virtnet_xsk_run()
>>           virtnet_xsk_xmit_batch()
>>
>> If there's no suffcieint slot you still need to return the number of
>> packet that has been sent.
> I don’t understand what you mean.
>
> As long as there are packets sent, "++packet" will be counted, and finally
> returned to virtnet_xsk_run() through "done", regardless of whether there is
> insufficient slot.


Right, I misread the code.


>
>>
>>
>>>>> +			break;
>>>>> +		}
>>>>> +
>>>>> +		++packet;
>>>>> +	}
>>>>> +
>>>>> +	if (packet) {
>>>>> +		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
>>>>> +			++stats->kicks;
>>>>> +
>>>>> +		*done = packet;
>>>>> +		stats->xdp_tx += packet;
>>>>> +
>>>>> +		xsk_tx_release(pool);
>>>>> +	}
>>>>> +
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>> +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
>>>>> +			   int budget, bool in_napi)
>>>>> +{
>>>>> +	struct virtnet_sq_stats stats = {};
>>>>> +	int done = 0;
>>>>> +	int err;
>>>>> +
>>>>> +	sq->xsk.need_wakeup = false;
>>>>> +	__free_old_xmit(sq, in_napi, &stats);
>>>>> +
>>>>> +	/* return err:
>>>>> +	 * -EAGAIN: done == budget
>>>>> +	 * -EBUSY:  done < budget
>>>>> +	 *  0    :  done < budget
>>>>> +	 */
>>>>> +	err = virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done, &stats);
>>>>> +	if (err == -EBUSY) {
>>>>> +		__free_old_xmit(sq, in_napi, &stats);
>>>>> +
>>>>> +		/* If the space is enough, let napi run again. */
>>>>> +		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>>>>> +			done = budget;
>>>> Why you need to run NAPI isntead of a netif_tx_wake()?
>>> When virtnet_xsk_run() is called by virtnet_xsk_wakeup(), the return value is
>>> not concerned.
>>>
>>> virtnet_xsk_run() is already in napi when it is called by poll_tx(), so if there
>>> are more slots, I try to return "budget" and let napi call poll_tx() again
>>
>> Well, my question is why you don't need to wakeup the qdisc in this
>> case. Note that the queue could be shared with ndo_start_xmit().
> virtnet_xsk_run() will been called by virtnet_poll_tx() or virtnet_xsk_wakeup().
>
> 1. virtnet_poll_tx() will call netif_tx_wake_queue()
>
> static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> {
> 	.....
>
> 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> 		netif_tx_wake_queue(txq);
>
> 2. virtnet_xsk_wakeup()
>       You are right. We can indeed call virtnet_xsk_wakeup() here.
>
>>
>>>>> +		else
>>>>> +			sq->xsk.need_wakeup = true;
>>>> So done is 0, is this intended?
>>> When err == 0, it indicates that the xsk queue has been exhausted. At this time,
>>> done < budget, return done directly, and napi can be stopped.
>>>
>>> When err == -EAGAIN, it indicates that the budget amount of patch has been sent,
>>> and done should be returned to the upper layer. Wait for napi to call poll_tx()
>>> again
>>
>> So the code is only for -EBUSY if I read the code correctly. And in this
>> case you return 0.
> This case, I return 'done' and the done < budge.  'done' may not be 0.
>
> done < budget, so napi will stop.


So to question is about this:

                 /* If the space is enough, let napi run again. */
                 if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
                         done = budget;
else
                         sq->xsk.need_wakeup = true;

So done is 0 when num_free < 2 + MAX_SKB_FRAGS, I think you should 
return done here.

Note that done is still less than budget in this case.

Another question, when num_free >= 2 + MAX_SKB_FRAGS why not simply 
re-try virtnet_xsk_xmit_batch here?


>
>
>>
>>> In both cases, done is directly returned to the upper layer without special
>>> processing.
>>>
>>>>> +	}
>>>>> +
>>>>> +	virtnet_xsk_check_queue(sq);
>>>>> +
>>>>> +	u64_stats_update_begin(&sq->stats.syncp);
>>>>> +	sq->stats.packets += stats.packets;
>>>>> +	sq->stats.bytes += stats.bytes;
>>>>> +	sq->stats.kicks += stats.kicks;
>>>>> +	sq->stats.xdp_tx += stats.xdp_tx;
>>>>> +	u64_stats_update_end(&sq->stats.syncp);
>>>>> +
>>>>> +	return done;
>>>>> +}
>>>>> +
>>>>> +static int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
>>>>> +{
>>>>> +	struct virtnet_info *vi = netdev_priv(dev);
>>>>> +	struct xsk_buff_pool *pool;
>>>>> +	struct netdev_queue *txq;
>>>>> +	struct send_queue *sq;
>>>>> +
>>>>> +	if (!netif_running(dev))
>>>>> +		return -ENETDOWN;
>>>>> +
>>>>> +	if (qid >= vi->curr_queue_pairs)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	sq = &vi->sq[qid];
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +
>>>>> +	pool = rcu_dereference(sq->xsk.pool);
>>>>> +	if (!pool)
>>>>> +		goto end;
>>>>> +
>>>>> +	if (napi_if_scheduled_mark_missed(&sq->napi))
>>>>> +		goto end;
>>>>> +
>>>>> +	txq = netdev_get_tx_queue(dev, qid);
>>>>> +
>>>>> +	__netif_tx_lock_bh(txq);
>>>>> +
>>>>> +	/* Send part of the packet directly to reduce the delay in sending the
>>>>> +	 * packet, and this can actively trigger the tx interrupts.
>>>>> +	 *
>>>>> +	 * If no packet is sent out, the ring of the device is full. In this
>>>>> +	 * case, we will still get a tx interrupt response. Then we will deal
>>>>> +	 * with the subsequent packet sending work.
>>>> So stmmac schedule NAPI here, do you have perf numbers for this improvement?
>>> virtnet_xsk_wakeup() is called by sendto(). The purpose is to start consuming
>>> the data in the xsk tx queue. The purpose here is to make napi run.
>>>
>>> When napi is not running, I try to send a certain amount of data:
>>> 1. Reduce the delay of the first packet
>>> 2. Trigger hardware to generate tx interrupt
>>
>> I dont' see the code the trigger hardware interrupt and I don't believe
>> virtio can do this.
>>
>> So the point is we need
>>
>> 1) schedule NAPI when napi_if_scheduled_mark_missed() returns false
>> 2) introduce this optimization on top with perf numbers
> It is true that virtio net does not directly let the hardware generate a tx
> method. So I try to send data here to wait for the tx interrupt notification
> from the hardware to recycle the sent packets.
>
> Is this method not feasible?


I think the answer is yes. But you need to benchmark this optimization 
to make sure it can give us the imporvement as you expected.

So I suggest to do something like follow:

1) start with a simple napi schedule here
2) add your optimization on top and benchmark the difference


>
> Do you mean the performance improvement brought by xsk zerocopy? I should put it
> in the patch set cover. Indeed I should put one in the commit log of this patch.
>
> There is a problem with that direct schedule NAPI. It will wait for NAPI to run
> on the current cpu. This will cause an obvious delay. Especially the current
> user process may occupy the cpu.


Yes, but can you simply do:

local_bh_disalbe();
netif_napi_schedule();
local_bh_enable();

?

Thanks


>
> Thanks.
>
>> Thanks
>>
>>> Thanks.
>>>
>>>> Thanks
>>>>
>>>>
>>>>> +	 */
>>>>> +	virtnet_xsk_run(sq, pool, napi_weight, false);
>>>>> +
>>>>> +	__netif_tx_unlock_bh(txq);
>>>>> +
>>>>> +end:
>>>>> +	rcu_read_unlock();
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>     static int virtnet_xsk_pool_enable(struct net_device *dev,
>>>>>     				   struct xsk_buff_pool *pool,
>>>>>     				   u16 qid)
>>>>> @@ -2559,6 +2844,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
>>>>>     		return -EPERM;
>>>>>
>>>>>     	rcu_read_lock();
>>>>> +	memset(&sq->xsk, 0, sizeof(sq->xsk));
>>>>> +
>>>>>     	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
>>>>>     	 * safe.
>>>>>     	 */
>>>>> @@ -2658,6 +2945,7 @@ static const struct net_device_ops virtnet_netdev = {
>>>>>     	.ndo_vlan_rx_kill_vid = virtnet_vlan_rx_kill_vid,
>>>>>     	.ndo_bpf		= virtnet_xdp,
>>>>>     	.ndo_xdp_xmit		= virtnet_xdp_xmit,
>>>>> +	.ndo_xsk_wakeup         = virtnet_xsk_wakeup,
>>>>>     	.ndo_features_check	= passthru_features_check,
>>>>>     	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>>>>>     	.ndo_set_features	= virtnet_set_features,
>>>>> @@ -2761,9 +3049,9 @@ static void free_unused_bufs(struct virtnet_info *vi)
>>>>>     	for (i = 0; i < vi->max_queue_pairs; i++) {
>>>>>     		struct virtqueue *vq = vi->sq[i].vq;
>>>>>     		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
>>>>> -			if (!is_xdp_frame(buf))
>>>>> +			if (is_skb_ptr(buf))
>>>>>     				dev_kfree_skb(buf);
>>>>> -			else
>>>>> +			else if (is_xdp_frame(buf))
>>>>>     				xdp_return_frame(ptr_to_xdp(buf));
>>>>>     		}
>>>>>     	}

