Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FDA6C6870
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjCWMf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCWMf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:35:28 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0C1B2F8;
        Thu, 23 Mar 2023 05:35:27 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Pj46f6NSwzKmj9;
        Thu, 23 Mar 2023 20:15:22 +0800 (CST)
Received: from [10.174.179.79] (10.174.179.79) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 20:15:44 +0800
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <joro@8bytes.org>,
        <will@kernel.org>, <robin.murphy@arm.com>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <wangrong68@huawei.com>,
        Cindy Lu <lulu@redhat.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com> <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
 <20230310034101-mutt-send-email-mst@kernel.org>
 <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
 <20230310045100-mutt-send-email-mst@kernel.org> <ZAskNjP3d9ipki4k@nvidia.com>
 <c6e60ed9-6de2-2f4a-7bd1-52c53ed57a28@huawei.com>
 <ZBw4hGj8oGARaKhW@nvidia.com>
From:   Nanyong Sun <sunnanyong@huawei.com>
Message-ID: <b2c24e31-a708-8556-0029-93c0aa22a6ef@huawei.com>
Date:   Thu, 23 Mar 2023 20:15:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ZBw4hGj8oGARaKhW@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.79]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/23 19:31, Jason Gunthorpe wrote:

> On Thu, Mar 23, 2023 at 05:22:36PM +0800, Nanyong Sun wrote:
>>> A patch to export that function is alread posted:
>>>
>>> https://lore.kernel.org/linux-iommu/BN9PR11MB52760E9705F2985EACCD5C4A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#u
>>>
>>> But I do not want VDPA to mis-use it unless it also implements all the
>>> ownership stuff properly.
>>>
>> I want to confirm if we need to introduce iommu group logic to vdpa, as "all
>> the ownership stuff" ?
> You have to call iommu_device_claim_dma_owner()
>
> But again, this is all pointless, iommufd takes are of all of this and
> VDPA should switch to it instead of more hacking.
>
> Jason
> .
Yeah,  thanks for your suggestion，but as Michael and Jason Wang said, 
before iommufd is ready, we may need to make vDPA work well on software 
managed MSI platforms.
To achieve that, basically we have two ways:

1. export iommu_get_resv_regions, and get regions device by device.
2. introduce iommu group, get regions by iommu_get_group_resv_regions, 
which already exported.
