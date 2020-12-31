Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598912E7FD4
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 13:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLaMOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 07:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgLaMOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 07:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE93223DB;
        Thu, 31 Dec 2020 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609416853;
        bh=RtWoLeGbWbintP+acf+80IAQXZOGQZCtPB+lC1usOpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vwo1zm26XZukJb37NnoTPdx8DpC/QKyZn6CzWUSMmvLk+5vrMlv+3SCLs0rsm+fWE
         q+NbBpb1E4+dUtMK1C6ubN/768Lr4QMqOdbc5LAp6c41x10BD4GYodoKjLQkfFFD1g
         8J3UYk6gggX7DyuFNnFhTr/2nc+ELLGqSomRntEPr3CNciOBi1jDfOUkPea+ett+7n
         cKQ1293E8ejISNuum9wHvPxqB1pEQxcLAIR68GeJnBCY2uDLVc571YkyYCmlIdujIY
         hObytOHQnCeHyMqLiz37CzwFuM7EKC2eckwY28cIN474+kij78WpYaVh2JdUopljAd
         qF/QV6KggnAMA==
Received: by pali.im (Postfix)
        id 722A8C35; Thu, 31 Dec 2020 13:14:10 +0100 (CET)
Date:   Thu, 31 Dec 2020 13:14:10 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201231121410.2xlxtyqjelrlysd2@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230190958.GW1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 19:09:58 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> > On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > > Hi Pali
> > > 
> > > I have to agree with Russell here. I would rather have no diagnostics
> > > than untrustable diagnostics.
> > 
> > Ok!
> > 
> > So should we completely skip hwmon_device_register_with_info() call
> > if (i2c_block_size < 2) ?
> 
> I don't think that alone is sufficient - there's also the matter of
> ethtool -m which will dump that information as well, and we don't want
> to offer it to userspace in an unreliable form.

Any idea/preference how to disable access to these registers?

> For reference, here is what SFF-8472 which defines the diagnostics, says
> about this:
> 
>   To guarantee coherency of the diagnostic monitoring data, the host is
>   required to retrieve any multi-byte fields from the diagnostic
>   monitoring data structure (IE: Rx Power MSB - byte 104 in A2h, Rx Power
>   LSB - byte 105 in A2h) by the use of a single two-byte read sequence
>   across the two-wire interface interface.
> 
>   The transceiver is required to ensure that any multi-byte fields which
>   are updated with diagnostic monitoring data (e.g. Rx Power MSB - byte
>   104 in A2h, Rx Power LSB - byte 105 in A2h) must have this update done
>   in a fashion which guarantees coherency and consistency of the data. In
>   other words, the update of a multi-byte field by the transceiver must
>   not occur such that a partially updated multi-byte field can be
>   transferred to the host. Also, the transceiver shall not update a
>   multi-byte field within the structure during the transfer of that
>   multi-byte field to the host, such that partially updated data would be
>   transferred to the host.
> 
> The first paragraph is extremely definitive in how these fields shall
> be read atomically - by a _single_ two-byte read sequence. From what
> you are telling us, these modules do not support that. Therefore, by
> definition, they do *not* support proper and reliable reporting of
> diagnostic data, and are non-conformant with the SFP MSAs.
> 
> So, they are basically broken, and the diagnostics can't be used to
> retrieve data that can be said to be useful.

I agree they are broken. We really should disable access to those 16bit
registers.

Anyway here is "datasheet" to some CarlitoxxPro SFP:
https://www.docdroid.net/hRsJ560/cpgos03-0490v2-datasheet-10-pdf

And on page 10 is written:

    The I2C system can support the mode of random address / single
    byteread which conform to SFF-8431.

Which seems to be wrong.

> > I do not think that manufacture says something. I think that they even
> > do not know that their Realtek chips are completely broken.
> 
> Oh, they do know. I had a response from CarlitoxxPro passed to me, which
> was:

Could you give me contact address?

Anyway, we would rather should contact Realtek chip division, real
manufacture. Not CarlitoxxPro rebrander which can just "buy product"
from Realtek reseller and put its logo on stick (and maybe configuration
like sn, mac address, password and enable/disable bit for web/telnet).

>   That is a behavior related on how your router/switch try to read the
>   EEPROM, as described in the datasheet of the GPON ONU SFP, the EEPROM
>   can be read in Sequential Single-Byte mode, not in Multi-byte mode as
>   you router do, basically, your router is trying to read the full a0h
>   table in a single call, and retrieve a null response. that is normal
>   and not affect the operations of the GPON ONU SFP, because these
>   values are informational only. so the Software for your router should
>   be able to read in Single-Byte mode to read the content of the EEPROM
>   in concordance to SFF-8431
> 
> which totally misses the point that it is /not/ up to the module to
> choose whether multi-byte reads are supported or not. If they bothered
> to gain a proper understanding of the MSAs, they would have noticed that
> the device on 0xA0 is required to behave as an Atmel AT24Cxx EEPROM.
> The following from INF-8074i, which is the very first definition of the
> SFP form factor modules:
> 
>   The SFP serial ID provides access to sophisticated identification
>   information that describes the transceiver's capabilities, standard
>   interfaces, manufacturer, and other information. The serial interface
>   uses the 2-wire serial CMOS E2PROM protocol defined for the ATMEL
>   AT24C01A/02/04 family of components.
> 
> As they took less than one working day to provide the above response, I
> suspect they know full well that there's a problem - and it likely
> affects other "routers" as well.

As this issue is with all those Realtek chips I really think this issue
is in underlying Realtek chip and not in CarlitoxxPro rebranding. Seems
that they know about this issue and because it affects all GPON Realtek
SFPs with that chip that cannot do anything with it, so just wrote it
into "datasheet" and trying to find arguments "why behavior is correct"
even it is not truth.

> They're also confused about their SFF specifications. SFF-8431 is: "SFP+
> 10 Gb/s and Low Speed Electrical Interface" which is not the correct
> specification for a 1Gbps module.

Looks like "trying to find arguments why it is correct".

> > I can imagine that vendor just says: it is working in our branded boxes
> > with SFP cages and if it does not work in your kernel then problem is
> > with your custom kernel and we do not care about 3rd parties.
> 
> Which shows why it's pointless producing an EEPROM validation tool that
> runs under Linux (as has been your suggestion). They won't use it,
> since their testing only goes as far as "does it work in our product?"

At least users could do their own validation and for rewritable EEPROMs
they could be able to fix its content.

Anyway, if there is such tool then users could start creating database
of working and non-working SFPs where can be put result of this tool.

It could help people to decide which SFP they should buy and which not.
Sending page/database to manufactures with showing "do not buy this your
SFP, does not work and is broken" maybe change their state and start
doing validation if people stop buying their products or manufacture
name would be on unsupported black list.
