Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4858669AB58
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBQMW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBQMW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:22:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1C966046
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676636528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VbZ6lg0zzAJJ7VsgOJE+0XQphc+KxOOGhEwY/SdO60g=;
        b=hfJbQq4iswBoTepmiodSMjFBbaCh6+NKkw3UIEBUqWH+LS/ZKYQ86+b1jfyGZqn0aBvYeU
        lFlDv/ETHl11PAKCQsq6wqqR7qJgzz2w13LaryHOLYZTL/G+GML1bU1asDAVGgorqJ/s7R
        08yC8gyiNfnj2Zh3JOhV4ksod7eEPmM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-492-CAGojjAcOxiuSQWIYRj4Ig-1; Fri, 17 Feb 2023 07:22:07 -0500
X-MC-Unique: CAGojjAcOxiuSQWIYRj4Ig-1
Received: by mail-wr1-f69.google.com with SMTP id s5-20020a5d6a85000000b002bfda39265aso118211wru.13
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:22:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbZ6lg0zzAJJ7VsgOJE+0XQphc+KxOOGhEwY/SdO60g=;
        b=ulvLw+LbeHIWFQ2yDr2HUNOVLMpL/0zUV7Bs45n1j7dYnaloDnYT0KKieTCWXQkIAF
         RzxxDbpswTQ86pEh7bOhzMJX1nirsomlzMrcYaUOZsc8/OyKUYX9nCcS9vVR1LKzwEEW
         BRpILC/UAIyf+KuRO6zY8oaF9X9KG7ovZ2ipuYP0/hdU90I5RsXznLd0bFT7xDaqiQHO
         36ERKsvWzOxDFNc/kcRjR1c+JwhtVfuXCnIIS1SJt9rerts73XP7gItzwUoije3xF5t6
         /2sI/2ENygW73nYfSEZwahCoBHLTyv3fQCIt5pYLhSyuxa9k3FaoqHENQfwcUb6o189J
         +PRg==
X-Gm-Message-State: AO0yUKUeoZhza4nj3qKYMpPWl31fpc0rOcZ/HOGzfElvxo3N2oU3HKuB
        1GSvwZ/wpGFlyFSMoGFKibWgdR/9vrtdgwlahXPI3jhhIX2EwGoCmiFT1JXaQH9oy+NvPA1lgv+
        8J3YEgW4Z3NCy0VYp
X-Received: by 2002:a05:600c:4b1b:b0:3df:fbc7:5b10 with SMTP id i27-20020a05600c4b1b00b003dffbc75b10mr341760wmp.0.1676636526333;
        Fri, 17 Feb 2023 04:22:06 -0800 (PST)
X-Google-Smtp-Source: AK7set9UTlL1W3RpGlRDPzUeP/pLLVc4PJU4+6e4Mtuwsp+LiTCnneeWPFlM/Gc64uI/ChZO+yqEkA==
X-Received: by 2002:a05:600c:4b1b:b0:3df:fbc7:5b10 with SMTP id i27-20020a05600c4b1b00b003dffbc75b10mr341749wmp.0.1676636526051;
        Fri, 17 Feb 2023 04:22:06 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id ay38-20020a05600c1e2600b003dff870ce0esm723720wmb.2.2023.02.17.04.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 04:22:05 -0800 (PST)
Date:   Fri, 17 Feb 2023 07:22:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <20230217072032-mutt-send-email-mst@kernel.org>
References: <20230217121547.3958716-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217121547.3958716-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> 
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that the driver provides the exact size of the header.
> 
> The driver already complies to fill the correct value. Introduce the
> feature and advertise it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Could you add a bit of motivation just for the record?
Does this improve performance for some card? By how much?
Expected to help some future card?

thanks!


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

