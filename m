Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438652C2C82
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390218AbgKXQNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 11:13:40 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:42312 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389424AbgKXQNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:13:40 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-52-HzliJv79Ow6gxTeamYvZmA-1; Tue, 24 Nov 2020 16:13:36 +0000
X-MC-Unique: HzliJv79Ow6gxTeamYvZmA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 16:13:35 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 16:13:35 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
Thread-Topic: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
Thread-Index: AQHWwnVjvwCYtog5HkymKKDHI5XK+KnXcZmA
Date:   Tue, 24 Nov 2020 16:13:35 +0000
Message-ID: <e86a5d8a3aed44139010dac219dfcf08@AcuMS.aculab.com>
References: <20201124151828.169152-1-arnd@kernel.org>
 <20201124151828.169152-3-arnd@kernel.org>
In-Reply-To: <20201124151828.169152-3-arnd@kernel.org>
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

From: Arnd Bergmann
> Sent: 24 November 2020 15:18
> 
> SIOCGIFMAP and SIOCSIFMAP currently require compat_alloc_user_space()
> and copy_in_user() for compat mode.
> 
> Move the compat handling into the location where the structures are
> actually used, to avoid using those interfaces and get a clearer
> implementation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> changes in v3:
>  - complete rewrite
...
>  include/linux/compat.h | 18 ++++++------
>  net/core/dev_ioctl.c   | 64 +++++++++++++++++++++++++++++++++---------
>  net/socket.c           | 39 ++-----------------------
>  3 files changed, 62 insertions(+), 59 deletions(-)
> 
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 08dbd34bb7a5..47496c5eb5eb 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -96,6 +96,15 @@ struct compat_iovec {
>  	compat_size_t	iov_len;
>  };
> 
> +struct compat_ifmap {
> +	compat_ulong_t mem_start;
> +	compat_ulong_t mem_end;
> +	unsigned short base_addr;
> +	unsigned char irq;
> +	unsigned char dma;
> +	unsigned char port;
> +};

Isn't the only difference the number of pad bytes at the end?
If you don't copy these (in or out) then the compat version
isn't special at all.
Not copying the pad in or out would ensure you don't leak
kernel stack to userspace.
OTOH you may want to write the padding zero.

So a CT_ASSERT(offsetof (struct ifmap, port) == offsetof (struct compat_ifmap, port))
would suffice.

Maybe a CT_ASSERT_EQ_OFFSET(struct ifmap, struct compat_ifmap, port);
Would make the code easier to read.
Although you might want the version that adds an offset

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

