Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBC7465E6C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345361AbhLBG4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhLBG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 01:56:20 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228A7C061574;
        Wed,  1 Dec 2021 22:52:58 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1msfxf-0000Ty-51; Thu, 02 Dec 2021 07:52:55 +0100
Message-ID: <68f2163e-63a2-c6dd-1491-fd748a92ac36@leemhuis.info>
Date:   Thu, 2 Dec 2021 07:52:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-BS
To:     Moshe Shemesh <moshe@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Amir Tzin <amirtz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>, regressions@lists.linux.dev,
        linux-s390 <linux-s390@vger.kernel.org>
References: <15db9c1d11d32fb16269afceb527b5d743177ac4.camel@linux.ibm.com>
 <129f5e00-db76-3230-75a5-243e8cd5beb0@nvidia.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Regression in v5.16-rc1: Timeout in mlx5_health_wait_pci_up() may
 try to wait 245 million years
In-Reply-To: <129f5e00-db76-3230-75a5-243e8cd5beb0@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1638427978;9cde409c;
X-HE-SMSGID: 1msfxf-0000Ty-51
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 20.11.21 17:38, Moshe Shemesh wrote:
> Thank you for reporting Niklas.
> 
> This is actually a case of use after free, as following that patch the
> recovery flow goes through mlx5_tout_cleanup() while timeouts structure
> is still needed in this flow.
> 
> We know the root cause and will send a fix.

That was twelve days ago, thus allow me asking: has any progress been
made? I could not find any with a quick search on lore.

Ciao, Thorsten

> On 11/19/2021 12:58 PM, Niklas Schnelle wrote:
>> Hello Amir, Moshe, and Saeed,
>>
>> (resent due to wrong netdev mailing list address, sorry about that)
>>
>> During testing of PCI device recovery, I found a problem in the mlx5
>> recovery support introduced in v5.16-rc1 by commit 32def4120e48
>> ("net/mlx5: Read timeout values from DTOR"). It follows my analysis of
>> the problem.
>>
>> When the device is in an error state, at least on s390 but I believe
>> also on other systems, it is isolated and all PCI MMIO reads return
>> 0xff. This is detected by your driver and it will immediately attempt
>> to recovery the device with a mlx5_core driver specific recovery
>> mechanism. Since at this point no reset has been done that would take
>> the device out of isolation this will of course fail as it can't
>> communicate with the device. Under normal circumstances this reset
>> would happen later during the new recovery flow introduced in
>> 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery") once
>> firmware has done their side of the recovery allowing that to succeed
>> once the driver specific recovery has failed.
>>
>> With v5.16-rc1 however the driver specific recovery gets stuck holding
>> locks which will block our recovery. Without our recovery mechanism
>> this can also be seen by "echo 1 > /sys/bus/pci/devices/<dev>/remove"
>> which hangs on the device lock forever.
>>
>> Digging into this I tracked the problem down to
>> mlx5_health_wait_pci_up() hangig. I added a debug print to it and it
>> turns out that with the device isolated mlx5_tout_ms(dev, FW_RESET)
>> returns 774039849367420401 (0x6B...6B) milliseconds and we try to wait
>> 245 million years. After reverting that commit things work again,
>> though of course the driver specific recovery flow will still fail
>> before ours can kick in and finally succeed.
>>
>> Thanks,
>> Niklas Schnelle
>>
>> #regzbot introduced: 32def4120e48
>>
> 
> 

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave they thus might sent someone reading this down the
wrong rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

#regzbot poke
