Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18B6BDFAB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCQDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQDeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:34:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B14A1C6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679024019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goLgdreS2QkUUpgFFAioCzRs6o6aj79euCwZW0bwQgc=;
        b=W/Ukah3dvpgbM75mE1hy8YKC+yZ66zdgx9QC3WKVQFR859R4Twf+XBTBxX84CLiWoMFTz1
        ySQbe3hn4tVw3HE2+UKjWstAAE5TGIFgvXPqPo/ucn4U8m3pkmdp/78tG9qEaIPG1uBK7S
        TOz1Vnj09quLlLBxP9m8YB15l53Qbgg=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-pu3UvG45On2DuhWd7XpkcA-1; Thu, 16 Mar 2023 23:33:38 -0400
X-MC-Unique: pu3UvG45On2DuhWd7XpkcA-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-17ae1c11a20so2245716fac.22
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679024018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goLgdreS2QkUUpgFFAioCzRs6o6aj79euCwZW0bwQgc=;
        b=rinSVKeOK7ZfLjOb/XcAyVnA0d7XWN7IdzLMii/+8KNOlqjjr9RmPXjc1p5kQwyhBs
         KYqFygFV+PBGYwNDaRfmWi4hZ8bE0e3OTXDCu6P1fI4YDzdDoTuEaXrx03EKMLPaVKU/
         3ejr9WkR4EtbxMbxvIYvXM4OiSWRY3NutxT712l0NN+dSbZzSjOcBseozjSZUtDjLiuT
         ksg39Dn1kzhz6luttTwdjQXWeevnb0LocotgbIt/2duH400wUlipraKVtfy37ILWs2us
         CwgKlDe3xHb+aX9V+oYvIguzDWSRzsiobO4A/QKFxpDyz3zArib+1s+IJoVpwRvXHzsY
         AMwQ==
X-Gm-Message-State: AO0yUKVWgCFGTcEVkKH9f6GRBxYriC+8bi5Q781oCKz3458JY4i9otFA
        gzow/txCLPtQ+atjYyevJvfqtp6M7vYdheG51EcxcxOXMrbyOaPaX8EFjc1KVjLNRWzwOTP2BQQ
        zGc2I8HyxU/ng3E/sEYe9XWVQ554ugcreARtmNaEeHWo=
X-Received: by 2002:aca:1c16:0:b0:384:4e2d:81ea with SMTP id c22-20020aca1c16000000b003844e2d81eamr2799674oic.9.1679024017922;
        Thu, 16 Mar 2023 20:33:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set/pmRoQksEiseo43fD6VDuW3rOIdhRFRBkOYL1vsdo+T8jzwj6/6gMtdY9EhFQE6kKEb5ajjs2JfFxWQK7FxKY=
X-Received: by 2002:aca:1c16:0:b0:384:4e2d:81ea with SMTP id
 c22-20020aca1c16000000b003844e2d81eamr2799666oic.9.1679024017611; Thu, 16 Mar
 2023 20:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-3-shannon.nelson@amd.com> <CACGkMEumJLysw4Grd19fVF-LuUb+r201XWMaeCkT=kDqN41ZTg@mail.gmail.com>
 <ad9ab1f3-43ff-a73d-0a62-50565aa5196f@amd.com>
In-Reply-To: <ad9ab1f3-43ff-a73d-0a62-50565aa5196f@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Mar 2023 11:33:26 +0800
Message-ID: <CACGkMEuv9Rd0nOw3VxM9Ut25=VuWa_MTfaUxkWPwFm+vicU22Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 2/7] pds_vdpa: get vdpa management info
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

On Thu, Mar 16, 2023 at 11:25=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> On 3/15/23 12:05 AM, Jason Wang wrote:
> > On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@a=
md.com> wrote:
> >>
> >> Find the vDPA management information from the DSC in order to
> >> advertise it to the vdpa subsystem.
> >>
> >> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> >> ---
> >>   drivers/vdpa/pds/Makefile    |   3 +-
> >>   drivers/vdpa/pds/aux_drv.c   |  13 ++++
> >>   drivers/vdpa/pds/aux_drv.h   |   7 +++
> >>   drivers/vdpa/pds/debugfs.c   |   3 +
> >>   drivers/vdpa/pds/vdpa_dev.c  | 113 +++++++++++++++++++++++++++++++++=
++
> >>   drivers/vdpa/pds/vdpa_dev.h  |  15 +++++
> >>   include/linux/pds/pds_vdpa.h |  92 ++++++++++++++++++++++++++++
> >>   7 files changed, 245 insertions(+), 1 deletion(-)
> >>   create mode 100644 drivers/vdpa/pds/vdpa_dev.c
> >>   create mode 100644 drivers/vdpa/pds/vdpa_dev.h
> >>
> >> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> >> index a9cd2f450ae1..13b50394ec64 100644
> >> --- a/drivers/vdpa/pds/Makefile
> >> +++ b/drivers/vdpa/pds/Makefile
> >> @@ -3,6 +3,7 @@
> >>
> >>   obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
> >>
> >> -pds_vdpa-y :=3D aux_drv.o
> >> +pds_vdpa-y :=3D aux_drv.o \
> >> +             vdpa_dev.o
> >>
> >>   pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> >> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> >> index b3f36170253c..63e40ae68211 100644
> >> --- a/drivers/vdpa/pds/aux_drv.c
> >> +++ b/drivers/vdpa/pds/aux_drv.c
> >> @@ -2,6 +2,8 @@
> >>   /* Copyright(c) 2023 Advanced Micro Devices, Inc */
> >>
> >>   #include <linux/auxiliary_bus.h>
> >> +#include <linux/pci.h>
> >> +#include <linux/vdpa.h>
> >>
> >>   #include <linux/pds/pds_core.h>
> >>   #include <linux/pds/pds_auxbus.h>
> >> @@ -9,6 +11,7 @@
> >>
> >>   #include "aux_drv.h"
> >>   #include "debugfs.h"
> >> +#include "vdpa_dev.h"
> >>
> >>   static const struct auxiliary_device_id pds_vdpa_id_table[] =3D {
> >>          { .name =3D PDS_VDPA_DEV_NAME, },
> >> @@ -30,6 +33,7 @@ static int pds_vdpa_probe(struct auxiliary_device *a=
ux_dev,
> >>                  return -ENOMEM;
> >>
> >>          vdpa_aux->padev =3D padev;
> >> +       vdpa_aux->vf_id =3D pci_iov_vf_id(padev->vf->pdev);
> >>          auxiliary_set_drvdata(aux_dev, vdpa_aux);
> >>
> >>          /* Register our PDS client with the pds_core */
> >> @@ -40,8 +44,15 @@ static int pds_vdpa_probe(struct auxiliary_device *=
aux_dev,
> >>                  goto err_free_mem;
> >>          }
> >>
> >> +       /* Get device ident info and set up the vdpa_mgmt_dev */
> >> +       err =3D pds_vdpa_get_mgmt_info(vdpa_aux);
> >> +       if (err)
> >> +               goto err_aux_unreg;
> >> +
> >>          return 0;
> >>
> >> +err_aux_unreg:
> >> +       padev->ops->unregister_client(padev);
> >>   err_free_mem:
> >>          kfree(vdpa_aux);
> >>          auxiliary_set_drvdata(aux_dev, NULL);
> >> @@ -54,6 +65,8 @@ static void pds_vdpa_remove(struct auxiliary_device =
*aux_dev)
> >>          struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_d=
ev);
> >>          struct device *dev =3D &aux_dev->dev;
> >>
> >> +       pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
> >> +
> >>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
> >>
> >>          kfree(vdpa_aux);
> >> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> >> index 14e465944dfd..94ba7abcaa43 100644
> >> --- a/drivers/vdpa/pds/aux_drv.h
> >> +++ b/drivers/vdpa/pds/aux_drv.h
> >> @@ -10,6 +10,13 @@
> >>   struct pds_vdpa_aux {
> >>          struct pds_auxiliary_dev *padev;
> >>
> >> +       struct vdpa_mgmt_dev vdpa_mdev;
> >> +
> >> +       struct pds_vdpa_ident ident;
> >> +
> >> +       int vf_id;
> >>          struct dentry *dentry;
> >> +
> >> +       int nintrs;
> >>   };
> >>   #endif /* _AUX_DRV_H_ */
> >> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> >> index 3c163dc7b66f..7b7e90fd6578 100644
> >> --- a/drivers/vdpa/pds/debugfs.c
> >> +++ b/drivers/vdpa/pds/debugfs.c
> >> @@ -1,7 +1,10 @@
> >>   // SPDX-License-Identifier: GPL-2.0-only
> >>   /* Copyright(c) 2023 Advanced Micro Devices, Inc */
> >>
> >> +#include <linux/vdpa.h>
> >> +
> >>   #include <linux/pds/pds_core.h>
> >> +#include <linux/pds/pds_vdpa.h>
> >>   #include <linux/pds/pds_auxbus.h>
> >>
> >>   #include "aux_drv.h"
> >> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> >> new file mode 100644
> >> index 000000000000..bd840688503c
> >> --- /dev/null
> >> +++ b/drivers/vdpa/pds/vdpa_dev.c
> >> @@ -0,0 +1,113 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> >> +
> >> +#include <linux/pci.h>
> >> +#include <linux/vdpa.h>
> >> +#include <uapi/linux/vdpa.h>
> >> +
> >> +#include <linux/pds/pds_core.h>
> >> +#include <linux/pds/pds_adminq.h>
> >> +#include <linux/pds/pds_auxbus.h>
> >> +#include <linux/pds/pds_vdpa.h>
> >> +
> >> +#include "vdpa_dev.h"
> >> +#include "aux_drv.h"
> >> +
> >> +static struct virtio_device_id pds_vdpa_id_table[] =3D {
> >> +       {VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
> >> +       {0},
> >> +};
> >> +
> >> +static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *n=
ame,
> >> +                           const struct vdpa_dev_set_config *add_conf=
ig)
> >> +{
> >> +       return -EOPNOTSUPP;
> >> +}
> >> +
> >> +static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
> >> +                            struct vdpa_device *vdpa_dev)
> >> +{
> >> +}
> >> +
> >> +static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops =3D {
> >> +       .dev_add =3D pds_vdpa_dev_add,
> >> +       .dev_del =3D pds_vdpa_dev_del
> >> +};
> >> +
> >> +int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
> >> +{
> >> +       struct pds_vdpa_ident_cmd ident_cmd =3D {
> >> +               .opcode =3D PDS_VDPA_CMD_IDENT,
> >> +               .vf_id =3D cpu_to_le16(vdpa_aux->vf_id),
> >> +       };
> >> +       struct pds_vdpa_comp ident_comp =3D {0};
> >> +       struct vdpa_mgmt_dev *mgmt;
> >> +       struct device *pf_dev;
> >> +       struct pci_dev *pdev;
> >> +       dma_addr_t ident_pa;
> >> +       struct device *dev;
> >> +       u16 max_vqs;
> >> +       int err;
> >> +
> >> +       dev =3D &vdpa_aux->padev->aux_dev.dev;
> >> +       pdev =3D vdpa_aux->padev->vf->pdev;
> >> +       mgmt =3D &vdpa_aux->vdpa_mdev;
> >> +
> >> +       /* Get resource info through the PF's adminq.  It is a block o=
f info,
> >> +        * so we need to map some memory for PF to make available to t=
he
> >> +        * firmware for writing the data.
> >> +        */
> >
> > It looks to me pds_vdpa_ident is not very large:
> >
> > struct pds_vdpa_ident {
> >          __le64 hw_features;
> >          __le16 max_vqs;
> >          __le16 max_qlen;
> >          __le16 min_qlen;
> > };
> >
> > Any reason it is not packed into some type of the comp structure of adm=
inq?
>
> Unfortunately, the completion structs are limited to 16 bytes, with 4 up
> front and 1 at the end already spoken for.  I suppose we could shrink
> max_vqs to a single byte and squeeze this into the comp, but then we'd
> have no ability to add to it if needed.  I'd rather leave it as it is
> for now.

Fine.

Thanks

>
> sln
>
> >
> > Others look good.
> >
> > Thanks
> >
>

