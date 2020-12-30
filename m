Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED392E7C05
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgL3TKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3TKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:10:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41096C061573;
        Wed, 30 Dec 2020 11:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fgi+Vsr2LvaK7mcKQV/9agi+rq7AbwJo87Y9Fht7lkM=; b=U2Pl4dk53y4Ws+jw2a2+iqA8g
        6KOqNNUipKj0bCUpSzUouZo6j3Yge7XHV/ecuzBRIocZv8NMd9rWN/NLGGVF4qeZzI3nhhmp1GdXS
        rQQCFXCiE5dMfVMeFd9fsnMOuF2gU2ZgZyHgwoiGTH8Q2ebMDP4gG8JiLSnTGN+Sld+5iG3ux824u
        u56ZRZsYJYIjG39R8+z1RlnGGTeLvC8Gkyja0jVGP1vnah+cugsbdIuM/7bT1xD+kscC1ImStjVJF
        jrJ+KBxe2Zc7T5uKYVsL+YpGBrDHCHhF8/Iqmu2W4FeDnE9qIIg0/jP39rKL5GRrjYqEYSWygxSFh
        /jkekktsg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44926)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kugr9-0005t4-LV; Wed, 30 Dec 2020 19:09:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kugr8-0002R0-ER; Wed, 30 Dec 2020 19:09:58 +0000
Date:   Wed, 30 Dec 2020 19:09:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230190958.GW1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230174307.lvehswvj5q6c6vk3@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > Hi Pali
> > 
> > I have to agree with Russell here. I would rather have no diagnostics
> > than untrustable diagnostics.
> 
> Ok!
> 
> So should we completely skip hwmon_device_register_with_info() call
> if (i2c_block_size < 2) ?

I don't think that alone is sufficient - there's also the matter of
ethtool -m which will dump that information as well, and we don't want
to offer it to userspace in an unreliable form.

For reference, here is what SFF-8472 which defines the diagnostics, says
about this:

  To guarantee coherency of the diagnostic monitoring data, the host is
  required to retrieve any multi-byte fields from the diagnostic
  monitoring data structure (IE: Rx Power MSB - byte 104 in A2h, Rx Power
  LSB - byte 105 in A2h) by the use of a single two-byte read sequence
  across the two-wire interface interface.

  The transceiver is required to ensure that any multi-byte fields which
  are updated with diagnostic monitoring data (e.g. Rx Power MSB - byte
  104 in A2h, Rx Power LSB - byte 105 in A2h) must have this update done
  in a fashion which guarantees coherency and consistency of the data. In
  other words, the update of a multi-byte field by the transceiver must
  not occur such that a partially updated multi-byte field can be
  transferred to the host. Also, the transceiver shall not update a
  multi-byte field within the structure during the transfer of that
  multi-byte field to the host, such that partially updated data would be
  transferred to the host.

The first paragraph is extremely definitive in how these fields shall
be read atomically - by a _single_ two-byte read sequence. From what
you are telling us, these modules do not support that. Therefore, by
definition, they do *not* support proper and reliable reporting of
diagnostic data, and are non-conformant with the SFP MSAs.

So, they are basically broken, and the diagnostics can't be used to
retrieve data that can be said to be useful.

> I do not think that manufacture says something. I think that they even
> do not know that their Realtek chips are completely broken.

Oh, they do know. I had a response from CarlitoxxPro passed to me, which
was:

  That is a behavior related on how your router/switch try to read the
  EEPROM, as described in the datasheet of the GPON ONU SFP, the EEPROM
  can be read in Sequential Single-Byte mode, not in Multi-byte mode as
  you router do, basically, your router is trying to read the full a0h
  table in a single call, and retrieve a null response. that is normal
  and not affect the operations of the GPON ONU SFP, because these
  values are informational only. so the Software for your router should
  be able to read in Single-Byte mode to read the content of the EEPROM
  in concordance to SFF-8431

which totally misses the point that it is /not/ up to the module to
choose whether multi-byte reads are supported or not. If they bothered
to gain a proper understanding of the MSAs, they would have noticed that
the device on 0xA0 is required to behave as an Atmel AT24Cxx EEPROM.
The following from INF-8074i, which is the very first definition of the
SFP form factor modules:

  The SFP serial ID provides access to sophisticated identification
  information that describes the transceiver's capabilities, standard
  interfaces, manufacturer, and other information. The serial interface
  uses the 2-wire serial CMOS E2PROM protocol defined for the ATMEL
  AT24C01A/02/04 family of components.

As they took less than one working day to provide the above response, I
suspect they know full well that there's a problem - and it likely
affects other "routers" as well.

They're also confused about their SFF specifications. SFF-8431 is: "SFP+
10 Gb/s and Low Speed Electrical Interface" which is not the correct
specification for a 1Gbps module.

> I can imagine that vendor just says: it is working in our branded boxes
> with SFP cages and if it does not work in your kernel then problem is
> with your custom kernel and we do not care about 3rd parties.

Which shows why it's pointless producing an EEPROM validation tool that
runs under Linux (as has been your suggestion). They won't use it,
since their testing only goes as far as "does it work in our product?"

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
