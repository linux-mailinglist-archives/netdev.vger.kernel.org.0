Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436D433378
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfFCP0H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 11:26:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:34649 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbfFCP0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:26:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-206-3Kexq_UPNJK4r62qVQ50LA-1; Mon, 03 Jun 2019 16:26:02 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 3 Jun 2019 16:26:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Jun 2019 16:26:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'paulmck@linux.ibm.com'" <paulmck@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: rcu_read_lock lost its compiler barrier
Thread-Topic: rcu_read_lock lost its compiler barrier
Thread-Index: AQHVGehFXRQXDDgADEmCdQtcecKZ/qaJ/5iA
Date:   Mon, 3 Jun 2019 15:26:01 +0000
Message-ID: <9c0a9e2faae7404cb712f57910c8db34@AcuMS.aculab.com>
References: <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge> <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603040114.st646bujtgyu7adn@gondor.apana.org.au>
 <20190603072339.GH28207@linux.ibm.com> <20190603084214.GA1496@linux.ibm.com>
In-Reply-To: <20190603084214.GA1496@linux.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 3Kexq_UPNJK4r62qVQ50LA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul E. McKenney
> Sent: 03 June 2019 09:42
...
> On kissing the kernel goodbye, a reasonable strategy might be to
> identify the transformations that are actually occuring (like the
> stores of certain constants called out above) and fix those.

> We do
> occasionally use READ_ONCE() to prevent load-fusing optimizations that
> would otherwise cause the compiler to turn while-loops into if-statements
> guarding infinite loops.

In that case the variable ought to be volatile...

> There is also the possibility of having the
> compiler guys give us more command-line arguments.

I wonder how much the code size (of anything) would increase
if the compiler:
1) Never read a value into a local more than once.
2) Never write a value that wasn't requested by the code.
3) Never used multiple memory accesses for 'machine word' (and
   smaller) items.

(1) makes all reads READ_ONCE() except that the actual read
    can be delayed until further down the code.
    If I have a naive #define bswap32() I'd expect:
        v = bswap32(foo->bar)
    to possibly read foo->bar multiple times, but not:
        int foo_bar = foo->bar;
        v = bswap32(foo_bar);

(2) makes all writes WRITE_ONCE() except that if there are
    multiple writes to the same location, only the last need
    be done.
    In particular it stops speculative writes and the use of
    locations that are going to be written to as temporaries.
    It also stop foo->bar = ~0; being implemented as a clear
    then decrement.

(3) I'd never imagined the compiler would write the two halves
    of a word separately!

If the compiler behaved like that (as one might expect it would)
then READ_ONCE() would be a READ_NOW() for when the sequencing
mattered.

I was also recently surprised by the code I got from this loop:
    for (i = 0; i < limit; i++)
        sum64 += array32[i];
(as in the IP checksum sum without add carry support).
The compiler unrolled it to used horrid sequences of sse3/avx
instructions.
This might be a gain for large enough buffers and 'hot cache'
but for small buffer and likely cold cache it is horrid.
I guess such optimisations are valid, but I wonder how often
they are an actual win for real programs.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

