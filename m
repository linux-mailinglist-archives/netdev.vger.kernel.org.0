Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA842AAFB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJLRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:44:39 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46965 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232602AbhJLRoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 13:44:37 -0400
Received: from [192.168.0.2] (ip5f5aef4c.dynamic.kabel-deutschland.de [95.90.239.76])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C1DE061E5FE33;
        Tue, 12 Oct 2021 19:42:30 +0200 (CEST)
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kubakici@wp.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
References: <1823864.tdWV9SEqCh@kailua> <2944777.ktpJ11cQ8Q@pinacolada>
 <c75203e9-0ef4-20bd-87a5-ad0846863886@intel.com> <2801801.e9J7NaK4W3@kailua>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <6faf4b92-78d5-47a4-63df-cc2bab7769d0@molgen.mpg.de>
Date:   Tue, 12 Oct 2021 19:42:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2801801.e9J7NaK4W3@kailua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: +ACPI maintainers]

Am 12.10.21 um 18:34 schrieb Andreas K. Huettel:
>>> The messages easily identifiable are:
>>>
>>> huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
>>> Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
>>> Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
>>> Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)
>>
>> This line is missing below, it indicates that the kernel couldn't or
>> didn't power up the PCIe for some reason. We're looking for something
>> like ACPI or PCI patches (possibly PCI-Power management) to be the
>> culprit here.
> 
> So I did a git bisect from linux-v5.10 (good) to linux-v5.14.11 (bad).
> 
> The result was:
> 
> dilfridge /usr/src/linux-git # git bisect bad
> 6381195ad7d06ef979528c7452f3ff93659f86b1 is the first bad commit
> commit 6381195ad7d06ef979528c7452f3ff93659f86b1
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Mon May 24 17:26:16 2021 +0200
> 
>      ACPI: power: Rework turning off unused power resources
> [...]
> 
> I tried naive reverting of this commit on top of 5.14.11. That applies nearly cleanly,
> and after a reboot the additional ethernet interfaces show up with their MAC in the
> boot messages.
> 
> (Not knowing how safe that experiment was, I did not go further than single mode and
> immediately rebooted into 5.10 afterwards.)
