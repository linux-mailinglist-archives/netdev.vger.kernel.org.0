Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E29688551
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjBBRYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjBBRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:24:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979265CD22
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675358644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zi7pe0UxkBtEbi7YCeZA5YzsyNiHTHBrH46k3JXR73E=;
        b=E6SWbTrv1dBA61Q3n5fH+f9eoCm0PJ0KCve2015J6hPlrK+eC8pDJc97RRJVFBXADYtAAZ
        JaaYcprcBasKUJmm1fqV0JALl7Pvk8hwEUmUpckCr/T2p2Gh5jR3YjXI193Mi0MGfO4rNo
        ioM1mJAz0ZS1aFgqYJpdlc2Aea+TkpY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-158-lQvQcWKnOMCT033EL-ijnw-1; Thu, 02 Feb 2023 12:24:03 -0500
X-MC-Unique: lQvQcWKnOMCT033EL-ijnw-1
Received: by mail-wm1-f70.google.com with SMTP id h2-20020a1ccc02000000b003db1ded176dso1269416wmb.5
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 09:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zi7pe0UxkBtEbi7YCeZA5YzsyNiHTHBrH46k3JXR73E=;
        b=mJ2OKQ/nleX/PO8Ed6XU+Ud3E2AAXVFXlBxvkKr0giZ4sViFmRHRA9I3Y27U3KqqiY
         NZ9NDAxMMv8FGf68F5yeBF9WTCrogEvGX4zi7rfDvI6RPpS291Er5zZMt/61sziNATJ4
         Z9z0ynsvJCXt/KHK1RbetsGbYfnTSzfeNii7yPAt0cu7BsmEwkYyNUJw7RY9Rs5+VZEj
         lb40nOE10MTT42Zv7hlzgJ9kLOgsaIKlJFrSrGQBbLXOdCz1L/94Qmyf66ecdnYOMqZV
         nakWQ727/q8bN7SqE+rcVSiBFjYBn3pemmNuZF5dmME49L+Wp7ODeZX1wxEGFITPqaL4
         n5Vg==
X-Gm-Message-State: AO0yUKXIaxBHURkdTz+CO8MRiQkLZyCH2B1f1pMcjfcy97KRpb4/Ky02
        Auym9iJeDzKWCl3z2UhXKAYePMTk9hgEONXDM9EVyFrn991Y5cn3dIGKTr0tuvPenIbZxQXKABC
        nfM9/rUNOU5zv+wJk
X-Received: by 2002:a05:600c:3c9b:b0:3dc:46e8:982 with SMTP id bg27-20020a05600c3c9b00b003dc46e80982mr6465498wmb.19.1675358642282;
        Thu, 02 Feb 2023 09:24:02 -0800 (PST)
X-Google-Smtp-Source: AK7set+SWaayznR+KdR4VtGrVFlQFcvR61IRH4Fc/O+4J8EkSdt36bLQbXIq6MZx64YFcR2JlMxuJA==
X-Received: by 2002:a05:600c:3c9b:b0:3dc:46e8:982 with SMTP id bg27-20020a05600c3c9b00b003dc46e80982mr6465465wmb.19.1675358642098;
        Thu, 02 Feb 2023 09:24:02 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id c18-20020a7bc012000000b003d1e3b1624dsm5423336wmb.2.2023.02.02.09.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 09:24:01 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:23:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 19/33] virtio_net: introduce virtnet_tx_reset()
Message-ID: <20230202121745-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-20-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-20-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:44PM +0800, Xuan Zhuo wrote:
> Introduce virtnet_tx_reset() to release the buffers inside virtio ring.
> 
> This is needed for xsk disable. When disable xsk, we need to relese the

typo

> buffer from xsk, so this function is needed.
> 
> This patch reuse the virtnet_tx_resize.

reuses

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


> ---
>  drivers/net/virtio/main.c       | 21 ++++++++++++++++++---
>  drivers/net/virtio/virtio_net.h |  1 +
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index fb82035a0b7f..049a3bb9d88d 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -1806,8 +1806,8 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
>  	return err;
>  }
>  
> -static int virtnet_tx_resize(struct virtnet_info *vi,
> -			     struct send_queue *sq, u32 ring_num)
> +static int __virtnet_tx_reset(struct virtnet_info *vi,
> +			      struct send_queue *sq, u32 ring_num)
>  {
>  	bool running = netif_running(vi->dev);
>  	struct netdev_queue *txq;
> @@ -1833,7 +1833,11 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
>  
>  	__netif_tx_unlock_bh(txq);
>  
> -	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> +	if (ring_num)
> +		err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> +	else
> +		err = virtqueue_reset(sq->vq, virtnet_sq_free_unused_buf);
> +
>  	if (err)
>  		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
>

This __virtnet_tx_reset is a really weird API.

Suggest just splitting the common parts:

__virtnet_tx_pause
__virtnet_tx_resume

we can then implement virtnet_tx_resize and virtnet_tx_reset
using these two.

  
> @@ -1847,6 +1851,17 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
>  	return err;
>  }
>  
> +static int virtnet_tx_resize(struct virtnet_info *vi,
> +			     struct send_queue *sq, u32 ring_num)
> +{
> +	return __virtnet_tx_reset(vi, sq, ring_num);
> +}
> +
> +int virtnet_tx_reset(struct virtnet_info *vi, struct send_queue *sq)
> +{
> +	return __virtnet_tx_reset(vi, sq, 0);
> +}
> +
>  /*
>   * Send command via the control virtqueue and check status.  Commands
>   * supported by the hypervisor, as indicated by feature bits, should
> diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> index af3e7e817f9e..b46f083a630a 100644
> --- a/drivers/net/virtio/virtio_net.h
> +++ b/drivers/net/virtio/virtio_net.h
> @@ -273,4 +273,5 @@ int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  			struct net_device *dev,
>  			unsigned int *xdp_xmit,
>  			struct virtnet_rq_stats *stats);
> +int virtnet_tx_reset(struct virtnet_info *vi, struct send_queue *sq);
>  #endif
> -- 
> 2.32.0.3.g01195cf9f

