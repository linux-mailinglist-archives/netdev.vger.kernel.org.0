Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF8C422283
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhJEJmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:42:12 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:45527 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232658AbhJEJmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 05:42:11 -0400
Received: from [192.168.0.2] (ip5f5ae91d.dynamic.kabel-deutschland.de [95.90.233.29])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A902861EA1903;
        Tue,  5 Oct 2021 11:40:20 +0200 (CEST)
Subject: Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM
 Checksum Is Not Valid") [8086:1521]
To:     Sasha Neftin <sasha.neftin@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Hisashi T Fujinaka <htodd@twofifty.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        "Andreas K. Huettel" <andreas.huettel@ur.de>
References: <1823864.tdWV9SEqCh@kailua>
 <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
 <4111f2b7-cbac-3451-593f-a154aca65263@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <b56c4c30-d393-96fb-182c-726a60a39eed@molgen.mpg.de>
Date:   Tue, 5 Oct 2021 11:40:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4111f2b7-cbac-3451-593f-a154aca65263@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sasha,


Am 05.10.21 um 08:50 schrieb Sasha Neftin:
> On 10/5/2021 02:39, Hisashi T Fujinaka wrote:
>> On Mon, 4 Oct 2021, Jakub Kicinski wrote:
>>
>>> On Mon, 04 Oct 2021 15:06:31 +0200 Andreas K. Huettel wrote:
>>>> Dear all,
>>>>
>>>> I hope this is the right place to ask, if not please advise me where 
>>>> to go.
>>>
>>> Adding intel-wired-lan@lists.osuosl.org and Sasha as well.
>>>
>>>> I have a new Dell machine with both an Intel on-board ethernet 
>>>> controller
>>>> ([8086:15f9]) and an additional 2-port extension card ([8086:1521]).
>>>>
>>>> The second adaptor, a "DeLock PCIe 2xGBit", worked fine as far as I 
>>>> could
>>>> see with Linux 5.10.59, but fails to initialize with Linux 5.14.9.
>>>>
>>>> dilfridge ~ # lspci -nn
>>>> [...]
>>>> 01:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
>>>> 01:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
>>>> [...]
>>>>
>>>> dilfridge ~ # dmesg|grep igb
>>>> [    2.069286] igb: Intel(R) Gigabit Ethernet Network Driver
>>>> [    2.069288] igb: Copyright (c) 2007-2014 Intel Corporation.
>>>> [    2.069305] igb 0000:01:00.0: can't change power state from D3cold to D0 (config space inaccessible)
>>>> [    2.069624] igb 0000:01:00.0 0000:01:00.0 (uninitialized): PCIe link lost
>>>> [    2.386659] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER session.
>>>> [    4.115500] igb 0000:01:00.0: The NVM Checksum Is Not Valid
>>>> [    4.133807] igb: probe of 0000:01:00.0 failed with error -5
>>>> [    4.133820] igb 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
>>>> [    4.134072] igb 0000:01:00.1 0000:01:00.1 (uninitialized): PCIe link lost
>>>> [    4.451602] igb 0000:01:00.1: PHY reset is blocked due to SOL/IDER session.
>>>> [    6.180123] igb 0000:01:00.1: The NVM Checksum Is Not Valid
>>>> [    6.188631] igb: probe of 0000:01:00.1 failed with error -5
>>>>
>>>> Any advice on how to proceed? Willing to test patches and provide 
>>>> additional debug info.
>>
>> Sorry to reply from a non-Intel account. I would suggest first
>> contacting Dell, and then contacting DeLock. This sounds like an issue
>> with motherboard firmware and most of what I can help with would be with
>> the driver. I think the issues are probably before things get to the
>> driver.
>>
> Agree. The driver starts work when the PCIe link in L0. Please, check 
> with Dell/DeLock what is PCIe link status and enumeration process 
> finished as properly.(probably you will need PCIe sniffer)

Of course, it’d be great to fix potential firmware bugs, but to suggest 
to a consumer to work with Dell to fix the problem is unfortunately not 
a realistic solution if Andreas does not own thousands of the 
problematic system.

Linux has a no-regression policy, meaning when userspace/hardware with 
an older Linux kernel worked than it *has to* work with a new version 
too. So besides fixing the firmware/system, it’s as important to find 
the commit introducing the regression and fix it.


Kind regards,

Paul
