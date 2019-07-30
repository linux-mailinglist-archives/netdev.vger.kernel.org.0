Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A777ABB0
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbfG3O7Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 10:59:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47645 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728526AbfG3O7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:59:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-62-zMYVNYknPF2PhZEH6HfzKw-1; Tue, 30 Jul 2019 15:59:12 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 30 Jul 2019 15:59:12 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 30 Jul 2019 15:59:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Qian Cai' <cai@lca.pw>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Thread-Topic: [PATCH v2] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Thread-Index: AQHVRuR2hmPxRDJks0KkKUnxQ8wAw6bjPw9w
Date:   Tue, 30 Jul 2019 14:59:12 +0000
Message-ID: <69c6beab2d734ed88ce31a6381f85420@AcuMS.aculab.com>
References: <1564497488-3030-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564497488-3030-1-git-send-email-cai@lca.pw>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: zMYVNYknPF2PhZEH6HfzKw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai
> Sent: 30 July 2019 15:38
...
> Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
> can keep the same alignments as a member in both packed and un-packed
> structures without breaking UAPI.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
...

Although I suggested it needs a bit of tidy up.

Add a comment maybe:

/* The definition uses anonymous union and struct in order to
 * control the default alignment. */

>  struct __kernel_sockaddr_storage {
> -	__kernel_sa_family_t	ss_family;		/* address family */
> -	/* Following field(s) are implementation specific */
> -	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
> +	union {
> +		void *__align; /* implementation specific desired alignment */

Move the 'void *' below the struct so the first member is the 'public one.

> +		struct {
> +			__kernel_sa_family_t	ss_family; /* address family */
> +			/* Following field(s) are implementation specific */
> +			char __data[_K_SS_MAXSIZE - sizeof(unsigned short)];
>  				/* space to achieve desired size, */
>  				/* _SS_MAXSIZE value minus size of ss_family */
> -} __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
> +			};
> +		};
> +};
> 
>  #endif /* _UAPI_LINUX_SOCKET_H */
> --
> 1.8.3.1

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

