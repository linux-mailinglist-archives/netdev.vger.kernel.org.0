Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C6A6C6340
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCWJXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjCWJWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:22:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0040A1A95B;
        Thu, 23 Mar 2023 02:22:40 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pj0CM5ChTzSm34;
        Thu, 23 Mar 2023 17:19:11 +0800 (CST)
Received: from [10.174.179.79] (10.174.179.79) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 17:22:37 +0800
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <joro@8bytes.org>,
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
From:   Nanyong Sun <sunnanyong@huawei.com>
Message-ID: <c6e60ed9-6de2-2f4a-7bd1-52c53ed57a28@huawei.com>
Date:   Thu, 23 Mar 2023 17:22:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ZAskNjP3d9ipki4k@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
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


On 2023/3/10 20:36, Jason Gunthorpe wrote:
> On Fri, Mar 10, 2023 at 04:53:42AM -0500, Michael S. Tsirkin wrote:
>> On Fri, Mar 10, 2023 at 05:45:46PM +0800, Jason Wang wrote:
>>> On Fri, Mar 10, 2023 at 4:41 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> On Mon, Feb 20, 2023 at 10:37:18AM +0800, Jason Wang wrote:
>>>>> On Fri, Feb 17, 2023 at 8:43 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>> On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
>>>>>>>> On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
>>>>>>>>> From: Rong Wang <wangrong68@huawei.com>
>>>>>>>>>
>>>>>>>>> Once enable iommu domain for one device, the MSI
>>>>>>>>> translation tables have to be there for software-managed MSI.
>>>>>>>>> Otherwise, platform with software-managed MSI without an
>>>>>>>>> irq bypass function, can not get a correct memory write event
>>>>>>>>> from pcie, will not get irqs.
>>>>>>>>> The solution is to obtain the MSI phy base address from
>>>>>>>>> iommu reserved region, and set it to iommu MSI cookie,
>>>>>>>>> then translation tables will be created while request irq.
>>>>>>>> Probably not what anyone wants to hear, but I would prefer we not add
>>>>>>>> more uses of this stuff. It looks like we have to get rid of
>>>>>>>> iommu_get_msi_cookie() :\
>>>>>>>>
>>>>>>>> I'd like it if vdpa could move to iommufd not keep copying stuff from
>>>>>>>> it..
>>>>>>> Absolutely but when is that happening?
>>>>>> Don't know, I think it has to come from the VDPA maintainers, Nicolin
>>>>>> made some drafts but wasn't able to get it beyond that.
>>>>> Cindy (cced) will carry on the work.
>>>>>
>>>>> Thanks
>>>> Hmm didn't see anything yet. Nanyong Sun maybe you can take a look?
>>> Just to clarify, Cindy will work on the iommufd conversion for
>>> vhost-vDPA, the changes are non-trivial and may take time. Before we
>>> are able to achieve that,  I think we still need something like this
>>> patch to make vDPA work on software managed MSI platforms.
>>>
>>> Maybe Nanyong can post a new version that addresses the comment so far?
>>>
>>> Thanks
>> Maybe but an ack from iommu maintainers will be needed anyway. Let's see
>> that version, maybe split the export to a patch by itself to make the
>> need for that ack clear.
> A patch to export that function is alread posted:
>
> https://lore.kernel.org/linux-iommu/BN9PR11MB52760E9705F2985EACCD5C4A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#u
>
> But I do not want VDPA to mis-use it unless it also implements all the
> ownership stuff properly.
>
> Jason
> .
I want to confirm if we need to introduce iommu group logic to vdpa, as 
"all the ownership stuff" ?
