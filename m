Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5FC2B7A32
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgKRJS3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Nov 2020 04:18:29 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52265 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgKRJS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:18:29 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-94-FSSv3gobMvWUdqkIex0ELA-1; Wed, 18 Nov 2020 09:18:25 +0000
X-MC-Unique: FSSv3gobMvWUdqkIex0ELA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 18 Nov 2020 09:18:24 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 18 Nov 2020 09:18:24 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kuniyuki Iwashima' <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Thread-Topic: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Thread-Index: AQHWvMXedAT5e1uWx0Go2ulX1CPcBqnNnI0w
Date:   Wed, 18 Nov 2020 09:18:24 +0000
Message-ID: <01a5c211a87a4dd69940e19c2ff00334@AcuMS.aculab.com>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
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

From: Kuniyuki Iwashima
> Sent: 17 November 2020 09:40
> 
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation. When a SYN packet is received, the connection is tied to a
> listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners could accept such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in
> in-flight ACK of 3WHS is responded by RST.

Can't you do something to stop new connections being queued (like
setting the 'backlog' to zero), then carry on doing accept()s
for a guard time (or until the queue length is zero) before finally
closing the listening socket.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

