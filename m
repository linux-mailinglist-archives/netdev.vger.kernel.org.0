Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50159274842
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIVSiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVSip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GWYrHvmr3XeRYW2UYJjZ/yBJV2z+Wc7zdFuDzopftII=;
        b=EcWyhwKbV8ciCOC/bJa11x8XOqVLLeKFxCJpI55qmYyTa00MJ3VY/zr2Z3nRDPJgwS5RJN
        dZObq/kYWciaDJQnqqOMfrWDy2tgaHQmhmSxaBcq5w9CGDJ+IFD4R+CfhXr6yUN8cew4Jc
        tEnOd16ynSFXrw/tfPy3m3siUBpwf8w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-iVlqRWFqM6WopV2tUA5V2Q-1; Tue, 22 Sep 2020 14:38:40 -0400
X-MC-Unique: iVlqRWFqM6WopV2tUA5V2Q-1
Received: by mail-wr1-f69.google.com with SMTP id i10so7761451wrq.5
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GWYrHvmr3XeRYW2UYJjZ/yBJV2z+Wc7zdFuDzopftII=;
        b=WleUcZG50n5ZKVW+5+S8TmTqNTrqa9NKbw/fHPo/aHB7gSQFFbFob7QzFuRHATMbwA
         amQQ6hWxWmVfC9T8tjZI9f2LKGdFP8G6EHOUxGS8O3y2ZORyLtjmzflnxynPGwResxDk
         p5GQT4aI4U4tRvoQd5LkwLh4flSPNtV4pfsx96l5+70M0BdvOuBAyEBL3BQOMyXSPYiw
         xhjSoo9AVP08Ih8PXspsTroel3+M1V1T8f6zw7e/xxGTgP92DO8fkmvgzWb7nA+hV24D
         Q75h1mSqDtF5WuHi2jSrs9b+tC1kJiMZWRBrYpKKJnB8eudYD50KIYT1Dzn14QC52a2K
         U97g==
X-Gm-Message-State: AOAM532Vm8FXWuB0lvXMm85mKzd1Jx1vvAKmDr12ApaPT5Z25bn9YJOm
        fflSDZvymqPnG9BhwZSNigILsLQib/dVRv8A94Kd1msI8HJ0aE3JACf4WUtjrlf26otuN7caFMn
        rWgsN7vcHkDR8wzMi
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr6796768wrt.196.1600799919563;
        Tue, 22 Sep 2020 11:38:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeWZ6Sj3fbsf9LqhMPCgjTJpuu7g5cVQ+dj2fUpqVXe5U6UUSwy1smveV2/cdkV3kSlrWBDA==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr6796744wrt.196.1600799919283;
        Tue, 22 Sep 2020 11:38:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w14sm27943281wrk.95.2020.09.22.11.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 14D2F183A94; Tue, 22 Sep 2020 20:38:37 +0200 (CEST)
Subject: [PATCH bpf-next v8 03/11] bpf: verifier: refactor
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
Date:   Tue, 22 Sep 2020 20:38:37 +0200
Message-ID: <160079991702.8301.18141427563623823055.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
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

This patch splits out (1.) and (3.) into separate functions in preparation
for reusing them when the actual attachment is happening (in the
raw_tracepoint_open syscall operation), which will allow tracing programs
to have multiple (compatible) attachments.

This also fixes a bug where a bunch of checks were skipped if a trampoline
already existed for the tracing target.

Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |    7 +
 include/linux/bpf_verifier.h |    9 ++
 kernel/bpf/trampoline.c      |   20 ++++
 kernel/bpf/verifier.c        |  200 ++++++++++++++++++++++++------------------
 4 files changed, 150 insertions(+), 86 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1f9e7c22cc7e..a1760fd87815 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -621,6 +621,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
+					  struct btf_func_model *fmodel);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
@@ -677,6 +679,11 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 {
 	return -ENOTSUPP;
 }
+static inline struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
+							struct btf_func_model *fmodel)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 7bc9276c4ef4..4fe718a5b4cd 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -450,4 +450,13 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno);
 
+int bpf_check_attach_target(struct bpf_verifier_log *log,
+			    const struct bpf_prog *prog,
+			    const struct bpf_prog *tgt_prog,
+			    u32 btf_id,
+			    struct btf_func_model *fmodel,
+			    long *tgt_addr,
+			    const char **tgt_name,
+			    const struct btf_type **tgt_type);
+
 #endif /* _LINUX_BPF_VERIFIER_H */
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7dd523a7e32d..e86d32f7f7dc 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -336,6 +336,26 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	return err;
 }
 
+struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
+					  struct btf_func_model *fmodel)
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
+	memcpy(&tr->func.model, fmodel, sizeof(*fmodel));
+	tr->func.addr = addr;
+out:
+	mutex_unlock(&tr->mutex);
+	return tr;
+}
+
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
 	if (!tr)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 81e1bdc492f8..ad244a606d7a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11174,11 +11174,11 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 }
 #define SECURITY_PREFIX "security_"
 
-static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
+static int check_attach_modify_return(const struct bpf_prog *prog, unsigned long addr,
+				      const char *func_name)
 {
 	if (within_error_injection_list(addr) ||
-	    !strncmp(SECURITY_PREFIX, prog->aux->attach_func_name,
-		     sizeof(SECURITY_PREFIX) - 1))
+	    !strncmp(SECURITY_PREFIX, func_name, sizeof(SECURITY_PREFIX) - 1))
 		return 0;
 
 	return -EINVAL;
@@ -11215,43 +11215,29 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
 }
 
-static int check_attach_btf_id(struct bpf_verifier_env *env)
+int bpf_check_attach_target(struct bpf_verifier_log *log,
+			    const struct bpf_prog *prog,
+			    const struct bpf_prog *tgt_prog,
+			    u32 btf_id,
+			    struct btf_func_model *fmodel,
+			    long *tgt_addr,
+			    const char **tgt_name,
+			    const struct btf_type **tgt_type)
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
@@ -11291,8 +11277,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			env->ops = bpf_verifier_ops[tgt_prog->type];
-			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -11328,13 +11312,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11364,13 +11346,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11380,12 +11356,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
-		prog->aux->attach_func_name = tname;
-		prog->aux->attach_func_proto = t;
-		if (!bpf_iter_prog_supported(prog))
-			return -EINVAL;
-		ret = btf_distill_func_proto(log, btf, t, tname, &fmodel);
-		return ret;
+		ret = btf_distill_func_proto(log, btf, t, tname, fmodel);
+		if (ret)
+			return ret;
+		break;
 	default:
 		if (!prog_extension)
 			return -EINVAL;
@@ -11394,13 +11368,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11412,24 +11379,14 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
+		ret = btf_distill_func_proto(log, btf, t, tname, fmodel);
 		if (ret < 0)
-			goto out;
+			return ret;
+
 		if (tgt_prog) {
 			if (subprog == 0)
 				addr = (long) tgt_prog->bpf_func;
@@ -11441,8 +11398,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
-				ret = -ENOENT;
-				goto out;
+				return -ENOENT;
 			}
 		}
 
@@ -11467,30 +11423,102 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
+			ret = check_attach_modify_return(prog, addr, tname);
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
+	*tgt_addr = addr;
+	if (tgt_name)
+		*tgt_name = tname;
+	if (tgt_type)
+		*tgt_type = t;
+	return 0;
+}
+
+static int check_attach_btf_id(struct bpf_verifier_env *env)
+{
+	struct bpf_prog *prog = env->prog;
+	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	u32 btf_id = prog->aux->attach_btf_id;
+	struct btf_func_model fmodel;
+	struct bpf_trampoline *tr;
+	const struct btf_type *t;
+	const char *tname;
+	long addr;
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
+	ret = bpf_check_attach_target(&env->log, prog, tgt_prog, btf_id,
+				      &fmodel, &addr, &tname, &t);
+	if (ret)
 		return ret;
+
+	if (tgt_prog) {
+		if (prog->type == BPF_PROG_TYPE_EXT) {
+			env->ops = bpf_verifier_ops[tgt_prog->type];
+			prog->expected_attach_type =
+				tgt_prog->expected_attach_type;
+		}
+		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
+	} else {
+		key = btf_id;
 	}
+
+	/* remember two read only pointers that are valid for
+	 * the life time of the kernel
+	 */
+	prog->aux->attach_func_proto = t;
+	prog->aux->attach_func_name = tname;
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
+	}
+
+	tr = bpf_trampoline_get(key, (void *)addr, &fmodel);
+	if (!tr)
+		return -ENOMEM;
+
+	prog->aux->trampoline = tr;
+	return 0;
 }
 
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,

