Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72C2B4C1D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732435AbgKPRF1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Nov 2020 12:05:27 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30768 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgKPRF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:05:27 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-32-6hGtgbgIP0GQA7QZEJA7DA-1; Mon, 16 Nov 2020 17:05:23 +0000
X-MC-Unique: 6hGtgbgIP0GQA7QZEJA7DA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 16 Nov 2020 17:05:22 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 16 Nov 2020 17:05:22 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin Schiller' <ms@dev.tdt.de>,
        "andrew.hendry@gmail.com" <andrew.hendry@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xie.he.0141@gmail.com" <xie.he.0141@gmail.com>
CC:     "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/6] net/x25: make neighbour params
 configurable
Thread-Topic: [PATCH net-next v2 2/6] net/x25: make neighbour params
 configurable
Thread-Index: AQHWvCDo0EreTMkGI0G9xcVRt+utm6nK+twg
Date:   Mon, 16 Nov 2020 17:05:22 +0000
Message-ID: <5d4faa10de734ba0af7a471b0eadd782@AcuMS.aculab.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-3-ms@dev.tdt.de>
In-Reply-To: <20201116135522.21791-3-ms@dev.tdt.de>
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

From: Martin Schiller
> Sent: 16 November 2020 13:55
> Extended struct x25_neigh and x25_subscrip_struct to configure following
> params through SIOCX25SSUBSCRIP:
>   o mode (DTE/DCE)
>   o number of channels
>   o facilities (packet size, window size)
>   o timer T20
> 
> Based on this configuration options the following changes/extensions
> where made:
>   o DTE/DCE handling to select the next lc (DCE=from bottom / DTE=from
>     top)
>   o DTE/DCE handling to set correct clear/reset/restart cause
>   o take default facilities from neighbour settings
> 
...
> +/*
> + *	DTE/DCE subscription options.
> + *
> + *      As this is missing lots of options, user should expect major
> + *	changes of this structure in 2.5.x which might break compatibility.

A little out of date!

> + *      The somewhat ugly dimension 200-sizeof() is needed to maintain
> + *	backward compatibility.
> + */
> +struct x25_subscrip_struct {
> +	char device[200 - ((2 * sizeof(unsigned long)) +
> +		    sizeof(struct x25_facilities) +
> +		    (2 * sizeof(unsigned int)))];
> +	unsigned int		dce;
> +	unsigned int		lc;
> +	struct x25_facilities	facilities;
> +	unsigned long		t20;
> +	unsigned long		global_facil_mask;	/* 0 to disable negotiation */
> +	unsigned int		extended;
> +};

Would it be better to used fixed size integer types to avoid
'compat_32' issues?

It might even be worth adding padding after the existing
32bit layout to align any additional fields at the same offset
in both 64bit and 32bit systems.

I was also wondering if you can use an anonymous structure
member for the actual fields and then use 200 - sizeof (struct foo)
for the pad?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

