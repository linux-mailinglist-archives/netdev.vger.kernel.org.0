Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3693CC211
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 10:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhGQIxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 04:53:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11437 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhGQIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 04:53:39 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GRhYz48GGzcdyy;
        Sat, 17 Jul 2021 16:47:19 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 17 Jul 2021 16:50:38 +0800
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210716141712.GA2096096@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>, <okaya@kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <0f223592-16ff-626b-94ef-3e89a51d1971@huawei.com>
Date:   Sat, 17 Jul 2021 16:50:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210716141712.GA2096096@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Sinan]

On 2021/7/16 22:17, Bjorn Helgaas wrote:
> On Fri, Jul 16, 2021 at 07:12:16PM +0800, Dongdong Liu wrote:
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
>>
>> PCIe spec 5.0 r1.0 section 2.2.6.2 IMPLEMENTATION NOTE says that.
>> Will fix.
>
> Thanks, that will be helpful.
>
>>>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>>>> enables the important class of 10-Bit Tag capable adapters that send
>>>> Memory Read Requests only to host memory.
>>>
>>> What is the implication for P2PDMA?  What happens if we enable 10-bit
>>> tags for device A, and A generates Mem Read Requests to device B,
>>> which does not support 10-bit tags?
>>
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says
>> If an Endpoint supports sending Requests to other Endpoints (as opposed to
>> host memory), the Endpoint must not send 10-Bit Tag Requests to another
>> given Endpoint unless an implementation-specific mechanism determines that
>> the Endpoint supports 10-Bit Tag Completer capability. Not sending 10-Bit
>> Tag Requests to other Endpoints at all
>> may be acceptable for some implementations. More sophisticated mechanisms
>> are outside the scope of this specification.
>>
>> Not sending 10-Bit Tag Requests to other Endpoints at all seems simple.
>> Add kernel parameter pci=pcie_bus_peer2peer when boot kernel with P2PDMA,
>> then do not config 10-BIT Tag.
>>
>> if (pcie_bus_config != PCIE_BUS_PEER2PEER)
>> 	pci_configure_10bit_tags(dev);
>
> Seems like a reasonable start.  I wish this were more dynamic and we
> didn't have to rely on a kernel parameter to make P2PDMA safe, but
> that seems to be the current situation.
>
> Does the same consideration apply to enabling Extended Tags (8-bit
> tags)?  I would guess so, but sec 2.2.6.2 says "Receivers/Completers
> must handle 8-bit Tag values correctly regardless of the setting of
> their Extended Tag Field Enable bit" so there's some subtlety there
> with regard to what "Extended Tag Field Supported" means.
>
> I don't know why the "Extended Tag Field Supported" bit exists if all
> receivers are required to support 8-bit tags.

The comment in the [PATCH] PCI: enable extended tags support for PCIe 
endpoints 
(https://patchwork.kernel.org/project/linux-arm-msm/patch/1474769434-5756-1-git-send-email-okaya@codeaurora.org/)
says "All PCIe completers are required to support 8 bit tags.
Generation of 8 bit tags is optional. That's why, there is a supported 
and an enable/disable bit."

So the completers can handle 8-bit Tag values correctly also regardless 
of "Extended Tag Field Supported" ?  seems not very clearly, but current 
code implement follow this.

>
> If we need a similar change to pci_configure_extended_tags() to check
> pcie_bus_config, that should be a separate patch because it would be a
> bug fix independent of 10-bit tag support.
>
Seems no need if All PCIe completers are required to support 8 bit tags.

Thanks,
Dongdong
> Bjorn
> .
>
