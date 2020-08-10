Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA4240573
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 13:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHJLrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 07:47:24 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39663 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgHJLrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 07:47:23 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07ABl0kf008607;
        Mon, 10 Aug 2020 13:47:00 +0200
Date:   Mon, 10 Aug 2020 13:47:00 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810114700.GB8474@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809183017.GC25124@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Sun, Aug 09, 2020 at 06:30:17PM +0000, George Spelvin wrote:
> Even something simple like buffering 8 TSC samples, and adding them
> at 32-bit offsets across the state every 8th call, would make a huge
> difference.

Doing testing on real hardware showed that retrieving the TSC on every
call had a non negligible cost, causing a loss of 2.5% on the accept()
rate and 4% on packet rate when using iptables -m statistics. However
I reused your idea of accumulating old TSCs to increase the uncertainty
about their exact value, except that I retrieve it only on 1/8 calls
and use the previous noise in this case. With this I observe the same
performance as plain 5.8. Below are the connection rates accepted on
a single core :

        5.8           5.8+patch     5.8+patch+tsc
   192900-197900   188800->192200   194500-197500  (conn/s)

This was on a core i7-8700K. I looked at the asm code for the function
and it remains reasonably light, in the same order of complexity as the
original one, so I think we could go with that.

My proposed change is below, in case you have any improvements to suggest.

Regards,
Willy


diff --git a/lib/random32.c b/lib/random32.c
index 2b048e2ea99f..a12d63028106 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -317,6 +317,8 @@ static void __init prandom_state_selftest(void)
 
 struct siprand_state {
 	unsigned long v[4];
+	unsigned long noise;
+	unsigned long count;
 };
 
 static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
@@ -334,7 +336,7 @@ static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
 #define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
 #define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
 
-#elif BITS_PER_LONG == 23
+#elif BITS_PER_LONG == 32
 /*
  * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
  * This is weaker, but 32-bit machines are not used for high-traffic
@@ -375,6 +377,12 @@ static u32 siprand_u32(struct siprand_state *s)
 {
 	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
 
+	if (++s->count >= 8) {
+		v3 ^= s->noise;
+		s->noise += random_get_entropy();
+		s->count = 0;
+	}
+
 	SIPROUND(v0, v1, v2, v3);
 	SIPROUND(v0, v1, v2, v3);
 	s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;
