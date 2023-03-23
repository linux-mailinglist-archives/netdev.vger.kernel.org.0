Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1416C5E92
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCWFPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWFPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834491F5D4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679548482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2Jdqd/2gCdvIPf34/hVy9mCqJMpFikXBc+zmi+CxBg=;
        b=aNQjbqHcBEF9XEoBFuTUxQ6prM6CvqSnoyK90TxFSfkrBmr+0sGY46qPwE7cVevlC95fv6
        sfI7dbvWb+AiJXsCVdPGfpc/qzaODwpCRCiA8zlsf7/+pYOndMuPgTAWmXl9PLdxVPM83Z
        Fx+uScIm4yuicWSVAYKV6XLTm8AIrKs=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-6wY-tFVuN8uAb2xP0_a3iQ-1; Thu, 23 Mar 2023 01:14:40 -0400
X-MC-Unique: 6wY-tFVuN8uAb2xP0_a3iQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-17abb9d4b67so10831774fac.5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2Jdqd/2gCdvIPf34/hVy9mCqJMpFikXBc+zmi+CxBg=;
        b=poFlPDezdAUzqWgoV8BXbbdRoCIgzOyNd3eZmGM7kLol8yShanGS5GhpXJf4WPe2rd
         CZxqWk54L83B1o5y1ouLsaVGBRKVbwEmRRMXvBzF+VyXYzvaX0ZcoBA0OGwoG9+/HICz
         xTkeoncSjjhspGMhwlOqGj2Ta2BiJSn2y4SLwPM7uGDAKArdGag7ownIVJv5Q3FHmVHv
         s5LQJt4DienpiGtHOrFr9/ZcW42GfwJcR7OsupqIZqrfMad//fpToTKoG/F0KWWXK0jU
         v1FCzXKFf5j/X6m/eg2lQiOXRScYp0KQfLgdpzgDJ25eIkja0dzWpRCnPAFyaapEuuUh
         XDmg==
X-Gm-Message-State: AO0yUKWTv3Y70bWUdDR7WR8wRd7RrR5dBIy6SR9NOMstGLuTB80ELGVi
        2lw3aGBV7arLxJW9HE3gye3HJjjGutVEXI4fjMDotpNzYy3WQoRabxP141W5/he3Daa/JM3Uk9j
        ho3tC9t827CpI0Wwmn8iGJHJkNVBOCQte
X-Received: by 2002:a05:6870:f915:b0:177:ca1c:2ca8 with SMTP id ao21-20020a056870f91500b00177ca1c2ca8mr747257oac.9.1679548479550;
        Wed, 22 Mar 2023 22:14:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set9gczklWHhnh6A0gS6ubekKff3AvmKRfZG9kbinQCT3wo9Kk5nuhWo0YcOyoN5m4BsRibRG2B8CqyoQLUftsbM=
X-Received: by 2002:a05:6870:f915:b0:177:ca1c:2ca8 with SMTP id
 ao21-20020a056870f91500b00177ca1c2ca8mr747251oac.9.1679548479278; Wed, 22 Mar
 2023 22:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-6-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-6-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 13:14:28 +0800
Message-ID: <CACGkMEt4m-g1OFyD9rF8Zjepgg7xUPJxYk8e__67_TD_NKzkcA@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 5/8] pds_vdpa: add vdpa config client commands
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
> These are the adminq commands that will be needed for
> setting up and using the vDPA device.  There are a number
> of commands defined in the FW's API, but by making use of
> the FW's virtio BAR we only need a few of these commands
> for vDPA support.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/pds/Makefile    |   1 +
>  drivers/vdpa/pds/cmds.c      | 178 +++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/cmds.h      |  16 ++++
>  drivers/vdpa/pds/vdpa_dev.h  |  33 ++++++-
>  include/linux/pds/pds_vdpa.h | 175 ++++++++++++++++++++++++++++++++++
>  5 files changed, 402 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vdpa/pds/cmds.c
>  create mode 100644 drivers/vdpa/pds/cmds.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index 13b50394ec64..2e22418e3ab3 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -4,6 +4,7 @@
>  obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
>
>  pds_vdpa-y :=3D aux_drv.o \
> +             cmds.o \
>               vdpa_dev.o
>
>  pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
> new file mode 100644
> index 000000000000..b847d708e4cc
> --- /dev/null
> +++ b/drivers/vdpa/pds/cmds.c
> @@ -0,0 +1,178 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_auxbus.h>
> +#include <linux/pds/pds_vdpa.h>
> +
> +#include "vdpa_dev.h"
> +#include "aux_drv.h"
> +#include "cmds.h"
> +
> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_init_cmd init_cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_INIT,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +       };
> +       struct pds_vdpa_comp init_comp =3D {0};
> +       int err;
> +
> +       /* Initialize the vdpa/virtio device */
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&init_c=
md,
> +                                    sizeof(init_cmd),
> +                                    (union pds_core_adminq_comp *)&init_=
comp,
> +                                    0);
> +       if (err)
> +               dev_dbg(dev, "Failed to init hw, status %d: %pe\n",
> +                       init_comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_RESET,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +       };
> +       struct pds_vdpa_comp comp =3D {0};
> +       int err;
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err)
> +               dev_dbg(dev, "Failed to reset hw, status %d: %pe\n",
> +                       comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_setattr_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_SET_ATTR,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .attr =3D PDS_VDPA_ATTR_MAC,
> +       };
> +       struct pds_vdpa_comp comp =3D {0};
> +       int err;
> +
> +       ether_addr_copy(cmd.mac, mac);
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err)
> +               dev_dbg(dev, "Failed to set mac address %pM, status %d: %=
pe\n",
> +                       mac, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_=
vqp)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_setattr_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_SET_ATTR,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .attr =3D PDS_VDPA_ATTR_MAX_VQ_PAIRS,
> +               .max_vq_pairs =3D cpu_to_le16(max_vqp),
> +       };
> +       struct pds_vdpa_comp comp =3D {0};
> +       int err;
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err)
> +               dev_dbg(dev, "Failed to set max vq pairs %u, status %d: %=
pe\n",
> +                       max_vqp, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
> +                        struct pds_vdpa_vq_info *vq_info)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_vq_init_comp comp =3D {0};
> +       struct pds_vdpa_vq_init_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_VQ_INIT,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .qid =3D cpu_to_le16(qid),
> +               .len =3D cpu_to_le16(ilog2(vq_info->q_len)),
> +               .desc_addr =3D cpu_to_le64(vq_info->desc_addr),
> +               .avail_addr =3D cpu_to_le64(vq_info->avail_addr),
> +               .used_addr =3D cpu_to_le64(vq_info->used_addr),
> +               .intr_index =3D cpu_to_le16(qid),
> +       };
> +       int err;
> +
> +       dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx =
used_addr %#llx\n",
> +               __func__, qid, ilog2(vq_info->q_len),
> +               vq_info->desc_addr, vq_info->avail_addr, vq_info->used_ad=
dr);
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err) {
> +               dev_dbg(dev, "Failed to init vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_vq_reset_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_VQ_RESET,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .qid =3D cpu_to_le16(qid),
> +       };
> +       struct pds_vdpa_comp comp =3D {0};
> +       int err;
> +
> +       err =3D padev->ops->adminq_cmd(padev,
> +                                    (union pds_core_adminq_cmd *)&cmd,
> +                                    sizeof(cmd),
> +                                    (union pds_core_adminq_comp *)&comp,
> +                                    0);
> +       if (err)
> +               dev_dbg(dev, "Failed to reset vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
> new file mode 100644
> index 000000000000..72e19f4efde6
> --- /dev/null
> +++ b/drivers/vdpa/pds/cmds.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _VDPA_CMDS_H_
> +#define _VDPA_CMDS_H_
> +
> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv);
> +
> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv);
> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac);
> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_=
vqp);
> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
> +                        struct pds_vdpa_vq_info *vq_info);
> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid);
> +int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features=
);
> +#endif /* _VDPA_CMDS_H_ */
> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
> index 97fab833a0aa..a21596f438c1 100644
> --- a/drivers/vdpa/pds/vdpa_dev.h
> +++ b/drivers/vdpa/pds/vdpa_dev.h
> @@ -4,11 +4,42 @@
>  #ifndef _VDPA_DEV_H_
>  #define _VDPA_DEV_H_
>
> -#define PDS_VDPA_MAX_QUEUES    65
> +#include <linux/pci.h>
> +#include <linux/vdpa.h>
> +
> +struct pds_vdpa_vq_info {
> +       bool ready;
> +       u64 desc_addr;
> +       u64 avail_addr;
> +       u64 used_addr;
> +       u32 q_len;
> +       u16 qid;
> +       int irq;
> +       char irq_name[32];
> +
> +       void __iomem *notify;
> +       dma_addr_t notify_pa;
> +
> +       u64 doorbell;
> +       u16 avail_idx;
> +       u16 used_idx;
>
> +       struct vdpa_callback event_cb;
> +       struct pds_vdpa_device *pdsv;
> +};
> +
> +#define PDS_VDPA_MAX_QUEUES    65
> +#define PDS_VDPA_MAX_QLEN      32768
>  struct pds_vdpa_device {
>         struct vdpa_device vdpa_dev;
>         struct pds_vdpa_aux *vdpa_aux;
> +
> +       struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
> +       u64 req_features;               /* features requested by vdpa */
> +       u64 actual_features;            /* features negotiated and in use=
 */
> +       u8 vdpa_index;                  /* rsvd for future subdevice use =
*/
> +       u8 num_vqs;                     /* num vqs in use */
> +       struct vdpa_callback config_cb;
>  };
>
>  int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
> index c1d6a3fe2d61..785909a6daf6 100644
> --- a/include/linux/pds/pds_vdpa.h
> +++ b/include/linux/pds/pds_vdpa.h
> @@ -97,4 +97,179 @@ struct pds_vdpa_ident_cmd {
>         __le32 len;
>         __le64 ident_pa;
>  };
> +
> +/**
> + * struct pds_vdpa_status_cmd - STATUS_UPDATE command
> + * @opcode:    Opcode PDS_VDPA_CMD_STATUS_UPDATE
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @status:    new status bits
> + */
> +struct pds_vdpa_status_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       u8     status;
> +};
> +
> +/**
> + * enum pds_vdpa_attr - List of VDPA device attributes
> + * @PDS_VDPA_ATTR_MAC:          MAC address
> + * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
> + */
> +enum pds_vdpa_attr {
> +       PDS_VDPA_ATTR_MAC          =3D 1,
> +       PDS_VDPA_ATTR_MAX_VQ_PAIRS =3D 2,
> +};
> +
> +/**
> + * struct pds_vdpa_setattr_cmd - SET_ATTR command
> + * @opcode:            Opcode PDS_VDPA_CMD_SET_ATTR
> + * @vdpa_index:                Index for vdpa subdevice
> + * @vf_id:             VF id
> + * @attr:              attribute to be changed (enum pds_vdpa_attr)
> + * @pad:               Word boundary padding
> + * @mac:               new mac address to be assigned as vdpa device add=
ress
> + * @max_vq_pairs:      new limit of virtqueue pairs
> + */
> +struct pds_vdpa_setattr_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       u8     attr;
> +       u8     pad[3];
> +       union {
> +               u8 mac[6];
> +               __le16 max_vq_pairs;
> +       } __packed;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_cmd - queue init command
> + * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id (bit0 clear =3D rx, bit0 set =3D tx, qid=3DN is =
ctrlq)
> + * @len:       log(2) of max descriptor count
> + * @desc_addr: DMA address of descriptor area
> + * @avail_addr:        DMA address of available descriptors (aka driver =
area)
> + * @used_addr: DMA address of used descriptors (aka device area)
> + * @intr_index:        interrupt index
> + */
> +struct pds_vdpa_vq_init_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +       __le16 len;
> +       __le64 desc_addr;
> +       __le64 avail_addr;
> +       __le64 used_addr;
> +       __le16 intr_index;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_init_comp - queue init completion
> + * @status:    Status of the command (enum pds_core_status_code)
> + * @hw_qtype:  HW queue type, used in doorbell selection
> + * @hw_qindex: HW queue index, used in doorbell selection
> + * @rsvd:      Word boundary padding
> + * @color:     Color bit
> + */
> +struct pds_vdpa_vq_init_comp {
> +       u8     status;
> +       u8     hw_qtype;
> +       __le16 hw_qindex;
> +       u8     rsvd[11];
> +       u8     color;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_reset_cmd - queue reset command
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_RESET
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + */
> +struct pds_vdpa_vq_reset_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +};
> +
> +/**
> + * struct pds_vdpa_set_features_cmd - set hw features
> + * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @rsvd:       Word boundary padding
> + * @features:  Feature bit mask
> + */
> +struct pds_vdpa_set_features_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le32 rsvd;
> +       __le64 features;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_set_state_cmd - set vq state
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_SET_STATE
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + * @avail:     Device avail index.
> + * @used:      Device used index.
> + *
> + * If the virtqueue uses packed descriptor format, then the avail and us=
ed
> + * index must have a wrap count.  The bits should be arranged like the u=
pper
> + * 16 bits in the device available notification data: 15 bit index, 1 bi=
t wrap.
> + */
> +struct pds_vdpa_vq_set_state_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +       __le16 avail;
> +       __le16 used;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_get_state_cmd - get vq state
> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_GET_STATE
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @qid:       Queue id
> + */
> +struct pds_vdpa_vq_get_state_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +       __le16 qid;
> +};
> +
> +/**
> + * struct pds_vdpa_vq_get_state_comp - get vq state completion
> + * @status:    Status of the command (enum pds_core_status_code)
> + * @rsvd0:      Word boundary padding
> + * @avail:     Device avail index.
> + * @used:      Device used index.
> + * @rsvd:       Word boundary padding
> + * @color:     Color bit
> + *
> + * If the virtqueue uses packed descriptor format, then the avail and us=
ed
> + * index will have a wrap count.  The bits will be arranged like the "ne=
xt"
> + * part of device available notification data: 15 bit index, 1 bit wrap.
> + */
> +struct pds_vdpa_vq_get_state_comp {
> +       u8     status;
> +       u8     rsvd0;
> +       __le16 avail;
> +       __le16 used;
> +       u8     rsvd[9];
> +       u8     color;
> +};
> +
>  #endif /* _PDS_VDPA_H_ */
> --
> 2.17.1
>

