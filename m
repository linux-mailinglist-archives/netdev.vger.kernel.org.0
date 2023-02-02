Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98E688557
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjBBR04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBR0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:26:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6EA6B350
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675358768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6WKJ+xTBuqvHJA/DgjJYK9bFyVaTh4ihb15FuQHGdbU=;
        b=CBWn2a5g2GLohGR2U+ZB0yxlNuW/47fiaBFn0lPtzhJgUWwydDpEaDaYU42a+B7Q7vJcUo
        JuVIO1Z5kco7iWuvOTAX2csXvMfTypJAdPr9+gv4N9jzhhkV7417P25tBxwGVKB6GBqW5R
        CQ4hE47nFPKELybQJdpEDu9PyiBNMLo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-147-8ST2TMNcPN6tNXgKIfm8Tg-1; Thu, 02 Feb 2023 12:26:06 -0500
X-MC-Unique: 8ST2TMNcPN6tNXgKIfm8Tg-1
Received: by mail-wm1-f72.google.com with SMTP id m3-20020a05600c3b0300b003dfdc6021bcso1169962wms.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 09:26:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WKJ+xTBuqvHJA/DgjJYK9bFyVaTh4ihb15FuQHGdbU=;
        b=nv6DFK1vZGJ01r5Wes6oGmEVWCx+Vh4cODY5OilGvprL/6iooDDgipeK0oK8i8IKUa
         Wb7V/8cWbM24AddYz8s6J3xu+hDyLl9gj4P3Uu+h+UHNCbidDrOiQZBvgD8NiVS1djSu
         QxlfzkybaTDNETGImUAIb1fzvrtE4rkuSXZSIAoSHW2pZdsd1iL+4Wl5MeWy/2iRW5RQ
         8j65w44z6b/ob8VXazHpKLv5h3wkzWEnuZhLZBh0xXjUfuGlvd9uux0VJgL5HXZgsO7T
         JqgXA6ZTH2Hm7AxnWGOPBTFmCIDcLYAyEWRuklsWGomCRYUDSBUeppN4XdeYjO3mhY0y
         H84w==
X-Gm-Message-State: AO0yUKWJZFQJDo14DvIU0+6CGdk/5xfrY3SZoZIG6SeiUEUyYGgsYQWz
        9iiKlad1A/ZcaUy/tKl8Vw6alBt1OtBgkaMvPpuMgrVof0cR+JRF/tYyAjldiiMNY4L8G5LFqRS
        E4ISVmao2gFHcXdu/
X-Received: by 2002:a05:600c:1e0b:b0:3da:1e35:dfec with SMTP id ay11-20020a05600c1e0b00b003da1e35dfecmr6910498wmb.4.1675358765642;
        Thu, 02 Feb 2023 09:26:05 -0800 (PST)
X-Google-Smtp-Source: AK7set/z5RmItaflCIcRIT8kR78dHQV5cx7Dg457PMDawnbySjhpBnXC5/Fk1nq6JbSLeIjJqL5pxQ==
X-Received: by 2002:a05:600c:1e0b:b0:3da:1e35:dfec with SMTP id ay11-20020a05600c1e0b00b003da1e35dfecmr6910475wmb.4.1675358765455;
        Thu, 02 Feb 2023 09:26:05 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b003dd1c15e7fcsm6365187wmq.15.2023.02.02.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 09:26:04 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:25:59 -0500
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
Subject: Re: [PATCH 24/33] virtio_net: xsk: stop disable tx napi
Message-ID: <20230202122445-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-25-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-25-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:49PM +0800, Xuan Zhuo wrote:
> Since xsk's TX queue is consumed by TX NAPI, if sq is bound to xsk, then
> we must stop tx napi from being disabled.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio/main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index ed79e750bc6c..232cf151abff 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -2728,8 +2728,15 @@ static int virtnet_set_coalesce(struct net_device *dev,
>  		return ret;
>  
>  	if (update_napi) {
> -		for (i = 0; i < vi->max_queue_pairs; i++)
> +		for (i = 0; i < vi->max_queue_pairs; i++) {
> +			/* xsk xmit depend on the tx napi. So if xsk is active,

depends.

> +			 * prevent modifications to tx napi.
> +			 */
> +			if (rtnl_dereference(vi->sq[i].xsk.pool))
> +				continue;
> +
>  			vi->sq[i].napi.weight = napi_weight;

I don't get it.
changing napi weight does not work then.
why is this ok?


> +		}
>  	}
>  
>  	return ret;
> -- 
> 2.32.0.3.g01195cf9f

