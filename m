Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0FA6892DA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBCI4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjBCI4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:56:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE1C1F5FC
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675414534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NTRIC3PmgkbexfvmdzDVVE1snyz3cb/Iuh5EyQX83nQ=;
        b=jPV6qUVRenyBcu0IiIvzUl+BrJ+CEyaXNxkZoaqFt0efOH9QI7Se1YZEOgFOh+J971i179
        aJjMSa2IVqU1PXk1Bqpd5DYWqcCGuAUzta/NlD5Y34tHrVq+1s+wPPO6acR+0WkpKgb3hK
        i2oka8Yg89wKjIHo/v9dG7rf/0B4o6A=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-pos-BbbhN1mJ6hX7p2EeZw-1; Fri, 03 Feb 2023 03:55:33 -0500
X-MC-Unique: pos-BbbhN1mJ6hX7p2EeZw-1
Received: by mail-ej1-f72.google.com with SMTP id p16-20020a170906499000b0088c5a527c89so3467860eju.23
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTRIC3PmgkbexfvmdzDVVE1snyz3cb/Iuh5EyQX83nQ=;
        b=4D/Uam8YoBgYIFx3RDRniWu8kFwXXTHZckR5aCUIHOjaX1Mj9micICw22MtXjOKp9H
         uNtRdRIXbWnb7mEYQ6eDk3e42gsKFp/4h6IIs07AtjHA3XUvgjTDRMYApKhzRvaQRfPp
         1YnCoWDgkkEBxRSVnT4wcclIJXNWCPWYZIJC04whGofkajAe/kha7THhwwOG/sqhtDC/
         TZItOuLjUaGHpwHF1bE0T5ZO0k2ocw8BJ5j+n3qDwKdKgRXs1Q92mu2vdzpznBA/cwhe
         x7Ya2mEGnMrUuUCvXh/R7WetVGG6eHzkXtfxieQahRLx8KdAfqhUrdki/eUd6H0Co8DU
         pj6Q==
X-Gm-Message-State: AO0yUKXqt9HpM1QUHo+IWywsqOSCvN3beeAnUKiNDKYCi+OH3AUq4F8g
        FEXAPD9U/ri9m3EbgmPbDKUnEiMmSrzojo6WuZvIGW336q6WGiOOwDVhi7dSz0QFDVyLumxoicF
        npj0vrer+3ur5mNGW
X-Received: by 2002:a05:6402:34cc:b0:4a0:e0a3:3adc with SMTP id w12-20020a05640234cc00b004a0e0a33adcmr9869170edc.7.1675414531908;
        Fri, 03 Feb 2023 00:55:31 -0800 (PST)
X-Google-Smtp-Source: AK7set+sA6ogVU1Whhi9IYFxyCPIOl3snDc0rUMN+CbivbyTZZKBNsts0SpPLVa3etlWkhkgN6ftWA==
X-Received: by 2002:a05:6402:34cc:b0:4a0:e0a3:3adc with SMTP id w12-20020a05640234cc00b004a0e0a33adcmr9869158edc.7.1675414531740;
        Fri, 03 Feb 2023 00:55:31 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id h40-20020a0564020ea800b004a245d70f17sm792571eda.54.2023.02.03.00.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:55:30 -0800 (PST)
Date:   Fri, 3 Feb 2023 03:55:26 -0500
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
Subject: Re: [PATCH 16/33] virtio_net: introduce virtnet_xdp_handler() to
 seprate the logic of run xdp
Message-ID: <20230203035416-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-17-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-17-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:41PM +0800, Xuan Zhuo wrote:
> At present, we have two long similar logic to perform XDP Progs. And in
> the implementation of XSK, we will have this need.
> 
> Therefore, this PATCH separates the code of executing XDP, which is
> conducive to later maintenance and facilitates subsequent XSK for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

So you first add a new function then move users over.
This means that it's hard during review to make sure
nothing is lost in translation.
Do the refactoring in a single patch instead.

> ---
>  drivers/net/virtio/main.c       | 53 +++++++++++++++++++++++++++++++++
>  drivers/net/virtio/virtio_net.h | 11 +++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index 5683cb576474..9d4b84b23ef7 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -478,6 +478,59 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	return ret;
>  }
>  
> +int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> +			struct net_device *dev,
> +			unsigned int *xdp_xmit,
> +			struct virtnet_rq_stats *stats)
> +{
> +	struct xdp_frame *xdpf;
> +	int err;
> +	u32 act;
> +
> +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> +	stats->xdp_packets++;
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return VIRTNET_XDP_RES_PASS;
> +
> +	case XDP_TX:
> +		stats->xdp_tx++;
> +		xdpf = xdp_convert_buff_to_frame(xdp);
> +		if (unlikely(!xdpf))
> +			return VIRTNET_XDP_RES_DROP;
> +
> +		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> +		if (unlikely(!err)) {
> +			xdp_return_frame_rx_napi(xdpf);
> +		} else if (unlikely(err < 0)) {
> +			trace_xdp_exception(dev, xdp_prog, act);
> +			return VIRTNET_XDP_RES_DROP;
> +		}
> +
> +		*xdp_xmit |= VIRTIO_XDP_TX;
> +		return VIRTNET_XDP_RES_CONSUMED;
> +
> +	case XDP_REDIRECT:
> +		stats->xdp_redirects++;
> +		err = xdp_do_redirect(dev, xdp, xdp_prog);
> +		if (err)
> +			return VIRTNET_XDP_RES_DROP;
> +
> +		*xdp_xmit |= VIRTIO_XDP_REDIR;
> +		return VIRTNET_XDP_RES_CONSUMED;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(dev, xdp_prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		return VIRTNET_XDP_RES_DROP;
> +	}
> +}
> +
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>  {
>  	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> index 8bf31429ae28..af3e7e817f9e 100644
> --- a/drivers/net/virtio/virtio_net.h
> +++ b/drivers/net/virtio/virtio_net.h
> @@ -22,6 +22,12 @@
>  #include <net/net_failover.h>
>  #include <net/xdp_sock_drv.h>
>  
> +enum {
> +	VIRTNET_XDP_RES_PASS,
> +	VIRTNET_XDP_RES_DROP,
> +	VIRTNET_XDP_RES_CONSUMED,
> +};
> +
>  #define VIRTIO_XDP_FLAG	BIT(0)
>  
>  struct virtnet_info {
> @@ -262,4 +268,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
>  		stats->packets++;
>  	}
>  }
> +
> +int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> +			struct net_device *dev,
> +			unsigned int *xdp_xmit,
> +			struct virtnet_rq_stats *stats);
>  #endif
> -- 
> 2.32.0.3.g01195cf9f

