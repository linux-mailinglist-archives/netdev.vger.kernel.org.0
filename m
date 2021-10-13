Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4742CCDE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 23:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhJMVhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 17:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhJMVho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 17:37:44 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0378DC061570;
        Wed, 13 Oct 2021 14:35:40 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HV5Rs70MSzQjdM;
        Wed, 13 Oct 2021 23:35:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <85e2a07d-6b7b-d443-fb9a-c15b8e9849d2@v0yd.nl>
Date:   Wed, 13 Oct 2021 23:35:28 +0200
MIME-Version: 1.0
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
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
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20211012112932.GA1735699@bhelgaas>
Content-Language: en-US
In-Reply-To: <20211012112932.GA1735699@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08D081899
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 13:29, Bjorn Helgaas wrote:
> On Tue, Oct 12, 2021 at 10:48:49AM +0200, Jonas Dreßler wrote:
>> On 10/11/21 18:53, Bjorn Helgaas wrote:
>>> On Mon, Oct 11, 2021 at 03:42:38PM +0200, Jonas Dreßler wrote:
>>>> The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
>>>> reports a hardcoded LTR value to the system during initialization,
>>>> probably as an (unsuccessful) attempt of the developers to fix firmware
>>>> crashes. This LTR value prevents most of the Microsoft Surface devices
>>>> from entering deep powersaving states (either platform C-State 10 or
>>>> S0ix state), because the exit latency of that state would be higher than
>>>> what the card can tolerate.
>>>
>>> S0ix and C-State 10 are ACPI concepts that don't mean anything in a
>>> PCIe context.
>>>
>>> I think LTR is only involved in deciding whether to enter the ASPM
>>> L1.2 substate.  Maybe the system will only enter C-State 10 or S0ix
>>> when the link is in L1.2?
>>
>> Yup, this is indeed the case, see https://01.org/blogs/qwang59/2020/linux-s0ix-troubleshooting
>> (ctrl+f "IP LINK PM STATE").
> 
> I think it would be helpful if the commit log included this missing
> link, e.g., the LTR value prevents the link from going to L1.2, which
> in turn prevents use of C-State 10/S0ix.
> 
>> There's two alternatives I can think of to deal with this issue:
>>
>> 1) Revert the cards firmware in linux-firmware back to the second-latest
>> version. That firmware didn't report a fixed LTR value and also doesn't
>> have any other obvious issues I know of compared to the latest one.
> 
> You've mentioned "fixed LTR value" more than once.  My weak
> understanding of LTR and L1.2 is that the latencies a device reports
> via LTR messages are essentially a function of buffering in the device
> and electrical characteristics of the link.  I expect them to be set
> once and not changed.

I'm not an expert on PCI at all, but from my understanding the idea behind
the LTR mechanism is to be able to dynamically communicate latency
requirements depending on the current situation/workload. So for example
in case the wifi card is receiving a lot of data, it would report a lower
latency tolerance because its rx buffers are filling up fast.

Looking at ltr_show in the pmc_core debug driver, that also seems to be how
other devices handle it: For example moving the USB mouse makes the XHCI
controller report a non-null LTR for a few seconds.

So with "fixed LTR value" I meant to say that in my understanding this is
exactly the opposite of how LTR is supposed to be used: Instead of
dynamically reporting a new latency tolerance when the card is being used,
it reports a "fixed" tolerance once during firmware startup, maybe with
the intention of papering over bugs in the firmware...

> 
> But did the previous firmware report different latencies at different
> times?  Or did it just not advertise L1.2 support at all?  Or do you
> mean the new firmware reports a "corrected" LTR value that doesn't
> work as well?

Sorry, as mentioned in my other reply the previous firmware is actually
behaving in the exact same way, no clue why I remembered this wrong.

> 
>> 2) Somehow interact with the PMC Core driver to make it ignore the LTR
>> values reported by the card (I doubt that's possible from mwifiex).
>> It can be done manually via debugfs by writing to
>> /sys/kernel/debug/pmc_core/ltr_ignore.
> 
> Interesting; I wasn't aware of that, thanks.  This still feels like a
> configuration issue.  If we ignore the reported LTR values, I guess
> you mean the root port assumes it's *always* safe to enter L1.2, i.e.,
> the device has enough buffering to deal with the exit latency?

Not sure about that, in theory there's also the whole negotiation via the
CLKREQ# pin when entering ASPM L1.2. The card could use that to reject L1.2
entry I guess.

> 
> I would think there would be a way to program the LTR capability to
> have the device itself report that, so we wouldn't have to fiddle with
> the upstream end.

Well I mean the device does report LTR capabilities and a maximum snoop and
non-snoop latency via extended capabilities, so I guess that means it is
supported.

> 
>>>> +	 * We need to do it here because it must happen after firmware
>>>> +	 * initialization and this function is called right after that is done.
>>>> +	 */
> 
>>>> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
>>>> +		pci_reset_function(parent_pdev);
>>>
>>> PCIe r5.0, sec 7.5.3.3, says Function Level Reset can only be
>>> supported by endpoints, so I guess this will actually do some other
>>> kind of reset.
>>
>> Interesting, I briefly searched and it doesn't seem like think
>> there's public documentation available by Intel that goes into
>> the specifics here, maybe someone working at Intel knows more?
> 
> "lspci -vv" will tell you whether the root port advertises FLR
> support.  The spec says it shouldn't, but I think pci_reset_function()
> relies on what DevCap says.  You could instrument pci_reset_function()
> to see exactly what kind of reset we do.

Ahh indeed, I wasn't aware there's multiple kinds of resets. Looks like
what it uses is pci_pm_reset().

> 
> Bjorn
> 

