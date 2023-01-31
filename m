Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87AC682F7D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjAaOlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAaOlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:41:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA2460A2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675176064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kDZeka6s2FVzAq9jQS/8+R+TVdtKiTI6wM5H/QR27ws=;
        b=D1+cbzqH4RwoqooElOxyxiW+Y98N9uOTry0zBVLcNM8o2LHoTBQvmtnh2doQ0V1jWf/8tj
        i8UCG1hUkcAgLNWDVPlhYUp3cSs1cjisVdnb+NbxL1olurBfNMMmc22RSu74gQ0JQn7f2g
        poGLNv20vj+Y5j9Y0t2tGYqljjgaVpo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-XXZRGpgTPiCx-MfR6Fai0w-1; Tue, 31 Jan 2023 09:41:03 -0500
X-MC-Unique: XXZRGpgTPiCx-MfR6Fai0w-1
Received: by mail-qv1-f71.google.com with SMTP id mx2-20020a0562142e0200b0053807f3eb76so7551491qvb.15
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kDZeka6s2FVzAq9jQS/8+R+TVdtKiTI6wM5H/QR27ws=;
        b=d/dSnZwcJiC0tuNLJUk2fPhkYEr8OJbazKnhsBT9vuTgpl4ynI7zxH0l8qUpYPv53Z
         MkqYT3mZPWEIb1x2TCKN6Bvd5k4gbjQMg0vUDNw7xMSkAsIEZkv2eKsOgoRtacKKOuuH
         B+S2Ezg5DMCmfb6kBKpzEP3f0/OYJKZL93MCMrkx3CdXq27HfUxnmLe9G1Pt94WLlUo+
         sa93syBx4LcFlP7SqO6EQvifzbqdfhqI49WTVRKsc41ESopyWgclnJ3UCCMqFZMbKkLz
         VBE52LzbuxowMsVpjTpzV6AkkTwbGngmmEDJeN9h97+XmJjPAaVvJ4vFFVOgAjUFOvXz
         2Tww==
X-Gm-Message-State: AFqh2kqm0sjvfVSnmWZ+3sQ+Os6i98rAUz/oLVPvUa1cdCFCgf+QiSkw
        PU4ow2B7nEqHXSpTh6Adtn2RO4hnwfu+pjyRT55b0NRViLHfy6TcS8QTHu3bcrpTEdqq44y9YcP
        l4u34H4J1Gzrh9+Pq
X-Received: by 2002:ac8:4519:0:b0:3b6:35cb:b944 with SMTP id q25-20020ac84519000000b003b635cbb944mr23843665qtn.2.1675176062583;
        Tue, 31 Jan 2023 06:41:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsLbf6GbwnxjCtGXO/npxRlAJRvvSIoFiQszhdhLaXnEkLpDqGgtp5TB3gnsbZNwt8XGUE+gg==
X-Received: by 2002:ac8:4519:0:b0:3b6:35cb:b944 with SMTP id q25-20020ac84519000000b003b635cbb944mr23843644qtn.2.1675176062323;
        Tue, 31 Jan 2023 06:41:02 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id fb23-20020a05622a481700b003b62cd6e60esm9720172qtb.43.2023.01.31.06.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:41:01 -0800 (PST)
Message-ID: <0743f81b0c84d7bbe3b727c746f4f4e856305d4e.camel@redhat.com>
Subject: Re: [PATCH v3 2/2] virtio_net: notify MAC address change on device
 initialization
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>, Cindy Lu <lulu@redhat.com>,
        netdev@vger.kernel.org, Gautam Dawar <gautam.dawar@xilinx.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 31 Jan 2023 15:40:58 +0100
In-Reply-To: <20230131084213-mutt-send-email-mst@kernel.org>
References: <20230127204500.51930-1-lvivier@redhat.com>
         <20230127204500.51930-3-lvivier@redhat.com>
         <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
         <20230131084213-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-31 at 08:43 -0500, Michael S. Tsirkin wrote:
> On Tue, Jan 31, 2023 at 10:01:53AM +0100, Paolo Abeni wrote:
> > On Fri, 2023-01-27 at 21:45 +0100, Laurent Vivier wrote:
> > > In virtnet_probe(), if the device doesn't provide a MAC address the
> > > driver assigns a random one.
> > > As we modify the MAC address we need to notify the device to allow it
> > > to update all the related information.
> > >=20
> > > The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> > > assign a MAC address by default. The virtio_net device uses a random
> > > MAC address (we can see it with "ip link"), but we can't ping a net
> > > namespace from another one using the virtio-vdpa device because the
> > > new MAC address has not been provided to the hardware:
> > > RX packets are dropped since they don't go through the receive filter=
s,
> > > TX packets go through unaffected.
> > >=20
> > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >=20
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7d700f8e545a..704a05f1c279 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *=
vdev)
> > >  		eth_hw_addr_set(dev, addr);
> > >  	} else {
> > >  		eth_hw_addr_random(dev);
> > > +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> > > +			 dev->dev_addr);
> > >  	}
> > > =20
> > >  	/* Set up our device-specific information */
> > > @@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device =
*vdev)
> > > =20
> > >  	virtio_device_ready(vdev);
> > > =20
> > > +	/* a random MAC address has been assigned, notify the device.
> > > +	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
> > > +	 * because many devices work fine without getting MAC explicitly
> > > +	 */
> > > +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> > > +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> > > +		struct scatterlist sg;
> > > +
> > > +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> > > +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> > > +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> > > +			pr_debug("virtio_net: setting MAC address failed\n");
> > > +			rtnl_unlock();
> > > +			err =3D -EINVAL;
> > > +			goto free_unregister_netdev;
> >=20
> > Since the above is still dealing with device initialization, would it
> > make sense moving such init step before registering the netdevice?=20
> >=20
> > Cheers,
> >=20
> > Paolo
>=20
> We can't really, device has to be ready otherwise
> we can't send commands to it.

Thanks, I see. Also, Laurent already clarified the above.

Should I read your comment as you are ok with the patches in the
current form?

Cheers,

Paolo

