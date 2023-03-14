Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CF6B8916
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjCNDku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNDks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE9619F3F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678765195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KhYBy1SbrL35uZcxmV9N94m0DcgNaM+uqRNvBlRXOo=;
        b=PXxkpK9XrIAKlAAXdjb7p7PZa2EMiViPOpmzm3ohR1Uh7ARJEaHm7wLqN92F2Zci6nDJ1b
        MLnNSTk0nryczqFvyAYw7xE3LUt1L1jy3Lb/0vv8WKtPtZYS310Zr5eMW7aXfYhhUrGBkr
        ui3ddoFk0OOxgKxtc0Bu/dcyr9EYpWg=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-fCTshj7dNkuz5lSyEP6c7A-1; Mon, 13 Mar 2023 23:39:54 -0400
X-MC-Unique: fCTshj7dNkuz5lSyEP6c7A-1
Received: by mail-oi1-f200.google.com with SMTP id bp16-20020a056808239000b00384dfa31ab8so6248380oib.2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678765193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KhYBy1SbrL35uZcxmV9N94m0DcgNaM+uqRNvBlRXOo=;
        b=o2f5cFwhQFpN9Bori93I5L8hJeFQg+wVZUzDt9MUiug25xCNC+7WFmRnwUng0n5E4j
         WGrbAsnIO2ajhq/Yd9NugnjnX5L2HUOV+esj7KFfWWDEpayn8TK2fmyVUN4UOF5GdJvS
         XcBscHOawvrPaakIArK/lr73gqteQb4ESVGe7fzF9i1Hq0NLs29lDjOUzGVUVlh7TwIk
         eTWNnOUyjygBYWii6vp2Ff/BNVkGX6HnkNMuQydCyfyRXSKwk4IyYJwPYLzLYd7yOxDN
         CyybmhRjhpp/e++rWGwL1Ov864to60geXXE/sRzR0DhEnory8IjpzTdIYi6P7viAX8Gd
         FEdA==
X-Gm-Message-State: AO0yUKWluyG5G8ljYcRrok7UeIfM4VyM3+be6RkW4W7IxP9vHhEw/mPX
        lZamAoAETTRppbvjj5FVs8GakC14UH3djGs8BSoIm0W4SV1JoF+sFP9aQm6h1owAUv/RykKq3Ow
        s6l8OsNOzfNq3kkuV0cT3tiTEBMkMj3XaxUq3G0sL7SITPg==
X-Received: by 2002:a05:6871:2315:b0:177:c2fb:8cec with SMTP id sf21-20020a056871231500b00177c2fb8cecmr1799902oab.9.1678765193340;
        Mon, 13 Mar 2023 20:39:53 -0700 (PDT)
X-Google-Smtp-Source: AK7set+cFgrKo8wDV2ck1Qw5dHYFA97psqjJwMF030XPXaImHObBym9NO6DrXVSlK3PnFCXSfBC5voQVIZy0kLV1jCI=
X-Received: by 2002:a05:6871:2315:b0:177:c2fb:8cec with SMTP id
 sf21-20020a056871231500b00177c2fb8cecmr1799898oab.9.1678765193106; Mon, 13
 Mar 2023 20:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-2-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 11:39:42 +0800
Message-ID: <CACGkMEv24Zw-OUbBBSne21pF7=4XCZ6JGj7Y_cC7cMFYTjbF1Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] vdpa: add bind_mm/unbind_mm callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> These new optional callbacks is used to bind/unbind the device to
> a specific address space so the vDPA framework can use VA when
> these callbacks are implemented.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---

One thing that came into my mind is that after this commit:

commit 5ce995f313ce56c0c62425c3ddc37c5c50fc33db
Author: Jason Wang <jasowang@redhat.com>
Date:   Fri May 29 16:02:59 2020 +0800

    vhost: use mmgrab() instead of mmget() for non worker device

    For the device that doesn't use vhost worker and use_mm(), mmget() is
    too heavy weight and it may brings troubles for implementing mmap()
    support for vDPA device.

We don't hold the address space after this commit, so the userspace
mapping could be invalid if the owner exits?

Thanks

>
> Notes:
>     v2:
>     - removed `struct task_struct *owner` param (unused for now, maybe
>       useful to support cgroups) [Jason]
>     - add unbind_mm callback [Jason]
>
>  include/linux/vdpa.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 43f59ef10cc9..369c21394284 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -290,6 +290,14 @@ struct vdpa_map_file {
>   *                             @vdev: vdpa device
>   *                             @idx: virtqueue index
>   *                             Returns pointer to structure device or er=
ror (NULL)
> + * @bind_mm:                   Bind the device to a specific address spa=
ce
> + *                             so the vDPA framework can use VA when thi=
s
> + *                             callback is implemented. (optional)
> + *                             @vdev: vdpa device
> + *                             @mm: address space to bind
> + * @unbind_mm:                 Unbind the device from the address space
> + *                             bound using the bind_mm callback. (option=
al)
> + *                             @vdev: vdpa device
>   * @free:                      Free resources that belongs to vDPA (opti=
onal)
>   *                             @vdev: vdpa device
>   */
> @@ -351,6 +359,8 @@ struct vdpa_config_ops {
>         int (*set_group_asid)(struct vdpa_device *vdev, unsigned int grou=
p,
>                               unsigned int asid);
>         struct device *(*get_vq_dma_dev)(struct vdpa_device *vdev, u16 id=
x);
> +       int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm);
> +       void (*unbind_mm)(struct vdpa_device *vdev);
>
>         /* Free device resources */
>         void (*free)(struct vdpa_device *vdev);
> --
> 2.39.2
>

