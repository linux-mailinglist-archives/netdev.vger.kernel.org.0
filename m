Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EE7509E5A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388748AbiDULQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388746AbiDULQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:16:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4989C25E82
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539613; x=1682075613;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SLmJKTCju+lqxbs9TBke+gwwuj8oPq+d+lcp0WcNv8U=;
  b=ksKgCzLcctQYZg6lOb4SMufYtxNFHFLr1UE4UEr3tv3PiNBCvnL9udol
   u2Py0CN8jY3BINSSPFx+fKFE0DOS29Yj8ooV9HckoGMPkZabZr6GlEVED
   iQiSxQPn0igJQ7xvH4I6RUYQH70v8xVOVPtZq20yfVd08Go4O0mk9S76m
   7qpo4kjKBWsDuK0e2OtjPaLxopd1ZnsOcCPi0IK8l7f29T7+w4CxopTcc
   FI5jmI3nM0SwRMUrspxXgSSFvHQfhL9Z3Go1o98F263lfySGF2UaOeS1q
   HRFywWqKazdas+A/z3LL7wXdtk0uAdb7nTwbG0C42AvsMYEpwqZXm2ou2
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="263167393"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="263167393"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:13:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577168921"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.168.77]) ([10.249.168.77])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:13:31 -0700
Message-ID: <d72f739e-e976-cc5e-39e3-f150bee3d66c@intel.com>
Date:   Thu, 21 Apr 2022 19:13:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.0
Subject: Re: [PATCH] vDPA/ifcvf: allow userspace to suspend a queue
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220411031057.162485-1-lingshan.zhu@intel.com>
 <CACGkMEu7dUYKr7Nv-fDFFBM4M1hvWuO8P17xNMEkwofiiP178A@mail.gmail.com>
 <20220413045223-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220413045223-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2022 4:54 PM, Michael S. Tsirkin wrote:
> On Wed, Apr 13, 2022 at 04:25:22PM +0800, Jason Wang wrote:
>> On Mon, Apr 11, 2022 at 11:18 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>> Formerly, ifcvf driver has implemented a lazy-initialization mechanism
>>> for the virtqueues, it would store all virtqueue config fields that
>>> passed down from the userspace, then load them to the virtqueues and
>>> enable the queues upon DRIVER_OK.
>>>
>>> To allow the userspace to suspend a virtqueue,
>>> this commit passes queue_enable to the virtqueue directly through
>>> set_vq_ready().
>>>
>>> This feature requires and this commits implementing all virtqueue
>>> ops(set_vq_addr, set_vq_num and set_vq_ready) to take immediate
>>> actions than lazy-initialization, so ifcvf_hw_enable() is retired.
>>>
>>> To avoid losing virtqueue configurations caused by multiple
>>> rounds of reset(), this commit also refactors thed evice reset
>>> routine, now it simply reset the config handler and the virtqueues,
>>> and only once device-reset().
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_base.c | 94 ++++++++++++++++++++-------------
>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 11 ++--
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 57 +++++---------------
>>>   3 files changed, 75 insertions(+), 87 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> index 48c4dadb0c7c..19eb0dcac123 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> @@ -175,16 +175,12 @@ u8 ifcvf_get_status(struct ifcvf_hw *hw)
>>>   void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
>>>   {
>>>          vp_iowrite8(status, &hw->common_cfg->device_status);
>>> +       vp_ioread8(&hw->common_cfg->device_status);
>> This looks confusing, the name of the function is to set the status
>> but what actually implemented here is to get the status.
>>
>>>   }
>>>
>>>   void ifcvf_reset(struct ifcvf_hw *hw)
>>>   {
>>> -       hw->config_cb.callback = NULL;
>>> -       hw->config_cb.private = NULL;
>>> -
>>>          ifcvf_set_status(hw, 0);
>>> -       /* flush set_status, make sure VF is stopped, reset */
>>> -       ifcvf_get_status(hw);
>>>   }
>>>
>>>   static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
>>> @@ -331,68 +327,94 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>>>          ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
>>>          q_pair_id = qid / hw->nr_vring;
>>>          avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
>>> -       hw->vring[qid].last_avail_idx = num;
>>>          vp_iowrite16(num, avail_idx_addr);
>>> +       vp_ioread16(avail_idx_addr);
>> This looks like a bug fix.
> is this to flush out the status write?  pls add a comment
> explaining when and why it's needed.
I think this may not needed anymore, setting DRIVER_OK will flush them all,
so all extra flush are removed.
>
>>>          return 0;
>>>   }
>>>
>>> -static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>>> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num)
>>>   {
>>> -       struct virtio_pci_common_cfg __iomem *cfg;
>>> -       u32 i;
>>> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>>>
>>> -       cfg = hw->common_cfg;
>>> -       for (i = 0; i < hw->nr_vring; i++) {
>>> -               if (!hw->vring[i].ready)
>>> -                       break;
>>> +       vp_iowrite16(qid, &cfg->queue_select);
>>> +       vp_iowrite16(num, &cfg->queue_size);
>>> +       vp_ioread16(&cfg->queue_size);
>>> +}
>>>
>>> -               vp_iowrite16(i, &cfg->queue_select);
>>> -               vp_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
>>> -                                    &cfg->queue_desc_hi);
>>> -               vp_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
>>> -                                     &cfg->queue_avail_hi);
>>> -               vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
>>> -                                    &cfg->queue_used_hi);
>>> -               vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
>>> -               ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
>>> -               vp_iowrite16(1, &cfg->queue_enable);
>>> -       }
>>> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
>>> +                        u64 driver_area, u64 device_area)
>>> +{
>>> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>>> +
>>> +       vp_iowrite16(qid, &cfg->queue_select);
>>> +       vp_iowrite64_twopart(desc_area, &cfg->queue_desc_lo,
>>> +                            &cfg->queue_desc_hi);
>>> +       vp_iowrite64_twopart(driver_area, &cfg->queue_avail_lo,
>>> +                            &cfg->queue_avail_hi);
>>> +       vp_iowrite64_twopart(device_area, &cfg->queue_used_lo,
>>> +                            &cfg->queue_used_hi);
>>> +       /* to flush IO */
>>> +       vp_ioread16(&cfg->queue_select);
>> Why do we need to flush I/O here?
>>
>>>          return 0;
>>>   }
>>>
>>> -static void ifcvf_hw_disable(struct ifcvf_hw *hw)
>>> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready)
>>>   {
>>> -       u32 i;
>>> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>>>
>>> -       ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
>>> -       for (i = 0; i < hw->nr_vring; i++) {
>>> -               ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
>>> -       }
>>> +       vp_iowrite16(qid, &cfg->queue_select);
>>> +       vp_iowrite16(ready, &cfg->queue_enable);
>> I think we need a comment to explain that IFCVF can support write to
>> queue_enable since it's not allowed by the virtio spec.
>
> I think you mean writing 0 there. writing 1 is allowed.
I have added a comment here says writing 0 would suspend the queue.
>
>
>>> +       vp_ioread16(&cfg->queue_enable);
>>> +}
>>> +
>>> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
>>> +{
>>> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>>> +       bool queue_enable;
>>> +
>>> +       vp_iowrite16(qid, &cfg->queue_select);
>>> +       queue_enable = vp_ioread16(&cfg->queue_enable);
>>> +
>>> +       return (bool)queue_enable;
>>>   }
>>>
>>>   int ifcvf_start_hw(struct ifcvf_hw *hw)
>>>   {
>>> -       ifcvf_reset(hw);
>>>          ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>>          ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
>>>
>>>          if (ifcvf_config_features(hw) < 0)
>>>                  return -EINVAL;
>>>
>>> -       if (ifcvf_hw_enable(hw) < 0)
>>> -               return -EINVAL;
>>> -
>>>          ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
>>>
>>>          return 0;
>>>   }
>>>
>>> +static void ifcvf_reset_vring(struct ifcvf_hw *hw)
>>> +{
>>> +       int i;
>>> +
>>> +       for (i = 0; i < hw->nr_vring; i++) {
>>> +               hw->vring[i].cb.callback = NULL;
>>> +               hw->vring[i].cb.private = NULL;
>>> +               ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
>>> +       }
>>> +}
>>> +
>>> +static void ifcvf_reset_config_handler(struct ifcvf_hw *hw)
>>> +{
>>> +       hw->config_cb.callback = NULL;
>>> +       hw->config_cb.private = NULL;
>>> +       ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
>> Do we need to synchronize with the IRQ here?
>>
>>> +}
>>> +
>>>   void ifcvf_stop_hw(struct ifcvf_hw *hw)
>>>   {
>>> -       ifcvf_hw_disable(hw);
>>> -       ifcvf_reset(hw);
>>> +       ifcvf_reset_vring(hw);
>>> +       ifcvf_reset_config_handler(hw);
>>>   }
>>>
>>>   void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> index 115b61f4924b..41d86985361f 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> @@ -49,12 +49,6 @@
>>>   #define MSIX_VECTOR_DEV_SHARED                 3
>>>
>>>   struct vring_info {
>>> -       u64 desc;
>>> -       u64 avail;
>>> -       u64 used;
>>> -       u16 size;
>>> -       u16 last_avail_idx;
>>> -       bool ready;
>>>          void __iomem *notify_addr;
>>>          phys_addr_t notify_pa;
>>>          u32 irq;
>>> @@ -131,6 +125,11 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>>>   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>>>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
>>> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
>>> +                        u64 driver_area, u64 device_area);
>>>   u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
>>>   u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
>>> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num);
>>> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready);
>>> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid);
>>>   #endif /* _IFCVF_H_ */
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index 4366320fb68d..e442aa11333e 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -374,37 +374,6 @@ static int ifcvf_start_datapath(void *private)
>>>          return ret;
>>>   }
>>>
>>> -static int ifcvf_stop_datapath(void *private)
>>> -{
>>> -       struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
>>> -       int i;
>>> -
>>> -       for (i = 0; i < vf->nr_vring; i++)
>>> -               vf->vring[i].cb.callback = NULL;
>>> -
>>> -       ifcvf_stop_hw(vf);
>>> -
>>> -       return 0;
>>> -}
>>> -
>>> -static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
>>> -{
>>> -       struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
>>> -       int i;
>>> -
>>> -       for (i = 0; i < vf->nr_vring; i++) {
>>> -               vf->vring[i].last_avail_idx = 0;
>>> -               vf->vring[i].desc = 0;
>>> -               vf->vring[i].avail = 0;
>>> -               vf->vring[i].used = 0;
>>> -               vf->vring[i].ready = 0;
>>> -               vf->vring[i].cb.callback = NULL;
>>> -               vf->vring[i].cb.private = NULL;
>>> -       }
>>> -
>>> -       ifcvf_reset(vf);
>>> -}
>>> -
>>>   static struct ifcvf_adapter *vdpa_to_adapter(struct vdpa_device *vdpa_dev)
>>>   {
>>>          return container_of(vdpa_dev, struct ifcvf_adapter, vdpa);
>>> @@ -477,6 +446,8 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>>>          if (status_old == status)
>>>                  return;
>>>
>>> +       ifcvf_set_status(vf, status);
>>> +
>>>          if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>              !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>                  ret = ifcvf_request_irq(adapter);
>> Does this mean e.g for DRIVER_OK the device may work before the
>> interrupt handler is requested?
>>
>> Looks racy.
>>
>> Thanks
>>
>>> @@ -493,7 +464,6 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>>>                                    status);
>>>          }
>>>
>>> -       ifcvf_set_status(vf, status);
>>>   }
>>>
>>>   static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
>>> @@ -509,12 +479,10 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
>>>          if (status_old == 0)
>>>                  return 0;
>>>
>>> -       if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
>>> -               ifcvf_stop_datapath(adapter);
>>> -               ifcvf_free_irq(adapter);
>>> -       }
>>> +       ifcvf_stop_hw(vf);
>>> +       ifcvf_free_irq(adapter);
>>>
>>> -       ifcvf_reset_vring(adapter);
>>> +       ifcvf_reset(vf);
>>>
>>>          return 0;
>>>   }
>>> @@ -554,14 +522,17 @@ static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
>>>   {
>>>          struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>
>>> -       vf->vring[qid].ready = ready;
>>> +       ifcvf_set_vq_ready(vf, qid, ready);
>>>   }
>>>
>>>   static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>>>   {
>>>          struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>> +       bool ready;
>>>
>>> -       return vf->vring[qid].ready;
>>> +       ready = ifcvf_get_vq_ready(vf, qid);
>>> +
>>> +       return ready;
>>>   }
>>>
>>>   static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
>>> @@ -569,7 +540,7 @@ static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
>>>   {
>>>          struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>
>>> -       vf->vring[qid].size = num;
>>> +       ifcvf_set_vq_num(vf, qid, num);
>>>   }
>>>
>>>   static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>>> @@ -578,11 +549,7 @@ static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>>>   {
>>>          struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>
>>> -       vf->vring[qid].desc = desc_area;
>>> -       vf->vring[qid].avail = driver_area;
>>> -       vf->vring[qid].used = device_area;
>>> -
>>> -       return 0;
>>> +       return ifcvf_set_vq_address(vf, qid, desc_area, driver_area, device_area);
>>>   }
>>>
>>>   static void ifcvf_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
>>> --
>>> 2.31.1
>>>

