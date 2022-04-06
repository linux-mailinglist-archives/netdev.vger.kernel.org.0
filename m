Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688304F671C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiDFRj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbiDFRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:39:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C0DC18BCCE;
        Wed,  6 Apr 2022 08:48:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B11812FC;
        Wed,  6 Apr 2022 08:48:36 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 164303F73B;
        Wed,  6 Apr 2022 08:48:30 -0700 (PDT)
Message-ID: <7455941b-ffc0-3771-7852-36fa685275e1@arm.com>
Date:   Wed, 6 Apr 2022 16:48:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
 dev_is_dma_coherent()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220406053039.GA10580@lst.de> <20220406120730.GA2120790@nvidia.com>
 <20220406135150.GA21532@lst.de> <20220406141446.GE2120790@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220406141446.GE2120790@nvidia.com>
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

On 2022-04-06 15:14, Jason Gunthorpe wrote:
> On Wed, Apr 06, 2022 at 03:51:50PM +0200, Christoph Hellwig wrote:
>> On Wed, Apr 06, 2022 at 09:07:30AM -0300, Jason Gunthorpe wrote:
>>> Didn't see it
>>>
>>> I'll move dev_is_dma_coherent to device.h along with
>>> device_iommu_mapped() and others then
>>
>> No.  It it is internal for a reason.  It also doesn't actually work
>> outside of the dma core.  E.g. for non-swiotlb ARM configs it will
>> not actually work.
> 
> Really? It is the only condition that dma_info_to_prot() tests to
> decide of IOMMU_CACHE is used or not, so you are saying that there is
> a condition where a device can be attached to an iommu_domain and
> dev_is_dma_coherent() returns the wrong information? How does
> dma-iommu.c safely use it then?

The common iommu-dma layer happens to be part of the subset of the DMA 
core which *does* play the dev->dma_coherent game. 32-bit Arm has its 
own IOMMU DMA ops which do not. I don't know if the set of PowerPCs with 
CONFIG_NOT_COHERENT_CACHE intersects the set of PowerPCs that can do 
VFIO, but that would be another example if so.

> In any case I still need to do something about the places checking
> IOMMU_CAP_CACHE_COHERENCY and thinking that means IOMMU_CACHE
> works. Any idea?

Can we improve the IOMMU drivers such that that *can* be the case 
(within a reasonable margin of error)? That's kind of where I was hoping 
to head with device_iommu_capable(), e.g. [1].

Robin.

[1] 
https://gitlab.arm.com/linux-arm/linux-rm/-/commit/53390e9505b3791adedc0974e251e5c7360e402e
