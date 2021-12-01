Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A298464C01
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 11:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242437AbhLAKyp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Dec 2021 05:54:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:27301 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhLAKyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 05:54:44 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-234-4a_ior_BOZqj3sK0_ELJ2g-1; Wed, 01 Dec 2021 10:51:21 +0000
X-MC-Unique: 4a_ior_BOZqj3sK0_ELJ2g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 1 Dec 2021 10:51:21 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 1 Dec 2021 10:51:21 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>
Subject: RE: [PATCH v2] x86/csum: rewrite csum_partial()
Thread-Topic: [PATCH v2] x86/csum: rewrite csum_partial()
Thread-Index: AQHX1+EjTNUIwu5klUmT0ItnijFgT6wdiFww
Date:   Wed, 1 Dec 2021 10:51:20 +0000
Message-ID: <cd7a346d37174ae7b90d149d5b8f3d4e@AcuMS.aculab.com>
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
In-Reply-To: <20211112161950.528886-1-eric.dumazet@gmail.com>
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
> Sent: 12 November 2021 16:20
> 
> With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> csum_partial() is heavily used with small amount of bytes,
> and is consuming many cycles.
> 
> IPv6 header size for instance is 40 bytes.
> 
> Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> meaning that network headers are not word-aligned, unless
> the driver forces this.
> 
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform three u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
> 
> With this new version, we perform a loop only for the 64 bytes blocks,
> then the remaining is bisected.
> 

I missed this going through, a couple of comments.
I've removed all the old lines from the patch to make it readable.

> +__wsum csum_partial(const void *buff, int len, __wsum sum)
>  {
> +	u64 temp64 = (__force u64)sum;
> +	unsigned odd, result;
> 
>  	odd = 1 & (unsigned long) buff;
>  	if (unlikely(odd)) {
> +		if (unlikely(len == 0))
> +			return sum;
> +		temp64 += (*(unsigned char *)buff << 8);
>  		len--;
>  		buff++;
>  	}

Do you need to special case an odd buffer address?
You are doing misaligned reads for other (more likely)
misaligned addresses so optimising for odd buffer addresses
is rather pointless.
If misaligned reads do cost an extra clock then it might
be worth detecting the more likely '4n+2' alignment of a receive
buffer and aligning that to 8n.

> 
> +	while (unlikely(len >= 64)) {
> +		asm("addq 0*8(%[src]),%[res]\n\t"
> +		    "adcq 1*8(%[src]),%[res]\n\t"
> +		    "adcq 2*8(%[src]),%[res]\n\t"
> +		    "adcq 3*8(%[src]),%[res]\n\t"
> +		    "adcq 4*8(%[src]),%[res]\n\t"
> +		    "adcq 5*8(%[src]),%[res]\n\t"
> +		    "adcq 6*8(%[src]),%[res]\n\t"
> +		    "adcq 7*8(%[src]),%[res]\n\t"
> +		    "adcq $0,%[res]"
> +		    : [res] "+r" (temp64)
> +		    : [src] "r" (buff)
> +		    : "memory");
> +		buff += 64;
> +		len -= 64;
> +	}
> +
> +	if (len & 32) {
> +		asm("addq 0*8(%[src]),%[res]\n\t"
> +		    "adcq 1*8(%[src]),%[res]\n\t"
> +		    "adcq 2*8(%[src]),%[res]\n\t"
> +		    "adcq 3*8(%[src]),%[res]\n\t"
> +		    "adcq $0,%[res]"
> +			: [res] "+r" (temp64)
> +			: [src] "r" (buff)
> +			: "memory");
> +		buff += 32;
> +	}
> +	if (len & 16) {
> +		asm("addq 0*8(%[src]),%[res]\n\t"
> +		    "adcq 1*8(%[src]),%[res]\n\t"
> +		    "adcq $0,%[res]"
> +			: [res] "+r" (temp64)
> +			: [src] "r" (buff)
> +			: "memory");
> +		buff += 16;
> +	}
> +	if (len & 8) {
> +		asm("addq 0*8(%[src]),%[res]\n\t"
> +		    "adcq $0,%[res]"
> +			: [res] "+r" (temp64)
> +			: [src] "r" (buff)
> +			: "memory");
> +		buff += 8;
> +	}

I suspect it is worth doing:
	switch (len & 24) {
	}
and separately coding the 24 byte case
to reduce the number of 'adc $0,%reg'.
Although writing the conditions by hand might needed to get
the likely code first (whichever length it is).

> +	if (len & 7) {
> +		unsigned int shift = (8 - (len & 7)) * 8;
> +		unsigned long trail;
> 
> +		trail = (load_unaligned_zeropad(buff) << shift) >> shift;
> 
> +		asm("addq %[trail],%[res]\n\t"
> +		    "adcq $0,%[res]"
> +			: [res] "+r" (temp64)
> +			: [trail] "r" (trail));
>  	}

If you do the 'len & 7' test at the top the 56bit 'trail' value
can just be added to the 32bit 'sum' input.
Just:
		temp64 += *(u64 *)(buff + len - 8) << shift;
would do - except it can fall off the beginning of a page :-(
Maybe:
		temp64 += load_unaligned_zeropad(buff + (len & ~7)) & (~0ull >> shift);
Generating the mask reduces the register dependency chain length.

Although I remember trying to do something like this and finding
it was actually slower than the old code.
The problem is likely to be the long register chain generating 'shift'
compared to the latency of multiple memory reads that you only get once.
So potentially a 'switch (len & 6)' followed by a final test for odd
length may in fact be better - who knows.

> +	result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
>  	if (unlikely(odd)) {
>  		result = from32to16(result);
>  		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
>  	}
> +	return (__force __wsum)result;
>  }

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

