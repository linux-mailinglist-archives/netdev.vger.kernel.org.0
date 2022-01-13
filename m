Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A41348D56F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiAMKKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:10:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:25769 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbiAMKKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 05:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642068619; x=1673604619;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VPakz69WokqAuxyzWrj35yW3FQTTCGRnryqWpLR4cd8=;
  b=I8P2KhizkSejorXmWxq0z8HWWl6EtwSxi5ZAz2dJcrhBFpcEWsQmuC//
   2VEhjjdrftQy4u9RYShd41/6H4D2J43uTa4Tnz3+oyp+fZufW1koIXnHf
   hq2oxDkcfu/IIdd8wNWvnhVOU6SM1Ak1S9/qi8lahhYwgBJ4h3ZQ/hL3R
   Yz+TxsuByaRqxqKjZQqYyMAH3mEmtzH3LGOJxpzz9XbEIc+ZPRhXebZDp
   MOd3vbClE5CnbRHM9evx9vzLDK38NuTVFQ0+6/lpbIB8ytH+0iJfj/8b6
   JQdNQ++Z1CpQo8Vd48k1pefZNE/jrXH44S2u5VKJeIn8bjPYrDvECUMSe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="223960075"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="223960075"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 02:10:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="475255224"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.137]) ([10.255.30.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 02:10:17 -0800
Message-ID: <104ef2d4-fb89-58e6-0a07-f8bdaeb278e3@intel.com>
Date:   Thu, 13 Jan 2022 18:10:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH 7/7] vDPA/ifcvf: improve irq requester, to handle
 per_vq/shared/config irq
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-8-lingshan.zhu@intel.com>
 <20220110005612-mutt-send-email-mst@kernel.org>
 <bc210134-4b1c-1b23-47f3-c90fb4b91b65@intel.com>
 <d7610c1c-611f-86e2-5330-c4783db078f5@intel.com>
 <20220113044642-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220113044642-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2022 5:52 PM, Michael S. Tsirkin wrote:
> On Thu, Jan 13, 2022 at 04:17:29PM +0800, Zhu, Lingshan wrote:
>>
>> On 1/11/2022 3:11 PM, Zhu, Lingshan wrote:
>>
>>
>>
>>      On 1/10/2022 2:04 PM, Michael S. Tsirkin wrote:
>>
>>          On Mon, Jan 10, 2022 at 01:18:51PM +0800, Zhu Lingshan wrote:
>>
>>              This commit expends irq requester abilities to handle per vq irq,
>>              shared irq and config irq.
>>
>>              On some platforms, the device can not get enough vectors for every
>>              virtqueue and config interrupt, the device needs to work under such
>>              circumstances.
>>
>>              Normally a device can get enough vectors, so every virtqueue and
>>              config interrupt can have its own vector/irq. If the total vector
>>              number is less than all virtqueues + 1(config interrupt), all
>>              virtqueues need to share a vector/irq and config interrupt is
>>              enabled. If the total vector number < 2, all vitequeues share
>>              a vector/irq, and config interrupt is disabled. Otherwise it will
>>              fail if allocation for vectors fails.
>>
>>              This commit also made necessary chages to the irq cleaner to
>>              free per vq irq/shared irq and config irq.
>>
>>              Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>
>>          In this case, shouldn't you also check VIRTIO_PCI_ISR_CONFIG?
>>          doing that will skip the need
>>
>>      Hello Michael,
>>
>>      When insufficient MSIX vectors granted:
>>      If num_vectors >=2, there will be a vector for the config interrupt, and all vqs share one vector.
>>      If num_vectors =1, all vqs share the only one vector, and config interrupt is disabled.
> ATM linux falls back to INTX in that case, shared by config and vqs.
Yes, the same result. However this driver needs to drive VFs too, and 
VFs do not support INTX,
so we need it to send msix dma.
>
>>      currently vqs and config interrupt don't share vectors, so IMHO, no need to check .
> IMHO it does not matter much that current Linux drivers do not use it,
> the spec explicitly allows this option. If such hardware
> becomes more common (and you seem to want to improve support
> for managing interrupts so maybe yes) we'll add it in Linux.
(just see your another email coming), so I think I should implement a 
irq handler
for num_vectors=1 case, a handler checks VIRTIO_PCI_ISR_CONFIG to tell 
whether
it is a vq interrupt or config interrupt, then handle it(not disabling 
config interrupt).

Thanks,
Zhu Lingshan
>
>>      I will send a V2 patch address your comments.
>>
>>      Thanks,
>>      Zhu Lingshan
>>
>>              ---
>>               drivers/vdpa/ifcvf/ifcvf_base.h |  6 +--
>>               drivers/vdpa/ifcvf/ifcvf_main.c | 78 +++++++++++++++------------------
>>               2 files changed, 38 insertions(+), 46 deletions(-)
>>
>>              diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>>              index 1d5431040d7d..1d0afb63f06c 100644
>>              --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>              +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>              @@ -27,8 +27,6 @@
>>
>>               #define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
>>               #define IFCVF_QUEUE_MAX                32768
>>              -#define IFCVF_MSI_CONFIG_OFF   0
>>              -#define IFCVF_MSI_QUEUE_OFF    1
>>               #define IFCVF_PCI_MAX_RESOURCE 6
>>
>>               #define IFCVF_LM_CFG_SIZE              0x40
>>              @@ -102,11 +100,13 @@ struct ifcvf_hw {
>>                      u8 notify_bar;
>>                      /* Notificaiton bar address */
>>                      void __iomem *notify_base;
>>              +       u8 vector_per_vq;
>>              +       u16 padding;
>>
>>          What is this padding doing?
>>
>> for cacheline alignment
>>
>>
>>
>>                      phys_addr_t notify_base_pa;
>>                      u32 notify_off_multiplier;
>>              +       u32 dev_type;
>>                      u64 req_features;
>>                      u64 hw_features;
>>              -       u32 dev_type;
>>
>>          moving things around ... optimization? split out.
>>
>> sure
>>
>>
>>
>>                      struct virtio_pci_common_cfg __iomem *common_cfg;
>>                      void __iomem *net_cfg;
>>                      struct vring_info vring[IFCVF_MAX_QUEUES];
>>              diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>>              index 414b5dfd04ca..ec76e342bd7e 100644
>>              --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>              +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>              @@ -17,6 +17,8 @@
>>               #define DRIVER_AUTHOR   "Intel Corporation"
>>               #define IFCVF_DRIVER_NAME       "ifcvf"
>>
>>              +static struct vdpa_config_ops ifc_vdpa_ops;
>>              +
>>
>>          there can be multiple devices thinkably.
>>          reusing a global ops does not sound reasonable.
>>
>> OK, I will set vq irq number to -EINVAL when vqs share irq,
>> then we can disable irq_bypass when see irq = -EINVAL,
>> no need to set get_vq_irq = NULL.
>>
>>
>>
>>
>>               static irqreturn_t ifcvf_config_changed(int irq, void *arg)
>>               {
>>                      struct ifcvf_hw *vf = arg;
>>              @@ -63,13 +65,20 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>>                      struct ifcvf_hw *vf = &adapter->vf;
>>                      int i;
>>
>>              +       if (vf->vector_per_vq)
>>              +               for (i = 0; i < queues; i++) {
>>              +                       devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>              +                       vf->vring[i].irq = -EINVAL;
>>              +               }
>>              +       else
>>              +               devm_free_irq(&pdev->dev, vf->vring[0].irq, vf);
>>
>>              -       for (i = 0; i < queues; i++) {
>>              -               devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>              -               vf->vring[i].irq = -EINVAL;
>>              +
>>              +       if (vf->config_irq != -EINVAL) {
>>              +               devm_free_irq(&pdev->dev, vf->config_irq, vf);
>>              +               vf->config_irq = -EINVAL;
>>                      }
>>
>>          what about other error types?
>>
>> vf->config_irq is set to -EINVAL in ifcvf_request_config_irq(),
>> if no config irq(vector) is granted, or it should be a valid irq number,
>> so there can be no other error numbers. But I can change it
>> to  if (vf->config_irq < 0) for sure
>>
>>
>>
>>
>>              -       devm_free_irq(&pdev->dev, vf->config_irq, vf);
>>                      ifcvf_free_irq_vectors(pdev);
>>               }
>>
>>              @@ -191,52 +200,35 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_ve
>>
>>               static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>>               {
>>              -       struct pci_dev *pdev = adapter->pdev;
>>                      struct ifcvf_hw *vf = &adapter->vf;
>>              -       int vector, i, ret, irq;
>>              -       u16 max_intr;
>>              +       u16 nvectors, max_vectors;
>>              +       int config_vector, ret;
>>
>>              -       /* all queues and config interrupt  */
>>              -       max_intr = vf->nr_vring + 1;
>>              +       nvectors = ifcvf_alloc_vectors(adapter);
>>              +       if (nvectors < 0)
>>              +               return nvectors;
>>
>>              -       ret = pci_alloc_irq_vectors(pdev, max_intr,
>>              -                                   max_intr, PCI_IRQ_MSIX);
>>              -       if (ret < 0) {
>>              -               IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>>              -               return ret;
>>              -       }
>>              +       vf->vector_per_vq = true;
>>              +       max_vectors = vf->nr_vring + 1;
>>              +       config_vector = vf->nr_vring;
>>
>>              -       snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
>>              -                pci_name(pdev));
>>              -       vector = 0;
>>              -       vf->config_irq = pci_irq_vector(pdev, vector);
>>              -       ret = devm_request_irq(&pdev->dev, vf->config_irq,
>>              -                              ifcvf_config_changed, 0,
>>              -                              vf->config_msix_name, vf);
>>              -       if (ret) {
>>              -               IFCVF_ERR(pdev, "Failed to request config irq\n");
>>              -               return ret;
>>              +       if (nvectors < max_vectors) {
>>              +               vf->vector_per_vq = false;
>>              +               config_vector = 1;
>>              +               ifc_vdpa_ops.get_vq_irq = NULL;
>>                      }
>>
>>              -       for (i = 0; i < vf->nr_vring; i++) {
>>              -               snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
>>              -                        pci_name(pdev), i);
>>              -               vector = i + IFCVF_MSI_QUEUE_OFF;
>>              -               irq = pci_irq_vector(pdev, vector);
>>              -               ret = devm_request_irq(&pdev->dev, irq,
>>              -                                      ifcvf_intr_handler, 0,
>>              -                                      vf->vring[i].msix_name,
>>              -                                      &vf->vring[i]);
>>              -               if (ret) {
>>              -                       IFCVF_ERR(pdev,
>>              -                                 "Failed to request irq for vq %d\n", i);
>>              -                       ifcvf_free_irq(adapter, i);
>>              +       if (nvectors < 2)
>>              +               config_vector = 0;
>>
>>              -                       return ret;
>>              -               }
>>              +       ret = ifcvf_request_vq_irq(adapter, vf->vector_per_vq);
>>              +       if (ret)
>>              +               return ret;
>>
>>              -               vf->vring[i].irq = irq;
>>              -       }
>>              +       ret = ifcvf_request_config_irq(adapter, config_vector);
>>              +
>>              +       if (ret)
>>              +               return ret;
>>
>>          here on error we need to cleanup vq irq we requested, need we not?
>>
>> I think it may not be needed, it can work without config interrupt, though lame
>>
>> Thanks for your comments!
>> Zhu Lingshan
>>
>>
>>
>>
>>                      return 0;
>>               }
>>              @@ -573,7 +565,7 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
>>                * IFCVF currently does't have on-chip IOMMU, so not
>>                * implemented set_map()/dma_map()/dma_unmap()
>>                */
>>              -static const struct vdpa_config_ops ifc_vdpa_ops = {
>>              +static struct vdpa_config_ops ifc_vdpa_ops = {
>>                      .get_features   = ifcvf_vdpa_get_features,
>>                      .set_features   = ifcvf_vdpa_set_features,
>>                      .get_status     = ifcvf_vdpa_get_status,
>>              --
>>              2.27.0
>>
>>
>>
>>

