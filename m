Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7223FD527B
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfJLUli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbfJLUli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 16:41:38 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94944C054907
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 20:41:37 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id i10so6299001wrb.20
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZaFkxctsbibUFj6Bxd+GJuTId3Jtu6GLUhdMt1F3Wo=;
        b=XT2THUp13xa5wWItD3me+ujZKr/tGfJG2zlZ6RxvE+qPSqnA7Bh0hETLhV4eQu4+Xf
         9f1Lg1UmjS9dNl9b0+fjYTTrk7A0MlOsrOa7PT0rSWnqt7Itrjqdj+xbgw4zX5K4OMor
         ovdlUtsbc/LHZQuEfe/N8CTs7DWWHuS++H7XX5WnPGPVajE7xddjrdfhirQK5O/0WqVf
         ae9aw/w+utCfN9okPy37iWcieNLczQHZ9ZQqvNhTSHuSNjuz6PuG6JkghMRYbs3w9vmm
         WZD68A4RAOdkzA/wCA/913s3TrAf2dm8CG21B+mEvYmFHygR8SAJDTkn1uXKTy2+MSOo
         RLsQ==
X-Gm-Message-State: APjAAAU2LnZL74bS5dJG+EBGyqhO9TbZwa6cQ+p1mavEgiMWDHL3TASa
        28lUZNUhXnEBLuCVdA6QOoFksFz8od3SDjAMVWUsAL1MpX/sguow7QMBj/rBnatYbqwRqNGmElf
        ZAK8SI334Dzaj3EkJ
X-Received: by 2002:adf:8123:: with SMTP id 32mr19539075wrm.300.1570912896272;
        Sat, 12 Oct 2019 13:41:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx/hxD3KXTjJMl1Pw2GVerYimRvfAMTY7X+pjGBb9FOLN0joa/A5jXnMGxtXzxdKd0aKlEjnw==
X-Received: by 2002:adf:8123:: with SMTP id 32mr19539067wrm.300.1570912896036;
        Sat, 12 Oct 2019 13:41:36 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id q22sm10966643wmj.5.2019.10.12.13.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 13:41:35 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:41:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     prashantbhole.linux@gmail.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] vhost_net: user tap recvmsg api to access
 ptr ring
Message-ID: <20191012164059-mutt-send-email-mst@kernel.org>
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
 <20191012015357.1775-3-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012015357.1775-3-prashantbhole.linux@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 10:53:56AM +0900, prashantbhole.linux@gmail.com wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
> 
> Currently vhost_net directly accesses ptr ring of tap driver to
> fetch Rx packet pointers. In order to avoid it this patch modifies
> tap driver's recvmsg api to do additional task of fetching Rx packet
> pointers.
> 
> A special struct tun_msg_ctl is already being usedd via msg_control
> for tun Rx XDP batching. This patch extends tun_msg_ctl usage to
> send sub commands to recvmsg api. recvmsg can now produce/unproduce
> pointers from ptr ring as an additional task.
> 
> This will be useful in future in implementation of virtio-net XDP
> offload feature. Where packets will be XDP batch processed in
> tun_recvmsg.

I'd like to see that future patch, by itself this patchset
seems to be of limited usefulness.

> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  drivers/net/tap.c      | 22 +++++++++++++++++++-
>  drivers/net/tun.c      | 24 +++++++++++++++++++++-
>  drivers/vhost/net.c    | 46 +++++++++++++++++++++++++++++++++---------
>  include/linux/if_tun.h |  3 +++
>  4 files changed, 83 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 01bd260ce60c..3d0bf382dbbc 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1234,8 +1234,28 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
>  		       size_t total_len, int flags)
>  {
>  	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
> -	struct sk_buff *skb = m->msg_control;
> +	struct tun_msg_ctl *ctl = m->msg_control;
> +	struct sk_buff *skb = NULL;
>  	int ret;
> +
> +	if (ctl) {
> +		switch (ctl->cmd) {
> +		case TUN_CMD_PACKET:
> +			skb = ctl->ptr;
> +			break;
> +		case TUN_CMD_PRODUCE_PTRS:
> +			return ptr_ring_consume_batched(&q->ring,
> +							ctl->ptr_array,
> +							ctl->num);
> +		case TUN_CMD_UNPRODUCE_PTRS:
> +			ptr_ring_unconsume(&q->ring, ctl->ptr_array, ctl->num,
> +					   tun_ptr_free);
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
>  	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
>  		kfree_skb(skb);
>  		return -EINVAL;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 29711671959b..7d4886f53389 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2577,7 +2577,8 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>  {
>  	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
>  	struct tun_struct *tun = tun_get(tfile);
> -	void *ptr = m->msg_control;
> +	struct tun_msg_ctl *ctl = m->msg_control;
> +	void *ptr = NULL;
>  	int ret;
>  
>  	if (!tun) {
> @@ -2585,6 +2586,27 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>  		goto out_free;
>  	}
>  
> +	if (ctl) {
> +		switch (ctl->cmd) {
> +		case TUN_CMD_PACKET:
> +			ptr = ctl->ptr;
> +			break;
> +		case TUN_CMD_PRODUCE_PTRS:
> +			ret = ptr_ring_consume_batched(&tfile->tx_ring,
> +						       ctl->ptr_array,
> +						       ctl->num);
> +			goto out;
> +		case TUN_CMD_UNPRODUCE_PTRS:
> +			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr_array,
> +					   ctl->num, tun_ptr_free);
> +			ret = 0;
> +			goto out;
> +		default:
> +			ret = -EINVAL;
> +			goto out_put_tun;
> +		}
> +	}
> +
>  	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC|MSG_ERRQUEUE)) {
>  		ret = -EINVAL;
>  		goto out_put_tun;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 5946d2775bd0..5e5c1063606c 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -175,24 +175,44 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>  
>  static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
>  {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	struct socket *sock = vq->private_data;
>  	struct vhost_net_buf *rxq = &nvq->rxq;
> +	struct tun_msg_ctl ctl = {
> +		.cmd = TUN_CMD_PRODUCE_PTRS,
> +		.ptr_array = rxq->queue,
> +		.num = VHOST_NET_BATCH,
> +	};
> +	struct msghdr msg = {
> +		.msg_control = &ctl,
> +	};
>  
>  	rxq->head = 0;
> -	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
> -					      VHOST_NET_BATCH);
> +	rxq->tail = sock->ops->recvmsg(sock, &msg, 0, 0);
> +	if (rxq->tail < 0)
> +		rxq->tail = 0;
> +
>  	return rxq->tail;
>  }
>  
>  static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
>  {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	struct socket *sock = vq->private_data;
>  	struct vhost_net_buf *rxq = &nvq->rxq;
> +	struct tun_msg_ctl ctl = {
> +		.cmd = TUN_CMD_UNPRODUCE_PTRS,
> +		.ptr_array = rxq->queue + rxq->head,
> +		.num = vhost_net_buf_get_size(rxq),
> +	};
> +	struct msghdr msg = {
> +		.msg_control = &ctl,
> +	};
>  
> -	if (nvq->rx_ring && !vhost_net_buf_is_empty(rxq)) {
> -		ptr_ring_unconsume(nvq->rx_ring, rxq->queue + rxq->head,
> -				   vhost_net_buf_get_size(rxq),
> -				   tun_ptr_free);
> -		rxq->head = rxq->tail = 0;
> -	}
> +	if (!vhost_net_buf_is_empty(rxq))
> +		sock->ops->recvmsg(sock, &msg, 0, 0);
> +
> +	rxq->head = rxq->tail = 0;
>  }
>  
>  static int vhost_net_buf_peek_len(void *ptr)
> @@ -1109,6 +1129,9 @@ static void handle_rx(struct vhost_net *net)
>  		.flags = 0,
>  		.gso_type = VIRTIO_NET_HDR_GSO_NONE
>  	};
> +	struct tun_msg_ctl ctl = {
> +		.cmd = TUN_CMD_PACKET,
> +	};
>  	size_t total_len = 0;
>  	int err, mergeable;
>  	s16 headcount;
> @@ -1166,8 +1189,11 @@ static void handle_rx(struct vhost_net *net)
>  			goto out;
>  		}
>  		busyloop_intr = false;
> -		if (nvq->rx_ring)
> -			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
> +		if (nvq->rx_ring) {
> +			ctl.cmd = TUN_CMD_PACKET;
> +			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
> +			msg.msg_control = &ctl;
> +		}
>  		/* On overrun, truncate and discard */
>  		if (unlikely(headcount > UIO_MAXIOV)) {
>  			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> index bdfa671612db..8608d4095143 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -13,10 +13,13 @@
>  
>  #define TUN_CMD_PACKET 1
>  #define TUN_CMD_BATCH  2
> +#define TUN_CMD_PRODUCE_PTRS	3
> +#define TUN_CMD_UNPRODUCE_PTRS	4
>  struct tun_msg_ctl {
>  	unsigned short cmd;
>  	unsigned short num;
>  	void *ptr;
> +	void **ptr_array;
>  };
>  
>  struct tun_xdp_hdr {
> -- 
> 2.21.0
