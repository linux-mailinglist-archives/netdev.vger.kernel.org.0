Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7A68281F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjAaJG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjAaJGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:06:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770A439CED
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675155720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vt2tjqxlN7/1NemGgBR2FJoG/wRT9bFNFt/hjOlWcI=;
        b=igVTo55D+tf+/ABLMrw399riM8ZiIsVLxtBhZPQpY5nFNcCurIq5y2JS2kJny8FnJg5biw
        tnp8SXRar+tmMI14u1JKxbLm6e1trbId2usIjoNszivDJo7LZIBfTcN8OkAzMf7sfyVGDt
        aIr/YbxZIe+/0RoLbk+N03h0KeyXp+g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-504-32BcMOs_OKCy4KTtxEFrlg-1; Tue, 31 Jan 2023 04:01:58 -0500
X-MC-Unique: 32BcMOs_OKCy4KTtxEFrlg-1
Received: by mail-qv1-f72.google.com with SMTP id p14-20020a05621421ee00b005392216783aso5756000qvj.16
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0vt2tjqxlN7/1NemGgBR2FJoG/wRT9bFNFt/hjOlWcI=;
        b=rzw5gv6FlbzSoDxCN0Fo8My9uEHiWBIesu87E/HFJSfbRngPFQdAX4h8FI8QDfYlfE
         9u6ANnA0e5F7pxBh246MtamGHcTZizS6ehHcYM5WuWmEpM4HRbz17QowCrEyOI/rc36C
         YEtPpvW0YEhJFRByGo9hDy/aIO3dZYescbPx1HRh1qw706m0yHDAc2ACVhrDln64q1MR
         qePISpiezwfKBjwTykqQZllpVpioa2nwWVCSizYGGPBcYopPt7WDyQLfbCRYllI68v/m
         b07DgEI6RoQptDOZBKO0ksM3MXjeHy5c1DjNmdPtewwykFhSCFFUC0qz4zX7ydSlRMYF
         x1pA==
X-Gm-Message-State: AO0yUKW9oyPJAHLjWkMgmmGYcKxPkaEHA7rBr493nwrWPgT16PjSBzLd
        VwnnZ9ufHhAaI2+b8RWqdeNg30jnHNDKTpKPx+QCBwghWUGl6RYGGnCNz2vfAl8NWoMmxCQrdK6
        kVRy3Bd7rzASFoyO6
X-Received: by 2002:a0c:b282:0:b0:53a:a0b4:99e5 with SMTP id r2-20020a0cb282000000b0053aa0b499e5mr5701067qve.5.1675155718288;
        Tue, 31 Jan 2023 01:01:58 -0800 (PST)
X-Google-Smtp-Source: AK7set/8gyp2fjq9TftLcjH1ZOMz2/ugjeYGTj52R3CtGBrlxJBMNlEq5CYyi69gOrfXhoP9k+Q6SA==
X-Received: by 2002:a0c:b282:0:b0:53a:a0b4:99e5 with SMTP id r2-20020a0cb282000000b0053aa0b499e5mr5701037qve.5.1675155718008;
        Tue, 31 Jan 2023 01:01:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id z16-20020ae9c110000000b0070617deb4b7sm9385834qki.134.2023.01.31.01.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:01:57 -0800 (PST)
Message-ID: <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
Subject: Re: [PATCH v3 2/2] virtio_net: notify MAC address change on device
 initialization
From:   Paolo Abeni <pabeni@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Date:   Tue, 31 Jan 2023 10:01:53 +0100
In-Reply-To: <20230127204500.51930-3-lvivier@redhat.com>
References: <20230127204500.51930-1-lvivier@redhat.com>
         <20230127204500.51930-3-lvivier@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-01-27 at 21:45 +0100, Laurent Vivier wrote:
> In virtnet_probe(), if the device doesn't provide a MAC address the
> driver assigns a random one.
> As we modify the MAC address we need to notify the device to allow it
> to update all the related information.
>=20
> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> assign a MAC address by default. The virtio_net device uses a random
> MAC address (we can see it with "ip link"), but we can't ping a net
> namespace from another one using the virtio-vdpa device because the
> new MAC address has not been provided to the hardware:
> RX packets are dropped since they don't go through the receive filters,
> TX packets go through unaffected.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/net/virtio_net.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7d700f8e545a..704a05f1c279 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *vdev=
)
>  		eth_hw_addr_set(dev, addr);
>  	} else {
>  		eth_hw_addr_random(dev);
> +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> +			 dev->dev_addr);
>  	}
> =20
>  	/* Set up our device-specific information */
> @@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device *vde=
v)
> =20
>  	virtio_device_ready(vdev);
> =20
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
> +			err =3D -EINVAL;
> +			goto free_unregister_netdev;

Since the above is still dealing with device initialization, would it
make sense moving such init step before registering the netdevice?=20

Cheers,

Paolo

