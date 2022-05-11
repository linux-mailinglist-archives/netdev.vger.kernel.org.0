Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0634523599
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244717AbiEKOdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240682AbiEKOdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:33:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828265437;
        Wed, 11 May 2022 07:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E87B8214A;
        Wed, 11 May 2022 14:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EF7C34113;
        Wed, 11 May 2022 14:33:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cY+zY9XA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1652279614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1ShbYN76P52wMMWdLuf5a0SE12YJgQYCBRIdAeSMtdo=;
        b=cY+zY9XAvEyVeCoDMg2YL8vEWwF8NWPez96lV/LKEjInMd6BgcmT6e3GAkzDUHJkMazMW8
        f0JZV2GGpKBInCKkfb1Ljl1Vg8OkdMpnn/jN31dFTljhevp4TGyrklga+WMDrPRyBE2e7c
        9rvTZ1z0VEeh/kRfsewQQ6nu8ORbgEk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9280fdfc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 11 May 2022 14:33:33 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] random32: use real rng for non-deterministic randomness
Date:   Wed, 11 May 2022 16:32:57 +0200
Message-Id: <20220511143257.88442-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

random32.c has two RNGs in it: one that is meant to be used
deterministically, with some predefined seed, and one that does the same
exact thing as random.c, except does it poorly. The first one has some
use cases. The second one no longer does and can be replaced with calls
to random.c's proper random number generator.

The relatively recent siphash-based bad random32.c code was added in
response to concerns that the prior random32.c was too deterministic.
Out of fears that random.c was (at the time) too slow, this code was
anonymously contributed by somebody who was likely reusing the alias of
long time anonymous contributor George Spelvin. Then out of that emerged
a kind of shadow entropy gathering system, with its own tentacles
throughout various net code, added willy nilly.

Stop👏making👏crappy👏bespoke👏random👏number👏generators👏.

Fortunately, recently advances in random.c mean that we can stop playing
with this sketchiness, and just use get_random_u32(), which is now fast
enough. In micro benchmarks using RDPMC, I'm seeing the same median
cycle count between the two functions, with the mean being _slightly_
higher due to batches refilling (which we can optimize further need be).
However, when doing *real* benchmarks of the net functions that actually
use these random numbers, the mean cycles actually *decreased* slightly
(with the median still staying the same), likely because the additional
prandom code means icache misses and complexity, whereas random.c is
generally already being used by something else nearby.

The biggest benefit of this is that there are many users of prandom who
probably should be using cryptographically secure random numbers. This
makes all of those accidental cases become secure by just flipping a
switch. Later on, we can do a tree-wide cleanup to remove the static
inline wrapper functions that this commit adds.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Jakub - If there are no objections to this plan, I intend on taking this
through the random.git tree, which is what this commit is based on, with
its recent siphash changes and such. -Jason


 include/linux/prandom.h |  68 ++-------
 kernel/time/timer.c     |   2 -
 lib/random32.c          | 321 ----------------------------------------
 net/core/dev.c          |   3 -
 net/ipv4/devinet.c      |   4 +-
 net/ipv6/addrconf.c     |   2 -
 6 files changed, 16 insertions(+), 384 deletions(-)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index a4aadd2dc153..77040efd77ef 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -10,53 +10,16 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
-#include <linux/siphash.h>
+#include <linux/random.h>
 
-u32 prandom_u32(void);
-void prandom_bytes(void *buf, size_t nbytes);
-void prandom_seed(u32 seed);
-void prandom_reseed_late(void);
-
-DECLARE_PER_CPU(unsigned long, net_rand_noise);
-
-#define PRANDOM_ADD_NOISE(a, b, c, d) \
-	prandom_u32_add_noise((unsigned long)(a), (unsigned long)(b), \
-			      (unsigned long)(c), (unsigned long)(d))
-
-#if BITS_PER_LONG == 64
-/*
- * The core SipHash round function.  Each line can be executed in
- * parallel given enough CPU resources.
- */
-#define PRND_SIPROUND(v0, v1, v2, v3) SIPHASH_PERMUTATION(v0, v1, v2, v3)
-
-#define PRND_K0 (SIPHASH_CONST_0 ^ SIPHASH_CONST_2)
-#define PRND_K1 (SIPHASH_CONST_1 ^ SIPHASH_CONST_3)
-
-#elif BITS_PER_LONG == 32
-/*
- * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
- * This is weaker, but 32-bit machines are not used for high-traffic
- * applications, so there is less output for an attacker to analyze.
- */
-#define PRND_SIPROUND(v0, v1, v2, v3) HSIPHASH_PERMUTATION(v0, v1, v2, v3)
-#define PRND_K0 (HSIPHASH_CONST_0 ^ HSIPHASH_CONST_2)
-#define PRND_K1 (HSIPHASH_CONST_1 ^ HSIPHASH_CONST_3)
-
-#else
-#error Unsupported BITS_PER_LONG
-#endif
+static inline u32 prandom_u32(void)
+{
+	return get_random_u32();
+}
 
-static inline void prandom_u32_add_noise(unsigned long a, unsigned long b,
-					 unsigned long c, unsigned long d)
+static inline void prandom_bytes(void *buf, size_t nbytes)
 {
-	/*
-	 * This is not used cryptographically; it's just
-	 * a convenient 4-word hash function. (3 xor, 2 add, 2 rol)
-	 */
-	a ^= raw_cpu_read(net_rand_noise);
-	PRND_SIPROUND(a, b, c, d);
-	raw_cpu_write(net_rand_noise, d);
+	return get_random_bytes(buf, nbytes);
 }
 
 struct rnd_state {
@@ -70,6 +33,14 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
 #define prandom_init_once(pcpu_state)			\
 	DO_ONCE(prandom_seed_full_state, (pcpu_state))
 
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
+{
+	return (x < m) ? x + m : x;
+}
+
 /**
  * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
  * @ep_ro: right open interval endpoint
@@ -87,14 +58,6 @@ static inline u32 prandom_u32_max(u32 ep_ro)
 	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
 }
 
-/*
- * Handle minimum values for seeds
- */
-static inline u32 __seed(u32 x, u32 m)
-{
-	return (x < m) ? x + m : x;
-}
-
 /**
  * prandom_seed_state - set seed for prandom_u32_state().
  * @state: pointer to state structure to receive the seed.
@@ -108,7 +71,6 @@ static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 	state->s2 = __seed(i,   8U);
 	state->s3 = __seed(i,  16U);
 	state->s4 = __seed(i, 128U);
-	PRANDOM_ADD_NOISE(state, i, 0, 0);
 }
 
 /* Pseudo random number generator from numerical recipes. */
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9dd2a39cb3b0..c12fe329c9ff 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1780,8 +1780,6 @@ void update_process_times(int user_tick)
 {
 	struct task_struct *p = current;
 
-	PRANDOM_ADD_NOISE(jiffies, user_tick, p, 0);
-
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
 	run_local_timers();
diff --git a/lib/random32.c b/lib/random32.c
index 976632003ec6..7aed7e7cf214 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -310,324 +310,3 @@ static int __init prandom_state_selftest(void)
 }
 core_initcall(prandom_state_selftest);
 #endif
-
-/*
- * The prandom_u32() implementation is now completely separate from the
- * prandom_state() functions, which are retained (for now) for compatibility.
- *
- * Because of (ab)use in the networking code for choosing random TCP/UDP port
- * numbers, which open DoS possibilities if guessable, we want something
- * stronger than a standard PRNG.  But the performance requirements of
- * the network code do not allow robust crypto for this application.
- *
- * So this is a homebrew Junior Spaceman implementation, based on the
- * lowest-latency trustworthy crypto primitive available, SipHash.
- * (The authors of SipHash have not been consulted about this abuse of
- * their work.)
- *
- * Standard SipHash-2-4 uses 2n+4 rounds to hash n words of input to
- * one word of output.  This abbreviated version uses 2 rounds per word
- * of output.
- */
-
-struct siprand_state {
-	unsigned long v0;
-	unsigned long v1;
-	unsigned long v2;
-	unsigned long v3;
-};
-
-static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
-DEFINE_PER_CPU(unsigned long, net_rand_noise);
-EXPORT_PER_CPU_SYMBOL(net_rand_noise);
-
-/*
- * This is the core CPRNG function.  As "pseudorandom", this is not used
- * for truly valuable things, just intended to be a PITA to guess.
- * For maximum speed, we do just two SipHash rounds per word.  This is
- * the same rate as 4 rounds per 64 bits that SipHash normally uses,
- * so hopefully it's reasonably secure.
- *
- * There are two changes from the official SipHash finalization:
- * - We omit some constants XORed with v2 in the SipHash spec as irrelevant;
- *   they are there only to make the output rounds distinct from the input
- *   rounds, and this application has no input rounds.
- * - Rather than returning v0^v1^v2^v3, return v1+v3.
- *   If you look at the SipHash round, the last operation on v3 is
- *   "v3 ^= v0", so "v0 ^ v3" just undoes that, a waste of time.
- *   Likewise "v1 ^= v2".  (The rotate of v2 makes a difference, but
- *   it still cancels out half of the bits in v2 for no benefit.)
- *   Second, since the last combining operation was xor, continue the
- *   pattern of alternating xor/add for a tiny bit of extra non-linearity.
- */
-static inline u32 siprand_u32(struct siprand_state *s)
-{
-	unsigned long v0 = s->v0, v1 = s->v1, v2 = s->v2, v3 = s->v3;
-	unsigned long n = raw_cpu_read(net_rand_noise);
-
-	v3 ^= n;
-	PRND_SIPROUND(v0, v1, v2, v3);
-	PRND_SIPROUND(v0, v1, v2, v3);
-	v0 ^= n;
-	s->v0 = v0;  s->v1 = v1;  s->v2 = v2;  s->v3 = v3;
-	return v1 + v3;
-}
-
-
-/**
- *	prandom_u32 - pseudo random number generator
- *
- *	A 32 bit pseudo-random number is generated using a fast
- *	algorithm suitable for simulation. This algorithm is NOT
- *	considered safe for cryptographic use.
- */
-u32 prandom_u32(void)
-{
-	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
-	u32 res = siprand_u32(state);
-
-	put_cpu_ptr(&net_rand_state);
-	return res;
-}
-EXPORT_SYMBOL(prandom_u32);
-
-/**
- *	prandom_bytes - get the requested number of pseudo-random bytes
- *	@buf: where to copy the pseudo-random bytes to
- *	@bytes: the requested number of bytes
- */
-void prandom_bytes(void *buf, size_t bytes)
-{
-	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
-	u8 *ptr = buf;
-
-	while (bytes >= sizeof(u32)) {
-		put_unaligned(siprand_u32(state), (u32 *)ptr);
-		ptr += sizeof(u32);
-		bytes -= sizeof(u32);
-	}
-
-	if (bytes > 0) {
-		u32 rem = siprand_u32(state);
-
-		do {
-			*ptr++ = (u8)rem;
-			rem >>= BITS_PER_BYTE;
-		} while (--bytes > 0);
-	}
-	put_cpu_ptr(&net_rand_state);
-}
-EXPORT_SYMBOL(prandom_bytes);
-
-/**
- *	prandom_seed - add entropy to pseudo random number generator
- *	@entropy: entropy value
- *
- *	Add some additional seed material to the prandom pool.
- *	The "entropy" is actually our IP address (the only caller is
- *	the network code), not for unpredictability, but to ensure that
- *	different machines are initialized differently.
- */
-void prandom_seed(u32 entropy)
-{
-	int i;
-
-	add_device_randomness(&entropy, sizeof(entropy));
-
-	for_each_possible_cpu(i) {
-		struct siprand_state *state = per_cpu_ptr(&net_rand_state, i);
-		unsigned long v0 = state->v0, v1 = state->v1;
-		unsigned long v2 = state->v2, v3 = state->v3;
-
-		do {
-			v3 ^= entropy;
-			PRND_SIPROUND(v0, v1, v2, v3);
-			PRND_SIPROUND(v0, v1, v2, v3);
-			v0 ^= entropy;
-		} while (unlikely(!v0 || !v1 || !v2 || !v3));
-
-		WRITE_ONCE(state->v0, v0);
-		WRITE_ONCE(state->v1, v1);
-		WRITE_ONCE(state->v2, v2);
-		WRITE_ONCE(state->v3, v3);
-	}
-}
-EXPORT_SYMBOL(prandom_seed);
-
-/*
- *	Generate some initially weak seeding values to allow
- *	the prandom_u32() engine to be started.
- */
-static int __init prandom_init_early(void)
-{
-	int i;
-	unsigned long v0, v1, v2, v3;
-
-	if (!arch_get_random_long(&v0))
-		v0 = jiffies;
-	if (!arch_get_random_long(&v1))
-		v1 = random_get_entropy();
-	v2 = v0 ^ PRND_K0;
-	v3 = v1 ^ PRND_K1;
-
-	for_each_possible_cpu(i) {
-		struct siprand_state *state;
-
-		v3 ^= i;
-		PRND_SIPROUND(v0, v1, v2, v3);
-		PRND_SIPROUND(v0, v1, v2, v3);
-		v0 ^= i;
-
-		state = per_cpu_ptr(&net_rand_state, i);
-		state->v0 = v0;  state->v1 = v1;
-		state->v2 = v2;  state->v3 = v3;
-	}
-
-	return 0;
-}
-core_initcall(prandom_init_early);
-
-
-/* Stronger reseeding when available, and periodically thereafter. */
-static void prandom_reseed(struct timer_list *unused);
-
-static DEFINE_TIMER(seed_timer, prandom_reseed);
-
-static void prandom_reseed(struct timer_list *unused)
-{
-	unsigned long expires;
-	int i;
-
-	/*
-	 * Reinitialize each CPU's PRNG with 128 bits of key.
-	 * No locking on the CPUs, but then somewhat random results are,
-	 * well, expected.
-	 */
-	for_each_possible_cpu(i) {
-		struct siprand_state *state;
-		unsigned long v0 = get_random_long(), v2 = v0 ^ PRND_K0;
-		unsigned long v1 = get_random_long(), v3 = v1 ^ PRND_K1;
-#if BITS_PER_LONG == 32
-		int j;
-
-		/*
-		 * On 32-bit machines, hash in two extra words to
-		 * approximate 128-bit key length.  Not that the hash
-		 * has that much security, but this prevents a trivial
-		 * 64-bit brute force.
-		 */
-		for (j = 0; j < 2; j++) {
-			unsigned long m = get_random_long();
-
-			v3 ^= m;
-			PRND_SIPROUND(v0, v1, v2, v3);
-			PRND_SIPROUND(v0, v1, v2, v3);
-			v0 ^= m;
-		}
-#endif
-		/*
-		 * Probably impossible in practice, but there is a
-		 * theoretical risk that a race between this reseeding
-		 * and the target CPU writing its state back could
-		 * create the all-zero SipHash fixed point.
-		 *
-		 * To ensure that never happens, ensure the state
-		 * we write contains no zero words.
-		 */
-		state = per_cpu_ptr(&net_rand_state, i);
-		WRITE_ONCE(state->v0, v0 ? v0 : -1ul);
-		WRITE_ONCE(state->v1, v1 ? v1 : -1ul);
-		WRITE_ONCE(state->v2, v2 ? v2 : -1ul);
-		WRITE_ONCE(state->v3, v3 ? v3 : -1ul);
-	}
-
-	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
-	expires = round_jiffies(jiffies + 40 * HZ + prandom_u32_max(40 * HZ));
-	mod_timer(&seed_timer, expires);
-}
-
-/*
- * The random ready callback can be called from almost any interrupt.
- * To avoid worrying about whether it's safe to delay that interrupt
- * long enough to seed all CPUs, just schedule an immediate timer event.
- */
-static int prandom_timer_start(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	mod_timer(&seed_timer, jiffies);
-	return 0;
-}
-
-#ifdef CONFIG_RANDOM32_SELFTEST
-/* Principle: True 32-bit random numbers will all have 16 differing bits on
- * average. For each 32-bit number, there are 601M numbers differing by 16
- * bits, and 89% of the numbers differ by at least 12 bits. Note that more
- * than 16 differing bits also implies a correlation with inverted bits. Thus
- * we take 1024 random numbers and compare each of them to the other ones,
- * counting the deviation of correlated bits to 16. Constants report 32,
- * counters 32-log2(TEST_SIZE), and pure randoms, around 6 or lower. With the
- * u32 total, TEST_SIZE may be as large as 4096 samples.
- */
-#define TEST_SIZE 1024
-static int __init prandom32_state_selftest(void)
-{
-	unsigned int x, y, bits, samples;
-	u32 xor, flip;
-	u32 total;
-	u32 *data;
-
-	data = kmalloc(sizeof(*data) * TEST_SIZE, GFP_KERNEL);
-	if (!data)
-		return 0;
-
-	for (samples = 0; samples < TEST_SIZE; samples++)
-		data[samples] = prandom_u32();
-
-	flip = total = 0;
-	for (x = 0; x < samples; x++) {
-		for (y = 0; y < samples; y++) {
-			if (x == y)
-				continue;
-			xor = data[x] ^ data[y];
-			flip |= xor;
-			bits = hweight32(xor);
-			total += (bits - 16) * (bits - 16);
-		}
-	}
-
-	/* We'll return the average deviation as 2*sqrt(corr/samples), which
-	 * is also sqrt(4*corr/samples) which provides a better resolution.
-	 */
-	bits = int_sqrt(total / (samples * (samples - 1)) * 4);
-	if (bits > 6)
-		pr_warn("prandom32: self test failed (at least %u bits"
-			" correlated, fixed_mask=%#x fixed_value=%#x\n",
-			bits, ~flip, data[0] & ~flip);
-	else
-		pr_info("prandom32: self test passed (less than %u bits"
-			" correlated)\n",
-			bits+1);
-	kfree(data);
-	return 0;
-}
-core_initcall(prandom32_state_selftest);
-#endif /*  CONFIG_RANDOM32_SELFTEST */
-
-/*
- * Start periodic full reseeding as soon as strong
- * random numbers are available.
- */
-static int __init prandom_init_late(void)
-{
-	static struct notifier_block random_ready = {
-		.notifier_call = prandom_timer_start
-	};
-	int ret = register_random_ready_notifier(&random_ready);
-
-	if (ret == -EALREADY) {
-		prandom_timer_start(&random_ready, 0, NULL);
-		ret = 0;
-	}
-	return ret;
-}
-late_initcall(prandom_init_late);
diff --git a/net/core/dev.c b/net/core/dev.c
index 1461c2d9dec8..19c9beb1136b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3527,7 +3527,6 @@ static int xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dev_queue_xmit_nit(skb, dev);
 
 	len = skb->len;
-	PRANDOM_ADD_NOISE(skb, dev, txq, len + jiffies);
 	trace_net_dev_start_xmit(skb, dev);
 	rc = netdev_start_xmit(skb, dev, txq, more);
 	trace_net_dev_xmit(skb, rc, dev, len);
@@ -4168,7 +4167,6 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			if (!skb)
 				goto out;
 
-			PRANDOM_ADD_NOISE(skb, dev, txq, jiffies);
 			HARD_TX_LOCK(dev, txq, cpu);
 
 			if (!netif_xmit_stopped(txq)) {
@@ -4234,7 +4232,6 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 
 	skb_set_queue_mapping(skb, queue_id);
 	txq = skb_get_tx_queue(dev, skb);
-	PRANDOM_ADD_NOISE(skb, dev, txq, jiffies);
 
 	local_bh_disable();
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 53a6b14dc50a..3d6d33ac20cc 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -536,10 +536,8 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 		return ret;
 	}
 
-	if (!(ifa->ifa_flags & IFA_F_SECONDARY)) {
-		prandom_seed((__force u32) ifa->ifa_local);
+	if (!(ifa->ifa_flags & IFA_F_SECONDARY))
 		ifap = last_primary;
-	}
 
 	rcu_assign_pointer(ifa->ifa_next, *ifap);
 	rcu_assign_pointer(*ifap, ifa);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..e7c68fa12fae 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3972,8 +3972,6 @@ static void addrconf_dad_begin(struct inet6_ifaddr *ifp)
 
 	addrconf_join_solict(dev, &ifp->addr);
 
-	prandom_seed((__force u32) ifp->addr.s6_addr32[3]);
-
 	read_lock_bh(&idev->lock);
 	spin_lock(&ifp->lock);
 	if (ifp->state == INET6_IFADDR_STATE_DEAD)
-- 
2.35.1

