Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168B344545F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhKDOAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 10:00:32 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:43940 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKDOAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 10:00:32 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HlQFT3F3kzQjf7;
        Thu,  4 Nov 2021 14:57:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <b7e15579-f899-d292-92e0-79ecdab1672e@v0yd.nl>
Date:   Thu, 4 Nov 2021 14:57:41 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Vidya Sagar <vidyas@nvidia.com>,
        Victor Ding <victording@google.com>
References: <20211025235618.GA52139@bhelgaas>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211025235618.GA52139@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43B0F110B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 01:56, Bjorn Helgaas wrote:
> On Mon, Oct 25, 2021 at 06:45:29PM +0200, Jonas Dreßler wrote:
>> On 10/18/21 17:35, Bjorn Helgaas wrote:
>>> On Thu, Oct 14, 2021 at 12:08:31AM +0200, Jonas Dreßler wrote:
>>>> On 10/12/21 17:39, Bjorn Helgaas wrote:
>>>>> [+cc Vidya, Victor, ASPM L1.2 config issue; beginning of thread:
>>>>> https://lore.kernel.org/all/20211011134238.16551-1-verdre@v0yd.nl/]
>>>
>>>>> I wonder if this reset quirk works because pci_reset_function() saves
>>>>> and restores much of config space, but it currently does *not* restore
>>>>> the L1 PM Substates capability, so those T_POWER_ON,
>>>>> Common_Mode_Restore_Time, and LTR_L1.2_THRESHOLD values probably get
>>>>> cleared out by the reset.  We did briefly save/restore it [1], but we
>>>>> had to revert that because of a regression that AFAIK was never
>>>>> resolved [2].  I expect we will eventually save/restore this, so if
>>>>> the quirk depends on it *not* being restored, that would be a problem.
>>>>>
>>>>> You should be able to test whether this is the critical thing by
>>>>> clearing those registers with setpci instead of doing the reset.  Per
>>>>> spec, they can only be modified when L1.2 is disabled, so you would
>>>>> have to disable it via sysfs (for the endpoint, I think)
>>>>> /sys/.../l1_2_aspm and /sys/.../l1_2_pcipm, do the setpci on the root
>>>>> port, then re-enable L1.2.
>>>>>
>>>>> [1] https://git.kernel.org/linus/4257f7e008ea
>>>>> [2] https://lore.kernel.org/all/20210127160449.2990506-1-helgaas@kernel.org/
>>>>
>>>> Hmm, interesting, thanks for those links.
>>>>
>>>> Are you sure the config values will get lost on the reset? If we
>>>> only reset the port by going into D3hot and back into D0, the
>>>> device will remain powered and won't lose the config space, will
>>>> it?
>>>
>>> I think you're doing a PM reset (transition to D3hot and back to
>>> D0).  Linux only does this when PCI_PM_CTRL_NO_SOFT_RESET == 0.
>>> The spec doesn't actually *require* the device to be reset; it
>>> only says the internal state of the device is undefined after
>>> these transitions.
>>
>> Not requiring the device to be reset sounds sensible to me given
>> that D3hot is what devices are transitioned into during suspend.
>>
>> But anyway, that doesn't really get us any further except it
>> somewhat gives an explanation why the LTR is suddenly 0 after the
>> reset. Or are you making the point that we shouldn't rely on
>> "undefined state" for this hack because not all PCI bridges/ports
>> will necessarily behave the same?
> 
> I guess I'm just making the point that I don't understand why the
> bridge reset fixes something, and I'm not confident that the fix will
> work on every system and continue working even if/when the PCI core
> starts saving and restoring the L1 PM Substates capability.
> 

FWIW, I've tested it with the restoring of L1 PM Substates enabled now
and the bridge reset worked just as before.

But yeah I, too, have no clue why exactly the bridge reset does what it
does...

Anyway, I've also confirmed that it actually impacts the power usage by
measuring consumed energy during idle over a few minutes: Applying either
the bridge reset quirk or ignoring the LTR via pmc_core results in about
7% less energy usage. Given that the overall energy usage was almost
nothing to make the measurement easier, those 7% are not a lot, but
nonetheless it confirms that the quirk works.
