Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172FA491CA7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiARDRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:28585 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345682AbiARDH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 22:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642475276; x=1674011276;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CNaqFv+uLyiP6jtGYdFqS6F6wbUedaaKvfHK8OxSP2Q=;
  b=GtdoBpteuKhrDdj5PNFyD0zNR2JogsVbA7sEPfjFwybW32nulX6y4na8
   R7l7neD7s8mcvnrYS2euMYRXOjzFUcEWzM36+wUqmS/GVoGg9irsUrsF4
   O0xZllyscst+4PMIWpEH2BtgcDf1aAY6buLEM3Hb0cCh8pNOLn3xv6KQZ
   rDfdCfpA+RndF/7HthQMQLK0DVovAVj5QGOHShnYIrsBOzWawiOLN0Ocw
   mhyRoD94YjE0FAtH4tNXh6Iqc/297rnMYqFizH3otJTKNRjgM2XT4D8Lw
   me77S7Jsr1c0pWb+D0iC+7HJVktjSzC67/XlDo6F598vFdsrYTkciPIUY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="243552245"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="243552245"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:07:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="476825082"
Received: from cbian-mobl.ccr.corp.intel.com (HELO [10.255.29.137]) ([10.255.29.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:07:54 -0800
Message-ID: <05435798-f496-5d12-ccce-bc53efa30e65@intel.com>
Date:   Tue, 18 Jan 2022 11:07:52 +0800
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
 <104ef2d4-fb89-58e6-0a07-f8bdaeb278e3@intel.com>
 <20220113052821-mutt-send-email-mst@kernel.org>
 <7546243d-1561-51fb-55d3-fe0ff1651e48@intel.com>
 <20220114081043-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220114081043-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/2022 9:36 PM, Michael S. Tsirkin wrote:
> On Fri, Jan 14, 2022 at 08:32:24PM +0800, Zhu, Lingshan wrote:
>>
>> On 1/13/2022 6:29 PM, Michael S. Tsirkin wrote:
>>
>>      On Thu, Jan 13, 2022 at 06:10:15PM +0800, Zhu, Lingshan wrote:
>>
>>
>>          On 1/13/2022 5:52 PM, Michael S. Tsirkin wrote:
>>
>>              On Thu, Jan 13, 2022 at 04:17:29PM +0800, Zhu, Lingshan wrote:
>>
>>                  On 1/11/2022 3:11 PM, Zhu, Lingshan wrote:
>>
>>
>>
>>                       On 1/10/2022 2:04 PM, Michael S. Tsirkin wrote:
>>
>>                           On Mon, Jan 10, 2022 at 01:18:51PM +0800, Zhu Lingshan wrote:
>>
>>                               This commit expends irq requester abilities to handle per vq irq,
>>                               shared irq and config irq.
>>
>>                               On some platforms, the device can not get enough vectors for every
>>                               virtqueue and config interrupt, the device needs to work under such
>>                               circumstances.
>>
>>                               Normally a device can get enough vectors, so every virtqueue and
>>                               config interrupt can have its own vector/irq. If the total vector
>>                               number is less than all virtqueues + 1(config interrupt), all
>>                               virtqueues need to share a vector/irq and config interrupt is
>>                               enabled. If the total vector number < 2, all vitequeues share
>>                               a vector/irq, and config interrupt is disabled. Otherwise it will
>>                               fail if allocation for vectors fails.
>>
>>                               This commit also made necessary chages to the irq cleaner to
>>                               free per vq irq/shared irq and config irq.
>>
>>                               Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>
>>                           In this case, shouldn't you also check VIRTIO_PCI_ISR_CONFIG?
>>                           doing that will skip the need
>>
>>                       Hello Michael,
>>
>>                       When insufficient MSIX vectors granted:
>>                       If num_vectors >=2, there will be a vector for the config interrupt, and all vqs share one vector.
>>                       If num_vectors =1, all vqs share the only one vector, and config interrupt is disabled.
>>
>>              ATM linux falls back to INTX in that case, shared by config and vqs.
>>
>>          Yes, the same result. However this driver needs to drive VFs too, and VFs do
>>          not support INTX,
>>          so we need it to send msix dma.
>>
>>                       currently vqs and config interrupt don't share vectors, so IMHO, no need to check .
>>
>>              IMHO it does not matter much that current Linux drivers do not use it,
>>              the spec explicitly allows this option. If such hardware
>>              becomes more common (and you seem to want to improve support
>>              for managing interrupts so maybe yes) we'll add it in Linux.
>>
>>          (just see your another email coming), so I think I should implement a irq
>>          handler
>>          for num_vectors=1 case, a handler checks VIRTIO_PCI_ISR_CONFIG to tell
>>          whether
>>          it is a vq interrupt or config interrupt, then handle it(not disabling
>>          config interrupt).
>>
>>          Thanks,
>>          Zhu Lingshan
>>
>>      Right. To be more exact, if status is bit 2 is not set you call
>>      vq interrupt, if set you call both vq and config interrupt,
>>      since with MSI only config interrupts have a status bit.
>>
>> Thanks! I guess I should call both vq and config interrupt handlers when they
>> share only one vector, because the spec says VIRTIO_PCI_CAP_ISR_CFG
>> is for INTx, but VFs don't support INTx as SRIOV spec required, so
>> isr may always be zero.
>>
>> Thanks,
>> Zhu Lingshan
>>
> Yes. But on the other hand, the spec says:
>
> The device MUST present at least one VIRTIO_PCI_CAP_ISR_CFG capability.
> The device MUST set the Device Configuration Interrupt bit in ISR status before sending a device configu­
> ration change notification to the driver.
> If MSI­X capability is disabled, the device MUST set the Queue Interrupt bit in ISR status before sending a
> virtqueue notification to the driver.
>
> which to me implies that the Device Configuration Interrupt bit
> is set unconditionally.
>
> And yes it says:
> ...to be used for INT#x interrupt handling
> but it does not say "exclusively".
>
> It is unfortunate that it does not copy this requirement in more places, but
> I think that device does have to set Device Configuration Interrupt bit
> unconditionally.
sorry for the late reply, I totally agree on expanding ISR cap to 
MSI(and MSIX) usage.
>
>
> What exactly does ifcvf do? Does it ever trigger config change
> interrupts? If it does, does it set the Device Configuration Interrupt
> when MSI is used?
It triggers config interrupt upon config changes. However, the spec says:
"If MSI-X capability is enabled, the driver SHOULD NOT access ISR status 
upon detecting a Queue Interrupt.",
so for a VF(only MSIX, no INTx), when a vq interrupt is triggered, we 
see isr == 0;
So I think it would be nice to make slight changes to the spec: 
consistently describes ISR cap usage, and
remove this (ambiguous) limitation of ISR usage(which implies only for 
INTx).

For the driver which drivers both VF and PF, I think currently we should 
ignore ISR cap, means if the all device vqs and config interrupt
share the only one vector/IRQ, just kick them all. I agree we should 
work out a way to tell the device type in the future.
Does this sounds reasonable?

Thanks,
Zhu Lingshan
>
> I will report a spec defect for the apparent inconsistency.
>
>>                       I will send a V2 patch address your comments.
>>
>>                       Thanks,
>>                       Zhu Lingshan
>>
>>                               ---
>>                                drivers/vdpa/ifcvf/ifcvf_base.h |  6 +--
>>                                drivers/vdpa/ifcvf/ifcvf_main.c | 78 +++++++++++++++------------------
>>                                2 files changed, 38 insertions(+), 46 deletions(-)
>>
>>                               diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>>                               index 1d5431040d7d..1d0afb63f06c 100644
>>                               --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>                               +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>                               @@ -27,8 +27,6 @@
>>
>>                                #define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
>>                                #define IFCVF_QUEUE_MAX                32768
>>                               -#define IFCVF_MSI_CONFIG_OFF   0
>>                               -#define IFCVF_MSI_QUEUE_OFF    1
>>                                #define IFCVF_PCI_MAX_RESOURCE 6
>>
>>                                #define IFCVF_LM_CFG_SIZE              0x40
>>                               @@ -102,11 +100,13 @@ struct ifcvf_hw {
>>                                       u8 notify_bar;
>>                                       /* Notificaiton bar address */
>>                                       void __iomem *notify_base;
>>                               +       u8 vector_per_vq;
>>                               +       u16 padding;
>>
>>                           What is this padding doing?
>>
>>                  for cacheline alignment
>>
>>
>>
>>                                       phys_addr_t notify_base_pa;
>>                                       u32 notify_off_multiplier;
>>                               +       u32 dev_type;
>>                                       u64 req_features;
>>                                       u64 hw_features;
>>                               -       u32 dev_type;
>>
>>                           moving things around ... optimization? split out.
>>
>>                  sure
>>
>>
>>
>>                                       struct virtio_pci_common_cfg __iomem *common_cfg;
>>                                       void __iomem *net_cfg;
>>                                       struct vring_info vring[IFCVF_MAX_QUEUES];
>>                               diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>>                               index 414b5dfd04ca..ec76e342bd7e 100644
>>                               --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>                               +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>                               @@ -17,6 +17,8 @@
>>                                #define DRIVER_AUTHOR   "Intel Corporation"
>>                                #define IFCVF_DRIVER_NAME       "ifcvf"
>>
>>                               +static struct vdpa_config_ops ifc_vdpa_ops;
>>                               +
>>
>>                           there can be multiple devices thinkably.
>>                           reusing a global ops does not sound reasonable.
>>
>>                  OK, I will set vq irq number to -EINVAL when vqs share irq,
>>                  then we can disable irq_bypass when see irq = -EINVAL,
>>                  no need to set get_vq_irq = NULL.
>>
>>
>>
>>
>>                                static irqreturn_t ifcvf_config_changed(int irq, void *arg)
>>                                {
>>                                       struct ifcvf_hw *vf = arg;
>>                               @@ -63,13 +65,20 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>>                                       struct ifcvf_hw *vf = &adapter->vf;
>>                                       int i;
>>
>>                               +       if (vf->vector_per_vq)
>>                               +               for (i = 0; i < queues; i++) {
>>                               +                       devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>                               +                       vf->vring[i].irq = -EINVAL;
>>                               +               }
>>                               +       else
>>                               +               devm_free_irq(&pdev->dev, vf->vring[0].irq, vf);
>>
>>                               -       for (i = 0; i < queues; i++) {
>>                               -               devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
>>                               -               vf->vring[i].irq = -EINVAL;
>>                               +
>>                               +       if (vf->config_irq != -EINVAL) {
>>                               +               devm_free_irq(&pdev->dev, vf->config_irq, vf);
>>                               +               vf->config_irq = -EINVAL;
>>                                       }
>>
>>                           what about other error types?
>>
>>                  vf->config_irq is set to -EINVAL in ifcvf_request_config_irq(),
>>                  if no config irq(vector) is granted, or it should be a valid irq number,
>>                  so there can be no other error numbers. But I can change it
>>                  to  if (vf->config_irq < 0) for sure
>>
>>
>>
>>
>>                               -       devm_free_irq(&pdev->dev, vf->config_irq, vf);
>>                                       ifcvf_free_irq_vectors(pdev);
>>                                }
>>
>>                               @@ -191,52 +200,35 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_ve
>>
>>                                static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>>                                {
>>                               -       struct pci_dev *pdev = adapter->pdev;
>>                                       struct ifcvf_hw *vf = &adapter->vf;
>>                               -       int vector, i, ret, irq;
>>                               -       u16 max_intr;
>>                               +       u16 nvectors, max_vectors;
>>                               +       int config_vector, ret;
>>
>>                               -       /* all queues and config interrupt  */
>>                               -       max_intr = vf->nr_vring + 1;
>>                               +       nvectors = ifcvf_alloc_vectors(adapter);
>>                               +       if (nvectors < 0)
>>                               +               return nvectors;
>>
>>                               -       ret = pci_alloc_irq_vectors(pdev, max_intr,
>>                               -                                   max_intr, PCI_IRQ_MSIX);
>>                               -       if (ret < 0) {
>>                               -               IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>>                               -               return ret;
>>                               -       }
>>                               +       vf->vector_per_vq = true;
>>                               +       max_vectors = vf->nr_vring + 1;
>>                               +       config_vector = vf->nr_vring;
>>
>>                               -       snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
>>                               -                pci_name(pdev));
>>                               -       vector = 0;
>>                               -       vf->config_irq = pci_irq_vector(pdev, vector);
>>                               -       ret = devm_request_irq(&pdev->dev, vf->config_irq,
>>                               -                              ifcvf_config_changed, 0,
>>                               -                              vf->config_msix_name, vf);
>>                               -       if (ret) {
>>                               -               IFCVF_ERR(pdev, "Failed to request config irq\n");
>>                               -               return ret;
>>                               +       if (nvectors < max_vectors) {
>>                               +               vf->vector_per_vq = false;
>>                               +               config_vector = 1;
>>                               +               ifc_vdpa_ops.get_vq_irq = NULL;
>>                                       }
>>
>>                               -       for (i = 0; i < vf->nr_vring; i++) {
>>                               -               snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
>>                               -                        pci_name(pdev), i);
>>                               -               vector = i + IFCVF_MSI_QUEUE_OFF;
>>                               -               irq = pci_irq_vector(pdev, vector);
>>                               -               ret = devm_request_irq(&pdev->dev, irq,
>>                               -                                      ifcvf_intr_handler, 0,
>>                               -                                      vf->vring[i].msix_name,
>>                               -                                      &vf->vring[i]);
>>                               -               if (ret) {
>>                               -                       IFCVF_ERR(pdev,
>>                               -                                 "Failed to request irq for vq %d\n", i);
>>                               -                       ifcvf_free_irq(adapter, i);
>>                               +       if (nvectors < 2)
>>                               +               config_vector = 0;
>>
>>                               -                       return ret;
>>                               -               }
>>                               +       ret = ifcvf_request_vq_irq(adapter, vf->vector_per_vq);
>>                               +       if (ret)
>>                               +               return ret;
>>
>>                               -               vf->vring[i].irq = irq;
>>                               -       }
>>                               +       ret = ifcvf_request_config_irq(adapter, config_vector);
>>                               +
>>                               +       if (ret)
>>                               +               return ret;
>>
>>                           here on error we need to cleanup vq irq we requested, need we not?
>>
>>                  I think it may not be needed, it can work without config interrupt, though lame
>>
>>                  Thanks for your comments!
>>                  Zhu Lingshan
>>
>>
>>
>>
>>                                       return 0;
>>                                }
>>                               @@ -573,7 +565,7 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
>>                                 * IFCVF currently does't have on-chip IOMMU, so not
>>                                 * implemented set_map()/dma_map()/dma_unmap()
>>                                 */
>>                               -static const struct vdpa_config_ops ifc_vdpa_ops = {
>>                               +static struct vdpa_config_ops ifc_vdpa_ops = {
>>                                       .get_features   = ifcvf_vdpa_get_features,
>>                                       .set_features   = ifcvf_vdpa_set_features,
>>                                       .get_status     = ifcvf_vdpa_get_status,
>>                               --
>>                               2.27.0
>>
>>
>>
>>
>>
>>

