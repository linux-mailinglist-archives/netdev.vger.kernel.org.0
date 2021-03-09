Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34B4331D23
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCICr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:47:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhCICrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615258060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yXxMXtBDnNA6kd3wQmWLnEiKXRyWhKVg+orPmmFoSwQ=;
        b=GCmqLglgsya18/WZUuiUAsVmri1AQsXAGv3Da7XtYb6SDZP5zTwgTSjTLT1ShtwZBmU7GL
        DHVh1NKIf8JwQD6kkol+SYzcS8VjMpVR+HZ1HZHYKJWPSj8vIqDc2OiECfDzVE+fupscw1
        9Spfn/6fPdIhe5uRFvWAZEMN21/v/nU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-JKFitLOKOOuULmc2xzrRwA-1; Mon, 08 Mar 2021 21:47:37 -0500
X-MC-Unique: JKFitLOKOOuULmc2xzrRwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A888326862;
        Tue,  9 Mar 2021 02:47:35 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD9F85D9CD;
        Tue,  9 Mar 2021 02:47:27 +0000 (UTC)
Subject: Re: [PATCH v7 net-next] virtio-net: support XDP when not more queues
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <1615257107.0376601-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cff8d1b7-8267-75a0-cfef-5330a1442742@redhat.com>
Date:   Tue, 9 Mar 2021 10:47:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1615257107.0376601-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/9 10:31 上午, Xuan Zhuo wrote:
> On Tue, 9 Mar 2021 10:17:16 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> On 2021/3/8 4:52 下午, Xuan Zhuo wrote:
>>> The number of queues implemented by many virtio backends is limited,
>>> especially some machines have a large number of CPUs. In this case, it
>>> is often impossible to allocate a separate queue for
>>> XDP_TX/XDP_REDIRECT, then xdp cannot be loaded to work, even xdp does
>>> not use the XDP_TX/XDP_REDIRECT.
>>>
>>> This patch allows XDP_TX/XDP_REDIRECT to run by reuse the existing SQ
>>> with __netif_tx_lock() hold when there are not enough queues.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>> ---
>>> v7: 1. use macros to implement get/put
>>>       2. remove 'flag'. (suggested by Jason Wang)
>>>
>>> v6: 1. use __netif_tx_acquire()/__netif_tx_release(). (suggested by Jason Wang)
>>>       2. add note for why not lock. (suggested by Jason Wang)
>>>       3. Use variable 'flag' to record with or without locked.  It is not safe to
>>>          use curr_queue_pairs in "virtnet_put_xdp_sq", because it may changed after
>>>          "virtnet_get_xdp_sq".
>>>
>>> v5: change subject from 'support XDP_TX when not more queues'
>>>
>>> v4: make sparse happy
>>>       suggested by Jakub Kicinski
>>>
>>> v3: add warning when no more queues
>>>       suggested by Jesper Dangaard Brouer
>>>
>>>    drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++------------
>>>    1 file changed, 42 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index ba8e637..5ce40ec 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -195,6 +195,9 @@ struct virtnet_info {
>>>    	/* # of XDP queue pairs currently used by the driver */
>>>    	u16 xdp_queue_pairs;
>>>
>>> +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
>>> +	bool xdp_enabled;
>>> +
>>>    	/* I like... big packets and I cannot lie! */
>>>    	bool big_packets;
>>>
>>> @@ -481,12 +484,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>>>    	return 0;
>>>    }
>>>
>>> -static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
>>> -{
>>> -	unsigned int qp;
>>> -
>>> -	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
>>> -	return &vi->sq[qp];
>>> +/* when vi->curr_queue_pairs > nr_cpu_ids, the txq/sq is only used for xdp tx on
>>> + * the current cpu, so it does not need to be locked.
>>> + */
>>> +#define virtnet_xdp_get_sq(vi) ({                                         \
>>> +	struct netdev_queue *txq;                                         \
>>> +	typeof(vi) v = (vi);                                              \
>>
>> Any reason for not using vi directly?
>>
>> Other looks good.
>>
>> Thanks
> Using vi directly, I got an error by checkpatch.pl:
>
> 	Macro argument reuse 'vi' - possible side-effects
>
> more info: https://gcc.gnu.org/onlinedocs/cpp/Duplication-of-Side-Effects.html
>
> Thanks.


Ok.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>
>>
>>> +	unsigned int qp;                                                  \
>>> +	if (v->curr_queue_pairs > nr_cpu_ids) {                           \
>>> +		qp = v->curr_queue_pairs - v->xdp_queue_pairs;            \
>>> +		qp += smp_processor_id();                                 \
>>> +		txq = netdev_get_tx_queue(v->dev, qp);                    \
>>> +		__netif_tx_acquire(txq);                                  \
>>> +	} else {                                                          \
>>> +		qp = smp_processor_id() % v->curr_queue_pairs;            \
>>> +		txq = netdev_get_tx_queue(v->dev, qp);                    \
>>> +		__netif_tx_lock(txq, raw_smp_processor_id());             \
>>> +	}                                                                 \
>>> +	v->sq + qp;                                                       \
>>> +})
>>> +
>>> +#define virtnet_xdp_put_sq(vi, q) {                                       \
>>> +	struct netdev_queue *txq;                                         \
>>> +	typeof(vi) v = (vi);                                              \
>>> +	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                   \
>>> +	if (v->curr_queue_pairs > nr_cpu_ids)                             \
>>> +		__netif_tx_release(txq);                                  \
>>> +	else                                                              \
>>> +		__netif_tx_unlock(txq);                                   \
>>>    }
>>>
>>>    static int virtnet_xdp_xmit(struct net_device *dev,
>>> @@ -512,7 +537,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>>>    	if (!xdp_prog)
>>>    		return -ENXIO;
>>>
>>> -	sq = virtnet_xdp_sq(vi);
>>> +	sq = virtnet_xdp_get_sq(vi);
>>>
>>>    	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>>>    		ret = -EINVAL;
>>> @@ -560,12 +585,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>>>    	sq->stats.kicks += kicks;
>>>    	u64_stats_update_end(&sq->stats.syncp);
>>>
>>> +	virtnet_xdp_put_sq(vi, sq);
>>>    	return ret;
>>>    }
>>>
>>>    static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>>>    {
>>> -	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
>>> +	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
>>>    }
>>>
>>>    /* We copy the packet for XDP in the following cases:
>>> @@ -1457,12 +1483,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>>    		xdp_do_flush();
>>>
>>>    	if (xdp_xmit & VIRTIO_XDP_TX) {
>>> -		sq = virtnet_xdp_sq(vi);
>>> +		sq = virtnet_xdp_get_sq(vi);
>>>    		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
>>>    			u64_stats_update_begin(&sq->stats.syncp);
>>>    			sq->stats.kicks++;
>>>    			u64_stats_update_end(&sq->stats.syncp);
>>>    		}
>>> +		virtnet_xdp_put_sq(vi, sq);
>>>    	}
>>>
>>>    	return received;
>>> @@ -2417,10 +2444,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>>
>>>    	/* XDP requires extra queues for XDP_TX */
>>>    	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
>>> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
>>> -		netdev_warn(dev, "request %i queues but max is %i\n",
>>> +		netdev_warn(dev, "XDP request %i queues but max is %i. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.\n",
>>>    			    curr_qp + xdp_qp, vi->max_queue_pairs);
>>> -		return -ENOMEM;
>>> +		xdp_qp = 0;
>>>    	}
>>>
>>>    	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
>>> @@ -2454,11 +2480,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>>    	vi->xdp_queue_pairs = xdp_qp;
>>>
>>>    	if (prog) {
>>> +		vi->xdp_enabled = true;
>>>    		for (i = 0; i < vi->max_queue_pairs; i++) {
>>>    			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
>>>    			if (i == 0 && !old_prog)
>>>    				virtnet_clear_guest_offloads(vi);
>>>    		}
>>> +	} else {
>>> +		vi->xdp_enabled = false;
>>>    	}
>>>
>>>    	for (i = 0; i < vi->max_queue_pairs; i++) {
>>> @@ -2526,7 +2555,7 @@ static int virtnet_set_features(struct net_device *dev,
>>>    	int err;
>>>
>>>    	if ((dev->features ^ features) & NETIF_F_LRO) {
>>> -		if (vi->xdp_queue_pairs)
>>> +		if (vi->xdp_enabled)
>>>    			return -EBUSY;
>>>
>>>    		if (features & NETIF_F_LRO)
>>> --
>>> 1.8.3.1
>>>

