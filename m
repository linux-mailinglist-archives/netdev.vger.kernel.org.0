Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C133443FD4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCKIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:08:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30911 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhKCKIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:08:12 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hkj2V1QRRzcb3Q;
        Wed,  3 Nov 2021 18:00:50 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Wed, 3 Nov 2021 18:05:34 +0800
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211101223314.GA557567@bhelgaas>
CC:     <hch@infradead.org>, <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>, <linux-media@vger.kernel.org>,
        <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <26f8758e-c85d-291b-1c34-5184aa6862aa@huawei.com>
Date:   Wed, 3 Nov 2021 18:05:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211101223314.GA557567@bhelgaas>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/2 6:33, Bjorn Helgaas wrote:
> On Mon, Nov 01, 2021 at 05:02:41PM -0500, Bjorn Helgaas wrote:
>> On Sat, Oct 30, 2021 at 09:53:47PM +0800, Dongdong Liu wrote:
>>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>>> field size from 8 bits to 10 bits.
>>>
>>> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
>>> 10-Bit Tag Capabilities" Implementation Note:
>>>
>>>   For platforms where the RC supports 10-Bit Tag Completer capability,
>>>   it is highly recommended for platform firmware or operating software
>>>   that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>>   bit automatically in Endpoints with 10-Bit Tag Requester capability.
>>>   This enables the important class of 10-Bit Tag capable adapters that
>>>   send Memory Read Requests only to host memory.
>>>
>>> It's safe to enable 10-bit tags for all devices below a Root Port that
>>> supports them. Switches that lack 10-Bit Tag Completer capability are
>>> still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
>>> since the two new Tag bits are in TLP Header bits that were formerly
>>> Reserved.
>>
>> Side note: the reason we want to do this to increase performance by
>> allowing more outstanding requests.  Do you have any benchmarking that
>> we can mention here to show that this is actually a benefit?  I don't
>> doubt that it is, but I assume you've measured it and it would be nice
>> to advertise it.
>
> Hmmm.  I did a quick Google search looking for "nvme pcie 10-bit tags"
> hoping to find some performance info, but what I *actually* found was
> several reports of 10-bit tags causing breakage:
>
>   https://www.reddit.com/r/MSI_Gaming/comments/exjvzg/x570_apro_7c37vh72beta_version_has_anyone_tryed_it/
>   https://rog.asus.com/forum/showthread.php?115064-Beware-of-agesa-1-0-0-4B-bios-not-good!/page2
>   https://forum-en.msi.com/index.php?threads/sound-blaster-z-has-weird-behaviour-after-updating-bios-x570-gaming-edge-wifi.325223/page-2
>   https://gearspace.com/board/electronic-music-instruments-and-electronic-music-production/1317189-h8000fw-firewire-facts-2020-must-read.html
>   https://www.soundonsound.com/forum/viewtopic.php?t=69651&start=12
>   https://forum.rme-audio.de/viewtopic.php?id=30307
>
> This is a big problem for me.
>
> Some of these might be a broken BIOS that turns on 10-bit tags when
> the completer doesn't support them.  I didn't try to debug them to
> that level.  But the last thing I want is to enable 10-bit by default
> and cause boot issues or sound card issues or whatever.
It seems a BIOS software bug, as it turned on(as default) a 10-Bit Tag
Field for RP, but the card(non-Gen4 card) does not support 10-Bit Completer.

This patch we enable 10-Bit Tag Requester for EP when RC supports
10-Bit Tag Completer capability. So it shuld be worked ok.

The below is one of the link. other links seems the same issue.
https://forum.rme-audio.de/viewtopic.php?id=30307
"Re: AMD Ryzen X570 chipset problems
So for those running into similar problems I found out that in most
recent BIOS AMD turned on(as default) a 10-bit Tag Field, which is only
available on PCI-e Gen4 devices. So your BIOS get stuck on startup if
inserted a non-Gen4 card like my firewire card.

So you need to find that feature in your BIOS and turn it off and set
the PCI compatibility on Gen3 for the slot your card is in.

Hope this helps others running in to similar troubles."
>
> I'm pretty sure this is a show-stopper for wedging this into v5.16 at
> this late date.  It's conceivable we could still do it if everything
> defaulted to "off" and we had a knob whereby users could turn it on
> via boot param or sysfs.
Maybe we can merge this patchset later into v5.17.

But I still think default to "on" will be better,
Current we enable 10-Bit Tag, in the future PCIe 6.0 maybe need to use
14-Bit tags to get good performance.
>
> In any case, we (by which I'm afraid I mean "you" :)) need to
> investigate the problem reports, figure out whether we will see
> similar problems, and fix them before merging if we can.
We have tested a PCIe 5.0 network card on FPGA with 10-Bit tag worked
ok. I have not got the performance data as FPGA is slow.

Current we enable 10-Bit Tag Requester for EP when RC supports
10-Bit Tag Completer capability. It shoud be worked ok except hardware
bugs, we also provide boot param to diasble 10-Bit Tag if the hardware
really have a bug or can do some quirks as 8-bit tag has done if we
have known the hardware.

Thanks,
Dongdong.
>
> Thanks to Krzysztof for pointing out the potential for issues like
> this.
>
> Bjorn
> .
>
