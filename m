Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C203167B14
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgBUKqs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Feb 2020 05:46:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44839 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgBUKqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 05:46:47 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-6-_yAAOt4EOhSflertEiZEPg-1; Fri, 21 Feb 2020 10:46:43 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 21 Feb 2020 10:46:42 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 21 Feb 2020 10:46:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kuniyuki Iwashima' <kuniyu@amazon.co.jp>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuni1840@gmail.com" <kuni1840@gmail.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "osa-contribution-log@amazon.com" <osa-contribution-log@amazon.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: RE: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Thread-Topic: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Thread-Index: AQHV6AFTighrXj68Q0S8xkdYh/UVXqgkUKtwgAEbNoCAAAn3MA==
Date:   Fri, 21 Feb 2020 10:46:42 +0000
Message-ID: <e9e755abf80f4fb78f6be494b0529347@AcuMS.aculab.com>
References: <2aead5c10d7c4bc6b80bbc5f079bef8e@AcuMS.aculab.com>
 <20200221100155.76241-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200221100155.76241-1-kuniyu@amazon.co.jp>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: _yAAOt4EOhSflertEiZEPg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima
> Sent: 21 February 2020 10:02
> 
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Thu, 20 Feb 2020 17:11:46 +0000
> > From: Kuniyuki Iwashima
> > > Sent: 20 February 2020 15:20
> > >
> > > Currently we fail to bind sockets to ephemeral ports when all of the ports
> > > are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> > > we still have a chance to connect to the different remote hosts.
> > >
> > > The second and third patches fix the behaviour to fully utilize all space
> > > of the local (addr, port) tuples.
> >
> > Would it make sense to only do this for the implicit bind() done
> > when connect() is called on an unbound socket?
> > In that case only the quadruplet of the local and remote addresses
> > needs to be unique.
> 
> The function to reserve a epehemral port is different between bind() and
> connect().
> 
>   bind    : inet_csk_find_open_port
>   connect : __inet_hash_connect
> 
> The connect() cannot use ports which are consumed by bind()
> because __inet_hash_connect() fails to get a port if tb->fastreuse or
> or tb->fastreuseport is not -1, which only __inet_hash_connect() sets.
> On the other hand, bind() can use ports which are used by connect().

Fixing that asymmetry may make more sense.
Since the final state can already exist.
No need for SO_REUSADDR to be checked at all.

> Moreover, we can call bind() before connect() to decide which IP to use.
> By setting IP_BIND_ADDRESS_NO_PORT to socket, we can defer getting a port
> until connect() is called. However, this means that getting port
> is done by __inet_hash_connect, so that connect() may fail to get a local
> port if it is reserved by bind(). So if we want to reuse ports consumed by
> bind(), we have to call bind() to get ports.
> 
> Without this patch, we may fail to get a ephemeral port and to fail to
> bind() in such case we should be able to reuse a local port when connecting
> to remote hosts.

I suspect that opens some security holes.
There is nothing to stop you trying to call listen() (etc).

SO_REUSADDR is pretty limited (for good reason).
I normally set it on listening sockets so that the daemon can be
restarted while old connections are lurking (usually in a FIN_WAIT state).
But even that probably opens some 'holes'.

You really don't want to be allocating an ephemeral port before connect().
I'm pretty sure you can't 'unconnect' a socket leaving is bound (and usable).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

