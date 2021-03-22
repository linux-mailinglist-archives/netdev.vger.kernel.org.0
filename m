Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0619A343C2F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 09:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCVI60 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Mar 2021 04:58:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:54865 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhCVI6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 04:58:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-245-4lZc9m03OW2Pu2atP1wGzw-1; Mon, 22 Mar 2021 08:58:12 +0000
X-MC-Unique: 4lZc9m03OW2Pu2atP1wGzw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 22 Mar 2021 08:58:11 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Mon, 22 Mar 2021 08:58:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>
CC:     "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: socket: change MSG_CMSG_COMPAT to
 BIT(21)
Thread-Topic: [PATCH net-next 2/2] net: socket: change MSG_CMSG_COMPAT to
 BIT(21)
Thread-Index: AQHXHlCgGHDgaZN5KE6t5P14se4atKqPtAlQ
Date:   Mon, 22 Mar 2021 08:58:11 +0000
Message-ID: <ab55a91d390c485187326c8fa3a84841@AcuMS.aculab.com>
References: <20210321123929.142838-1-dong.menglong@zte.com.cn>
 <20210321123929.142838-3-dong.menglong@zte.com.cn>
 <20210321124906.GA14333@gondor.apana.org.au>
In-Reply-To: <20210321124906.GA14333@gondor.apana.org.au>
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

From: Herbert Xu
> Sent: 21 March 2021 12:49
> 
> On Sun, Mar 21, 2021 at 08:39:29PM +0800, menglong8.dong@gmail.com wrote:
> >
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index d5ebfe30d96b..317b2933f499 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -312,17 +312,18 @@ struct ucred {
> >  					 * plain text and require encryption
> >  					 */
> >
> > +#if defined(CONFIG_COMPAT)
> > +#define MSG_CMSG_COMPAT		BIT(21)	/* This message needs 32 bit fixups */
> > +#else
> > +#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
> > +#endif
> > +
> >  #define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
> >  #define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
> >  #define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
> >  					 * descriptor received through
> >  					 * SCM_RIGHTS
> >  					 */
> > -#if defined(CONFIG_COMPAT)
> > -#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
> > -#else
> > -#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
> > -#endif
> 
> Shouldn't you add some comment here to stop people from trying to
> use BIT(31) in the future?

You'd also be better using BIT(30) - ie the other end of the
free space from the user-visible bits.

It has to be said that the entire impossibility of writing BIT(n)
safely almost makes it worse that just defining appropriate constants.

Personally I like the hex constants.
The make it much easier to work out which bits are set in a diagnostic
print (or memory hexdump).

The only time I've really found BIT() type macros useful is when
defining values that have to match hardware specs that define bit
numbers backwards starting from 1.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

