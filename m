Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6461A2E80CC
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 16:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgLaPKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 10:10:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgLaPKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 10:10:14 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuzZt-00FFaw-Bj; Thu, 31 Dec 2020 16:09:25 +0100
Date:   Thu, 31 Dec 2020 16:09:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X+3ppQhbjCGFzs6P@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201231121410.2xlxtyqjelrlysd2@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 01:14:10PM +0100, Pali Rohár wrote:
> On Wednesday 30 December 2020 19:09:58 Russell King - ARM Linux admin wrote:
> > On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> > > On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > > > Hi Pali
> > > > 
> > > > I have to agree with Russell here. I would rather have no diagnostics
> > > > than untrustable diagnostics.
> > > 
> > > Ok!
> > > 
> > > So should we completely skip hwmon_device_register_with_info() call
> > > if (i2c_block_size < 2) ?
> > 
> > I don't think that alone is sufficient - there's also the matter of
> > ethtool -m which will dump that information as well, and we don't want
> > to offer it to userspace in an unreliable form.
> 
> Any idea/preference how to disable access to these registers?
> 
> > For reference, here is what SFF-8472 which defines the diagnostics, says
> > about this:
> > 
> >   To guarantee coherency of the diagnostic monitoring data, the host is
> >   required to retrieve any multi-byte fields from the diagnostic
> >   monitoring data structure (IE: Rx Power MSB - byte 104 in A2h, Rx Power
> >   LSB - byte 105 in A2h) by the use of a single two-byte read sequence
> >   across the two-wire interface interface.
> > 
> >   The transceiver is required to ensure that any multi-byte fields which
> >   are updated with diagnostic monitoring data (e.g. Rx Power MSB - byte
> >   104 in A2h, Rx Power LSB - byte 105 in A2h) must have this update done
> >   in a fashion which guarantees coherency and consistency of the data. In
> >   other words, the update of a multi-byte field by the transceiver must
> >   not occur such that a partially updated multi-byte field can be
> >   transferred to the host. Also, the transceiver shall not update a
> >   multi-byte field within the structure during the transfer of that
> >   multi-byte field to the host, such that partially updated data would be
> >   transferred to the host.
> > 
> > The first paragraph is extremely definitive in how these fields shall
> > be read atomically - by a _single_ two-byte read sequence. From what
> > you are telling us, these modules do not support that. Therefore, by
> > definition, they do *not* support proper and reliable reporting of
> > diagnostic data, and are non-conformant with the SFP MSAs.
> > 
> > So, they are basically broken, and the diagnostics can't be used to
> > retrieve data that can be said to be useful.
> 
> I agree they are broken. We really should disable access to those 16bit
> registers.
> 
> Anyway here is "datasheet" to some CarlitoxxPro SFP:
> https://www.docdroid.net/hRsJ560/cpgos03-0490v2-datasheet-10-pdf
> 
> And on page 10 is written:
> 
>     The I2C system can support the mode of random address / single
>     byteread which conform to SFF-8431.
> 
> Which seems to be wrong.

Searching around, i found:

http://read.pudn.com/downloads776/doc/3073304/RTL9601B-CG_Datasheet.pdf

It has two i2c busses, a master and a slave. The master bus can do
multi-byte transfers. The slave bus description says nothing in words
about multi-byte transfers, but the diagram shows only single byte
transfers.

So any SFP based around this device is broken.

The silly thing is, it is reading/writing from a shadow SRAM. The CPU
is not directly involved in an I2C transaction. So it could easily
read multiple bytes from the SRAM and return them. But it would still
need a synchronisation method to handle writes from the CPU to the
SRAM, in order to make these word values safe.

      Andrew
