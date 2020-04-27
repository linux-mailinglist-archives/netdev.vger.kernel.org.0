Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A4F1B9842
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD0HVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:21:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31394 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbgD0HVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 03:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587972083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmrqhUr63ylUIBJ0HetA0W/F7e91Q2QoSF5xiRnj80k=;
        b=QDe4n2l4jFP5WfoLGMdrK6kRBoz1GvAIz/rk576H6kYtLcUWtT5l6kw49vQHT8/ZHDM1mi
        VXSy9tews6Pnc6tSDlbI1tjgXxqrso8pb6Nwf/GyD/5qCSqzw2zYoO9FgXC1LyuXZLUDzq
        OwNEClsIc+ZdRgG/y11GIQ01A7sJjAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-MYQl7MChPPyI20unIZ4TkQ-1; Mon, 27 Apr 2020 03:21:18 -0400
X-MC-Unique: MYQl7MChPPyI20unIZ4TkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2532C107ACF9;
        Mon, 27 Apr 2020 07:21:16 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82AF760CD3;
        Mon, 27 Apr 2020 07:21:04 +0000 (UTC)
Subject: Re: [PATCH net-next 21/33] virtio_net: add XDP frame size in two code
 paths
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757174774.1370371.14395462229209766397.stgit@firesoul>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3958d9c6-a7d1-6a3d-941d-0a2915cc6b09@redhat.com>
Date:   Mon, 27 Apr 2020 15:21:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757174774.1370371.14395462229209766397.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/23 =E4=B8=8A=E5=8D=8812:09, Jesper Dangaard Brouer wrote:
> The virtio_net driver is running inside the guest-OS. There are two
> XDP receive code-paths in virtio_net, namely receive_small() and
> receive_mergeable(). The receive_big() function does not support XDP.
>
> In receive_small() the frame size is available in buflen. The buffer
> backing these frames are allocated in add_recvbuf_small() with same
> size, except for the headroom, but tailroom have reserved room for
> skb_shared_info. The headroom is encoded in ctx pointer as a value.
>
> In receive_mergeable() the frame size is more dynamic. There are two
> basic cases: (1) buffer size is based on a exponentially weighted
> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
> virtnet_get_headroom() have any headroom then buffer size is
> PAGE_SIZE. The ctx pointer is this time used for encoding two values;
> the buffer len "truesize" and headroom. In case (1) if the rx buffer
> size is underestimated, the packet will have been split over more
> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
> buffer area). If that happens the XDP path does a xdp_linearize_page
> operation.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/virtio_net.c |   15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 11f722460513..1df3676da185 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -689,6 +689,7 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>   		xdp.data_end =3D xdp.data + len;
>   		xdp.data_meta =3D xdp.data;
>   		xdp.rxq =3D &rq->xdp_rxq;
> +		xdp.frame_sz =3D buflen;
>   		orig_data =3D xdp.data;
>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>   		stats->xdp_packets++;
> @@ -797,10 +798,11 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>   	int offset =3D buf - page_address(page);
>   	struct sk_buff *head_skb, *curr_skb;
>   	struct bpf_prog *xdp_prog;
> -	unsigned int truesize;
> +	unsigned int truesize =3D mergeable_ctx_to_truesize(ctx);
>   	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
> -	int err;
>   	unsigned int metasize =3D 0;
> +	unsigned int frame_sz;
> +	int err;
>  =20
>   	head_skb =3D NULL;
>   	stats->bytes +=3D len - vi->hdr_len;
> @@ -821,6 +823,11 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>   		if (unlikely(hdr->hdr.gso_type))
>   			goto err_xdp;
>  =20
> +		/* Buffers with headroom use PAGE_SIZE as alloc size,
> +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +		 */
> +		frame_sz =3D headroom ? PAGE_SIZE : truesize;
> +
>   		/* This happens when rx buffer size is underestimated
>   		 * or headroom is not enough because of the buffer
>   		 * was refilled before XDP is set. This should only
> @@ -834,6 +841,8 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   						      page, offset,
>   						      VIRTIO_XDP_HEADROOM,
>   						      &len);
> +			frame_sz =3D PAGE_SIZE;


Should this be PAGE_SIZE -=C2=A0 SKB_DATA_ALIGN(sizeof(struct skb_shared_=
info))?


> +
>   			if (!xdp_page)
>   				goto err_xdp;
>   			offset =3D VIRTIO_XDP_HEADROOM;
> @@ -850,6 +859,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
>   		xdp.data_meta =3D xdp.data;
>   		xdp.rxq =3D &rq->xdp_rxq;
> +		xdp.frame_sz =3D frame_sz;


Maybe we can easily check by

xdp.frame_sz =3D (xdp_page =3D=3D page) ? truesize : ...

Thanks


>  =20
>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>   		stats->xdp_packets++;
> @@ -924,7 +934,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   	}
>   	rcu_read_unlock();
>  =20
> -	truesize =3D mergeable_ctx_to_truesize(ctx);
>   	if (unlikely(len > truesize)) {
>   		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
>   			 dev->name, len, (unsigned long)ctx);
>
>

