Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80253CC23F
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 11:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhGQJoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 05:44:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11438 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhGQJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 05:44:44 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GRjhx0pGzzcbFd;
        Sat, 17 Jul 2021 17:38:25 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 17 Jul 2021 17:41:44 +0800
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
To:     Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <20210715172336.GA1972959@bjorn-Precision-5520>
 <db506d81-3cb9-4cdc-fb4a-f2d28587b9b2@huawei.com>
 <dcad182a-fafc-39ad-b1f2-8ed86f3634d9@deltatee.com>
CC:     <hch@infradead.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <97fd40fb-433a-930d-878c-0700268037ca@huawei.com>
Date:   Sat, 17 Jul 2021 17:41:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <dcad182a-fafc-39ad-b1f2-8ed86f3634d9@deltatee.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/16 23:51, Logan Gunthorpe wrote:
>
>
> On 2021-07-16 5:12 a.m., Dongdong Liu wrote:
>> Hi Bjorn
>>
>> Many thanks for your review.
>>
>> On 2021/7/16 1:23, Bjorn Helgaas wrote:
>>> [+cc Logan]
>>>
>>> On Mon, Jun 21, 2021 at 06:27:20PM +0800, Dongdong Liu wrote:
>>>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>>>> field size from 8 bits to 10 bits.
>>>>
>>>> For platforms where the RC supports 10-Bit Tag Completer capability,
>>>> it is highly recommended for platform firmware or operating software
>>>
>>> Recommended by whom?  If the spec recommends it, we should provide the
>>> citation.
>> PCIe spec 5.0 r1.0 section 2.2.6.2 IMPLEMENTATION NOTE says that.
>> Will fix.
>>>
>>>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>>>> enables the important class of 10-Bit Tag capable adapters that send
>>>> Memory Read Requests only to host memory.
>>>
>>> What is the implication for P2PDMA?  What happens if we enable 10-bit
>>> tags for device A, and A generates Mem Read Requests to device B,
>>> which does not support 10-bit tags?
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says
>> If an Endpoint supports sending Requests to other Endpoints (as opposed
>> to host memory), the Endpoint must not send 10-Bit Tag Requests to
>> another given Endpoint unless an implementation-specific mechanism
>> determines that the Endpoint supports 10-Bit Tag Completer capability.
>> Not sending 10-Bit Tag Requests to other Endpoints at all
>> may be acceptable for some implementations. More sophisticated
>> mechanisms are outside the scope of this specification.
>>
>> Not sending 10-Bit Tag Requests to other Endpoints at all seems simple.
>> Add kernel parameter pci=pcie_bus_peer2peer when boot kernel with
>> P2PDMA, then do not config 10-BIT Tag.
>>
>> if (pcie_bus_config != PCIE_BUS_PEER2PEER)
>> 	pci_configure_10bit_tags(dev);
>>
>> Bjorn and Logan, any suggestion?
>
> I think we need a check in the P2PDMA code to ensure that a device with
> 10bit tags doesn't interact with a device that has no 10bit tags. Before
> that happens, the kernel should emit a warning saying to enable a
> specific kernel parameter.
Seems reasonable.
>
> Though a parameter with a bit more granularity might be appropriate. See
> what was done for disable_acs_redir where it affects only the devices
> specified in the list.

Many Thanks for your suggestion. I will investigate more about this.

It seems P2PDMA also does not consider MPS safe issue if not use 
"pci=pcie_bus_peer2peer".

Thanks,
Dongdong
>
> Thanks,
>
> Logan
> .
>
