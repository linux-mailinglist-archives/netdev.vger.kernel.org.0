Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B510D49FE13
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349916AbiA1Qbi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jan 2022 11:31:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:28422 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231221AbiA1Qbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:31:37 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-282-NOutcp0EONG3gEpHng3j6g-1; Fri, 28 Jan 2022 16:31:34 +0000
X-MC-Unique: NOutcp0EONG3gEpHng3j6g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 28 Jan 2022 16:31:32 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 28 Jan 2022 16:31:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Thread-Topic: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Thread-Index: AQHYFDTJs9bxk0Q5BUyDnjGXsateMqx4d6SwgAAjK/GAAAR/gA==
Date:   Fri, 28 Jan 2022 16:31:32 +0000
Message-ID: <29f644f8322e4d79ad861a8347ddea0d@AcuMS.aculab.com>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
 <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
 <87k0ejc0ol.fsf@waldekranz.com> <YfQVg4mYYT9iop3x@lunn.ch>
In-Reply-To: <YfQVg4mYYT9iop3x@lunn.ch>
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
> Sent: 28 January 2022 16:11
> 
> On Fri, Jan 28, 2022 at 04:58:02PM +0100, Tobias Waldekranz wrote:
> > On Fri, Jan 28, 2022 at 14:10, David Laight <David.Laight@ACULAB.COM> wrote:
> > > From: Tobias Waldekranz
> > >> Sent: 28 January 2022 10:50
> > >>
> > >> The individual patches have all the details. This work was triggered
> > >> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
> > >> module.
> > >>
> > >> The first patch gets rid of most of that time by replacing a very long
> > >> delay with a tighter poll loop to wait for the busy bit to clear.
> > >>
> > >> The second patch shaves off some more time by avoiding redundant
> > >> busy-bit-checks, saving 1 out of 4 MDIO operations for every register
> > >> read/write in the optimal case.
> > >
> > > I don't think you should fast-poll for the entire timeout period.
> > > Much better to drop to a usleep_range() after the first 2 (or 3)
> > > reads fail.
> >
> > You could, I suppose. Andrew, do you want a v3?
> 
> You have i available, so it would be a simple change. So yes please.
> 
> But saying that, it seems like if the switch does not complete within
> 2 polls, it is likely to be dead and we are about to start a cascade
> of failures. We probably don't care about a bit of CPU usage when the
> devices purpose in being has just stopped working.

But you don't want to destroy everything else on the system while
all the requests are failing either.
(I've also just seen v3)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

