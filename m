Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB649FB5E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245187AbiA1OKO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jan 2022 09:10:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:29267 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235208AbiA1OKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:10:14 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-220-5UJkh51_PXW-lSeVQyoshw-1; Fri, 28 Jan 2022 14:10:11 +0000
X-MC-Unique: 5UJkh51_PXW-lSeVQyoshw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 28 Jan 2022 14:10:09 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 28 Jan 2022 14:10:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tobias Waldekranz' <tobias@waldekranz.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Thread-Topic: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Thread-Index: AQHYFDTJs9bxk0Q5BUyDnjGXsateMqx4d6Sw
Date:   Fri, 28 Jan 2022 14:10:09 +0000
Message-ID: <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
In-Reply-To: <20220128104938.2211441-1-tobias@waldekranz.com>
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

From: Tobias Waldekranz
> Sent: 28 January 2022 10:50
> 
> The individual patches have all the details. This work was triggered
> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
> module.
> 
> The first patch gets rid of most of that time by replacing a very long
> delay with a tighter poll loop to wait for the busy bit to clear.
> 
> The second patch shaves off some more time by avoiding redundant
> busy-bit-checks, saving 1 out of 4 MDIO operations for every register
> read/write in the optimal case.

I don't think you should fast-poll for the entire timeout period.
Much better to drop to a usleep_range() after the first 2 (or 3)
reads fail.

Also I presume there is some lock that ensures this is all single threaded?
If you remember the 'busy state' you can defer the 'busy check' after
a write until the next request.
That may well reduce the number of 'double checks' needed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

