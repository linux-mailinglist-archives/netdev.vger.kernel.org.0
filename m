Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FBE23F811
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHHPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 11:34:58 -0400
Received: from mx.sdf.org ([205.166.94.24]:54926 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgHHPe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 11:34:58 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Aug 2020 11:34:57 EDT
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078FQUSS014819
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 15:26:30 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078FQTQX013694;
        Sat, 8 Aug 2020 15:26:29 GMT
Date:   Sat, 8 Aug 2020 15:26:28 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     netdev@vger.kernel.org
Cc:     w@1wt.eu, aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org,
        George Spelvin <lkml@SDF.ORG>
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808152628.GA27941@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=letter
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm quite annoyed at the way that this discussion has drifted away from
the main problem, which is that f227e3ec3b5c is broken and needs reverted.

The original bug report is accurate, and it's a critical issue.
My proposed fix is described (patch imminent) below.


THE PROBLEM:

The reseeding design in add_interrupt_randomness is fatally flawed.
Quite simply, drip-feeding entropy into a PRNG is pissing the entropy
straight down the drain.  It's a complete waste of time *and* it fatally
damages /dev/random.

This is an information-theoretic flaw which cannot be patched
by any amount of clever crypto.

People don't seem to be grasping this fundamental concept.  Ted,
I'm particularly disappointed in you; you *know* better.

First, why reseed at all?  We do it to reduce an attacker's ability
to predict the PRNG output, which in practice means to reduce their
knowledge of the PRNG's internal state.

So any discussion of reseeding begins by *assuming* an attacker has
captured the PRNG state.  If we weren't worried about this possibility,
we wouldn't need to reseed in the first place!

[Footnote: most crypto PRNGs also want rekeying before their cycle
length limit is reached, but these limits are more than 2^64 bits
nowadays and thus infinite in practice.]

If we add k bits of seed entropy to the (attacker-known!) state and let an
attacker see >= k bits of output, there is a trivial brute-force attack
on *any* deterministic PRNG algorithm: try all 2^k possible inputs and
choose the one that matches the observed output.

[Footnote: in real life, you don't have 2^k equally likely possibilities,
so you end up trying possibilities in decreasing order of likelihood,
giving the same average time to solve, but with a longer tail.
The implementation details are messier, but well known; RTFM of any
password-guessing software for details.]

If k is small, this is trivially easy.  Reseeding many times (large n)
doesn't help if you allow an attacker to observe PRNG output after each
small reseeding; the effort is n * 2^k.

The way to prevent this from becoming a problem is well-known: ensure
that k is large.  Save up the n seeds and reseed once, making the
brute-force effort 2^(n*k).  This is called "catastrophic reseeding"
and is described in more detail at e.g.
https://www.schneier.com/academic/paperfiles/paper-prngs.pdf

But the amount of entropy is any one interrupt timing sample is small.
/dev/random assumes it lies somewhere between 1/64 and 2 bits.  If
our attacker is less skilled, they may have more subjective uncertainty,
but guessing a TSC delta to within 20 bits (0.26 ms at 4 GHz) doesn't
seem at all difficult.  Testing 2^20 possibilities is trivial.

*This* is why Willy's patch is useless.  No amount of deckchair
rearrangement or bikeshed painting will fix this core structural flaw.
It *must* be redesigned to do catastrophic reseeding.


Additionally, the entropy revealed by this attack is *also* the primary
source for /dev/random, destroying its security guarantee.  This elevates
the problem from "useless" to "disastrous".  This patch *must* be reverted
for 5.8.1.


In response to various messages saying "this is all theoretical; I won't
believe you until I see a PoC", all I can say is "I feel that you should
be aware that some asshole is signing your name to stupid letters."

Just like a buffer overflow, a working attack is plausible using a
combination of well-understood techniques.  It's ridiculous to go to
the effort of developing a full exploit when it's less work to fix the
problem in the first place.

I also notice a lot of amateurish handwaving about the security of
various primitives.  This is particularly frustrating, but I will refrain
from giving vent/rant to my feelings, instead referring people to the
various references linked from

https://security.stackexchange.com/questions/18197/why-shouldnt-we-roll-our-own


A SOLUTION:

Now, how to fix it?

First, what is the problem?  "Non-cryptographic PRNGs are predictable"
fits in the cateogry of Not A Bug.  There are may applications for
a non-cryptographic PRNG in the kernel.  Self-tests, spreading wear
across flash memory, randomized backoff among cooperating processes,
and assigning IDs in protocols which aren't designed for DoS resistance
in the first place.

But apparently the network code is (ab)using lib/random32.c for choosing
TCP/UDP port numbers and someone has found a (not publicly disclosed)
attack which exploits the predictability to commit some mischief.

And apparently switching to the fastest secure PRNG currently
in the kernel (get_random_u32() using ChaCha + per-CPU buffers)
would cause too much performance penalty.

So the request is for a less predictable PRNG which is still extremely
fast.  It's specifically okay if the crypto is half-assed; this is
apparently some kind of nuisance (DoS?) attack rather than something
really valuable.

Gee, I seem to recall solving a very similar problem with the
dache hash function.  I think I can do this.

An important design constraint is that we want low-latency random number
generation, not just high bandwidth.  Amortizing over bulk operations
is *not* okay.


Well, the best crypto primitive I know of for such an application is
SipHash.  Its 4x 64-bit words of state is only twice the size of the
current struct rnd_state.  Converting it from a a pseudo-random function
to a CRNG is some half-assed amateur cryptography, but at least it's a
robust and well-studied primitive.

So here's my proposal, for comment:  (I'll post an RFC patch shortly.)
- Replace the prandom_u32() generator with something that does
  2 rounds of SipHash.  (Could drop to 1 round if we get complaints.)
- Keep the per-CPU structure, to minimize cacheline bouncing.
- On 32-bit processors, use HSipHash to keep performance up.  In the
  spirit of half-assedness, this is weaker, but hopefully good enough,
  and while there are lots of such processors in routers and IoT devices,
  they aren't handling thousands of connections per second and so expose
  much less PRNG output.
- Using random_ready_callback and periodically thereafter, do a full
  catastrophic reseed from the ChaCha generator.  There's no need for
  locking; tearing on updates doesn't do any harm.

Current plans I'm open to discussion about:
- Replace the current prandom_u32(), rather than adding yet another
  PRNG.  This keeps the patch smaller.
- Leave the 60-second reseed interval alone.  If someone can suggest a
  way to suppress reseeding when not needed, we could drop the interval
  without penalizing mobile devices.
- Leave the prandom_u32_state() code paths alone.  Those functions are
  used in self-test code and it's probably worth not changing the output.
  (The downside is misleading function names.)
- For robustness, seed each CPU's PRNG state independently.  We could
  use a global key and use SipHash itself to hash in the CPU number which
  would be faster than ChaCha, but let's KISS.


INDIVIDUAL REPLIES:

Jason A. Donenfeld: You're quite right about the accretion of
	superstitious incantations in random.c, but I do think it's a
	fundamentally sound design, just with an inelegant implementation.
	A comparison to SHACAL1 is not appropriate.  SHACAL is invertible
	because it leaves off the final Davies-Meyer add-back,	random.c
	uses SHA1 *with* the add-back, so the compression function
	is not invertible.  The most maliciously backdoored rdrand
	implementation imaginable can't analyze the entropy pool and
	choose its output so as to leak data to the Bavarian Illuminati.
	That's laughably impractical.

Willy Tarreau: Middle square + Weil sequence isn't even *close* to
	crypto-quality.  And you're badly misunderstanding what the
	fast_pool is doing.  Please stop trying to invent your own crypto
	primitives; see
	https://www.schneier.com/crypto-gram/archives/1998/1015.html#cipherdesign

Ted Ts'o: Actually, I'm (slowly) working through a complete audit of all
	RNG users in the kernel.  Current code offers four basic
	levels of security:
	- Trivial LCG (next_pseudo_random32, preserved for compatibility)
	- Trivially predictable (but statistically good) LFSR
	- Cryptographically strong ChaCha, batched
	- Cryptographically strong ChaCha, with anti-backtracking.
	(Because I'm working strong-to-weak, I've mostly downgraded
	call sites so far.  There's also the earlyrandom stuff, which
	is its own mess.)

	Do we want an additional "hopefully strong" level in the middle
	for TCP ports and other visible IDs only, or should we replace
	the LFSR and not have a conventional PRNG at all?

Andy Lutomirski: I also have some code for combining the 32- and 64-bit
	entropy batches, and I've generalized it to return bytes as well,
	because *most* users of get_random_bytes() in the kernel don't
	need anti-backtracking, but my understanding from Linus is that
	for this application, amortized time is *not* okay; we want a
	fast 99th percentile.


PERSONAL NOTE:

Events this year have left me without the bandwidth to keep up with kernel
development and so I've been AFK for some months.  My problems haven't
gone away, but this issue is important enough that I'll be making time
to see it through to resolution.
