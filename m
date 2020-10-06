Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBAE28547B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 00:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgJFWYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 18:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgJFWYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 18:24:20 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ACCC061755;
        Tue,  6 Oct 2020 15:24:19 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5X7k3F8Tz1s8vN;
        Wed,  7 Oct 2020 00:24:17 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5X7j2nldz1qql5;
        Wed,  7 Oct 2020 00:24:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Y9zUkKaVGMCi; Wed,  7 Oct 2020 00:24:14 +0200 (CEST)
X-Auth-Info: Ii+nhy4Y3fudnAwmzlaCA1OAbSKRBjLZTPNCq8y+MYw=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed,  7 Oct 2020 00:24:14 +0200 (CEST)
Subject: Re: PHY reset question
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <59dced0b-3630-3a40-435a-bfa99e23df0e@denx.de>
Date:   Wed, 7 Oct 2020 00:24:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 11:11 PM, Florian Fainelli wrote:
> 
> 
> On 10/6/2020 1:24 PM, Marek Vasut wrote:
>> On 10/6/20 9:36 PM, Florian Fainelli wrote:
>> [...]
>>>> - Use compatible ("compatible = "ethernet-phy-id0022.1560") in the
>>>> devicetree,
>>>>     so that reading the PHYID is not needed
>>>>     - easy to solve.
>>>>     Disadvantage:
>>>>     - losing PHY auto-detection capability
>>>>     - need a new devicetree if different PHY is used (for example in
>>>> different
>>>>       board revision)
>>>
>>> Or you can punt that to the boot loader to be able to tell the
>>> difference and populate different compatible, or even manage the PHY
>>> reset to be able to read the actual PHY OUI. To me that is still the
>>> best solution around.
>>
>> Wasn't there some requirement for Linux to be bootloader-independent ?
> 
> What kind of dependency does this create here? The fact that Linux is
> capable of parsing a compatible string of the form
> "ethernet-phyAAAA.BBBB" is not something that is exclusively applicable
> to Linux. Linux just so happens to support that, but so could FreeBSD or
> any OS for that matter.
> 
> This is exactly the way firmware should be going, that is to describe
> accurately the hardware, while making the life of the OS much easier
> when it can. If we supported ACPI that is exactly what would have to
> happen IMHO.

I should have been more specific, I meant the part where bootloader
should handle the PHY reset. If the kernel code depends on the fact that
the bootloader did PHY reset, then it depends on the bootloader
behavior, and I think that used to be frowned upon.

>> Some systems cannot replace their bootloaders, e.g. if the bootloader is
>> in ROM, so this might not be a solution.
> 
> It is always possible to chain load a field updateable boot loader

Not always, but that's another discussion.

>, and
> even when that is not desirable you could devise a solution that allows
> to utilize say a slightly different DTB that you could append to the
> kernel. Again, if you want to use strictly the same DTB, then you have
> to do what I just suggested and have the boot loader absorb some of this
> complexit

That sounds like moving the problem one level down without really
solving it, the bootloader will have this exact same problem -- how does
it determine that the PHY needs reset if it cannot reads its ID ?

>>>> - modify PHY framework to deassert reset before identifying the PHY.
>>>>     Disadvantages?
>>
>> If this happens on MX6 with FEC, can you please try these two patches?
>>
>> https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/
>>
>>
>> https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/
>>
> 
> Your patches are not scaling across multiple Ethernet MAC drivers
> unfortunately, so I am not sure this should be even remotely considered
> a viable solution.

Sorry for that . Since Oleksij was running into this problem on MX6 and
I had similar issue on MX6 with LAN8710 PHY, I thought this might be
helpful.
