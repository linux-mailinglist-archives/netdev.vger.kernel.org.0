Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02C323F85D
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgHHRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 13:45:45 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39549 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgHHRpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 13:45:44 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 078HipXU007482;
        Sat, 8 Aug 2020 19:44:51 +0200
Date:   Sat, 8 Aug 2020 19:44:51 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808174451.GA7429@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808152628.GA27941@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 03:26:28PM +0000, George Spelvin wrote:
> So any discussion of reseeding begins by *assuming* an attacker has
> captured the PRNG state.  If we weren't worried about this possibility,
> we wouldn't need to reseed in the first place!

Sure, but what matters is the time it takes to capture the state.
In the previous case it used to take Amit a few packets only. If it
takes longer than the reseeding period, then it's not captured anymore.
That was exactly the point there: break the certainty of the observations
so that the state cannot be reliably guessed anymore, hence cancelling
the concerns about the input bits being guessed. For sure if it is
assumed that the state is guessed nevertheless, this doesn't work
anymore, but that wasn't the assumption.

> Just like a buffer overflow, a working attack is plausible using a
> combination of well-understood techniques.  It's ridiculous to go to
> the effort of developing a full exploit when it's less work to fix the
> problem in the first place.

I totally agree with this principle. However, systematically starting
with assumptions like "the PRNG's state is known to the attacker" while
it's the purpose of the attack doesn't exactly match something which
does not warrant a bit more explanation. Otherwise I could as well say
in other contexts "let's assume I know the private key of this site's
certificate, after all it's only 2048 bits". And the reason why we're
looping here is that all explanations about the risk of losing entropy
are based on the assumption that the attacker has already won. The patch
was made to keep that assumption sufficiently away, otherwise it's
useless.

> A SOLUTION:
> 
> Now, how to fix it?
> 
> First, what is the problem?  "Non-cryptographic PRNGs are predictable"
> fits in the cateogry of Not A Bug.  There are may applications for
> a non-cryptographic PRNG in the kernel.  Self-tests, spreading wear
> across flash memory, randomized backoff among cooperating processes,
> and assigning IDs in protocols which aren't designed for DoS resistance
> in the first place.
> 
> But apparently the network code is (ab)using lib/random32.c for choosing
> TCP/UDP port numbers and someone has found a (not publicly disclosed)
> attack which exploits the predictability to commit some mischief.

Note, it's beyond predictability, it's reversibility at this point.

> And apparently switching to the fastest secure PRNG currently
> in the kernel (get_random_u32() using ChaCha + per-CPU buffers)
> would cause too much performance penalty.

Based on some quick userland tests, apparently yes.

> So the request is for a less predictable PRNG which is still extremely
> fast.

That was the goal around the MSWS PRNG, as it didn't leak its bits
and would require a certain amount of brute force.

> Well, the best crypto primitive I know of for such an application is
> SipHash.  Its 4x 64-bit words of state is only twice the size of the
> current struct rnd_state.  Converting it from a a pseudo-random function
> to a CRNG is some half-assed amateur cryptography, but at least it's a
> robust and well-studied primitive.

If it's considered as cryptographically secure, it's OK to feed it with
just a counter starting from a random value, since the only way to guess
the current counter state is to brute-force it, right ? I've done this in
the appended patch. Note that for now I've commented out all the reseeding
code because I just wanted to test the impact. 

In my perf measurements I've had some erratic behaviors, one test showing
almost no loss, and another one showing a lot, which didn't make sense, so
I'll need to measure again under better condition (i.e. not my laptop with
a variable frequency CPU).

> Willy Tarreau: Middle square + Weil sequence isn't even *close* to
> 	crypto-quality.

Absolutely, I've even said this myself.

>  And you're badly misunderstanding what the
> 	fast_pool is doing.  Please stop trying to invent your own crypto
> 	primitives; see
> 	https://www.schneier.com/crypto-gram/archives/1998/1015.html#cipherdesign

I know this pretty well and am NOT trying to invent crypto and am not
qualified for this. I'm not even trying to invent a PRNG myself because
there are some aspects I can't judge (such as measuring the sequence).
This is why I proposed to reuse some published work.

There seems to be some general thinking among many crypto-savvy people
that everything in the world needs strong crypto, including PRNGs, and
that doesn't always help. As you mentioned above, there are plenty of
valid use cases for weaker PRNGs, and my opinion (which may or may not
be shared) is that if guessing an internal state is expensive enough
for an attacker, either in terms of number of probes, or in brute-force
time, it may be sufficient for certain use cases. The main problem is
that every time someone says "oh it seems easy to guess a 16-bit port",
it's almost impossible not to receive proposals to implement expensive
super-strong crypto that will be suitable for everything. It would help
if security people would actually more often try to adapt to the context,
or explain why it still matters in a certain case. Actually that's what
Jason tried but as he already said, the covid outbreak arrived in the
middle of the work on this issue and stalled a lot of things.  

Regards,
Willy


commit dec36680a3f4888a7c026f8d40f978eec31ce1a1
Author: Willy Tarreau <w@1wt.eu>
Date:   Sun Apr 19 17:31:46 2020 +0200

    WIP: random32: use siphash with a counter for prandom_u32

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
diff --git a/include/linux/random.h b/include/linux/random.h
index 9ab7443bd91b..9e22973b207c 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/once.h>
 #include <asm/percpu.h>
+#include <linux/siphash.h>
 
 #include <uapi/linux/random.h>
 
@@ -117,7 +118,8 @@ void prandom_seed(u32 seed);
 void prandom_reseed_late(void);
 
 struct rnd_state {
-	__u32 s1, s2, s3, s4;
+	siphash_key_t key;
+	uint64_t counter;
 };
 
 DECLARE_PER_CPU(struct rnd_state, net_rand_state);
@@ -161,12 +163,14 @@ static inline u32 __seed(u32 x, u32 m)
  */
 static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
+#if 0
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
 	state->s1 = __seed(i,   2U);
 	state->s2 = __seed(i,   8U);
 	state->s3 = __seed(i,  16U);
 	state->s4 = __seed(i, 128U);
+#endif
 }
 
 #ifdef CONFIG_ARCH_RANDOM
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 026ac01af9da..c9d839c2b179 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1743,13 +1743,6 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	if (IS_ENABLED(CONFIG_POSIX_TIMERS))
 		run_posix_cpu_timers();
-
-	/* The current CPU might make use of net randoms without receiving IRQs
-	 * to renew them often enough. Let's update the net_rand_state from a
-	 * non-constant value that's not affine to the number of calls to make
-	 * sure it's updated when there's some activity (we don't care in idle).
-	 */
-	this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
 }
 
 /**
diff --git a/lib/random32.c b/lib/random32.c
index 3d749abb9e80..aa83cade911a 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -59,13 +59,8 @@ DEFINE_PER_CPU(struct rnd_state, net_rand_state);
  */
 u32 prandom_u32_state(struct rnd_state *state)
 {
-#define TAUSWORTHE(s, a, b, c, d) ((s & c) << d) ^ (((s << a) ^ s) >> b)
-	state->s1 = TAUSWORTHE(state->s1,  6U, 13U, 4294967294U, 18U);
-	state->s2 = TAUSWORTHE(state->s2,  2U, 27U, 4294967288U,  2U);
-	state->s3 = TAUSWORTHE(state->s3, 13U, 21U, 4294967280U,  7U);
-	state->s4 = TAUSWORTHE(state->s4,  3U, 12U, 4294967168U, 13U);
-
-	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4);
+	state->counter++;
+	return siphash(&state->counter, sizeof(state->counter), &state->key);
 }
 EXPORT_SYMBOL(prandom_u32_state);
 
@@ -161,12 +156,14 @@ static u32 __extract_hwseed(void)
 static void prandom_seed_early(struct rnd_state *state, u32 seed,
 			       bool mix_with_hwseed)
 {
+#if 0
 #define LCG(x)	 ((x) * 69069U)	/* super-duper LCG */
 #define HWSEED() (mix_with_hwseed ? __extract_hwseed() : 0)
 	state->s1 = __seed(HWSEED() ^ LCG(seed),        2U);
 	state->s2 = __seed(HWSEED() ^ LCG(state->s1),   8U);
 	state->s3 = __seed(HWSEED() ^ LCG(state->s2),  16U);
 	state->s4 = __seed(HWSEED() ^ LCG(state->s3), 128U);
+#endif
 }
 
 /**
@@ -184,8 +181,6 @@ void prandom_seed(u32 entropy)
 	 */
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-
-		state->s1 = __seed(state->s1 ^ entropy, 2U);
 		prandom_warmup(state);
 	}
 }
@@ -244,14 +239,8 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state)
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = per_cpu_ptr(pcpu_state, i);
-		u32 seeds[4];
-
-		get_random_bytes(&seeds, sizeof(seeds));
-		state->s1 = __seed(seeds[0],   2U);
-		state->s2 = __seed(seeds[1],   8U);
-		state->s3 = __seed(seeds[2],  16U);
-		state->s4 = __seed(seeds[3], 128U);
 
+		get_random_bytes(state, sizeof(*state));
 		prandom_warmup(state);
 	}
 }
