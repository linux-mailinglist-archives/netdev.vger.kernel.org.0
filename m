Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A06A6EAE
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCAOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCAOpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:45:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347F92CFD2
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 06:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677681856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E86jCb8kW1PzrvPSO5dVoBke0amKLBuYHjvi+nJQr9o=;
        b=bTk2IXxjyM8H25glC8AUnI8Nvf7PrGOtJM0U4bFXTraGafQvNNnwqGKMD68lNez2cjCeuD
        b0xuj84RHxU8q8eLhCZzTn2uD+C8RuDKf3BCnYjD60hYCrDECSiRRdEPN4ZS1cEa7wspr2
        oFpOBKMeBwtdnl4AOUlSDrmVrxG+hEA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-P-tW0JuNMayp8vgBLodOZQ-1; Wed, 01 Mar 2023 09:44:15 -0500
X-MC-Unique: P-tW0JuNMayp8vgBLodOZQ-1
Received: by mail-wm1-f71.google.com with SMTP id az12-20020a05600c600c00b003e8910ec2fdso4643270wmb.6
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 06:44:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677681854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E86jCb8kW1PzrvPSO5dVoBke0amKLBuYHjvi+nJQr9o=;
        b=sUM1B60YnSdzXjnZ5gY0cDLlhPLT/tNiDdoC7ganESebIURQRq8ePfFxFzBoufFrNV
         2+IYXJQmsQt71OST2RcWEZxrOg+wsMkHAkoVUrm1ZFyk6MX1XZbDXKMXRpCLG7tdz8Lh
         XukFzAjkaSfKoDvEePPMZ1uEAl1rwBUGk1E/aPpcpKDQGhs8pn9902LZFv7RqmURKv8/
         6eAGwNmL+jzF35LWw6SBFEnFgx0nb4d5O1Xt5YVzfOJnpVsHxnRBveiKHFjz+Amb8vUv
         hxcbzVvaYFWQLsB5V77fRsLYpnkrpv2ULzuUdu8ZQ/7nOqKRFbnBf3pZ/dMu09HXSQkE
         fPvw==
X-Gm-Message-State: AO0yUKXJQMFcrOVjYqgoWjTBf9zDSRy2Sva/Xqr9a8ig80Fpbs43YwxM
        Y9evXG5L8UpKo9yaMu0h2aSZEEzrm2TaRKftNevAmXnFitcteY4OVGqpU34JMiA1PHiHBsiembA
        /Zk7E6jcr7acg4WOp
X-Received: by 2002:a5d:6e09:0:b0:2c7:5247:e496 with SMTP id h9-20020a5d6e09000000b002c75247e496mr5056892wrz.60.1677681854203;
        Wed, 01 Mar 2023 06:44:14 -0800 (PST)
X-Google-Smtp-Source: AK7set8mSY3e1Y8uBNg7J/umChcu632unCjyUQQS2o6WA2kpSEr1P+PNtHKwqRrvNwfJaKiCprzfMA==
X-Received: by 2002:a5d:6e09:0:b0:2c7:5247:e496 with SMTP id h9-20020a5d6e09000000b002c75247e496mr5056875wrz.60.1677681853859;
        Wed, 01 Mar 2023 06:44:13 -0800 (PST)
Received: from redhat.com ([2.52.141.194])
        by smtp.gmail.com with ESMTPSA id t14-20020adfe44e000000b002c5503a8d21sm13145104wrm.70.2023.03.01.06.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 06:44:13 -0800 (PST)
Date:   Wed, 1 Mar 2023 09:44:09 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     rbradford@rivosinc.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio-net: Fix probe of virtio-net on kvmtool
Message-ID: <20230301093054-mutt-send-email-mst@kernel.org>
References: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 01:59:52PM +0000, Rob Bradford via B4 Relay wrote:
> From: Rob Bradford <rbradford@rivosinc.com>
> 
> Since the following commit virtio-net on kvmtool has printed a warning
> during the probe:
> 
> commit dbcf24d153884439dad30484a0e3f02350692e4c
> Author: Jason Wang <jasowang@redhat.com>
> Date:   Tue Aug 17 16:06:59 2021 +0800
> 
>     virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
> 
> [    1.865992] net eth0: Fail to set guest offload.
> [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wanted 0x0000000000134829, left 0x0080000000134829
> 
> This is because during the probing the underlying netdev device has
> identified that the netdev features on the device has changed and
> attempts to update the virtio-net offloads through the virtio-net
> control queue. kvmtool however does not have a control queue that supports
> offload changing (VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is not advertised)
> 
> The netdev features have changed due to validation checks in
> netdev_fix_features():
> 
> if (!(features & NETIF_F_RXCSUM)) {
> 	/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
> 	 * successfully merged by hardware must also have the
> 	 * checksum verified by hardware.  If the user does not
> 	 * want to enable RXCSUM, logically, we should disable GRO_HW.
> 	 */
> 	if (features & NETIF_F_GRO_HW) {
> 		netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
> 		features &= ~NETIF_F_GRO_HW;
> 	}
> }
> 
> Since kvmtool does not advertise the VIRTIO_NET_F_GUEST_CSUM feature the
> NETIF_F_RXCSUM bit is not present and so the NETIF_F_GRO_HW bit is
> cleared. This results in the netdev features changing, which triggers
> the attempt to reprogram the virtio-net offloads which then fails.
> 
> This commit prevents that set of netdev features from changing by
> preemptively applying the same validation and only setting
> NETIF_F_GRO_HW if NETIF_F_RXCSUM is set because the device supports both
> VIRTIO_NET_F_GUEST_CSUM and VIRTIO_NET_F_GUEST_TSO{4,6}
> 
> Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> ---
> Changes in v3:
> - Identified root-cause of feature bit changing and updated conditions
>   check
> - Link to v2: https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com
> 
> Changes in v2:
> - Use parentheses to group logical OR of features 
> - Link to v1:
>   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b9d7a@rivosinc.com
> ---
>  drivers/net/virtio_net.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 61e33e4dd0cd..2e7705142ca5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3778,11 +3778,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>  			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
>  		/* (!csum && gso) case will be fixed by register_netdev() */
>  	}
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM)) {
>  		dev->features |= NETIF_F_RXCSUM;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> -		dev->features |= NETIF_F_GRO_HW;
> +		/* This dependency is enforced by netdev_fix_features */
> +		if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +		    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> +			dev->features |= NETIF_F_GRO_HW;
> +	}
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
>  		dev->hw_features |= NETIF_F_GRO_HW;
>  

I see. It is annoying that we are duplicating the logic from
netdev_fix_features here though :(
Maybe we should call netdev_update_features, in the callback check
the flags and decide what to set and what to clear?
Or export netdev_fix_features to modules?



Also re-reading Documentation/networking/netdev-features.rst - 

 1. netdev->hw_features set contains features whose state may possibly
    be changed (enabled or disabled) for a particular device by user's
    request.  This set should be initialized in ndo_init callback and not
    changed later.

 2. netdev->features set contains features which are currently enabled
    for a device.  This should be changed only by network core or in
    error paths of ndo_set_features callback.


is it then wrong that virtio sets NETIF_F_RXCSUM and NETIF_F_GRO_HW in
dev->features and not in dev->hw_features? We set it there because
without ctrl guest offload these can not be changed.
I suspect this is just a minor documentation bug yes? Maybe devices
where features can't be cleared are uncommon.

Also:
        if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
                dev->hw_features |= NETIF_F_GRO_HW;

but should we not set NETIF_F_RXCSUM there too?



> ---
> base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
> change-id: 20230223-virtio-net-kvmtool-87f37515be22
> 
> Best regards,
> -- 
> Rob Bradford <rbradford@rivosinc.com>

