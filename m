Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB90236EB8D
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbhD2Nr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 09:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbhD2Nr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 09:47:58 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0EAC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d11so9177512wrw.8
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuRhzqKQieIT1ODprczAwmVtjBChKg2B72Ii/9rZYuo=;
        b=mb+38Lrf9QSlQEtF3RsuAnTvMklUYvlX2ZWo6zRuvrBMrWA5JruXFCP7ADqZ5lJUKg
         2FBfDBVuILT0dRe155ErPHPZ5CQJR+0owuML2B0IB8vJX6iLri9bbb5bxacVPHJaF10c
         n+pyPLMvj5PQtTa/ywEI48+nh/q5Bq3y+FMR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuRhzqKQieIT1ODprczAwmVtjBChKg2B72Ii/9rZYuo=;
        b=Lt8oJ/JUjRYJrky8/UZs/gkotc8c8dssVc3d4YT/XRLlmHQgdOhlsh1cGfmGMUns9T
         L2LFprx/j+j1WLWarMQklIIWBKWgqrPiwRTKQlo9eN/u20OGXncoEfLR8D9AIJIzvnpy
         Go0Cf3QLDFreODzie7Mm/TzXqs4YV27J3ASMn88ydrJdsJbIz15aEtdo72j+yd3PJp2R
         SDcHaiIQ4tXzpKs0vltdBn/TV+7a8CU3x98EZH/Kkm0eqsoHb08gq0Z8Qa4sjPV2rBNY
         SSNA+8q+FgF9jt3kB5fEv2rRBYkUbeGg2oOINo1L5miTGLsPcJp95Sp0H7oEWEfhRwpI
         8OLQ==
X-Gm-Message-State: AOAM53255Chb1l7xVkm/SaGbhb0Y4xhJefwtQjy0Hd5GfIiDwpBhgyqx
        NKqd2EoXgAvle+itz8d3zmLxMA==
X-Google-Smtp-Source: ABdhPJyYOwOAOQa4RTbnNWTD2m1DK4J8zLfa5DXnAbONdWGd5OI5jv+LWuI3uVJvoTg2H53uQ2jNfw==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr29094253wrv.239.1619704029983;
        Thu, 29 Apr 2021 06:47:09 -0700 (PDT)
Received: from localhost.localdomain (8.7.1.e.3.2.9.3.e.a.2.1.c.2.e.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4e2c:12ae:3923:e178])
        by smtp.gmail.com with ESMTPSA id x8sm5105592wru.70.2021.04.29.06.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 06:47:09 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/3] bpf: verifier: improve function state reallocation
Date:   Thu, 29 Apr 2021 14:46:54 +0100
Message-Id: <20210429134656.122225-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210429134656.122225-1-lmb@cloudflare.com>
References: <20210429134656.122225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resizing and copying stack and reference tracking state currently
does a lot of kfree / kmalloc when the size of the tracked set changes.
The logic in copy_*_state and realloc_*_state is also hard to follow.

Refactor this into two core functions. copy_array copies from a source
into a destination. It avoids reallocation by taking the allocated
size of the destination into account via ksize(). The function is
essentially krealloc_array, with the difference that the contents of
dst are not preserved. realloc_array changes the size of an array and
zeroes newly allocated items. Contrary to krealloc both functions don't
free the destination if the size is zero. Instead we rely on free_func_state
to clean up.

realloc_stack_state is renamed to grow_stack_state to better convey
that it never shrinks the stack state.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c | 195 ++++++++++++++++++++++--------------------
 1 file changed, 100 insertions(+), 95 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8fd552c16763..67d914b26a39 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -737,81 +737,104 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 	verbose(env, "\n");
 }
 
-#define COPY_STATE_FN(NAME, COUNT, FIELD, SIZE)				\
-static int copy_##NAME##_state(struct bpf_func_state *dst,		\
-			       const struct bpf_func_state *src)	\
-{									\
-	if (!src->FIELD)						\
-		return 0;						\
-	if (WARN_ON_ONCE(dst->COUNT < src->COUNT)) {			\
-		/* internal bug, make state invalid to reject the program */ \
-		memset(dst, 0, sizeof(*dst));				\
-		return -EFAULT;						\
-	}								\
-	memcpy(dst->FIELD, src->FIELD,					\
-	       sizeof(*src->FIELD) * (src->COUNT / SIZE));		\
-	return 0;							\
-}
-/* copy_reference_state() */
-COPY_STATE_FN(reference, acquired_refs, refs, 1)
-/* copy_stack_state() */
-COPY_STATE_FN(stack, allocated_stack, stack, BPF_REG_SIZE)
-#undef COPY_STATE_FN
-
-#define REALLOC_STATE_FN(NAME, COUNT, FIELD, SIZE)			\
-static int realloc_##NAME##_state(struct bpf_func_state *state, int size, \
-				  bool copy_old)			\
-{									\
-	u32 old_size = state->COUNT;					\
-	struct bpf_##NAME##_state *new_##FIELD;				\
-	int slot = size / SIZE;						\
-									\
-	if (size <= old_size || !size) {				\
-		if (copy_old)						\
-			return 0;					\
-		state->COUNT = slot * SIZE;				\
-		if (!size && old_size) {				\
-			kfree(state->FIELD);				\
-			state->FIELD = NULL;				\
-		}							\
-		return 0;						\
-	}								\
-	new_##FIELD = kmalloc_array(slot, sizeof(struct bpf_##NAME##_state), \
-				    GFP_KERNEL);			\
-	if (!new_##FIELD)						\
-		return -ENOMEM;						\
-	if (copy_old) {							\
-		if (state->FIELD)					\
-			memcpy(new_##FIELD, state->FIELD,		\
-			       sizeof(*new_##FIELD) * (old_size / SIZE)); \
-		memset(new_##FIELD + old_size / SIZE, 0,		\
-		       sizeof(*new_##FIELD) * (size - old_size) / SIZE); \
-	}								\
-	state->COUNT = slot * SIZE;					\
-	kfree(state->FIELD);						\
-	state->FIELD = new_##FIELD;					\
-	return 0;							\
+/* copy array src of length n * size bytes to dst. dst is reallocated if it's too
+ * small to hold src. This is different from krealloc since we don't want to preserve
+ * the contents of dst.
+ *
+ * Leaves dst untouched if src is NULL or length is zero. Returns NULL if memory could
+ * not be allocated.
+ */
+static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (ZERO_OR_NULL_PTR(src))
+		goto out;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+
+	if (ksize(dst) < bytes) {
+		kfree(dst);
+		dst = kmalloc_track_caller(bytes, flags);
+		if (!dst)
+			return NULL;
+	}
+
+	memcpy(dst, src, bytes);
+out:
+	return dst ? dst : ZERO_SIZE_PTR;
 }
-/* realloc_reference_state() */
-REALLOC_STATE_FN(reference, acquired_refs, refs, 1)
-/* realloc_stack_state() */
-REALLOC_STATE_FN(stack, allocated_stack, stack, BPF_REG_SIZE)
-#undef REALLOC_STATE_FN
-
-/* do_check() starts with zero-sized stack in struct bpf_verifier_state to
- * make it consume minimal amount of memory. check_stack_write() access from
- * the program calls into realloc_func_state() to grow the stack size.
- * Note there is a non-zero 'parent' pointer inside bpf_verifier_state
- * which realloc_stack_state() copies over. It points to previous
- * bpf_verifier_state which is never reallocated.
+
+/* resize an array from old_n items to new_n items. the array is reallocated if it's too
+ * small to hold new_n items. new items are zeroed out if the array grows.
+ *
+ * Contrary to krealloc_array, does not free arr if new_n is zero.
  */
-static int realloc_func_state(struct bpf_func_state *state, int stack_size,
-			      int refs_size, bool copy_old)
+static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
+{
+	if (!new_n || old_n == new_n)
+		goto out;
+
+	arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
+	if (!arr)
+		return NULL;
+
+	if (new_n > old_n)
+		memset(arr + old_n * size, 0, (new_n - old_n) * size);
+
+out:
+	return arr ? arr : ZERO_SIZE_PTR;
+}
+
+static int copy_reference_state(struct bpf_func_state *dst, const struct bpf_func_state *src)
+{
+	dst->refs = copy_array(dst->refs, src->refs, src->acquired_refs,
+			       sizeof(struct bpf_reference_state), GFP_KERNEL);
+	if (!dst->refs)
+		return -ENOMEM;
+
+	dst->acquired_refs = src->acquired_refs;
+	return 0;
+}
+
+static int copy_stack_state(struct bpf_func_state *dst, const struct bpf_func_state *src)
+{
+	size_t n = src->allocated_stack / BPF_REG_SIZE;
+
+	dst->stack = copy_array(dst->stack, src->stack, n, sizeof(struct bpf_stack_state),
+				GFP_KERNEL);
+	if (!dst->stack)
+		return -ENOMEM;
+
+	dst->allocated_stack = src->allocated_stack;
+	return 0;
+}
+
+static int resize_reference_state(struct bpf_func_state *state, size_t n)
 {
-	int err = realloc_reference_state(state, refs_size, copy_old);
-	if (err)
-		return err;
-	return realloc_stack_state(state, stack_size, copy_old);
+	state->refs = realloc_array(state->refs, state->acquired_refs, n,
+				    sizeof(struct bpf_reference_state));
+	if (!state->refs)
+		return -ENOMEM;
+
+	state->acquired_refs = n;
+	return 0;
+}
+
+static int grow_stack_state(struct bpf_func_state *state, int size)
+{
+	size_t old_n = state->allocated_stack / BPF_REG_SIZE, n = size / BPF_REG_SIZE;
+
+	if (old_n >= n)
+		return 0;
+
+	state->stack = realloc_array(state->stack, old_n, n, sizeof(struct bpf_stack_state));
+	if (!state->stack)
+		return -ENOMEM;
+
+	state->allocated_stack = size;
+	return 0;
 }
 
 /* Acquire a pointer id from the env and update the state->refs to include
@@ -825,7 +848,7 @@ static int acquire_reference_state(struct bpf_verifier_env *env, int insn_idx)
 	int new_ofs = state->acquired_refs;
 	int id, err;
 
-	err = realloc_reference_state(state, state->acquired_refs + 1, true);
+	err = resize_reference_state(state, state->acquired_refs + 1);
 	if (err)
 		return err;
 	id = ++env->id_gen;
@@ -854,18 +877,6 @@ static int release_reference_state(struct bpf_func_state *state, int ptr_id)
 	return -EINVAL;
 }
 
-static int transfer_reference_state(struct bpf_func_state *dst,
-				    struct bpf_func_state *src)
-{
-	int err = realloc_reference_state(dst, src->acquired_refs, false);
-	if (err)
-		return err;
-	err = copy_reference_state(dst, src);
-	if (err)
-		return err;
-	return 0;
-}
-
 static void free_func_state(struct bpf_func_state *state)
 {
 	if (!state)
@@ -904,10 +915,6 @@ static int copy_func_state(struct bpf_func_state *dst,
 {
 	int err;
 
-	err = realloc_func_state(dst, src->allocated_stack, src->acquired_refs,
-				 false);
-	if (err)
-		return err;
 	memcpy(dst, src, offsetof(struct bpf_func_state, acquired_refs));
 	err = copy_reference_state(dst, src);
 	if (err)
@@ -2590,8 +2597,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	u32 dst_reg = env->prog->insnsi[insn_idx].dst_reg;
 	struct bpf_reg_state *reg = NULL;
 
-	err = realloc_func_state(state, round_up(slot + 1, BPF_REG_SIZE),
-				 state->acquired_refs, true);
+	err = grow_stack_state(state, round_up(slot + 1, BPF_REG_SIZE));
 	if (err)
 		return err;
 	/* caller checked that off % size == 0 and -MAX_BPF_STACK <= off < 0,
@@ -2753,8 +2759,7 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 	if (value_reg && register_is_null(value_reg))
 		writing_zero = true;
 
-	err = realloc_func_state(state, round_up(-min_off, BPF_REG_SIZE),
-				 state->acquired_refs, true);
+	err = grow_stack_state(state, round_up(-min_off, BPF_REG_SIZE));
 	if (err)
 		return err;
 
@@ -5629,7 +5634,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			subprog /* subprog number within this prog */);
 
 	/* Transfer references to the callee */
-	err = transfer_reference_state(callee, caller);
+	err = copy_reference_state(callee, caller);
 	if (err)
 		return err;
 
@@ -5780,7 +5785,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	}
 
 	/* Transfer references to the caller */
-	err = transfer_reference_state(caller, callee);
+	err = copy_reference_state(caller, callee);
 	if (err)
 		return err;
 
-- 
2.27.0

