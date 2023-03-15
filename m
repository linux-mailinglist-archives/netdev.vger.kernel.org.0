Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07A06BA685
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCOFJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCOFJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:09:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443802ED68
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678856938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jw5sTb6LYwq2f2ghqtUbSQ2J9VfrG4ShdaQzyFyEDE=;
        b=HJyPOenxpm8yzjYlFdMc8MdQ0GVPlLhJn6T9J2kVajZlTVG6APo9uHuY+Y4BGqx56aDsT2
        Llsuvjhkd+2XhW5Jp8ky9TqyIPl34k1sqd5wotuIR4ITYxrHHVFY8RP6jRv2aBZ1+Zr6Qj
        vahx5sSIkga9Oq2p64DSEIIBvhDALFo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-NTjY7e2KOTKFLh_h7KaG0A-1; Wed, 15 Mar 2023 01:08:55 -0400
X-MC-Unique: NTjY7e2KOTKFLh_h7KaG0A-1
Received: by mail-pj1-f71.google.com with SMTP id e8-20020a17090a118800b0023d35ae431eso2082548pja.8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678856934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jw5sTb6LYwq2f2ghqtUbSQ2J9VfrG4ShdaQzyFyEDE=;
        b=Vi7F7dhytnXurie+pY2xWQro0ytCTJhln/BrY6uGcvAhRKG3FHRbjDPA/F9nceePT0
         3yX2GKLatS7EtYtvXfqY3u1VC0nN3UJVI0zCsK3muHNV3DwPZZ3K+aejzjlizqnUAvlm
         ZMkYqjvJ+ZHPk83qgsocQGb4ZIc0HjuUjDxIMN3d+CWbj9G7iqxHhWi8S3qqzUCSthE0
         OgwJDTVsafHnWi/DiUBhEcNrE/TKMQekPY6vaGyYs7KmoRa33+ZdQLNOavtL4XLy00k0
         VFAWwSLICCFE3hKPBRaT7YlBPrjg4DxRw6zG2WR6lwOxdFwbOW3qg5ApHkFtoxMSrOvl
         iyGg==
X-Gm-Message-State: AO0yUKXMLIhMI8Fwfgo1eqWD+v4l1N75ZkcqFAIzBqIVYAwH/yQLiD+q
        5sMvjHOG0hKcdSWu7rocaCYR6rjroFYJ02uBp/JpiW/Oj9O1H6aU0VrmAI6s8TomA8XzhwaFrSC
        TQApgAA3Davn9LjP2
X-Received: by 2002:a17:90b:4a48:b0:23e:2b3c:d4a7 with SMTP id lb8-20020a17090b4a4800b0023e2b3cd4a7mr1095012pjb.35.1678856933809;
        Tue, 14 Mar 2023 22:08:53 -0700 (PDT)
X-Google-Smtp-Source: AK7set/gBSxKlLgIxQlpCk9QiRoOvjLPg3BfL8X0rRnpMTQMOZl2/3hC2JegCk3yK3QYCkfMWU/2kQ==
X-Received: by 2002:a17:90b:4a48:b0:23e:2b3c:d4a7 with SMTP id lb8-20020a17090b4a4800b0023e2b3cd4a7mr1094992pjb.35.1678856933320;
        Tue, 14 Mar 2023 22:08:53 -0700 (PDT)
Received: from [10.72.12.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f54a00b00196025a34b9sm2580500plf.159.2023.03.14.22.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 22:08:52 -0700 (PDT)
Message-ID: <8572a910-82a1-1020-5abe-5adbd38cc8bc@redhat.com>
Date:   Wed, 15 Mar 2023 13:08:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 08/14] sfc: implement vdpa vring config
 operations
Content-Language: en-US
To:     Gautam Dawar <gdawar@amd.com>, Gautam Dawar <gautam.dawar@amd.com>
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
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-9-gautam.dawar@amd.com>
 <CACGkMEut9FY-2OYnAQPr_wGpcpVc3yurOA+imQARzVcMeuTH1A@mail.gmail.com>
 <7522e236-3105-bc1d-6c14-6fba82703abc@amd.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <7522e236-3105-bc1d-6c14-6fba82703abc@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/13 20:33, Gautam Dawar 写道:
>
> On 3/10/23 10:34, Jason Wang wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On Tue, Mar 7, 2023 at 7:37 PM Gautam Dawar <gautam.dawar@amd.com> 
>> wrote:
>>> This patch implements the vDPA config operations related to
>>> virtqueues or vrings. These include setting vring address,
>>> getting vq state, operations to enable/disable a vq etc.
>>> The resources required for vring operations eg. VI, interrupts etc.
>>> are also allocated.
>>>
>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>> ---
>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 
>>> ++++++++++++++++++++++
>>>   3 files changed, 374 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> index 4c5a98c9d6c3..c66e5aef69ea 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> @@ -14,6 +14,7 @@
>>>   #include "ef100_vdpa.h"
>>>   #include "mcdi_vdpa.h"
>>>   #include "mcdi_filters.h"
>>> +#include "mcdi_functions.h"
>>>   #include "ef100_netdev.h"
>>>
>>>   static struct virtio_device_id ef100_vdpa_id_table[] = {
>>> @@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data 
>>> *probe_data)
>>>          return rc;
>>>   }
>>>
>>> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int 
>>> *allocated_vis)
>>> +{
>>> +       /* The first VI is reserved for MCDI
>>> +        * 1 VI each for rx + tx ring
>>> +        */
>>> +       unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
>>> +       unsigned int min_vis = 1 + 1;
>>> +       int rc;
>>> +
>>> +       rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
>>> +                               NULL, allocated_vis);
>>> +       if (!rc)
>>> +               return rc;
>>> +       if (*allocated_vis < min_vis)
>>> +               return -ENOSPC;
>>> +       return 0;
>>> +}
>>> +
>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>   {
>>>          if (efx->vdpa_nic) {
>>>                  /* replace with _vdpa_unregister_device later */
>>> put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>          }
>>> +       efx_mcdi_free_vis(efx);
>>>   }
>>>
>>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>>> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>   {
>>>          struct ef100_nic_data *nic_data = efx->nic_data;
>>>          struct ef100_vdpa_nic *vdpa_nic;
>>> +       unsigned int allocated_vis;
>>>          int rc;
>>> +       u8 i;
>>>
>>>          nic_data->vdpa_class = dev_type;
>>> +       rc = vdpa_allocate_vis(efx, &allocated_vis);
>>> +       if (rc) {
>>> +               pci_err(efx->pci_dev,
>>> +                       "%s Alloc VIs failed for vf:%u error:%d\n",
>>> +                        __func__, nic_data->vf_index, rc);
>>> +               return ERR_PTR(rc);
>>> +       }
>>> +
>>>          vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>>>                                       vdpa_dev, &efx->pci_dev->dev,
>>> &ef100_vdpa_config_ops,
>>> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>                          "vDPA device allocation failed for vf: %u\n",
>>>                          nic_data->vf_index);
>>>                  nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>>> -               return ERR_PTR(-ENOMEM);
>>> +               rc = -ENOMEM;
>>> +               goto err_alloc_vis_free;
>>>          }
>>>
>>>          mutex_init(&vdpa_nic->lock);
>>> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>          vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>>>          vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>>>          vdpa_nic->efx = efx;
>>> +       vdpa_nic->max_queue_pairs = allocated_vis - 1;
>>>          vdpa_nic->pf_index = nic_data->pf_index;
>>>          vdpa_nic->vf_index = nic_data->vf_index;
>>>          vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>          vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>>>
>>> +       for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
>>> +               rc = ef100_vdpa_init_vring(vdpa_nic, i);
>>> +               if (rc) {
>>> +                       pci_err(efx->pci_dev,
>>> +                               "vring init idx: %u failed, rc: 
>>> %d\n", i, rc);
>>> +                       goto err_put_device;
>>> +               }
>>> +       }
>>> +
>>>          rc = get_net_config(vdpa_nic);
>>>          if (rc)
>>>                  goto err_put_device;
>>> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>   err_put_device:
>>>          /* put_device invokes ef100_vdpa_free */
>>>          put_device(&vdpa_nic->vdpa_dev.dev);
>>> +
>>> +err_alloc_vis_free:
>>> +       efx_mcdi_free_vis(efx);
>>>          return ERR_PTR(rc);
>>>   }
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> index dcf4a8156415..348ca8a7404b 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> @@ -32,6 +32,21 @@
>>>   /* Alignment requirement of the Virtqueue */
>>>   #define EF100_VDPA_VQ_ALIGN 4096
>>>
>>> +/* Vring configuration definitions */
>>> +#define EF100_VRING_ADDRESS_CONFIGURED 0x1
>>> +#define EF100_VRING_SIZE_CONFIGURED 0x10
>>> +#define EF100_VRING_READY_CONFIGURED 0x100
>>> +#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
>>> +                               EF100_VRING_SIZE_CONFIGURED | \
>>> +                               EF100_VRING_READY_CONFIGURED)
>>> +#define EF100_VRING_CREATED 0x1000
>>> +
>>> +/* Maximum size of msix name */
>>> +#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
>>> +
>>> +/* Default high IOVA for MCDI buffer */
>>> +#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
>>> +
>>>   /**
>>>    * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>>>    *
>>> @@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
>>>          EF100_VDPA_VQ_NTYPES
>>>   };
>>>
>>> +/**
>>> + * struct ef100_vdpa_vring_info - vDPA vring data structure
>>> + *
>>> + * @desc: Descriptor area address of the vring
>>> + * @avail: Available area address of the vring
>>> + * @used: Device area address of the vring
>>> + * @size: Number of entries in the vring
>>> + * @vring_state: bit map to track vring configuration
>>> + * @last_avail_idx: last available index of the vring
>>> + * @last_used_idx: last used index of the vring
>>> + * @doorbell_offset: doorbell offset
>>> + * @doorbell_offset_valid: true if @doorbell_offset is updated
>>> + * @vring_type: type of vring created
>>> + * @vring_ctx: vring context information
>>> + * @msix_name: device name for vring irq handler
>>> + * @irq: irq number for vring irq handler
>>> + * @cb: callback for vring interrupts
>>> + */
>>> +struct ef100_vdpa_vring_info {
>>> +       dma_addr_t desc;
>>> +       dma_addr_t avail;
>>> +       dma_addr_t used;
>>> +       u32 size;
>>> +       u16 vring_state;
>>> +       u32 last_avail_idx;
>>> +       u32 last_used_idx;
>>> +       u32 doorbell_offset;
>>> +       bool doorbell_offset_valid;
>>> +       enum ef100_vdpa_vq_type vring_type;
>>> +       struct efx_vring_ctx *vring_ctx;
>>> +       char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
>>> +       u32 irq;
>>> +       struct vdpa_callback cb;
>>> +};
>>> +
>>>   /**
>>>    *  struct ef100_vdpa_nic - vDPA NIC data structure
>>>    *
>>> @@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
>>>    * @features: negotiated feature bits
>>>    * @max_queue_pairs: maximum number of queue pairs supported
>>>    * @net_config: virtio_net_config data
>>> + * @vring: vring information of the vDPA device.
>>>    * @mac_address: mac address of interface associated with this 
>>> vdpa device
>>>    * @mac_configured: true after MAC address is configured
>>>    * @cfg_cb: callback for config change
>>> @@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
>>>          u64 features;
>>>          u32 max_queue_pairs;
>>>          struct virtio_net_config net_config;
>>> +       struct ef100_vdpa_vring_info 
>>> vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>>          u8 *mac_address;
>>>          bool mac_configured;
>>>          struct vdpa_callback cfg_cb;
>>> @@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data 
>>> *probe_data);
>>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>>>   int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>> +void ef100_vdpa_irq_vectors_free(void *data);
>>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>>
>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic 
>>> *vdpa_nic)
>>>   {
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> index a2364ef9f492..0051c4c0e47c 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> @@ -9,13 +9,270 @@
>>>
>>>   #include <linux/vdpa.h>
>>>   #include "ef100_vdpa.h"
>>> +#include "io.h"
>>>   #include "mcdi_vdpa.h"
>>>
>>> +/* Get the queue's function-local index of the associated VI
>>> + * virtqueue number queue 0 is reserved for MCDI
>>> + */
>>> +#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
>>> +
>>>   static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>>>   {
>>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>>   }
>>>
>>> +void ef100_vdpa_irq_vectors_free(void *data)
>>> +{
>>> +       pci_free_irq_vectors(data);
>>> +}
>>> +
>>> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       struct efx_vring_ctx *vring_ctx;
>>> +       u32 vi_index;
>>> +
>>> +       if (idx % 2) /* Even VQ for RX and odd for TX */
>>> +               vdpa_nic->vring[idx].vring_type = 
>>> EF100_VDPA_VQ_TYPE_NET_TXQ;
>>> +       else
>>> +               vdpa_nic->vring[idx].vring_type = 
>>> EF100_VDPA_VQ_TYPE_NET_RXQ;
>>> +       vi_index = EFX_GET_VI_INDEX(idx);
>>> +       vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
>>> + vdpa_nic->vring[idx].vring_type);
>>> +       if (IS_ERR(vring_ctx))
>>> +               return PTR_ERR(vring_ctx);
>>> +
>>> +       vdpa_nic->vring[idx].vring_ctx = vring_ctx;
>>> +       return 0;
>>> +}
>>> +
>>> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> + efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
>>> +       vdpa_nic->vring[idx].vring_ctx = NULL;
>>> +}
>>> +
>>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>> +       vdpa_nic->vring[idx].vring_state = 0;
>>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>>> +}
>>> +
>>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       u32 offset;
>>> +       int rc;
>>> +
>>> +       vdpa_nic->vring[idx].irq = -EINVAL;
>>> +       rc = create_vring_ctx(vdpa_nic, idx);
>>> +       if (rc) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: create_vring_ctx failed, idx:%u, 
>>> err:%d\n",
>>> +                       __func__, idx, rc);
>>> +               return rc;
>>> +       }
>>> +
>>> +       rc = 
>>> efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
>>> +                                         &offset);
>>> +       if (rc) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: get_doorbell failed idx:%u, err:%d\n",
>>> +                       __func__, idx, rc);
>>> +               goto err_get_doorbell_offset;
>>> +       }
>>> +       vdpa_nic->vring[idx].doorbell_offset = offset;
>>> +       vdpa_nic->vring[idx].doorbell_offset_valid = true;
>>> +
>>> +       return 0;
>>> +
>>> +err_get_doorbell_offset:
>>> +       delete_vring_ctx(vdpa_nic, idx);
>>> +       return rc;
>>> +}
>>> +
>>> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>> +                          const char *caller)
>>> +{
>>> +       if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: Invalid qid %u\n", caller, idx);
>>> +               return true;
>>> +       }
>>> +       return false;
>>> +}
>>> +
>>> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>> +                                    u16 idx, u64 desc_area, u64 
>>> driver_area,
>>> +                                    u64 device_area)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return -EINVAL;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       vdpa_nic->vring[idx].desc = desc_area;
>>> +       vdpa_nic->vring[idx].avail = driver_area;
>>> +       vdpa_nic->vring[idx].used = device_area;
>>> +       vdpa_nic->vring[idx].vring_state |= 
>>> EF100_VRING_ADDRESS_CONFIGURED;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return 0;
>>> +}
>>> +
>>> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 
>>> idx, u32 num)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return;
>>> +
>>> +       if (!is_power_of_2(num)) {
>>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u not power 
>>> of 2\n",
>>> +                       __func__, idx, num);
>>> +               return;
>>> +       }
>> Note that this is not a requirement for packed virtqueue.
>>
>> """
>> Queue Size corresponds to the maximum number of descriptors in the
>> virtqueue5. The Queue Size value does not have to be a power of 2.
>> """
> Yes, but we are using split vrings and virtio spec states "Queue Size 
> value is always a power of 2" for Split virtqueues.


Did you mean the device can only support split virtqueue? If yes, we'd 
better document this.

But this seems not scalable consider the packed virtqueue could be 
supported in the future. It would be nice if device can fail the command 
according to the type of the virtqueue, then the driver doesn't need any 
care about this.


>>
>>> +       if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
>>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u more than 
>>> max:%u\n",
>>> +                       __func__, idx, num, 
>>> EF100_VDPA_VQ_NUM_MAX_SIZE);
>>> +               return;
>>> +       }
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       vdpa_nic->vring[idx].size  = num;
>>> +       vdpa_nic->vring[idx].vring_state |= 
>>> EF100_VRING_SIZE_CONFIGURED;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +}
>>> +
>>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       u32 idx_val;
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return;
>>> +
>>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>> +               return;
>> In which case could we hit this condition?
> I've noticed this condition in regular testing with vhost-vdpa. The 
> first couple of kick_vq calls arrive when the HW queues aren't created 
> yet. .I think userspace assumes queues to be ready soon after sending 
> DRIVER_OK. However, there is a little time window between that and 
> when the HW VQs are actually ready for datapath.


Interesting, so I think the driver need to wait until the HW VQS are 
ready before return from DRIVER_OK setting in this case. Otherwise we 
may end up with the above check (and it probably lacks some kind of 
synchronization).


>>
>>> +
>>> +       idx_val = idx;
>>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>> +                   vdpa_nic->vring[idx].doorbell_offset);
>>> +}
>>> +
>>> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>> +                                struct vdpa_callback *cb)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return;
>>> +
>>> +       if (cb)
>>> +               vdpa_nic->vring[idx].cb = *cb;
>>> +}
>>> +
>>> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
>>> +                                   bool ready)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       if (ready) {
>>> +               vdpa_nic->vring[idx].vring_state |=
>>> + EF100_VRING_READY_CONFIGURED;
>> I think it would be sufficient to have EF100_VRING_READY_CONFIGURED
>> here. With this set, the device can think the vq configuration is done
>> by the driver.
>>
>> Or is there anything special for size and num?
> The virtqueue is considered ready for datapath when it is fully 
> configured (both size and address set and enabled with set_vq_ready). 
> Depending on merely the queue enable (EF100_VRING_READY_CONFIGURED) 
> would assume valid values for vq size and addresses, which we wish to 
> avoid.


Ok, but I'd say it's better to offload those to the device. According to 
the spec, once queue_enable is set, the device assumes the virtqueue 
configuration is ready (no matter if size and num are configured). And 
driver risks its own for wrong configuration and device should be ready 
for invalid configuration (this is even the case with the above codes, 
device should still need to care about illegal size and num).

Thanks


>>
>> Thanks
>>
>>
>>> +       } else {
>>> +               vdpa_nic->vring[idx].vring_state &=
>>> + ~EF100_VRING_READY_CONFIGURED;
>>> +       }
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +}
>>> +
>>> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       bool ready;
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return false;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       ready = vdpa_nic->vring[idx].vring_state & 
>>> EF100_VRING_READY_CONFIGURED;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return ready;
>>> +}
>>> +
>>> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>>> +                                  const struct vdpa_vq_state *state)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return -EINVAL;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       vdpa_nic->vring[idx].last_avail_idx = state->split.avail_index;
>>> +       vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return 0;
>>> +}
>>> +
>>> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
>>> +                                  u16 idx, struct vdpa_vq_state 
>>> *state)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return -EINVAL;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       state->split.avail_index = 
>>> (u16)vdpa_nic->vring[idx].last_used_idx;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static struct vdpa_notification_area
>>> +               ef100_vdpa_get_vq_notification(struct vdpa_device 
>>> *vdev,
>>> +                                              u16 idx)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       struct vdpa_notification_area notify_area = {0, 0};
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               goto end;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
>>> + vdpa_nic->vring[idx].doorbell_offset);
>>> +       /* VDPA doorbells are at a stride of VI/2
>>> +        * One VI stride is shared by both rx & tx doorbells
>>> +        */
>>> +       notify_area.size = vdpa_nic->efx->vi_stride / 2;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +
>>> +end:
>>> +       return notify_area;
>>> +}
>>> +
>>> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       u32 irq;
>>> +
>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> +               return -EINVAL;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       irq = vdpa_nic->vring[idx].irq;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +
>>> +       return irq;
>>> +}
>>> +
>>>   static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>>>   {
>>>          return EF100_VDPA_VQ_ALIGN;
>>> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct 
>>> vdpa_device *vdev,
>>>
>>>          if (cb)
>>>                  vdpa_nic->cfg_cb = *cb;
>>> +       else
>>> +               memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
>>>   }
>>>
>>>   static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
>>> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct 
>>> vdpa_device *vdev, unsigned int offset,
>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>   {
>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       int i;
>>>
>>>          if (vdpa_nic) {
>>> +               for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>> +                       reset_vring(vdpa_nic, i);
>>> +                       if (vdpa_nic->vring[i].vring_ctx)
>>> +                               delete_vring_ctx(vdpa_nic, i);
>>> +               }
>>>                  mutex_destroy(&vdpa_nic->lock);
>>>                  vdpa_nic->efx->vdpa_nic = NULL;
>>>          }
>>>   }
>>>
>>>   const struct vdpa_config_ops ef100_vdpa_config_ops = {
>>> +       .set_vq_address      = ef100_vdpa_set_vq_address,
>>> +       .set_vq_num          = ef100_vdpa_set_vq_num,
>>> +       .kick_vq             = ef100_vdpa_kick_vq,
>>> +       .set_vq_cb           = ef100_vdpa_set_vq_cb,
>>> +       .set_vq_ready        = ef100_vdpa_set_vq_ready,
>>> +       .get_vq_ready        = ef100_vdpa_get_vq_ready,
>>> +       .set_vq_state        = ef100_vdpa_set_vq_state,
>>> +       .get_vq_state        = ef100_vdpa_get_vq_state,
>>> +       .get_vq_notification = ef100_vdpa_get_vq_notification,
>>> +       .get_vq_irq          = ef100_get_vq_irq,
>>>          .get_vq_align        = ef100_vdpa_get_vq_align,
>>>          .get_device_features = ef100_vdpa_get_device_features,
>>>          .set_driver_features = ef100_vdpa_set_driver_features,
>>> -- 
>>> 2.30.1
>>>
>

