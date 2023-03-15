Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CAA6BA670
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCOFBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCOFBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2815D25D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678856447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z24A5FJASFqmD/XcLMfMx2NIcTC5TC4NJTVxq1zW8iQ=;
        b=Ej6B89HWd+oSa6mxM73FpfJyO7nkD1ZSOunb5lJ/Uzuth2IpQifFV3Aowv3IZcX9cZw7zK
        CGUn6UPX2gvu6UXTtpf43vyc7V+WdYZ1bq2+lmni/GLo7x183LaOl5sNNHTHC7ehYlhtCZ
        XRDpDgSu5dZqXzTvEzjJLudIoCsMZWg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-wxPeMeY4M_qF4ID_2MU2Ig-1; Wed, 15 Mar 2023 01:00:45 -0400
X-MC-Unique: wxPeMeY4M_qF4ID_2MU2Ig-1
Received: by mail-pg1-f199.google.com with SMTP id p1-20020a631e41000000b0050bdffd4995so91233pgm.16
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678856445;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z24A5FJASFqmD/XcLMfMx2NIcTC5TC4NJTVxq1zW8iQ=;
        b=aVVPVKfvqet8z7u94lrBkwsBSMtT1h8w3rxTP4BeabYiZ0WXpYmIk6U8gmCVt2CQQu
         AXCKB3fJc7mc/kuAH6cjJ+W6Z7dxCbICqt9vpQiSEep21UqokP4t7SSBUYiku1d8A+Es
         PvwgoLaIbYfNpvFM07E5M6Jm1MYsyegHo8BSK8xBfCG5td+Cs/+cnNQM6t0bMV3/Re9x
         ocLItQEDxE5Ojjum+BciWNABhIlIS4FmT5+ArJ2tS+1lsp8jgCHwPSHETnGzP0jvpL4t
         NgKNoVdIQSbCp9LZYhlCTEk5YTuF2XOFbB8F/Ocqf3OPtDrMFD3LiXKPgpKyJFZnbkVI
         Rn9g==
X-Gm-Message-State: AO0yUKWFyNIcv/EcrMrtBe99dJNx6R523bldMXJMCXdtN1mhqgVVLTql
        lU8MIp0u5g+fR5Unw5z0dw8XQAjVJj3Ko9xOpH9una83DS/hAYwOqLFl+RLm5zErxJLOuIZV3uz
        0017IbFIdraeCCY+i
X-Received: by 2002:a17:90a:b89:b0:23b:5537:8c99 with SMTP id 9-20020a17090a0b8900b0023b55378c99mr10311146pjr.45.1678856444658;
        Tue, 14 Mar 2023 22:00:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set/kvXF7cLuVo4/bh1m0vtkR1Y73mMDyIOiDkBLY0RT5Q4ZycaavrYrzuWysN7o3SXqIjCVFYQ==
X-Received: by 2002:a17:90a:b89:b0:23b:5537:8c99 with SMTP id 9-20020a17090a0b8900b0023b55378c99mr10311126pjr.45.1678856444238;
        Tue, 14 Mar 2023 22:00:44 -0700 (PDT)
Received: from [10.72.12.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d17-20020a17090ae29100b0023b2bc8ebc4sm378544pjz.9.2023.03.14.22.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 22:00:43 -0700 (PDT)
Message-ID: <a6562f42-7bb1-0e0d-3990-7d5962efe6b9@redhat.com>
Date:   Wed, 15 Mar 2023 13:00:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 09/14] sfc: implement device status related
 vdpa config operations
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
 <20230307113621.64153-10-gautam.dawar@amd.com>
 <CACGkMEvpK4P1TTAO2bZ+YMXuNFMk_hJHQBPszCwOTzbQX70s7w@mail.gmail.com>
 <3a3b63f5-66a9-47aa-ba0d-3bb99c928a60@amd.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <3a3b63f5-66a9-47aa-ba0d-3bb99c928a60@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/13 20:10, Gautam Dawar 写道:
>
> On 3/10/23 10:35, Jason Wang wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com> 
>> wrote:
>>> vDPA config opertions to handle get/set device status and device
>>> reset have been implemented. Also .suspend config operation is
>>> implemented to support Live Migration.
>>>
>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>> ---
>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   2 +
>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367 
>>> ++++++++++++++++++++--
>>>   3 files changed, 355 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> index c66e5aef69ea..4ba57827a6cd 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> @@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, 
>>> unsigned int *allocated_vis)
>>>
>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>   {
>>> +       struct vdpa_device *vdpa_dev;
>>> +
>>>          if (efx->vdpa_nic) {
>>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>> +               ef100_vdpa_reset(vdpa_dev);
>>> +
>>>                  /* replace with _vdpa_unregister_device later */
>>> - put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>> +               put_device(&vdpa_dev->dev);
>>>          }
>>>          efx_mcdi_free_vis(efx);
>>>   }
>>> @@ -171,6 +176,15 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>                  }
>>>          }
>>>
>>> +       rc = devm_add_action_or_reset(&efx->pci_dev->dev,
>>> + ef100_vdpa_irq_vectors_free,
>>> +                                     efx->pci_dev);
>>> +       if (rc) {
>>> +               pci_err(efx->pci_dev,
>>> +                       "Failed adding devres for freeing irq 
>>> vectors\n");
>>> +               goto err_put_device;
>>> +       }
>>> +
>>>          rc = get_net_config(vdpa_nic);
>>>          if (rc)
>>>                  goto err_put_device;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> index 348ca8a7404b..58791402e454 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> @@ -149,6 +149,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic 
>>> *efx);
>>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>>   void ef100_vdpa_irq_vectors_free(void *data);
>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>> +void ef100_vdpa_irq_vectors_free(void *data);
>>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>>
>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic 
>>> *vdpa_nic)
>>>   {
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> index 0051c4c0e47c..95a2177f85a2 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> @@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct 
>>> vdpa_device *vdev)
>>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>>   }
>>>
>>> -void ef100_vdpa_irq_vectors_free(void *data)
>>> -{
>>> -       pci_free_irq_vectors(data);
>>> -}
>>> -
>>>   static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>   {
>>>          struct efx_vring_ctx *vring_ctx;
>>> @@ -52,14 +47,6 @@ static void delete_vring_ctx(struct 
>>> ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>          vdpa_nic->vring[idx].vring_ctx = NULL;
>>>   }
>>>
>>> -static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> -{
>>> -       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>> -       vdpa_nic->vring[idx].vring_state = 0;
>>> -       vdpa_nic->vring[idx].last_avail_idx = 0;
>>> -       vdpa_nic->vring[idx].last_used_idx = 0;
>>> -}
>>> -
>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>   {
>>>          u32 offset;
>>> @@ -103,6 +90,236 @@ static bool is_qid_invalid(struct 
>>> ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>          return false;
>>>   }
>>>
>>> +static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>> +
>>> +       devm_free_irq(&pci_dev->dev, vring->irq, vring);
>>> +       vring->irq = -EINVAL;
>>> +}
>>> +
>>> +static irqreturn_t vring_intr_handler(int irq, void *arg)
>>> +{
>>> +       struct ef100_vdpa_vring_info *vring = arg;
>>> +
>>> +       if (vring->cb.callback)
>>> +               return vring->cb.callback(vring->cb.private);
>>> +
>>> +       return IRQ_NONE;
>>> +}
>>> +
>>> +static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, 
>>> u16 nvqs)
>>> +{
>>> +       int rc;
>>> +
>>> +       rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
>>> +       if (rc < 0)
>>> +               pci_err(pci_dev,
>>> +                       "Failed to alloc %d IRQ vectors, err:%d\n", 
>>> nvqs, rc);
>>> +       return rc;
>>> +}
>>> +
>>> +void ef100_vdpa_irq_vectors_free(void *data)
>>> +{
>>> +       pci_free_irq_vectors(data);
>>> +}
>>> +
>>> +static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>> +       int irq;
>>> +       int rc;
>>> +
>>> +       snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
>>> +                pci_name(pci_dev), idx);
>>> +       irq = pci_irq_vector(pci_dev, idx);
>>> +       rc = devm_request_irq(&pci_dev->dev, irq, 
>>> vring_intr_handler, 0,
>>> +                             vring->msix_name, vring);
>>> +       if (rc)
>>> +               pci_err(pci_dev,
>>> +                       "devm_request_irq failed for vring %d, rc 
>>> %d\n",
>>> +                       idx, rc);
>>> +       else
>>> +               vring->irq = irq;
>>> +
>>> +       return rc;
>>> +}
>>> +
>>> +static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>> +       int rc;
>>> +
>>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>> +               return 0;
>>> +
>>> +       rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>>> +                                   &vring_dyn_cfg);
>>> +       if (rc)
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: delete vring failed index:%u, err:%d\n",
>>> +                       __func__, idx, rc);
>>> +       vdpa_nic->vring[idx].last_avail_idx = vring_dyn_cfg.avail_idx;
>>> +       vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
>>> +       vdpa_nic->vring[idx].vring_state &= ~EF100_VRING_CREATED;
>>> +
>>> +       irq_vring_fini(vdpa_nic, idx);
>>> +
>>> +       return rc;
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
>>> +
>>> +       idx_val = idx;
>>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>> +                   vdpa_nic->vring[idx].doorbell_offset);
>>> +}
>>> +
>>> +static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       if (vdpa_nic->vring[idx].vring_state == 
>>> EF100_VRING_CONFIGURED &&
>>> +           vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>> +           !(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>> +               return true;
>>> +
>>> +       return false;
>>> +}
>>> +
>>> +static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>> +       struct efx_vring_cfg vring_cfg;
>>> +       int rc;
>>> +
>>> +       rc = irq_vring_init(vdpa_nic, idx);
>>> +       if (rc) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: irq_vring_init failed. index:%u, 
>>> err:%d\n",
>>> +                       __func__, idx, rc);
>>> +               return rc;
>>> +       }
>>> +       vring_cfg.desc = vdpa_nic->vring[idx].desc;
>>> +       vring_cfg.avail = vdpa_nic->vring[idx].avail;
>>> +       vring_cfg.used = vdpa_nic->vring[idx].used;
>>> +       vring_cfg.size = vdpa_nic->vring[idx].size;
>>> +       vring_cfg.features = vdpa_nic->features;
>>> +       vring_cfg.msix_vector = idx;
>>> +       vring_dyn_cfg.avail_idx = vdpa_nic->vring[idx].last_avail_idx;
>>> +       vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
>>> +
>>> +       rc = efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
>>> +                                  &vring_cfg, &vring_dyn_cfg);
>>> +       if (rc) {
>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                       "%s: vring_create failed index:%u, err:%d\n",
>>> +                       __func__, idx, rc);
>>> +               goto err_vring_create;
>>> +       }
>>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_CREATED;
>>> +
>>> +       /* A VQ kick allows the device to read the avail_idx, which 
>>> will be
>>> +        * required at the destination after live migration.
>>> +        */
>>> +       ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
>>> +
>>> +       return 0;
>>> +
>>> +err_vring_create:
>>> +       irq_vring_fini(vdpa_nic, idx);
>>> +       return rc;
>>> +}
>>> +
>>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>> +{
>>> +       delete_vring(vdpa_nic, idx);
>>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>> +       vdpa_nic->vring[idx].vring_state = 0;
>>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>>> +}
>>> +
>>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>> +{
>>> +       int i;
>>> +
>>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>>> +
>>> +       if (!vdpa_nic->status)
>>> +               return;
>>> +
>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>> +       vdpa_nic->status = 0;
>>> +       vdpa_nic->features = 0;
>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>> +               reset_vring(vdpa_nic, i);
>>> + ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>>> +}
>>> +
>>> +/* May be called under the rtnl lock */
>>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +
>>> +       /* vdpa device can be deleted anytime but the bar_config
>>> +        * could still be vdpa and hence efx->state would be 
>>> STATE_VDPA.
>>> +        * Accordingly, ensure vdpa device exists before reset handling
>>> +        */
>>> +       if (!vdpa_nic)
>>> +               return -ENODEV;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       ef100_reset_vdpa_device(vdpa_nic);
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return 0;
>>> +}
>>> +
>>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>> +{
>>> +       struct efx_nic *efx = vdpa_nic->efx;
>>> +       struct ef100_nic_data *nic_data;
>>> +       int i, j;
>>> +       int rc;
>>> +
>>> +       nic_data = efx->nic_data;
>>> +       rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>>> + vdpa_nic->max_queue_pairs * 2);
>>> +       if (rc < 0) {
>>> +               pci_err(efx->pci_dev,
>>> +                       "vDPA IRQ alloc failed for vf: %u err:%d\n",
>>> +                       nic_data->vf_index, rc);
>>> +               return rc;
>>> +       }
>>> +
>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>> +               if (can_create_vring(vdpa_nic, i)) {
>>> +                       rc = create_vring(vdpa_nic, i);
>>> +                       if (rc)
>>> +                               goto clear_vring;
>>> +               }
>>> +       }
>>> +
>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>> It looks to me that this duplicates with the DRIVER_OK status bit.
> vdpa_state is set EF100_VDPA_STATE_STARTED during DRIVER_OK handling. 
> See my later response for its purpose.
>>
>>> +       return 0;
>>> +
>>> +clear_vring:
>>> +       for (j = 0; j < i; j++)
>>> +               delete_vring(vdpa_nic, j);
>>> +
>>> +       ef100_vdpa_irq_vectors_free(efx->pci_dev);
>>> +       return rc;
>>> +}
>>> +
>>>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>                                       u16 idx, u64 desc_area, u64 
>>> driver_area,
>>>                                       u64 device_area)
>>> @@ -144,22 +361,6 @@ static void ef100_vdpa_set_vq_num(struct 
>>> vdpa_device *vdev, u16 idx, u32 num)
>>>          mutex_unlock(&vdpa_nic->lock);
>>>   }
>>>
>>> -static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>> -{
>>> -       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> -       u32 idx_val;
>>> -
>>> -       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>> -               return;
>>> -
>>> -       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>> -               return;
>>> -
>>> -       idx_val = idx;
>>> -       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>> -                   vdpa_nic->vring[idx].doorbell_offset);
>>> -}
>>> -
>>>   static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>>                                   struct vdpa_callback *cb)
>>>   {
>>> @@ -176,6 +377,7 @@ static void ef100_vdpa_set_vq_ready(struct 
>>> vdpa_device *vdev, u16 idx,
>>>                                      bool ready)
>>>   {
>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       int rc;
>>>
>>>          if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>                  return;
>>> @@ -184,9 +386,21 @@ static void ef100_vdpa_set_vq_ready(struct 
>>> vdpa_device *vdev, u16 idx,
>>>          if (ready) {
>>>                  vdpa_nic->vring[idx].vring_state |=
>>> EF100_VRING_READY_CONFIGURED;
>>> +               if (vdpa_nic->vdpa_state == EF100_VDPA_STATE_STARTED &&
>>> +                   can_create_vring(vdpa_nic, idx)) {
>>> +                       rc = create_vring(vdpa_nic, idx);
>>> +                       if (rc)
>>> +                               /* Rollback ready configuration
>>> +                                * So that the above layer driver
>>> +                                * can make another attempt to set 
>>> ready
>>> +                                */
>>> + vdpa_nic->vring[idx].vring_state &=
>>> + ~EF100_VRING_READY_CONFIGURED;
>>> +               }
>>>          } else {
>>>                  vdpa_nic->vring[idx].vring_state &=
>>> ~EF100_VRING_READY_CONFIGURED;
>>> +               delete_vring(vdpa_nic, idx);
>>>          }
>>>          mutex_unlock(&vdpa_nic->lock);
>>>   }
>>> @@ -296,6 +510,12 @@ static u64 
>>> ef100_vdpa_get_device_features(struct vdpa_device *vdev)
>>>          }
>>>
>>>          features |= BIT_ULL(VIRTIO_NET_F_MAC);
>>> +       /* As QEMU SVQ doesn't implement the following features,
>>> +        * masking them off to allow Live Migration
>>> +        */
>>> +       features &= ~BIT_ULL(VIRTIO_F_IN_ORDER);
>>> +       features &= ~BIT_ULL(VIRTIO_F_ORDER_PLATFORM);
>> It's better not to work around userspace bugs in the kernel. We should
>> fix Qemu instead.
>
> There's already a QEMU patch [1] submitted to support 
> VIRTIO_F_ORDER_PLATFORM but it hasn't concluded yet. Also, there is no 
> support for VIRTIO_F_IN_ORDER in the kernel virtio driver. The motive 
> of this change is to have VM Live Migration working with the kernel 
> in-tree driver without requiring any changes.
>
> Once QEMU is able to handle these features, we can submit a patch to 
> undo these changes.


I can understand the motivation, but it works for prototyping but not 
formal kernel code (especially consider SVQ is not mature and still 
being development). What's more, we can not assume Qemu is the only 
user, we have other users like DPDK and cloud-hypervisors.

Thanks


>
>>
>>> +
>>>          return features;
>>>   }
>>>
>>> @@ -356,6 +576,77 @@ static u32 ef100_vdpa_get_vendor_id(struct 
>>> vdpa_device *vdev)
>>>          return EF100_VDPA_VENDOR_ID;
>>>   }
>>>
>>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       u8 status;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       status = vdpa_nic->status;
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return status;
>>> +}
>>> +
>>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       u8 new_status;
>>> +       int rc;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       if (!status) {
>>> +               dev_info(&vdev->dev,
>>> +                        "%s: Status received is 0. Device reset 
>>> being done\n",
>>> +                        __func__);
>> This is trigger-able by the userspace. It might be better to use
>> dev_dbg() instead.
> Will change.
>>
>>> + ef100_reset_vdpa_device(vdpa_nic);
>>> +               goto unlock_return;
>>> +       }
>>> +       new_status = status & ~vdpa_nic->status;
>>> +       if (new_status == 0) {
>>> +               dev_info(&vdev->dev,
>>> +                        "%s: New status same as current status\n", 
>>> __func__);
>> Same here.
> Ok.
>>
>>> +               goto unlock_return;
>>> +       }
>>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>> +               goto unlock_return;
>>> +       }
>>> +
>>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>> +       }
>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER) {
>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>>> +       }
>>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
>> It might be better to explain the reason we need to track another
>> state in vdpa_state instead of simply using the device status.
> vdpa_state helps to ensure correct status transitions in the 
> .set_status callback and safe-guards against incorrect/malicious 
> user-space driver.


Ok, let's document this in the definition of vdpa_state.


>>
>>> +               new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>> +       }
>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
>>> +               rc = start_vdpa_device(vdpa_nic);
>>> +               if (rc) {
>>> + dev_err(&vdpa_nic->vdpa_dev.dev,
>>> +                               "%s: vDPA device failed:%d\n", 
>>> __func__, rc);
>>> +                       vdpa_nic->status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>>> +                       goto unlock_return;
>>> +               }
>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>>> +       }
>>> +       if (new_status) {
>>> +               dev_warn(&vdev->dev,
>>> +                        "%s: Mismatch Status: %x & State: %u\n",
>>> +                        __func__, new_status, vdpa_nic->vdpa_state);
>>> +       }
>>> +
>>> +unlock_return:
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +}
>>> +
>>>   static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>>>   {
>>>          return sizeof(struct virtio_net_config);
>>> @@ -393,6 +684,20 @@ static void ef100_vdpa_set_config(struct 
>>> vdpa_device *vdev, unsigned int offset,
>>>                  vdpa_nic->mac_configured = true;
>>>   }
>>>
>>> +static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>>> +{
>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       int i, rc;
>>> +
>>> +       mutex_lock(&vdpa_nic->lock);
>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>> +               rc = delete_vring(vdpa_nic, i);
>> Note that the suspension matters for the whole device. It means the
>> config space should not be changed. But the code here only suspends
>> the vring, is this intende/d?
> Are you referring to the possibility of updating device configuration 
> (eg. MAC address) using .set_config() after suspend operation? Is 
> there any other user triggered operation that falls in this category?


Updating MAC should be prohibited, one typical use case is the link status.


>>
>> Reset may have the same issue.
> Could you pls elaborate on the requirement during device reset?


I meant ef100_reset_vdpa_device() may suffer from the same issue:

It only reset all the vring but not the config space?

Thanks


>>
>> Thanks
> [1] 
> https://patchew.org/QEMU/20230213191929.1547497-1-eperezma@redhat.com/
>>
>>> +               if (rc)
>>> +                       break;
>>> +       }
>>> +       mutex_unlock(&vdpa_nic->lock);
>>> +       return rc;
>>> +}
>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>   {
>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> @@ -428,9 +733,13 @@ const struct vdpa_config_ops 
>>> ef100_vdpa_config_ops = {
>>>          .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
>>>          .get_device_id       = ef100_vdpa_get_device_id,
>>>          .get_vendor_id       = ef100_vdpa_get_vendor_id,
>>> +       .get_status          = ef100_vdpa_get_status,
>>> +       .set_status          = ef100_vdpa_set_status,
>>> +       .reset               = ef100_vdpa_reset,
>>>          .get_config_size     = ef100_vdpa_get_config_size,
>>>          .get_config          = ef100_vdpa_get_config,
>>>          .set_config          = ef100_vdpa_set_config,
>>>          .get_generation      = NULL,
>>> +       .suspend             = ef100_vdpa_suspend,
>>>          .free                = ef100_vdpa_free,
>>>   };
>>> -- 
>>> 2.30.1
>>>
>

