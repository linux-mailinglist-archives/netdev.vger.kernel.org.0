Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11766240585
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 14:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHJMBR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Aug 2020 08:01:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:46556 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbgHJMBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 08:01:16 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-260-nkm5nAmrOyipDTtP4l7K2Q-1; Mon, 10 Aug 2020 13:01:12 +0100
X-MC-Unique: nkm5nAmrOyipDTtP4l7K2Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 10 Aug 2020 13:01:11 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 10 Aug 2020 13:01:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>, George Spelvin <lkml@sdf.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "aksecurity@gmail.com" <aksecurity@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "lkml.mplumb@gmail.com" <lkml.mplumb@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "fw@strlen.de" <fw@strlen.de>
Subject: RE: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Thread-Topic: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Thread-Index: AQHWbwwF+YIY6C7gik6eIuQudA9QkKkxPI4A
Date:   Mon, 10 Aug 2020 12:01:11 +0000
Message-ID: <fe180697062643ac9538bf080e2de3d7@AcuMS.aculab.com>
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu> <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu> <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
In-Reply-To: <20200810114700.GB8474@1wt.eu>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau
> Sent: 10 August 2020 12:47
> On Sun, Aug 09, 2020 at 06:30:17PM +0000, George Spelvin wrote:
> > Even something simple like buffering 8 TSC samples, and adding them
> > at 32-bit offsets across the state every 8th call, would make a huge
> > difference.
> 
> Doing testing on real hardware showed that retrieving the TSC on every
> call had a non negligible cost, causing a loss of 2.5% on the accept()
> rate and 4% on packet rate when using iptables -m statistics. However
> I reused your idea of accumulating old TSCs to increase the uncertainty
> about their exact value, except that I retrieve it only on 1/8 calls
> and use the previous noise in this case. With this I observe the same
> performance as plain 5.8. Below are the connection rates accepted on
> a single core :
> 
>         5.8           5.8+patch     5.8+patch+tsc
>    192900-197900   188800->192200   194500-197500  (conn/s)
> 
> This was on a core i7-8700K. I looked at the asm code for the function
> and it remains reasonably light, in the same order of complexity as the
> original one, so I think we could go with that.
> 
> My proposed change is below, in case you have any improvements to suggest.
> 
> Regards,
> Willy
> 
> 
> diff --git a/lib/random32.c b/lib/random32.c
> index 2b048e2ea99f..a12d63028106 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -317,6 +317,8 @@ static void __init prandom_state_selftest(void)
> 
>  struct siprand_state {
>  	unsigned long v[4];
> +	unsigned long noise;
> +	unsigned long count;
>  };
> 
>  static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
> @@ -334,7 +336,7 @@ static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
>  #define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
>  #define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
> 
> -#elif BITS_PER_LONG == 23
> +#elif BITS_PER_LONG == 32
>  /*
>   * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
>   * This is weaker, but 32-bit machines are not used for high-traffic
> @@ -375,6 +377,12 @@ static u32 siprand_u32(struct siprand_state *s)
>  {
>  	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
> 
> +	if (++s->count >= 8) {
> +		v3 ^= s->noise;
> +		s->noise += random_get_entropy();
> +		s->count = 0;
> +	}
> +

Using:
	if (s->count-- <= 0) {
		...
		s->count = 8;
	}
probably generates better code.
Although you may want to use a 'signed int' instead of 'unsigned long'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

