Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E837169F36B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 12:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjBVLZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 06:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjBVLZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 06:25:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D563402D
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677065066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RuR991O3W89jniq0oLJ77ACUn68KcHgToD/Kc8DJ8E8=;
        b=hKji0l1X1YjgyEJ4dDyqhOan8+tMX21Ndhj4q/J1NHMn/PEi5WOY56PDkvNpC8s5iAAxQa
        TYkej261gtjzr9iHUcoakvqmfLONTS0RLGzt/36Qosi9yIHpUXVh3vRCbkK1TU4RQKJvbE
        bGDLAykwuPRuBSKW5xPubuz1AQPgv28=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-Rn2vsnvhPRO6RJcKnGU9Dg-1; Wed, 22 Feb 2023 06:24:25 -0500
X-MC-Unique: Rn2vsnvhPRO6RJcKnGU9Dg-1
Received: by mail-wm1-f69.google.com with SMTP id k20-20020a05600c1c9400b003e2249bd2b4so3404202wms.5
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:24:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuR991O3W89jniq0oLJ77ACUn68KcHgToD/Kc8DJ8E8=;
        b=mpfj2I+Q1YXR/HhBopVRF0yqCz6Zrmwj+lNgqhGIXeOpINZBabJ1+o2F9bGU62cqu5
         AQSdtQgWSr55isi43eBj6nkWkZ25/AuEzmGOD63otl+jsQg4+iayU5U1sUEQFkSrGFjn
         dZzTbvc7OifWaQnayUrsqHiHraMO9AM4AgCcc4la/hV3nXNmDlsKSwFqBs6GGu1WPoJK
         GPVhCVG+ZVRzlC3U8/E1G23/eOcLgZoix1KVJnVol1faH6ZA4JKDYNbk98VpI0W3hlOt
         CplnroPHBDjyGPOyCO8hDJi5WGKMq5iio6cfq2N/7fYrS71P8Y6zIisEzUbocFTZsUeY
         acYA==
X-Gm-Message-State: AO0yUKV1rXcELpSjMpzeTUDJKv0clfQ1cvb7QDQLG8kBo98VEtGKs3XJ
        7KwGtGs6Zh4F/ABZXStOo3Ks3/H62LsmEgzbXpm7/2r3diE9tu93wxtpkb3j5VevGFB5jyZFbKO
        nAZVatR/25UiC7XQf
X-Received: by 2002:a5d:554c:0:b0:2c5:9c7a:86a with SMTP id g12-20020a5d554c000000b002c59c7a086amr5776172wrw.22.1677065064442;
        Wed, 22 Feb 2023 03:24:24 -0800 (PST)
X-Google-Smtp-Source: AK7set9ej0HSttfykbZ7EUBVAJC2Ml1o3MpEJH7HI5jIlYzxKjA5zFnJ0+TPjcZnlb2Qi2pgPhlW6A==
X-Received: by 2002:a5d:554c:0:b0:2c5:9c7a:86a with SMTP id g12-20020a5d554c000000b002c59c7a086amr5776148wrw.22.1677065064080;
        Wed, 22 Feb 2023 03:24:24 -0800 (PST)
Received: from redhat.com ([2.52.2.78])
        by smtp.gmail.com with ESMTPSA id c15-20020adfef4f000000b002c54c9bd71fsm5007564wrp.93.2023.02.22.03.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 03:24:22 -0800 (PST)
Date:   Wed, 22 Feb 2023 06:24:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [patch net-next v3] net: virtio_net: implement exact header
 length guest feature
Message-ID: <20230222062208-mutt-send-email-mst@kernel.org>
References: <20230222080638.382211-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222080638.382211-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 09:06:38AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> which when 

which when which when is probably unintentional :)

>set implicates that device benefits from knowing the exact
> size of the header. For compatibility, to signal to the device that
> the header is reliable driver also needs to set this feature.
> Without this feature set by driver, device has to figure
> out the header size itself.
> 
> Quoting the original virtio spec:
> "hdr_len is a hint to the device as to how much of the header needs to
>  be kept to copy into each packet"
> 
> "a hint" might not be clear for the reader what does it mean, if it is
> "maybe like that" of "exactly like that". This feature just makes it
> crystal clear and let the device count on the hdr_len being filled up
> by the exact length of header.
> 
> Also note the spec already has following note about hdr_len:
> "Due to various bugs in implementations, this field is not useful
>  as a guarantee of the transport header size."
> 
> Without this feature the device needs to parse the header in core
> data path handling. Accurate information helps the device to eliminate
> such header parsing and directly use the hardware accelerators
> for GSO operation.
> 
> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> The driver already complies to fill the correct value. Introduce the
> feature and advertise it.
> 
> Note that virtio spec also includes following note for device
> implementation:
> "Caution should be taken by the implementation so as to prevent
>  a malicious driver from attacking the device by setting
>  an incorrect hdr_len."
> 
> There is a plan to support this feature in our emulated device.
> A device of SolidRun offers this feature bit. They claim this feature
> will save the device a few cycles for every GSO packet.
> 
> Link: https://docs.oasis-open.org/virtio/virtio/v1.2/cs01/virtio-v1.2-cs01.html#x1-230006x3
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> v2->v3:
> - changed the first paragraph in patch description according to
>   Michael's suggestion
> - added Link tag with link to the spec
> v1->v2:
> - extended patch description
> ---
>  drivers/net/virtio_net.c        | 6 ++++--
>  include/uapi/linux/virtio_net.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fb5e68ed3ec2..e85b03988733 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>  	VIRTIO_NET_F_GUEST_UFO,
>  	VIRTIO_NET_F_GUEST_CSUM,
>  	VIRTIO_NET_F_GUEST_USO4,
> -	VIRTIO_NET_F_GUEST_USO6
> +	VIRTIO_NET_F_GUEST_USO6,
> +	VIRTIO_NET_F_GUEST_HDRLEN
>  };
>  
>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> +	VIRTIO_NET_F_GUEST_HDRLEN
>  
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index b4062bed186a..12c1c9699935 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -61,6 +61,7 @@
>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
> -- 
> 2.39.0

