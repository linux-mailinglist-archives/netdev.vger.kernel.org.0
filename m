Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DD6633566
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiKVGiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKVGiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:38:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53621A04C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669099029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mg/iEcCE3HNR7XMFb/obxcU1pufGPEhcPp6Y/fVNCyE=;
        b=DZeGS0hBINw4tBt1D2HG8FmF+s60EHE6kOq4iZSW2hkyW2fevMApCCZKoSBUCkGTZS638g
        qRcJe7CaF9AqHLKUvrnAwGvXIumMElWPwoMJxrhCECLAjWLPWedGkk7xKv6HiayPwWxzR8
        EKwAKls049lHxtXhUbsyMsP8HUn72P4=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54--79Kjp6IOxSBzqp6xQmtpA-1; Tue, 22 Nov 2022 01:37:08 -0500
X-MC-Unique: -79Kjp6IOxSBzqp6xQmtpA-1
Received: by mail-oi1-f199.google.com with SMTP id bf10-20020a056808190a00b0035a0a5ab8b6so5070552oib.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:37:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mg/iEcCE3HNR7XMFb/obxcU1pufGPEhcPp6Y/fVNCyE=;
        b=eXJ/jCfHGhDYlvc+BItQFrSm1rphcKismlBcTEMqSSpEKIh6ETWgaYqIfmUSf76xwG
         G+UMegp3ggVzEXGvwWxntuaUikMPHuVSlAFEMVgbNhqdzU7QY7DoG3SWTxMrWzibUzIl
         A/zQEquth4vrT3yJ+WH5f6GI+/qYehNGhYidcX+asa0ppm/JVULzM1teVdDBA0t2fOJL
         6U0y4gUANffvzgAUqhiq7wuuWNVRGz9YUx1qOfBXXbUyQbshrmxPlnygajhKj0Lx2tlE
         Twie8zCLHBOqe+eMov6m+CuMk4aLpdgiGQC9W2mwMVcFNkFbk1PuND16Rv039GLmHhqc
         sfqA==
X-Gm-Message-State: ANoB5plg9eKzkgLhh5ASsAfzLCh/AThi4SMy13csmszJggZnz8Nq5tuL
        2tBKIRR/auOUKRA3TUjMcDaPHoaG2GptRgu7kKtOAG893xlcy7zlKJA3bwPKtcc9ZmXf7YIlFbK
        eBoLhfh5EN6LwIYh724+iKaX+0cJxAXab
X-Received: by 2002:a9d:4f07:0:b0:66c:64d6:1bb4 with SMTP id d7-20020a9d4f07000000b0066c64d61bb4mr11383633otl.201.1669099027492;
        Mon, 21 Nov 2022 22:37:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6vCOflZ8adi4YjFFR9O36mfGNMgH3Psk7QQNr2hpUO5Qg9+KjEdIeXeF5GvR/2AZ0FM6Pb5lHul02P6TnGUDY=
X-Received: by 2002:a9d:4f07:0:b0:66c:64d6:1bb4 with SMTP id
 d7-20020a9d4f07000000b0066c64d61bb4mr11383629otl.201.1669099027186; Mon, 21
 Nov 2022 22:37:07 -0800 (PST)
MIME-Version: 1.0
References: <20221118225656.48309-1-snelson@pensando.io> <20221118225656.48309-16-snelson@pensando.io>
 <bf06e7f0-48a1-37f7-0793-f68be31958e1@redhat.com>
In-Reply-To: <bf06e7f0-48a1-37f7-0793-f68be31958e1@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 22 Nov 2022 14:36:56 +0800
Message-ID: <CACGkMEu2A5Yt+hrmdQdAnVBCqcBn_-gXx3cF-SYjb2HsRUtF_g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 15/19] pds_vdpa: virtio bar setup for vdpa
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io
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

On Tue, Nov 22, 2022 at 11:32 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/11/19 06:56, Shannon Nelson =E5=86=99=E9=81=93:
> > The PDS vDPA device has a virtio BAR for describing itself, and
> > the pds_vdpa driver needs to access it.  Here we copy liberally
> > from the existing drivers/virtio/virtio_pci_modern_dev.c as it
> > has what we need, but we need to modify it so that it can work
> > with our device id and so we can use our own DMA mask.
> >
> > We suspect there is room for discussion here about making the
> > existing code a little more flexible, but we thought we'd at
> > least start the discussion here.
>
>
> Exactly, since the virtio_pci_modern_dev.c is a library, we could tweak
> it to allow the caller to pass the device_id with the DMA mask. Then we
> can avoid code/bug duplication here.

Btw, I found only isr/notification were used but not the others? If
this is true, we can avoid mapping those capabilities.

Thanks

>
> Thanks
>
>
> >
> > Signed-off-by: Shannon Nelson <snelson@pensando.io>
> > ---
> >   drivers/vdpa/pds/Makefile     |   3 +-
> >   drivers/vdpa/pds/pci_drv.c    |  10 ++
> >   drivers/vdpa/pds/pci_drv.h    |   2 +
> >   drivers/vdpa/pds/virtio_pci.c | 283 +++++++++++++++++++++++++++++++++=
+
> >   4 files changed, 297 insertions(+), 1 deletion(-)
> >   create mode 100644 drivers/vdpa/pds/virtio_pci.c
> >
> > diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> > index 3ba28a875574..b8376ab165bc 100644
> > --- a/drivers/vdpa/pds/Makefile
> > +++ b/drivers/vdpa/pds/Makefile
> > @@ -4,4 +4,5 @@
> >   obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
> >
> >   pds_vdpa-y :=3D pci_drv.o     \
> > -           debugfs.o
> > +           debugfs.o \
> > +           virtio_pci.o
> > diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
> > index 369e11153f21..10491e22778c 100644
> > --- a/drivers/vdpa/pds/pci_drv.c
> > +++ b/drivers/vdpa/pds/pci_drv.c
> > @@ -44,6 +44,14 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
> >               goto err_out_free_mem;
> >       }
> >
> > +     vdpa_pdev->vd_mdev.pci_dev =3D pdev;
> > +     err =3D pds_vdpa_probe_virtio(&vdpa_pdev->vd_mdev);
> > +     if (err) {
> > +             dev_err(dev, "Unable to probe for virtio configuration: %=
pe\n",
> > +                     ERR_PTR(err));
> > +             goto err_out_free_mem;
> > +     }
> > +
> >       pci_enable_pcie_error_reporting(pdev);
> >
> >       /* Use devres management */
> > @@ -74,6 +82,7 @@ pds_vdpa_pci_probe(struct pci_dev *pdev,
> >   err_out_pci_release_device:
> >       pci_disable_device(pdev);
> >   err_out_free_mem:
> > +     pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
> >       pci_disable_pcie_error_reporting(pdev);
> >       kfree(vdpa_pdev);
> >       return err;
> > @@ -88,6 +97,7 @@ pds_vdpa_pci_remove(struct pci_dev *pdev)
> >       pci_clear_master(pdev);
> >       pci_disable_pcie_error_reporting(pdev);
> >       pci_disable_device(pdev);
> > +     pds_vdpa_remove_virtio(&vdpa_pdev->vd_mdev);
> >       kfree(vdpa_pdev);
> >
> >       dev_info(&pdev->dev, "Removed\n");
> > diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
> > index 747809e0df9e..15f3b34fafa9 100644
> > --- a/drivers/vdpa/pds/pci_drv.h
> > +++ b/drivers/vdpa/pds/pci_drv.h
> > @@ -43,4 +43,6 @@ struct pds_vdpa_pci_device {
> >       struct virtio_pci_modern_device vd_mdev;
> >   };
> >
> > +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
> > +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
> >   #endif /* _PCI_DRV_H */
> > diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pc=
i.c
> > new file mode 100644
> > index 000000000000..0f4ac9467199
> > --- /dev/null
> > +++ b/drivers/vdpa/pds/virtio_pci.c
> > @@ -0,0 +1,283 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +/*
> > + * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
> > + */
> > +
> > +#include <linux/virtio_pci_modern.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/delay.h>
> > +
> > +#include "pci_drv.h"
> > +
> > +/*
> > + * pds_vdpa_map_capability - map a part of virtio pci capability
> > + * @mdev: the modern virtio-pci device
> > + * @off: offset of the capability
> > + * @minlen: minimal length of the capability
> > + * @align: align requirement
> > + * @start: start from the capability
> > + * @size: map size
> > + * @len: the length that is actually mapped
> > + * @pa: physical address of the capability
> > + *
> > + * Returns the io address of for the part of the capability
> > + */
> > +static void __iomem *
> > +pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off=
,
> > +                      size_t minlen, u32 align, u32 start, u32 size,
> > +                      size_t *len, resource_size_t *pa)
> > +{
> > +     struct pci_dev *dev =3D mdev->pci_dev;
> > +     u8 bar;
> > +     u32 offset, length;
> > +     void __iomem *p;
> > +
> > +     pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
> > +                                              bar),
> > +                          &bar);
> > +     pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, =
offset),
> > +                          &offset);
> > +     pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, =
length),
> > +                           &length);
> > +
> > +     /* Check if the BAR may have changed since we requested the regio=
n. */
> > +     if (bar >=3D PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar)=
)) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: bar unexpectedly changed to %u\n", b=
ar);
> > +             return NULL;
> > +     }
> > +
> > +     if (length <=3D start) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: bad capability len %u (>%u expected)=
\n",
> > +                     length, start);
> > +             return NULL;
> > +     }
> > +
> > +     if (length - start < minlen) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: bad capability len %u (>=3D%zu expec=
ted)\n",
> > +                     length, minlen);
> > +             return NULL;
> > +     }
> > +
> > +     length -=3D start;
> > +
> > +     if (start + offset < offset) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: map wrap-around %u+%u\n",
> > +                     start, offset);
> > +             return NULL;
> > +     }
> > +
> > +     offset +=3D start;
> > +
> > +     if (offset & (align - 1)) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: offset %u not aligned to %u\n",
> > +                     offset, align);
> > +             return NULL;
> > +     }
> > +
> > +     if (length > size)
> > +             length =3D size;
> > +
> > +     if (len)
> > +             *len =3D length;
> > +
> > +     if (minlen + offset < minlen ||
> > +         minlen + offset > pci_resource_len(dev, bar)) {
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: map virtio %zu@%u out of range on ba=
r %i length %lu\n",
> > +                     minlen, offset,
> > +                     bar, (unsigned long)pci_resource_len(dev, bar));
> > +             return NULL;
> > +     }
> > +
> > +     p =3D pci_iomap_range(dev, bar, offset, length);
> > +     if (!p)
> > +             dev_err(&dev->dev,
> > +                     "virtio_pci: unable to map virtio %u@%u on bar %i=
\n",
> > +                     length, offset, bar);
> > +     else if (pa)
> > +             *pa =3D pci_resource_start(dev, bar) + offset;
> > +
> > +     return p;
> > +}
> > +
> > +/**
> > + * virtio_pci_find_capability - walk capabilities to find device info.
> > + * @dev: the pci device
> > + * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
> > + * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
> > + * @bars: the bitmask of BARs
> > + *
> > + * Returns offset of the capability, or 0.
> > + */
> > +static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 c=
fg_type,
> > +                                          u32 ioresource_types, int *b=
ars)
> > +{
> > +     int pos;
> > +
> > +     for (pos =3D pci_find_capability(dev, PCI_CAP_ID_VNDR);
> > +          pos > 0;
> > +          pos =3D pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR))=
 {
> > +             u8 type, bar;
> > +
> > +             pci_read_config_byte(dev, pos + offsetof(struct virtio_pc=
i_cap,
> > +                                                      cfg_type),
> > +                                  &type);
> > +             pci_read_config_byte(dev, pos + offsetof(struct virtio_pc=
i_cap,
> > +                                                      bar),
> > +                                  &bar);
> > +
> > +             /* Ignore structures with reserved BAR values */
> > +             if (bar >=3D PCI_STD_NUM_BARS)
> > +                     continue;
> > +
> > +             if (type =3D=3D cfg_type) {
> > +                     if (pci_resource_len(dev, bar) &&
> > +                         pci_resource_flags(dev, bar) & ioresource_typ=
es) {
> > +                             *bars |=3D (1 << bar);
> > +                             return pos;
> > +                     }
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> > +/*
> > + * pds_vdpa_probe_virtio: probe the modern virtio pci device, note tha=
t the
> > + * caller is required to enable PCI device before calling this functio=
n.
> > + * @mdev: the modern virtio-pci device
> > + *
> > + * Return 0 on succeed otherwise fail
> > + */
> > +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
> > +{
> > +     struct pci_dev *pci_dev =3D mdev->pci_dev;
> > +     int err, common, isr, notify, device;
> > +     u32 notify_length;
> > +     u32 notify_offset;
> > +
> > +     /* check for a common config: if not, use legacy mode (bar 0). */
> > +     common =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COM=
MON_CFG,
> > +                                         IORESOURCE_IO | IORESOURCE_ME=
M,
> > +                                         &mdev->modern_bars);
> > +     if (!common) {
> > +             dev_info(&pci_dev->dev,
> > +                      "virtio_pci: missing common config\n");
> > +             return -ENODEV;
> > +     }
> > +
> > +     /* If common is there, these should be too... */
> > +     isr =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CF=
G,
> > +                                      IORESOURCE_IO | IORESOURCE_MEM,
> > +                                      &mdev->modern_bars);
> > +     notify =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOT=
IFY_CFG,
> > +                                         IORESOURCE_IO | IORESOURCE_ME=
M,
> > +                                         &mdev->modern_bars);
> > +     if (!isr || !notify) {
> > +             dev_err(&pci_dev->dev,
> > +                     "virtio_pci: missing capabilities %i/%i/%i\n",
> > +                     common, isr, notify);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* Device capability is only mandatory for devices that have
> > +      * device-specific configuration.
> > +      */
> > +     device =3D virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEV=
ICE_CFG,
> > +                                         IORESOURCE_IO | IORESOURCE_ME=
M,
> > +                                         &mdev->modern_bars);
> > +
> > +     err =3D pci_request_selected_regions(pci_dev, mdev->modern_bars,
> > +                                        "virtio-pci-modern");
> > +     if (err)
> > +             return err;
> > +
> > +     err =3D -EINVAL;
> > +     mdev->common =3D pds_vdpa_map_capability(mdev, common,
> > +                                   sizeof(struct virtio_pci_common_cfg=
), 4,
> > +                                   0, sizeof(struct virtio_pci_common_=
cfg),
> > +                                   NULL, NULL);
> > +     if (!mdev->common)
> > +             goto err_map_common;
> > +     mdev->isr =3D pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
> > +                                          0, 1,
> > +                                          NULL, NULL);
> > +     if (!mdev->isr)
> > +             goto err_map_isr;
> > +
> > +     /* Read notify_off_multiplier from config space. */
> > +     pci_read_config_dword(pci_dev,
> > +                           notify + offsetof(struct virtio_pci_notify_=
cap,
> > +                                             notify_off_multiplier),
> > +                           &mdev->notify_offset_multiplier);
> > +     /* Read notify length and offset from config space. */
> > +     pci_read_config_dword(pci_dev,
> > +                           notify + offsetof(struct virtio_pci_notify_=
cap,
> > +                                             cap.length),
> > +                           &notify_length);
> > +
> > +     pci_read_config_dword(pci_dev,
> > +                           notify + offsetof(struct virtio_pci_notify_=
cap,
> > +                                             cap.offset),
> > +                           &notify_offset);
> > +
> > +     /* We don't know how many VQs we'll map, ahead of the time.
> > +      * If notify length is small, map it all now.
> > +      * Otherwise, map each VQ individually later.
> > +      */
> > +     if ((u64)notify_length + (notify_offset % PAGE_SIZE) <=3D PAGE_SI=
ZE) {
> > +             mdev->notify_base =3D pds_vdpa_map_capability(mdev, notif=
y,
> > +                                                          2, 2,
> > +                                                          0, notify_le=
ngth,
> > +                                                          &mdev->notif=
y_len,
> > +                                                          &mdev->notif=
y_pa);
> > +             if (!mdev->notify_base)
> > +                     goto err_map_notify;
> > +     } else {
> > +             mdev->notify_map_cap =3D notify;
> > +     }
> > +
> > +     /* Again, we don't know how much we should map, but PAGE_SIZE
> > +      * is more than enough for all existing devices.
> > +      */
> > +     if (device) {
> > +             mdev->device =3D pds_vdpa_map_capability(mdev, device, 0,=
 4,
> > +                                                     0, PAGE_SIZE,
> > +                                                     &mdev->device_len=
,
> > +                                                     NULL);
> > +             if (!mdev->device)
> > +                     goto err_map_device;
> > +     }
> > +
> > +     return 0;
> > +
> > +err_map_device:
> > +     if (mdev->notify_base)
> > +             pci_iounmap(pci_dev, mdev->notify_base);
> > +err_map_notify:
> > +     pci_iounmap(pci_dev, mdev->isr);
> > +err_map_isr:
> > +     pci_iounmap(pci_dev, mdev->common);
> > +err_map_common:
> > +     pci_release_selected_regions(pci_dev, mdev->modern_bars);
> > +     return err;
> > +}
> > +
> > +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
> > +{
> > +     struct pci_dev *pci_dev =3D mdev->pci_dev;
> > +
> > +     if (mdev->device)
> > +             pci_iounmap(pci_dev, mdev->device);
> > +     if (mdev->notify_base)
> > +             pci_iounmap(pci_dev, mdev->notify_base);
> > +     pci_iounmap(pci_dev, mdev->isr);
> > +     pci_iounmap(pci_dev, mdev->common);
> > +     pci_release_selected_regions(pci_dev, mdev->modern_bars);
> > +}

