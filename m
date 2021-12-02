Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4A466624
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358701AbhLBPJt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Dec 2021 10:09:49 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:31554 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358403AbhLBPJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:09:35 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-190-L0sbvhYUMzm2UAavlZ4DdQ-1; Thu, 02 Dec 2021 15:06:07 +0000
X-MC-Unique: L0sbvhYUMzm2UAavlZ4DdQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 2 Dec 2021 15:06:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 2 Dec 2021 15:06:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vladimir Oltean' <olteanv@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX534DDWxMByH9C0Scwj/3q1CYoawfSXcQ
Date:   Thu, 2 Dec 2021 15:06:06 +0000
Message-ID: <88b82ae31dc54a4c8b2173487f61ffe9@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
In-Reply-To: <20211202131040.rdxzbfwh2slhftg5@skbuf>
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
> Sent: 02 December 2021 13:11
...
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int
> len,
> >  static inline void skb_postpull_rcsum(struct sk_buff *skb,
> >  				      const void *start, unsigned int len)
> >  {
> > -	__skb_postpull_rcsum(skb, start, len, 0);
> > +	if (skb->ip_summed == CHECKSUM_COMPLETE)
> > +		skb->csum = ~csum_partial(start, len, ~skb->csum);

You can't do that, the domain is 1..0xffff (or maybe 0xffffffff).
The invert has to convert ~0 to ~0 not zero.
...
> There seems to be a disparity when the skb->csum is calculated by
> skb_postpull_rcsum as zero. Before, it was calculated as 0xffff.

Which is what that will do for some inputs at least.
Maybe:
		skb->csum = 1 + ~csum_partial(start, len, ~skb->csum + 1);
is right.
I think that is the same as:
		skb->csum = -csum_partial(start, len, -skb->csum);
Although letting the compiler do that transform probably makes
the code easier to read.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

