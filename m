Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61722439BF9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhJYQsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:48:03 -0400
Received: from mout-p-202.mailbox.org ([80.241.56.172]:59386 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhJYQsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:48:03 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HdLRk2wvLzQk12;
        Mon, 25 Oct 2021 18:45:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <2157749e-4e88-76c1-bdc9-f01656f5a292@v0yd.nl>
Date:   Mon, 25 Oct 2021 18:45:29 +0200
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
References: <20211018153529.GA2235731@bhelgaas>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211018153529.GA2235731@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62ADB4A3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 17:35, Bjorn Helgaas wrote:
> On Thu, Oct 14, 2021 at 12:08:31AM +0200, Jonas Dreßler wrote:
>> On 10/12/21 17:39, Bjorn Helgaas wrote:
>>> [+cc Vidya, Victor, ASPM L1.2 config issue; beginning of thread:
>>> https://lore.kernel.org/all/20211011134238.16551-1-verdre@v0yd.nl/]
> 
>>> I wonder if this reset quirk works because pci_reset_function() saves
>>> and restores much of config space, but it currently does *not* restore
>>> the L1 PM Substates capability, so those T_POWER_ON,
>>> Common_Mode_Restore_Time, and LTR_L1.2_THRESHOLD values probably get
>>> cleared out by the reset.  We did briefly save/restore it [1], but we
>>> had to revert that because of a regression that AFAIK was never
>>> resolved [2].  I expect we will eventually save/restore this, so if
>>> the quirk depends on it *not* being restored, that would be a problem.
>>>
>>> You should be able to test whether this is the critical thing by
>>> clearing those registers with setpci instead of doing the reset.  Per
>>> spec, they can only be modified when L1.2 is disabled, so you would
>>> have to disable it via sysfs (for the endpoint, I think)
>>> /sys/.../l1_2_aspm and /sys/.../l1_2_pcipm, do the setpci on the root
>>> port, then re-enable L1.2.
>>>
>>> [1] https://git.kernel.org/linus/4257f7e008ea
>>> [2] https://lore.kernel.org/all/20210127160449.2990506-1-helgaas@kernel.org/
>>
>> Hmm, interesting, thanks for those links.
>>
>> Are you sure the config values will get lost on the reset? If we only reset
>> the port by going into D3hot and back into D0, the device will remain powered
>> and won't lose the config space, will it?
> 
> I think you're doing a PM reset (transition to D3hot and back to D0).
> Linux only does this when PCI_PM_CTRL_NO_SOFT_RESET == 0.  The spec
> doesn't actually *require* the device to be reset; it only says the
> internal state of the device is undefined after these transitions.
> 

Not requiring the device to be reset sounds sensible to me given that
D3hot is what devices are transitioned into during suspend.

But anyway, that doesn't really get us any further except it somewhat
gives an explanation why the LTR is suddenly 0 after the reset. Or are
you making the point that we shouldn't rely on "undefined state" for this
hack because not all PCI bridges/ports will necessarily behave the same?
