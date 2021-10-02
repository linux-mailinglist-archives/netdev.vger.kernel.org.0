Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489FA41FCE5
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 17:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhJBP4r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Oct 2021 11:56:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:29389 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233545AbhJBP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 11:56:46 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-JWS7r0F4PKqKFlaZpOK-Xw-1; Sat, 02 Oct 2021 16:54:56 +0100
X-MC-Unique: JWS7r0F4PKqKFlaZpOK-Xw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Sat, 2 Oct 2021 16:54:54 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Sat, 2 Oct 2021 16:54:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Florian Weimer' <fweimer@redhat.com>,
        "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: RE: Non-packed structures in IP headers
Thread-Topic: Non-packed structures in IP headers
Thread-Index: AQHXtwBfS5Uh4qQ3iEK5aIu8W7utVau/29dA
Date:   Sat, 2 Oct 2021 15:54:54 +0000
Message-ID: <a8082bcaeb534ee5b24ea6dae4428547@AcuMS.aculab.com>
References: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
 <87bl48v74v.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87bl48v74v.fsf@oldenburg.str.redhat.com>
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

From: Florian Weimer
> Sent: 01 October 2021 21:10
> 
> * Carles Cufi:
> 
> > I was looking through the structures for IPv{4,6} packet headers and
> > noticed that several of those that seem to be used to parse a packet
> > directly from the wire are not declared as packed. This surprised me
> > because, although I did find that provisions are made so that the
> > alignment of the structure, it is still technically possible for the
> > compiler to inject padding bytes inside those structures, since AFAIK
> > the C standard makes no guarantees about padding unless it's
> > instructed to pack the structure.
> 
> The C standards do not make such guarantees, but the platform ABI
> standards describe struct layout and ensure that there is no padding.
> Linux relies on that not just for networking, but also for the userspace
> ABI, support for separately compiled kernel modules, and in other
> places.

In particular structures are used to map hardware register blocks.

> Sometimes there are alignment concerns in the way these structs are
> used, but I believe the kernel generally controls placement of the data
> that is being worked on, so that does not matter, either.
> 
> Therefore, I do not believe this is an actual problem.

And adding __packed forces the compiler to do byte accesses
(with shifts) on cpu that don't support misaligned memory accesses.

So it really is wrong to specify __packed unless the structure
can be unaligned in memory, or has a 'broken' definition
that has fields that aren't 'naturally aligned'.
In the latter case it is enough to mark the field that requires
the padding before it removed as (IIRC) __aligned(1).
The compiler will then remove the padding but still assume the
field is partially aligned - so my do two 32bit access instead
of 8 8bit ones).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

