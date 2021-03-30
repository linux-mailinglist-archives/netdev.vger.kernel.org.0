Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690F934E355
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhC3IlN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Mar 2021 04:41:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:45355 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231546AbhC3Iky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 04:40:54 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-54-CISavjqRMeS8clzZHhjRpg-1; Tue, 30 Mar 2021 09:40:51 +0100
X-MC-Unique: CISavjqRMeS8clzZHhjRpg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 30 Mar 2021 09:40:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Tue, 30 Mar 2021 09:40:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vladimir Oltean' <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Topic: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Index: AQHXJKXlZqB1plpeA0OcVM38+bWT0qqbJqaAgAEPNdA=
Date:   Tue, 30 Mar 2021 08:40:50 +0000
Message-ID: <57677b6102f4424093875fb8f3d5e2f2@AcuMS.aculab.com>
References: <20210329141443.23245-1-claudiu.manoil@nxp.com>
 <20210329162421.k5ltz2tkufsueyds@skbuf>
In-Reply-To: <20210329162421.k5ltz2tkufsueyds@skbuf>
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
> Sent: 29 March 2021 17:24
> 
> On Mon, Mar 29, 2021 at 05:14:43PM +0300, Claudiu Manoil wrote:
> > Static analysis tool reports:
> > "Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
> > unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
> > then sign-extended to type unsigned long long (64 bits, unsigned).
> > If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result
> 
> This is a backwards way of saying 'if flags & BIT(7) is set', no? But
> BIT(7) is ENETC_TXBD_FLAGS_F (the 'final BD' bit), and I've been testing
> SO_TXTIME with single BD frames, and haven't seen this problem.
> 
> > will all be 1."
> >
> > Use lower_32_bits() to avoid this scenario.
> >
> > Fixes: 82728b91f124 ("enetc: Remove Tx checksumming offload code")
> >
> > Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> > ---
> > v2 - added 'fixes' tag
> >
> >  drivers/net/ethernet/freescale/enetc/enetc_hw.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > index 00938f7960a4..07e03df8af94 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> > @@ -535,8 +535,8 @@ static inline __le32 enetc_txbd_set_tx_start(u64 tx_start, u8 flags)
> >  {
> >  	u32 temp;
> >
> > -	temp = (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
> > -	       (flags << ENETC_TXBD_FLAGS_OFFSET);
> > +	temp = lower_32_bits(tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
> > +	       (u32)(flags << ENETC_TXBD_FLAGS_OFFSET);
> 
> I don't actually understand why lower_32_bits called on the TX time
> helps, considering that the value is masked already.

Not only that the high bits get thrown away by the assignment.
The change just gives the reader more to parse for zero benefit.

> The static analysis
> tool says that the right hand side of the "|" operator is what is
> sign-extended:
> 
> 	       (flags << ENETC_TXBD_FLAGS_OFFSET);
> 
> Isn't it sufficient that you replace "u8 flags" in the function
> prototype with "u32 flags"?

That would be much better.
It may save the value having to be masked with 0xff as well.

Regardless of the domain of function parameters/results (and local
variables) using machine-register sized types will typically give
better code.
x86 is probably unique in having sub-32bit arithmetic.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

