Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0450F6BA663
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCOEzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCOEzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:55:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA41E5DA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678856053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkgbyV2imY4L0VYJhnilioyShG3uVxcmJ5pkGa8UGko=;
        b=c2RxtraZK2HFZYaZuIupoezSeZP49BJAYTcqjbxbUQvSJgcQ+s5p3qmZVliX5VRpnJbggG
        wLiNmXJ4Zg4HT4GKbp2glrF5sMdB1+z51vtD1LxYqEdM/LQY9pOSXbaujzQ+i/0sF1G5Bj
        +RYJ4boMuGKwG4KCTzM51UcIE38iGGY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-ANmqPUs7MNmHoASGhhRpJQ-1; Wed, 15 Mar 2023 00:54:12 -0400
X-MC-Unique: ANmqPUs7MNmHoASGhhRpJQ-1
Received: by mail-pf1-f200.google.com with SMTP id q15-20020a62e10f000000b00622aa7007f0so5592926pfh.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678856051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkgbyV2imY4L0VYJhnilioyShG3uVxcmJ5pkGa8UGko=;
        b=C7dOy3xlOqrKq4jn9NiTXQ/vocxLhOhRwoTQ59MEzdceffztDpRmMsTIxz8NzSq38Q
         d0l6d51Zfew69wP5NJzmEv8M/trdHI1VdNG0+yg1EDZmgiq17NChOCHkPgfU9jDh3jGC
         BFaAHa4XGN9ecPgoB/dPJScDIzmX7aZ/kbiS30/k24IOlA3bAgliVsJQNyySeZWqQiYo
         IAWAKy//t1NpQj9pmxadqThi/cDQeGYjxAt8GaNAxsihbxxCzHy9JTY2b8jv+NihrHXD
         xR/f+pEB6XYxvmu2vg8PQcLJIVLKd2OT/yLI/mfuyQeVd74MltB7lpyQiR1SyCVuKVQv
         vdHQ==
X-Gm-Message-State: AO0yUKXe4YK2+xomgTgKMRF81XAFjMYM0H6P7qRFrGGYvV4w8iMX97sj
        kljjn4bYwC8dGHzvhyRViLqhxnjWHay5C12V76dgyxS75Gz9yq6X3+kX1NqloI/lOWtDSGxO85m
        wjtcKswiS3MG5Z6tK
X-Received: by 2002:a62:7b0c:0:b0:61d:e8bb:1cb0 with SMTP id w12-20020a627b0c000000b0061de8bb1cb0mr16502268pfc.1.1678856051454;
        Tue, 14 Mar 2023 21:54:11 -0700 (PDT)
X-Google-Smtp-Source: AK7set9tGWsTDVTFm2JIik05f5OvajGcFh0jvyhtYWvl9Nz0F7MiDMP0+HRT+kOMv1oRVFxpDa0rNA==
X-Received: by 2002:a62:7b0c:0:b0:61d:e8bb:1cb0 with SMTP id w12-20020a627b0c000000b0061de8bb1cb0mr16502250pfc.1.1678856051093;
        Tue, 14 Mar 2023 21:54:11 -0700 (PDT)
Received: from [10.72.12.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q30-20020a635c1e000000b004fb10399da2sm2371294pgb.56.2023.03.14.21.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 21:54:10 -0700 (PDT)
Message-ID: <420ce417-015c-427f-a576-206e135244b2@redhat.com>
Date:   Wed, 15 Mar 2023 12:54:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 12/14] sfc: unmap VF's MCDI buffer when
 switching to vDPA mode
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
 <20230307113621.64153-13-gautam.dawar@amd.com>
 <CACGkMEuvJF9WXu0N+d-54hB=kGgjU=zNk=620d7chinRWz=j5Q@mail.gmail.com>
 <311a2506-d178-b136-bf4f-8da8a96b9d47@amd.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <311a2506-d178-b136-bf4f-8da8a96b9d47@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/13 15:09, Gautam Dawar 写道:
>
> On 3/10/23 10:35, Jason Wang wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com> 
>> wrote:
>>> To avoid clash of IOVA range of VF's MCDI DMA buffer with the guest
>>> buffer IOVAs, unmap the MCDI buffer when switching to vDPA mode
>>> and use PF's IOMMU domain for running VF's MCDI commands.
>>>
>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>> ---
>>>   drivers/net/ethernet/sfc/ef100_nic.c      |  1 -
>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     | 25 ++++++++++++++++
>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  3 ++
>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 35 
>>> +++++++++++++++++++++++
>>>   drivers/net/ethernet/sfc/mcdi.h           |  3 ++
>>>   drivers/net/ethernet/sfc/net_driver.h     | 12 ++++++++
>>>   6 files changed, 78 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c 
>>> b/drivers/net/ethernet/sfc/ef100_nic.c
>>> index cd9f724a9e64..1bffc1994ed8 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>> @@ -33,7 +33,6 @@
>>>
>>>   #define EF100_MAX_VIS 4096
>>>   #define EF100_NUM_MCDI_BUFFERS 1
>>> -#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>>
>>>   #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << 
>>> ETH_RESET_SHARED_SHIFT)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> index 5c9f29f881a6..30ca4ab00175 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>> @@ -223,10 +223,19 @@ static int vdpa_allocate_vis(struct efx_nic 
>>> *efx, unsigned int *allocated_vis)
>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>   {
>>>          struct vdpa_device *vdpa_dev;
>>> +       int rc;
>>>
>>>          if (efx->vdpa_nic) {
>>>                  vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>>                  ef100_vdpa_reset(vdpa_dev);
>>> +               if (efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
>>> +                       rc = ef100_vdpa_map_mcdi_buffer(efx);
>>> +                       if (rc) {
>>> +                               pci_err(efx->pci_dev,
>>> +                                       "map_mcdi_buffer failed, 
>>> err: %d\n",
>>> +                                       rc);
>>> +                       }
>>> +               }
>>>
>>>                  /* replace with _vdpa_unregister_device later */
>>>                  put_device(&vdpa_dev->dev);
>>> @@ -276,6 +285,21 @@ static int get_net_config(struct ef100_vdpa_nic 
>>> *vdpa_nic)
>>>          return 0;
>>>   }
>>>
>>> +static void unmap_mcdi_buffer(struct efx_nic *efx)
>>> +{
>>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>>> +       struct efx_mcdi_iface *mcdi;
>>> +
>>> +       mcdi = efx_mcdi(efx);
>>> +       spin_lock_bh(&mcdi->iface_lock);
>>> +       /* Save current MCDI mode to be restored later */
>>> +       efx->vdpa_nic->mcdi_mode = mcdi->mode;
>>> +       efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
>>> +       mcdi->mode = MCDI_MODE_FAIL;
>>> +       spin_unlock_bh(&mcdi->iface_lock);
>>> +       efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
>>> +}
>>> +
>>>   static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>>                                                  const char *dev_name,
>>>                                                  enum 
>>> ef100_vdpa_class dev_type,
>>> @@ -342,6 +366,7 @@ static struct ef100_vdpa_nic 
>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>          for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>>>                  vdpa_nic->filters[i].filter_id = 
>>> EFX_INVALID_FILTER_ID;
>>>
>>> +       unmap_mcdi_buffer(efx);
>>>          rc = get_net_config(vdpa_nic);
>>>          if (rc)
>>>                  goto err_put_device;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> index 49fb6be04eb3..0913ac2519cb 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>> @@ -147,6 +147,7 @@ struct ef100_vdpa_filter {
>>>    * @status: device status as per VIRTIO spec
>>>    * @features: negotiated feature bits
>>>    * @max_queue_pairs: maximum number of queue pairs supported
>>> + * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
>>>    * @net_config: virtio_net_config data
>>>    * @vring: vring information of the vDPA device.
>>>    * @mac_address: mac address of interface associated with this 
>>> vdpa device
>>> @@ -166,6 +167,7 @@ struct ef100_vdpa_nic {
>>>          u8 status;
>>>          u64 features;
>>>          u32 max_queue_pairs;
>>> +       enum efx_mcdi_mode mcdi_mode;
>>>          struct virtio_net_config net_config;
>>>          struct ef100_vdpa_vring_info 
>>> vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>>          u8 *mac_address;
>>> @@ -185,6 +187,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic 
>>> *vdpa_nic,
>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>>   void ef100_vdpa_irq_vectors_free(void *data);
>>>   int ef100_vdpa_reset(struct vdpa_device *vdev);
>>> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
>>>
>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic 
>>> *vdpa_nic)
>>>   {
>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c 
>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> index db86c2693950..c6c9458f0e6f 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>> @@ -711,12 +711,47 @@ static int ef100_vdpa_suspend(struct 
>>> vdpa_device *vdev)
>>>          mutex_unlock(&vdpa_nic->lock);
>>>          return rc;
>>>   }
>>> +
>>> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx)
>>> +{
>> The name of this function is confusing, it's actually map buffer for
>> ef100 netdev mode.
>
> Yeah, I get your point. Actually, I am using the prefix ef100_vdpa_ 
> for extern functions and this function is just mapping the  MCDI 
> buffer resulting in the name ef100_vdpa_map_mcdi_buffer().
>
> I think ef100_vdpa_map_vf_mcdi_buffer() would remove this confusion. 
> What do you think?


Not a native speaker, but for me, it would be better to remove "vdpa" 
from the name since the buffer is not used by vDPA (if I understand the 
code correctly).


>
>>
>> Actually, I wonder why not moving this to init/fini of bar config ops
>> or if we use aux bus, it should be done during aux driver
>> probe/remove.
> It makes sense, however we store the last mcdi mode (poll or events) 
> in vdpa_nic->mcdi_mode to restore later, which requires vdpa_nic to be 
> allocated that happens later than switching to vdpa bar_config.


Ok.

Thanks


>> Thanks
>>
>>
>>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>>> +       struct efx_mcdi_iface *mcdi;
>>> +       int rc;
>>> +
>>> +       /* Update VF's MCDI buffer when switching out of vdpa mode */
>>> +       rc = efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf,
>>> +                                 MCDI_BUF_LEN, GFP_KERNEL);
>>> +       if (rc)
>>> +               return rc;
>>> +
>>> +       mcdi = efx_mcdi(efx);
>>> +       spin_lock_bh(&mcdi->iface_lock);
>>> +       mcdi->mode = efx->vdpa_nic->mcdi_mode;
>>> +       efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
>>> +       spin_unlock_bh(&mcdi->iface_lock);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>   {
>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>> +       int rc;
>>>          int i;
>>>
>>>          if (vdpa_nic) {
>>> +               if (vdpa_nic->efx->mcdi_buf_mode == 
>>> EFX_BUF_MODE_VDPA) {
>>> +                       /* This will only be called via call to 
>>> put_device()
>>> +                        * on vdpa device creation failure
>>> +                        */
>>> +                       rc = ef100_vdpa_map_mcdi_buffer(vdpa_nic->efx);
>>> +                       if (rc) {
>>> +                               dev_err(&vdev->dev,
>>> +                                       "map_mcdi_buffer failed, 
>>> err: %d\n",
>>> +                                       rc);
>>> +                       }
>>> +               }
>>> +
>>>                  for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); 
>>> i++) {
>>>                          reset_vring(vdpa_nic, i);
>>>                          if (vdpa_nic->vring[i].vring_ctx)
>>> diff --git a/drivers/net/ethernet/sfc/mcdi.h 
>>> b/drivers/net/ethernet/sfc/mcdi.h
>>> index 2c526d2edeb6..bc4de3b4e6f3 100644
>>> --- a/drivers/net/ethernet/sfc/mcdi.h
>>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>>> @@ -6,6 +6,9 @@
>>>
>>>   #ifndef EFX_MCDI_H
>>>   #define EFX_MCDI_H
>>> +#include "mcdi_pcol.h"
>>> +
>>> +#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>>
>>>   /**
>>>    * enum efx_mcdi_state - MCDI request handling state
>>> diff --git a/drivers/net/ethernet/sfc/net_driver.h 
>>> b/drivers/net/ethernet/sfc/net_driver.h
>>> index 948c7a06403a..9cdfeb6ad05a 100644
>>> --- a/drivers/net/ethernet/sfc/net_driver.h
>>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>>> @@ -848,6 +848,16 @@ enum efx_xdp_tx_queues_mode {
>>>
>>>   struct efx_mae;
>>>
>>> +/**
>>> + * enum efx_buf_alloc_mode - buffer allocation mode
>>> + * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
>>> + * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
>>> + */
>>> +enum efx_buf_alloc_mode {
>>> +       EFX_BUF_MODE_EF100,
>>> +       EFX_BUF_MODE_VDPA
>>> +};
>>> +
>>>   /**
>>>    * struct efx_nic - an Efx NIC
>>>    * @name: Device name (net device name or bus id before net device 
>>> registered)
>>> @@ -877,6 +887,7 @@ struct efx_mae;
>>>    * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event 
>>> queues
>>>    * @irq_rx_moderation_us: IRQ moderation time for RX event queues
>>>    * @msg_enable: Log message enable flags
>>> + * @mcdi_buf_mode: mcdi buffer allocation mode
>>>    * @state: Device state number (%STATE_*). Serialised by the 
>>> rtnl_lock.
>>>    * @reset_pending: Bitmask for pending resets
>>>    * @tx_queue: TX DMA queues
>>> @@ -1045,6 +1056,7 @@ struct efx_nic {
>>>          u32 msg_enable;
>>>
>>>          enum nic_state state;
>>> +       enum efx_buf_alloc_mode mcdi_buf_mode;
>>>          unsigned long reset_pending;
>>>
>>>          struct efx_channel *channel[EFX_MAX_CHANNELS];
>>> -- 
>>> 2.30.1
>>>
>

