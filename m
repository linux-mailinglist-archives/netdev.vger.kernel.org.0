Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3440F248A04
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgHRPiO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 11:38:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59467 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726624AbgHRPiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:38:13 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-46-sOLneJyYMye81YaMlQPUsg-1; Tue, 18 Aug 2020 16:38:09 +0100
X-MC-Unique: sOLneJyYMye81YaMlQPUsg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 16:38:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 16:38:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Use of genradix in sctp
Thread-Topic: Use of genradix in sctp
Thread-Index: AdZ1ckZAY2qe63tNS/O9MsxVdvHiSA==
Date:   Tue, 18 Aug 2020 15:38:09 +0000
Message-ID: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
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

A few years ago (for 5.1) the 'arrays' that sctp uses for
info about data streams was changed to use the 'genradix'
functions.

I'm not sure of the reason for the change, but I don't
thing anyone looked at the performance implications.

The code contains lots of SCTP_SI(stream, i) with the
probable expectation that the expansion is basically
stream->foo[i] (a pointer to a big memory array).

However the genradix functions are far more complicated.
Basically it is a list of pointers to pages, each of
which is split into the maximum number of items.
(With the page pointers being in a tree of pages
for large numbers of large items.)

So every SCTP_S[IO]() has inline code to calculate
the byte offset:
	idx / objs_per_page * PAGE_SIZE + idx % objs_per_page * obj_size
(objs_per_page and obj_size are compile time constants)
and then calls a function to do the actual lookup.

This is all rather horrid when the array isn't even sparse.

I also doubt it really helps if anyone is trying to allow
a lot of streams. For 64k streams you might be trying to
allocate ~700 pages in atomic context.

For example look at the object code for sctp_stream_clear()
(__genradix_ptr() is in lib/generic-radix-tree.c).

There is only one other piece of code that uses genradix.
All it needs is a fifo list.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

