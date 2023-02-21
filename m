Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572B269E358
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbjBUP07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjBUP06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:26:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CBA2A981
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:26:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e5so6455606plg.8
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CEBQYFfz8u1AQ/qusEQlYsB5MIzDcptJm3TnGtSX42M=;
        b=ganXHfcsHc1FLGIm1FbFzKTNHXRPhCgH9k4aSTvgxxXPEtvDtIL5Gno0e4Du667/wn
         0g1TugteC6QFgAAzMbrQrDHZYw6hf6mElcJ4FNSKzQ4idls6Ys3UIzMT3ShAni7PHNQQ
         lA55rflyFv9EbcbWnsoEVHF0/zGnNVAb14eS1OLUOtrGbY84y17lRiPqrPZN++TlS2d7
         aDKYriyo6FWfkHAT5Od5SSyO4tQFb2vlhKUbyHS92lG+f7asbS5pZcb/WcJzQ43/GD7k
         pAldqMBgElL8Tj6ofNihxl52LhazIPkPpH/Hs+//hl6DGHl329HcpWcZT9TtsG4O+3tO
         rbbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CEBQYFfz8u1AQ/qusEQlYsB5MIzDcptJm3TnGtSX42M=;
        b=Lmy5H4rZ20LYaWmTyRSjaFQdEe8eDWM9mRvgm1J5514xwTSJDO9DSbbIMA604So9Dr
         TOeleMkOywFj1EbqCTSCiNeeUyJhaRZqNWWW0tQc+QKu7Ho35CB3YfOEfRo5t7GbOeqF
         Hj3FMpJNf0fZvz1cYLAduqNGmBE36WUmNz3eImJ0/NuyqawUhQf2+R06+PcUbvcoSkdD
         wTifCOlRpyMnPDuaaJUMquaH7d/c54sRztYAyvNO4m8qYpdMQG9O5dBcoeDnS+MKySEL
         ssEHCb1BMMn/opiEW8wya+WIx1q6rIW3anKPV3slD52XE+OAFsvFgOubxJHNBYAjCdlG
         DMNw==
X-Gm-Message-State: AO0yUKVXlir8NFSPGJcTpf8oRJiQ6TyX7tfMfc8B0sR4QZInOTnzVWEi
        wo/utFQfKylfB9IyFSYqSl7SxOuXgz+8hAUEyWGeUg==
X-Google-Smtp-Source: AK7set/qHTpAvHhp8PD1WmOrzerofi/YjEjmRzdSlSv29jiMeyxbdKlgxlSYSlQmd118whC13xVGKzd2fpwhr8zKhVo=
X-Received: by 2002:a17:90b:3912:b0:233:f53f:95eb with SMTP id
 ob18-20020a17090b391200b00233f53f95ebmr1575044pjb.51.1676993215734; Tue, 21
 Feb 2023 07:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20230221144741.316477-1-jiri@resnulli.us>
In-Reply-To: <20230221144741.316477-1-jiri@resnulli.us>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 21 Feb 2023 17:26:19 +0200
Message-ID: <CAJs=3_Aqy25Xnm3fNV7A2Xz6uN9vdKGXE9w5Zg99fb0HgpbZnQ@mail.gmail.com>
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        vmireyno@marvell.com, parav@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> From: Jiri Pirko <jiri@nvidia.com>
>
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that the driver provides the exact size of the header.
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
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
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
>         VIRTIO_NET_F_GUEST_UFO,
>         VIRTIO_NET_F_GUEST_CSUM,
>         VIRTIO_NET_F_GUEST_USO4,
> -       VIRTIO_NET_F_GUEST_USO6
> +       VIRTIO_NET_F_GUEST_USO6,
> +       VIRTIO_NET_F_GUEST_HDRLEN
>  };
>
>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>         VIRTIO_NET_F_CTRL_MAC_ADDR, \
>         VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>         VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> +       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> +       VIRTIO_NET_F_GUEST_HDRLEN
>
>  static unsigned int features[] = {
>         VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index b4062bed186a..12c1c9699935 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -61,6 +61,7 @@
>  #define VIRTIO_NET_F_GUEST_USO6        55      /* Guest can handle USOv6 in. */
>  #define VIRTIO_NET_F_HOST_USO  56      /* Host can handle USO in. */
>  #define VIRTIO_NET_F_HASH_REPORT  57   /* Supports hash report */
> +#define VIRTIO_NET_F_GUEST_HDRLEN  59  /* Guest provides the exact hdr_len value. */
>  #define VIRTIO_NET_F_RSS         60    /* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT     61    /* extended coalescing info */
>  #define VIRTIO_NET_F_STANDBY     62    /* Act as standby for another device
> --
> 2.39.0
>

This indeed saves some cycles in our device.
Thanks!

Reviewed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
