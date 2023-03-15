Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106236BA8B8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCOHHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCOHHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B5C66D13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678863937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtU3rInEYuF8KYF1vvIl8re+OkAcXBh1WE8QkRT/Oec=;
        b=Ry5l5oeokAxLu0EcNkWGMa9QxGJmXTqDcxrbRqeq/oj8jbg4A96cP7VrC56vqBoQD6FtEL
        k+FffltUCynR3ZqvidqwibKU4suj3UfSQFePBTy8/aArQiz6WWsOBsgbhS0Wip3JrgEP5J
        kdH3tbNRfk2ZBy1ctDz/4owRcYVunfg=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-BxUSrEl5O-iqpFAxfWVxgQ-1; Wed, 15 Mar 2023 03:05:36 -0400
X-MC-Unique: BxUSrEl5O-iqpFAxfWVxgQ-1
Received: by mail-oo1-f70.google.com with SMTP id m14-20020a4add0e000000b0052010e01597so4834621oou.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678863935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wtU3rInEYuF8KYF1vvIl8re+OkAcXBh1WE8QkRT/Oec=;
        b=XzO98HieFyHcMQjfGqBQnA6e3L/OrAMECxIv3aawXN+R0V+d/knWnqeTflcaViAGeA
         /PPkJ5/lHvPpM8mDbRscTLOLoD2CP9a7kr+FSN5s2cF9Iwd2aiaNNhxbkCx3uHpIO+ht
         wyvz/zHFWfUVGWCf0q2Nm+aLLcrTq6KB15Nswv+9teS/LdUDrHxv7qRw2ElNNeGe4TT3
         u/q145XGkGkugmveReTOTjHVQw5av6mbIel35qAznMI/Dey2pB8oGSWQo+qQlOzCoqEO
         xwXgEE9mhkl+G7MZ7oNn0uSWBzGxTw4kiXVDVPvzS30ACgTQBOAM60Gc5orO4P+9FD3N
         uDKQ==
X-Gm-Message-State: AO0yUKVtgFMKNe88/naBO9GXok5PR9y2KcUaZQFrGOIXJnb17uaCWMJt
        8zzVboJdtAvYnM0TPhiL7hqDBrvVMY9QaJPsF6O46ZTXpHDArY/jVZPAPDdHBS8YQOjk9/7yV7L
        krVnJAVS7B2IifPORlPhL6zNqGvMwP65I
X-Received: by 2002:a05:6870:1341:b0:177:ca1c:2ca8 with SMTP id 1-20020a056870134100b00177ca1c2ca8mr2983766oac.9.1678863935132;
        Wed, 15 Mar 2023 00:05:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set8vDBJWX3Qf1j79WE91MJ7iJxU7vYD03PsIBEaB0LoKjJtRcBQcYPj82Fo5tN3mZXZCuDdjmkUdUZ50mMVxcNE=
X-Received: by 2002:a05:6870:1341:b0:177:ca1c:2ca8 with SMTP id
 1-20020a056870134100b00177ca1c2ca8mr2983751oac.9.1678863934685; Wed, 15 Mar
 2023 00:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com> <20230309013046.23523-4-shannon.nelson@amd.com>
In-Reply-To: <20230309013046.23523-4-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Mar 2023 15:05:23 +0800
Message-ID: <CACGkMEt5Jbsp=+st8aG_0kXD+OSSp+FX9vYE+gTkywp2ZN4LTw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 3/7] pds_vdpa: virtio bar setup for vdpa
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
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

On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> The PDS vDPA device has a virtio BAR for describing itself, and
> the pds_vdpa driver needs to access it.  Here we copy liberally
> from the existing drivers/virtio/virtio_pci_modern_dev.c as it
> has what we need, but we need to modify it so that it can work
> with our device id and so we can use our own DMA mask.

By passing a pointer to a customized id probing routine to vp_modern_probe(=
)?

Thanks


>
> We suspect there is room for discussion here about making the
> existing code a little more flexible, but we thought we'd at
> least start the discussion here.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/Makefile     |   1 +
>  drivers/vdpa/pds/aux_drv.c    |  14 ++
>  drivers/vdpa/pds/aux_drv.h    |   1 +
>  drivers/vdpa/pds/debugfs.c    |   1 +
>  drivers/vdpa/pds/vdpa_dev.c   |   1 +
>  drivers/vdpa/pds/virtio_pci.c | 281 ++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/virtio_pci.h |   8 +
>  7 files changed, 307 insertions(+)
>  create mode 100644 drivers/vdpa/pds/virtio_pci.c
>  create mode 100644 drivers/vdpa/pds/virtio_pci.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index 13b50394ec64..ca2efa8c6eb5 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -4,6 +4,7 @@
>  obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
>
>  pds_vdpa-y :=3D aux_drv.o \
> +             virtio_pci.o \
>               vdpa_dev.o
>
>  pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index 63e40ae68211..28158d0d98a5 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -4,6 +4,7 @@
>  #include <linux/auxiliary_bus.h>
>  #include <linux/pci.h>
>  #include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
>
>  #include <linux/pds/pds_core.h>
>  #include <linux/pds/pds_auxbus.h>
> @@ -12,6 +13,7 @@
>  #include "aux_drv.h"
>  #include "debugfs.h"
>  #include "vdpa_dev.h"
> +#include "virtio_pci.h"
>
>  static const struct auxiliary_device_id pds_vdpa_id_table[] =3D {
>         { .name =3D PDS_VDPA_DEV_NAME, },
> @@ -49,8 +51,19 @@ static int pds_vdpa_probe(struct auxiliary_device *aux=
_dev,
>         if (err)
>                 goto err_aux_unreg;
>
> +       /* Find the virtio configuration */
> +       vdpa_aux->vd_mdev.pci_dev =3D padev->vf->pdev;
> +       err =3D pds_vdpa_probe_virtio(&vdpa_aux->vd_mdev);
> +       if (err) {
> +               dev_err(dev, "Unable to probe for virtio configuration: %=
pe\n",
> +                       ERR_PTR(err));
> +               goto err_free_mgmt_info;
> +       }
> +
>         return 0;
>
> +err_free_mgmt_info:
> +       pci_free_irq_vectors(padev->vf->pdev);
>  err_aux_unreg:
>         padev->ops->unregister_client(padev);
>  err_free_mem:
> @@ -65,6 +78,7 @@ static void pds_vdpa_remove(struct auxiliary_device *au=
x_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>         pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
>
>         vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> index 94ba7abcaa43..87ac3c01c476 100644
> --- a/drivers/vdpa/pds/aux_drv.h
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -16,6 +16,7 @@ struct pds_vdpa_aux {
>
>         int vf_id;
>         struct dentry *dentry;
> +       struct virtio_pci_modern_device vd_mdev;
>
>         int nintrs;
>  };
> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> index 7b7e90fd6578..aa5e9677fe74 100644
> --- a/drivers/vdpa/pds/debugfs.c
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>
> +#include <linux/virtio_pci_modern.h>
>  #include <linux/vdpa.h>
>
>  #include <linux/pds/pds_core.h>
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> index bd840688503c..15d623297203 100644
> --- a/drivers/vdpa/pds/vdpa_dev.c
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -4,6 +4,7 @@
>  #include <linux/pci.h>
>  #include <linux/vdpa.h>
>  #include <uapi/linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
>
>  #include <linux/pds/pds_core.h>
>  #include <linux/pds/pds_adminq.h>
> diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pci.=
c
> new file mode 100644
> index 000000000000..cb879619dac3
> --- /dev/null
> +++ b/drivers/vdpa/pds/virtio_pci.c
> @@ -0,0 +1,281 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +/*
> + * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
> + */
> +
> +#include <linux/virtio_pci_modern.h>
> +#include <linux/pci.h>
> +
> +#include "virtio_pci.h"
> +
> +/*
> + * pds_vdpa_map_capability - map a part of virtio pci capability
> + * @mdev: the modern virtio-pci device
> + * @off: offset of the capability
> + * @minlen: minimal length of the capability
> + * @align: align requirement
> + * @start: start from the capability
> + * @size: map size
> + * @len: the length that is actually mapped
> + * @pa: physical address of the capability
> + *
> + * Returns the io address of for the part of the capability
> + */
> +static void __iomem *
> +pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off,
> +                       size_t minlen, u32 align, u32 start, u32 size,
> +                       size_t *len, resource_size_t *pa)
> +{
> +       struct pci_dev *dev =3D mdev->pci_dev;
> +       u8 bar;
> +       u32 offset, length;
> +       void __iomem *p;
> +
> +       pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
> +                                                bar),
> +                            &bar);
> +       pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, =
offset),
> +                             &offset);
> +       pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, =
length),
> +                             &length);
> +
> +       /* Check if the BAR may have changed since we requested the regio=
n. */
> +       if (bar >=3D PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar)=
)) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: bar unexpectedly changed to %u\n", b=
ar);
> +               return NULL;
> +       }
> +
> +       if (length <=3D start) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: bad capability len %u (>%u expected)=
\n",
> +                       length, start);
> +               return NULL;
> +       }
> +
> +       if (length - start < minlen) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: bad capability len %u (>=3D%zu expec=
ted)\n",
> +                       length, minlen);
> +               return NULL;
> +       }
> +
> +       length -=3D start;
> +
> +       if (start + offset < offset) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: map wrap-around %u+%u\n",
> +                       start, offset);
> +               return NULL;
> +       }
> +
> +       offset +=3D start;
> +
> +       if (offset & (align - 1)) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: offset %u not aligned to %u\n",
> +                       offset, align);
> +               return NULL;
> +       }
> +
> +       if (length > size)
> +               length =3D size;
> +
> +       if (len)
> +               *len =3D length;
> +
> +       if (minlen + offset < minlen ||
> +           minlen + offset > pci_resource_len(dev, bar)) {
> +               dev_err(&dev->dev,
> +                       "virtio_pci: map virtio %zu@%u out of range on ba=
r %i length %lu\n",
> +                       minlen, offset,
> +                       bar, (unsigned long)pci_resource_len(dev, bar));
> +               return NULL;
> +       }
> +
> +       p =3D pci_iomap_range(dev, bar, offset, length);
> +       if (!p)
> +               dev_err(&dev->dev,
> +                       "virtio_pci: unable to map virtio %u@%u on bar %i=
\n",
> +                       length, offset, bar);
> +       else if (pa)
> +               *pa =3D pci_resource_start(dev, bar) + offset;
> +
> +       return p;
> +}
> +
> +/**
> + * virtio_pci_find_capability - walk capabilities to find device info.
> + * @dev: the pci device
> + * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
> + * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
> + * @bars: the bitmask of BARs
> + *
> + * Returns offset of the capability, or 0.
> + */
> +static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg=
_type,
> +                                            u32 ioresource_types, int *b=
ars)
> +{
> +       int pos;
> +
> +       for (pos =3D pci_find_capability(dev, PCI_CAP_ID_VNDR);
> +            pos > 0;
> +            pos =3D pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR))=
 {
> +               u8 type, bar;
> +
> +               pci_read_config_byte(dev, pos + offsetof(struct virtio_pc=
i_cap,
> +                                                        cfg_type),
> +                                    &type);
> +               pci_read_config_byte(dev, pos + offsetof(struct virtio_pc=
i_cap,
> +                                                        bar),
> +                                    &bar);
> +
> +               /* Ignore structures with reserved BAR values */
> +               if (bar >=3D PCI_STD_NUM_BARS)
> +                       continue;
> +
> +               if (type =3D=3D cfg_type) {
> +                       if (pci_resource_len(dev, bar) &&
> +                           pci_resource_flags(dev, bar) & ioresource_typ=
es) {
> +                               *bars |=3D (1 << bar);
> +                               return pos;
> +                       }
> +               }
> +       }
> +       return 0;
> +}
> +
> +/*
> + * pds_vdpa_probe_virtio: probe the modern virtio pci device, note that =
the
> + * caller is required to enable PCI device before calling this function.
> + * @mdev: the modern virtio-pci device
> + *
> + * Return 0 on succeed otherwise fail
> + */
> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
> +{
> +       struct pci_dev *pci_dev =3D mdev->pci_dev;
> +       int err, common, isr, notify, device;
> +       u32 notify_length;
> +       u32 notify_offset;
> +
> +       /* check for a common config: if not, use legacy mode (bar 0). */
> +       common =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COM=
MON_CFG,
> +                                           IORESOURCE_IO | IORESOURCE_ME=
M,
> +                                           &mdev->modern_bars);
> +       if (!common) {
> +               dev_info(&pci_dev->dev,
> +                        "virtio_pci: missing common config\n");
> +               return -ENODEV;
> +       }
> +
> +       /* If common is there, these should be too... */
> +       isr =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CF=
G,
> +                                        IORESOURCE_IO | IORESOURCE_MEM,
> +                                        &mdev->modern_bars);
> +       notify =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOT=
IFY_CFG,
> +                                           IORESOURCE_IO | IORESOURCE_ME=
M,
> +                                           &mdev->modern_bars);
> +       if (!isr || !notify) {
> +               dev_err(&pci_dev->dev,
> +                       "virtio_pci: missing capabilities %i/%i/%i\n",
> +                       common, isr, notify);
> +               return -EINVAL;
> +       }
> +
> +       /* Device capability is only mandatory for devices that have
> +        * device-specific configuration.
> +        */
> +       device =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEV=
ICE_CFG,
> +                                           IORESOURCE_IO | IORESOURCE_ME=
M,
> +                                           &mdev->modern_bars);
> +
> +       err =3D pci_request_selected_regions(pci_dev, mdev->modern_bars,
> +                                          "virtio-pci-modern");
> +       if (err)
> +               return err;
> +
> +       err =3D -EINVAL;
> +       mdev->common =3D pds_vdpa_map_capability(mdev, common,
> +                                              sizeof(struct virtio_pci_c=
ommon_cfg),
> +                                              4, 0,
> +                                              sizeof(struct virtio_pci_c=
ommon_cfg),
> +                                              NULL, NULL);
> +       if (!mdev->common)
> +               goto err_map_common;
> +       mdev->isr =3D pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
> +                                           0, 1, NULL, NULL);
> +       if (!mdev->isr)
> +               goto err_map_isr;
> +
> +       /* Read notify_off_multiplier from config space. */
> +       pci_read_config_dword(pci_dev,
> +                             notify + offsetof(struct virtio_pci_notify_=
cap,
> +                                               notify_off_multiplier),
> +                             &mdev->notify_offset_multiplier);
> +       /* Read notify length and offset from config space. */
> +       pci_read_config_dword(pci_dev,
> +                             notify + offsetof(struct virtio_pci_notify_=
cap,
> +                                               cap.length),
> +                             &notify_length);
> +
> +       pci_read_config_dword(pci_dev,
> +                             notify + offsetof(struct virtio_pci_notify_=
cap,
> +                                               cap.offset),
> +                             &notify_offset);
> +
> +       /* We don't know how many VQs we'll map, ahead of the time.
> +        * If notify length is small, map it all now.
> +        * Otherwise, map each VQ individually later.
> +        */
> +       if ((u64)notify_length + (notify_offset % PAGE_SIZE) <=3D PAGE_SI=
ZE) {
> +               mdev->notify_base =3D pds_vdpa_map_capability(mdev, notif=
y,
> +                                                           2, 2,
> +                                                           0, notify_len=
gth,
> +                                                           &mdev->notify=
_len,
> +                                                           &mdev->notify=
_pa);
> +               if (!mdev->notify_base)
> +                       goto err_map_notify;
> +       } else {
> +               mdev->notify_map_cap =3D notify;
> +       }
> +
> +       /* Again, we don't know how much we should map, but PAGE_SIZE
> +        * is more than enough for all existing devices.
> +        */
> +       if (device) {
> +               mdev->device =3D pds_vdpa_map_capability(mdev, device, 0,=
 4,
> +                                                      0, PAGE_SIZE,
> +                                                      &mdev->device_len,
> +                                                      NULL);
> +               if (!mdev->device)
> +                       goto err_map_device;
> +       }
> +
> +       return 0;
> +
> +err_map_device:
> +       if (mdev->notify_base)
> +               pci_iounmap(pci_dev, mdev->notify_base);
> +err_map_notify:
> +       pci_iounmap(pci_dev, mdev->isr);
> +err_map_isr:
> +       pci_iounmap(pci_dev, mdev->common);
> +err_map_common:
> +       pci_release_selected_regions(pci_dev, mdev->modern_bars);
> +       return err;
> +}
> +
> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
> +{
> +       struct pci_dev *pci_dev =3D mdev->pci_dev;
> +
> +       if (mdev->device)
> +               pci_iounmap(pci_dev, mdev->device);
> +       if (mdev->notify_base)
> +               pci_iounmap(pci_dev, mdev->notify_base);
> +       pci_iounmap(pci_dev, mdev->isr);
> +       pci_iounmap(pci_dev, mdev->common);
> +       pci_release_selected_regions(pci_dev, mdev->modern_bars);
> +}
> diff --git a/drivers/vdpa/pds/virtio_pci.h b/drivers/vdpa/pds/virtio_pci.=
h
> new file mode 100644
> index 000000000000..f017cfa1173c
> --- /dev/null
> +++ b/drivers/vdpa/pds/virtio_pci.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _PDS_VIRTIO_PCI_H_
> +#define _PDS_VIRTIO_PCI_H_
> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
> +#endif /* _PDS_VIRTIO_PCI_H_ */
> --
> 2.17.1
>

