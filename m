Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2B6C5E87
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCWFMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWFMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A821F5C4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679548315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3obIApiz6XSZWW1/5Bw9gaJPbynr/ma2GlgXsdWN+4I=;
        b=ZQj0WSAWRMZ+dgme0+9wzOz0pSU0U2owZc7t4xmxQ3wElVF1FIDMZwUom3sXBHe5AkFbjJ
        seQkb5bgQlKtX2iUlEFENuqUmfJqonYC3C4UkOsUnnMaQTlMZ1QgDL+WLjsF59idZgBDc5
        BmjYIRoNQHDP/ZWilo6n6O71MfkYkqY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-3nfbIdXGN8KaYaYYERnkwg-1; Thu, 23 Mar 2023 01:11:52 -0400
X-MC-Unique: 3nfbIdXGN8KaYaYYERnkwg-1
Received: by mail-oi1-f199.google.com with SMTP id bi38-20020a05680818a600b0037b36626937so8252228oib.13
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3obIApiz6XSZWW1/5Bw9gaJPbynr/ma2GlgXsdWN+4I=;
        b=eriVaaY0/HIz4b6+G9VI7PD2vPNYsiQtl1LCdFTN8opnGMLxmDDdrMQOlkUxhm0494
         F85cvuV5A8FW1K9PrBljPSCIY+A8tIE/lDfqjv933wejZ6eaGuZ9XQxFtXdS+L36af5Q
         jAoXWh73ZDUYr1AQ/TI26jDvoeb09O7zAJek1oZriYhXt7tUnaDLPEj/E40rHivKD3NA
         2AnN/KPhmJIa1LrF8iN8cX2Y2Gu2YVtCd2ASuY5FyECBeHvYIxtePncKf58VC6IcLk3H
         GfoRjQM+pWxXFWjxsGj2J9XDQoIPyHqvVujuiz/KB49s3YwSB4KIanEfsOSDfEFuXhnF
         gN2Q==
X-Gm-Message-State: AAQBX9fjpB12WUvfB/qFGKupVdZDcJQp15Q+Ymjmc/dW+p8nWTcZyxzG
        IIllqQdEkgc4hsGlkz6VJ2qGlKpdNdYemkCMkHlS8mcFHdUow1edOQfs3gSrgzjcD2jJEMR4gtf
        60iFnDxVxH5GOgDwSbXWxuYB64vEnJxWK
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id zj23-20020a0568716c9700b0017e76748df0mr708953oab.9.1679548310153;
        Wed, 22 Mar 2023 22:11:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set/ZEZkMXDEYWmucA01pOHV0jYtKIc/O0X4B69Ds15sDFH0SmHz0B8yc7U/s8mZMK9Yi0aM3l+qrQwnkM/yazzk=
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id
 zj23-20020a0568716c9700b0017e76748df0mr708948oab.9.1679548309923; Wed, 22 Mar
 2023 22:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-5-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-5-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 13:11:38 +0800
Message-ID: <CACGkMEtBGZ-ViLk=tRJiAMm_YJJ2XomRQAKdCpa1tWE4KmuRJA@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 4/8] pds_vdpa: virtio bar setup for vdpa
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
> Prep and use the "modern" virtio bar utilities to get our
> virtio config space ready.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/aux_drv.c | 25 +++++++++++++++++++++++++
>  drivers/vdpa/pds/aux_drv.h |  3 +++
>  2 files changed, 28 insertions(+)
>
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index 881acd869a9d..8f3ae3326885 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -4,6 +4,7 @@
>  #include <linux/auxiliary_bus.h>
>  #include <linux/pci.h>
>  #include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
>
>  #include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> @@ -20,12 +21,22 @@ static const struct auxiliary_device_id pds_vdpa_id_t=
able[] =3D {
>         {},
>  };
>
> +static int pds_vdpa_device_id_check(struct pci_dev *pdev)
> +{
> +       if (pdev->device !=3D PCI_DEVICE_ID_PENSANDO_VDPA_VF ||
> +           pdev->vendor !=3D PCI_VENDOR_ID_PENSANDO)
> +               return -ENODEV;

Similar to patch 1, if we don't need to override we probably can
rename the device_id_check_override to device_id_check(). Otherwise
it's better to let this function to return device id.

Thanks

> +
> +       return 0;
> +}
> +
>  static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>                           const struct auxiliary_device_id *id)
>
>  {
>         struct pds_auxiliary_dev *padev =3D
>                 container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
> +       struct device *dev =3D &aux_dev->dev;
>         struct pds_vdpa_aux *vdpa_aux;
>         int err;
>
> @@ -42,8 +53,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux=
_dev,
>         if (err)
>                 goto err_free_mem;
>
> +       /* Find the virtio configuration */
> +       vdpa_aux->vd_mdev.pci_dev =3D padev->vf_pdev;
> +       vdpa_aux->vd_mdev.device_id_check_override =3D pds_vdpa_device_id=
_check;
> +       vdpa_aux->vd_mdev.dma_mask_override =3D DMA_BIT_MASK(PDS_CORE_ADD=
R_LEN);
> +       err =3D vp_modern_probe(&vdpa_aux->vd_mdev);
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
> +       pci_free_irq_vectors(padev->vf_pdev);
>  err_free_mem:
>         kfree(vdpa_aux);
>         auxiliary_set_drvdata(aux_dev, NULL);
> @@ -56,6 +80,7 @@ static void pds_vdpa_remove(struct auxiliary_device *au=
x_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       vp_modern_remove(&vdpa_aux->vd_mdev);
>         pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
>
>         kfree(vdpa_aux);
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> index 94ba7abcaa43..8f5140401573 100644
> --- a/drivers/vdpa/pds/aux_drv.h
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -4,6 +4,8 @@
>  #ifndef _AUX_DRV_H_
>  #define _AUX_DRV_H_
>
> +#include <linux/virtio_pci_modern.h>
> +
>  #define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
>  #define PDS_VDPA_DRV_NAME           "pds_vdpa"
>
> @@ -16,6 +18,7 @@ struct pds_vdpa_aux {
>
>         int vf_id;
>         struct dentry *dentry;
> +       struct virtio_pci_modern_device vd_mdev;
>
>         int nintrs;
>  };
> --
> 2.17.1
>

