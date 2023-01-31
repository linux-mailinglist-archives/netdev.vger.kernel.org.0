Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42DF683914
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjAaWK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjAaWK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:10:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9027C7AA0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675202977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+EInBavO8bUQmbkFuSQwUsNVOCGCJTbOtt6tsAhifI=;
        b=HeDM7iOZ2sQe5BEaxp/NSpE15JyY17OyQkkytebjzwyhGC4DBzxpIX0XVkNpuwut18CIZX
        FR+0RJT6J/RohVL8XeIMAdH0KuKi1z5L7crdMFY2uuB+X5IKlynaejKHRzDkWoe4kyqyaS
        yFIODFaJBkLFdPVP8koVCGkyNjbDhjw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-zzOWvWBVP8GSMsBbYOcZQw-1; Tue, 31 Jan 2023 17:09:36 -0500
X-MC-Unique: zzOWvWBVP8GSMsBbYOcZQw-1
Received: by mail-ed1-f72.google.com with SMTP id s26-20020a056402037a00b004a25c2875d6so3663038edw.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+EInBavO8bUQmbkFuSQwUsNVOCGCJTbOtt6tsAhifI=;
        b=nP7c6gzElWwoqelw7Igv7wTy/XDSceS3N+QOKRPbLengKbumPmfNfRh1Sk7KmSft4g
         uUnXgJTojv8XxXpuZgYvPGLNS3bN/1CJo6AwVVONQRmzRDaWVr5nRG/cJfCYmfG2F8M7
         SDgoRxDGUHecszl3IXVhcZdBNDrLnoaxRto8qDqudc5CE+9Yj+ogLqA93CVQmVo3r/NF
         sqEOwxfnK0CbAMha7yKm+ULazKC/xCiMi2571fJM+XOsd2rE2dOfL/aSBYcr8AxyHs3s
         kGY/laKabZrZZUERBBF5OA+9jcuAisK+NFgwAjcCKxzCVVhVRDm+kScQ9QipDsbtdEuE
         +JOQ==
X-Gm-Message-State: AO0yUKUc6uIVyIAPMwry7XLG1uTA7HSb7a67I7rqa1uOGhgXI9WFRgtc
        L3PZbmIkNunR49UXHAfttoGQT9uEBfEDlJxGoP1nTES3FxXq58OzrQyeldtjSgqqKjjnW+gu1bF
        kzreYywNufClbcxsZ
X-Received: by 2002:a17:907:7e9e:b0:878:5c22:6e03 with SMTP id qb30-20020a1709077e9e00b008785c226e03mr6070819ejc.73.1675202975371;
        Tue, 31 Jan 2023 14:09:35 -0800 (PST)
X-Google-Smtp-Source: AK7set/umuCR+3IZE7Li+5UeArJ7g88Vg8CTJWN7CwjHLCAHc+Y5XBZ1wpIH1VghWcytadpuSByN2w==
X-Received: by 2002:a17:907:7e9e:b0:878:5c22:6e03 with SMTP id qb30-20020a1709077e9e00b008785c226e03mr6070806ejc.73.1675202975121;
        Tue, 31 Jan 2023 14:09:35 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id d23-20020a1709063ed700b0088d0b51f056sm818204ejj.40.2023.01.31.14.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:09:34 -0800 (PST)
Date:   Tue, 31 Jan 2023 17:09:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v3 1/2] virtio_net: disable VIRTIO_NET_F_STANDBY if
 VIRTIO_NET_F_MAC is not set
Message-ID: <20230131170923-mutt-send-email-mst@kernel.org>
References: <20230127204500.51930-1-lvivier@redhat.com>
 <20230127204500.51930-2-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127204500.51930-2-lvivier@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:44:59PM +0100, Laurent Vivier wrote:
> failover relies on the MAC address to pair the primary and the standby
> devices:
> 
>   "[...] the hypervisor needs to enable VIRTIO_NET_F_STANDBY
>    feature on the virtio-net interface and assign the same MAC address
>    to both virtio-net and VF interfaces."
> 
>   Documentation/networking/net_failover.rst
> 
> This patch disables the STANDBY feature if the MAC address is not
> provided by the hypervisor.
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..7d700f8e545a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3688,6 +3688,12 @@ static int virtnet_validate(struct virtio_device *vdev)
>  			__virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
>  	}
>  
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY) &&
> +	    !virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> +		dev_warn(&vdev->dev, "device advertises feature VIRTIO_NET_F_STANDBY but not VIRTIO_NET_F_MAC, disabling standby");
> +		__virtio_clear_bit(vdev, VIRTIO_NET_F_STANDBY);
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.39.1

