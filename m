Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826AE279376
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgIYVZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729535AbgIYVZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:11 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6nVgdxKtOohBnPcnpi3UK1PyG3ojf+3nbbDuUmJDTME=;
        b=bCfbS9AVv3Azok7weAaBefzdLL5qo1M6lHb0ifOYTK0hSgtblxlU25qRbjZf01NtbloRJC
        RnTdujyAn+N41HxM/VsjGvJoZ+3eRpJP81DUDCKAX4AF3UHpLEM6fny1oGfqqMWP3fksy4
        ZxhRZEcO0wUFuIk2s7a15mXXI40815c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-A97pm2pFORCWZMxi8cBV1g-1; Fri, 25 Sep 2020 17:25:05 -0400
X-MC-Unique: A97pm2pFORCWZMxi8cBV1g-1
Received: by mail-wm1-f72.google.com with SMTP id u5so130393wme.3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6nVgdxKtOohBnPcnpi3UK1PyG3ojf+3nbbDuUmJDTME=;
        b=MWplTTYxVukesMAXSa7A1zjZbopvoLLTSv4LESEb+M8t/RLjgs/vNXzSOBlm10lQKQ
         iXz3RXtCmif2CwPXYYzgqPCqw+qQKZlpoQ3Bp4wC/sJChtVw2eM0+S1tddoqlKwD8bUF
         Xxd/gL8xYy/eSp8XOIbEokNgyD1ULfXIaEMlpv9Y2LH9LvBB9a6Lln7fzCOz+iGQdCa9
         jCI0pE+sUNicRLByOuqWSUVtdT9gSx+t7I4SIsW8uJa6r1Cbw2YeNU4hj/f5YwzqUILL
         MJCH7eKV3c6YuqR8Dc7j/oj/h+sP4SafwPPnyzi3ddRhSBFjX0t+bvBBevcx1xEbnHoW
         GFoA==
X-Gm-Message-State: AOAM531uLmHpjHDtxm9CJpFlNKpTTKJqDjoAA+vhDVTaJT3Fkw4yzP1m
        72otOw2PvpEzB69twHb6dRJqHRA9abul4h0rhP1PZ6E3yB6ne4wT+c/2h5l4+cSFdQ5erO0Sn/j
        3l1tnoOlxwcOTIP46
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr503865wma.46.1601069104217;
        Fri, 25 Sep 2020 14:25:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkqnA67JOjCZ8ezGzlfZx8qcEVnlF2iAhnSPzrGjqk9/9lUgh9+qYG/z2Y9NcpuK3pnm6HEg==
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr503826wma.46.1601069103724;
        Fri, 25 Sep 2020 14:25:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h76sm350436wme.10.2020.09.25.14.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C95C6183C5C; Fri, 25 Sep 2020 23:25:02 +0200 (CEST)
Subject: [PATCH bpf-next v9 03/11] bpf: verifier: refactor
 check_attach_btf_id()
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 25 Sep 2020 23:25:02 +0200
Message-ID: <160106910278.27725.16501032625569915252.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The check_attach_btf_id() function really does three things:

1. It performs a bunch of checks on the program to ensure that the
   attachment is valid.

2. It stores a bunch of state about the attachment being requested in
   the verifier environment and struct bpf_prog objects.

3. It allocates a trampoline for the attachment.

This patch splits out (1.) and (3.) into separate functions which will
perform the checks, but return the computed values instead of directly
modifying the environment. This is done in preparation for reusing the
checks when the actual attachment is happening, which will allow tracing
programs to have multiple (compatible) attachments.

This also fixes a bug where a bunch of checks were skipped if a trampoline
already existed for the tracing target.

Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |   19 +++-
 include/linux/bpf_verifier.h |   13 +++
 kernel/bpf/trampoline.c      |   22 +++++
 kernel/bpf/verifier.c        |  183 ++++++++++++++++++++++--------------------
 4 files changed, 145 insertions(+), 92 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1f9e7c22cc7e..f5974c49804b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -591,6 +591,13 @@ struct bpf_trampoline {
 	struct bpf_ksym ksym;
 };
 
+struct bpf_attach_target_info {
+	struct btf_func_model fmodel;
+	long tgt_addr;
+	const char *tgt_name;
+	const struct btf_type *tgt_type;
+};
+
 #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
 
 struct bpf_dispatcher_prog {
@@ -618,9 +625,10 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 #ifdef CONFIG_BPF_JIT
-struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+struct bpf_trampoline *bpf_trampoline_get(u64 key,
+					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
@@ -665,10 +673,6 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
 #else
-static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
-{
-	return NULL;
-}
 static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
 {
 	return -ENOTSUPP;
@@ -677,6 +681,11 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 {
 	return -ENOTSUPP;
 }
+static inline struct bpf_trampoline *bpf_trampoline_get(u64 key,
+							struct bpf_attach_target_info *tgt_info)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 7bc9276c4ef4..363b4f1c562a 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -450,4 +450,17 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno);
 
+/* this lives here instead of in bpf.h because it needs to dereference tgt_prog */
+static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_prog,
+					     u32 btf_id)
+{
+        return tgt_prog ? (((u64)tgt_prog->aux->id) << 32 | btf_id) : btf_id;
+}
+
+int bpf_check_attach_target(struct bpf_verifier_log *log,
+			    const struct bpf_prog *prog,
+			    const struct bpf_prog *tgt_prog,
+			    u32 btf_id,
+			    struct bpf_attach_target_info *tgt_info);
+
 #endif /* _LINUX_BPF_VERIFIER_H */
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7dd523a7e32d..28c1899949e0 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -65,7 +65,7 @@ static void bpf_trampoline_ksym_add(struct bpf_trampoline *tr)
 	bpf_image_ksym_add(tr->image, ksym);
 }
 
-struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
+static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
@@ -336,6 +336,26 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	return err;
 }
 
+struct bpf_trampoline *bpf_trampoline_get(u64 key,
+					  struct bpf_attach_target_info *tgt_info)
+{
+	struct bpf_trampoline *tr;
+
+	tr = bpf_trampoline_lookup(key);
+	if (!tr)
+		return NULL;
+
+	mutex_lock(&tr->mutex);
+	if (tr->func.addr)
+		goto out;
+
+	memcpy(&tr->func.model, &tgt_info->fmodel, sizeof(tgt_info->fmodel));
+	tr->func.addr = (void *)tgt_info->tgt_addr;
+out:
+	mutex_unlock(&tr->mutex);
+	return tr;
+}
+
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
 	if (!tr)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 400c265fdd73..0883822b91b4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11173,11 +11173,10 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 }
 #define SECURITY_PREFIX "security_"
 
-static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
+static int check_attach_modify_return(unsigned long addr, const char *func_name)
 {
 	if (within_error_injection_list(addr) ||
-	    !strncmp(SECURITY_PREFIX, prog->aux->attach_func_name,
-		     sizeof(SECURITY_PREFIX) - 1))
+	    !strncmp(SECURITY_PREFIX, func_name, sizeof(SECURITY_PREFIX) - 1))
 		return 0;
 
 	return -EINVAL;
@@ -11214,43 +11213,26 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
 }
 
-static int check_attach_btf_id(struct bpf_verifier_env *env)
+int bpf_check_attach_target(struct bpf_verifier_log *log,
+			    const struct bpf_prog *prog,
+			    const struct bpf_prog *tgt_prog,
+			    u32 btf_id,
+			    struct bpf_attach_target_info *tgt_info)
 {
-	struct bpf_prog *prog = env->prog;
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
-	struct bpf_verifier_log *log = &env->log;
-	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
-	struct btf_func_model fmodel;
 	int ret = 0, subprog = -1, i;
-	struct bpf_trampoline *tr;
 	const struct btf_type *t;
 	bool conservative = true;
 	const char *tname;
 	struct btf *btf;
-	long addr;
-	u64 key;
-
-	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
-	    prog->type != BPF_PROG_TYPE_LSM) {
-		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
-		return -EINVAL;
-	}
-
-	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
-		return check_struct_ops_btf_id(env);
-
-	if (prog->type != BPF_PROG_TYPE_TRACING &&
-	    prog->type != BPF_PROG_TYPE_LSM &&
-	    !prog_extension)
-		return 0;
+	long addr = 0;
 
 	if (!btf_id) {
 		bpf_log(log, "Tracing programs must provide btf_id\n");
 		return -EINVAL;
 	}
-	btf = bpf_prog_get_target_btf(prog);
+	btf = tgt_prog ? tgt_prog->aux->btf : btf_vmlinux;
 	if (!btf) {
 		bpf_log(log,
 			"FENTRY/FEXIT program can only be attached to another program annotated with BTF\n");
@@ -11290,8 +11272,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			env->ops = bpf_verifier_ops[tgt_prog->type];
-			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -11327,13 +11307,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			bpf_log(log, "Cannot extend fentry/fexit\n");
 			return -EINVAL;
 		}
-		key = ((u64)aux->id) << 32 | btf_id;
 	} else {
 		if (prog_extension) {
 			bpf_log(log, "Cannot replace kernel functions\n");
 			return -EINVAL;
 		}
-		key = btf_id;
 	}
 
 	switch (prog->expected_attach_type) {
@@ -11363,13 +11341,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			/* should never happen in valid vmlinux build */
 			return -EINVAL;
 
-		/* remember two read only pointers that are valid for
-		 * the life time of the kernel
-		 */
-		prog->aux->attach_func_name = tname;
-		prog->aux->attach_func_proto = t;
-		prog->aux->attach_btf_trace = true;
-		return 0;
+		break;
 	case BPF_TRACE_ITER:
 		if (!btf_type_is_func(t)) {
 			bpf_log(log, "attach_btf_id %u is not a function\n",
@@ -11379,12 +11351,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
-		prog->aux->attach_func_name = tname;
-		prog->aux->attach_func_proto = t;
-		if (!bpf_iter_prog_supported(prog))
-			return -EINVAL;
-		ret = btf_distill_func_proto(log, btf, t, tname, &fmodel);
-		return ret;
+		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
+		if (ret)
+			return ret;
+		break;
 	default:
 		if (!prog_extension)
 			return -EINVAL;
@@ -11393,13 +11363,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	case BPF_LSM_MAC:
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
-		prog->aux->attach_func_name = tname;
-		if (prog->type == BPF_PROG_TYPE_LSM) {
-			ret = bpf_lsm_verify_prog(log, prog);
-			if (ret < 0)
-				return ret;
-		}
-
 		if (!btf_type_is_func(t)) {
 			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
@@ -11411,24 +11374,14 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
-		tr = bpf_trampoline_lookup(key);
-		if (!tr)
-			return -ENOMEM;
-		/* t is either vmlinux type or another program's type */
-		prog->aux->attach_func_proto = t;
-		mutex_lock(&tr->mutex);
-		if (tr->func.addr) {
-			prog->aux->trampoline = tr;
-			goto out;
-		}
-		if (tgt_prog && conservative) {
-			prog->aux->attach_func_proto = NULL;
+
+		if (tgt_prog && conservative)
 			t = NULL;
-		}
-		ret = btf_distill_func_proto(log, btf, t,
-					     tname, &tr->func.model);
+
+		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
 		if (ret < 0)
-			goto out;
+			return ret;
+
 		if (tgt_prog) {
 			if (subprog == 0)
 				addr = (long) tgt_prog->bpf_func;
@@ -11440,8 +11393,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
-				ret = -ENOENT;
-				goto out;
+				return -ENOENT;
 			}
 		}
 
@@ -11466,30 +11418,89 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			default:
 				break;
 			}
-			if (ret)
-				bpf_log(log, "%s is not sleepable\n",
-					prog->aux->attach_func_name);
+			if (ret) {
+				bpf_log(log, "%s is not sleepable\n", tname);
+				return ret;
+			}
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			if (tgt_prog) {
 				bpf_log(log, "can't modify return codes of BPF programs\n");
-				ret = -EINVAL;
-				goto out;
+				return -EINVAL;
+			}
+			ret = check_attach_modify_return(addr, tname);
+			if (ret) {
+				bpf_log(log, "%s() is not modifiable\n", tname);
+				return ret;
 			}
-			ret = check_attach_modify_return(prog, addr);
-			if (ret)
-				bpf_log(log, "%s() is not modifiable\n",
-					prog->aux->attach_func_name);
 		}
-		if (ret)
-			goto out;
-		tr->func.addr = (void *)addr;
-		prog->aux->trampoline = tr;
-out:
-		mutex_unlock(&tr->mutex);
-		if (ret)
-			bpf_trampoline_put(tr);
+
+		break;
+	}
+	tgt_info->tgt_addr = addr;
+	tgt_info->tgt_name = tname;
+	tgt_info->tgt_type = t;
+	return 0;
+}
+
+static int check_attach_btf_id(struct bpf_verifier_env *env)
+{
+	struct bpf_prog *prog = env->prog;
+	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_attach_target_info tgt_info = {};
+	u32 btf_id = prog->aux->attach_btf_id;
+	struct bpf_trampoline *tr;
+	int ret;
+	u64 key;
+
+	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
+	    prog->type != BPF_PROG_TYPE_LSM) {
+		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
+		return -EINVAL;
+	}
+
+	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
+		return check_struct_ops_btf_id(env);
+
+	if (prog->type != BPF_PROG_TYPE_TRACING &&
+	    prog->type != BPF_PROG_TYPE_LSM &&
+	    prog->type != BPF_PROG_TYPE_EXT)
+		return 0;
+
+	ret = bpf_check_attach_target(&env->log, prog, tgt_prog, btf_id, &tgt_info);
+	if (ret)
 		return ret;
+
+	if (tgt_prog && prog->type == BPF_PROG_TYPE_EXT) {
+		env->ops = bpf_verifier_ops[tgt_prog->type];
+		prog->expected_attach_type = tgt_prog->expected_attach_type;
+	}
+
+	/* store info about the attachment target that will be used later */
+	prog->aux->attach_func_proto = tgt_info.tgt_type;
+	prog->aux->attach_func_name = tgt_info.tgt_name;
+
+	if (prog->expected_attach_type == BPF_TRACE_RAW_TP) {
+		prog->aux->attach_btf_trace = true;
+		return 0;
+	} else if (prog->expected_attach_type == BPF_TRACE_ITER) {
+		if (!bpf_iter_prog_supported(prog))
+			return -EINVAL;
+		return 0;
+	}
+
+	if (prog->type == BPF_PROG_TYPE_LSM) {
+		ret = bpf_lsm_verify_prog(&env->log, prog);
+		if (ret < 0)
+			return ret;
 	}
+
+	key = bpf_trampoline_compute_key(tgt_prog, btf_id);
+	tr = bpf_trampoline_get(key, &tgt_info);
+	if (!tr)
+		return -ENOMEM;
+
+	prog->aux->trampoline = tr;
+	return 0;
 }
 
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,

