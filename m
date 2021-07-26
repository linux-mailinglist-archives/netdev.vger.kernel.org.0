Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1D3D5E92
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhGZPK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:10:59 -0400
Received: from ale.deltatee.com ([204.191.154.188]:42738 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbhGZPJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=eAmodO/I2oyyLqrI2JH2Q22VXuS5hxurk32hCdMAH8c=; b=VPCbQDUsFSNHjYATqc6JeTyQoq
        R8jTkkKL4BraHobrBiWfjQPegIsCFcr45xSZ+AkiPXZahqEbkLdNk6spdXbBdnsXgfo2PqWpipbmK
        FjLzcdQ93Qb6twJJeyBPh3unD1+rzf8L8cnkeXQYxJ5CCIj7vd+oCUXwvNeqXsTbsilP3UVHnV19u
        x6aKzju4qMDhlbR6vGbH++A0In4OoYIvoCXGHEBmkhhtfFb2WNDd49FAhXAGuBZ143YLA1eBdjJvo
        kwuzNqa7A78uR5nIbXPXELrNvt99OIKDz9F8I2olhs4mKA9Jw/f1AxNMUSfHh7F+ig1Ng9JLPNyq8
        pwIZzgxQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1m82qh-0003lM-R0; Mon, 26 Jul 2021 09:49:01 -0600
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
 <YPqo6M0AKWLupvNU@unreal> <a8a8ffee-67e8-c899-3d04-1e28fb72560a@deltatee.com>
 <YP0HOf7kE1aOkqjV@unreal>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <bc9b7b00-40eb-7d4e-f3b3-1d4174f10be5@deltatee.com>
Date:   Mon, 26 Jul 2021 09:48:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YP0HOf7kE1aOkqjV@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com, leon@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for
 peer-to-peer support
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-25 12:39 a.m., Leon Romanovsky wrote:
> On Fri, Jul 23, 2021 at 10:20:50AM -0600, Logan Gunthorpe wrote:
>>
>>
>>
>> On 2021-07-23 5:32 a.m., Leon Romanovsky wrote:
>>> On Fri, Jul 23, 2021 at 07:06:41PM +0800, Dongdong Liu wrote:
>>>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>>>> sending Requests to other Endpoints (as opposed to host memory), the
>>>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>>>> unless an implementation-specific mechanism determines that the Endpoint
>>>> supports 10-Bit Tag Completer capability. Add "pci=disable_10bit_tag="
>>>> parameter to disable 10-Bit Tag Requester if the peer device does not
>>>> support the 10-Bit Tag Completer. This will make P2P traffic safe.
>>>>
>>>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>>>> ---
>>>>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
>>>>  drivers/pci/pci.c                               | 56 +++++++++++++++++++++++++
>>>>  drivers/pci/pci.h                               |  1 +
>>>>  drivers/pci/pcie/portdrv_pci.c                  | 13 +++---
>>>>  drivers/pci/probe.c                             |  9 ++--
>>>>  5 files changed, 78 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>>> index bdb2200..c2c4585 100644
>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>> @@ -4019,6 +4019,13 @@
>>>>  				bridges without forcing it upstream. Note:
>>>>  				this removes isolation between devices and
>>>>  				may put more devices in an IOMMU group.
>>>> +		disable_10bit_tag=<pci_dev>[; ...]
>>>> +				  Specify one or more PCI devices (in the format
>>>> +				  specified above) separated by semicolons.
>>>> +				  Disable 10-Bit Tag Requester if the peer
>>>> +				  device does not support the 10-Bit Tag
>>>> +				  Completer.This will make P2P traffic safe.
>>>
>>> I can't imagine more awkward user experience than such kernel parameter.
>>>
>>> As a user, I will need to boot the system, hope for the best that system
>>> works, write down all PCI device numbers, guess which one doesn't work
>>> properly, update grub with new command line argument and reboot the
>>> system. Any HW change and this dance should be repeated.
>>
>> There are already two such PCI parameters with this pattern and they are
>> not that awkward. pci_dev may be specified with either vendor/device IDS
>> or with a path of BDFs (which protects against renumbering).
> 
> Unfortunately, in the real world, BDF is not so stable. It changes with
> addition of new hardware, BIOS upgrades and even broken servers.

That's why it supports using a *path* of BDFs which tends not to catch
the wrong device if the topology changes.

> Vendor/device IDs doesn't work if you have multiple devices of same
> vendor in the system.

Yes, but it's fine for some use cases. That's why there's a range of
options.

>>
>> This flag is only useful in P2PDMA traffic, and if the user attempts
>> such a transfer, it prints a warning (see the next patch) with the exact
>> parameter that needs to be added to the command line.
> 
> Dongdong citied PCI spec and it was very clear - don't enable this
> feature unless you clearly know that it is safe to enable. This is
> completely opposite to the proposal here - always enable and disable
> if something is printed to the dmesg.

Quoting from patch 4:

"For platforms where the RC supports 10-Bit Tag Completer capability,
it is highly recommended for platform firmware or operating software
that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
bit automatically in Endpoints with 10-Bit Tag Requester capability.
This enables the important class of 10-Bit Tag capable adapters that
send Memory Read Requests only to host memory."

Notice the last sentence. It's saying that devices who only talk to host
memory should have 10-bit tags enabled. In the kernel we call devices
that talk to things besides host memory "P2PDMA". So the spec is saying
not to enable 10bit tags for devices participating in P2PDMA. The kernel
needs a way to allow users to do that. The kernel parameter only stops
the feature from being enabled for a specific device, and the only
use-case is P2PDMA which is not that common and requires the user to be
aware of their topology. So I really don't think this is that big a problem.

>>
>> This has worked well for disable_acs_redir and was used for
>> resource_alignment before that for quite some time. So save a better
>> suggestion I think this is more than acceptable.
> 
> I don't know about other parameters and their history, but we are not in
> 90s anymore and addition of modules parameters (for the PCI it is kernel
> cmdline arguments) are better to be changed to some configuration tool/sysfs.

The problem was that the ACS bits had to be set before the kernel
enumerated the devices. The IOMMU code simply was not able to support
dynamic adjustments to its groups. I assume changing 10bit tags
dynamically is similarly tricky -- but if it's not then, yes a sysfs
interface in addition to the kernel parameter would be a good idea.

Logan
