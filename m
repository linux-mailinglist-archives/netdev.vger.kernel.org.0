Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2344490087
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 04:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbiAQDXy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Jan 2022 22:23:54 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:60199 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbiAQDXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 22:23:54 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-311-h4edUOIEOYuA5FN4UJsePg-1; Mon, 17 Jan 2022 03:23:51 +0000
X-MC-Unique: h4edUOIEOYuA5FN4UJsePg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 17 Jan 2022 03:23:50 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 17 Jan 2022 03:23:50 +0000
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
Thread-Index: AQHYCrfJGT15ZBxssEC1JYcw+v8NsqxmipoA
Date:   Mon, 17 Jan 2022 03:23:50 +0000
Message-ID: <20a08d9d62f442fcb710a2bbfae47289@AcuMS.aculab.com>
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
> In the past, free_fib_info() was supposed to be called
> under RTNL protection.
> 
> This eventually was no longer the case.
> 
> Instead of enforcing RTNL it seems we simply can
> move fib_info_cnt changes to occur when fib_info_lock
> is held.
> 
> v2: David Laight suggested to update fib_info_cnt
> only when an entry is added/deleted to/from the hash table,
> as fib_info_cnt is used to make sure hash table size
> is optimal.

Already applied, but
acked-by: David Laight

...
If you are going to add READ_ONCE() markers then one on
'fib_info_hash_size' would be much more appropriate since
this value is used twice.

>  	err = -ENOBUFS;
> -	if (fib_info_cnt >= fib_info_hash_size) {
> +
> +	/* Paired with WRITE_ONCE() in fib_release_info() */
> +	if (READ_ONCE(fib_info_cnt) >= fib_info_hash_size) {
>  		unsigned int new_size = fib_info_hash_size << 1;
>  		struct hlist_head *new_info_hash;
>  		struct hlist_head *new_laddrhash;
> @@ -1462,7 +1467,6 @@ struct fib_info *fib_create_info(struct fib_config *cfg,

If is also possible for two (or many) threads to decide to
increase the hash table size at the same time.

The code that moves the items to the new hash tables should
probably discard the new tables is they aren't larger than
the existing ones.
The copy does look safe - just a waste of time.

It is also technically possible (but very unlikely) that the table
will get shrunk!
It will grow again on the next allocate.

But this is a different bug.

I also though Linus said that the WRITE_ONCE() weren't needed
here because the kernel basically assumes the compiler isn't
stupid enough to do 'write tearing' on word sized items
(or just write zero before every write).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

