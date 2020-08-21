Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5C24E2C4
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgHUVj2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Aug 2020 17:39:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:24982 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgHUVj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:39:28 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-221-Ovfv65qLMDOzSh5mErwndw-1; Fri, 21 Aug 2020 22:39:24 +0100
X-MC-Unique: Ovfv65qLMDOzSh5mErwndw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 21 Aug 2020 22:39:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 21 Aug 2020 22:39:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: Use of genradix in sctp
Thread-Topic: Use of genradix in sctp
Thread-Index: AdZ1ckZAY2qe63tNS/O9MsxVdvHiSAALTAcAAANIG8AAkcwnAAADgzyw
Date:   Fri, 21 Aug 2020 21:39:23 +0000
Message-ID: <11eafe393bc640a8bbddf33d0e784901@AcuMS.aculab.com>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
 <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
 <20200821204636.GO3399@localhost.localdomain>
In-Reply-To: <20200821204636.GO3399@localhost.localdomain>
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

From: 'Marcelo Ricardo Leitner'
> Sent: 21 August 2020 21:47
...
> > 3) Defer the allocation until the stream is used.
> >    for outbound streams this could remove the extra buffer.
> 
> This can be tricky. What should happen if it gets a packet on a stream
> that it couldn't allocate, and then another on a stream that was
> already allocated? Just a drop, it will retransmit and recover, and
> then again.. While, OTOH, if the application requested such amount of
> streams, it is likely going to use it. If not, that's an application
> bug.

You'd probably need to (effectively) drop the ethernet frame
that contained the chunk.

But the problem I see is that GFP flags are passed in.
So there must me a path where the allocation can't sleep.
Now allocating a couple of pages is fine but if the
maximum is just over 300 for each of 'in' and 'out'.
I can well imagine that is likely to fail.
I suspect this happens because the remote system can
(if my quick scan of the code is right) negotiate a
much larger number on an active connection.

I don't know what applications might be doing such things.
But I can imagine someone will try to negotiate 64k-1
streams just because that is the maximum.
And/or deciding to use stream 65535 for 'special' traffic.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

