Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419126C5DC1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjCWEGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCWEGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A071BC2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 21:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679544317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOnNIGAilJ7fmmyy5EpSRdCYNuyde6MJKsXQO3HGUMs=;
        b=IasWpIaL+6ZGiFZ8D2mvReQTFbUImc6+w0G9ztbf7BmmdPRtnoDsrm77vUnWvuWq/0Ulmg
        B0doe3DEXzi+2/GQI4j2ciLoigAjMqD6syZ4aRnd6axgd7QRHTHV6Qw3I78m1KgOR6zHwB
        rUusRa48AALX/ODwSaU8tZ7s5GtZO6o=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-EI-Q976GMjmCEdiFC6FSMg-1; Thu, 23 Mar 2023 00:05:15 -0400
X-MC-Unique: EI-Q976GMjmCEdiFC6FSMg-1
Received: by mail-ot1-f72.google.com with SMTP id n19-20020a9d7413000000b0069f913914d8so2530228otk.5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 21:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679544315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOnNIGAilJ7fmmyy5EpSRdCYNuyde6MJKsXQO3HGUMs=;
        b=tcnqyFL9gRIC7iAJc+wE0Hh2uK67NmCPyAlhrCdbIIhNhs7l5Tq6wqdJ7hnIZ63ArO
         qSQCRxTqrctrVpsGkFHEdng91cyM6Wp0+9UPu4MsZpgO3rYNJkmkiLKdSBU0MHUPnt2K
         a2Pny8x1r8YJv9xCX+qRlEoHqZPospl+fuyG8kX16x6qmj4Zwg6D5+KO+fglxHpFfeFd
         VmE5UBEzYJVP94OA56iLiC0P/JL7aaNk9CjVkzCxD9Y2v7oiMuq4Sy4QmIVjovxGbjiw
         AXpCmVv91lI3gH5gNjUIC9BtSe72jf4AHLr5HXYOhV0wwIoFFODZRPHpOLPjgOCSjVeX
         Nywg==
X-Gm-Message-State: AO0yUKX0KgACdkp9F15kK4Lpcwe1JpKR6uZDVsoZmS6MN6l8V7oe3r/u
        MT0PXMSPLT0AOO61f/6G3bBytoatYcOXlUHiXsPkfjoAMQjq4ZDnqfxXdtm5MVtEFMu8S0b8g14
        NUDhRBhJCEg0G37ff0LFKKa6b36WrUfjv
X-Received: by 2002:a05:6871:4d10:b0:17a:d3d2:dc75 with SMTP id ug16-20020a0568714d1000b0017ad3d2dc75mr540507oab.3.1679544315250;
        Wed, 22 Mar 2023 21:05:15 -0700 (PDT)
X-Google-Smtp-Source: AK7set8FZEdSFvyHWpm4kjJu22TgDTHMafGQoxV36094gItSoHHuYJ036I/iI+eBjzGXAFHDuZI3p37rdKRjhcjHm+s=
X-Received: by 2002:a05:6871:4d10:b0:17a:d3d2:dc75 with SMTP id
 ug16-20020a0568714d1000b0017ad3d2dc75mr540500oab.3.1679544315023; Wed, 22 Mar
 2023 21:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-2-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-2-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 12:05:04 +0800
Message-ID: <CACGkMEvMvd9rwWZYTuc_gU1fSm8XPa=7=EOKjjzy7Mr=qEyqgA@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 1/8] virtio: allow caller to override device id
 and DMA mask
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
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

On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.=
com> wrote:
>
> To allow a bit of flexibility with various virtio based devices, allow
> the caller to specify a different device id and DMA mask.  This adds
> fields to struct XXX to specify an override device id check and a DMA mas=
k.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/virtio/virtio_pci_modern_dev.c | 36 +++++++++++++++++---------
>  include/linux/virtio_pci_modern.h      |  6 +++++
>  2 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virt=
io_pci_modern_dev.c
> index 869cb46bef96..6ad1bb9ae8fa 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -221,18 +221,25 @@ int vp_modern_probe(struct virtio_pci_modern_device=
 *mdev)
>
>         check_offsets();
>
> -       /* We only own devices >=3D 0x1000 and <=3D 0x107f: leave the res=
t. */
> -       if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> -               return -ENODEV;
> -
> -       if (pci_dev->device < 0x1040) {
> -               /* Transitional devices: use the PCI subsystem device id =
as
> -                * virtio device id, same as legacy driver always did.
> -                */
> -               mdev->id.device =3D pci_dev->subsystem_device;
> +       if (mdev->device_id_check_override) {
> +               err =3D mdev->device_id_check_override(pci_dev);
> +               if (err)
> +                       return err;
> +               mdev->id.device =3D pci_dev->device;

While at this, would it be better to let the device_id_check_override
to return the mdev->id.device ?

Others look good.

Thanks

>         } else {
> -               /* Modern devices: simply use PCI device id, but start fr=
om 0x1040. */
> -               mdev->id.device =3D pci_dev->device - 0x1040;
> +               /* We only own devices >=3D 0x1000 and <=3D 0x107f: leave=
 the rest. */
> +               if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> +                       return -ENODEV;
> +
> +               if (pci_dev->device < 0x1040) {
> +                       /* Transitional devices: use the PCI subsystem de=
vice id as
> +                        * virtio device id, same as legacy driver always=
 did.
> +                        */
> +                       mdev->id.device =3D pci_dev->subsystem_device;
> +               } else {
> +                       /* Modern devices: simply use PCI device id, but =
start from 0x1040. */
> +                       mdev->id.device =3D pci_dev->device - 0x1040;
> +               }
>         }
>         mdev->id.vendor =3D pci_dev->subsystem_vendor;
>
> @@ -260,7 +267,12 @@ int vp_modern_probe(struct virtio_pci_modern_device =
*mdev)
>                 return -EINVAL;
>         }
>
> -       err =3D dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64)=
);
> +       if (mdev->dma_mask_override)
> +               err =3D dma_set_mask_and_coherent(&pci_dev->dev,
> +                                               mdev->dma_mask_override);
> +       else
> +               err =3D dma_set_mask_and_coherent(&pci_dev->dev,
> +                                               DMA_BIT_MASK(64));
>         if (err)
>                 err =3D dma_set_mask_and_coherent(&pci_dev->dev,
>                                                 DMA_BIT_MASK(32));
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci=
_modern.h
> index c4eeb79b0139..84765bbd8dc5 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
>         int modern_bars;
>
>         struct virtio_device_id id;
> +
> +       /* alt. check for vendor virtio device, return 0 or -ERRNO */
> +       int (*device_id_check_override)(struct pci_dev *pdev);
> +
> +       /* alt. mask for devices with limited DMA space */
> +       u64 dma_mask_override;
>  };
>
>  /*
> --
> 2.17.1
>

