Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD635EBA2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 06:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhDNEC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 00:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhDNEC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 00:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618372924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cb160dTeZzNNrUQErRypJRQxN1hzmXq4Crw0cmUCkUs=;
        b=gpK0qZiQ9M8s8y40iN/JfsZQ2VUCdlK6vbd0xPNUL+bw5yDZ2BK87PU7Fm5nu0dH1OHDCP
        DqUh6AZnRdBCOdLO//psJWvLcRQm7FDCLkTlGusBaXMQG56OEDG0CS+8dBMNKB2mvdKHGw
        lFkLDZVeUA1bpqsFo/FIkNYSExSDuj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-yOknOJ61Pvy4cwWns3ZXuA-1; Wed, 14 Apr 2021 00:01:58 -0400
X-MC-Unique: yOknOJ61Pvy4cwWns3ZXuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DFA5189C447;
        Wed, 14 Apr 2021 04:01:56 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9ACE5D6AC;
        Wed, 14 Apr 2021 04:01:48 +0000 (UTC)
Subject: Re: [PATCH net-next v4 08/10] virtio-net: xsk zero copy xmit setup
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
 <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ec6d7825-ddfb-ae7e-1105-fffd6afecfcb@redhat.com>
Date:   Wed, 14 Apr 2021 12:01:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÉÏÎç11:15, Xuan Zhuo Ð´µÀ:
> xsk is a high-performance packet receiving and sending technology.
>
> This patch implements the binding and unbinding operations of xsk and
> the virtio-net queue for xsk zero copy xmit.
>
> The xsk zero copy xmit depends on tx napi.


It's better to describe why zero copy depends on tx napi.


>   So if tx napi is not true,
> an error will be reported. And the entire operation is under the
> protection of rtnl_lock.
>
> If xsk is active, it will prevent ethtool from modifying tx napi.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 78 +++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 77 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f52a25091322..8242a9e9f17d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -22,6 +22,7 @@
>   #include <net/route.h>
>   #include <net/xdp.h>
>   #include <net/net_failover.h>
> +#include <net/xdp_sock_drv.h>
>   
>   static int napi_weight = NAPI_POLL_WEIGHT;
>   module_param(napi_weight, int, 0444);
> @@ -133,6 +134,11 @@ struct send_queue {
>   	struct virtnet_sq_stats stats;
>   
>   	struct napi_struct napi;
> +
> +	struct {
> +		/* xsk pool */


This comment is unnecessary since the code explains itself.


> +		struct xsk_buff_pool __rcu *pool;
> +	} xsk;
>   };
>   
>   /* Internal representation of a receive virtqueue */
> @@ -2249,8 +2255,19 @@ static int virtnet_set_coalesce(struct net_device *dev,
>   	if (napi_weight ^ vi->sq[0].napi.weight) {
>   		if (dev->flags & IFF_UP)
>   			return -EBUSY;
> -		for (i = 0; i < vi->max_queue_pairs; i++)
> +		for (i = 0; i < vi->max_queue_pairs; i++) {
> +			/* xsk xmit depend on the tx napi. So if xsk is active,
> +			 * prevent modifications to tx napi.
> +			 */
> +			rcu_read_lock();
> +			if (rcu_dereference(vi->sq[i].xsk.pool)) {


Let's use rtnl_derefernece() then the rcu_read_lock()/unlock() is not 
needed.


> +				rcu_read_unlock();
> +				continue;
> +			}
> +			rcu_read_unlock();
> +
>   			vi->sq[i].napi.weight = napi_weight;
> +		}
>   	}
>   
>   	return 0;
> @@ -2518,11 +2535,70 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   	return err;
>   }
>   
> +static int virtnet_xsk_pool_enable(struct net_device *dev,
> +				   struct xsk_buff_pool *pool,
> +				   u16 qid)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct send_queue *sq;
> +
> +	if (qid >= vi->curr_queue_pairs)
> +		return -EINVAL;
> +
> +	sq = &vi->sq[qid];
> +
> +	/* xsk zerocopy depend on the tx napi.
> +	 *
> +	 * xsk zerocopy xmit is driven by the tx interrupt. When the device is
> +	 * not busy, napi will be called continuously to send data. When the
> +	 * device is busy, wait for the notification interrupt after the
> +	 * hardware has finished processing the data, and continue to send data
> +	 * in napi.
> +	 */
> +	if (!sq->napi.weight)
> +		return -EPERM;
> +
> +	rcu_read_lock();
> +	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
> +	 * safe.
> +	 */
> +	rcu_assign_pointer(sq->xsk.pool, pool);
> +	rcu_read_unlock();


Any reason for the rcu lock here? And don't we need to synchronize rcu here?


> +
> +	return 0;
> +}
> +
> +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct send_queue *sq;
> +
> +	if (qid >= vi->curr_queue_pairs)
> +		return -EINVAL;
> +
> +	sq = &vi->sq[qid];
> +
> +	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
> +	 * safe.
> +	 */
> +	rcu_assign_pointer(sq->xsk.pool, NULL);
> +
> +	synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */


Let's move the comment above the code.

Thanks


> +
> +	return 0;
> +}
> +
>   static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>   {
>   	switch (xdp->command) {
>   	case XDP_SETUP_PROG:
>   		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
> +	case XDP_SETUP_XSK_POOL:
> +		if (xdp->xsk.pool)
> +			return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
> +						       xdp->xsk.queue_id);
> +		else
> +			return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
>   	default:
>   		return -EINVAL;
>   	}

