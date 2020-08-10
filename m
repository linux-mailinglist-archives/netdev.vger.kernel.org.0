Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA78241210
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgHJVFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 17:05:51 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39733 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgHJVFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 17:05:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07AL4tN0009204;
        Mon, 10 Aug 2020 23:04:55 +0200
Date:   Mon, 10 Aug 2020 23:04:55 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <lkml@sdf.org>, Florian Westphal <fw@strlen.de>
Cc:     Netdev <netdev@vger.kernel.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810210455.GA9194@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
 <20200810165859.GD9060@1wt.eu>
 <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus, George, Florian,

would something in this vein be OK in your opinion ?

- update_process_times still updates the noise
- we don't touch the fast_pool anymore
- we don't read any TSC on hot paths
- we update the noise in xmit from jiffies and a few pointer values instead

I've applied it on top of George's patch rebased to mainline for simplicity.
I've used a separate per_cpu noise variable to keep the net_rand_state static
with its __latent_entropy.

With this I'm even getting very slightly better performance than with
the previous patch (195.7 - 197.8k cps).

What could be improved is the way the input values are mixed (just
added hence commutative for now). I didn't want to call a siphash
round on the hot paths, but just shifting the previous noise value
before adding would work, such as the following for example:

  void prandom_u32_add_noise(a, b, c, d)
  {
  	unsigned long *noise = get_cpu_ptr(&net_rand_noise);

  #if BITS_PER_LONG == 64
	*noise = rol64(*noise, 7) + a + b + c + d;
  #else
	*noise = rol32(*noise, 7) + a + b + c + d;
  #endif
  	put_cpu_ptr(&net_rand_noise);

  }

Thanks,
Willy

---


diff --git a/drivers/char/random.c b/drivers/char/random.c
index d20ba1b104ca..2a41b21623ae 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1277,7 +1277,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
-	this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index aa16e6468f91..e2b4990f2126 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -20,7 +20,7 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
-DECLARE_PER_CPU(struct rnd_state, net_rand_state);
+DECLARE_PER_CPU(unsigned long, net_rand_noise);
 
 u32 prandom_u32_state(struct rnd_state *state);
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
@@ -67,6 +67,7 @@ static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 	state->s2 = __seed(i,   8U);
 	state->s3 = __seed(i,  16U);
 	state->s4 = __seed(i, 128U);
+	__this_cpu_add(net_rand_noise, i);
 }
 
 /* Pseudo random number generator from numerical recipes. */
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index ae5029f984a8..2f07c569af77 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1721,7 +1721,7 @@ void update_process_times(int user_tick)
 	 * non-constant value that's not affine to the number of calls to make
 	 * sure it's updated when there's some activity (we don't care in idle).
 	 */
-	this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
+	__this_cpu_add(net_rand_noise, rol32(jiffies, 24) + user_tick);
 }
 
 /**
diff --git a/lib/random32.c b/lib/random32.c
index 2b048e2ea99f..d74cf1db8cc9 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -320,6 +320,8 @@ struct siprand_state {
 };
 
 static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
+DEFINE_PER_CPU(unsigned long, net_rand_noise);
+EXPORT_SYMBOL(net_rand_noise);
 
 #if BITS_PER_LONG == 64
 /*
@@ -334,7 +336,7 @@ static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
 #define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
 #define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
 
-#elif BITS_PER_LONG == 23
+#elif BITS_PER_LONG == 32
 /*
  * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
  * This is weaker, but 32-bit machines are not used for high-traffic
@@ -374,9 +376,12 @@ static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
 static u32 siprand_u32(struct siprand_state *s)
 {
 	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
+	unsigned long n = __this_cpu_read(net_rand_noise);
 
+	v3 ^= n;
 	SIPROUND(v0, v1, v2, v3);
 	SIPROUND(v0, v1, v2, v3);
+	v0 ^= n;
 	s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;
 	return v1 + v3;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..55a2471cd75b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -144,6 +144,7 @@
 #include <linux/indirect_call_wrapper.h>
 #include <net/devlink.h>
 #include <linux/pm_runtime.h>
+#include <linux/prandom.h>
 
 #include "net-sysfs.h"
 
@@ -3557,6 +3558,7 @@ static int xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dev_queue_xmit_nit(skb, dev);
 
 	len = skb->len;
+	__this_cpu_add(net_rand_noise, (long)skb + (long)dev + (long)txq + len + jiffies);
 	trace_net_dev_start_xmit(skb, dev);
 	rc = netdev_start_xmit(skb, dev, txq, more);
 	trace_net_dev_xmit(skb, rc, dev, len);
@@ -4129,6 +4131,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			if (!skb)
 				goto out;
 
+			__this_cpu_add(net_rand_noise, (long)skb + (long)dev + (long)txq + jiffies);
 			HARD_TX_LOCK(dev, txq, cpu);
 
 			if (!netif_xmit_stopped(txq)) {
@@ -4194,6 +4197,7 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 
 	skb_set_queue_mapping(skb, queue_id);
 	txq = skb_get_tx_queue(dev, skb);
+	__this_cpu_add(net_rand_noise, (long)skb + (long)dev + (long)txq + jiffies);
 
 	local_bh_disable();
 
