Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F23954F50E
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381677AbiFQKNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381689AbiFQKNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:13:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A571213F16
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655460791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Egh8+Gz6P7sJjajReRg4TwcxQZ6PNsT6qhTrjGb38E=;
        b=aVYmR3D39lk3QGNcjm8sS9/hTpwBZgtOYMz3IVOWrSlLyNaiC96DQlkEIlCpaOvg9YdTli
        l6qq88H3yeHvKIii5ykQYKmGCIdOmdwaWUIM6GKMNeVdL2NRB0kI324iczkIhTWTOfsi4F
        DBt6Nm36FiUNytAMZmr1eir6Ofukzas=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-08VNSnPwMQiecQEgQz_kmw-1; Fri, 17 Jun 2022 06:13:03 -0400
X-MC-Unique: 08VNSnPwMQiecQEgQz_kmw-1
Received: by mail-wm1-f69.google.com with SMTP id k32-20020a05600c1ca000b0039c4cf75023so2505630wms.9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Egh8+Gz6P7sJjajReRg4TwcxQZ6PNsT6qhTrjGb38E=;
        b=M2oMnHl1WdPNzb0bzar4vFvIFRLVb9dMX+OI9fmzbLzPD2XxWyCAXWlFeOP+2JugEH
         IomZsgO4KGJBp+5x91V6Hk9zDLqO+QH0YmlLPFP7PorOJQ9CNDibpFAqkhl0Prro6VWA
         6mg8qwzMvnA8Ap+MuQOKeKrTNm3RIlXQO5uO/+bX52b5WWlYxxISerNEbiOlEyURdJwf
         FxZI77LClfE9ffV4QJvUYkzmw3qbsQYF/UnNr8VepEJ/aBPjenQIFReM2RJbHMNtogPW
         fZPiIXPX96N7Nsj2M/PGMPYZfP54NnjffpJfLPFUGItZUGyYmLVjetKgQdYAv7JT0qQC
         xopQ==
X-Gm-Message-State: AJIora+JJi3koSWPgV5wCKmA7/iWKITasJtfdjOsEywMP9VdkUt/+7F/
        hp2LH+cmEGjsly4K6TbBdg1Sa2VJHFG1PZ+GJaKoZ5unIV/uZ/QJxDEBaFOje2Rxr+k0EXWgEdY
        PVAnC3SEgnrtElfrm
X-Received: by 2002:a5d:6d8b:0:b0:218:4dc8:293e with SMTP id l11-20020a5d6d8b000000b002184dc8293emr8684806wrs.612.1655460781811;
        Fri, 17 Jun 2022 03:13:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uCeVJ3V3dWfzRxiKB7fJuvCI0FPi1R5vsbVVS3gLAKJyU7vKwteL3gJz5FSVTdXRodiZ6DGg==
X-Received: by 2002:a5d:6d8b:0:b0:218:4dc8:293e with SMTP id l11-20020a5d6d8b000000b002184dc8293emr8684788wrs.612.1655460781577;
        Fri, 17 Jun 2022 03:13:01 -0700 (PDT)
Received: from redhat.com ([2.54.189.19])
        by smtp.gmail.com with ESMTPSA id i188-20020a1c3bc5000000b0039ee52c1345sm2137495wma.4.2022.06.17.03.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:13:01 -0700 (PDT)
Date:   Fri, 17 Jun 2022 06:12:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: fix race between ndo_open() and
 virtio_device_ready()
Message-ID: <20220617060632-mutt-send-email-mst@kernel.org>
References: <20220617072949.30734-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617072949.30734-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 03:29:49PM +0800, Jason Wang wrote:
> We used to call virtio_device_ready() after netdev registration. This
> cause a race between ndo_open() and virtio_device_ready(): if
> ndo_open() is called before virtio_device_ready(), the driver may
> start to use the device before DRIVER_OK which violates the spec.
> 
> Fixing this by switching to use register_netdevice() and protect the
> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> only be called after virtio_device_ready().
> 
> Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..8a5810bcb839 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (vi->has_rss || vi->has_rss_hash_report)
>  		virtnet_init_default_rss(vi);
>  
> -	err = register_netdev(dev);
> +	/* serialize netdev register + virtio_device_ready() with ndo_open() */
> +	rtnl_lock();
> +
> +	err = register_netdevice(dev);
>  	if (err) {
>  		pr_debug("virtio_net: registering device failed\n");
> +		rtnl_unlock();
>  		goto free_failover;
>  	}
>  
>  	virtio_device_ready(vdev);
>  
> +	rtnl_unlock();
> +
>  	err = virtnet_cpu_notif_add(vi);
>  	if (err) {
>  		pr_debug("virtio_net: registering cpu notifier failed\n");


Looks good but then don't we have the same issue when removing the
device?

Actually I looked at  virtnet_remove and I see
        unregister_netdev(vi->dev);

        net_failover_destroy(vi->failover);

        remove_vq_common(vi); <- this will reset the device

a window here?


Really, I think what we had originally was a better idea -
instead of dropping interrupts they were delayed and
when driver is ready to accept them it just enables them.
We just need to make sure driver does not wait for
interrupts before enabling them.

And I suspect we need to make this opt-in on a per driver
basis.



> -- 
> 2.25.1

