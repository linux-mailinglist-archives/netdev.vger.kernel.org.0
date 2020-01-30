Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346E914DCD3
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgA3OcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 09:32:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:40048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgA3OcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 09:32:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E556AE19;
        Thu, 30 Jan 2020 14:32:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CD4BAE03DA; Thu, 30 Jan 2020 15:32:17 +0100 (CET)
Date:   Thu, 30 Jan 2020 15:32:17 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ttttabcd <ttttabcd@protonmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [RFC] tcp: syncookies: Interesting serious errors when
 generating and verification cookies
Message-ID: <20200130143217.GB20720@unicorn.suse.cz>
References: <MUBNBny50CpQ5J-18Cx99emdQLBJsj6NiZUx_YT2wTBKSWmpTt1Ly67TGbllsxL-JVA2fCESTWEk72hrLWBukVvZcN2-3DidrDdrLRN9g9M=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MUBNBny50CpQ5J-18Cx99emdQLBJsj6NiZUx_YT2wTBKSWmpTt1Ly67TGbllsxL-JVA2fCESTWEk72hrLWBukVvZcN2-3DidrDdrLRN9g9M=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 01:55:30PM +0000, Ttttabcd wrote:
> Following are the two core functions of current syncookies calculation generating and verification.
> 
> static __u32 secure_tcp_syn_cookie(__be32 saddr, __be32 daddr, __be16 sport,
> 				   __be16 dport, __u32 sseq, __u32 data)
> {
> 	/*
> 	 * Compute the secure sequence number.
> 	 * The output should be:
> 	 *   HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24)
> 	 *      + (HASH(sec2,saddr,sport,daddr,dport,count,sec2) % 2^24).
> 	 * Where sseq is their sequence number and count increases every
> 	 * minute by 1.
> 	 * As an extra hack, we add a small "data" value that encodes the
> 	 * MSS into the second hash value.
> 	 */
> 	u32 count = tcp_cookie_time();
> 	return (cookie_hash(saddr, daddr, sport, dport, 0, 0) +
> 		sseq + (count << COOKIEBITS) +
> 		((cookie_hash(saddr, daddr, sport, dport, count, 1) + data)
> 		 & COOKIEMASK));
> }
> 
> static __u32 check_tcp_syn_cookie(__u32 cookie, __be32 saddr, __be32 daddr,
> 				  __be16 sport, __be16 dport, __u32 sseq)
> {
> 	u32 diff, count = tcp_cookie_time();
> 
> 	/* Strip away the layers from the cookie */
> 	cookie -= cookie_hash(saddr, daddr, sport, dport, 0, 0) + sseq;
> 
> 	/* Cookie is now reduced to (count * 2^24) ^ (hash % 2^24) */
> 	diff = (count - (cookie >> COOKIEBITS)) & ((__u32) -1 >> COOKIEBITS);
> 	if (diff >= MAX_SYNCOOKIE_AGE)
> 		return (__u32)-1;
> 
> 	return (cookie -
> 		cookie_hash(saddr, daddr, sport, dport, count - diff, 1))
> 		& COOKIEMASK;	/* Leaving the data behind */
> }
> 
> Can you find the problem?
> 
> Generate formula is:
> 
> cookie = HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24)
>              + ((HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data) % 2^24)
> 
> Verification formula is:
> 
> data = (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - HASH(sec2,saddr,sport,daddr,dport,count,sec2)) % 2^24
> 
> I don't know if the final & is a modulo or an AND operation, but the result is the same.
> 
> Now, I think anyone will understand that the above calculation is wrong.
> 
> ---------------------------------------------------------------
> 
> We know that the last % 2^24 is to remove the upper 8 bits of counte * 2^24.
> 
> If we do not perform the final modulo, then the formula is:
> 
> (count * 2^24) + data = cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - HASH(sec2,saddr,sport,daddr,dport,count,sec2)
> 
> The conversion into a generating formula is:
> 
> cookie = HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24) + HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data
> 
> Compared with the real generation formula:
> 
> cookie = HASH(sec1,saddr,sport,daddr,dport,sec1) + sseq + (count * 2^24) + ((HASH(sec2,saddr,sport,daddr,dport,count,sec2) + data) % 2^24)
> 
> These two formulas are completely different!
> 
> So the final calculated (count * 2^24) + data is absolutely wrong.
> 
> The correct verification calculation should be:
> 
> data = (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - (HASH(sec2,saddr,sport,daddr,dport,count,sec2) % 2^24)) % 2^24
> 
> ------------------------------------------------------------------
> 
> The most interesting place came, the result of the final data turned out to be correct.
> 
> ((count * 2^24) + data) % 2^24 is correct!
> 
> Why?
> 
> correct verification calculation:
> 
> data = (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - (HASH(sec2,saddr,sport,daddr,dport,count,sec2) % 2^24)) % 2^24
> 
> current verification formula:
> 
> data = (cookie - HASH(sec1,saddr,sport,daddr,dport,sec1) - sseq - HASH(sec2,saddr,sport,daddr,dport,count,sec2)) % 2^24
> 
> What do you find in comparison? The difference is that before subtracting HASH(sec2, saddr, sport, daddr, dport, count, sec2) we have to take the modulus first.
> 
> We know that modulo a % 2^n is equivalent to a & (2^n - 1). So the correct calculation is to subtract the lower 24 bits of HASH2. The current practice is to subtract the entire 32 bits of HASH2.
> 
> The error is only in the high bit and has no effect on the low bit.
> 
> data is in low bit!
> 
> Amazing coincidence reached the right result with the wrong implementation.
> 
> Therefore, this wrong implementation has been used for many years without any problems.

What I don't understand is that even if you yourself concluded that the
implementation provides correct result for any possible values, you
still insist on calling it "wrong". Why?

Rather than "coincidence", I would call this optimization based on
trivial identity

  (a - b % m) % m = (a - b) % m

together with the usual trick that if m is a power of two, "% m" is
equivalent to "& (m - 1)". To put it simply, if we know we are going to
mask out upper bits eventually, there is no reason to do the same with
one of the operands before the subtraction.

> In the end I raised this RFC to ask, should we fix this implementation?

I wouldn't be even surprised if the compiler translated both versions
into the same code. If it does, what you suggest would be pointless as
you yourself proved. If not, what you call "fix this implementation"
would only add an extra instruction for no gain.

Michal
