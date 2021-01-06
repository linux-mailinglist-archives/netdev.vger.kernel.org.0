Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA092EBFE6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAFO4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbhAFO4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 09:56:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A55E123106;
        Wed,  6 Jan 2021 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609944936;
        bh=u7WvQbeJBDsarxFXXj430rrW8wY6RIqlsFAd/OoZR4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1qTz4rTy0TOO+DMWIiERnmrFiAZmMVhdmCN2rn0U6fvxO9sMXNp/JMWQ8AA5vtZS
         3Vo/xmMBqbH58Qle+DeySRGd89w5D7HDxCXNfbdL46M4npUvGlLoFy0GVPZhnt6FFA
         mgq2b8f2hlE+qj/fFIhEJ8gbRyfmQV1BCZ3oGlThkOg70Q0O2Dmm+aW7GtNJmMUcX/
         a46qd2VtNdEulkm7huqf/o8ZdBpEAiStmONT7iAieUtHBs8ifKu2AhLHfeLnxT8ivH
         0Ww/aSDM3qVMKn79/nmElv9p78UL4yYlQVf4euKVbhZvO1KlRMZv708qpw+7GoJfJz
         jmsQO14PvLZXw==
Received: by pali.im (Postfix)
        id CA8B644E; Wed,  6 Jan 2021 15:55:32 +0100 (CET)
Date:   Wed, 6 Jan 2021 15:55:32 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210106145532.xynhoufpfyzmurd5@pali>
References: <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali>
 <X+4GwpFnJ0Asq/Yj@lunn.ch>
 <20210102014955.2xv27xla65eeqyzz@pali>
 <CALQZrspktLr3SfVRhBrVK2zhjFzJMm9tQjWXU_07zjwJytk7Cg@mail.gmail.com>
 <20210103024132.fpvjumilazrxiuzj@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210103024132.fpvjumilazrxiuzj@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 03 January 2021 03:41:32 Pali Rohár wrote:
> Hello!
> 
> On Sunday 03 January 2021 03:25:23 Thomas Schreiber wrote:
> > Hi Pali,
> > I have a CarlitoxxPro module and I reported an issue about RX_LOS pin
> > to the manufacturer.
> > It looks to me that the module asserts "inverted LOS" through EEPROM
> > but does not implement it.
> 
> So, it is broken :-( But I'm not surprised.
> 
> Anyway, I think you could be interested in this discussion about my
> patch series, but I forgot to CC you on the first patch/cover letter.
> You can read whole discussion on public archive available at:
> 
> https://lore.kernel.org/netdev/20201230154755.14746-1-pali@kernel.org/t/#u
> 
> If you have any comments, let me know so I can fix it for V2.
> 
> Those RTL8672/RTL9601C SFP are extremely broken and I do not think that
> "rebrander" CarlitoxxPro would do anything with it.
> 
> > Consequently, the SFP state machine of my
> > host router stays in check los state and link is not set up for the
> > host interface.
> 
> So link does not work at all?
> 
> > Below is a dump of the module's EEPROM:
> > 
> > [root@clearfog-gt-8k ~]# ethtool -m eth0
> > Identifier                                : 0x03 (SFP)
> > Extended identifier                       : 0x04 (GBIC/SFP defined by
> > 2-wire interface ID)
> > Connector                                 : 0x01 (SC)
> > Transceiver codes                         : 0x00 0x00 0x00 0x00 0x00
> > 0x00 0x00 0x00 0x00
> > Encoding                                  : 0x03 (NRZ)
> > BR, Nominal                               : 1200MBd
> > Rate identifier                           : 0x00 (unspecified)
> > Length (SMF,km)                           : 20km
> > Length (SMF)                              : 20000m
> > Length (50um)                             : 0m
> > Length (62.5um)                           : 0m
> > Length (Copper)                           : 0m
> > Length (OM3)                              : 0m
> > Laser wavelength                          : 1310nm
> > Vendor name                               : VSOL
> > Vendor OUI                                : 00:00:00
> > Vendor PN                                 : V2801F
> > Vendor rev                                : 1.0
> > Option values                             : 0x00 0x1c
> > Option                                    : RX_LOS implemented, inverted
> > Option                                    : TX_FAULT implemented
> > Option                                    : TX_DISABLE implemented
> > BR margin, max                            : 0%
> > BR margin, min                            : 0%
> > Vendor SN                                 : CP202003180377
> > Date code                                 : 200408
> > Optical diagnostics support               : Yes
> > Laser bias current                        : 0.000 mA
> > Laser output power                        : 0.0000 mW / -inf dBm
> > Receiver signal average optical power     : 0.0000 mW / -inf dBm
> > Module temperature                        : 31.00 degrees C / 87.80 degrees F
> > Module voltage                            : 0.0000 V
> > Alarm/warning flags implemented           : Yes
> > Laser bias current high alarm             : Off
> > Laser bias current low alarm              : On
> > Laser bias current high warning           : Off
> > Laser bias current low warning            : Off
> > Laser output power high alarm             : Off
> > Laser output power low alarm              : On
> > Laser output power high warning           : Off
> > Laser output power low warning            : Off
> > Module temperature high alarm             : Off
> > Module temperature low alarm              : Off
> > Module temperature high warning           : Off
> > Module temperature low warning            : Off
> > Module voltage high alarm                 : Off
> > Module voltage low alarm                  : Off
> > Module voltage high warning               : Off
> > Module voltage low warning                : Off
> > Laser rx power high alarm                 : Off
> > Laser rx power low alarm                  : Off
> > Laser rx power high warning               : Off
> > Laser rx power low warning                : Off
> > Laser bias current high alarm threshold   : 74.752 mA
> > Laser bias current low alarm threshold    : 0.000 mA
> > Laser bias current high warning threshold : 0.000 mA
> > Laser bias current low warning threshold  : 0.000 mA
> > Laser output power high alarm threshold   : 0.0000 mW / -inf dBm
> > Laser output power low alarm threshold    : 0.0000 mW / -inf dBm
> > Laser output power high warning threshold : 0.0000 mW / -inf dBm
> > Laser output power low warning threshold  : 0.0000 mW / -inf dBm
> > Module temperature high alarm threshold   : 90.00 degrees C / 194.00 degrees F
> > Module temperature low alarm threshold    : 0.00 degrees C / 32.00 degrees F
> > Module temperature high warning threshold : 0.00 degrees C / 32.00 degrees F
> > Module temperature low warning threshold  : 0.00 degrees C / 32.00 degrees F
> > Module voltage high alarm threshold       : 0.0000 V
> > Module voltage low alarm threshold        : 0.0000 V
> > Module voltage high warning threshold     : 0.0000 V
> > Module voltage low warning threshold      : 0.0000 V
> > Laser rx power high alarm threshold       : 0.1536 mW / -8.14 dBm
> > Laser rx power low alarm threshold        : 0.0000 mW / -inf dBm
> > Laser rx power high warning threshold     : 0.0000 mW / -inf dBm
> > Laser rx power low warning threshold      : 0.0000 mW / -inf dBm
> > 
> > 
> > Le sam. 2 janv. 2021 à 02:49, Pali Rohár <pali@kernel.org> a écrit :
> > >
> > > On Thursday 31 December 2020 18:13:38 Andrew Lunn wrote:
> > > > > > Looking at sfp_module_info(), adding a check for i2c_block_size < 2
> > > > > > when determining what length to return. ethtool should do the right
> > > > > > thing, know that the second page has not been returned to user space.
> > > > >
> > > > > But if we limit length of eeprom then userspace would not be able to
> > > > > access those TX_DISABLE, LOS and other bits from byte 110 at address A2.
> > > >
> > > > Have you tested these bits to see if they actually work? If they don't
> > > > work...
> > >
> > > On Ubiquiti module that LOS bit does not work.
> > >
> > > I think that on CarlitoxxPro module LOS bit worked. But I cannot test it
> > > right now as I do not have access to testing OLT unit.

On my tested CarlitoxxPro module is:

        Option values                             : 0x00 0x1c
        Option                                    : RX_LOS implemented, inverted
        Option                                    : TX_FAULT implemented
        Option                                    : TX_DISABLE implemented

When cable is disconnected then in EEPROM at position 0x16e is value
0x82. If I call 'ip link set eth1 up' then value changes to 0x02, module
itself has a link and I can connect to its internal telnet/webserver to
configure it.

When cable is connected but connection is not established by OLT then
this value is 0x80. If I call 'ip link set eth1 up' then value changes
to 0x00 and kernel does not see a link (no carrier).

So it seems that RX_LOS (bit 1 of 0x16e EEPROM) and also TX_DISABLE (bit
7 of 0x16e EEPROM) is implemented and working properly.

And therefore we should allow access to these bits.


I also tested UBNT module and result is:

        Option values                             : 0x00 0x06
        Option                                    : RX_LOS implemented
        Option                                    : RX_LOS implemented, inverted

Which means that those bits are not implemented.

Anyway I check position 0x16e and value on its value is randomly either
0x79 or 0xff independently of the state of the GPON module.

So it is really not implemented on UBNT.

> > > Adding Thomas to loop. Can you check if CarlitoxxPro GPON ONT module
> > > supports LOS or other bits at byte offset 110 at address A2?
