Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B174679BF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244307AbhLCOyn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Dec 2021 09:54:43 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:55022 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235792AbhLCOym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:54:42 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-234-gAIpiTZ0PWGL6dnDAfWjVQ-1; Fri, 03 Dec 2021 14:51:16 +0000
X-MC-Unique: gAIpiTZ0PWGL6dnDAfWjVQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 3 Dec 2021 14:51:15 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 3 Dec 2021 14:51:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vladimir Oltean' <olteanv@gmail.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX57zbDWxMByH9C0Scwj/3q1CYoawfrjxggAAMpYCAAR7pAA==
Date:   Fri, 3 Dec 2021 14:51:15 +0000
Message-ID: <7aa1271399664bb3ac453a7f4d64798e@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
 <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
 <20211202214009.5hm3diwom4qsbsjd@skbuf>
In-Reply-To: <20211202214009.5hm3diwom4qsbsjd@skbuf>
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

From: Vladimir Oltean
> Sent: 02 December 2021 21:40
> 
> On Thu, Dec 02, 2021 at 08:58:46PM +0000, David Laight wrote:
> > > To me it looks like the strange part is that the checksum of the removed
> > > block (printed by me as "csum_partial(start, len, 0)" inside
> > > skb_postpull_rcsum()) is the same as the skb->csum itself.
> >
> > If you are removing all the bytes that made the original checksum
> > that will happen.
> > And that might be true for the packets you are building.
> 
> Yes, I am not removing all the bytes that made up the original L2
> payload csum. Let me pull up the skb_dump from my original message:
> 
>                         here is where the enetc saw the          the "start" variable (old skb->data)
>                         beginning of the frame                   points here
>                         v                                         v
> skb headroom: 00000040: 88 80 00 0a 00 33 9d 40 f0 41 01 80 00 00 08 0f
> 
>                               OCELOT_TAG_LEN bytes into the frame,
>                               the real MAC header can be found
>                                     v
> skb headroom: 00000050: 00 10 00 00 00 04 9f 05 f6 28 ba ae e4 b6 2c 3d
> skb headroom: 00000060: 08 00
> skb linear:   00000000: 45 00 00 54 27 ac 00 00 40 01 09 a8 c0 a8 64 03
>                         ^
>                         the skb_postpull_rcsum is called from "start"
>                         pointer until the first byte prior to this one
> 
> skb linear:   00000010: c0 a8 64 01 00 00 10 e6 01 5c 00 04 49 30 a7 61
> skb linear:   00000020: 00 00 00 00 3d 55 01 00 00 00 00 00 10 11 12 13
> skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
> skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> skb linear:   00000050: 34 35 36 37
> 
> So skb_postpull_rcsum() is called from "skb headroom" offset 0x4e to
> offset 0x61 inclusive (0x61 - 0x4e + 1 = 20 == OCELOT_TAG_LEN).
> 
> However as I understand it, the CHECKSUM_COMPLETE of this packet is
> calculated by enetc from "skb headroom" offset 0x4e and all the way
> until "skb linear" offset 0x53. So there is still a good chunk of packet
> to go. That's why it is still a mystery to me why the checksums would be
> equal
...

Possibly because the rest of the packet actually has a valid checksum
(ie 0xffff) that (somewhere) got reduced to 16 bits.
If the checksum of the header were then added, and later removed
you'd end up inverting ~0u.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

