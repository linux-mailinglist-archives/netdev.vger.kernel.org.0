Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B299C3BE1A3
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhGGDzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:55:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6437 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhGGDzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:55:32 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GKQQq0ySnz77vJ;
        Wed,  7 Jul 2021 11:49:23 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 7 Jul 2021 11:52:50 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
Date:   Wed, 7 Jul 2021 04:38:11 +0000
Message-ID: <20210707043811.5349-4-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707043811.5349-1-hefengqing@huawei.com>
References: <20210707043811.5349-1-hefengqing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf_patch_insn_data, env->prog was input parameter of
bpf_patch_insn_single function. bpf_patch_insn_single call
bpf_prog_realloc to realloc ebpf prog. When we need to malloc new prog,
bpf_prog_realloc will free the old prog, in this scenery is the
env->prog.
Then bpf_patch_insn_data function call adjust_insn_aux_data function, if
adjust_insn_aux_data function return error, bpf_patch_insn_data will
return NULL.
In bpf_check->convert_ctx_accesses->bpf_patch_insn_data call chain, if
bpf_patch_insn_data return NULL, env->prog has been freed in
bpf_prog_realloc, then bpf_check will use the freed env->prog.

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 include/linux/filter.h |  2 +-
 kernel/bpf/core.c      |  9 ++++---
 kernel/bpf/verifier.c  | 53 ++++++++++++++++++++++++++++++++----------
 net/core/filter.c      |  2 +-
 4 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index f39e008a377d..ec11a5ae92c2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -881,7 +881,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog);
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags);
 struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags);
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
-				  gfp_t gfp_extra_flags);
+				  gfp_t gfp_extra_flags, bool free_old);
 void __bpf_prog_free(struct bpf_prog *fp);
 
 static inline void bpf_prog_clone_free(struct bpf_prog *fp)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49b0311f48c1..e5616bb1665b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -218,7 +218,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 }
 
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
-				  gfp_t gfp_extra_flags)
+				  gfp_t gfp_extra_flags, bool free_old)
 {
 	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
@@ -238,7 +238,8 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 		/* We keep fp->aux from fp_old around in the new
 		 * reallocated structure.
 		 */
-		bpf_prog_clone_free(fp_old);
+		if (free_old)
+			bpf_prog_clone_free(fp_old);
 	}
 
 	return fp;
@@ -456,7 +457,7 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 	 * last page could have large enough tailroom.
 	 */
 	prog_adj = bpf_prog_realloc(prog, bpf_prog_size(insn_adj_cnt),
-				    GFP_USER);
+				    GFP_USER, false);
 	if (!prog_adj)
 		return ERR_PTR(-ENOMEM);
 
@@ -1150,6 +1151,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 			return tmp;
 		}
 
+		if (tmp != clone)
+			bpf_prog_clone_free(clone);
 		clone = tmp;
 		insn_delta = rewritten - 1;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 41109f49b724..e75b933f69e4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11855,7 +11855,10 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 		new_prog = bpf_patch_insn_data(env, adj_idx, patch, patch_len);
 		if (!new_prog)
 			return -ENOMEM;
-		env->prog = new_prog;
+		if (new_prog != env->prog) {
+			bpf_prog_clone_free(env->prog);
+			env->prog = new_prog;
+		}
 		insns = new_prog->insnsi;
 		aux = env->insn_aux_data;
 		delta += patch_len - 1;
@@ -11895,7 +11898,10 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			if (!new_prog)
 				return -ENOMEM;
 
-			env->prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = new_prog;
+			}
 			delta += cnt - 1;
 		}
 	}
@@ -11944,7 +11950,10 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
@@ -12042,9 +12051,11 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			return -ENOMEM;
 
 		delta += cnt - 1;
-
-		/* keep walking new program and skip insns we just inserted */
-		env->prog = new_prog;
+		if (new_prog != env->prog) {
+			bpf_prog_clone_free(env->prog);
+			/* keep walking new program and skip insns we just inserted */
+			env->prog = new_prog;
+		}
 		insn      = new_prog->insnsi + i + delta;
 	}
 
@@ -12419,7 +12430,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
@@ -12439,7 +12453,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
@@ -12492,7 +12509,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
@@ -12584,7 +12604,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
@@ -12623,7 +12646,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 					return -ENOMEM;
 
 				delta    += cnt - 1;
-				env->prog = prog = new_prog;
+				if (new_prog != env->prog) {
+					bpf_prog_clone_free(env->prog);
+					env->prog = prog = new_prog;
+				}
 				insn      = new_prog->insnsi + i + delta;
 				continue;
 			}
@@ -12700,7 +12726,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				return -ENOMEM;
 
 			delta    += cnt - 1;
-			env->prog = prog = new_prog;
+			if (new_prog != env->prog) {
+				bpf_prog_clone_free(env->prog);
+				env->prog = prog = new_prog;
+			}
 			insn      = new_prog->insnsi + i + delta;
 			continue;
 		}
diff --git a/net/core/filter.c b/net/core/filter.c
index d70187ce851b..8a8d1a3ba5c2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1268,7 +1268,7 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
 
 	/* Expand fp for appending the new filter representation. */
 	old_fp = fp;
-	fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0);
+	fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0, true);
 	if (!fp) {
 		/* The old_fp is still around in case we couldn't
 		 * allocate new memory, so uncharge on that one.
-- 
2.25.1

