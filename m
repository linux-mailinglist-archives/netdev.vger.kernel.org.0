Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857CD31E44D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBRCUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 21:20:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhBRCUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 21:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613614749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oEPKtTgrc4YzD3mfk0Ov5baKrhMLojrx5gD3FzHnF7c=;
        b=DX9aF+Xm2M/qaKrVac+P3ZsP7tIYpzf1tiItJgm5w4mXa8eCptS/+I7TpA4kLHXp+QvGB6
        wca2kFvFH8QQ64IFhDqUqoOmJYLGAfOuIXjeTaEeVrxsArBefKdiUiS+QyT0q61H/FOi7x
        olZ4bJqYrbX8fy+tLkRENoF9qusocQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-w1bAZqm7MIifojaTZnr1uQ-1; Wed, 17 Feb 2021 21:19:07 -0500
X-MC-Unique: w1bAZqm7MIifojaTZnr1uQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48C4318A08C0;
        Thu, 18 Feb 2021 02:19:05 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-162.pek2.redhat.com [10.72.13.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC80F19C46;
        Thu, 18 Feb 2021 02:18:57 +0000 (UTC)
Subject: Re: [PATCH netdev] virtio-net: support XDP_TX when not more queues
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        dust.li@linux.alibaba.com
References: <81abae33fc8dbec37ef0061ff6f6fd696b484a3e.1610523188.git.xuanzhuo@linux.alibaba.com>
 <20210210163945-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bbd43240-c677-da41-8e6f-6a1550c220a8@redhat.com>
Date:   Thu, 18 Feb 2021 10:18:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210163945-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/11 5:40 上午, Michael S. Tsirkin wrote:
> On Wed, Jan 13, 2021 at 04:08:57PM +0800, Xuan Zhuo wrote:
>> The number of queues implemented by many virtio backends is limited,
>> especially some machines have a large number of CPUs. In this case, it
>> is often impossible to allocate a separate queue for XDP_TX.
>>
>> This patch allows XDP_TX to run by reuse the existing SQ with
>> __netif_tx_lock() hold when there are not enough queues.
>>
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> I'd like to get some advice on whether this is ok from some
> XDP experts - previously my understanding was that it is
> preferable to disable XDP for such devices than
> use locks on XDP fast path.


I think this is acceptable on the device that changing the number of 
queues is not easy. For virtio-net, it probably requires a lot of 
changes in the management.

Another example is TUN which use TX lock for XDP.

Thanks


>
>> ---
>>   drivers/net/virtio_net.c | 47 +++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 35 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index ba8e637..7a3b2a7 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -195,6 +195,9 @@ struct virtnet_info {
>>   	/* # of XDP queue pairs currently used by the driver */
>>   	u16 xdp_queue_pairs;
>>   
>> +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
>> +	bool xdp_enabled;
>> +
>>   	/* I like... big packets and I cannot lie! */
>>   	bool big_packets;
>>   
>> @@ -481,14 +484,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>>   	return 0;
>>   }
>>   
>> -static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
>> +static struct send_queue *virtnet_get_xdp_sq(struct virtnet_info *vi)
>>   {
>>   	unsigned int qp;
>> +	struct netdev_queue *txq;
>> +
>> +	if (vi->curr_queue_pairs > nr_cpu_ids) {
>> +		qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
>> +	} else {
>> +		qp = smp_processor_id() % vi->curr_queue_pairs;
>> +		txq = netdev_get_tx_queue(vi->dev, qp);
>> +		__netif_tx_lock(txq, raw_smp_processor_id());
>> +	}
>>   
>> -	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
>>   	return &vi->sq[qp];
>>   }
>>   
>> +static void virtnet_put_xdp_sq(struct virtnet_info *vi)
>> +{
>> +	unsigned int qp;
>> +	struct netdev_queue *txq;
>> +
>> +	if (vi->curr_queue_pairs <= nr_cpu_ids) {
>> +		qp = smp_processor_id() % vi->curr_queue_pairs;
>> +		txq = netdev_get_tx_queue(vi->dev, qp);
>> +		__netif_tx_unlock(txq);
>> +	}
>> +}
>> +
>>   static int virtnet_xdp_xmit(struct net_device *dev,
>>   			    int n, struct xdp_frame **frames, u32 flags)
>>   {
>> @@ -512,7 +535,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>>   	if (!xdp_prog)
>>   		return -ENXIO;
>>   
>> -	sq = virtnet_xdp_sq(vi);
>> +	sq = virtnet_get_xdp_sq(vi);
>>   
>>   	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>>   		ret = -EINVAL;
>> @@ -560,12 +583,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>>   	sq->stats.kicks += kicks;
>>   	u64_stats_update_end(&sq->stats.syncp);
>>   
>> +	virtnet_put_xdp_sq(vi);
>>   	return ret;
>>   }
>>   
>>   static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>>   {
>> -	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
>> +	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
>>   }
>>   
>>   /* We copy the packet for XDP in the following cases:
>> @@ -1457,12 +1481,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>   		xdp_do_flush();
>>   
>>   	if (xdp_xmit & VIRTIO_XDP_TX) {
>> -		sq = virtnet_xdp_sq(vi);
>> +		sq = virtnet_get_xdp_sq(vi);
>>   		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
>>   			u64_stats_update_begin(&sq->stats.syncp);
>>   			sq->stats.kicks++;
>>   			u64_stats_update_end(&sq->stats.syncp);
>>   		}
>> +		virtnet_put_xdp_sq(vi);
>>   	}
>>   
>>   	return received;
>> @@ -2416,12 +2441,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>   		xdp_qp = nr_cpu_ids;
>>   
>>   	/* XDP requires extra queues for XDP_TX */
>> -	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
>> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
>> -		netdev_warn(dev, "request %i queues but max is %i\n",
>> -			    curr_qp + xdp_qp, vi->max_queue_pairs);
>> -		return -ENOMEM;
>> -	}
>> +	if (curr_qp + xdp_qp > vi->max_queue_pairs)
>> +		xdp_qp = 0;
>>   
>>   	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
>>   	if (!prog && !old_prog)
>> @@ -2453,12 +2474,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>   	netif_set_real_num_rx_queues(dev, curr_qp + xdp_qp);
>>   	vi->xdp_queue_pairs = xdp_qp;
>>   
>> +	vi->xdp_enabled = false;
>>   	if (prog) {
>>   		for (i = 0; i < vi->max_queue_pairs; i++) {
>>   			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
>>   			if (i == 0 && !old_prog)
>>   				virtnet_clear_guest_offloads(vi);
>>   		}
>> +		vi->xdp_enabled = true;
>>   	}
>>   
>>   	for (i = 0; i < vi->max_queue_pairs; i++) {
>> @@ -2526,7 +2549,7 @@ static int virtnet_set_features(struct net_device *dev,
>>   	int err;
>>   
>>   	if ((dev->features ^ features) & NETIF_F_LRO) {
>> -		if (vi->xdp_queue_pairs)
>> +		if (vi->xdp_enabled)
>>   			return -EBUSY;
>>   
>>   		if (features & NETIF_F_LRO)
>> -- 
>> 1.8.3.1

