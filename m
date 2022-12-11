Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB16496AA
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 23:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiLKWQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 17:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiLKWQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 17:16:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2DEDEF4
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 14:16:21 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f18so10305558wrj.5
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 14:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.huji.ac.il; s=mailhuji;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xP7SztWgBK+Di2/S95g1mehudvt/HTZxLIDMbTsStrA=;
        b=NsBv8YBArez4sULmrC65Gp4iZjpiVbOwMXtC5J0t9bXgqExRzgTid04TUvMwzKrntf
         UskktvrreL59jAExs1Mt8AA2jVEClqV07MezbQtmUghS4oHq/kYSD4OxWv2/PV39/15f
         bzqlsRtcKcynJK4QqTubWDdAu7wQlVvyHklAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xP7SztWgBK+Di2/S95g1mehudvt/HTZxLIDMbTsStrA=;
        b=Le5VWv4NeRorXjBu4VGxwqPcPftnD4ZMWG4wlu1SeXqhGxyGi6ByOp3IBXcVtJh38W
         Z/91zQbBGB02uINW5XOp9O/eVbBuXIfpjGs2cDprZH72knVa0/98Hhp1CVPqiIqTWZp8
         4JwrGSEQQlachYYITF4DHsnL90eQSW36QaFSBtYy41S9m2MJg4yykJtw0m4uxgZwDzp8
         1lfyqwV3oBgUYhUaS8uvnskKjQ2ZzvbkPbgK8XTpn0vk2Q2OI73ZzSL9KO/ibTRfHb2U
         ko/i0yvPD+98grZITbikdL7uCyjO9JAB+J7io+N3iVrlZ6mUDe9mu7EwrQTpZHbBLmVH
         fgWg==
X-Gm-Message-State: ANoB5pnRI/TJcQQnQb4WCd/B1KIHe6Qt/sAY/Z8F1U+POuKrwS7LKT+3
        D2Kq50U5hI5oLs/WIMztA3yy2Q==
X-Google-Smtp-Source: AA0mqf78YDUe2K8y4Kcbr4ZFKECLu8LJR6RszwRHTVyeY8S7AZZ7xsHqn/enF4FY+rfybmFnQlF/GQ==
X-Received: by 2002:a05:6000:1c18:b0:242:7594:c2f7 with SMTP id ba24-20020a0560001c1800b002427594c2f7mr10558116wrb.64.1670796979520;
        Sun, 11 Dec 2022 14:16:19 -0800 (PST)
Received: from MacBook-Pro-5.lan ([2a0d:6fc2:218c:1a00:a91c:f8bf:c26f:4f15])
        by smtp.gmail.com with ESMTPSA id d7-20020adffd87000000b002422bc69111sm8605805wrr.9.2022.12.11.14.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 14:16:18 -0800 (PST)
From:   david.keisarschm@mail.huji.ac.il
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     David <david.keisarschm@mail.huji.ac.il>, aksecurity@gmail.com,
        ilay.bahat1@gmail.com, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/5] Renaming weak prng invocations - prandom_bytes_state, prandom_u32_state
Date:   Mon, 12 Dec 2022 00:16:04 +0200
Message-Id: <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David <david.keisarschm@mail.huji.ac.il>

Since the two functions
 prandom_byte_state and prandom_u32_state
 use the weak prng prandom_u32,
 we added the prefix predictable_rng,
 to their signatures so it is clear they are weak.

Signed-off-by: David <david.keisarschm@mail.huji.ac.il>
---
 arch/x86/mm/kaslr.c                           |  2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  2 +-
 .../i915/gem/selftests/i915_gem_client_blt.c  |  2 +-
 .../i915/gem/selftests/i915_gem_coherency.c   |  2 +-
 .../drm/i915/gem/selftests/i915_gem_context.c |  2 +-
 drivers/gpu/drm/i915/gt/selftest_lrc.c        |  2 +-
 drivers/gpu/drm/i915/gt/selftest_migrate.c    |  2 +-
 drivers/gpu/drm/i915/gt/selftest_timeline.c   |  4 +-
 drivers/gpu/drm/i915/selftests/i915_random.c  |  4 +-
 drivers/gpu/drm/i915/selftests/i915_random.h  |  4 +-
 drivers/gpu/drm/i915/selftests/i915_syncmap.c |  4 +-
 .../drm/i915/selftests/intel_memory_region.c  | 10 ++---
 drivers/gpu/drm/i915/selftests/scatterlist.c  |  4 +-
 drivers/gpu/drm/lib/drm_random.c              |  2 +-
 drivers/mtd/tests/oobtest.c                   | 10 ++---
 drivers/mtd/tests/pagetest.c                  | 12 +++---
 drivers/mtd/tests/subpagetest.c               | 12 +++---
 drivers/scsi/fcoe/fcoe_ctlr.c                 |  2 +-
 include/linux/prandom.h                       |  6 +--
 kernel/bpf/core.c                             |  2 +-
 lib/interval_tree_test.c                      |  6 +--
 lib/random32.c                                | 42 +++++++++----------
 lib/rbtree_test.c                             |  4 +-
 lib/test_bpf.c                                |  2 +-
 lib/test_parman.c                             |  2 +-
 lib/test_scanf.c                              |  8 ++--
 mm/slab.c                                     |  2 +-
 mm/slab_common.c                              |  2 +-
 28 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 557f0fe25..66c17b449 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -123,7 +123,7 @@ void __init kernel_randomize_memory(void)
 		 * available.
 		 */
 		entropy = remain_entropy / (ARRAY_SIZE(kaslr_regions) - i);
-		prandom_bytes_state(&rand_state, &rand, sizeof(rand));
+		predictable_rng_prandom_bytes_state(&rand_state, &rand, sizeof(rand));
 		entropy = (rand % (entropy + 1)) & PUD_MASK;
 		vaddr += entropy;
 		*kaslr_regions[i].base = vaddr;
diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index c570cf780..f698d58e4 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1294,7 +1294,7 @@ static u32 igt_random_size(struct rnd_state *prng,
 	GEM_BUG_ON(min_page_size > max_page_size);
 
 	mask = ((max_page_size << 1ULL) - 1) & PAGE_MASK;
-	size = prandom_u32_state(prng) & mask;
+	size = predictable_rng_prandom_u32_state(prng) & mask;
 	if (size < min_page_size)
 		size |= min_page_size;
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_client_blt.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_client_blt.c
index 9a6a6b5b7..039f17b6b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_client_blt.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_client_blt.c
@@ -630,7 +630,7 @@ static int tiled_blits_prepare(struct tiled_blits *t,
 
 	/* Use scratch to fill objects */
 	for (i = 0; i < ARRAY_SIZE(t->buffers); i++) {
-		fill_scratch(t, map, prandom_u32_state(prng));
+		fill_scratch(t, map, predictable_rng_prandom_u32_state(prng));
 		GEM_BUG_ON(verify_buffer(t, &t->scratch, prng));
 
 		err = tiled_blit(t,
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
index a666d7e61..24cc7e6d4 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
@@ -371,7 +371,7 @@ static int igt_gem_coherency(void *arg)
 
 					i915_random_reorder(offsets, ncachelines, &prng);
 					for (n = 0; n < count; n++)
-						values[n] = prandom_u32_state(&prng);
+						values[n] = predictable_rng_prandom_u32_state(&prng);
 
 					for (n = 0; n < count; n++) {
 						err = over->set(&ctx, offsets[n], ~values[n]);
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
index c6ad67b90..6e437a1d6 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
@@ -1407,7 +1407,7 @@ static int igt_ctx_readonly(void *arg)
 					goto out_file;
 				}
 
-				if (prandom_u32_state(&prng) & 1)
+				if (predictable_rng_prandom_u32_state(&prng) & 1)
 					i915_gem_object_set_readonly(obj);
 			}
 
diff --git a/drivers/gpu/drm/i915/gt/selftest_lrc.c b/drivers/gpu/drm/i915/gt/selftest_lrc.c
index 82d3f8058..e2fe4fe8f 100644
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -1760,7 +1760,7 @@ static struct i915_request *garbage(struct intel_context *ce,
 	if (err)
 		return ERR_PTR(err);
 
-	prandom_bytes_state(prng,
+	predictable_rng_prandom_bytes_state(prng,
 			    ce->lrc_reg_state,
 			    ce->engine->context_size -
 			    LRC_STATE_OFFSET);
diff --git a/drivers/gpu/drm/i915/gt/selftest_migrate.c b/drivers/gpu/drm/i915/gt/selftest_migrate.c
index 2b0c87999..9b6e8cf52 100644
--- a/drivers/gpu/drm/i915/gt/selftest_migrate.c
+++ b/drivers/gpu/drm/i915/gt/selftest_migrate.c
@@ -551,7 +551,7 @@ static int threaded_migrate(struct intel_migrate *migrate,
 
 		thread[i].migrate = migrate;
 		thread[i].prng =
-			I915_RND_STATE_INITIALIZER(prandom_u32_state(&prng));
+			I915_RND_STATE_INITIALIZER(predictable_rng_prandom_u32_state(&prng));
 
 		tsk = kthread_run(fn, &thread[i], "igt-%d", i);
 		if (IS_ERR(tsk)) {
diff --git a/drivers/gpu/drm/i915/gt/selftest_timeline.c b/drivers/gpu/drm/i915/gt/selftest_timeline.c
index 522d01905..5c8b662c6 100644
--- a/drivers/gpu/drm/i915/gt/selftest_timeline.c
+++ b/drivers/gpu/drm/i915/gt/selftest_timeline.c
@@ -308,7 +308,7 @@ static int bench_sync(void *arg)
 		u32 x;
 
 		/* Make sure the compiler doesn't optimise away the prng call */
-		WRITE_ONCE(x, prandom_u32_state(&prng));
+		WRITE_ONCE(x, predictable_rng_prandom_u32_state(&prng));
 
 		count++;
 	} while (!time_after(jiffies, end_time));
@@ -393,7 +393,7 @@ static int bench_sync(void *arg)
 	end_time = jiffies + HZ/10;
 	do {
 		u32 id = random_engine(&prng);
-		u32 seqno = prandom_u32_state(&prng);
+		u32 seqno = predictable_rng_prandom_u32_state(&prng);
 
 		if (!__intel_timeline_sync_is_later(&tl, id, seqno))
 			__intel_timeline_sync_set(&tl, id, seqno);
diff --git a/drivers/gpu/drm/i915/selftests/i915_random.c b/drivers/gpu/drm/i915/selftests/i915_random.c
index abdfadcf6..e6b56688e 100644
--- a/drivers/gpu/drm/i915/selftests/i915_random.c
+++ b/drivers/gpu/drm/i915/selftests/i915_random.c
@@ -35,9 +35,9 @@ u64 i915_prandom_u64_state(struct rnd_state *rnd)
 {
 	u64 x;
 
-	x = prandom_u32_state(rnd);
+	x = predictable_rng_prandom_u32_state(rnd);
 	x <<= 32;
-	x |= prandom_u32_state(rnd);
+	x |= predictable_rng_prandom_u32_state(rnd);
 
 	return x;
 }
diff --git a/drivers/gpu/drm/i915/selftests/i915_random.h b/drivers/gpu/drm/i915/selftests/i915_random.h
index 05364eca2..7290a2eaf 100644
--- a/drivers/gpu/drm/i915/selftests/i915_random.h
+++ b/drivers/gpu/drm/i915/selftests/i915_random.h
@@ -40,13 +40,13 @@
 	struct rnd_state name__ = I915_RND_STATE_INITIALIZER(i915_selftest.random_seed)
 
 #define I915_RND_SUBSTATE(name__, parent__) \
-	struct rnd_state name__ = I915_RND_STATE_INITIALIZER(prandom_u32_state(&(parent__)))
+	struct rnd_state name__ = I915_RND_STATE_INITIALIZER(predictable_rng_prandom_u32_state(&(parent__)))
 
 u64 i915_prandom_u64_state(struct rnd_state *rnd);
 
 static inline u32 i915_prandom_u32_max_state(u32 ep_ro, struct rnd_state *state)
 {
-	return upper_32_bits(mul_u32_u32(prandom_u32_state(state), ep_ro));
+	return upper_32_bits(mul_u32_u32(predictable_rng_prandom_u32_state(state), ep_ro));
 }
 
 unsigned int *i915_random_order(unsigned int count,
diff --git a/drivers/gpu/drm/i915/selftests/i915_syncmap.c b/drivers/gpu/drm/i915/selftests/i915_syncmap.c
index 47f4ae18a..c02e55133 100644
--- a/drivers/gpu/drm/i915/selftests/i915_syncmap.c
+++ b/drivers/gpu/drm/i915/selftests/i915_syncmap.c
@@ -223,7 +223,7 @@ static int igt_syncmap_one(void *arg)
 
 		for (loop = 0; loop <= max; loop++) {
 			err = check_one(&sync, context,
-					prandom_u32_state(&prng));
+					predictable_rng_prandom_u32_state(&prng));
 			if (err)
 				goto out;
 		}
@@ -575,7 +575,7 @@ static int igt_syncmap_random(void *arg)
 		u32 last_seqno = seqno;
 		bool expect;
 
-		seqno = prandom_u32_state(&prng);
+		seqno = predictable_rng_prandom_u32_state(&prng);
 		expect = seqno_later(last_seqno, seqno);
 
 		for (i = 0; i < count; i++) {
diff --git a/drivers/gpu/drm/i915/selftests/intel_memory_region.c b/drivers/gpu/drm/i915/selftests/intel_memory_region.c
index 3b18e5905..2c65795e8 100644
--- a/drivers/gpu/drm/i915/selftests/intel_memory_region.c
+++ b/drivers/gpu/drm/i915/selftests/intel_memory_region.c
@@ -758,7 +758,7 @@ static int igt_gpu_write(struct i915_gem_context *ctx,
 	i = 0;
 	engines = i915_gem_context_lock_engines(ctx);
 	do {
-		u32 rng = prandom_u32_state(&prng);
+		u32 rng = predictable_rng_prandom_u32_state(&prng);
 		u32 dword = offset_in_page(rng) / 4;
 
 		ce = engines->engines[order[i] % engines->num_engines];
@@ -929,7 +929,7 @@ static int igt_lmem_create_cleared_cpu(void *arg)
 			goto out_unpin;
 		}
 
-		val = prandom_u32_state(&prng);
+		val = predictable_rng_prandom_u32_state(&prng);
 
 		memset32(vaddr, val, obj->base.size / sizeof(u32));
 
@@ -972,7 +972,7 @@ static int igt_lmem_write_gpu(void *arg)
 		goto out_file;
 	}
 
-	sz = round_up(prandom_u32_state(&prng) % SZ_32M, PAGE_SIZE);
+	sz = round_up(predictable_rng_prandom_u32_state(&prng) % SZ_32M, PAGE_SIZE);
 
 	obj = i915_gem_object_create_lmem(i915, sz, 0);
 	if (IS_ERR(obj)) {
@@ -1046,7 +1046,7 @@ static int igt_lmem_write_cpu(void *arg)
 
 	pr_info("%s: using %s\n", __func__, engine->name);
 
-	sz = round_up(prandom_u32_state(&prng) % SZ_32M, PAGE_SIZE);
+	sz = round_up(predictable_rng_prandom_u32_state(&prng) % SZ_32M, PAGE_SIZE);
 	sz = max_t(u32, 2 * PAGE_SIZE, sz);
 
 	obj = i915_gem_object_create_lmem(i915, sz, I915_BO_ALLOC_CONTIGUOUS);
@@ -1115,7 +1115,7 @@ static int igt_lmem_write_cpu(void *arg)
 		offset = igt_random_offset(&prng, 0, obj->base.size,
 					   size, align);
 
-		val = prandom_u32_state(&prng);
+		val = predictable_rng_prandom_u32_state(&prng);
 		memset32(vaddr + offset / sizeof(u32), val ^ 0xdeadbeaf,
 			 size / sizeof(u32));
 
diff --git a/drivers/gpu/drm/i915/selftests/scatterlist.c b/drivers/gpu/drm/i915/selftests/scatterlist.c
index d599186d5..ff86bf468 100644
--- a/drivers/gpu/drm/i915/selftests/scatterlist.c
+++ b/drivers/gpu/drm/i915/selftests/scatterlist.c
@@ -187,7 +187,7 @@ static unsigned int random(unsigned long n,
 			   unsigned long count,
 			   struct rnd_state *rnd)
 {
-	return 1 + (prandom_u32_state(rnd) % 1024);
+	return 1 + (predictable_rng_prandom_u32_state(rnd) % 1024);
 }
 
 static unsigned int random_page_size_pages(unsigned long n,
@@ -201,7 +201,7 @@ static unsigned int random_page_size_pages(unsigned long n,
 		BIT(21) >> PAGE_SHIFT,
 	};
 
-	return page_count[(prandom_u32_state(rnd) % 3)];
+	return page_count[(predictable_rng_prandom_u32_state(rnd) % 3)];
 }
 
 static inline bool page_contiguous(struct page *first,
diff --git a/drivers/gpu/drm/lib/drm_random.c b/drivers/gpu/drm/lib/drm_random.c
index 31b5a3e21..512455039 100644
--- a/drivers/gpu/drm/lib/drm_random.c
+++ b/drivers/gpu/drm/lib/drm_random.c
@@ -9,7 +9,7 @@
 
 u32 drm_prandom_u32_max_state(u32 ep_ro, struct rnd_state *state)
 {
-	return upper_32_bits((u64)prandom_u32_state(state) * ep_ro);
+	return upper_32_bits((u64)predictable_rng_prandom_u32_state(state) * ep_ro);
 }
 EXPORT_SYMBOL(drm_prandom_u32_max_state);
 
diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 13fed3989..fc248fbdb 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -60,7 +60,7 @@ static int write_eraseblock(int ebnum)
 	int err = 0;
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 
-	prandom_bytes_state(&rnd_state, writebuf, use_len_max * pgcnt);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, use_len_max * pgcnt);
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
@@ -170,7 +170,7 @@ static int verify_eraseblock(int ebnum)
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 	size_t bitflips;
 
-	prandom_bytes_state(&rnd_state, writebuf, use_len_max * pgcnt);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, use_len_max * pgcnt);
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
@@ -268,7 +268,7 @@ static int verify_eraseblock_in_one_go(int ebnum)
 	size_t bitflips;
 	int i;
 
-	prandom_bytes_state(&rnd_state, writebuf, len);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, len);
 	ops.mode      = MTD_OPS_AUTO_OOB;
 	ops.len       = 0;
 	ops.retlen    = 0;
@@ -642,7 +642,7 @@ static int __init mtd_oobtest_init(void)
 		if (bbt[i] || bbt[i + 1])
 			continue;
 		addr = (loff_t)(i + 1) * mtd->erasesize - mtd->writesize;
-		prandom_bytes_state(&rnd_state, writebuf, sz * cnt);
+		predictable_rng_prandom_bytes_state(&rnd_state, writebuf, sz * cnt);
 		for (pg = 0; pg < cnt; ++pg) {
 			ops.mode      = MTD_OPS_AUTO_OOB;
 			ops.len       = 0;
@@ -673,7 +673,7 @@ static int __init mtd_oobtest_init(void)
 	for (i = 0; i < ebcnt - 1; ++i) {
 		if (bbt[i] || bbt[i + 1])
 			continue;
-		prandom_bytes_state(&rnd_state, writebuf, mtd->oobavail * 2);
+		predictable_rng_prandom_bytes_state(&rnd_state, writebuf, mtd->oobavail * 2);
 		addr = (loff_t)(i + 1) * mtd->erasesize - mtd->writesize;
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
diff --git a/drivers/mtd/tests/pagetest.c b/drivers/mtd/tests/pagetest.c
index 8eb40b6e6..088146869 100644
--- a/drivers/mtd/tests/pagetest.c
+++ b/drivers/mtd/tests/pagetest.c
@@ -42,7 +42,7 @@ static int write_eraseblock(int ebnum)
 {
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 
-	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	cond_resched();
 	return mtdtest_write(mtd, addr, mtd->erasesize, writebuf);
 }
@@ -62,7 +62,7 @@ static int verify_eraseblock(int ebnum)
 	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
-	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	for (j = 0; j < pgcnt - 1; ++j, addr += pgsize) {
 		/* Do a read to set the internal dataRAMs to different data */
 		err = mtdtest_read(mtd, addr0, bufsize, twopages);
@@ -97,7 +97,7 @@ static int verify_eraseblock(int ebnum)
 		if (err)
 			return err;
 		memcpy(boundary, writebuf + mtd->erasesize - pgsize, pgsize);
-		prandom_bytes_state(&rnd_state, boundary + pgsize, pgsize);
+		predictable_rng_prandom_bytes_state(&rnd_state, boundary + pgsize, pgsize);
 		if (memcmp(twopages, boundary, bufsize)) {
 			pr_err("error: verify failed at %#llx\n",
 			       (long long)addr);
@@ -210,7 +210,7 @@ static int erasecrosstest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	prandom_bytes_state(&rnd_state, writebuf, pgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtdtest_write(mtd, addr0, pgsize, writebuf);
 	if (err)
@@ -235,7 +235,7 @@ static int erasecrosstest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	prandom_bytes_state(&rnd_state, writebuf, pgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtdtest_write(mtd, addr0, pgsize, writebuf);
 	if (err)
@@ -284,7 +284,7 @@ static int erasetest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	prandom_bytes_state(&rnd_state, writebuf, pgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	err = mtdtest_write(mtd, addr0, pgsize, writebuf);
 	if (err)
 		return err;
diff --git a/drivers/mtd/tests/subpagetest.c b/drivers/mtd/tests/subpagetest.c
index 05250a080..3d312a51f 100644
--- a/drivers/mtd/tests/subpagetest.c
+++ b/drivers/mtd/tests/subpagetest.c
@@ -46,7 +46,7 @@ static int write_eraseblock(int ebnum)
 	int err = 0;
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 
-	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	err = mtd_write(mtd, addr, subpgsize, &written, writebuf);
 	if (unlikely(err || written != subpgsize)) {
 		pr_err("error: write failed at %#llx\n",
@@ -60,7 +60,7 @@ static int write_eraseblock(int ebnum)
 
 	addr += subpgsize;
 
-	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	err = mtd_write(mtd, addr, subpgsize, &written, writebuf);
 	if (unlikely(err || written != subpgsize)) {
 		pr_err("error: write failed at %#llx\n",
@@ -84,7 +84,7 @@ static int write_eraseblock2(int ebnum)
 	for (k = 1; k < 33; ++k) {
 		if (addr + (subpgsize * k) > (loff_t)(ebnum + 1) * mtd->erasesize)
 			break;
-		prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
+		predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
 		err = mtd_write(mtd, addr, subpgsize * k, &written, writebuf);
 		if (unlikely(err || written != subpgsize * k)) {
 			pr_err("error: write failed at %#llx\n",
@@ -120,7 +120,7 @@ static int verify_eraseblock(int ebnum)
 	int err = 0;
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 
-	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	clear_data(readbuf, subpgsize);
 	err = mtd_read(mtd, addr, subpgsize, &read, readbuf);
 	if (unlikely(err || read != subpgsize)) {
@@ -147,7 +147,7 @@ static int verify_eraseblock(int ebnum)
 
 	addr += subpgsize;
 
-	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
+	predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	clear_data(readbuf, subpgsize);
 	err = mtd_read(mtd, addr, subpgsize, &read, readbuf);
 	if (unlikely(err || read != subpgsize)) {
@@ -184,7 +184,7 @@ static int verify_eraseblock2(int ebnum)
 	for (k = 1; k < 33; ++k) {
 		if (addr + (subpgsize * k) > (loff_t)(ebnum + 1) * mtd->erasesize)
 			break;
-		prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
+		predictable_rng_prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
 		clear_data(readbuf, subpgsize * k);
 		err = mtd_read(mtd, addr, subpgsize * k, &read, readbuf);
 		if (unlikely(err || read != subpgsize * k)) {
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index ddc048069..e1a0e2c27 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2224,7 +2224,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 	 */
 	port_id = fip->port_id;
 	if (fip->probe_tries)
-		port_id = prandom_u32_state(&fip->rnd_state) & 0xffff;
+		port_id = predictable_rng_prandom_u32_state(&fip->rnd_state) & 0xffff;
 	else if (!port_id)
 		port_id = fip->lp->wwpn & 0xffff;
 	if (!port_id || port_id == 0xffff)
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index e0a0759dd..d525ab02e 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -16,8 +16,8 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
-u32 prandom_u32_state(struct rnd_state *state);
-void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
+u32 predictable_rng_prandom_u32_state(struct rnd_state *state);
+void predictable_rng_prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
 
 #define prandom_init_once(pcpu_state)			\
@@ -52,7 +52,7 @@ static inline u32 __seed(u32 x, u32 m)
 }
 
 /**
- * prandom_seed_state - set seed for prandom_u32_state().
+ * prandom_seed_state - set seed for predictable_rng_prandom_u32_state().
  * @state: pointer to state structure to receive the seed.
  * @seed: arbitrary 64-bit value to use as a seed.
  */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 25a54e045..4cb5421d9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2599,7 +2599,7 @@ BPF_CALL_0(bpf_user_rnd_u32)
 	u32 res;
 
 	state = &get_cpu_var(bpf_user_rnd_state);
-	res = prandom_u32_state(state);
+	res = predictable_rng_prandom_u32_state(state);
 	put_cpu_var(bpf_user_rnd_state);
 
 	return res;
diff --git a/lib/interval_tree_test.c b/lib/interval_tree_test.c
index f37f4d44f..1a1a89a39 100644
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -43,8 +43,8 @@ static void init(void)
 	int i;
 
 	for (i = 0; i < nnodes; i++) {
-		u32 b = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
-		u32 a = (prandom_u32_state(&rnd) >> 4) % b;
+		u32 b = (predictable_rng_prandom_u32_state(&rnd) >> 4) % max_endpoint;
+		u32 a = (predictable_rng_prandom_u32_state(&rnd) >> 4) % b;
 
 		nodes[i].start = a;
 		nodes[i].last = b;
@@ -56,7 +56,7 @@ static void init(void)
 	 * which is pointless.
 	 */
 	for (i = 0; i < nsearches; i++)
-		queries[i] = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
+		queries[i] = (predictable_rng_prandom_u32_state(&rnd) >> 4) % max_endpoint;
 }
 
 static int interval_tree_test_init(void)
diff --git a/lib/random32.c b/lib/random32.c
index 32060b852..3b34ea934 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -43,13 +43,13 @@
 #include <asm/unaligned.h>
 
 /**
- *	prandom_u32_state - seeded pseudo-random number generator.
+ *	predictable_rng_prandom_u32_state - seeded pseudo-random number generator.
  *	@state: pointer to state structure holding seeded state.
  *
  *	This is used for pseudo-randomness with no outside seeding.
  *	For more random results, use get_random_u32().
  */
-u32 prandom_u32_state(struct rnd_state *state)
+u32 predictable_rng_prandom_u32_state(struct rnd_state *state)
 {
 #define TAUSWORTHE(s, a, b, c, d) ((s & c) << d) ^ (((s << a) ^ s) >> b)
 	state->s1 = TAUSWORTHE(state->s1,  6U, 13U, 4294967294U, 18U);
@@ -59,10 +59,10 @@ u32 prandom_u32_state(struct rnd_state *state)
 
 	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4);
 }
-EXPORT_SYMBOL(prandom_u32_state);
+EXPORT_SYMBOL(predictable_rng_prandom_u32_state);
 
 /**
- *	prandom_bytes_state - get the requested number of pseudo-random bytes
+ *	predictable_rng_prandom_bytes_state - get the requested number of pseudo-random bytes
  *
  *	@state: pointer to state structure holding seeded state.
  *	@buf: where to copy the pseudo-random bytes to
@@ -71,18 +71,18 @@ EXPORT_SYMBOL(prandom_u32_state);
  *	This is used for pseudo-randomness with no outside seeding.
  *	For more random results, use get_random_bytes().
  */
-void prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
+void predictable_rng_prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
 {
 	u8 *ptr = buf;
 
 	while (bytes >= sizeof(u32)) {
-		put_unaligned(prandom_u32_state(state), (u32 *) ptr);
+		put_unaligned(predictable_rng_prandom_u32_state(state), (u32 *) ptr);
 		ptr += sizeof(u32);
 		bytes -= sizeof(u32);
 	}
 
 	if (bytes > 0) {
-		u32 rem = prandom_u32_state(state);
+		u32 rem = predictable_rng_prandom_u32_state(state);
 		do {
 			*ptr++ = (u8) rem;
 			bytes--;
@@ -90,21 +90,21 @@ void prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
 		} while (bytes > 0);
 	}
 }
-EXPORT_SYMBOL(prandom_bytes_state);
+EXPORT_SYMBOL(predictable_rng_prandom_bytes_state);
 
 static void prandom_warmup(struct rnd_state *state)
 {
 	/* Calling RNG ten times to satisfy recurrence condition */
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
+	predictable_rng_prandom_u32_state(state);
 }
 
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state)
@@ -265,7 +265,7 @@ static int __init prandom_state_selftest(void)
 		prandom_state_selftest_seed(&state, test1[i].seed);
 		prandom_warmup(&state);
 
-		if (test1[i].result != prandom_u32_state(&state))
+		if (test1[i].result != predictable_rng_prandom_u32_state(&state))
 			error = true;
 	}
 
@@ -281,9 +281,9 @@ static int __init prandom_state_selftest(void)
 		prandom_warmup(&state);
 
 		for (j = 0; j < test2[i].iteration - 1; j++)
-			prandom_u32_state(&state);
+			predictable_rng_prandom_u32_state(&state);
 
-		if (test2[i].result != prandom_u32_state(&state))
+		if (test2[i].result != predictable_rng_prandom_u32_state(&state))
 			errors++;
 
 		runs++;
diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 41ae3c757..62dd773c8 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -150,8 +150,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < nnodes; i++) {
-		nodes[i].key = prandom_u32_state(&rnd);
-		nodes[i].val = prandom_u32_state(&rnd);
+		nodes[i].key = predictable_rng_prandom_u32_state(&rnd);
+		nodes[i].val = predictable_rng_prandom_u32_state(&rnd);
 	}
 }
 
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 582070416..b17e751cc 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -140,7 +140,7 @@ static int bpf_fill_maxinsns3(struct bpf_test *self)
 	prandom_seed_state(&rnd, 3141592653589793238ULL);
 
 	for (i = 0; i < len - 1; i++) {
-		__u32 k = prandom_u32_state(&rnd);
+		__u32 k = predictable_rng_prandom_u32_state(&rnd);
 
 		insn[i] = __BPF_STMT(BPF_ALU | BPF_ADD | BPF_K, k);
 	}
diff --git a/lib/test_parman.c b/lib/test_parman.c
index 35e322436..f89b8192c 100644
--- a/lib/test_parman.c
+++ b/lib/test_parman.c
@@ -136,7 +136,7 @@ static void test_parman_rnd_init(struct test_parman *test_parman)
 
 static u32 test_parman_rnd_get(struct test_parman *test_parman)
 {
-	return prandom_u32_state(&test_parman->rnd);
+	return predictable_rng_prandom_u32_state(&test_parman->rnd);
 }
 
 static unsigned long test_parman_priority_gen(struct test_parman *test_parman)
diff --git a/lib/test_scanf.c b/lib/test_scanf.c
index b620cf7de..a2de3dee2 100644
--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -269,16 +269,16 @@ static void __init numbers_simple(void)
  */
 static u32 __init next_test_random(u32 max_bits)
 {
-	u32 n_bits = hweight32(prandom_u32_state(&rnd_state)) % (max_bits + 1);
+	u32 n_bits = hweight32(predictable_rng_prandom_u32_state(&rnd_state)) % (max_bits + 1);
 
-	return prandom_u32_state(&rnd_state) & GENMASK(n_bits, 0);
+	return predictable_rng_prandom_u32_state(&rnd_state) & GENMASK(n_bits, 0);
 }
 
 static unsigned long long __init next_test_random_ull(void)
 {
-	u32 rand1 = prandom_u32_state(&rnd_state);
+	u32 rand1 = predictable_rng_prandom_u32_state(&rnd_state);
 	u32 n_bits = (hweight32(rand1) * 3) % 64;
-	u64 val = (u64)prandom_u32_state(&rnd_state) * rand1;
+	u64 val = (u64)predictable_rng_prandom_u32_state(&rnd_state) * rand1;
 
 	return val & GENMASK_ULL(n_bits, 0);
 }
diff --git a/mm/slab.c b/mm/slab.c
index 59c8e28f7..ff71c5757 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2447,7 +2447,7 @@ static bool shuffle_freelist(struct kmem_cache *cachep, struct slab *slab)
 
 		/* Fisher-Yates shuffle */
 		for (i = count - 1; i > 0; i--) {
-			rand = prandom_u32_state(&state.rnd_state);
+			rand = predictable_rng_prandom_u32_state(&state.rnd_state);
 			rand %= (i + 1);
 			swap_free_obj(slab, i, rand);
 		}
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 0042fb273..deb764785 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1141,7 +1141,7 @@ static void freelist_randomize(struct rnd_state *state, unsigned int *list,
 
 	/* Fisher-Yates shuffle */
 	for (i = count - 1; i > 0; i--) {
-		rand = prandom_u32_state(state);
+		rand = predictable_rng_prandom_u32_state(state);
 		rand %= (i + 1);
 		swap(list[i], list[rand]);
 	}
-- 
2.38.0

