Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B7636E756
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbhD2ItJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Apr 2021 04:49:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:57652 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232738AbhD2ItI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:49:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-219-b-Z3yt6wPv-bCo1xGyIVJA-1; Thu, 29 Apr 2021 09:48:18 +0100
X-MC-Unique: b-Z3yt6wPv-bCo1xGyIVJA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 29 Apr 2021 09:48:18 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Thu, 29 Apr 2021 09:48:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'zhouchuangao' <zhouchuangao@vivo.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/rxrpc: Use BUG_ON instead of if condition followed by
 BUG.
Thread-Topic: [PATCH] net/rxrpc: Use BUG_ON instead of if condition followed
 by BUG.
Thread-Index: AQHXPM/tVVdxd6dES0eMiUm+pJEO+6rLLuow
Date:   Thu, 29 Apr 2021 08:48:18 +0000
Message-ID: <e7c1b060f1594d21bab96e68c4b53bb3@AcuMS.aculab.com>
References: <1619683852-2247-1-git-send-email-zhouchuangao@vivo.com>
In-Reply-To: <1619683852-2247-1-git-send-email-zhouchuangao@vivo.com>
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

From: zhouchuangao
> Sent: 29 April 2021 09:11
> 
> BUG_ON() uses unlikely in if(), which can be optimized at compile time.
> 
>               do { if (unlikely(condition)) BUG(); } while (0)
...
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 4eb91d95..e5deb6f 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -505,8 +505,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
>  	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
> 
>  	spin_lock_bh(&call->lock);
> -	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
> -		BUG();
> +	BUG_ON(test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags));

Hiding as assignment inside BUG_ON() isn't nice.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

