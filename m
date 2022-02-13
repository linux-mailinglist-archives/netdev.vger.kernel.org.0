Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E772E4B38F6
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 03:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiBMCjR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 12 Feb 2022 21:39:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiBMCjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 21:39:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 028AC6006D
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 18:39:11 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-267-jz20NOQ6P6ya1sjHH6f2FQ-1; Sun, 13 Feb 2022 02:39:08 +0000
X-MC-Unique: jz20NOQ6P6ya1sjHH6f2FQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Sun, 13 Feb 2022 02:39:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Sun, 13 Feb 2022 02:39:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: Remove branch in csum_shift()
Thread-Topic: [PATCH] net: Remove branch in csum_shift()
Thread-Index: AQHYHyQqmTo4K/pb5UWdDmTfE7rfRayQxWFw
Date:   Sun, 13 Feb 2022 02:39:06 +0000
Message-ID: <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
In-Reply-To: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Leroy
> Sent: 11 February 2022 08:48
> 
> Today's implementation of csum_shift() leads to branching based on
> parity of 'offset'
> 
> 	000002f8 <csum_block_add>:
> 	     2f8:	70 a5 00 01 	andi.   r5,r5,1
> 	     2fc:	41 a2 00 08 	beq     304 <csum_block_add+0xc>
> 	     300:	54 84 c0 3e 	rotlwi  r4,r4,24
> 	     304:	7c 63 20 14 	addc    r3,r3,r4
> 	     308:	7c 63 01 94 	addze   r3,r3
> 	     30c:	4e 80 00 20 	blr
> 
> Use first bit of 'offset' directly as input of the rotation instead of
> branching.
> 
> 	000002f8 <csum_block_add>:
> 	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
> 	     2fc:	20 a5 00 20 	subfic  r5,r5,32
> 	     300:	5c 84 28 3e 	rotlw   r4,r4,r5
> 	     304:	7c 63 20 14 	addc    r3,r3,r4
> 	     308:	7c 63 01 94 	addze   r3,r3
> 	     30c:	4e 80 00 20 	blr
> 
> And change to left shift instead of right shift to skip one more
> instruction. This has no impact on the final sum.
> 
> 	000002f8 <csum_block_add>:
> 	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
> 	     2fc:	5c 84 28 3e 	rotlw   r4,r4,r5
> 	     300:	7c 63 20 14 	addc    r3,r3,r4
> 	     304:	7c 63 01 94 	addze   r3,r3
> 	     308:	4e 80 00 20 	blr

That is ppc64.
What happens on x86-64?

Trying to do the same in the x86 ipcsum code tended to make the code worse.
(Although that test is for an odd length fragment and can just be removed.)

	David

> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  include/net/checksum.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/net/checksum.h b/include/net/checksum.h
> index 5218041e5c8f..9badcd5532ef 100644
> --- a/include/net/checksum.h
> +++ b/include/net/checksum.h
> @@ -83,9 +83,7 @@ static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
>  static inline __wsum csum_shift(__wsum sum, int offset)
>  {
>  	/* rotate sum to align it with a 16b boundary */
> -	if (offset & 1)
> -		return (__force __wsum)ror32((__force u32)sum, 8);
> -	return sum;
> +	return (__force __wsum)rol32((__force u32)sum, (offset & 1) << 3);
>  }
> 
>  static inline __wsum
> --
> 2.34.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

