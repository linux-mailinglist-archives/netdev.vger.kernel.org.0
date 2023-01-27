Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA11267E2B8
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjA0LJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjA0LI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:08:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ED19757
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674817691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CKPEQeD05U6KFCAYtgfxbXNA3n/pe6PkgZWvP+2Uf2k=;
        b=fnWuBB/VKKvOH9nnukn+9qwZdSnVUlnjjjyUgD+FLWt/Jb/w06I8Mc5GeiEEMHKyX50sPa
        4A6CVi1HXfBi7j/qnJIXEJOl0AQvY3DqhRkbm9Ep4N+nybhT9uQCIPoC1PXRlOiM6pF/pp
        4cAWKqB84Cmfc4f51p3AICdFvkLyTOM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-tnk1E8rbNdeCSTS7qNJYmQ-1; Fri, 27 Jan 2023 06:08:08 -0500
X-MC-Unique: tnk1E8rbNdeCSTS7qNJYmQ-1
Received: by mail-ej1-f71.google.com with SMTP id ds1-20020a170907724100b008775bfcef62so3198246ejc.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKPEQeD05U6KFCAYtgfxbXNA3n/pe6PkgZWvP+2Uf2k=;
        b=I+Ny7J7Wo7nmAhQ1R8sXB74vDIMRUXk5rV2p+YUnz90fMwkVIZVzyy+ilhEYy+WdUV
         AsTBDZ8RTCL1HedVdlUnkiWjif4Z0GqgxKAwz90kGByEVP23TEA2qZGBrc6no/gn6jmc
         8QTz8tkBluB/RrGccaEyP5JfMMJajDHw/K6Vp1oR1HJoj76X2Z1hgkaLtB4oYqAoCYLl
         N0oyVJjB8WejcXTUfbtKWY+Ez8aXy4cz7k3hWOYKLjj9ALspkrUaCbOZGCXbNHKqUhkV
         Cd2krZGpvpPU9n+LRzkT5MqPV2tN4IYUc9pQn+pov88bLPwF0OlV31aBUiQMNH4zE3Cq
         uUUA==
X-Gm-Message-State: AFqh2kpL/yGUa/idqvzA2x8XmlNo19kpvsPzPRXYMyHPtFX7xodd+7lW
        faD+Uhprzj4RFy5KLjPfwKiKVHMJDYmc0RKtbS084vMK77i273tRmIEUOS7/bOI3nCoD3tmTdn6
        hlqzEylvGftg5eHb2
X-Received: by 2002:a17:907:8a07:b0:7c1:5ee1:4c57 with SMTP id sc7-20020a1709078a0700b007c15ee14c57mr48312978ejc.8.1674817686728;
        Fri, 27 Jan 2023 03:08:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtEZ9qSwCeJX4118ylH95WPKVKjIFX0j4DWxndoYOi4bwRVWxwjupfV2ZGS4Sf/mhJEOQy+Mg==
X-Received: by 2002:a17:907:8a07:b0:7c1:5ee1:4c57 with SMTP id sc7-20020a1709078a0700b007c15ee14c57mr48312963ejc.8.1674817686493;
        Fri, 27 Jan 2023 03:08:06 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id m5-20020aa7c485000000b0049e19136c22sm2120592edq.95.2023.01.27.03.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:08:05 -0800 (PST)
Date:   Fri, 27 Jan 2023 06:08:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2 1/1] virtio_net: notify MAC address change on device
 initialization
Message-ID: <20230127060453-mutt-send-email-mst@kernel.org>
References: <20230123120022.2364889-1-lvivier@redhat.com>
 <20230123120022.2364889-2-lvivier@redhat.com>
 <20230124024711-mutt-send-email-mst@kernel.org>
 <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 12:04:24PM +0100, Laurent Vivier wrote:
> On 1/24/23 11:15, Michael S. Tsirkin wrote:
> > On Mon, Jan 23, 2023 at 01:00:22PM +0100, Laurent Vivier wrote:
> > > In virtnet_probe(), if the device doesn't provide a MAC address the
> > > driver assigns a random one.
> > > As we modify the MAC address we need to notify the device to allow it
> > > to update all the related information.
> > > 
> > > The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> > > assign a MAC address by default. The virtio_net device uses a random
> > > MAC address (we can see it with "ip link"), but we can't ping a net
> > > namespace from another one using the virtio-vdpa device because the
> > > new MAC address has not been provided to the hardware.
> > 
> > And then what exactly happens? Does hardware drop the outgoing
> > or the incoming packets? Pls include in the commit log.
> 
> I don't know. There is nothing in the kernel logs.
> 
> The ping error is: "Destination Host Unreachable"
> 
> I found the problem with the mlx5 driver as in "it doesn't work when MAC
> address is not set"...
> 
> Perhaps Eli can explain what happens when the MAC address is not set?
> 
> > 
> > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > > ---
> > >   drivers/net/virtio_net.c | 14 ++++++++++++++
> > >   1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7723b2a49d8e..4bdc8286678b 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >   		eth_hw_addr_set(dev, addr);
> > >   	} else {
> > >   		eth_hw_addr_random(dev);
> > > +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> > > +			 dev->dev_addr);
> > >   	}
> > >   	/* Set up our device-specific information */
> > > @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >   	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
> > >   		 dev->name, max_queue_pairs);
> > > +	/* a random MAC address has been assigned, notify the device */
> > > +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> > > +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> > 
> > Maybe add a comment explaining that we don't fail probe if
> > VIRTIO_NET_F_CTRL_MAC_ADDR is not there because
> > many devices work fine without getting MAC explicitly.
> 
> OK
> 
> > 
> > > +		struct scatterlist sg;
> > > +
> > > +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> > > +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> > > +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> > > +			dev_warn(&vdev->dev, "Failed to update MAC address.\n");
> > 
> > Here, I'm not sure we want to proceed. Is it useful sometimes?
> 
> I think reporting an error is always useful, but I can remove that if you prefer.

No the question was whether we should fail probe not
whether we print the warning.


> > I note that we deny with virtnet_set_mac_address.
> > 
> > > +		}
> > > +	}
> > > +
> > >   	return 0;
> > 
> > 
> > 
> > Also, some code duplication with virtnet_set_mac_address here.
> > 
> > Also:
> > 	When using the legacy interface, \field{mac} is driver-writable
> > 	which provided a way for drivers to update the MAC without
> > 	negotiating VIRTIO_NET_F_CTRL_MAC_ADDR.
> > 
> > How about factoring out code in virtnet_set_mac_address
> > and reusing that?
> > 
> 
> In fact, we can write in the field only if we have VIRTIO_NET_F_MAC
> (according to virtnet_set_mac_address(), and this code is executed only if
> we do not have VIRTIO_NET_F_MAC. So I think it's better not factoring the
> code as we have only the control queue case to manage.
> 
> > This will also handle corner cases such as VIRTIO_NET_F_STANDBY
> > which are not currently addressed.
> 
> F_STANDBY is only enabled when virtio-net device MAC address is equal to the
> VFIO device MAC address, I don't think it can be enabled when the MAC
> address is randomly assigned (in this case it has already failed in
> net_failover_create(), as it has been called using the random mac address),
> it's why I didn't check for it.

But the spec did not say there's a dependency :(.
My point is what should we do if there's F_STANDBY but no MAC?
Maybe add a separate patch clearing F_STANDBY in this case?

> > 
> > 
> > >   free_unregister_netdev:
> > > -- 
> > > 2.39.0
> > 
> 
> Thanks,
> Laurent

