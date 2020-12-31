Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA42E810B
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 16:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgLaPlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 10:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgLaPlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 10:41:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041A5223DB;
        Thu, 31 Dec 2020 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609429233;
        bh=58vn7OFcrfeh9DagXwzYykT0BK0kzXMv6GeOH8DES68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYe/JdhIT94o74h3eJzIcycX2Vd75v4zEl6TgASqpdutcQYFe2kq9VTYSlaDQmeRb
         Bf2x3AB/fXndM+NS6hq/7hdBzyBzhmFtsHuuyLRTWa4zZ90P3Btp8Kt11l/9Ejdyi+
         jgpzKMijudtBcuZdkibBZ+bJ5PiQhYgeB5c8BCFnlsqc73npSsYgthmr6nanLSxR1S
         wAqO9tghQ8SEFuAxcXnuoIdJ3KHIApmX8l5bjBsz32jfMfT5wOm9jGfUBtd2b8umV3
         CWJGXX4tplwlmwxN66QJqBQzE89ferlabVesa7tfibpNFZH8gcBf6WT+Ke5vrPjdsK
         CdHROb3MsyfEA==
Received: by pali.im (Postfix)
        id DDD1BC35; Thu, 31 Dec 2020 16:40:30 +0100 (CET)
Date:   Thu, 31 Dec 2020 16:40:30 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201231154030.tbofxtq4ravct4sg@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ppQhbjCGFzs6P@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X+3ppQhbjCGFzs6P@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 31 December 2020 16:09:25 Andrew Lunn wrote:
> On Thu, Dec 31, 2020 at 01:14:10PM +0100, Pali Rohár wrote:
> > On Wednesday 30 December 2020 19:09:58 Russell King - ARM Linux admin wrote:
> > > On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> > > > On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > > > > Hi Pali
> > > > > 
> > > > > I have to agree with Russell here. I would rather have no diagnostics
> > > > > than untrustable diagnostics.
> > > > 
> > > > Ok!
> > > > 
> > > > So should we completely skip hwmon_device_register_with_info() call
> > > > if (i2c_block_size < 2) ?
> > > 
> > > I don't think that alone is sufficient - there's also the matter of
> > > ethtool -m which will dump that information as well, and we don't want
> > > to offer it to userspace in an unreliable form.
> > 
> > Any idea/preference how to disable access to these registers?
> > 
> > > For reference, here is what SFF-8472 which defines the diagnostics, says
> > > about this:
> > > 
> > >   To guarantee coherency of the diagnostic monitoring data, the host is
> > >   required to retrieve any multi-byte fields from the diagnostic
> > >   monitoring data structure (IE: Rx Power MSB - byte 104 in A2h, Rx Power
> > >   LSB - byte 105 in A2h) by the use of a single two-byte read sequence
> > >   across the two-wire interface interface.
> > > 
> > >   The transceiver is required to ensure that any multi-byte fields which
> > >   are updated with diagnostic monitoring data (e.g. Rx Power MSB - byte
> > >   104 in A2h, Rx Power LSB - byte 105 in A2h) must have this update done
> > >   in a fashion which guarantees coherency and consistency of the data. In
> > >   other words, the update of a multi-byte field by the transceiver must
> > >   not occur such that a partially updated multi-byte field can be
> > >   transferred to the host. Also, the transceiver shall not update a
> > >   multi-byte field within the structure during the transfer of that
> > >   multi-byte field to the host, such that partially updated data would be
> > >   transferred to the host.
> > > 
> > > The first paragraph is extremely definitive in how these fields shall
> > > be read atomically - by a _single_ two-byte read sequence. From what
> > > you are telling us, these modules do not support that. Therefore, by
> > > definition, they do *not* support proper and reliable reporting of
> > > diagnostic data, and are non-conformant with the SFP MSAs.
> > > 
> > > So, they are basically broken, and the diagnostics can't be used to
> > > retrieve data that can be said to be useful.
> > 
> > I agree they are broken. We really should disable access to those 16bit
> > registers.
> > 
> > Anyway here is "datasheet" to some CarlitoxxPro SFP:
> > https://www.docdroid.net/hRsJ560/cpgos03-0490v2-datasheet-10-pdf
> > 
> > And on page 10 is written:
> > 
> >     The I2C system can support the mode of random address / single
> >     byteread which conform to SFF-8431.
> > 
> > Which seems to be wrong.
> 
> Searching around, i found:
> 
> http://read.pudn.com/downloads776/doc/3073304/RTL9601B-CG_Datasheet.pdf
> 
> It has two i2c busses, a master and a slave. The master bus can do
> multi-byte transfers. The slave bus description says nothing in words
> about multi-byte transfers, but the diagram shows only single byte
> transfers.

Yes. Only i2c slave is used for communication with external entity and
diagrams clearly shows that only single byte i2c transfers are
supported.

> So any SFP based around this device is broken.

Exactly. That is why I send this patch in a way that try to detect these
RTL chips and not particular vendors who create product on top of this
chip.

All SFP modules with this RTL9601B chip are broken and cannot be fixed.

Re-branders and OEM vendors like CarlitoxxPro or UBNT should stop saying
that they are compliant to SFP/SFF standards, because based on above
descriptions it is not truth.

> The silly thing is, it is reading/writing from a shadow SRAM. The CPU
> is not directly involved in an I2C transaction. So it could easily
> read multiple bytes from the SRAM and return them. But it would still
> need a synchronisation method to handle writes from the CPU to the
> SRAM, in order to make these word values safe.

But there is a still issue how to read these values from SRAM outside of
SFP module via i2c. And with current one-byte transfers of that i2c
slave on RTL9601B it is impossible via current SFP diagnostic API
specification.
