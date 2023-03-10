Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FC16B35E5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCJFFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCJFFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11077DAB8B
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ME1A+qs7kq3XtZD/JNtKwRMcFUQsBn2Io39lnGwhc2Y=;
        b=POlNxqI2+N6zf93XQ1y5lC9QX72kkXRVSOFnedAWvvtBVtgWydTGuOUerv54919pA3hqX/
        7wUl0grk+gfjBkYyhEQA75QmGqfag0xQupQgzvdIi9TJwEMvyNz5keTbCnhj2/huXRG+0q
        W02kMRl0mKu0jXN4MEsGwLva9CYtkJc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-F0lw4Tv7OuWeHKdVKqSxDg-1; Fri, 10 Mar 2023 00:04:49 -0500
X-MC-Unique: F0lw4Tv7OuWeHKdVKqSxDg-1
Received: by mail-oi1-f199.google.com with SMTP id bh14-20020a056808180e00b00364c7610c6aso1957318oib.6
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:04:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ME1A+qs7kq3XtZD/JNtKwRMcFUQsBn2Io39lnGwhc2Y=;
        b=dWDPcBlZmq2YVgtNMNooZDC1rYZSEtR5N4+3D7zkpV0pYwwLQwSJLxUDiqC7xHM47H
         NA/AcoiHQPZWpollKOgddrb0v2uazNjrgUnMh/IDnEXhnuMVKRwOcCUxJz0sSXRlBhf6
         9AifdopARhHCDMQikfrQGFW9qpr5eRSUj2MiUxuULFPvlOhoIIdf8TyPzXjIei/99eFI
         w2nANT9bLKB2J0auK1kntOPjub5AMlqdqSrE3g8gxCTUhxk02Tx40wnssyrzGn7erQL1
         eJD8fdEae+1m5EaTWqGAgIaQCvVf11kifqUQ66p4lA/UqfjG8KEN0uXgU+IbqMQ1dpgM
         j0+Q==
X-Gm-Message-State: AO0yUKUN0c/meh1EU2zbewmjQ+Kod4mTRu42UKAReRcgjKBSWyuFT3Vz
        pXUBfzTTpuZ6L8fqOfVU671x06MzUuy6Y7P55yStIb3/dJpc/a5huIvDmjmApgp+WFalTj/6o/g
        v+jvUAiHZV4HAxBRdWLvYE8NvVdHbxxh/
X-Received: by 2002:a05:6871:6b9f:b0:176:2420:d0f4 with SMTP id zh31-20020a0568716b9f00b001762420d0f4mr8320891oab.9.1678424689082;
        Thu, 09 Mar 2023 21:04:49 -0800 (PST)
X-Google-Smtp-Source: AK7set/XiZx+eNpvX3Lw/Qse4ydxNP6yjeAv230lhVx1OdCN6k4J8Jxi03yh8ot3Eery2D4lXTsj9FwrPf2IjqB2gPo=
X-Received: by 2002:a05:6871:6b9f:b0:176:2420:d0f4 with SMTP id
 zh31-20020a0568716b9f00b001762420d0f4mr8320874oab.9.1678424688713; Thu, 09
 Mar 2023 21:04:48 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-9-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-9-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:04:37 +0800
Message-ID: <CACGkMEut9FY-2OYnAQPr_wGpcpVc3yurOA+imQARzVcMeuTH1A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/14] sfc: implement vdpa vring config operations
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
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

On Tue, Mar 7, 2023 at 7:37=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> This patch implements the vDPA config operations related to
> virtqueues or vrings. These include setting vring address,
> getting vq state, operations to enable/disable a vq etc.
> The resources required for vring operations eg. VI, interrupts etc.
> are also allocated.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 ++++++++++++++++++++++
>  3 files changed, 374 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet=
/sfc/ef100_vdpa.c
> index 4c5a98c9d6c3..c66e5aef69ea 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -14,6 +14,7 @@
>  #include "ef100_vdpa.h"
>  #include "mcdi_vdpa.h"
>  #include "mcdi_filters.h"
> +#include "mcdi_functions.h"
>  #include "ef100_netdev.h"
>
>  static struct virtio_device_id ef100_vdpa_id_table[] =3D {
> @@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data=
)
>         return rc;
>  }
>
> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocate=
d_vis)
> +{
> +       /* The first VI is reserved for MCDI
> +        * 1 VI each for rx + tx ring
> +        */
> +       unsigned int max_vis =3D 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
> +       unsigned int min_vis =3D 1 + 1;
> +       int rc;
> +
> +       rc =3D efx_mcdi_alloc_vis(efx, min_vis, max_vis,
> +                               NULL, allocated_vis);
> +       if (!rc)
> +               return rc;
> +       if (*allocated_vis < min_vis)
> +               return -ENOSPC;
> +       return 0;
> +}
> +
>  static void ef100_vdpa_delete(struct efx_nic *efx)
>  {
>         if (efx->vdpa_nic) {
>                 /* replace with _vdpa_unregister_device later */
>                 put_device(&efx->vdpa_nic->vdpa_dev.dev);
>         }
> +       efx_mcdi_free_vis(efx);
>  }
>
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data)
> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(stru=
ct efx_nic *efx,
>  {
>         struct ef100_nic_data *nic_data =3D efx->nic_data;
>         struct ef100_vdpa_nic *vdpa_nic;
> +       unsigned int allocated_vis;
>         int rc;
> +       u8 i;
>
>         nic_data->vdpa_class =3D dev_type;
> +       rc =3D vdpa_allocate_vis(efx, &allocated_vis);
> +       if (rc) {
> +               pci_err(efx->pci_dev,
> +                       "%s Alloc VIs failed for vf:%u error:%d\n",
> +                        __func__, nic_data->vf_index, rc);
> +               return ERR_PTR(rc);
> +       }
> +
>         vdpa_nic =3D vdpa_alloc_device(struct ef100_vdpa_nic,
>                                      vdpa_dev, &efx->pci_dev->dev,
>                                      &ef100_vdpa_config_ops,
> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struc=
t efx_nic *efx,
>                         "vDPA device allocation failed for vf: %u\n",
>                         nic_data->vf_index);
>                 nic_data->vdpa_class =3D EF100_VDPA_CLASS_NONE;
> -               return ERR_PTR(-ENOMEM);
> +               rc =3D -ENOMEM;
> +               goto err_alloc_vis_free;
>         }
>
>         mutex_init(&vdpa_nic->lock);
> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(str=
uct efx_nic *efx,
>         vdpa_nic->vdpa_dev.dma_dev =3D &efx->pci_dev->dev;
>         vdpa_nic->vdpa_dev.mdev =3D efx->mgmt_dev;
>         vdpa_nic->efx =3D efx;
> +       vdpa_nic->max_queue_pairs =3D allocated_vis - 1;
>         vdpa_nic->pf_index =3D nic_data->pf_index;
>         vdpa_nic->vf_index =3D nic_data->vf_index;
>         vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_INITIALIZED;
>         vdpa_nic->mac_address =3D (u8 *)&vdpa_nic->net_config.mac;
>
> +       for (i =3D 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
> +               rc =3D ef100_vdpa_init_vring(vdpa_nic, i);
> +               if (rc) {
> +                       pci_err(efx->pci_dev,
> +                               "vring init idx: %u failed, rc: %d\n", i,=
 rc);
> +                       goto err_put_device;
> +               }
> +       }
> +
>         rc =3D get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struc=
t efx_nic *efx,
>  err_put_device:
>         /* put_device invokes ef100_vdpa_free */
>         put_device(&vdpa_nic->vdpa_dev.dev);
> +
> +err_alloc_vis_free:
> +       efx_mcdi_free_vis(efx);
>         return ERR_PTR(rc);
>  }
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet=
/sfc/ef100_vdpa.h
> index dcf4a8156415..348ca8a7404b 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -32,6 +32,21 @@
>  /* Alignment requirement of the Virtqueue */
>  #define EF100_VDPA_VQ_ALIGN 4096
>
> +/* Vring configuration definitions */
> +#define EF100_VRING_ADDRESS_CONFIGURED 0x1
> +#define EF100_VRING_SIZE_CONFIGURED 0x10
> +#define EF100_VRING_READY_CONFIGURED 0x100
> +#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
> +                               EF100_VRING_SIZE_CONFIGURED | \
> +                               EF100_VRING_READY_CONFIGURED)
> +#define EF100_VRING_CREATED 0x1000
> +
> +/* Maximum size of msix name */
> +#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
> +
> +/* Default high IOVA for MCDI buffer */
> +#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
> +
>  /**
>   * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>   *
> @@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
>         EF100_VDPA_VQ_NTYPES
>  };
>
> +/**
> + * struct ef100_vdpa_vring_info - vDPA vring data structure
> + *
> + * @desc: Descriptor area address of the vring
> + * @avail: Available area address of the vring
> + * @used: Device area address of the vring
> + * @size: Number of entries in the vring
> + * @vring_state: bit map to track vring configuration
> + * @last_avail_idx: last available index of the vring
> + * @last_used_idx: last used index of the vring
> + * @doorbell_offset: doorbell offset
> + * @doorbell_offset_valid: true if @doorbell_offset is updated
> + * @vring_type: type of vring created
> + * @vring_ctx: vring context information
> + * @msix_name: device name for vring irq handler
> + * @irq: irq number for vring irq handler
> + * @cb: callback for vring interrupts
> + */
> +struct ef100_vdpa_vring_info {
> +       dma_addr_t desc;
> +       dma_addr_t avail;
> +       dma_addr_t used;
> +       u32 size;
> +       u16 vring_state;
> +       u32 last_avail_idx;
> +       u32 last_used_idx;
> +       u32 doorbell_offset;
> +       bool doorbell_offset_valid;
> +       enum ef100_vdpa_vq_type vring_type;
> +       struct efx_vring_ctx *vring_ctx;
> +       char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
> +       u32 irq;
> +       struct vdpa_callback cb;
> +};
> +
>  /**
>   *  struct ef100_vdpa_nic - vDPA NIC data structure
>   *
> @@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
>   * @features: negotiated feature bits
>   * @max_queue_pairs: maximum number of queue pairs supported
>   * @net_config: virtio_net_config data
> + * @vring: vring information of the vDPA device.
>   * @mac_address: mac address of interface associated with this vdpa devi=
ce
>   * @mac_configured: true after MAC address is configured
>   * @cfg_cb: callback for config change
> @@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
>         u64 features;
>         u32 max_queue_pairs;
>         struct virtio_net_config net_config;
> +       struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * =
2];
>         u8 *mac_address;
>         bool mac_configured;
>         struct vdpa_callback cfg_cb;
> @@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)=
;
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>  int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
> +void ef100_vdpa_irq_vectors_free(void *data);
> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa=
_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethe=
rnet/sfc/ef100_vdpa_ops.c
> index a2364ef9f492..0051c4c0e47c 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -9,13 +9,270 @@
>
>  #include <linux/vdpa.h>
>  #include "ef100_vdpa.h"
> +#include "io.h"
>  #include "mcdi_vdpa.h"
>
> +/* Get the queue's function-local index of the associated VI
> + * virtqueue number queue 0 is reserved for MCDI
> + */
> +#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
> +
>  static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>  {
>         return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>  }
>
> +void ef100_vdpa_irq_vectors_free(void *data)
> +{
> +       pci_free_irq_vectors(data);
> +}
> +
> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       struct efx_vring_ctx *vring_ctx;
> +       u32 vi_index;
> +
> +       if (idx % 2) /* Even VQ for RX and odd for TX */
> +               vdpa_nic->vring[idx].vring_type =3D EF100_VDPA_VQ_TYPE_NE=
T_TXQ;
> +       else
> +               vdpa_nic->vring[idx].vring_type =3D EF100_VDPA_VQ_TYPE_NE=
T_RXQ;
> +       vi_index =3D EFX_GET_VI_INDEX(idx);
> +       vring_ctx =3D efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
> +                                       vdpa_nic->vring[idx].vring_type);
> +       if (IS_ERR(vring_ctx))
> +               return PTR_ERR(vring_ctx);
> +
> +       vdpa_nic->vring[idx].vring_ctx =3D vring_ctx;
> +       return 0;
> +}
> +
> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
> +       vdpa_nic->vring[idx].vring_ctx =3D NULL;
> +}
> +
> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       vdpa_nic->vring[idx].vring_type =3D EF100_VDPA_VQ_NTYPES;
> +       vdpa_nic->vring[idx].vring_state =3D 0;
> +       vdpa_nic->vring[idx].last_avail_idx =3D 0;
> +       vdpa_nic->vring[idx].last_used_idx =3D 0;
> +}
> +
> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       u32 offset;
> +       int rc;
> +
> +       vdpa_nic->vring[idx].irq =3D -EINVAL;
> +       rc =3D create_vring_ctx(vdpa_nic, idx);
> +       if (rc) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: create_vring_ctx failed, idx:%u, err:%d\n",
> +                       __func__, idx, rc);
> +               return rc;
> +       }
> +
> +       rc =3D efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ct=
x,
> +                                         &offset);
> +       if (rc) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: get_doorbell failed idx:%u, err:%d\n",
> +                       __func__, idx, rc);
> +               goto err_get_doorbell_offset;
> +       }
> +       vdpa_nic->vring[idx].doorbell_offset =3D offset;
> +       vdpa_nic->vring[idx].doorbell_offset_valid =3D true;
> +
> +       return 0;
> +
> +err_get_doorbell_offset:
> +       delete_vring_ctx(vdpa_nic, idx);
> +       return rc;
> +}
> +
> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
> +                          const char *caller)
> +{
> +       if (unlikely(idx >=3D (vdpa_nic->max_queue_pairs * 2))) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: Invalid qid %u\n", caller, idx);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
> +                                    u16 idx, u64 desc_area, u64 driver_a=
rea,
> +                                    u64 device_area)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return -EINVAL;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       vdpa_nic->vring[idx].desc =3D desc_area;
> +       vdpa_nic->vring[idx].avail =3D driver_area;
> +       vdpa_nic->vring[idx].used =3D device_area;
> +       vdpa_nic->vring[idx].vring_state |=3D EF100_VRING_ADDRESS_CONFIGU=
RED;
> +       mutex_unlock(&vdpa_nic->lock);
> +       return 0;
> +}
> +
> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32=
 num)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return;
> +
> +       if (!is_power_of_2(num)) {
> +               dev_err(&vdev->dev, "%s: Index:%u size:%u not power of 2\=
n",
> +                       __func__, idx, num);
> +               return;
> +       }

Note that this is not a requirement for packed virtqueue.

"""
Queue Size corresponds to the maximum number of descriptors in the
virtqueue5. The Queue Size value does not have to be a power of 2.
"""

> +       if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
> +               dev_err(&vdev->dev, "%s: Index:%u size:%u more than max:%=
u\n",
> +                       __func__, idx, num, EF100_VDPA_VQ_NUM_MAX_SIZE);
> +               return;
> +       }
> +       mutex_lock(&vdpa_nic->lock);
> +       vdpa_nic->vring[idx].size  =3D num;
> +       vdpa_nic->vring[idx].vring_state |=3D EF100_VRING_SIZE_CONFIGURED=
;
> +       mutex_unlock(&vdpa_nic->lock);
> +}
> +
> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       u32 idx_val;
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return;
> +
> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> +               return;

In which case could we hit this condition?

> +
> +       idx_val =3D idx;
> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
> +                   vdpa_nic->vring[idx].doorbell_offset);
> +}
> +
> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
> +                                struct vdpa_callback *cb)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return;
> +
> +       if (cb)
> +               vdpa_nic->vring[idx].cb =3D *cb;
> +}
> +
> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
> +                                   bool ready)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       if (ready) {
> +               vdpa_nic->vring[idx].vring_state |=3D
> +                                       EF100_VRING_READY_CONFIGURED;

I think it would be sufficient to have EF100_VRING_READY_CONFIGURED
here. With this set, the device can think the vq configuration is done
by the driver.

Or is there anything special for size and num?

Thanks


> +       } else {
> +               vdpa_nic->vring[idx].vring_state &=3D
> +                                       ~EF100_VRING_READY_CONFIGURED;
> +       }
> +       mutex_unlock(&vdpa_nic->lock);
> +}
> +
> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       bool ready;
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return false;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       ready =3D vdpa_nic->vring[idx].vring_state & EF100_VRING_READY_CO=
NFIGURED;
> +       mutex_unlock(&vdpa_nic->lock);
> +       return ready;
> +}
> +
> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
> +                                  const struct vdpa_vq_state *state)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return -EINVAL;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       vdpa_nic->vring[idx].last_avail_idx =3D state->split.avail_index;
> +       vdpa_nic->vring[idx].last_used_idx =3D state->split.avail_index;
> +       mutex_unlock(&vdpa_nic->lock);
> +       return 0;
> +}
> +
> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
> +                                  u16 idx, struct vdpa_vq_state *state)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return -EINVAL;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       state->split.avail_index =3D (u16)vdpa_nic->vring[idx].last_used_=
idx;
> +       mutex_unlock(&vdpa_nic->lock);
> +
> +       return 0;
> +}
> +
> +static struct vdpa_notification_area
> +               ef100_vdpa_get_vq_notification(struct vdpa_device *vdev,
> +                                              u16 idx)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       struct vdpa_notification_area notify_area =3D {0, 0};
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               goto end;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       notify_area.addr =3D (uintptr_t)(vdpa_nic->efx->membase_phys +
> +                               vdpa_nic->vring[idx].doorbell_offset);
> +       /* VDPA doorbells are at a stride of VI/2
> +        * One VI stride is shared by both rx & tx doorbells
> +        */
> +       notify_area.size =3D vdpa_nic->efx->vi_stride / 2;
> +       mutex_unlock(&vdpa_nic->lock);
> +
> +end:
> +       return notify_area;
> +}
> +
> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       u32 irq;
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return -EINVAL;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       irq =3D vdpa_nic->vring[idx].irq;
> +       mutex_unlock(&vdpa_nic->lock);
> +
> +       return irq;
> +}
> +
>  static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>  {
>         return EF100_VDPA_VQ_ALIGN;
> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_devic=
e *vdev,
>
>         if (cb)
>                 vdpa_nic->cfg_cb =3D *cb;
> +       else
> +               memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
>  }
>
>  static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct vdpa_devic=
e *vdev, unsigned int offset,
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
>  {
>         struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       int i;
>
>         if (vdpa_nic) {
> +               for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> +                       reset_vring(vdpa_nic, i);
> +                       if (vdpa_nic->vring[i].vring_ctx)
> +                               delete_vring_ctx(vdpa_nic, i);
> +               }
>                 mutex_destroy(&vdpa_nic->lock);
>                 vdpa_nic->efx->vdpa_nic =3D NULL;
>         }
>  }
>
>  const struct vdpa_config_ops ef100_vdpa_config_ops =3D {
> +       .set_vq_address      =3D ef100_vdpa_set_vq_address,
> +       .set_vq_num          =3D ef100_vdpa_set_vq_num,
> +       .kick_vq             =3D ef100_vdpa_kick_vq,
> +       .set_vq_cb           =3D ef100_vdpa_set_vq_cb,
> +       .set_vq_ready        =3D ef100_vdpa_set_vq_ready,
> +       .get_vq_ready        =3D ef100_vdpa_get_vq_ready,
> +       .set_vq_state        =3D ef100_vdpa_set_vq_state,
> +       .get_vq_state        =3D ef100_vdpa_get_vq_state,
> +       .get_vq_notification =3D ef100_vdpa_get_vq_notification,
> +       .get_vq_irq          =3D ef100_get_vq_irq,
>         .get_vq_align        =3D ef100_vdpa_get_vq_align,
>         .get_device_features =3D ef100_vdpa_get_device_features,
>         .set_driver_features =3D ef100_vdpa_set_driver_features,
> --
> 2.30.1
>

