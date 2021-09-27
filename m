Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3D419E3C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhI0S2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbhI0S2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:28:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D591C06176A
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kn18so109132pjb.5
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43dYGFExJoNuUmNt38Q8tohqKTb1ufKF7gir+xFriEA=;
        b=OTAJiCmBuuuFhoToQMBxE4KKkWNnqjyY0T5C3ko8WigldOACXGOmEVIThFL4CLWHfO
         0boiIvm+MRHkRP41MYoLnff6X/iHRMjtpJjnNiOV5LMSlmS2bgfQf1LYCsoBbDk6Vro4
         YGrdlHlgW3FYYUDbRLxmgCOQqLpvBX8z7RJbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43dYGFExJoNuUmNt38Q8tohqKTb1ufKF7gir+xFriEA=;
        b=gI+1HZPAgsAB2DXSYgCizGjfBHrsGJQJCugzDzMoFBa7qIApOAlftq/DvpYZeJ/opr
         Z9zk1DooNOkjvMMgQFnIJktpFM/Fsx6u4Qrh1ToRXf4BKsvmQg3m8qzdv4012+e+fSbr
         LaxrooejUI143TmG5UoRAp5jNsIj9e84h+fE0TFePyzLOEJdN4uZ09zyFPhEN1Nzftm7
         zEBheJaHBxfNSOX03OuBQOAR8VXRJT0g0MsIZeuMKu7tRUXjX7Y3lV98oaiSMBNQIYyf
         uYZWmUnasmxIUtyyV9IxrHmtG8SMGBCuhJ+GR9q1wjZ5ELC2t2NAwmh2CwgCIgnITeul
         p3DA==
X-Gm-Message-State: AOAM5317HOMXsZT9CLrlgxtMnkonYCs0BXF5i5sLOogSgR+5/FWpJDhf
        jyBH6A8ipmQjXPR2OaVREPAgpg==
X-Google-Smtp-Source: ABdhPJxn5n/7A6OeXcZ2gt0ceLGh0mQJYaK+ALnORV1nQHPSTfrg5bFiJNgYv9qmlI2GDrQ5D/juVA==
X-Received: by 2002:a17:90a:8596:: with SMTP id m22mr569840pjn.218.1632767223760;
        Mon, 27 Sep 2021 11:27:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h21sm17302774pfc.118.2021.09.27.11.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:27:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 2/2] bpf: Replace callers of BPF_CAST_CALL with proper function typedef
Date:   Mon, 27 Sep 2021 11:27:00 -0700
Message-Id: <20210927182700.2980499-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927182700.2980499-1-keescook@chromium.org>
References: <20210927182700.2980499-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5714; h=from:subject; bh=9JNJGH2jsdZr2e7yM2qvfQSMdoLIKPava0PYTFnVOoE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhUgzzQWvlA6xROER3rNkckjnSKXUmUWAhnSt0wEvb X2wRni2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYVIM8wAKCRCJcvTf3G3AJl+zD/ 4kSHS8ROEmGLh19XUw5x0ZU+DiRLH2SQ1oI6znQZbgydbJmDS81IMLn+XMiTZevkXONslNzNQKTH1c kc3SDmSLlCifVvC0QCFUi6hajHSbBdLJHYTFTrqCAesvGCtZOne84ZyN5VGs0A0nNrodSE3okF+YDV rN5lLXMpOXS5Wnn+xs1RjKavvL9g1WkOlDAMe0P7IoPumksdGo/xHx17i7qpiqGx8uF5CbhHhyZkyn 6ri6k3O2cOOwGiZKP3nu/BFMBu8648kDEnA8aVTx/cGWLGyVg5wnVFxdEXtXpB5Y9+LlwOkVEvPlAh OufsAAX36wtfReKPXEDrO8eLq/513snXaFKkvKK7AuzDqmGefSlj4I+WDofkWJzHvr3yzS0bKoAoMW bMVA7nsYELnyydbt7/UZFwdb+ZIvqgK200kmEkNkOJjAy6mAb5IED7982+JUMxiNIZd/vHZNtIiB98 urArKjnn5jRgxZMyJw/g7zk6nbLJt9i0Nd2zXn53sWNM0CiVewTUkEFnSHlrOIEPJXeEUOTBYuezaB cwEdmdM8XpOacyGM52zWM87QBpxT5/2nbFiuQJhnpIx4DkEpld9a1Pg8ElZyv+lVE5G1SU2SaaMFrc 3DN/n+3XaZDNpjq3aM9MCTbmZY6KvpV2m6gAf3HtFeQscEWax6MhgkyQpasg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to keep ahead of cases in the kernel where Control Flow
Integrity (CFI) may trip over function call casts, enabling
-Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
various warnings and is one of the last places in the kernel
triggering this warning.

For actual function calls, replace BPF_CAST_CALL() with a typedef, which
captures the same details about the given function pointers.

This change results in no object code difference.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://github.com/KSPP/linux/issues/20
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/bpf.h    | 4 +++-
 include/linux/filter.h | 5 -----
 kernel/bpf/arraymap.c  | 7 +++----
 kernel/bpf/hashtab.c   | 7 +++----
 kernel/bpf/helpers.c   | 5 ++---
 5 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f19f83e..ff633f08cb51 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -48,6 +48,7 @@ extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
 extern struct kobject *btf_kobj;
 
+typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
@@ -142,7 +143,8 @@ struct bpf_map_ops {
 	int (*map_set_for_each_callback_args)(struct bpf_verifier_env *env,
 					      struct bpf_func_state *caller,
 					      struct bpf_func_state *callee);
-	int (*map_for_each_callback)(struct bpf_map *map, void *callback_fn,
+	int (*map_for_each_callback)(struct bpf_map *map,
+				     bpf_callback_t callback_fn,
 				     void *callback_ctx, u64 flags);
 
 	/* BTF name and id of struct allocated by map_alloc */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6c247663d4ce..47f80adbe744 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -360,11 +360,6 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 		.off   = 0,					\
 		.imm   = TGT })
 
-/* Function call */
-
-#define BPF_CAST_CALL(x)					\
-		((u64 (*)(u64, u64, u64, u64, u64))(x))
-
 /* Convert function address to BPF immediate */
 
 #define BPF_CALL_IMM(x)	((void *)(x) - (void *)__bpf_call_base)
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index cebd4fb06d19..5e1ccfae916b 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -645,7 +645,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_array_map_info),
 };
 
-static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
+static int bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback_fn,
 				   void *callback_ctx, u64 flags)
 {
 	u32 i, key, num_elems = 0;
@@ -668,9 +668,8 @@ static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
 			val = array->value + array->elem_size * i;
 		num_elems++;
 		key = i;
-		ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-					(u64)(long)&key, (u64)(long)val,
-					(u64)(long)callback_ctx, 0);
+		ret = callback_fn((u64)(long)map, (u64)(long)&key,
+				  (u64)(long)val, (u64)(long)callback_ctx, 0);
 		/* return value: 0 - continue, 1 - stop and return */
 		if (ret)
 			break;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3d8f9d6997d5..d29af9988f37 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2049,7 +2049,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_hash_map_info),
 };
 
-static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
+static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_fn,
 				  void *callback_ctx, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
@@ -2089,9 +2089,8 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
 				val = elem->key + roundup_key_size;
 			}
 			num_elems++;
-			ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-					(u64)(long)key, (u64)(long)val,
-					(u64)(long)callback_ctx, 0);
+			ret = callback_fn((u64)(long)map, (u64)(long)key,
+					  (u64)(long)val, (u64)(long)callback_ctx, 0);
 			/* return value: 0 - continue, 1 - stop and return */
 			if (ret) {
 				rcu_read_unlock();
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 9aabf84afd4b..25d7e02ba449 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1058,7 +1058,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
 	struct bpf_map *map = t->map;
 	void *value = t->value;
-	void *callback_fn;
+	bpf_callback_t callback_fn;
 	void *key;
 	u32 idx;
 
@@ -1083,8 +1083,7 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 		key = value - round_up(map->key_size, 8);
 	}
 
-	BPF_CAST_CALL(callback_fn)((u64)(long)map, (u64)(long)key,
-				   (u64)(long)value, 0, 0);
+	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
 	/* The verifier checked that return value is zero. */
 
 	this_cpu_write(hrtimer_running, NULL);
-- 
2.30.2

