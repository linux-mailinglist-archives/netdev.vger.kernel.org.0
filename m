Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01453354D3F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244124AbhDFHDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:03:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238199AbhDFHDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617692625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxo6tmkvBefpqtp+AZkpyNAyaWzhV5s1Lu6jg16B4FI=;
        b=I5BSOlfpKGBjP7CgFDr42grBV/obxb9Y70vsOCKywLUJ5Qz8T2TOoxst18dCU38Uyn32tI
        eDigTqFDCvRHf6fcigV902uNPbS3ZCVhxZlItifpwOTK5NpbHNVkDqCd1LYhwQClX026sa
        FMiDSCAMni4D+tNxlOU4jeQN5j+9+N4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-wrmH6CO3NNCD7xUsJyGbYw-1; Tue, 06 Apr 2021 03:03:43 -0400
X-MC-Unique: wrmH6CO3NNCD7xUsJyGbYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 298171084D68;
        Tue,  6 Apr 2021 07:03:40 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-95.pek2.redhat.com [10.72.13.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF1195D6DC;
        Tue,  6 Apr 2021 07:03:30 +0000 (UTC)
Subject: Re: [PATCH net-next v3 7/8] virtio-net: poll tx call xsk zerocopy
 xmit
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
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
 <20210331071139.15473-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f8631a22-c51a-f5ee-7130-a3cadf1a8b25@redhat.com>
Date:   Tue, 6 Apr 2021 15:03:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331071139.15473-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç3:11, Xuan Zhuo Ð´µÀ:
> poll tx call virtnet_xsk_run, then the data in the xsk tx queue will be
> continuously consumed by napi.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>


I think we need squash this into patch 4, it looks more like a bug fix 
to me.


> ---
>   drivers/net/virtio_net.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d7e95f55478d..fac7d0020013 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -264,6 +264,9 @@ struct padded_vnet_hdr {
>   	char padding[4];
>   };
>   
> +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
> +			   int budget, bool in_napi);
> +
>   static bool is_xdp_frame(void *ptr)
>   {
>   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> @@ -1553,7 +1556,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	struct send_queue *sq = container_of(napi, struct send_queue, napi);
>   	struct virtnet_info *vi = sq->vq->vdev->priv;
>   	unsigned int index = vq2txq(sq->vq);
> +	struct xsk_buff_pool *pool;
>   	struct netdev_queue *txq;
> +	int work = 0;
>   
>   	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
>   		/* We don't need to enable cb for XDP */
> @@ -1563,15 +1568,24 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   
>   	txq = netdev_get_tx_queue(vi->dev, index);
>   	__netif_tx_lock(txq, raw_smp_processor_id());
> -	free_old_xmit_skbs(sq, true);
> +	rcu_read_lock();
> +	pool = rcu_dereference(sq->xsk.pool);
> +	if (pool) {
> +		work = virtnet_xsk_run(sq, pool, budget, true);
> +		rcu_read_unlock();
> +	} else {
> +		rcu_read_unlock();
> +		free_old_xmit_skbs(sq, true);
> +	}
>   	__netif_tx_unlock(txq);
>   
> -	virtqueue_napi_complete(napi, sq->vq, 0);
> +	if (work < budget)
> +		virtqueue_napi_complete(napi, sq->vq, 0);
>   
>   	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   		netif_tx_wake_queue(txq);
>   
> -	return 0;
> +	return work;


Need a separate patch to "fix" the budget returned by poll_tx here.

Thanks


>   }
>   
>   static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)

