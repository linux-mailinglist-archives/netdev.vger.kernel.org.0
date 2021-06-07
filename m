Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8649839DD77
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFGNTH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Jun 2021 09:19:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:35287 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230227AbhFGNTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:19:06 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-232-PLAYMgjKODCUrXQ11EE9cw-1; Mon, 07 Jun 2021 14:17:12 +0100
X-MC-Unique: PLAYMgjKODCUrXQ11EE9cw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Mon, 7 Jun 2021 14:17:11 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Mon, 7 Jun 2021 14:17:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     'Koba Ko' <koba.ko@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8169: introduce polling method for link change
Thread-Topic: [PATCH] r8169: introduce polling method for link change
Thread-Index: AQHXW1Z1J4XkbqR7K0q4sy48RuQacKsIelDA///1bwCAABSCIA==
Date:   Mon, 7 Jun 2021 13:17:11 +0000
Message-ID: <85afdf3eb2de443da78f6c10c8eb4dc7@AcuMS.aculab.com>
References: <20210603025414.226526-1-koba.ko@canonical.com>
 <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com>
 <CAJB-X+V4vpLoNt2C_i=3mS4UtFnDdro5+hgaFXHWxcvobO=pzg@mail.gmail.com>
 <f969a075-25a1-84ba-daad-b4ed0e7f75f5@gmail.com>
 <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
 <bfc68450-422d-1968-1316-64f7eaa7cbe9@gmail.com>
 <CAJB-X+UDRK5-fKEGc+PS+_02HePmb34Pw_+tMyNr_iGGeE+jbQ@mail.gmail.com>
 <16f24c21776a4772ac41e6d3e0a9150c@AcuMS.aculab.com>
 <YL4V6jak3TYxDPg8@lunn.ch>
In-Reply-To: <YL4V6jak3TYxDPg8@lunn.ch>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn
> Sent: 07 June 2021 13:50
> 
> On Mon, Jun 07, 2021 at 12:32:29PM +0000, David Laight wrote:
> > From: Koba Ko
> > > Sent: 07 June 2021 05:35
> > ...
> > > After consulting with REALTEK, I can identify RTL8106e by PCI_VENDOR
> > > REALTEK, DEVICE 0x8136, Revision 0x7.
> > > I would like to make PHY_POLL as default for RTL8106E on V2.
> > > because there's no side effects besides the cpu usage rate would be a
> > > little higher,
> > > How do you think?
> >
> > If reading the PHY registers involves a software bit-bang
> > of an MII register (rather than, say, a sleep for interrupt
> > while the MAC unit does the bit-bang) then you can clobber
> > interrupt latency because of all the time spent spinning.
> 
> That is not what PHY IRQ/POLL means in the PHY subsystem.
> 
> Many PHYs don't actually have there interrupt output connected to a
> GPIO. This is partially because 803.2 C22 and C45 standards don't
> define interrupts. Each vendor which supports interrupts uses
> proprietary registers. So by default, the PHY subsystem will poll the
> status of the PHY once per second to see if the link has changed
> state. If the combination of PHY hardware, board hardware and PHY
> driver does have interrupts, the PHY subsystem will not poll, but wait
> for an interrupt, and then check the status of the link.

I know. I might be 30 years since I wrote anything to read MII
but I don't remember seeing anything that made it less horrid.

One of the MAC units (probably AMD lance based) could be configured
to repeatedly read one PHY register and generate a MAC interrupt
if it changed - but I've not seen that on some later MAC chips.

> As for MII bus masters, i only know of one which is interrupt driven,
> rather than polled IO, for completion. The hardware is clocking out 64
> bits at 2.5MHz. So it is done rather quickly. I profiled that one
> using interrupts, and the overhead of dealing with the interrupt is
> bigger than polling.

64 bits at 2.5MHz is some 64000 cpu clocks - not inconsiderable.

It has to be said that I don't know how to solve the delays
associated with software bit-bang (apart from persuading the
hardware engineers it isn't a good idea).
With my 'hardware engineer' hat on (I'm currently (ir)responsible
for some FPGA internals as well as the drivers) the logic to
do things like I2C (etc) reads and writes from fpga memory
sits in a tiny corner of a modern device.

One possibility for 'slow polls' is to do them slowly!
One edge per timer tick - although 'tickless' probably
kills that.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

