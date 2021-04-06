Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90120354BBA
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 06:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbhDFE1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 00:27:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238031AbhDFE1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 00:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617683254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/AFYn8wyf126xH7Xvsc600hQ8aGmO5+JH2/S4X8qpE=;
        b=ShCWr1jmdsucDsVh0edDk8IkfZrnpyk8d2B3mg7QQp9EVZNhJ8K9Bd4Wm/z0pJ7f2VYvZH
        Ik4/r19ybQvKFzvl6SG0xddW969VbipAuBZkah5fW7KunaPqvuH1RGtvpVcpj7gcrWsyWg
        2oOApunxhy5xXSKGI0VI9P3EzdDQUcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240--WbY4wkKMN2I-VutlISTYg-1; Tue, 06 Apr 2021 00:27:30 -0400
X-MC-Unique: -WbY4wkKMN2I-VutlISTYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B7B835BD1;
        Tue,  6 Apr 2021 04:27:26 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD5906267C;
        Tue,  6 Apr 2021 04:27:16 +0000 (UTC)
Subject: Re: [PATCH net-next v3 3/8] virtio-net: xsk zero copy xmit setup
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
 <20210331071139.15473-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <97a147bc-f9b8-ce95-889d-274893fd0444@redhat.com>
Date:   Tue, 6 Apr 2021 12:27:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331071139.15473-4-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç3:11, Xuan Zhuo Ð´µÀ:
> xsk is a high-performance packet receiving and sending technology.
>
> This patch implements the binding and unbinding operations of xsk and
> the virtio-net queue for xsk zero copy xmit.
>
> The xsk zero copy xmit depends on tx napi. So if tx napi is not opened,
> an error will be reported. And the entire operation is under the
> protection of rtnl_lock
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 66 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 66 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb4ea9dbc16b..4e25408a2b37 100644
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
> +		struct xsk_buff_pool __rcu *pool;
> +	} xsk;
>   };
>   
>   /* Internal representation of a receive virtqueue */
> @@ -2526,11 +2532,71 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   	return err;
>   }
>   
> +static int virtnet_xsk_pool_enable(struct net_device *dev,
> +				   struct xsk_buff_pool *pool,
> +				   u16 qid)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct send_queue *sq;
> +	int ret = -EBUSY;


I'd rather move this under the check of xsk.pool.


> +
> +	if (qid >= vi->curr_queue_pairs)
> +		return -EINVAL;
> +
> +	sq = &vi->sq[qid];
> +
> +	/* xsk zerocopy depend on the tx napi */


Need more comments to explain why tx NAPI is required here.

And what's more important, tx NAPI could be enabled/disable via ethtool, 
what if the NAPI is disabled after xsk is enabled?


> +	if (!sq->napi.weight)
> +		return -EPERM;
> +
> +	rcu_read_lock();
> +	if (rcu_dereference(sq->xsk.pool))
> +		goto end;


Under what condition can we reach here?


> +
> +	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
> +	 * safe.
> +	 */
> +	rcu_assign_pointer(sq->xsk.pool, pool);
> +	ret = 0;
> +end:
> +	rcu_read_unlock();
> +
> +	return ret;
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
> +	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */


Since rtnl is held here, I guess it's better to use synchornize_net().


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
> +		/* virtio net not use dma before call vring api */
> +		xdp->xsk.check_dma = false;


I think it's better not open code things like this. How about introduce 
new parameters in xp_assign_dev()?


> +		if (xdp->xsk.pool)
> +			return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
> +						       xdp->xsk.queue_id);
> +		else
> +			return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
>   	default:
>   		return -EINVAL;
>   	}


Thanks

