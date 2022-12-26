Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF9765661A
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 00:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiLZXhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 18:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiLZXhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 18:37:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F4A60FD
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 15:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672097801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uzpr44sA44tjoiP52UekyIu8PBOLrYR7TYiwR3W0WSA=;
        b=FjUebgYGQPzACUkZiz2adQAanYnJSTR1eLctA+wanzywaeJ8n7b9ElWrG6KyHN4BVvi6y8
        r5d9a9KwTUxPAIImxsIXwaxX/KuZpRmy90AJeAI/VItQ2ZDdZjFfp3bEu4UEcmnC10Aqw5
        sYAmqaCdCWs7nJDwtO3fLIwJqLyTz4w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-WkowqiGyPvuE4h-tt1zoCw-1; Mon, 26 Dec 2022 18:36:40 -0500
X-MC-Unique: WkowqiGyPvuE4h-tt1zoCw-1
Received: by mail-ej1-f71.google.com with SMTP id xc12-20020a170907074c00b007416699ea14so8021750ejb.19
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 15:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzpr44sA44tjoiP52UekyIu8PBOLrYR7TYiwR3W0WSA=;
        b=xJfbXbmWGcht6l2T9qvIHFGZfz3Sk8qQZiz7dtSt0onlwHcsv3xm3KCT53gChfNbI7
         Ah/1KCspb3U4KCB1jPUOFhniCtjwwvTpXfSzts8bj+NkUO9b0XFFl5wtt3UrgkqmlJ9O
         /tr/0OjhYxjGW4HO18Mdk+HhfllMRFk/ueWTya89yNMJiTbAV9C4zD0HZKOmEnQlZq8U
         u1JGTEz9hWLQAt6eInEkb8ozetPIDziMK9DOfHKTRU8cGq/hk00BUhWNl8tb7Lm3CcNZ
         mrU1hDTy+3OKWzldFoRuzTS5P0U7CgHpis3lrPqnBMsP7xSU+GwpDT536Hi5AtgLQMk8
         5yGQ==
X-Gm-Message-State: AFqh2krjb2lgbYQ/TiBoCkn27bxjzwHdHy2bTjC/Upy4BU1LqmwTmI04
        yAgoIf38Z8sgsHm294cgCS2Vnle/nLvkUmhjo2MD2CCzlY3BTfAKe5hr9ZZiok3RKnOLIgs1icY
        HhS+4DaNSXPTUjLvo
X-Received: by 2002:a17:907:7676:b0:7c1:7183:2d32 with SMTP id kk22-20020a170907767600b007c171832d32mr18284263ejc.56.1672097799365;
        Mon, 26 Dec 2022 15:36:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuvQh+t/YUrOWufzLCFVyH7pjzJsK3vL527X56J/9SF731Dpz8d+d56ZwO0krnV4UliPaSZ5Q==
X-Received: by 2002:a17:907:7676:b0:7c1:7183:2d32 with SMTP id kk22-20020a170907767600b007c171832d32mr18284257ejc.56.1672097799188;
        Mon, 26 Dec 2022 15:36:39 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b0080345493023sm5296229ejt.167.2022.12.26.15.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 15:36:38 -0800 (PST)
Date:   Mon, 26 Dec 2022 18:36:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 2/4] virtio_ring: switch to use BAD_RING()
Message-ID: <20221226183604-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226074908.8154-3-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 03:49:06PM +0800, Jason Wang wrote:
> Switch to reuse BAD_RING() to allow common logic to be implemented in
> BAD_RING().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes since V1:
> - switch to use BAD_RING in virtio_break_device()
> ---
>  drivers/virtio/virtio_ring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 2e7689bb933b..5cfb2fa8abee 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -58,7 +58,8 @@
>  	do {							\
>  		dev_err(&_vq->vq.vdev->dev,			\
>  			"%s:"fmt, (_vq)->vq.name, ##args);	\
> -		(_vq)->broken = true;				\
> +		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \

I don't think WRITE_ONCE/READ_ONCE pair as such. Can you point
me at documentation of such pairing?

> +		WRITE_ONCE((_vq)->broken, true);		       \
>  	} while (0)
>  #define START_USE(vq)
>  #define END_USE(vq)
> @@ -2237,7 +2238,7 @@ bool virtqueue_notify(struct virtqueue *_vq)
>  
>  	/* Prod other side to tell it about changes. */
>  	if (!vq->notify(_vq)) {
> -		vq->broken = true;
> +		BAD_RING(vq, "vq %d is broken\n", vq->vq.index);
>  		return false;
>  	}
>  	return true;
> @@ -2786,8 +2787,7 @@ void virtio_break_device(struct virtio_device *dev)
>  	list_for_each_entry(_vq, &dev->vqs, list) {
>  		struct vring_virtqueue *vq = to_vvq(_vq);
>  
> -		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> -		WRITE_ONCE(vq->broken, true);
> +		BAD_RING(vq, "Device break vq %d", _vq->index);
>  	}
>  	spin_unlock(&dev->vqs_list_lock);
>  }
> -- 
> 2.25.1

