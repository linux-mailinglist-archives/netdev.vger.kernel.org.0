Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3A466B50
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349038AbhLBVD0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Dec 2021 16:03:26 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:53663 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234616AbhLBVDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:03:24 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-8-1TBcfAgSODeo9XmlqApOIQ-1; Thu, 02 Dec 2021 20:58:47 +0000
X-MC-Unique: 1TBcfAgSODeo9XmlqApOIQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 2 Dec 2021 20:58:46 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 2 Dec 2021 20:58:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vladimir Oltean' <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX57zbDWxMByH9C0Scwj/3q1CYoawfrjxg
Date:   Thu, 2 Dec 2021 20:58:46 +0000
Message-ID: <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
In-Reply-To: <20211202204036.negad3mnrm2gogjd@skbuf>
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

> To me it looks like the strange part is that the checksum of the removed
> block (printed by me as "csum_partial(start, len, 0)" inside
> skb_postpull_rcsum()) is the same as the skb->csum itself.

If you are removing all the bytes that made the original checksum
that will happen.
And that might be true for the packets you are building.

Try replacing both ~ with -.
So replace:
		skb->csum = ~csum_partial(start, len, ~skb->csum);
with:
		skb->csum = -csum_partial(start, len, -skb->csum);

That should geneate ~0u instead 0 (if I've got my maths right).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

