Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD325513A7
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiFTJEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240283AbiFTJEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC44C44
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655715883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XvT2/EIqirhY+p5g64uUJvmK6JkYzBXCB04zVu3nQHE=;
        b=Q2Eemmhuej0t4q+XQ39gqCvim5zdIvLLzVxuGUs2z8JmiVOnMeHS9KMhaa+GYMYBcnPjw+
        MDLeiWruRicSLk7rXsJYZi0JSrvCOXO9xRMZQik300USE0JtQrKQ16NfWhmRtIeFryH/lC
        Ob9GK2n7lHjGdVAFNxjHphzbrMLECSw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Aai6lbcGPRujjue9liWh-g-1; Mon, 20 Jun 2022 05:04:42 -0400
X-MC-Unique: Aai6lbcGPRujjue9liWh-g-1
Received: by mail-ej1-f71.google.com with SMTP id mb1-20020a170906eb0100b00710c3b46a9aso3204052ejb.22
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XvT2/EIqirhY+p5g64uUJvmK6JkYzBXCB04zVu3nQHE=;
        b=T2qvaB5bkAANHeuhle28nTfxdkZOsGc/3GjIjatFR2hWOzRgM+mIpX7X+Aj3KX/5ag
         VS/I/lgbUvLaIB6XWfzP+Mms7MEz1GMq20X0Z4CcAzRraTHsGH+SJitRVAFVmymzy5JF
         /he2ui6vGylMxTYW6rMAj8p/koN3QvqwHO3vHPVd+iKOTUNidvFg3T5Nmd9cMmbpEFD2
         TOR8nIrIvigVL9hfkAKXuJDg+H+cigIk1hjanPdBKCSeaLnPDuW2Z5coLYvQPM9kP0Y+
         lWMOVqQG+JqWJyZalk5PMzklRQwqVsm0pNQ2DX5wPDCp/EvmDmUcmbYnGgsjqCA/0lce
         oryg==
X-Gm-Message-State: AJIora/e21elQfOH99hA0NOW3yWVflMC2ALmF3U62mEzROXjxJawyQNt
        rvPFXj7spc7WFiHTQbZO1a+JpxrTa01p0JF1MwtaN9Yr8e8w1Qs8XOSOBYV9gSEWk8cQ416hBPx
        uJ0tvb7YOHnYR5VJQ
X-Received: by 2002:a05:6402:5412:b0:435:5997:ccb5 with SMTP id ev18-20020a056402541200b004355997ccb5mr22879962edb.167.1655715880626;
        Mon, 20 Jun 2022 02:04:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u1V+8Z1olE7xRgb2e9/tLuRkZXYmTbhDWHE3J4zi9+b+f3sbuOtlQmw5zirNa6vEQBRLEWbA==
X-Received: by 2002:a05:6402:5412:b0:435:5997:ccb5 with SMTP id ev18-20020a056402541200b004355997ccb5mr22879947edb.167.1655715880436;
        Mon, 20 Jun 2022 02:04:40 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id o17-20020aa7dd51000000b0042df0c7deccsm9739758edw.78.2022.06.20.02.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 02:04:39 -0700 (PDT)
Date:   Mon, 20 Jun 2022 05:04:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, erwan.yvin@stericsson.com
Subject: Re: [PATCH 2/3] caif_virtio: fix the race between
 virtio_device_ready() and ndo_open()
Message-ID: <20220620050251-mutt-send-email-mst@kernel.org>
References: <20220620051115.3142-1-jasowang@redhat.com>
 <20220620051115.3142-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620051115.3142-3-jasowang@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:11:14PM +0800, Jason Wang wrote:
> We used to depend on the virtio_device_ready() that is called after

"We used to" implies it's not the case currently.
I think you mean "we currently depend".

> probe() by virtio_dev_probe() after netdev registration. This
> cause 

causes

>a race between ndo_open() and virtio_device_ready(): if
> ndo_open() is called before virtio_device_ready(), the driver may
> start to use the device (e.g TX) before DRIVER_OK which violates the
> spec.
> 
> Fixing this

Fix this

> by switching to use register_netdevice() and protect the
> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> only be called after virtio_device_ready().
> 
> Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/caif/caif_virtio.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> index c677ded81133..66375bea2fcd 100644
> --- a/drivers/net/caif/caif_virtio.c
> +++ b/drivers/net/caif/caif_virtio.c
> @@ -719,13 +719,21 @@ static int cfv_probe(struct virtio_device *vdev)
>  	/* Carrier is off until netdevice is opened */
>  	netif_carrier_off(netdev);
>  
> +	/* serialize netdev register + virtio_device_ready() with ndo_open() */
> +	rtnl_lock();
> +
>  	/* register Netdev */
> -	err = register_netdev(netdev);
> +	err = register_netdevice(netdev);
>  	if (err) {
> +		rtnl_unlock();
>  		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
>  		goto err;
>  	}
>  
> +	virtio_device_ready(vdev);
> +
> +	rtnl_unlock();
> +
>  	debugfs_init(cfv);
>  
>  	return 0;
> -- 
> 2.25.1

