Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625FA5324BC
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiEXIBk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 May 2022 04:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiEXIB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:01:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC146205E3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:01:22 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-35-ppu1gej3NzGDz7Rk5zJVNA-1; Tue, 24 May 2022 09:01:19 +0100
X-MC-Unique: ppu1gej3NzGDz7Rk5zJVNA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 24 May 2022 09:01:18 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 24 May 2022 09:01:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Oleksandr Natalenko' <oleksandr@natalenko.name>,
        Neal Cardwell <ncardwell@google.com>
CC:     Yuchung Cheng <ycheng@google.com>,
        Yousuk Seung <ysseung@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Adithya Abraham Philip <abrahamphilip@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konstantin Demin" <rockdrilla@gmail.com>
Subject: RE: [RFC] tcp_bbr2: use correct 64-bit division
Thread-Topic: [RFC] tcp_bbr2: use correct 64-bit division
Thread-Index: AQHYbityIzPXZ3B6u0uaGlDnmUxgKq0tq8zw
Date:   Tue, 24 May 2022 08:01:18 +0000
Message-ID: <4bd84c983e77486fbc94dfa2a167afaa@AcuMS.aculab.com>
References: <4740526.31r3eYUQgx@natalenko.name>
In-Reply-To: <4740526.31r3eYUQgx@natalenko.name>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksandr Natalenko
> Sent: 22 May 2022 23:30
> To: Neal Cardwell <ncardwell@google.com>
> 
> Hello Neal.
> 
> It was reported to me [1] by Konstantin (in Cc) that BBRv2 code suffers from integer division issue on
> 32 bit systems.

Do any of these divisions ever actually have 64bit operands?
Even on x86-64 64bit divide is significantly slower than 32bit divide.

It is quite clear that x * 8 / 1000 is the same as x / (1000 / 8).
So promoting to 64bit cannot be needed.

	David

> 
> Konstantin suggested a solution available in the same linked merge request and copy-pasted by me below
> for your convenience:
> 
> ```
> diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
> index 664c9e119787..fd3f89e3a8a6 100644
> --- a/net/ipv4/tcp_bbr.c
> +++ b/net/ipv4/tcp_bbr.c
> @@ -312,7 +312,7 @@ static u32 bbr_tso_segs_generic(struct sock *sk, unsigned int mss_now,
>  	bytes = sk->sk_pacing_rate >> sk->sk_pacing_shift;
> 
>  	bytes = min_t(u32, bytes, gso_max_size - 1 - MAX_TCP_HEADER);
> -	segs = max_t(u32, bytes / mss_now, bbr_min_tso_segs(sk));
> +	segs = max_t(u32, div_u64(bytes, mss_now), bbr_min_tso_segs(sk));
>  	return segs;
>  }
> 
> diff --git a/net/ipv4/tcp_bbr2.c b/net/ipv4/tcp_bbr2.c
> index fa49e17c47ca..488429f0f3d0 100644
> --- a/net/ipv4/tcp_bbr2.c
> +++ b/net/ipv4/tcp_bbr2.c
> @@ -588,7 +588,7 @@ static void bbr_debug(struct sock *sk, u32 acked,
>  		 bbr_rate_kbps(sk, bbr_max_bw(sk)), /* bw: max bw */
>  		 0ULL,				    /* lb: [obsolete] */
>  		 0ULL,				    /* ib: [obsolete] */
> -		 (u64)sk->sk_pacing_rate * 8 / 1000,
> +		 div_u64((u64)sk->sk_pacing_rate * 8, 1000),
>  		 acked,
>  		 tcp_packets_in_flight(tp),
>  		 rs->is_ack_delayed ? 'd' : '.',
> @@ -698,7 +698,7 @@ static u32 bbr_tso_segs_generic(struct sock *sk, unsigned int mss_now,
>  	}
> 
>  	bytes = min_t(u32, bytes, gso_max_size - 1 - MAX_TCP_HEADER);
> -	segs = max_t(u32, bytes / mss_now, bbr_min_tso_segs(sk));
> +	segs = max_t(u32, div_u64(bytes, mss_now), bbr_min_tso_segs(sk));
>  	return segs;
>  }
> ```
> 
> Could you please evaluate this report and check whether it is correct, and also check whether the
> suggested patch is acceptable?
> 
> Thanks.
> 
> [1] https://gitlab.com/post-factum/pf-kernel/-/merge_requests/6
> 
> --
> Oleksandr Natalenko (post-factum)
> 

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

