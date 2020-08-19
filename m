Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7217D249825
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHSIUF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 04:20:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32302 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 04:20:04 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-287-LmcQtodmMOC5j6gVLqFzVg-1; Wed, 19 Aug 2020 09:18:50 +0100
X-MC-Unique: LmcQtodmMOC5j6gVLqFzVg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 19 Aug 2020 09:18:50 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 19 Aug 2020 09:18:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: Use of genradix in sctp
Thread-Topic: Use of genradix in sctp
Thread-Index: AdZ1ckZAY2qe63tNS/O9MsxVdvHiSAALTAcAAANIG8A=
Date:   Wed, 19 Aug 2020 08:18:50 +0000
Message-ID: <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
In-Reply-To: <20200818213800.GJ906397@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:'Marcelo Ricardo Leitner
> Sent: 18 August 2020 22:38
> 
> On Tue, Aug 18, 2020 at 03:38:09PM +0000, David Laight wrote:
> > A few years ago (for 5.1) the 'arrays' that sctp uses for
> > info about data streams was changed to use the 'genradix'
> > functions.
> >
> > I'm not sure of the reason for the change, but I don't
> > thing anyone looked at the performance implications.
> 
> I don't have something like a CI for it, but I do run some performance
> benchmarks every now and then and it didn't trigger anything
> noticeable in my tests.

We have some customers who we think are sending 10000+ short
SCTP data chunks a second.
They are probably sending SMS messages, so that is 5000+ text
messages a second!
It is hard to stop those being sent with more than one
data chunk in each ethernet frame!

> Yet, can it be improved? Certainly. Patches welcomed. :-)

I'll apply some of my copious free time to it...
Actually some simple changes would help:

1) Change SCTP_SO()->x to so=SCTP_SO(); so->x in places
   where there are multiple references to the same stream.

2) Optimise the genradix lookup for the case where there
   is a single page - it can be completely inlined.

3) Defer the allocation until the stream is used.
   for outbound streams this could remove the extra buffer.

> > The code contains lots of SCTP_SI(stream, i) with the
> > probable expectation that the expansion is basically
> > stream->foo[i] (a pointer to a big memory array).
> >
> > However the genradix functions are far more complicated.
> > Basically it is a list of pointers to pages, each of
> > which is split into the maximum number of items.
> > (With the page pointers being in a tree of pages
> > for large numbers of large items.)
> >
> > So every SCTP_S[IO]() has inline code to calculate
> > the byte offset:
> > 	idx / objs_per_page * PAGE_SIZE + idx % objs_per_page * obj_size
> > (objs_per_page and obj_size are compile time constants)
> > and then calls a function to do the actual lookup.
> >
> > This is all rather horrid when the array isn't even sparse.
> >
> > I also doubt it really helps if anyone is trying to allow
> > a lot of streams. For 64k streams you might be trying to
> > allocate ~700 pages in atomic context.
> 
> Yes, and kvrealloc as you suggested on another email is not a
> solution, because it can't fallback to vmalloc in atomic contexts.
> 
> Genradix here allows it to use several non-contiguous pages, which is
> a win if compared to a simple kmalloc(..., GFP_ATOMIC) it had before
> flex_arrays, and anything that we could implement around such scheme
> would be just re-implementing genradix/flex_arrays again. After all,
> it does need 64k elements allocated.
> 
> How soon it needs them? Well, it already deferred some allocation with
> the usage of sctp_stream_out_ext (which is only allocated when the
> stream is actually used, but added another pointer deref), leaving
> just stuff couldn't be (easily) initialized later, there.
> 
> >
> > For example look at the object code for sctp_stream_clear()
> > (__genradix_ptr() is in lib/generic-radix-tree.c).
> 
> sctp_stream_clear() is rarely called.
> 
> Caller graph:
> sctp_stream_clear
>   sctp_assoc_update
>     SCTP_CMD_UPDATE_ASSOC
>       sctp_sf_do_dupcook_b
>       sctp_sf_do_dupcook_a
> 
> So, well, I'm not worried about it.

I wasn't considering the loop.
It was just a place where the object code can be looked at.

But there are quite a few places where the same stream
is looked for lots of times in succession.
Even saving the pointer is probably noticeable.

> Specs say 64k streams, so we should support that and preferrably
> without major regressions. Traversing 64k elements each time to find
> an entry is very not performant.
> 
> For a more standard use case, with something like you were saying, 17
> streams, genradix here doesn't use too much memory. I'm afraid a
> couple of integer calculations to get an offset is minimal overhead if
> compared to the rest of the code.

It is probably nearer 40 including a function call - which
is likely to cause register spills.

> For example, the stream scheduler
> operations, accessed via struct sctp_sched_ops (due to retpoline), is
> probably more interesting fixing than genradix effects here.

Hmmm... the most scheduling M3UA/M2PA (etc) want is (probably)
to send stream 0 first.
But even the use of stream 0 (for non-data messages) is a
misunderstanding (of my understanding) of what SCTP streams are.
IIRC there is only one flow control window.
I thought that tx data just got added to a single tx queue,
and the multiple streams just allowed some messages to passed
on to the receiving application while waiting for retransmissions
(head of line blocking).

OTOH M2PA seems to wand stream 0 to have the semantics of
ISO transport 'expedited data' - which can be sent even when
the main flow is blocked because it has its own credit (of 1).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

