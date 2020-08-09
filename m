Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9323FD0D
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgHIG6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 02:58:40 -0400
Received: from mx.sdf.org ([205.166.94.24]:63647 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgHIG6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 02:58:40 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 0796vlbX028304
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 9 Aug 2020 06:57:48 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 0796viAx004572;
        Sun, 9 Aug 2020 06:57:44 GMT
Date:   Sun, 9 Aug 2020 06:57:44 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     netdev@vger.kernel.org
Cc:     w@1wt.eu, aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org,
        fw@strlen.de, George Spelvin <lkml@SDF.ORG>
Subject: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809065744.GA17668@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline;
        filename="0001-random32-Make-prandom_u32-output-difficult-to-predic.patch"
In-Reply-To: <20200808152628.GA27941@SDF.ORG>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non-cryptographic PRNGs may have great statistical proprties, but
are usually trivially predictable to someone who knows the algorithm,
given a small sample of their output.  An LFSR like prandom_u32() is
particularly simple, even if the sample is widely scattered bits.

It turns out the network stack uses prandom_u32() for some things like
random port numbers which it would prefer are *not* trivially predictable.
Predictability led to a practical DNS spoofing attack.  Oops.

This patch replaces the LFSR with a homebrew cryptographic PRNG based
on the SipHash round function, which is in turn seeded with 128 bits
of strong random key.  (The authors of SipHash have *not* been consulted
about this abuse of their algorithm.)  Speed is prioritized over security;
attacks are rare, while performance is always wanted.

Replacing all callers of prandom_u32() is the quick fix.
Whether to reinstate a weaker PRNG for uses which can tolerate it
is an open question.

TODO: The prandom_seed() function is currently a no-op stub.
It's not obvious how to use this additional data, so suggestions are
invited.

f227e3ec3b5c ("random32: update the net random state on interrupt and
activity") was an earlier attempt at a solution.  This patch
replaces it; revert it before applying this one.

Reported-by: Amit Klein <aksecurity@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: f227e3ec3b5c ("random32: update the net random state on interrupt and activity")
Replaces: f227e3ec3b5c ("random32: update the net random state on interrupt and activity")
Signed-off-by: George Spelvin <lkml@sdf.org>
---
 lib/random32.c | 437 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 267 insertions(+), 170 deletions(-)

I haven't yet rebooted, so this is only build-tested, but it should illustrate
the idea.

diff --git a/lib/random32.c b/lib/random32.c
index 763b920a6206c..2b048e2ea99f6 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -48,8 +48,6 @@ static inline void prandom_state_selftest(void)
 }
 #endif
 
-static DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
-
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
  *	@state: pointer to state structure holding seeded state.
@@ -69,25 +67,6 @@ u32 prandom_u32_state(struct rnd_state *state)
 }
 EXPORT_SYMBOL(prandom_u32_state);
 
-/**
- *	prandom_u32 - pseudo random number generator
- *
- *	A 32 bit pseudo-random number is generated using a fast
- *	algorithm suitable for simulation. This algorithm is NOT
- *	considered safe for cryptographic use.
- */
-u32 prandom_u32(void)
-{
-	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	u32 res;
-
-	res = prandom_u32_state(state);
-	put_cpu_var(net_rand_state);
-
-	return res;
-}
-EXPORT_SYMBOL(prandom_u32);
-
 /**
  *	prandom_bytes_state - get the requested number of pseudo-random bytes
  *
@@ -119,20 +98,6 @@ void prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
 }
 EXPORT_SYMBOL(prandom_bytes_state);
 
-/**
- *	prandom_bytes - get the requested number of pseudo-random bytes
- *	@buf: where to copy the pseudo-random bytes to
- *	@bytes: the requested number of bytes
- */
-void prandom_bytes(void *buf, size_t bytes)
-{
-	struct rnd_state *state = &get_cpu_var(net_rand_state);
-
-	prandom_bytes_state(state, buf, bytes);
-	put_cpu_var(net_rand_state);
-}
-EXPORT_SYMBOL(prandom_bytes);
-
 static void prandom_warmup(struct rnd_state *state)
 {
 	/* Calling RNG ten times to satisfy recurrence condition */
@@ -148,96 +113,6 @@ static void prandom_warmup(struct rnd_state *state)
 	prandom_u32_state(state);
 }
 
-static u32 __extract_hwseed(void)
-{
-	unsigned int val = 0;
-
-	(void)(arch_get_random_seed_int(&val) ||
-	       arch_get_random_int(&val));
-
-	return val;
-}
-
-static void prandom_seed_early(struct rnd_state *state, u32 seed,
-			       bool mix_with_hwseed)
-{
-#define LCG(x)	 ((x) * 69069U)	/* super-duper LCG */
-#define HWSEED() (mix_with_hwseed ? __extract_hwseed() : 0)
-	state->s1 = __seed(HWSEED() ^ LCG(seed),        2U);
-	state->s2 = __seed(HWSEED() ^ LCG(state->s1),   8U);
-	state->s3 = __seed(HWSEED() ^ LCG(state->s2),  16U);
-	state->s4 = __seed(HWSEED() ^ LCG(state->s3), 128U);
-}
-
-/**
- *	prandom_seed - add entropy to pseudo random number generator
- *	@entropy: entropy value
- *
- *	Add some additional entropy to the prandom pool.
- */
-void prandom_seed(u32 entropy)
-{
-	int i;
-	/*
-	 * No locking on the CPUs, but then somewhat random results are, well,
-	 * expected.
-	 */
-	for_each_possible_cpu(i) {
-		struct rnd_state *state = &per_cpu(net_rand_state, i);
-
-		state->s1 = __seed(state->s1 ^ entropy, 2U);
-		prandom_warmup(state);
-	}
-}
-EXPORT_SYMBOL(prandom_seed);
-
-/*
- *	Generate some initially weak seeding values to allow
- *	to start the prandom_u32() engine.
- */
-static int __init prandom_init(void)
-{
-	int i;
-
-	prandom_state_selftest();
-
-	for_each_possible_cpu(i) {
-		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		u32 weak_seed = (i + jiffies) ^ random_get_entropy();
-
-		prandom_seed_early(state, weak_seed, true);
-		prandom_warmup(state);
-	}
-
-	return 0;
-}
-core_initcall(prandom_init);
-
-static void __prandom_timer(struct timer_list *unused);
-
-static DEFINE_TIMER(seed_timer, __prandom_timer);
-
-static void __prandom_timer(struct timer_list *unused)
-{
-	u32 entropy;
-	unsigned long expires;
-
-	get_random_bytes(&entropy, sizeof(entropy));
-	prandom_seed(entropy);
-
-	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
-	expires = 40 + prandom_u32_max(40);
-	seed_timer.expires = jiffies + msecs_to_jiffies(expires * MSEC_PER_SEC);
-
-	add_timer(&seed_timer);
-}
-
-static void __init __prandom_start_seed_timer(void)
-{
-	seed_timer.expires = jiffies + msecs_to_jiffies(40 * MSEC_PER_SEC);
-	add_timer(&seed_timer);
-}
-
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state)
 {
 	int i;
@@ -257,51 +132,6 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state)
 }
 EXPORT_SYMBOL(prandom_seed_full_state);
 
-/*
- *	Generate better values after random number generator
- *	is fully initialized.
- */
-static void __prandom_reseed(bool late)
-{
-	unsigned long flags;
-	static bool latch = false;
-	static DEFINE_SPINLOCK(lock);
-
-	/* Asking for random bytes might result in bytes getting
-	 * moved into the nonblocking pool and thus marking it
-	 * as initialized. In this case we would double back into
-	 * this function and attempt to do a late reseed.
-	 * Ignore the pointless attempt to reseed again if we're
-	 * already waiting for bytes when the nonblocking pool
-	 * got initialized.
-	 */
-
-	/* only allow initial seeding (late == false) once */
-	if (!spin_trylock_irqsave(&lock, flags))
-		return;
-
-	if (latch && !late)
-		goto out;
-
-	latch = true;
-	prandom_seed_full_state(&net_rand_state);
-out:
-	spin_unlock_irqrestore(&lock, flags);
-}
-
-void prandom_reseed_late(void)
-{
-	__prandom_reseed(true);
-}
-
-static int __init prandom_reseed(void)
-{
-	__prandom_reseed(false);
-	__prandom_start_seed_timer();
-	return 0;
-}
-late_initcall(prandom_reseed);
-
 #ifdef CONFIG_RANDOM32_SELFTEST
 static struct prandom_test1 {
 	u32 seed;
@@ -463,3 +293,270 @@ static void __init prandom_state_selftest(void)
 		pr_info("prandom: %d self tests passed\n", runs);
 }
 #endif
+
+
+
+/*
+ * The prandom_u32() implementation is now completely separate from the
+ * prandom_state() functions, which are retained (for now) for compatibility.
+ *
+ * Because of (ab)use in the networking code for choosing random TCP/UDP port
+ * numbers, which open DoS possibilities if guessable, we want something
+ * stronger than a standard PRNG.  But the performance requirements of
+ * the network code do not allow robust crypto for this application.
+ *
+ * So this is a homebrew Junior Spaceman implementation, based on the
+ * lowest-latency trustworthy crypto primitive available, SipHash.
+ * (The authors of SipHash have not been consulted about this abuse of
+ * their work.)
+ *
+ * Standard SipHash-2-4 uses 2n+4 rounds to hash n words of input to
+ * one word of output.  This abbreviated version uses 2 rounds per word
+ * of output.
+ */
+
+struct siprand_state {
+	unsigned long v[4];
+};
+
+static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
+
+#if BITS_PER_LONG == 64
+/*
+ * The core SipHash round function.  Each line can be executed in
+ * parallel given enough CPU resources.
+ */
+#define SIPROUND(v0,v1,v2,v3) ( \
+	v0 += v1, v1 = rol64(v1, 13),  v2 += v3, v3 = rol64(v3, 16), \
+	v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
+	v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
+	v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  )
+#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
+#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
+
+#elif BITS_PER_LONG == 23
+/*
+ * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
+ * This is weaker, but 32-bit machines are not used for high-traffic
+ * applications, so there is less output for an attacker to analyze.
+ */
+#define SIPROUND(v0,v1,v2,v3) ( \
+	v0 += v1, v1 = rol32(v1,  5),  v2 += v3, v3 = rol32(v3,  8), \
+	v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
+	v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
+	v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  )
+#define K0 0x6c796765
+#define K1 0x74656462
+
+#else
+#error Unsupported BITS_PER_LONG
+#endif
+
+/*
+ * This is the core CPRNG function.  As "pseudorandom", this is not used
+ * for truly valuable things, just intended to be a PITA to guess.
+ * For maximum speed, we do just two SipHash rounds per word.  This is
+ * the same rate as 4 rounds per 64 bits that SipHash normally uses,
+ * so hopefully it's reasonably secure.
+ *
+ * There are two changes from the official SipHash finalization:
+ * - We omit some constants XORed with v2 in the SipHash spec as irrelevant;
+ *   they are there only to make the output rounds distinct from the input
+ *   rounds, and this application has no input rounds.
+ * - Rather than returning v0^v1^v2^v3, return v1+v3.
+ *   If you look at the SipHash round, the last operation on v3 is
+ *   "v3 ^= v0", so "v0 ^ v3" just undoes that, a waste of time.
+ *   Likewise "v1 ^= v2".  (The rotate of v2 makes a difference, but
+ *   it still cancels out half of the bits in v2 for no benefit.)
+ *   Second, since the last combining operation was xor, continue the
+ *   pattern of alternating xor/add for a tiny bit of extra non-linearity.
+ */
+static u32 siprand_u32(struct siprand_state *s)
+{
+	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
+
+	SIPROUND(v0, v1, v2, v3);
+	SIPROUND(v0, v1, v2, v3);
+	s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;
+	return v1 + v3;
+}
+
+
+/**
+ *	prandom_u32 - pseudo random number generator
+ *
+ *	A 32 bit pseudo-random number is generated using a fast
+ *	algorithm suitable for simulation. This algorithm is NOT
+ *	considered safe for cryptographic use.
+ */
+u32 prandom_u32(void)
+{
+	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
+	u32 res = siprand_u32(state);
+
+	put_cpu_ptr(&net_rand_state);
+	return res;
+}
+EXPORT_SYMBOL(prandom_u32);
+
+/**
+ *	prandom_bytes - get the requested number of pseudo-random bytes
+ *	@buf: where to copy the pseudo-random bytes to
+ *	@bytes: the requested number of bytes
+ */
+void prandom_bytes(void *buf, size_t bytes)
+{
+	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
+	u8 *ptr = buf;
+
+	while (bytes >= sizeof(u32)) {
+		put_unaligned(siprand_u32(state), (u32 *)ptr);
+		ptr += sizeof(u32);
+		bytes -= sizeof(u32);
+	}
+
+	if (bytes > 0) {
+		u32 rem = siprand_u32(state);
+		do {
+			*ptr++ = (u8)rem;
+			rem >>= BITS_PER_BYTE;
+		} while (--bytes > 0);
+	}
+	put_cpu_ptr(&net_rand_state);
+}
+EXPORT_SYMBOL(prandom_bytes);
+
+/**
+ *	prandom_seed - add entropy to pseudo random number generator
+ *	@entropy: entropy value
+ *
+ *	Add some additional seed material to the prandom pool.
+ *	The "entropy" is actually our IP address (the only caller is
+ *	the network code), not for unpredictability, but to ensure that
+ *	different machines are initialized differently.
+ */
+void prandom_seed(u32 entropy)
+{
+	/* FIXME: Where to feed this in? */
+}
+EXPORT_SYMBOL(prandom_seed);
+
+/*
+ *	Generate some initially weak seeding values to allow
+ *	the prandom_u32() engine to be started.
+ */
+static int __init prandom_init_early(void)
+{
+	int i;
+	unsigned long v0, v1, v2, v3;
+
+	if (!arch_get_random_long(&v0))
+		v0 = jiffies;
+	if (!arch_get_random_long(&v1))
+		v0 = random_get_entropy();
+	v2 = v0 ^ K0;
+	v3 = v1 ^ K1;
+
+	for_each_possible_cpu(i) {
+		struct siprand_state *state;
+
+		v3 ^= i;
+		SIPROUND(v0, v1, v2, v3);
+		SIPROUND(v0, v1, v2, v3);
+		v0 ^= i;
+
+		state = per_cpu_ptr(&net_rand_state, i);
+		state->v[0] = v0;  state->v[1] = v1;
+		state->v[2] = v2;  state->v[3] = v3;
+	}
+
+	return 0;
+}
+core_initcall(prandom_init_early);
+
+
+/* Stronger reseeding when available, and periodically thereafter. */
+static void prandom_reseed(struct timer_list *unused);
+
+static DEFINE_TIMER(seed_timer, prandom_reseed);
+
+static void prandom_reseed(struct timer_list *unused)
+{
+	unsigned long expires;
+	int i;
+
+	/*
+	 * Reinitialize each CPU's PRNG with 128 bits of key.
+	 * No locking on the CPUs, but then somewhat random results are,
+	 * well, expected.
+	 */
+	for_each_possible_cpu(i) {
+		struct siprand_state *state;
+		unsigned long v0 = get_random_long(), v2 = v0 ^ K0;
+		unsigned long v1 = get_random_long(), v3 = v1 ^ K1;
+#if BITS_PER_LONG == 32
+		int j;
+
+		/*
+		 * On 32-bit machines, hash in two extra words to
+		 * approximate 128-bit key length.  Not that the hash
+		 * has that much security, but this prevents a trivial
+		 * 64-bit brute force.
+		 */
+		for (j = 0; j < 2; j++) {
+			unsigned long m = get_random_long();
+			v3 ^= m;
+			SIPROUND(v0, v1, v2, v3);
+			SIPROUND(v0, v1, v2, v3);
+			v0 ^= m;
+		}
+#endif
+		/*
+		 * Probably impossible in practice, but there is a
+		 * theoretical risk that a race between this reseeding
+		 * and the target CPU writing its state back could
+		 * create the all-zero SipHash fixed point.
+		 *
+		 * To ensure that never happens, ensure the state
+		 * we write contains no zero words.
+		 */
+		state = per_cpu_ptr(&net_rand_state, i);
+		WRITE_ONCE(state->v[0], v0 ? v0 : -1ul);
+		WRITE_ONCE(state->v[1], v1 ? v1 : -1ul);
+		WRITE_ONCE(state->v[2], v2 ? v2 : -1ul);
+		WRITE_ONCE(state->v[3], v3 ? v3 : -1ul);
+	}
+
+	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
+	expires = round_jiffies(jiffies + 40 * HZ + prandom_u32_max(40 * HZ));
+	mod_timer(&seed_timer, expires);
+}
+
+/*
+ * The random ready callback can be called from almost any interrupt.
+ * To avoid worrying about whether it's safe to delay that interrupt
+ * long enough to seed all CPUs, just schedule an immediate timer event.
+ */
+static void prandom_timer_start(struct random_ready_callback *unused)
+{
+	mod_timer(&seed_timer, jiffies);
+}
+
+/*
+ * Start periodic full reseeding as soon as strong
+ * random numbers are available.
+ */
+static int __init prandom_init_late(void)
+{
+	static struct random_ready_callback random_ready = {
+	        .func = prandom_timer_start
+	};
+	int ret = add_random_ready_callback(&random_ready);
+
+	if (ret == -EALREADY) {
+		prandom_timer_start(&random_ready);
+		ret = 0;
+	}
+	return ret;
+}
+late_initcall(prandom_init_late);
-- 
2.28.0

