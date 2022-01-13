Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA56848D0D8
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 04:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiAMDYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 22:24:05 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48330
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231983AbiAMDYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 22:24:04 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 01A1B3F0FC;
        Thu, 13 Jan 2022 03:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642044242;
        bh=/wUFmttyv84qQYfrG79OlBt05JFQ8xQtLNk02ZhtSA0=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=YszsSf/DENwg7Ce7yVa1XMY9sms93TdGgNdHDIgGnuqZJpBgVPoZNyl89Rs60nCAW
         dS1tuszcmiQeFANns11sysYcKO0wzL1T/sCmHaU0NbDMYtMM5YUekVwEDRKKmvsGD8
         26vZCNLaWoHUxDDjLndd1UU9bVQOU54745H6enOgmESkIe67UBrn/b1xGob0xCpS1F
         esZosadVATYLSER52Ex1TG3OvBABiapM0MD3CUMYd2naVl0tPGg2dkC1JtzVHsEvUG
         0isMZb+xLeLpXnmdiT5TjGM6yB/lJZW9gDdwVA/cPUVDm+hyLUEKnttO9SYAuxRSRv
         kvEgw0w2JGMOg==
Message-ID: <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
Date:   Thu, 13 Jan 2022 11:23:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdbuXbtc64+Knbhm@lunn.ch>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/13/22 03:27, Limonciello, Mario wrote:
> [Public]
>
>> -----Original Message-----
>> From: Henning Schild <henning.schild@siemens.com>
>> Sent: Wednesday, January 12, 2022 13:21
>> To: Limonciello, Mario <Mario.Limonciello@amd.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>; Kai-Heng Feng
>> <kai.heng.feng@canonical.com>; Andrew Lunn <andrew@lunn.ch>; Oliver
>> Neukum <oneukum@suse.com>; Aaron Ma <aaron.ma@canonical.com>; linux-
>> usb@vger.kernel.org; netdev@vger.kernel.org; davem@davemloft.net;
>> hayeswang@realtek.com; tiwai@suse.de
>> Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
>> address
>>
>> Am Tue, 11 Jan 2022 11:10:52 -0600
>> schrieb "Limonciello, Mario" <mario.limonciello@amd.com>:
>>
>>> On 1/11/2022 11:06, Jakub Kicinski wrote:
>>>> On Tue, 11 Jan 2022 10:54:50 -0600 Limonciello, Mario wrote:
>>>>>> Also knowing how those OSes handle the new docks which don't have
>>>>>> unique device IDs would obviously be great..
>>>>> I'm sorry, can you give me some more context on this?  What unique
>>>>> device IDs?
>>>> We used to match the NICs based on their device ID. The USB NICs
>>>> present in docks had lenovo as manufacturer and a unique device ID.
>>>> Now reportedly the new docks are using generic realtek IDs so we
>>>> have no way to differentiate "blessed" dock NICs from random USB
>>>> dongles, and inheriting the address to all devices with the generic
>>>> relatek IDs breaks setups with multiple dongles, e.g. Henning's
>>>> setup. > If we know of a fuse that can be read on new docks that'd
>>>> put us back in more comfortable position. If we need to execute
>>>> random heuristics to find the "right NIC" we'd much rather have
>>>> udev or NetworkManager or some other user space do that according
>>>> to whatever policy it chooses.
>>> I agree - this stuff in the kernel isn't supposed to be applying to
>>> anything other than the OEM dongles or docks.  If you can't identify
>>> them they shouldn't be in here.
>> Not sure we can really get to a proper solution here. The one revert
>> for Lenovo will solve my very issue. And on top i was lucky enough to
>> being able to disable pass-thru in the BIOS.
>>
>>  From what the Lenovo vendor docs seem to suggest it is about PXE ...
>> meaning the BIOS will do the spoofing, how it does that is unclear. Now
>> an OS can try to keep it up but probably should not try to do anything
>> on its own ... or do the additional bits in user-space and not the
>> kernel.
>>
>> Thinking about PXE we do not just have the kernel, but also multiple
>> potential bootloaders. All would need to inherit the spoofed MAC from a
>> potential predecessor having applied spoofing, and support USB and
>> network ... that is not realistic!
>>
>> Going back to PXE ... says nothing about OS operation really. Say a
>> BIOS decides to spoof when booting ... that say nothing on how to deal
>> with hot-plugged devices which die BIOS did not even see. But we have
>> code for such hot-plug spoofing in the kernel .. where vendors like
>> Lenovo talk about PXE (only?)
> Something that would probably be interesting to check is whether the
> BIOS uses pass through MAC on anything as well or it has some criteria
> that decides to apply it that the kernel doesn't know about.
>
>> The whole story seems too complicated and not really explained or
>> throught through. If the vendors can explain stuff the kernel can
>> probably cater ... but user-land would still be the better place.
>>
>> I will not push for more reverts. But more patches in the direction
>> should be questioned really hard! And even if we get "proper device
>> matching" we will only cater for "vendor lock-in". It is not clear why
>> that strange feature will only apply if the dock if from the same
>> vendor as the laptop. Applying it on all USB NICs is clearly going too
>> far, that will only work with IT department highlander policies like
>> "there must only be one NIC".
>>
>> So from my point it is solved with the one Lenovo-related revert. Any
>> future pass-thru patches get a NACK and any reverts targeting other
>> vendors get an ACK. But feel free to Cc me when such things happen in
>> the future.
>>
> KH & Aaron - can you please talk to Lenovo about making sure that there
> is a way to distinguish between devices that should get pass through or
> shouldn't and to document that?
>
> I think that a policy that it should be a NACK for anything else general
> makes sense.

Sorry for my previous patch.
Before made that patch I already discussed with Lenovo.
And didn't get any other opinion. The solution is from a discussion with them.

This info had been forward to them too.

Aaron

>
>> regards,
>> Henning

