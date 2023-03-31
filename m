Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EF6D1BDE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjCaJTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaJTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3A71BFD
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjF7kg5QmZ1/qJ69Al0S1LwU0awEPb7/otJ5sPvHIVM=;
        b=Yl7wUrumcW14cnJrDdhoMa7ritqV9DYboJ3f9wIjugD37OaRW1UydcNiLIHJC7owNxV0pu
        H+MhA/O+2qMZ7MSmS/G4AyxfYvjQ+pnZ4jUxY93lDQFEoBHg1wPd9OYvcPqfFQpx5Yk7Kw
        zGfGREzk18XvVzBHAv+sh5A9itPJWeA=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-AsGoMb2DMICPwzcwH4hDTQ-1; Fri, 31 Mar 2023 05:18:36 -0400
X-MC-Unique: AsGoMb2DMICPwzcwH4hDTQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17fd0d597dcso3793563fac.6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680254315; x=1682846315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjF7kg5QmZ1/qJ69Al0S1LwU0awEPb7/otJ5sPvHIVM=;
        b=ONqhdE0E093D+3jecx0tOGllL9huZFKKt1NR/91CTU2HR1KQ8avtXJA7aox89dXou0
         Ka6nIE8lhV6NUR2qjCrnfd/8i7OzIyc5XtmIVk5HZAyF4lf9265STKi0cwNnRav+fSip
         uGdVTbGlm/NYUAI2XtJBCHadhbB7yzcMfb+8bAhjkK7PWEWx3dOQiqBbl+zYgMUElwpB
         rs1ohrEBYOQdATztnSOA83aV9jMSuTybOpzJHfM0g3oX6HRAOtuL+8C8ZjwTSkITacIM
         bLMPMBLUoirnywJlFIIXS9AZtARsTjhDPOjTaBItQWfZjplnb7d70MkMk5Hz48S2tx04
         L0ag==
X-Gm-Message-State: AAQBX9emW6PyjfwQ6kj6mwC+zPKitryzx1kt3MC80658yUWkhEhP9c6M
        wTIKKLMvSjyojerx5/JOkuDlvFp37CwQZ3lPxxbIu0Pu4rGkQusGREjoXHkiDLatiVh33z0m+iu
        0U1D2GU9KcYO3tnujtAIJBADaD+SmJHfpFurfOwodXFULYA==
X-Received: by 2002:a05:6870:8310:b0:177:c2fb:8cec with SMTP id p16-20020a056870831000b00177c2fb8cecmr10256790oae.9.1680254315578;
        Fri, 31 Mar 2023 02:18:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set8h/g9cwwlFDEN3CpISOrlwRlyD8WoPl87WsZC7TGG3Rc64PVQuD9PxGq42lxRD587X8v/3rvk9TjWgnzfbZZE=
X-Received: by 2002:a05:6870:8310:b0:177:c2fb:8cec with SMTP id
 p16-20020a056870831000b00177c2fb8cecmr10256789oae.9.1680254315408; Fri, 31
 Mar 2023 02:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org> <20230331-vhost-fixes-v1-3-1f046e735b9e@kernel.org>
In-Reply-To: <20230331-vhost-fixes-v1-3-1f046e735b9e@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 31 Mar 2023 17:18:24 +0800
Message-ID: <CACGkMEu-0=-Kfw28BfxTWSWZ2Dwov_0NJMOxbh4n-=e2RU2x7Q@mail.gmail.com>
Subject: Re: [PATCH vhost 3/3] MAINTAINERS: add vringh.h to Virtio Core and
 Net Drivers
To:     Simon Horman <horms@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 4:59=E2=80=AFPM Simon Horman <horms@kernel.org> wro=
te:
>
> vringh.h doesn't seem to belong to any section in MAINTAINERS.
> Add it to Virtio Core and Net Drivers, which seems to be the most
> appropriate section to me.
>
> Signed-off-by: Simon Horman <horms@kernel.org>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 91201c2b8190..7cf548302c56 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22095,6 +22095,7 @@ F:      drivers/vdpa/
>  F:     drivers/virtio/
>  F:     include/linux/vdpa.h
>  F:     include/linux/virtio*.h
> +F:     include/linux/vringh.h
>  F:     include/uapi/linux/virtio_*.h
>  F:     tools/virtio/
>
>
> --
> 2.30.2
>

