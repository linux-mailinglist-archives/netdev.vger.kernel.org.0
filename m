Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687004F82A8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiDGPTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiDGPT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:19:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88E371FAA25;
        Thu,  7 Apr 2022 08:17:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 921BA12FC;
        Thu,  7 Apr 2022 08:17:19 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F7B33F73B;
        Thu,  7 Apr 2022 08:17:15 -0700 (PDT)
Message-ID: <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
Date:   Thu, 7 Apr 2022 16:17:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
 dev_is_dma_coherent()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com> <20220406151823.GG2120790@nvidia.com>
 <20220406155056.GA30433@lst.de> <20220406160623.GI2120790@nvidia.com>
 <20220406161031.GA31790@lst.de> <20220406171729.GJ2120790@nvidia.com>
 <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220407135946.GM2120790@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220407135946.GM2120790@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-07 14:59, Jason Gunthorpe wrote:
> On Thu, Apr 07, 2022 at 07:18:48AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Thursday, April 7, 2022 1:17 AM
>>>
>>> On Wed, Apr 06, 2022 at 06:10:31PM +0200, Christoph Hellwig wrote:
>>>> On Wed, Apr 06, 2022 at 01:06:23PM -0300, Jason Gunthorpe wrote:
>>>>> On Wed, Apr 06, 2022 at 05:50:56PM +0200, Christoph Hellwig wrote:
>>>>>> On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
>>>>>>>> Oh, I didn't know about device_get_dma_attr()..
>>>>>>
>>>>>> Which is completely broken for any non-OF, non-ACPI plaform.
>>>>>
>>>>> I saw that, but I spent some time searching and could not find an
>>>>> iommu driver that would load independently of OF or ACPI. ie no IOMMU
>>>>> platform drivers are created by board files. Things like Intel/AMD
>>>>> discover only from ACPI, etc.
>>
>> Intel discovers IOMMUs (and optionally ACPI namespace devices) from
>> ACPI, but there is no ACPI description for PCI devices i.e. the current
>> logic of device_get_dma_attr() cannot be used on PCI devices.
> 
> Oh? So on x86 acpi_get_dma_attr() returns DEV_DMA_NON_COHERENT or
> DEV_DMA_NOT_SUPPORTED?

I think it _should_ return DEV_DMA_COHERENT on x86/IA-64 (unless a _CCA 
method was actually present to say otherwise), based on 
acpi_init_coherency(), but I only know for sure what happens on arm64.

> I think I should give up on this and just redefine the existing iommu
> cap flag to IOMMU_CAP_CACHE_SUPPORTED or something.

TBH I don't see any issue with current name, but I'd certainly be happy 
to nail down a specific definition for it, along the lines of "this 
means that IOMMU_CACHE mappings are generally coherent". That works for 
things like Arm's S2FWB making it OK to assign an otherwise-non-coherent 
device without extra hassle.

For the specific case of overriding PCIe No Snoop (which is more 
problematic from an Arm SMMU PoV) when assigning to a VM, would that not 
be easier solved by just having vfio-pci clear the "Enable No Snoop" 
control bit in the endpoint's PCIe capability?

>>> We could alternatively use existing device_get_dma_attr() as a default
>>> with an iommu wrapper and push the exception down through the iommu
>>> driver and s390 can override it.
>>>
>>
>> if going this way probably device_get_dma_attr() should be renamed to
>> device_fwnode_get_dma_attr() instead to make it clearer?
> 
> I'm looking at the few users:
> 
> drivers/ata/ahci_ceva.c
> drivers/ata/ahci_qoriq.c
>   - These are ARM only drivers. They are trying to copy the dma-coherent
>     property from its DT/ACPI definition to internal register settings
>     which look like they tune how the AXI bus transactions are created.
> 
>     I'm guessing the SATA IP block's AXI interface can be configured to
>     generate coherent or non-coherent requests and it has to be set
>     in a way that is consistent with the SOC architecture and match
>     what the DMA API expects the device will do.
> 
> drivers/crypto/ccp/sp-platform.c
>   - Only used on ARM64 and also programs a HW register similar to the
>     sata drivers. Refuses to work if the FW property is not present.
> 
> drivers/net/ethernet/amd/xgbe/xgbe-platform.c
>   - Seems to be configuring another ARM AXI block
> 
> drivers/gpu/drm/panfrost/panfrost_drv.c
>   - Robin's commit comment here is good, and one of the things this
>     controls is if the coherent_walk is set for the io-pgtable-arm.c
>     code which avoids DMA API calls
> 
> drivers/gpu/drm/tegra/uapi.c
>   - Returns DRM_TEGRA_CHANNEL_CAP_CACHE_COHERENT to userspace. No idea.
> 
> My take is that the drivers using this API are doing it to make sure
> their HW blocks are setup in a way that is consistent with the DMA API
> they are also using, and run in constrained embedded-style
> environments that know the firmware support is present.
> 
> So in the end it does not seem suitable right now for linking to
> IOMMU_CACHE..

That seems a pretty good summary - I think they're basically all 
"firmware told Linux I'm coherent so I'd better act coherent" cases, but 
that still doesn't necessarily mean that they're *forced* to respect 
that. One of the things on my to-do list is to try adding a 
DMA_ATTR_NO_SNOOP that can force DMA cache maintenance for coherent 
devices, primarily to hook up in Panfrost (where there is a bit of a 
performance to claw back on the coherent AmLogic SoCs by leaving certain 
buffers non-cacheable).

Cheers,
Robin.
