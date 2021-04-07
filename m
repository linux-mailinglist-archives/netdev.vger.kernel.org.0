Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC85356789
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346018AbhDGJBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:01:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346096AbhDGJBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617786074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rkz4nKqmSi3Q6k0oz/hhB2XArXf+uraFndElilQ7l4Y=;
        b=KD+onLjAZxS/nW+aNR3SURgw4eoRN2hBYdHpCPzn/WaSsLPb3K/IiSjjhTJme6pFgMlpAp
        LyOqz185UEdINtCRpbdsr1c2tr/EXlwIExpjHC8K2h9sjxhC5s33ZQf8Tic31ewjyJw0WN
        9QgZQlVDyazMLxBwufht2OqO9Y6M5iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-qJLkybGIMl2vhBM809sq0g-1; Wed, 07 Apr 2021 05:01:10 -0400
X-MC-Unique: qJLkybGIMl2vhBM809sq0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D41B5B38D;
        Wed,  7 Apr 2021 09:01:08 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-236.pek2.redhat.com [10.72.13.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86135D762;
        Wed,  7 Apr 2021 09:00:57 +0000 (UTC)
Subject: Re: [PATCH net-next v3 3/8] virtio-net: xsk zero copy xmit setup
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
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>, netdev@vger.kernel.org
References: <1617780476.5300975-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <67f0091a-e065-9183-04a0-4722e1fff84f@redhat.com>
Date:   Wed, 7 Apr 2021 17:00:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617780476.5300975-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/7 下午3:27, Xuan Zhuo 写道:
> On Tue, 6 Apr 2021 12:27:14 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/3/31 下午3:11, Xuan Zhuo 写道:
>>> xsk is a high-performance packet receiving and sending technology.
>>>
>>> This patch implements the binding and unbinding operations of xsk and
>>> the virtio-net queue for xsk zero copy xmit.
>>>
>>> The xsk zero copy xmit depends on tx napi. So if tx napi is not opened,
>>> an error will be reported. And the entire operation is under the
>>> protection of rtnl_lock
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>> ---
>>>    drivers/net/virtio_net.c | 66 ++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 66 insertions(+)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index bb4ea9dbc16b..4e25408a2b37 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -22,6 +22,7 @@
>>>    #include <net/route.h>
>>>    #include <net/xdp.h>
>>>    #include <net/net_failover.h>
>>> +#include <net/xdp_sock_drv.h>
>>>
>>>    static int napi_weight = NAPI_POLL_WEIGHT;
>>>    module_param(napi_weight, int, 0444);
>>> @@ -133,6 +134,11 @@ struct send_queue {
>>>    	struct virtnet_sq_stats stats;
>>>
>>>    	struct napi_struct napi;
>>> +
>>> +	struct {
>>> +		/* xsk pool */
>>> +		struct xsk_buff_pool __rcu *pool;
>>> +	} xsk;
>>>    };
>>>
>>>    /* Internal representation of a receive virtqueue */
>>> @@ -2526,11 +2532,71 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>>>    	return err;
>>>    }
>>>
>>> +static int virtnet_xsk_pool_enable(struct net_device *dev,
>>> +				   struct xsk_buff_pool *pool,
>>> +				   u16 qid)
>>> +{
>>> +	struct virtnet_info *vi = netdev_priv(dev);
>>> +	struct send_queue *sq;
>>> +	int ret = -EBUSY;
>>
>> I'd rather move this under the check of xsk.pool.
>>
>>
>>> +
>>> +	if (qid >= vi->curr_queue_pairs)
>>> +		return -EINVAL;
>>> +
>>> +	sq = &vi->sq[qid];
>>> +
>>> +	/* xsk zerocopy depend on the tx napi */
>>
>> Need more comments to explain why tx NAPI is required here.
>>
>> And what's more important, tx NAPI could be enabled/disable via ethtool,
>> what if the NAPI is disabled after xsk is enabled?
>>
> If napi_tx is turned off, then the xmit will be affected.


Please document what kind of effect that prevents xsk from working.


> Maybe I
> should restrict that tx NAPI be disable via ethtool after xsk is enabled.


It can work.


>
>>> +	if (!sq->napi.weight)
>>> +		return -EPERM;
>>> +
>>> +	rcu_read_lock();
>>> +	if (rcu_dereference(sq->xsk.pool))
>>> +		goto end;
>>
>> Under what condition can we reach here?
> When the user tries to bind repeatedly.


Ok, I am a little suprised that it was not checked by xsk_bind().



>
>>
>>> +
>>> +	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
>>> +	 * safe.
>>> +	 */
>>> +	rcu_assign_pointer(sq->xsk.pool, pool);
>>> +	ret = 0;
>>> +end:
>>> +	rcu_read_unlock();
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
>>> +{
>>> +	struct virtnet_info *vi = netdev_priv(dev);
>>> +	struct send_queue *sq;
>>> +
>>> +	if (qid >= vi->curr_queue_pairs)
>>> +		return -EINVAL;
>>> +
>>> +	sq = &vi->sq[qid];
>>> +
>>> +	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
>>> +	 * safe.
>>> +	 */
>>> +	rcu_assign_pointer(sq->xsk.pool, NULL);
>>> +
>>> +	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
>>
>> Since rtnl is held here, I guess it's better to use synchornize_net().
>>
>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>    static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>>>    {
>>>    	switch (xdp->command) {
>>>    	case XDP_SETUP_PROG:
>>>    		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
>>> +	case XDP_SETUP_XSK_POOL:
>>> +		/* virtio net not use dma before call vring api */
>>> +		xdp->xsk.check_dma = false;
>>
>> I think it's better not open code things like this. How about introduce
>> new parameters in xp_assign_dev()?
> xp_assign_dev is called by the user, we should let xsk perceive that the current
> dev does not directly use dma. Is it possible to use dev->priv_flags? I only
> know that this is the case with virtio-net!!


Ok, then it should be fine, but we need a better name other than 
"check_dma". Maybe "use_dma_addr" instead.

Thanks


>
> Thanks very much.
>
>>
>>> +		if (xdp->xsk.pool)
>>> +			return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
>>> +						       xdp->xsk.queue_id);
>>> +		else
>>> +			return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
>>>    	default:
>>>    		return -EINVAL;
>>>    	}
>>
>> Thanks
>>

