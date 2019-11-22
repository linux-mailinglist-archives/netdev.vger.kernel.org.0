Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8923F106FCB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 12:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfKVLR5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Nov 2019 06:17:57 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48879 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbfKVLR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 06:17:56 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-67-7umQ3wvKPsm7jLHIlIOsjw-1; Fri, 22 Nov 2019 11:17:52 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 22 Nov 2019 11:17:51 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 22 Nov 2019 11:17:51 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     network dev <netdev@vger.kernel.org>
Subject: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQ==
Date:   Fri, 22 Nov 2019 11:17:51 +0000
Message-ID: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 7umQ3wvKPsm7jLHIlIOsjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to optimise some code that reads UDP messages (RTP and RTCP) from a lot of sockets.
The 'normal' data pattern is that there is no data on half the sockets (RTCP) and
one message every 20ms on the others (RTP).
However there can be more than one message on each socket, and they all need to be read.
Since the code processing the data runs every 10ms, the message receiving code
also runs every 10ms (a massive gain when using poll()).

While using recvmmsg() to read multiple messages might seem a good idea, it is much
slower than recv() when there is only one message (even recvmsg() is a lot slower).
(I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
and faffing with the user iov[].)

So using poll() we repoll the fd after calling recv() to find is there is a second message.
However the second poll has a significant performance cost (but less than using recvmmsg()).

If we use epoll() in level triggered mode a second epoll_wait() call (after the recv()) will
indicate that there is more data.

For poll() it doesn't make much difference how many fd are supplied to each system call.
The overall performance is much the same for 32, 64 or 500 (all the sockets).

For epoll_wait() that isn't true.
Supplying a buffer that is shorter than the list of 'ready' fds gives a massive penalty.
With a buffer long enough for all the events epoll() is somewhat faster than poll().
But with a 64 entry buffer it is much slower.
I've looked at the code and can't see why splicing the unread events back is expensive.

I'd like to be able to change the code so that multiple threads are reading from the epoll fd.
This would mean I'd have to run it in edge mode and each thread reading a smallish
block of events.
Any suggestions on how to efficiently read the 'unusual' additional messages from
the sockets?

FWIW the fastest way to read 1 RTP message every 20ms is to do non-blocking recv() every 10ms.
The failing recv() is actually faster than either epoll() or two poll() actions.
(Although something is needed to pick up the occasional second message.) 

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

