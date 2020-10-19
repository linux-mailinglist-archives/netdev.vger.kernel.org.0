Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD1292641
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgJSLOM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Oct 2020 07:14:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43133 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727249AbgJSLOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:14:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-30-AqFKCS7gOyy69YZr7eu52w-1; Mon, 19 Oct 2020 12:14:07 +0100
X-MC-Unique: AqFKCS7gOyy69YZr7eu52w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 19 Oct 2020 12:14:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 19 Oct 2020 12:14:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vladimir Oltean' <vladimir.oltean@nxp.com>
CC:     'Florian Fainelli' <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: RE: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2covbenUJHrUGBeBnvt72Q+6mcR6aAgAADAwCAAk7l4IAAEeOAgAAWErA=
Date:   Mon, 19 Oct 2020 11:14:07 +0000
Message-ID: <45ac0c697c164991a99a35a2d981b5db@AcuMS.aculab.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
 <049e7fd8f46c43819a05689fe464df25@AcuMS.aculab.com>
 <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
In-Reply-To: <20201019103047.oq5ki3jlhnwzz2xv@skbuf>
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

From: Vladimir Oltean
> Sent: 19 October 2020 11:31
> 
> On Mon, Oct 19, 2020 at 08:33:27AM +0000, David Laight wrote:
> > Is it possible to send the extra bytes from a separate buffer fragment?
> > The entire area could be allocated (coherent) when the rings are
> > allocated.
> > That would save having to modify the skb at all.
> >
> > Even if some bytes of the frame header need 'adjusting' transmitting
> > from a copy may be faster - especially on systems with an iommu.
> >
> > Many (many) moons ago we found the cutoff point for copying frames
> > on a system with an iommu to be around 1k bytes.
> 
> Please help me understand better how to implement what you're suggesting.
> DSA switches have 3 places where they might insert a tag:
> 1. Between the source MAC address and the EtherType (this is the most
>    common)
> 2. Before the destination MAC address
> 3. Before the FCS
> 
> I imagine that the most common scenario (1) is also the most difficult
> to implement using fragments, since I would need to split the Ethernet
> header from the rest of the skb data area, which might defeat the
> purpose.
> 
> Also, simply integrating these 3 code paths into something generic will
> bring challenges of its own.
> 
> Lastly, I fully expect the buffers to have proper headroom and tailroom
> now (if they don't, then it's worth investigating what's the code path
> that doesn't observe our dev->needed_headroom and dev->needed_tailroom).
> The reallocation code is there just for clones (and as far as I
> understand, fragments won't save us from the need of reallocating the
> data areas of clones), and for short frames with DSA switches in case
> (3).

If the skb are 'cloned' then I suspect you can't even put the MAC addresses
into the skb because they might be being transmitted on another interface.

OTOH TCP will have cloned the skb for retransmit so may ensure than there
isn't (still) a second reference (from an old transmit) before doing the
transmit - in which case you can write into the head/tail space.

Hmmm... I was thinking you were doing something for a specific driver.
But it looks more like it depends on what the interface is connected to.

If the MAC addresses (and ethertype) can be written into the skb head
space then it must be valid to rewrite the header containing the tag.
(With the proviso that none of the MAC drivers try to decode it again.)

One thing I have noticed is that the size of the 'headroom' for UDP
and RAWIP (where I was looking) packets depends on the final 'dev'.
This means that you can't copy the frame into an skb until you know
the 'dev' - but that might depend on the frame data.
This is a 'catch-22' problem.

I actually wonder how much the headroom varies.
It might be worth having a system-wide 'headroom' value.
A few extra bytes aren't really going to make any difference.

That might make it far less likely that there isn't the available
headroom for the tag - in which case you can just log once and discard.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

