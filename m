Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CBA48471D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiADRlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:41:04 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:39252
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235820AbiADRlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:41:03 -0500
Received: from [192.168.1.7] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8190A3F11D;
        Tue,  4 Jan 2022 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641318055;
        bh=LuQb28R2FkLy01iYLZ8QkxirC3IlNK0sfWy4RR2SAYQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=WInJL35A2sSz8464pePpjabQuyPyIdKmTnNd67/ANReKaMADAzM49Ndk++AO7MUcA
         8qG6DVCAkZKtihyq91fz8nlVH2OmAOljd76XnlA+oiF00ul+JdYvOpyC+KRoxwNwZb
         pWKADSlqJ9StQgzxhi/xIOiWHvrmcjXvbeRNo++eK30BIgMu//OgFh2QQh9tFyqbOm
         oh9bU58Dp0kU8RrFud7zRXw83b4Q4C8soHwnma+CwJ3zViipuE807j3S+qYQ4h7Bs9
         rf7USO2TlGjfaQj5dz9vL8irmmYnLBPOBIsmuppKh83v8wCSZVn4mWu9WPXBv8j47A
         SJ78JCw5DZ8yA==
Message-ID: <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
Date:   Wed, 5 Jan 2022 01:40:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Content-Language: en-US
To:     Henning Schild <henning.schild@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116141917.31661-1-aaron.ma@canonical.com>
 <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
 <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/22 01:07, Henning Schild wrote:
> Am Tue, 4 Jan 2022 06:53:26 -0800
> schrieb Jakub Kicinski <kuba@kernel.org>:
> 
>> On Tue, 4 Jan 2022 12:38:14 +0100 Henning Schild wrote:
>>> This patch is wrong and taking the MAC inheritance way too far. Now
>>> any USB Ethernet dongle connected to a Lenovo USB Hub will go into
>>> inheritance (which is meant for docks).
>>>
>>> It means that such dongles plugged directly into the laptop will do
>>> that, or travel adaptors/hubs which are not "active docks".
>>>
>>> I have USB-Ethernet dongles on two desks and both stopped working as
>>> expected because they took the main MAC, even with it being used at
>>> the same time. The inheritance should (if at all) only be done for
>>> clearly identified docks and only for one r8152 instance ... not
>>> all. Maybe even double checking if that main PHY is "plugged" and
>>> monitoring it to back off as soon as it is.
>>>
>>> With this patch applied users can not use multiple ethernet devices
>>> anymore ... if some of them are r8152 and connected to "Lenovo" ...
>>> which is more than likely!
>>>
>>> Reverting that patch solved my problem, but i later went to
>>> disabling that very questionable BIOS feature to disable things for
>>> good without having to patch my kernel.
>>>
>>> I strongly suggest to revert that. And if not please drop the
>>> defines of
>>>> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
>>>> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
>>>
>>> And instead of crapping out with "(unnamed net_device)
>>> (uninitialized): Invalid header when reading pass-thru MAC addr"
>>> when the BIOS feature is turned off, one might want to check
>>> DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking
>>> the BIOS if the feature is wanted.
>>
>> Thank you for the report!
>>
>> Aaron, will you be able to fix this quickly? 5.16 is about to be
>> released.
> 
> If you guys agree with a revert and potentially other actions, i would
> be willing to help. In any case it is not super-urgent since we can
> maybe agree an regression and push it back into stable kernels.
> 
> I first wanted to place the report and see how people would react ...
> if you guys agree that this is a bug and the inheritance is going "way
> too far".
> 
> But i would only do some repairs on the surface, the feature itself is
> horrific to say the least and i am very happy with that BIOS switch to
> ditch it for good. Giving the MAC out is something a dock physically
> blocking the original PHY could do ... but year ... only once and it
> might be pretty hard to say which r8152 is built-in from the hub and
> which is plugged in additionally in that very hub.
> Not to mention multiple hubs of the same type ... in a nice USB-C chain.
> 

Yes, it's expected to be a mess if multiple r8152 are attached to Lenovo USB-C/TBT docks.
The issue had been discussed for several times in LKML.
Either lose this feature or add potential risk for multiple r8152.

The idea is to make the Dock work which only ship with one r8152.
It's really hard to say r8152 is from dock or another plugin one.

If revert this patch, then most users with the original shipped dock may lose this feature.
That's the problem this patch try to fix.

For now I suggest to disable it in BIOS if you got multiple r8152.

Let me try to make some changes to limit this feature in one r8152.

Aaron


> MAC spoofing is something NetworkManager and others can take care of,
> or udev ... doing that in the driver is ... spooky.
> 
> regards,
> Henning
