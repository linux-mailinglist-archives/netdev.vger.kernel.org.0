Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE1E682E3B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjAaNoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjAaNoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:44:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0039752
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675172590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FjK9CwJ0qU9dRcgLTPDubY9KveWkyLemzeLHtogsBVU=;
        b=UCoE/WIVtE0895wuyGYFehF8ol7CihRTmFLw3O91nAXULzYwpvmGr/P0LbuK72x8zaNgHr
        HCNaUzZD0nhX/QnLKGpWslZzX2hJ7dIsoqvWgGmk6ErDDOAGp8zNsgcfjwi+Tmof2Fc9Nk
        kQuhN4ZCYheMyqHMVR8B046uQ5Jbhas=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-133-2ibrgykOMKmkA8Gqwdso8w-1; Tue, 31 Jan 2023 08:43:09 -0500
X-MC-Unique: 2ibrgykOMKmkA8Gqwdso8w-1
Received: by mail-wm1-f71.google.com with SMTP id j20-20020a05600c1c1400b003dc5dd44c0cso2496375wms.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjK9CwJ0qU9dRcgLTPDubY9KveWkyLemzeLHtogsBVU=;
        b=BbWR7N2ndW0D1BDDB2DrnFTHuYgv/e6O0xE0IGENxTupv3TLEaG3LUNNJlFOXsJrtW
         U9yYwM6BiLzHH8KUMCle1uGrEiv2PCBk3CDEkqGj38ddLModMLAH02UM9nzQEYpXgwlg
         HkAq8wafpN/oZqa8Om0LfwiC8d+8zsoaAKTblBxUy5zm9jTJzY0WRZE0QP01kH5gESwA
         WtEP5kMQkfSJ2PT/cprOYlzBVBD0hW66UPMIz+7jmM+OwcZlXPuQqcgMD7Ap4uJokoF3
         rPnIgiHyxcMwnJIdKpTCTAy5MIDbPAxl01VBUybQBIitppLhg+HYgj9ld15jOzhUxtX3
         hU/w==
X-Gm-Message-State: AO0yUKUv5gcht3bxDu6p5ZBPS3N/8dbwJOImRtbEFESgyn9ZHNBcCCo0
        cZleM9A6r/66U0jUYfDEc8Hi2JSr64Z0h4LfS3l7zHW7vi5ktlulBfpMnEWosdVREzdv+68DiiS
        ktk5ava9bY7dzrYdx
X-Received: by 2002:a5d:6186:0:b0:2c1:28dc:1566 with SMTP id j6-20020a5d6186000000b002c128dc1566mr2925914wru.41.1675172588151;
        Tue, 31 Jan 2023 05:43:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+p39CqWABw+L+6uLvyXB/Xo6TtwQky3aHV0sHHTMfoOt2nrNUb+4VicVe08niov9+PPvP6YQ==
X-Received: by 2002:a5d:6186:0:b0:2c1:28dc:1566 with SMTP id j6-20020a5d6186000000b002c128dc1566mr2925898wru.41.1675172587836;
        Tue, 31 Jan 2023 05:43:07 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d50c6000000b002bfc24e1c55sm14824129wrt.78.2023.01.31.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 05:43:07 -0800 (PST)
Date:   Tue, 31 Jan 2023 08:43:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v3 2/2] virtio_net: notify MAC address change on device
 initialization
Message-ID: <20230131084213-mutt-send-email-mst@kernel.org>
References: <20230127204500.51930-1-lvivier@redhat.com>
 <20230127204500.51930-3-lvivier@redhat.com>
 <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 10:01:53AM +0100, Paolo Abeni wrote:
> On Fri, 2023-01-27 at 21:45 +0100, Laurent Vivier wrote:
> > In virtnet_probe(), if the device doesn't provide a MAC address the
> > driver assigns a random one.
> > As we modify the MAC address we need to notify the device to allow it
> > to update all the related information.
> > 
> > The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> > assign a MAC address by default. The virtio_net device uses a random
> > MAC address (we can see it with "ip link"), but we can't ping a net
> > namespace from another one using the virtio-vdpa device because the
> > new MAC address has not been provided to the hardware:
> > RX packets are dropped since they don't go through the receive filters,
> > TX packets go through unaffected.
> > 
> > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7d700f8e545a..704a05f1c279 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> >  		eth_hw_addr_set(dev, addr);
> >  	} else {
> >  		eth_hw_addr_random(dev);
> > +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> > +			 dev->dev_addr);
> >  	}
> >  
> >  	/* Set up our device-specific information */
> > @@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device *vdev)
> >  
> >  	virtio_device_ready(vdev);
> >  
> > +	/* a random MAC address has been assigned, notify the device.
> > +	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
> > +	 * because many devices work fine without getting MAC explicitly
> > +	 */
> > +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> > +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> > +		struct scatterlist sg;
> > +
> > +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> > +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> > +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> > +			pr_debug("virtio_net: setting MAC address failed\n");
> > +			rtnl_unlock();
> > +			err = -EINVAL;
> > +			goto free_unregister_netdev;
> 
> Since the above is still dealing with device initialization, would it
> make sense moving such init step before registering the netdevice? 
> 
> Cheers,
> 
> Paolo

We can't really, device has to be ready otherwise
we can't send commands to it.

-- 
MST

