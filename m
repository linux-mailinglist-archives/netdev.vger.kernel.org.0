Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923292C80CF
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgK3JUj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 04:20:39 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:26708 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbgK3JUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:20:39 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-144-Q0MlZ52vP8mTVg-vKwyGSQ-1; Mon, 30 Nov 2020 09:19:00 +0000
X-MC-Unique: Q0MlZ52vP8mTVg-vKwyGSQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 30 Nov 2020 09:18:59 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 30 Nov 2020 09:18:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stephen Hemminger' <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/5] misc: fix compiler warning in ifstat and nstat
Thread-Topic: [PATCH 4/5] misc: fix compiler warning in ifstat and nstat
Thread-Index: AQHWxq89V9V+Fa2vMUOjPZD4kiCxKKngZaNw
Date:   Mon, 30 Nov 2020 09:18:59 +0000
Message-ID: <efb6a29fef0e4ca1845956701f670b4b@AcuMS.aculab.com>
References: <20201130002135.6537-1-stephen@networkplumber.org>
 <20201130002135.6537-5-stephen@networkplumber.org>
In-Reply-To: <20201130002135.6537-5-stephen@networkplumber.org>
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

From: Stephen Hemminger
> Sent: 30 November 2020 00:22
> 
> The code here was doing strncpy() in a way that causes gcc 10
> warning about possible string overflow. Just use strlcpy() which
> will null terminate and bound the string as expected.
> 
> This has existed since start of git era so no Fixes tag.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  misc/ifstat.c | 2 +-
>  misc/nstat.c  | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/ifstat.c b/misc/ifstat.c
> index c05183d79a13..d4a33429dc50 100644
> --- a/misc/ifstat.c
> +++ b/misc/ifstat.c
> @@ -251,7 +251,7 @@ static void load_raw_table(FILE *fp)
>  			buf[strlen(buf)-1] = 0;
>  			if (info_source[0] && strcmp(info_source, buf+1))
>  				source_mismatch = 1;
> -			strncpy(info_source, buf+1, sizeof(info_source)-1);
> +			strlcpy(info_source, buf+1, sizeof(info_source));
>  			continue;

ISTM that once it has done a strlen() it ought to use the length
for the later copy.

I don't seem to have the source file (I'm guessing it isn't in the
normal repo), but is that initial strlen() guaranteed not to return
zero?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

