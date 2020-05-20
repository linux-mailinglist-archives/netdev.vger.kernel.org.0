Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84731DAE5E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgETJKa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 05:10:30 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:57863 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbgETJKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:10:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-50-tluLY8XmNuuDjM3-9TBDiA-1; Wed, 20 May 2020 10:10:26 +0100
X-MC-Unique: tluLY8XmNuuDjM3-9TBDiA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 20 May 2020 10:10:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 20 May 2020 10:10:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: RE: sctp doesn't honour net.ipv6.bindv6only
Thread-Topic: sctp doesn't honour net.ipv6.bindv6only
Thread-Index: AdYtySwMD5fuoEShRtCmkqkLr9/ogQARLsAAABzoS0A=
Date:   Wed, 20 May 2020 09:10:23 +0000
Message-ID: <2889b2f6b55f42fcaa1dc8552df33911@AcuMS.aculab.com>
References: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
 <20200519194710.GP2491@localhost.localdomain>
In-Reply-To: <20200519194710.GP2491@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 19 May 2020 20:47
> 
> On Tue, May 19, 2020 at 10:47:17AM +0000, David Laight wrote:
> > The sctp code doesn't use sk->sk_ipv6only (which is initialised
> > from net.ipv6.bindv6only) but instead uses its own flag
> 
> It actually does, via [__]ipv6_only_sock() calls since 7dab83de50c7
> ("sctp: Support ipv6only AF_INET6 sockets.").
> 
> > sp->v4mapped which always defaults to 1.
> >
> > There may also be an expectation that
> >   [gs]etsockopt(sctp_fd, IPPROTO_IPV6, IPV6_V6ONLY,...)
> > will access the flag that sctp uses internally.
> > (Matching TCP and UDP.)
> 
> My understanding is that these are slightly different.
> 
> v4mapped, if false, will allow the socket to deal with both address
> types, without mapping. If true, it will map v4 into v6.
> v6only, if false, it will do mapping for tcp/udp, but sctp won't use
> it. If true, it will deny using v4, which is complementary to v4mapped
> for sctp.
> 
> Did I miss anything?

Possibly I did, I wasn't looking much beyond the [sg]etsockopt code.
Although our code supports SCTP/IPv6 and I have tested it a bit
I don't think any of our customers use it (yet).
We default to creating IPv6 listening sockets but all the connections
are IPv4.

I think I'm still confused though:

IIRC v6only (mainly) affects listening sockets.
If 0 (the default on Linux) an IPv4 connection will 'attach to' an
IPv6 socket and the application will see v4mapped addresses [1].
If 1 the application needs to create two separate sockets to receive
both IPv4 and IPV6 connections.

I can't see how SCTP would be any different to TCP and UDP.
It can't make any sense to dual-home with a mixture of IPv4/6 addresses.

So does v4mapped just control the format of the addresses on the socket
interface when an IPv4 connection is using an IPv6 socket? 

[1] Actually, thinking further I can't remember whether this is true.
All our code allows for v4mapped addresses and decodes them for printing.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

