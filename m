Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B815683912
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjAaWKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjAaWKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:10:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E0268D
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675202963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ip7LN5t2XMU2RXyA57wD+YKH27SGyN1LXlfzY7WmEN8=;
        b=WFavo6h/eexQX+XMM5JOfU0buq9keVPsDpNhugzbBdKQPbp3hr5jHQAnr6O5rGhXZaIvk0
        SdvqiX/9MWJ2Wcr9V06fu8fw8zkojudDc9VNK3ks3+W98OKTmkPa4jYzMYjkltV8aq2GBu
        GA2Ae0dz6W4kmkldAc2DxUWgj27fL48=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-yA3AzOqKMNWTL3Y46dlhKA-1; Tue, 31 Jan 2023 17:09:21 -0500
X-MC-Unique: yA3AzOqKMNWTL3Y46dlhKA-1
Received: by mail-ed1-f70.google.com with SMTP id j10-20020a05640211ca00b0049e385d5830so11620860edw.22
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ip7LN5t2XMU2RXyA57wD+YKH27SGyN1LXlfzY7WmEN8=;
        b=AUX+y+Kbwx+nVA+7YVwetnSlfzdeozoWJ+CNex1uQY1Z1ye2iPbR/rmf1bvqSwJDKU
         Zlt1NouuESAJSi4F+0BXozc5l/aWQwV/aLBPU45SUOLDuuODStQGzRMWB6pLoI9CITwg
         S+qj7qhIlKhBaXh059crajxnQHOZwWS4eh6PEp+siXmcXOX57NaHGw6+lsVzH7cywE37
         Ux5Zw8bj5b334TEus49q+niQBA62kylSgTUwwiMgEV8FG8INl63RCw4qzVDN/LOqqood
         6vgeMVaFtPErDedOGvLyu763XVZWiNmhpFRTbRMMGTbrhqOZSG0r2/C+4nnbgjNT/QD3
         WDWw==
X-Gm-Message-State: AO0yUKWOLbO9Urh/lnpvc2zaPwJvpfwm10ONuogFYB/ZsszAdGTqAJCA
        u7S9zJ3/AGTBqAp3ZNJ8bLFL/HXRKv2hMhlCawsogLA44yI/4U+tn4Xr4Hedt/OHZDoY+LtvDv9
        z6w/+UQ9sxEN8zhZE
X-Received: by 2002:a05:6402:202e:b0:4a2:449a:9498 with SMTP id ay14-20020a056402202e00b004a2449a9498mr10759873edb.31.1675202960758;
        Tue, 31 Jan 2023 14:09:20 -0800 (PST)
X-Google-Smtp-Source: AK7set8v8HniRH4JSAGTfryw69wu0KZFyBxDDgNcZStsKTfdJjHe3oeQBGrcGyuRfy7DNSiGzKJRUQ==
X-Received: by 2002:a05:6402:202e:b0:4a2:449a:9498 with SMTP id ay14-20020a056402202e00b004a2449a9498mr10759855edb.31.1675202960506;
        Tue, 31 Jan 2023 14:09:20 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id a66-20020a509ec8000000b00482e0c55e2bsm889495edf.93.2023.01.31.14.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:09:19 -0800 (PST)
Date:   Tue, 31 Jan 2023 17:09:15 -0500
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
Subject: Re: [PATCH v3 2/2] virtio_net: notify MAC address change on device
 initialization
Message-ID: <20230131170908-mutt-send-email-mst@kernel.org>
References: <20230127204500.51930-1-lvivier@redhat.com>
 <20230127204500.51930-3-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127204500.51930-3-lvivier@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:45:00PM +0100, Laurent Vivier wrote:
> In virtnet_probe(), if the device doesn't provide a MAC address the
> driver assigns a random one.
> As we modify the MAC address we need to notify the device to allow it
> to update all the related information.
> 
> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> assign a MAC address by default. The virtio_net device uses a random
> MAC address (we can see it with "ip link"), but we can't ping a net
> namespace from another one using the virtio-vdpa device because the
> new MAC address has not been provided to the hardware:
> RX packets are dropped since they don't go through the receive filters,
> TX packets go through unaffected.
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7d700f8e545a..704a05f1c279 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		eth_hw_addr_set(dev, addr);
>  	} else {
>  		eth_hw_addr_random(dev);
> +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> +			 dev->dev_addr);
>  	}
>  
>  	/* Set up our device-specific information */
> @@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device *vdev)
>  
>  	virtio_device_ready(vdev);
>  
> +	/* a random MAC address has been assigned, notify the device.
> +	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
> +	 * because many devices work fine without getting MAC explicitly
> +	 */
> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> +		struct scatterlist sg;
> +
> +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> +			pr_debug("virtio_net: setting MAC address failed\n");
> +			rtnl_unlock();
> +			err = -EINVAL;
> +			goto free_unregister_netdev;
> +		}
> +	}
> +
>  	rtnl_unlock();
>  
>  	err = virtnet_cpu_notif_add(vi);
> -- 
> 2.39.1

