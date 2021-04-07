Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4164D3567D1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350017AbhDGJQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:16:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231878AbhDGJQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617787001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gyj7IJkIUvUgggyzLzduzdDumbbdYLArWF7fFDCSWyE=;
        b=ZBuI8I6Swqxuo0iZTzbj+JAkJ6SsnW0SOcQ/dG5UnI+rrs8tn9hd/neAdUw6ujbxUTdcxB
        BfAMK3wgCSXY7VWae+gnvnlB9T2pZrXcrnw8F4vI2FyCa7QIBLrM/lvlbvj+fzFN94WISR
        Xd2uzwYY9JjPqUeroKy3K75B6bQsNvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-qUhOMZ4FPBGKHH9acOmwuQ-1; Wed, 07 Apr 2021 05:16:37 -0400
X-MC-Unique: qUhOMZ4FPBGKHH9acOmwuQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A607E1922967;
        Wed,  7 Apr 2021 09:16:35 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-236.pek2.redhat.com [10.72.13.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43F1E10023AF;
        Wed,  7 Apr 2021 09:16:27 +0000 (UTC)
Subject: Re: [PATCH net-next v3 7/8] virtio-net: poll tx call xsk zerocopy
 xmit
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
References: <1617786614.454336-5-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6dc46d13-7bdc-33d8-3bab-9cabd16d69d0@redhat.com>
Date:   Wed, 7 Apr 2021 17:16:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617786614.454336-5-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/7 下午5:10, Xuan Zhuo 写道:
> On Tue, 6 Apr 2021 15:03:29 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/3/31 下午3:11, Xuan Zhuo 写道:
>>> poll tx call virtnet_xsk_run, then the data in the xsk tx queue will be
>>> continuously consumed by napi.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>
>> I think we need squash this into patch 4, it looks more like a bug fix
>> to me.
>>
>>
>>> ---
>>>    drivers/net/virtio_net.c | 20 +++++++++++++++++---
>>>    1 file changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index d7e95f55478d..fac7d0020013 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -264,6 +264,9 @@ struct padded_vnet_hdr {
>>>    	char padding[4];
>>>    };
>>>
>>> +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
>>> +			   int budget, bool in_napi);
>>> +
>>>    static bool is_xdp_frame(void *ptr)
>>>    {
>>>    	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
>>> @@ -1553,7 +1556,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>    	struct send_queue *sq = container_of(napi, struct send_queue, napi);
>>>    	struct virtnet_info *vi = sq->vq->vdev->priv;
>>>    	unsigned int index = vq2txq(sq->vq);
>>> +	struct xsk_buff_pool *pool;
>>>    	struct netdev_queue *txq;
>>> +	int work = 0;
>>>
>>>    	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
>>>    		/* We don't need to enable cb for XDP */
>>> @@ -1563,15 +1568,24 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>
>>>    	txq = netdev_get_tx_queue(vi->dev, index);
>>>    	__netif_tx_lock(txq, raw_smp_processor_id());
>>> -	free_old_xmit_skbs(sq, true);
>>> +	rcu_read_lock();
>>> +	pool = rcu_dereference(sq->xsk.pool);
>>> +	if (pool) {
>>> +		work = virtnet_xsk_run(sq, pool, budget, true);
>>> +		rcu_read_unlock();
>>> +	} else {
>>> +		rcu_read_unlock();
>>> +		free_old_xmit_skbs(sq, true);
>>> +	}
>>>    	__netif_tx_unlock(txq);
>>>
>>> -	virtqueue_napi_complete(napi, sq->vq, 0);
>>> +	if (work < budget)
>>> +		virtqueue_napi_complete(napi, sq->vq, 0);
>>>
>>>    	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>>>    		netif_tx_wake_queue(txq);
>>>
>>> -	return 0;
>>> +	return work;
>>
>> Need a separate patch to "fix" the budget returned by poll_tx here.
> I will merge #5 #7 #8 into #4, which is indeed more reasonable, but maybe this
> patch will be too big.
>
> But I don't understand, what you are talking about here, what is the separate
> patch, when this is squashed into patch 4?


So you modify the behaviour of NAPI poll to return the number of work 
now (0 is returned previously). Do we need to do that for non XSK part 
as well (which seems to be the behaviour of other nic driver)? If yes, 
this part should be a separated patch to be more bisect friendly.

Thanks


>
>> Thanks
>>
>>
>>>    }
>>>
>>>    static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)

