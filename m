Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5124904AF
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiAQJUU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 04:20:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:20702 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233695AbiAQJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:20:20 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-23-2CC5VzGtNxyVoTuySSDULQ-1; Mon, 17 Jan 2022 09:20:17 +0000
X-MC-Unique: 2CC5VzGtNxyVoTuySSDULQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 17 Jan 2022 09:20:16 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 17 Jan 2022 09:20:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "Jiri Pirko" <jiri@mellanox.com>
Subject: RE: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock
 protection
Thread-Topic: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock
 protection
Thread-Index: AQHYCrfJGT15ZBxssEC1JYcw+v8Nsqxm75EQ
Date:   Mon, 17 Jan 2022 09:20:16 +0000
Message-ID: <bc172b2512174b8f862c854d0d376c0c@AcuMS.aculab.com>
References: <20220116090220.2378360-1-eric.dumazet@gmail.com>
In-Reply-To: <20220116090220.2378360-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet
> Sent: 16 January 2022 09:02
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> In the past, free_fib_info() was supposed to be called
> under RTNL protection.
> 
> This eventually was no longer the case.
> 
> Instead of enforcing RTNL it seems we simply can
> move fib_info_cnt changes to occur when fib_info_lock
> is held.

This probably ought to be a stable candidate.

If an increment is lost due to the unlocked inc/dec it is
possible for the count to wrap to -1 if all fib are deleted.
That will cause the table size to be doubled on every
allocate (until the count goes +ve again).

Losing a decrement is less of a problem.
You'd need to lose a lot of them for any ill effect.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

