Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9158643F7BD
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhJ2HT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:19:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14877 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhJ2HT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:19:27 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HgYdX1TM2z90Wg;
        Fri, 29 Oct 2021 15:16:48 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 29 Oct 2021 15:16:52 +0800
Subject: Re: [PATCH V10 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211028172423.GA279833@bhelgaas>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <4761096c-4445-8928-5faa-2674272cd088@huawei.com>
Date:   Fri, 29 Oct 2021 15:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211028172423.GA279833@bhelgaas>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/29 1:24, Bjorn Helgaas wrote:
> On Thu, Oct 28, 2021 at 03:44:49PM +0800, Dongdong Liu wrote:
>> On 2021/10/28 6:28, Bjorn Helgaas wrote:
>>> On Sat, Oct 09, 2021 at 06:49:34PM +0800, Dongdong Liu wrote:
>>>> PCIe spec 5.0 r1.0 section 2.2.6.2 says:
>>>>
>>>>   If an Endpoint supports sending Requests to other Endpoints (as
>>>>   opposed to host memory), the Endpoint must not send 10-Bit Tag
>>>>   Requests to another given Endpoint unless an implementation-specific
>>>>   mechanism determines that the Endpoint supports 10-Bit Tag Completer
>>>>   capability.
>>>>
>>>> Add a 10bit_tag sysfs file, write 0 to disable 10-Bit Tag Requester
>>>> when the driver does not bind the device. The typical use case is for
>>>> p2pdma when the peer device does not support 10-Bit Tag Completer.
>>>> Write 1 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
>>>> Completer capability. The typical use case is for host memory targeted
>>>> by DMA Requests. The 10bit_tag file content indicate current status of
>>>> 10-Bit Tag Requester Enable.
>>>
>>> Don't we have a hole here?  We're adding knobs to control 10-Bit Tag
>>> usage, but don't we have basically the same issues with Extended
>>> (8-bit) Tags?
>>
>> All PCIe completers are required to support 8-bit tags
>> from the "[PATCH] PCI: enable extended tags support for PCIe endpoints"
>> (https://patchwork.kernel.org/project/linux-arm-msm/patch/1474769434-5756-1-git-send-email-okaya@codeaurora.org/).
>>
>> I ask hardware colleagues, also says all PCIe devices should support
>> 8-bit tags completer default, so seems no need to do this for 8-bit tags.
>
> Oh, right, I forgot that, thanks for the reminder!  Let's add a
> comment in pci_configure_extended_tags() to that effect so I'll
> remember next time.
Ok, Will do.
>
> I think the appropriate reference is PCIe r5.0, sec 2.2.6.2, which
> says "Receivers/Completers must handle 8-bit Tag values correctly
> regardless of the setting of their Extended Tag Field Enable bit (see
> Section 7.5.3.4)."
>
> The Tag field was 8 bits all the way from PCIe r1.0, but until r2.1 it
> said that by default, only the lower 5 bits are used.
>
> The text about all Completers explicitly being required to support
> 8-bit Tags wasn't added until PCIe r3.0, which might explain some
> confusion and the presence of the Extended Tag Field Enable bit.
>
Thanks for the clarification.
> At the same time, can you fold pci_configure_10bit_tags() directly
> into pci_configure_extended_tags()?  It's pretty small and I think it
> will be easier if it's all in one place.
OK, will do.
>
>>> I wonder if we should be adding a more general "tags" file that can
>>> manage both 8-bit and 10-bit tag usage.
>
> I'm still thinking that maybe a generic name (without "10") would be
> better, even though we don't need it to manage 8-bit tags.  It's
> conceivable that there could be even more tag bits in the future, and
> it would be nice if we didn't have to add yet another file.
Looks good, will do.

Thanks,
Dongdong.
>
> Bjorn
> .
>
