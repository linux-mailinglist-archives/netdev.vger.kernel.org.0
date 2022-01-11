Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D3F48AA6F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349267AbiAKJYx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jan 2022 04:24:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52619 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237029AbiAKJYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:24:52 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-53-1xZ1mu4IMP-8jPHDydNz9Q-1; Tue, 11 Jan 2022 09:24:49 +0000
X-MC-Unique: 1xZ1mu4IMP-8jPHDydNz9Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Tue, 11 Jan 2022 09:24:49 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Tue, 11 Jan 2022 09:24:49 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Thread-Topic: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Thread-Index: AQHYBooc+zd0TLCwI0SMx+giCPDt3axdi3LQ
Date:   Tue, 11 Jan 2022 09:24:49 +0000
Message-ID: <918a937f6cef44e282353001a7fbba7a@AcuMS.aculab.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
 <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
In-Reply-To: <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
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

From: Pavel Begunkov
> Sent: 11 January 2022 01:22
> 
> Inline a HW csum'ed part of skb_csum_hwoffload_help().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/netdevice.h | 16 ++++++++++++++--
>  net/core/dev.c            | 13 +++----------
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3213c7227b59..fbe6c764ce57 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4596,8 +4596,20 @@ void netdev_rss_key_fill(void *buffer, size_t len);
> 
>  int skb_checksum_help(struct sk_buff *skb);
>  int skb_crc32c_csum_help(struct sk_buff *skb);
> -int skb_csum_hwoffload_help(struct sk_buff *skb,
> -			    const netdev_features_t features);
> +int __skb_csum_hwoffload_help(struct sk_buff *skb,
> +			      const netdev_features_t features);
> +
> +static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
> +					  const netdev_features_t features)
> +{
> +	if (unlikely(skb_csum_is_sctp(skb)))
> +		return !!(features & NETIF_F_SCTP_CRC) ? 0 :

If that !! doing anything? - doesn't look like it.

> +			skb_crc32c_csum_help(skb);
> +
> +	if (features & NETIF_F_HW_CSUM)
> +		return 0;
> +	return __skb_csum_hwoffload_help(skb, features);
> +}

Maybe you should remove some bloat by moving the sctp code
into the called function.
This probably needs something like?

{
	if (features & NETIF_F_HW_CSUM && !skb_csum_is_sctp(skb))
		return 0;
	return __skb_csum_hw_offload(skb, features);
}

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

