Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932CD2A91AD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKFIod convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Nov 2020 03:44:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38225 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFIod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:44:33 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-68-jUwjDba8OY2VwwZx-KRtiA-1; Fri, 06 Nov 2020 08:44:27 +0000
X-MC-Unique: jUwjDba8OY2VwwZx-KRtiA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Nov 2020 08:44:20 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Nov 2020 08:44:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        "Lee Jones" <lee.jones@linaro.org>
Subject: RE: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
Thread-Topic: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
Thread-Index: AQHWs8Wc9clo0WoJVE6rwm6TlnJJWam6x96A
Date:   Fri, 6 Nov 2020 08:44:20 +0000
Message-ID: <babda61688af4f42b4a9e0fb41808272@AcuMS.aculab.com>
References: <20201104154858.1247725-1-andrew@lunn.ch>
        <20201104154858.1247725-7-andrew@lunn.ch>
 <20201105144711.40a2f8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105144711.40a2f8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski
> Sent: 05 November 2020 22:47
> 
> On Wed,  4 Nov 2020 16:48:57 +0100 Andrew Lunn wrote:
> > -	buf = (char*)((u32)skb->data & ~0x3);
> > -	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
> > -	cmdA = (((u32)skb->data & 0x3) << 16) |
> > +	offset = (unsigned long)skb->data & 3;
> > +	buf = skb->data - offset;
> > +	len = skb->len + offset;
> > +	cmdA = (offset << 16) |
> 
> The len calculation is wrong, you trusted people on the mailing list
> too much ;)

I misread what the comment-free convoluted code was doing....

Clearly it is rounding the base address down to a multiple of 4
and passing the offset in cmdA.
This is fine - but quite why the (I assume) hardware doesn't do
this itself and just document that it does a 32bit read is
another matter - the logic will be much the same and I doubt
anything modern is that pushed for space.

However rounding the length up to a multiple of 4 is buggy.
If this is an ethernet chipset it must (honest) be able to
send frames that don't end on a 4 byte boundary.
So rounding up the length is very dubious.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

