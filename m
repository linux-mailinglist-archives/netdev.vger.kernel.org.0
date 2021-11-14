Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B644F7FC
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhKNNK0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 14 Nov 2021 08:10:26 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:58608 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230186AbhKNNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 08:10:15 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-132-mj8KR5zHN0GbCvVfZp2Q6Q-1; Sun, 14 Nov 2021 13:07:08 +0000
X-MC-Unique: mj8KR5zHN0GbCvVfZp2Q6Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 14 Nov 2021 13:07:07 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 14 Nov 2021 13:07:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [RFC] x86/csum: rewrite csum_partial()
Thread-Topic: [RFC] x86/csum: rewrite csum_partial()
Thread-Index: AQHX1sjWUoYmK80LukOvYdZq9v09u6wC9Srg
Date:   Sun, 14 Nov 2021 13:07:06 +0000
Message-ID: <e6fcc05d59974ba9afa49ba07a7251aa@AcuMS.aculab.com>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
In-Reply-To: <20211111065322.1261275-1-eric.dumazet@gmail.com>
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
> Sent: 11 November 2021 06:53
> 
> With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> csum_partial() is heavily used with small amount of bytes,
> and is consuming many cycles.
> 
> IPv6 header size for instance is 40 bytes.
> 
> Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> meaning that network headers in RX path are not word-aligned,
> unless the driver forces this.
> 
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform seven u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
> 
> With this new version, we perform 10 u32 adds with carry, to
> avoid the expensive 64->32 transformation. Using 5 u64 adds
> plus one add32_with_carry() is more expensive.
> 
> Also note that this avoids loops for less than ~60 bytes.

I spent far too long looking at this code a while back :-)
I did post a patch - probably 10th May 2020.

Prior to Sandy bridge ADC always took two clocks.
Even on Sandy bridge there is a two clock delay for the sum,
only the carry flag is available earlier.
Broadwell (and I think all AMD cpu) do ADC in 1 clock.
This can be avoided by adding to alternate registers.
There are also issues on some cpu with the partial updates
to the flags register (DEC sets Z but not C) causing unwanted
register dependencies.

I think misaligned memory reads take an extra clock.
But more recent cpu can do two memory reads per clock.
So unless the code is trying to beat 8 bytes/clock it
shouldn't have much effect.

The fastest loop I found (for large buffers) used:

+       asm(    "       bt    $4, %[len]\n"
+               "       jnc   10f\n"
+               "       add   (%[buff], %[len]), %[sum_0]\n"
+               "       adc   8(%[buff], %[len]), %[sum_1]\n"
+               "       lea   16(%[len]), %[len]\n"
+               "10:    jecxz 20f\n"
+               "       adc   (%[buff], %[len]), %[sum_0]\n"
+               "       adc   8(%[buff], %[len]), %[sum_1]\n"
+               "       lea   32(%[len]), %[len_tmp]\n"
+               "       adc   16(%[buff], %[len]), %[sum_0]\n"
+               "       adc   24(%[buff], %[len]), %[sum_1]\n"
+               "       mov   %[len_tmp], %[len]\n"
+               "       jmp   10b\n"
+               "20:    adc   %[sum_0], %[sum]\n"
+               "       adc   %[sum_1], %[sum]\n"
+               "       adc   $0, %[sum]\n"
+           : [sum] "+&r" (sum), [sum_0] "+&r" (sum_0), [sum_1] "+&r" (sum_1),
+               [len] "+&c" (len), [len_tmp] "=&r" (len_tmp)
+           : [buff] "r" (buff)
+           : "memory" );

The principle is that 'buff' points to the end on the buffer.
The 'length' (in %cx) is negative and then increased until it hits zero.

This runs at 8 bytes/clock on anything recent (and approaches it on Ivy bridge).
Splitting the 'add 32' did make a slight improvement.
If you aren't worried (too much) about cpu before Bradwell then IIRC
this loop gets close to 8 bytes/clock:

+               "10:    jecxz 20f\n"
+               "       adc   (%[buff], %[len]), %[sum]\n"
+               "       adc   8(%[buff], %[len]), %[sum]\n"
+               "       lea   16(%[len]), %[tmp]\n"
+               "       jmp   10b\n"
+               " 20:"

I also toyed with this loop:

            count = (lim + 7 - buf) & -64;
            buf += count;

            count = -count;
            asm(    "       xor   %[sum_odd], %[sum_odd]\n"    // Also clears carry and overflow
                    "10:    jrcxz 20f\n"
                    "       adcx    (%[buf], %[count]), %[sum]\n"
                    "       adox   8(%[buf], %[count]), %[sum_odd]\n"
                    "       adcx  16(%[buf], %[count]), %[sum]\n"
                    "       adox  24(%[buf], %[count]), %[sum_odd]\n"
                    "       adcx  32(%[buf], %[count]), %[sum]\n"
                    "       adox  40(%[buf], %[count]), %[sum_odd]\n"
                    "       adcx  48(%[buf], %[count]), %[sum]\n"
                    "       adox  56(%[buf], %[count]), %[sum_odd]\n"
                    "       lea   64(%[count]), %[count]\n"
                    "       jmp   10b\n"
                    "20:    adox  %[count], %[sum_odd]\n"  // [count] is zero
                    "       adcx  %[sum_odd], %[sum]\n"
                    "       adcx  %[count], %[sum]"
                : [sum] "=&r" (sum), [count] "=&c" (count), [sum_odd] "=&r" (sum_odd)
                : [buf] "r" (buf), "0" (sum), "1" (count)
                : "memory");
        }

My notes say it achieved 12 bytes/clock on an i7-7700.
However it is only really useful for long aligned buffers.

It is completely annoying that you can't use LOOP (dec %cx and jump nz)
because it is very slow on Intel cpu - even ones that support adox).
JCZX is fine.

It is also possible to reduce the checksum to 16 bits using:
	sum = (sum % 0xffff) ^ 0xffff;
I think this is faster if gcc uses a 'multiply by reciprocal'
but (in my tests) it sometimes used a divide.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

