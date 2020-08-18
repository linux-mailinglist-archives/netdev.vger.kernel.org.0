Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CD3248031
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRIIf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 04:08:35 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60873 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgHRII3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:08:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-172-q1b5FOGUNN6Evg-arIgRjA-1; Tue, 18 Aug 2020 09:08:25 +0100
X-MC-Unique: q1b5FOGUNN6Evg-arIgRjA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 09:08:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 09:08:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: sctp: num_ostreams and max_instreams negotiation
Thread-Topic: sctp: num_ostreams and max_instreams negotiation
Thread-Index: AdZyPjABix+HSvLeTmG2b9Vg1HRq1AAFgglgAC9e6TAAZIGjOAAkANEA
Date:   Tue, 18 Aug 2020 08:08:24 +0000
Message-ID: <e438e08865a04eac92dde5ba8ce1dbf2@AcuMS.aculab.com>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
 <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
 <20200817142223.GH3399@localhost.localdomain>
 <20200817143554.GI3399@localhost.localdomain>
In-Reply-To: <20200817143554.GI3399@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 17 August 2020 15:36
..
> > The proper fix here is to move back to the original if() condition,
> > and put genradix_prealloc() inside it again, as was fa_zero() before.
> > The if() is not strictly needed, because genradix_prealloc() will
> > handle it nicely, but it's a nice-to-have optimization anyway.
> >
> > Do you want to send a patch?

I can, but my systems aren't really setup for doing it.
Especially while working from home.

Just deleting the conditionals works for normal connections.
I don't know what happens if the number of streams is negotiated
up and down (and up again?) while the connection is active.

> Note the thread 'Subject: RE: v5.3.12 SCTP Stream Negotiation Problem'
> though.

The patch you suggested contained a typo:

-	if (incnt <= stream->incnt)
-		return 0;
+	if (incnt > stream->incnt)
+		goto out;

So the 'in' array was never allocated.

The code will still allocate a 'big' array which I think used
to get shrunk when the value from the peer was processed.
I suspect the array need not get allocated until after
that is done (ISTR in process_init).

I also suspect that the genradix lookup is more expensive
than the sctp code expects.
I wonder if a straight forward kvmalloc() wouldn't be better.
You'd actually need kvrealloc().

All the sctp connections we use have a max of 17 streams.
But if someone allocates 64k and then uses them sparsely
it still allocates about 700 pages for the genradix arrays.

Also, since the 'gfp' flags are being passed in, I suspect
the allocate happens in atomic context somewhere.
I bet allocating 700 pages is very likely to fail!
Lazy allocation would only require single pages be allocated,
but would need extra error paths.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

