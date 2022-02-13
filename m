Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738034B3928
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 04:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiBMDBe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 12 Feb 2022 22:01:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBMDBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 22:01:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C523A287
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 19:01:28 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-230-aZDGCbkKMKmOLXdRHLKgCw-1; Sun, 13 Feb 2022 03:01:25 +0000
X-MC-Unique: aZDGCbkKMKmOLXdRHLKgCw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Sun, 13 Feb 2022 03:01:24 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Sun, 13 Feb 2022 03:01:24 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] powerpc/32: Implement csum_sub
Thread-Topic: [PATCH 2/2] powerpc/32: Implement csum_sub
Thread-Index: AQHYHzGljVa6S8GqcUW0lv81TntuEayQyZKA
Date:   Sun, 13 Feb 2022 03:01:24 +0000
Message-ID: <a87eb9e5bb6d483f8352ccb4b7374286@AcuMS.aculab.com>
References: <0c8eaab8f0685d2a70d125cf876238c70afd4fb6.1644574987.git.christophe.leroy@csgroup.eu>
 <c2a3f87d97f0903fdef3bbcb84661f75619301bf.1644574987.git.christophe.leroy@csgroup.eu>
In-Reply-To: <c2a3f87d97f0903fdef3bbcb84661f75619301bf.1644574987.git.christophe.leroy@csgroup.eu>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Leroy
> Sent: 11 February 2022 10:25
> 
> When building kernel with CONFIG_CC_OPTIMISE_FOR_SIZE, several
> copies of csum_sub() are generated, with the following code:
> 
> 	00000170 <csum_sub>:
> 	     170:	7c 84 20 f8 	not     r4,r4
> 	     174:	7c 63 20 14 	addc    r3,r3,r4
> 	     178:	7c 63 01 94 	addze   r3,r3
> 	     17c:	4e 80 00 20 	blr
> 
> Let's define a PPC32 version with subc/addme, and for it's inlining.
> 
> It will return 0 instead of 0xffffffff when subtracting 0x80000000 to itself,
> this is not an issue as 0 and ~0 are equivalent, refer to RFC 1624.

They are not always equivalent.
In particular in the UDP checksum field one of them is (0?) 'checksum not calculated'.

I think all the Linux functions have to return a non-zero value (for non-zero input).

If the csum is going to be converted to 16 bit, inverted, and put into a packet
the code usually has to have a check that changes 0 to 0xffff.
However if the csum functions guarantee never to return zero they can feed
an extra 1 into the first csum_partial() then just invert and add 1 at the end.
Because (~csum_partion(buffer, 1) + 1) is the same as ~csum_partial(buffer, 0)
except when the buffer's csum is 0xffffffff.

I did do some experiments and the 64bit value can be reduced directly to
16bits using '% 0xffff'.
This is different because it returns 0 not 0xffff.
However gcc 'randomly' picks between the fast 'multiply by reciprocal'
and slow divide instruction paths.
The former is (probably) faster than reducing using shifts and adc.
The latter definitely slower.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

