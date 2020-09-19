Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0D270DC6
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgISLu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgISLu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600516223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nkc8py834+GtLH2NLmAgpctndhaXo0E1xh0+eK3BDu8=;
        b=G8SHG6tOr+vICDbu8Y6g4IgfMp3wxZifE4GAbRsRc5LAjp8IbNFZU9nDmiQAD3D2Rxetgk
        5BYTMEqMkSxklF1y5F7i+x87Qcbygwst9HRW0WiItS5KBrGJC38uJXgjSB66XxnjqhcMkr
        w0CR0pLQb3u82VNAbxjcX7Tga7rf2ow=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-5vdQlQhQNGy7Hak1YJuqcA-1; Sat, 19 Sep 2020 07:50:19 -0400
X-MC-Unique: 5vdQlQhQNGy7Hak1YJuqcA-1
Received: by mail-ej1-f70.google.com with SMTP id dc22so3121528ejb.21
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 04:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nkc8py834+GtLH2NLmAgpctndhaXo0E1xh0+eK3BDu8=;
        b=ZMxsCQtqkTaKZ/wyPNMulcd+its3lb6TkJ0SwA/S22HvwMl0OF+ElTjwpWJFs7SGDi
         m+afRCxC1ZKhAp9T4n5yBDttFJ2NN5w75+29y5bFx/Ev6uw9y/hHsu76nEprhwY6+aE1
         h8e4eR5DwsWU/4Y0Wny9s3eNxuv9z8ATeRqiWuOQtdLI6e3goJzFRHsMj3FdTpr/bE3N
         d98rU0mZQolCVTgGDYCwevpT5TzfzruFdKim+yQpaMxUPmsRlgN7dKSO9PYKmIUtjajY
         cTWsXpSzcH/JOWDM+j1aaM992ydbGRwToXwQMogW796MY5ofWjga5Jfi0QypwRmmSicW
         FEdQ==
X-Gm-Message-State: AOAM5325QReeot0/JyYAyFb8hLxwBYain/b52JFKu/Tf1EH26fBQkBF5
        KxCjLly73NnNkndJgViODqbalHmAK/YJSzm96A4YPbCDf6F14sI3G47UIqWI3/5bkALkeNrU7AH
        4KLX6Y1Swnj2uCZnN
X-Received: by 2002:a05:6402:1007:: with SMTP id c7mr2499137edu.339.1600516217899;
        Sat, 19 Sep 2020 04:50:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7GkfYJHRjPbegmYwM1MugIChrNLfdErze9LLG7VpuxaKgTc11IGjWQ7DpL+GDl9eto6eVGA==
X-Received: by 2002:a05:6402:1007:: with SMTP id c7mr2499108edu.339.1600516217255;
        Sat, 19 Sep 2020 04:50:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id re19sm4214394ejb.86.2020.09.19.04.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 04:50:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 516E4183A91; Sat, 19 Sep 2020 13:49:46 +0200 (CEST)
Subject: [PATCH bpf-next v7 03/10] bpf: verifier: refactor
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
Date:   Sat, 19 Sep 2020 13:49:46 +0200
Message-ID: <160051618622.58048.13304507277053169557.stgit@toke.dk>
In-Reply-To: <160051618267.58048.2336966160671014012.stgit@toke.dk>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
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

No functional change is intended with this patch.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |    7 +
 include/linux/bpf_verifier.h |    9 ++
 kernel/bpf/trampoline.c      |   20 ++++
 kernel/bpf/verifier.c        |  197 ++++++++++++++++++++++++------------------
 4 files changed, 149 insertions(+), 84 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 59db5165b3d8..9d444021f160 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -616,6 +616,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
+					  struct btf_func_model *fmodel);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
@@ -672,6 +674,11 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
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
index 44cfd5697241..412b0810807f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11144,11 +11144,11 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
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
@@ -11185,43 +11185,29 @@ static int check_non_sleepable_error_inject(u32 btf_id)
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
@@ -11261,8 +11247,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			env->ops = bpf_verifier_ops[tgt_prog->type];
-			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -11298,13 +11282,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11334,13 +11316,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11350,12 +11326,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11364,13 +11338,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11382,24 +11349,14 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11411,8 +11368,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
-				ret = -ENOENT;
-				goto out;
+				return -ENOENT;
 			}
 		}
 
@@ -11437,25 +11393,98 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
-			ret = check_attach_modify_return(prog, addr);
-			if (ret || tgt_prog)
-				bpf_log(log, "%s() is not modifiable\n",
-					prog->aux->attach_func_name);
+			ret = check_attach_modify_return(prog, addr, tname);
+			if (ret || tgt_prog) {
+				bpf_log(log, "%s() is not modifiable\n", tname);
+				return ret;
+			}
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

