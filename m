Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C75E1B2D9
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfEMJ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:28:13 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:19484 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbfEMJ2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:28:13 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 56CED37B5;
        Mon, 13 May 2019 11:28:09 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 281a2c16;
        Mon, 13 May 2019 11:28:07 +0200 (CEST)
Date:   Mon, 13 May 2019 11:28:07 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
Message-ID: <20190513092807.GX81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
 <20190512121910.432t2vncvmpu26qg@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190512121910.432t2vncvmpu26qg@flea>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxime Ripard <maxime.ripard@bootlin.com> [2019-05-12 14:19:10]:

> > @@ -29,6 +31,19 @@ Optional properties:
> >  bits:  Is pair of bit location and number of bits, which specifies offset
> >         in bit and number of bits within the address range specified by reg property.
> >         Offset takes values from 0-7.
> > +byte-indices: array, encoded as an arbitrary number of (offset, length) pairs,
> > +            within the address range specified by reg property. Each pair is
> > +            then processed with byte-transform in order to produce single u8
> > +            sized byte.
> > +byte-transform: string, specifies the transformation which should be applied
> > +              to every byte-indices pair in order to produce usable u8 sized byte,
> > +              possible values are "none", "ascii" and "bcd". Default is "none".
> > +byte-adjust: number, value by which should be adjusted resulting output byte at
> > +           byte-adjust-at offset.
> > +byte-adjust-at: number, specifies offset of resulting output byte which should be
> > +              adjusted by byte-adjust value, default is 0.
> > +byte-result-swap: boolean, specifies if the resulting output bytes should be
> > +                swapped prior to return
> >
> >  For example:
> >
> > @@ -59,6 +74,36 @@ For example:
> >                 ...
> >         };
> >
> > +Another example where we've MAC address for eth1 stored in the NOR EEPROM as
> > +following sequence of bytes (output of hexdump -C /dev/mtdX):
> > +
> > + 00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
> > + 00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|
> > +
> > +Which means, that MAC address is stored in EEPROM as D4:EE:07:33:6C:20, so
> > +ASCII delimited by colons, but we can't use this MAC address directly as
> > +there's only one MAC address stored in the EEPROM and we need to increment last
> > +octet/byte in this address in order to get usable MAC address for eth1 device.
> > +
> > + eth1_addr: eth-mac-addr@18a {
> > +     reg = <0x18a 0x11>;
> > +     byte-indices = < 0 2
> > +                      3 2
> > +                      6 2
> > +                      9 2
> > +                     12 2
> > +                     15 2>;
> > +     byte-transform = "ascii";
> > +     byte-increment = <1>;
> > +     byte-increment-at = <5>;
> > +     byte-result-swap;
> > + };
> > +
> > + &eth1 {
> > +     nvmem-cells = <&eth1_addr>;
> > +     nvmem-cell-names = "mac-address";
> > + };
> > +
> 
> Something along those lines yes. I'm not sure why in your example the
> cell doesn't start at the mac address itself, instead of starting at
> the key + having to specify an offset though. The reg property is the
> offset already.

The cell starts at the MAC address itself, 0x180 is offset within the EEPROM
and 0xa is byte within the offset (off-by-one, correct should be 0x9 though).

  EEPROM                 byte within EEPROM offset
  offset    1  2  3  4  5  5  6  7   8  9  a  b  c  d  e  f
 ------------------------------------------------------------|-----------------
 00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
 00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|

So this would produce following:

 eth1_addr: eth-mac-addr@189 {
    reg = <0x189 0x11>;         /* 0x44 0x34 0x3a 0x45 0x45 0x3a 0x30 0x37
                                 * 0x3a 0x33 0x33 0x3a 0x36 0x43 0x3a 0x32 0x30 */
    byte-indices = < 0 2        /* 0x44 0x34 */
                     3 2        /* 0x45 0x45 */
                     6 2        /* 0x30 0x37 */
                     9 2        /* 0x33 0x33 */
                    12 2        /* 0x36 0x43 */
                    15 2>;      /* 0x32 0x30 */
    byte-transform = "ascii";   /* 0xd4 0xee 0x7 0x33 0x6c 0x20 */
    byte-increment = <1>;
    byte-increment-at = <5>;    /* 0xd4 0xee 0x7 0x33 0x6c 0x21 */
    byte-result-swap;           /* 0x21 0x6c 0x33 0x7 0xee 0xd4 */
 };

-- ynezz
