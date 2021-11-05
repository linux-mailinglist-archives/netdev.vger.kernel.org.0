Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1526A446095
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhKEI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:27:10 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:27178 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhKEI1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 04:27:10 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HltmY4Mtjz8v8y;
        Fri,  5 Nov 2021 16:22:53 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 5 Nov 2021 16:24:24 +0800
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211103160255.GA687132@bhelgaas>
CC:     <hch@infradead.org>, <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>, <linux-media@vger.kernel.org>,
        <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <894a1e8f-cc08-2710-9f56-9dda14e2e617@huawei.com>
Date:   Fri, 5 Nov 2021 16:24:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211103160255.GA687132@bhelgaas>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/4 0:02, Bjorn Helgaas wrote:
> On Wed, Nov 03, 2021 at 06:05:34PM +0800, Dongdong Liu wrote:
>> On 2021/11/2 6:33, Bjorn Helgaas wrote:
>>> On Mon, Nov 01, 2021 at 05:02:41PM -0500, Bjorn Helgaas wrote:
>>>> On Sat, Oct 30, 2021 at 09:53:47PM +0800, Dongdong Liu wrote:
>>>>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>>>>> field size from 8 bits to 10 bits.
>>>>>
>>>>> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
>>>>> 10-Bit Tag Capabilities" Implementation Note:
>>>>>
>>>>>   For platforms where the RC supports 10-Bit Tag Completer capability,
>>>>>   it is highly recommended for platform firmware or operating software
>>>>>   that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>>>>   bit automatically in Endpoints with 10-Bit Tag Requester capability.
>>>>>   This enables the important class of 10-Bit Tag capable adapters that
>>>>>   send Memory Read Requests only to host memory.
>>>>>
>>>>> It's safe to enable 10-bit tags for all devices below a Root Port that
>>>>> supports them. Switches that lack 10-Bit Tag Completer capability are
>>>>> still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
>>>>> since the two new Tag bits are in TLP Header bits that were formerly
>>>>> Reserved.
>>>>
>>>> Side note: the reason we want to do this to increase performance by
>>>> allowing more outstanding requests.  Do you have any benchmarking that
>>>> we can mention here to show that this is actually a benefit?  I don't
>>>> doubt that it is, but I assume you've measured it and it would be nice
>>>> to advertise it.
>>>
>>> Hmmm.  I did a quick Google search looking for "nvme pcie 10-bit tags"
>>> hoping to find some performance info, but what I *actually* found was
>>> several reports of 10-bit tags causing breakage:
>>>
>>>   https://www.reddit.com/r/MSI_Gaming/comments/exjvzg/x570_apro_7c37vh72beta_version_has_anyone_tryed_it/
>>>   https://rog.asus.com/forum/showthread.php?115064-Beware-of-agesa-1-0-0-4B-bios-not-good!/page2
>>>   https://forum-en.msi.com/index.php?threads/sound-blaster-z-has-weird-behaviour-after-updating-bios-x570-gaming-edge-wifi.325223/page-2
>>>   https://gearspace.com/board/electronic-music-instruments-and-electronic-music-production/1317189-h8000fw-firewire-facts-2020-must-read.html
>>>   https://www.soundonsound.com/forum/viewtopic.php?t=69651&start=12
>>>   https://forum.rme-audio.de/viewtopic.php?id=30307
>>>
>>> This is a big problem for me.
>>>
>>> Some of these might be a broken BIOS that turns on 10-bit tags
>>> when the completer doesn't support them.  I didn't try to debug
>>> them to that level.  But the last thing I want is to enable 10-bit
>>> by default and cause boot issues or sound card issues or whatever.
>>
>> It seems a BIOS software bug, as it turned on (as default) a 10-Bit
>> Tag Field for RP, but the card (non-Gen4 card) does not support
>> 10-Bit Completer.
>
> It doesn't matter *where* the problem is.  If we change Linux to
> *expose* a BIOS bug, that's just as much of a problem as if the bug
> were in Linux.  Users are not equipped to diagnose or fix problems
> like that.
>
>> This patch we enable 10-Bit Tag Requester for EP when RC supports
>> 10-Bit Tag Completer capability. So it shuld be worked ok.
>
> That's true as long as the RC supports 10-bit tags correctly when it
> advertises support for them.  It "should" work :)
>
> But it does remind me that if the RC doesn't support 10-bit tags, but
> we use sysfs to enable 10-bit tags for a reqester that intends to use
> P2PDMA to a peer that *does* support them, I don't think there's
> any check in the DMA API that prevents the driver from setting up DMA
> to the RC in addition to the peer.
Current we use sysfs to enable/disable 10-bit tags for a requester also
depend on the RP support 10-bit tag completer, so it will be ok.
>
>> But I still think default to "on" will be better,
>> Current we enable 10-Bit Tag, in the future PCIe 6.0 maybe need to use
>> 14-Bit tags to get good performance.
>
> Maybe we can default to "on" based on BIOS date or something.  Older
> systems that want the benefit can use the param to enable it, and if
> there's a problem, the cause will be obvious ("we booted with
> 'pci=tag-bits=10' and things broke").
>
> If we enable 10-bit tags by default on systems from 2022 or newer, we
> shouldn't break any existing systems, and we have a chance to discover
> any problems and add quirk if necessary.
>
>>> In any case, we (by which I'm afraid I mean "you" :)) need to
>>> investigate the problem reports, figure out whether we will see
>>> similar problems, and fix them before merging if we can.
>>
>> We have tested a PCIe 5.0 network card on FPGA with 10-Bit tag worked
>> ok. I have not got the performance data as FPGA is slow.
>
> 10-bit tag support appeared in the spec four years ago (PCIe r4.0, in
> September, 2017).  Surely there is production hardware that supports
> this and could demonstrate a benefit from this.
I found the below introduction about "Number of tags needed to achieve
maximum throughput for PCIe 4.0 and PCIe 5.0 links"
https://www.synopsys.com/designware-ip/technical-bulletin/accelerating-32gtps-pcie5-designs.html

It seems pretty clear.
>
> We need a commit log that says "enabling 10-bit tags allows more
> outstanding transactions, which improves performance of adapters like
> X by Y% on these workloads," not a log that says "we think enabling
> 10-bit tags is safe, but users with non-compliant hardware may see new
> PCIe errors or even non-bootable systems, and they should use boot
> param X to work around this."
Looks good, will fix the commit log.
I investigate some PCIe 4.0 cards such as mlx cx5(PCIe 4.0 16GT/s
x16), a NVME SSD(PCIe 4.0 16GT/s X4), but these cards only support
10-bit tag completer not support 10-bit tag requester. Maybe
these cards use 8-bit tag can achieve its performance specs.
>
>> Current we enable 10-Bit Tag Requester for EP when RC supports
>> 10-Bit Tag Completer capability. It should be worked ok except
>> hardware bugs, we also provide boot param to disable 10-Bit Tag if
>> the hardware really have a bug or can do some quirks as 8-bit tag
>> has done if we have known the hardware.
>
> The problem is that turning it on by default means systems with
> hardware defects *used* to work but now they mysteriously *stop*
> working.  Yes, a boot param can work around that, but it's just
> not an acceptable user experience.  Maybe there are no such defects.
> I dunno.
Ok, current defaulted to "off" and use boot param and sysfs to turn on
maybe a safe choice.

Thanks,
Dongdong
>
> Bjorn
> .
>
