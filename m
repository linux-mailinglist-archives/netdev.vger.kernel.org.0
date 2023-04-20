Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CE06E88F9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 06:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjDTEHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 00:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDTEHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 00:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468E8E63
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 21:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681963592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l+PcrQmhA5a7Qy66EfXDRyvtBeGDrU5rKrslFVh6JTc=;
        b=GuSAyORaSXZyuhLQJAlkdgAqbc4cJCyRwIzZdfKuG7XRDlzx1GEdhtpXpuIGD8BOzmUdn+
        JkJ7NMmgZ7gwJVmHPPSiUdlrKcZDuKQ5xmbnfASrP5A91Pk1Mxr/XAc/nInExoa9OSHW8w
        bkYXSYS/9XO8ggOt65mfx4e9/iUIVb0=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-_93Kbrv5Ng-nuOxx4YblAQ-1; Thu, 20 Apr 2023 00:06:30 -0400
X-MC-Unique: _93Kbrv5Ng-nuOxx4YblAQ-1
Received: by mail-ot1-f71.google.com with SMTP id a3-20020a9d5c83000000b006a5dd7df178so33115oti.13
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 21:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681963589; x=1684555589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+PcrQmhA5a7Qy66EfXDRyvtBeGDrU5rKrslFVh6JTc=;
        b=k6qCoQLdlauNEPRnQoTmeogYAaFxVyjOJwJHj3TeDalfuYuffHrhNB8wzVcF+JrJG5
         o2HHWUw3Es6ah7gU8ROnnTsdR+Ip9LQ5qI5f3owsN3kaft1GeVhAh40C6PcBFGgRxqbd
         kWeJ79m9GALAlED0KJWxiT96KyFxj0xnL4hvHQTqGo3Oo2iETAUFuhBxRiQ+l+7i4XTo
         KykNhYOkv8bS54yB0w6tzJBGND3jOfYJ2D/ZQGDpLXcibCUbK+I+5V/vUwVuPVbVCB36
         lR1xT+MiKTqXfb2Xz2ueZf3XjV/wT6Yy4Zy0KN8xHR8aC9/r43REM+wa60JOH4Rq0Buh
         l4iQ==
X-Gm-Message-State: AAQBX9cmWStvA4cpJUaa85gvfSVj6Vo0MRtlD9ZjBVlD1qIHSHnUSArD
        twxcUK0mWVmry+bsZzNgRZm7GdxMf5Fip3XpIK8OeVKYY2QITchD1qpAIgMGwmBMMDYAD5l/9Od
        pwOMft9o05UYMc32PyXfRezTIMuRNzX3Y
X-Received: by 2002:a4a:4fc5:0:b0:545:c9f3:3aa7 with SMTP id c188-20020a4a4fc5000000b00545c9f33aa7mr231991oob.3.1681963589488;
        Wed, 19 Apr 2023 21:06:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350almE7OZ2hK3i9wG2F1V/HOEwI3f3+Wk4eBkkfDJJpZ3JxHt5qBliBBQkn1VfqZwPfdNNE8xFhWXkirCdQALzI=
X-Received: by 2002:a4a:4fc5:0:b0:545:c9f3:3aa7 with SMTP id
 c188-20020a4a4fc5000000b00545c9f33aa7mr231983oob.3.1681963589276; Wed, 19 Apr
 2023 21:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com> <20230419134329.346825-2-maxime.coquelin@redhat.com>
In-Reply-To: <20230419134329.346825-2-maxime.coquelin@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 12:06:18 +0800
Message-ID: <CACGkMEtooodqB9pSGTQJx4x55-+RqPhNhT5_4zSDMiCSJXyjVg@mail.gmail.com>
Subject: Re: [RFC 1/2] vduse: validate block features only with block devices
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     xieyongji@bytedance.com, mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 9:43=E2=80=AFPM Maxime Coquelin
<maxime.coquelin@redhat.com> wrote:
>
> This patch is preliminary work to enable network device
> type support to VDUSE.
>
> As VIRTIO_BLK_F_CONFIG_WCE shares the same value as
> VIRTIO_NET_F_HOST_TSO4, we need to restrict its check
> to Virtio-blk device type.
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index 0c3b48616a9f..6fa598a03d8e 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1416,13 +1416,14 @@ static bool device_is_allowed(u32 device_id)
>         return false;
>  }
>
> -static bool features_is_valid(u64 features)
> +static bool features_is_valid(struct vduse_dev_config *config)
>  {
> -       if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
> +       if (!(config->features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
>                 return false;
>
>         /* Now we only support read-only configuration space */
> -       if (features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE))
> +       if ((config->device_id =3D=3D VIRTIO_ID_BLOCK) &&
> +                       (config->features & (1ULL << VIRTIO_BLK_F_CONFIG_=
WCE)))

The reason we filter WCE out is to avoid writable config space which
might block the driver with a buggy userspace.

For networking, I guess we should fail if VERSION_1 is not negotiated,
then we can avoid setting mac addresses via the config space.

Thanks

>                 return false;
>
>         return true;
> @@ -1446,7 +1447,7 @@ static bool vduse_validate_config(struct vduse_dev_=
config *config)
>         if (!device_is_allowed(config->device_id))
>                 return false;
>
> -       if (!features_is_valid(config->features))
> +       if (!features_is_valid(config))
>                 return false;
>
>         return true;
> --
> 2.39.2
>

