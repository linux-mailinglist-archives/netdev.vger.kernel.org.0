Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFA945D77D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354221AbhKYJrL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Nov 2021 04:47:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:49992 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344779AbhKYJpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 04:45:10 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-234-tu_n2HW-MLuRds2OE2CvBA-1; Thu, 25 Nov 2021 09:41:56 +0000
X-MC-Unique: tu_n2HW-MLuRds2OE2CvBA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 25 Nov 2021 09:41:56 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 25 Nov 2021 09:41:55 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Topic: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Thread-Index: AQHX4XFaeNlULo4wpkmTYyB+DTu/bKwT/kEA
Date:   Thu, 25 Nov 2021 09:41:55 +0000
Message-ID: <06864387ba644a58816ab3a82a8b5f82@AcuMS.aculab.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
In-Reply-To: <20211124202446.2917972-3-eric.dumazet@gmail.com>
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

From: Eric Dumazet
> Sent: 24 November 2021 20:25
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> Remove one pair of add/adc instructions and their dependency
> against carry flag.
> 
> We can leverage third argument to csum_partial():
> 
>   X = csum_block_sub(X, csum_partial(start, len, 0), 0);
> 
>   -->
> 
>   X = csum_block_add(X, ~csum_partial(start, len, 0), 0);
> 
>   -->
> 
>   X = ~csum_partial(start, len, ~X);

That doesn't seem to refer to the change in this file.

	David
 
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/skbuff.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index eba256af64a577b458998845f2dc01a5ec80745a..eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int len,
>  static inline void skb_postpull_rcsum(struct sk_buff *skb,
>  				      const void *start, unsigned int len)
>  {
> -	__skb_postpull_rcsum(skb, start, len, 0);
> +	if (skb->ip_summed == CHECKSUM_COMPLETE)
> +		skb->csum = ~csum_partial(start, len, ~skb->csum);
> +	else if (skb->ip_summed == CHECKSUM_PARTIAL &&
> +		 skb_checksum_start_offset(skb) < 0)
> +		skb->ip_summed = CHECKSUM_NONE;
>  }
> 
>  static __always_inline void
> --
> 2.34.0.rc2.393.gf8c9666880-goog

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

