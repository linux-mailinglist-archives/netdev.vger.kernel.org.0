Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319BC66D1A4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbjAPWQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbjAPWQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:16:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA053C0D
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 14:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673907188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWmw6eIlLIrAqi6cPEzZVmLSGb1Pc0llD3aKiuwhdDA=;
        b=hxjgf9z4Q+bu46KjnfkD0FGQNVgg4keB9asb4WHpioevP2kHbCwE67XwKFyo+9KjAy2v87
        3l0K0DGPACmWPHeioWtkgdSrA3ulM9HxvG8Dy0iLoVH1iuNqX41OBJ3zgCWHjYzOk2S+u0
        a29FTQOtANa+Yf2BybvbXCHY7nlIhgo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-QmGmYllIPGOy4MEuNnNW0Q-1; Mon, 16 Jan 2023 17:13:06 -0500
X-MC-Unique: QmGmYllIPGOy4MEuNnNW0Q-1
Received: by mail-wm1-f72.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so19057300wmq.2
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 14:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWmw6eIlLIrAqi6cPEzZVmLSGb1Pc0llD3aKiuwhdDA=;
        b=GvUsQVcvRW7DzZEkae8WPyG70C4NRG4WyXPwWzMyMQE9UFZMSzwEyKNvgFrRrJyycq
         LgGvTooG3FissSLLXFfGQzFd2PZbrafPgU+RS9BxQ2Q81aNceGqDwC043ektGdB/Mjl9
         DYIXxXvXk0IYhit0er8Efmuz1QY2SGXKF/LwJMkKmzAcjO8kp8XSLmxnX/QeA2oYhnrg
         rDcawkzcTVebfidNXarBQnA3P3wYqD9ovoae9sNBi8S+FA1yNM+VMsPZ8NEqG2id3LB1
         FlyHzLYg/MPfVZhjd+RAsoZAITm9Fl73x3XAQsRjJFZiix0UVCOJe8DhZ/NaedlbNnSB
         LCaA==
X-Gm-Message-State: AFqh2krWGMhz6i6Vwcf9tUWeYLEhUR1dxvET07fibsgCr/k3oqMiRq7l
        Q5Ets0bSnnqpYNf04573liW5UKD8lz+Hrn3UIEiXkgsgI0LoxDx1WYB34p051rGpqfYSll8EHsu
        3P/ZzTV+jeQAIjxl4
X-Received: by 2002:a05:6000:719:b0:2bd:f8db:faa1 with SMTP id bs25-20020a056000071900b002bdf8dbfaa1mr6528985wrb.32.1673907185684;
        Mon, 16 Jan 2023 14:13:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsM9cWxKgdTjEDIlA9m69cdOjnGV43o/LVpzLBt4am3zkVVn7HYsM4jvEnJ8+X3Uszkr6VTeg==
X-Received: by 2002:a05:6000:719:b0:2bd:f8db:faa1 with SMTP id bs25-20020a056000071900b002bdf8dbfaa1mr6528973wrb.32.1673907185467;
        Mon, 16 Jan 2023 14:13:05 -0800 (PST)
Received: from redhat.com ([2.52.132.216])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d4010000000b002bbed1388a5sm22007633wrp.15.2023.01.16.14.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 14:13:04 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:13:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexanderduyck@fb.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v2] virtio_net: Reuse buffer free function
Message-ID: <20230116170550-mutt-send-email-mst@kernel.org>
References: <20230116202708.276604-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116202708.276604-1-parav@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 10:27:08PM +0200, Parav Pandit wrote:
> virtnet_rq_free_unused_buf() helper function to free the buffer
> already exists. Avoid code duplication by reusing existing function.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  drivers/net/virtio_net.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..31d037df514f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1251,13 +1251,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>  	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>  		pr_debug("%s: short packet %i\n", dev->name, len);
>  		dev->stats.rx_length_errors++;
> -		if (vi->mergeable_rx_bufs) {
> -			put_page(virt_to_head_page(buf));
> -		} else if (vi->big_packets) {
> -			give_pages(rq, buf);
> -		} else {
> -			put_page(virt_to_head_page(buf));
> -		}
> +		virtnet_rq_free_unused_buf(rq->vq, buf);
>  		return;
>  	}

Sure.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

while we are at it how about a patch moving
virtnet_rq_free_unused_buf and virtnet_sq_free_unused_buf so
we don't need forward declarations?

E.g. a good place for virtnet_sq_free_unused_buf is likely
after ptr_to_xdp group of functions.

For virtnet_rq_free_unused_buf - after give_pages/get_a_page.

>  
> -- 
> 2.26.2

