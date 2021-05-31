Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E9D395922
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhEaKnd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 31 May 2021 06:43:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:35864 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231529AbhEaKnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:43:05 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-0wYY4wymNmmsRwAcyPod2Q-1; Mon, 31 May 2021 11:41:21 +0100
X-MC-Unique: 0wYY4wymNmmsRwAcyPod2Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 31 May 2021 11:41:18 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Mon, 31 May 2021 11:41:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH net-next] ipv6: use prandom_u32() for ID generation
Thread-Topic: [PATCH net-next] ipv6: use prandom_u32() for ID generation
Thread-Index: AQHXVHsAigx754KkQkSlq/l9+mKws6r9Zzgg
Date:   Mon, 31 May 2021 10:41:18 +0000
Message-ID: <e4cc31c1fead46b3aa1132937a720da2@AcuMS.aculab.com>
References: <20210529110746.6796-1-w@1wt.eu>
In-Reply-To: <20210529110746.6796-1-w@1wt.eu>
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

From: Willy Tarreau
> Sent: 29 May 2021 12:08
> 
> This is a complement to commit aa6dd211e4b1 ("inet: use bigger hash
> table for IP ID generation"), but focusing on some specific aspects
> of IPv6.
> 
> Contary to IPv4, IPv6 only uses packet IDs with fragments, and with a
> minimum MTU of 1280, it's much less easy to force a remote peer to
> produce many fragments to explore its ID sequence. In addition packet
> IDs are 32-bit in IPv6, which further complicates their analysis. On
> the other hand, it is often easier to choose among plenty of possible
> source addresses and partially work around the bigger hash table the
> commit above permits, which leaves IPv6 partially exposed to some
> possibilities of remote analysis at the risk of weakening some
> protocols like DNS if some IDs can be predicted with a good enough
> probability.
> 
> Given the wide range of permitted IDs, the risk of collision is extremely
> low so there's no need to rely on the positive increment algorithm that
> is shared with the IPv4 code via ip_idents_reserve(). We have a fast
> PRNG, so let's simply call prandom_u32() and be done with it.
> 
> Performance measurements at 10 Gbps couldn't show any difference with
> the previous code, even when using a single core, because due to the
> large fragments, we're limited to only ~930 kpps at 10 Gbps and the cost
> of the random generation is completely offset by other operations and by
> the network transfer time. In addition, this change removes the need to
> update a shared entry in the idents table so it may even end up being
> slightly faster on large scale systems where this matters.
> 
> The risk of at least one collision here is about 1/80 million among
> 10 IDs, 1/850k among 100 IDs, and still only 1/8.5k among 1000 IDs,
> which remains very low compared to IPv4 where all IDs are reused
> every 4 to 80ms on a 10 Gbps flow depending on packet sizes.

The problem is that, on average, 1 in 2^32 packets will use
the same id as the previous one.
If a fragment of such a pair gets lost horrid things are
likely to happen.
Note that this is different from an ID being reused after a
count of packets or after a time delay.

So you still need something to ensure IDs aren't reused immediately.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

