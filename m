Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E036BA8BC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCOHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjCOHHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAACD67807
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678863948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GK7ilReN9bo1OsYk8ynoSHPpp2q3aS8NUzPtNEQ8lp4=;
        b=IeyFyCQWsUaHtrbkjGiXx5O8gU9suj48uu2H8Fj8FRIlXo6TLzgFQwkqBGc5SF1O98rPPc
        h+rv06mYNcs6pl5Q4LSi9hnyBlOXIoMwO/9P42+qepK5ab6livUrN9+0EnUQWEML2deh/A
        AFCsfCid4RR0oNR5Bq79SlCyt3YS+D8=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-cMbP6cU3OA6GVIcbxfhAkQ-1; Wed, 15 Mar 2023 03:05:46 -0400
X-MC-Unique: cMbP6cU3OA6GVIcbxfhAkQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-177c2fb86b7so4326556fac.20
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678863946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GK7ilReN9bo1OsYk8ynoSHPpp2q3aS8NUzPtNEQ8lp4=;
        b=zoM1IsaVsXdL3Ik1iUX0FeyT+EQQG4cO0tWUYGMAWlBbe+riCQBW/utX3EJo+FFy87
         oNOdbSerUV90ybcSA8bvq+5pkbf9nxiSLm/nygVMhIPouRizHpKhp6PA+jdvLJ9aE4uQ
         ++Hvom0OtpZN1dONdMKOPjCFFnS2mHz4OiosZ9N522JFHd0QwlsbTAKIk3IbK7Q6QMTR
         SFXp1d/repEuRU5TuGwmX8YdA/hWlq00NSh6IDk1cxwn3qpscVCefkX/fOGwpko6WIJN
         mKCuskSp0Q32u0mMb919dBYvAqg2i4WwLJFDfcHjmVV778DKhOkafHyxCKhylMYVF1XG
         rKag==
X-Gm-Message-State: AO0yUKVhMqAWZUHvPzpXhMQzPdvqSygSmA0jWHOD/9uBMESzOOdp9/xJ
        1VDQzIcYQ7uEsDUUuDUSawKhUOQgfSAlUzAkU68UkGo+aQbneeuPgm0jNhJNrxLNeYwC5QVlmts
        1Gw5JbuP79NfjHFOQ0/6nf0rAc2PmP6JW
X-Received: by 2002:a05:6871:2315:b0:177:c2fb:8cec with SMTP id sf21-20020a056871231500b00177c2fb8cecmr3695926oab.9.1678863946008;
        Wed, 15 Mar 2023 00:05:46 -0700 (PDT)
X-Google-Smtp-Source: AK7set8KcrM8dHG6jtPovHcgo7AZZgpEN+/caS9S8RyxwNkv4Yu3cybwCiwoENy0G0s2/va5dDJGuUWBkn5MNPJrwwM=
X-Received: by 2002:a05:6871:2315:b0:177:c2fb:8cec with SMTP id
 sf21-20020a056871231500b00177c2fb8cecmr3695918oab.9.1678863945730; Wed, 15
 Mar 2023 00:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com> <20230309013046.23523-5-shannon.nelson@amd.com>
In-Reply-To: <20230309013046.23523-5-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Mar 2023 15:05:34 +0800
Message-ID: <CACGkMEtcm+VeTUKw_DF=bHFpYRUyqOkhh+UEfc+ppUp5zuNVkw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 4/7] pds_vdpa: add vdpa config client commands
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
> These are the adminq commands that will be needed for
> setting up and using the vDPA device.

It's better to explain under which case the driver should use adminq,
I see some functions overlap with common configuration capability.
More below.

>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/Makefile    |   1 +
>  drivers/vdpa/pds/cmds.c      | 207 +++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/cmds.h      |  16 +++
>  drivers/vdpa/pds/vdpa_dev.h  |  36 +++++-
>  include/linux/pds/pds_vdpa.h | 175 +++++++++++++++++++++++++++++
>  5 files changed, 434 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vdpa/pds/cmds.c
>  create mode 100644 drivers/vdpa/pds/cmds.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index ca2efa8c6eb5..7211eba3d942 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -4,6 +4,7 @@
>  obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
>
>  pds_vdpa-y :=3D aux_drv.o \
> +             cmds.o \
>               virtio_pci.o \
>               vdpa_dev.o
>
> diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
> new file mode 100644
> index 000000000000..45410739107c
> --- /dev/null
> +++ b/drivers/vdpa/pds/cmds.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
> +
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
> +               .len =3D cpu_to_le32(sizeof(struct virtio_net_config)),
> +               .config_pa =3D 0,   /* we use the PCI space, not an alter=
nate space */
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
> +               dev_err(dev, "Failed to init hw, status %d: %pe\n",
> +                       init_comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
> +{

This function is not used.

And I wonder what's the difference between reset via adminq and reset
via pds_vdpa_set_status(0) ?

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
> +               dev_err(dev, "Failed to reset hw, status %d: %pe\n",
> +                       comp.status, ERR_PTR(err));

It might be better to use deb_dbg() here since it can be triggered by the g=
uest.

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
> +               dev_err(dev, "Failed to set mac address %pM, status %d: %=
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
> +               dev_err(dev, "Failed to set max vq pairs %u, status %d: %=
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

We map common cfg in pds_vdpa_probe_virtio, any reason for using
adminq here? (I guess it might be faster?)

> +       if (err) {
> +               dev_err(dev, "Failed to init vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +               return err;
> +       }
> +
> +       vq_info->hw_qtype =3D comp.hw_qtype;

What does hw_qtype mean?

> +       vq_info->hw_qindex =3D le16_to_cpu(comp.hw_qindex);
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
> +               dev_err(dev, "Failed to reset vq %d, status %d: %pe\n",
> +                       qid, comp.status, ERR_PTR(err));
> +
> +       return err;
> +}
> +
> +int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features=
)
> +{
> +       struct pds_auxiliary_dev *padev =3D pdsv->vdpa_aux->padev;
> +       struct device *dev =3D &padev->aux_dev.dev;
> +       struct pds_vdpa_set_features_cmd cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_SET_FEATURES,
> +               .vdpa_index =3D pdsv->vdpa_index,
> +               .vf_id =3D cpu_to_le16(pdsv->vdpa_aux->vf_id),
> +               .features =3D cpu_to_le64(features),
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
> +               dev_err(dev, "Failed to set features %#llx, status %d: %p=
e\n",
> +                       features, comp.status, ERR_PTR(err));
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
> index 97fab833a0aa..33284ebe538c 100644
> --- a/drivers/vdpa/pds/vdpa_dev.h
> +++ b/drivers/vdpa/pds/vdpa_dev.h
> @@ -4,11 +4,45 @@
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
> +
> +       u8 hw_qtype;
> +       u16 hw_qindex;
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
> index 3f7c08551163..b6a4cb4d3c6b 100644
> --- a/include/linux/pds/pds_vdpa.h
> +++ b/include/linux/pds/pds_vdpa.h
> @@ -101,4 +101,179 @@ struct pds_vdpa_ident_cmd {
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

Just wonder in which case intr_index can be different from qid, in
pds_vdpa_cmd_init_vq() we had:

                .intr_index =3D cpu_to_le16(qid),

Thanks


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
>  #endif /* _PDS_VDPA_IF_H_ */
> --
> 2.17.1
>

