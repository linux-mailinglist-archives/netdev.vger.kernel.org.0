Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C23D4F836B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344933AbiDGPd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345146AbiDGPdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:33:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24039C38;
        Thu,  7 Apr 2022 08:31:08 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7B78668AFE; Thu,  7 Apr 2022 17:31:03 +0200 (CEST)
Date:   Thu, 7 Apr 2022 17:31:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
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
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220407153103.GA15336@lst.de>
References: <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com> <20220406142432.GF2120790@nvidia.com> <20220406151823.GG2120790@nvidia.com> <20220406155056.GA30433@lst.de> <20220406160623.GI2120790@nvidia.com> <20220406161031.GA31790@lst.de> <20220406171729.GJ2120790@nvidia.com> <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com> <20220407135946.GM2120790@nvidia.com> <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:17:11PM +0100, Robin Murphy wrote:
>> My take is that the drivers using this API are doing it to make sure
>> their HW blocks are setup in a way that is consistent with the DMA API
>> they are also using, and run in constrained embedded-style
>> environments that know the firmware support is present.
>>
>> So in the end it does not seem suitable right now for linking to
>> IOMMU_CACHE..
>
> That seems a pretty good summary - I think they're basically all "firmware 
> told Linux I'm coherent so I'd better act coherent" cases, but that still 
> doesn't necessarily mean that they're *forced* to respect that.

Yes. And the interface is horribly misnamed for that.  I'll see what
I can do to clean this up as I've noticed various other not very
nice things in that area.

> One of the 
> things on my to-do list is to try adding a DMA_ATTR_NO_SNOOP that can force 
> DMA cache maintenance for coherent devices, primarily to hook up in 
> Panfrost (where there is a bit of a performance to claw back on the 
> coherent AmLogic SoCs by leaving certain buffers non-cacheable).

This has been an explicit request from the amdgpu folks and thus been
on my TODO list for quite a while as well.  Note that I don't think it
should be a flag to dma_alloc_attrs, but rather for dma_alloc_pages
as the drivers that want non-snoop generally also want to actually
be able to deal with pages.
