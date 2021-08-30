Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84613FBDF2
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhH3VLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237201AbhH3VLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630357820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+618f6pIQ7QqyteZqRd+k8qoLUdo13s2E6E3MFo9/Y=;
        b=NBR8UifYubAHdJHB6EXmwlNxVjMKQkQZHD9XJ4wYjvp0rHMxjAfTQAP+yKJxE8Kef9PY0b
        8GCuFiWuzaNiheprjcJtK9VlQ/5X/JVkmc0cRFo9DLZIOa0UOOKY6BAo2A6IldcOsNYMP9
        plvRgjplpqeNTciVM+R113TksoBGH2w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-p0Wv7SZjOrilJ3S04gPY3A-1; Mon, 30 Aug 2021 17:10:19 -0400
X-MC-Unique: p0Wv7SZjOrilJ3S04gPY3A-1
Received: by mail-wr1-f71.google.com with SMTP id r11-20020a5d4e4b000000b001575c5ed4b4so3558337wrt.4
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H+618f6pIQ7QqyteZqRd+k8qoLUdo13s2E6E3MFo9/Y=;
        b=qRPKWihMi6+byFwErBAXQAP5zb4mjE3uYhAu57zi2rWHYaXq6DBdhSQZ3V3u7WDUPA
         Wi/s3d2xeHxdDZg4TvpbwTXtNDKvuwgW1C8OktaX9NY87DeETwe0w9DpI89xPUSuZ9ly
         es5HoZW7ub40Tf5TzIEplY0S+HenXbgHuU4Ms182kAlWBQcPNYM+A6kwggN1UIhjQFqJ
         WHsuXujAaodd7xc+pwjfHkVu64tEu/MVpfa/C8J6Sesk4zP9EeY7B3RAgL7RLlj8I6EA
         6kmvNYAIPtNFk9+/LUtWhNIH0Bj4sQ1lR2h5lTirLf70+QdTLNJ4m+HwXiaW1zfPWgB/
         uJzQ==
X-Gm-Message-State: AOAM532sWKgjbm2/Ch0mtHHEFRAh1oQ80BokydQxH0/iEqJ84+XqXR2t
        dz20p3CaZb0ndFAn982+LK0OF1UYaeCTlwqXpk9OS1oWvnVBYs3FB6XbeGJS3pd0Bh9e4krwIhP
        BrCDp5CmiXo/erYzQ
X-Received: by 2002:a1c:f414:: with SMTP id z20mr933899wma.94.1630357817835;
        Mon, 30 Aug 2021 14:10:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCALB10bxh63E5WvwArTBCCDlGaCHtgsikTuncNYNnIlBrCWXTlsk5nCq4LlIE12ZJaPWdQQ==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr933890wma.94.1630357817655;
        Mon, 30 Aug 2021 14:10:17 -0700 (PDT)
Received: from redhat.com ([2.55.138.60])
        by smtp.gmail.com with ESMTPSA id g138sm601124wmg.34.2021.08.30.14.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:10:17 -0700 (PDT)
Date:   Mon, 30 Aug 2021 17:10:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: reduce raw_smp_processor_id() calling in
 virtnet_xdp_get_sq
Message-ID: <20210830170837-mutt-send-email-mst@kernel.org>
References: <1629966095-16341-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629966095-16341-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 04:21:35PM +0800, Li RongQing wrote:
> smp_processor_id()/raw* will be called once each when not
> more queues in virtnet_xdp_get_sq() which is called in
> non-preemptible context, so it's safe to call the function
> smp_processor_id() once.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

commit log should probably explain why it's a good idea
to replace raw_smp_processor_id with smp_processor_id
in the case of curr_queue_pairs <= nr_cpu_ids.

> ---
>  drivers/net/virtio_net.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2e42210a6503..2a7b368c1da2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -528,19 +528,20 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>   * functions to perfectly solve these three problems at the same time.
>   */
>  #define virtnet_xdp_get_sq(vi) ({                                       \
> +	int cpu = smp_processor_id();                                   \
>  	struct netdev_queue *txq;                                       \
>  	typeof(vi) v = (vi);                                            \
>  	unsigned int qp;                                                \
>  									\
>  	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
>  		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
> -		qp += smp_processor_id();                               \
> +		qp += cpu;                                              \
>  		txq = netdev_get_tx_queue(v->dev, qp);                  \
>  		__netif_tx_acquire(txq);                                \
>  	} else {                                                        \
> -		qp = smp_processor_id() % v->curr_queue_pairs;          \
> +		qp = cpu % v->curr_queue_pairs;                         \
>  		txq = netdev_get_tx_queue(v->dev, qp);                  \
> -		__netif_tx_lock(txq, raw_smp_processor_id());           \
> +		__netif_tx_lock(txq, cpu);                              \
>  	}                                                               \
>  	v->sq + qp;                                                     \
>  })
> -- 
> 2.33.0.69.gc420321.dirty
> 
> 

