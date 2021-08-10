Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E213E59F3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbhHJMb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:31:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17001 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbhHJMbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:31:55 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GkXKN6PHnzb0VN;
        Tue, 10 Aug 2021 20:27:52 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 10 Aug 2021 20:31:31 +0800
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210809173113.GA2166744@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <d113a3f3-6098-314b-32d3-b944daf1186c@huawei.com>
Date:   Tue, 10 Aug 2021 20:31:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210809173113.GA2166744@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/10 1:31, Bjorn Helgaas wrote:
> On Sat, Aug 07, 2021 at 03:11:34PM +0800, Dongdong Liu wrote:
>>
>> On 2021/8/6 2:12, Bjorn Helgaas wrote:
>>> On Wed, Aug 04, 2021 at 09:47:08PM +0800, Dongdong Liu wrote:
>>>> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
>>>> 10-Bit Tag Requester doesn't interact with a device that does not
>>>> support 10-BIT Tag Completer. Before that happens, the kernel should
>>>> emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
>>>> disable 10-BIT Tag Requester for PF device.
>>>> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
>>>> 10-BIT Tag Requester for VF device.
>>>
>>> s/10-BIT/10-Bit/ several times.
>> Will fix.
>>>
>>> Add blank lines between paragraphs.
>> Will fix.
>>>
>>>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>>>> ---
>>>>  drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 40 insertions(+)
>>>>
>>>> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
>>>> index 50cdde3..948f2be 100644
>>>> --- a/drivers/pci/p2pdma.c
>>>> +++ b/drivers/pci/p2pdma.c
>>>> @@ -19,6 +19,7 @@
>>>>  #include <linux/random.h>
>>>>  #include <linux/seq_buf.h>
>>>>  #include <linux/xarray.h>
>>>> +#include "pci.h"
>>>>
>>>>  enum pci_p2pdma_map_type {
>>>>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
>>>> @@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
>>>>  		(client->bus->number << 8) | client->devfn;
>>>>  }
>>>>
>>>> +static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,
>>>
>>> s/vaild/valid/
>>>
>>> Or maybe s/valid/safe/ or s/valid/supported/, since "valid" isn't
>>> quite the right word here.  We want to know whether the source is
>>> enabled to generate 10-bit tags, and if so, whether the destination
>>> can handle them.
>>>
>>> "if (check_10bit_tags_valid())" does not make sense because
>>> "check_10bit_tags_valid()" is not a question with a yes/no answer.
>>>
>>> "10bit_tags_valid()" *might* be, because "if (10bit_tags_valid())"
>>> makes sense.  But I don't think you can start with a digit.
>>>
>>> Or maybe you want to invert the sense, e.g.,
>>> "10bit_tags_unsupported()", since that avoids negation at the caller:
>>>
>>>   if (10bit_tags_unsupported(a, b) ||
>>>       10bit_tags_unsupported(b, a))
>>>         map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>> Good suggestion. add a pci_ prefix.
>>
>> if (pci_10bit_tags_unsupported(a, b) ||
>>     pci_10bit_tags_unsupported(b, a))
>> 	map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>
> This treats both directions as equally important.  I don't know P2PDMA
> very well, but that doesn't seem like it would necessarily be the
> case.  I would think a common case would be device A doing DMA to B,
> but B *not* doing DMA to A.  So can you tell which direction you're
> setting up here, and can you take advantage of any asymmetry, e.g., by
> enabling 10-bit tags in the direction that supports it even if the
> other direction does not?

Documentation/driver-api/pci/p2pdma.rst
* Provider - A driver which provides or publishes P2P resources like
   memory or doorbell registers to other drivers.
* Client - A driver which makes use of a resource by setting up a
   DMA transaction to or from it.

So we may just check as below.
if (10bit_tags_unsupported(client, provider, verbose)
	map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;

@Logan What's your opinion?

Thanks,
Dongdong
> .
>
