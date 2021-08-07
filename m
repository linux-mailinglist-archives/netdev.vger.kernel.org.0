Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233B43E33B9
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhHGGTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 02:19:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13242 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhHGGTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 02:19:30 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GhXH86wjQz1CSMK;
        Sat,  7 Aug 2021 14:19:00 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 14:19:10 +0800
Subject: Re: [PATCH V7 4/9] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210805195407.GA1763784@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <c7fdb77d-8b93-f3ef-05d2-54daf67305e2@huawei.com>
Date:   Sat, 7 Aug 2021 14:19:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210805195407.GA1763784@bjorn-Precision-5520>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/6 3:54, Bjorn Helgaas wrote:
> On Thu, Aug 05, 2021 at 03:47:31PM +0800, Dongdong Liu wrote:
>> Hi Bjorn
>>
>> Many thanks for your review.
>> On 2021/8/5 7:17, Bjorn Helgaas wrote:
>>> On Wed, Aug 04, 2021 at 09:47:03PM +0800, Dongdong Liu wrote:
>>>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>>>> field size from 8 bits to 10 bits.
>>>>
>>>> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
>>>> 10-Bit Tag Capabilities" Implementation Note.
>>>> For platforms where the RC supports 10-Bit Tag Completer capability,
>>>> it is highly recommended for platform firmware or operating software
>>>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>>>> enables the important class of 10-Bit Tag capable adapters that send
>>>> Memory Read Requests only to host memory.
>>>
>>> Quoted material should be set off with a blank line before it and
>>> indented by two spaces so it's clear exactly what comes from the spec
>>> and what you've added.  For example, see
>>> https://git.kernel.org/linus/ec411e02b7a2
>> Good point, will fix.
>>>
>>> We need to say why we assume it's safe to enable 10-bit tags for all
>>> devices below a Root Port that supports them.  I think this has to do
>>> with switches being required to forward 10-bit tags correctly even if
>>> they were designed before 10-bit tags were added to the spec.
>>
>> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
>> 10-Bit Tag Capabilities" Implementation Note:
>>
>>   Switches that lack 10-Bit Tag Completer capability are still able to
>>   forward NPRs and Completions carrying 10-Bit Tags correctly, since the
>>   two new Tag bits are in TLP Header bits that were formerly Reserved,
>>   and Switches are required to forward Reserved TLP Header bits without
>>   modification. However, if such a Switch detects an error with an NPR
>>   carrying a 10-Bit Tag, and that Switch handles the error by acting as
>>   the Completer for the NPR, the resulting Completion will have an
>>   invalid 10-Bit Tag. Thus, it is strongly recommended that Switches
>>   between any components using 10-Bit Tags support 10-Bit Tag Completer
>>   capability.  Note that Switches supporting 16.0 GT/s data rates or
>>   greater must support 10-Bit Tag Completer capability.
>>
>> This patch also consider to enable 10-Bit Tag for EP device need RP
>> and Switch device support 10-Bit Tag Completer capability.
>>>
>>> And it should call out any cases where it is *not* safe, e.g., if P2P
>>> traffic is an issue.
>> Yes, indeed.
>>>
>>> If there are cases where we don't want to enable 10-bit tags, whether
>>> it's to enable P2P traffic or merely to work around device defects,
>>> that ability needs to be here from the beginning.  If somebody needs
>>> to bisect with 10-bit tags disabled, we don't want a bisection hole
>>> between this commit and the commit that adds the control.
>> We provide sysfs file to disable 10-bit tag for P2P traffic when needed.
>> The details see PATCH 7/8/9.
>
> A mechanism for avoiding problems needs to be present from the very
> beginning so there's no bisection hole.  It should not be added by a
> future patch.
Yes, will adjust PATCH 7/8/9 before PATCH 4。
>
> The sysfs file is a start, but if we run into an issue, it could mean
> that we can't boot and run long enough to use sysfs to disable 10-bit
> tags.  So I think we might need a kernel parameter that disables it
> (and possibly other things like MPS optimization).

Yes, We can add a pcie_tag_p2p kernel parameter just to use the 8-bit
tags, not to enable 10-bit tags for all PCIe devices.

Thanks,
Dongdong

