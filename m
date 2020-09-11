Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5233265D43
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgIKKAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:00:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgIKJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNKG6AOVdIfdnzQEvRUadWQ3Pw+S7Ezk0Pev6l/6j6s=;
        b=KTtQDoliuthW4LuDM7cZhuG7+H1ErgZFzbvd0L9li9ophU2omI8RiT7YGEpAOrK4aijD0u
        6mBkr06XHw1/kiRyNIi7BtZRa5JQdu26IyQiQECmSAV1wABy3XPTZS1KFAnEWccO8DH/K2
        OqQvk5Qkn162zTu122RwkocKT5uzAXg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-M0mgfT9VN-OemybYh46GsA-1; Fri, 11 Sep 2020 05:59:20 -0400
X-MC-Unique: M0mgfT9VN-OemybYh46GsA-1
Received: by mail-wr1-f71.google.com with SMTP id a12so3329731wrg.13
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 02:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LNKG6AOVdIfdnzQEvRUadWQ3Pw+S7Ezk0Pev6l/6j6s=;
        b=NOiB3KIlAVVhbxwBt8EFSQPtJJZiMyt6ApAemedBnNKTQOtnsCDxvYC0oGGDSR+hHH
         hm+T04P/UughRTWreYxDfdkGqO+RVaFec3fJ/N1WfsOVsNc6g1dsAh+ZEqxPOA4E+70+
         pTrlLj9bpGPVu8QEkxpb51Jq61onhrIFysOZic9nWMwIl49biT83/CDuRzcV9xmmPllQ
         NTda+cOrA6bFLheHsOeJDhbzVLmU9038z+eEDSUcQZqDz9CEUrbenTopO8ZInj74uqUb
         ZibnSMa8DQY4g0jj91KaDdGDu2RBXpofIQYyP81xSrY2x5tT5JX3jnb8hh9I51Dl5E83
         5oNg==
X-Gm-Message-State: AOAM530Vb57wVO8N2uefAofvhcuQL7mG7LmHYxJMDe0rKKt+FDt9o5do
        sgkOsQBpYhxTgPYm4RDWGgT5t3FqYcWNxKWe8Bdk+7z7eqt4ceYjSxeOjY9GX0wnEJJ7poQVqoZ
        YzMN5Oj0MMkZ5MlT5
X-Received: by 2002:adf:f58b:: with SMTP id f11mr1244790wro.250.1599818358314;
        Fri, 11 Sep 2020 02:59:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqnLpiDPDD5//ycpZ9qPs9MVVjNX1nT3TIkbAQOt3fsxG8EEbqo14h6oDofN2ZHAFxHP8zRw==
X-Received: by 2002:adf:f58b:: with SMTP id f11mr1244766wro.250.1599818358043;
        Fri, 11 Sep 2020 02:59:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z203sm3531603wmc.31.2020.09.11.02.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:59:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 03C8F1829D4; Fri, 11 Sep 2020 11:59:16 +0200 (CEST)
Subject: [PATCH RESEND bpf-next v3 2/9] bpf: verifier: refactor
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
Date:   Fri, 11 Sep 2020 11:59:16 +0200
Message-ID: <159981835693.134722.13561339671142530897.stgit@toke.dk>
In-Reply-To: <159981835466.134722.8652987144251743467.stgit@toke.dk>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |    9 ++
 include/linux/bpf_verifier.h |    9 ++
 kernel/bpf/trampoline.c      |   22 ++++
 kernel/bpf/verifier.c        |  233 +++++++++++++++++++++++-------------------
 4 files changed, 170 insertions(+), 103 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5ad4a935a24e..7f19c3216370 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -616,6 +616,9 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+int bpf_trampoline_get(u64 key, void *addr,
+		       struct btf_func_model *fmodel,
+		       struct bpf_trampoline **trampoline);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
@@ -672,6 +675,12 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 {
 	return -ENOTSUPP;
 }
+static inline int bpf_trampoline_get(u64 key, void *addr,
+				     struct btf_func_model *fmodel,
+				     struct bpf_trampoline **trampoline)
+{
+	return -EOPNOTSUPP;
+}
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 20009e766805..db3db0b69aad 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -447,4 +447,13 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
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
index 7dd523a7e32d..cb442c7ece10 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -336,6 +336,28 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	return err;
 }
 
+int bpf_trampoline_get(u64 key, void *addr,
+		       struct btf_func_model *fmodel,
+		       struct bpf_trampoline **trampoline)
+{
+	struct bpf_trampoline *tr;
+
+	tr = bpf_trampoline_lookup(key);
+	if (!tr)
+		return -ENOMEM;
+
+	mutex_lock(&tr->mutex);
+	if (tr->func.addr)
+		goto out;
+
+	memcpy(&tr->func.model, fmodel, sizeof(*fmodel));
+	tr->func.addr = addr;
+out:
+	mutex_unlock(&tr->mutex);
+	*trampoline = tr;
+	return 0;
+}
+
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
 	if (!tr)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0be7a187fb7f..f2624784b915 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11038,43 +11038,29 @@ static int check_non_sleepable_error_inject(u32 btf_id)
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
@@ -11114,8 +11100,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			env->ops = bpf_verifier_ops[tgt_prog->type];
-			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -11151,13 +11135,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11187,13 +11169,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11203,12 +11179,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11217,13 +11191,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11235,24 +11202,14 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11264,50 +11221,120 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
-				ret = -ENOENT;
-				goto out;
+				return -ENOENT;
 			}
 		}
+		break;
+	}
 
-		if (prog->aux->sleepable) {
-			ret = -EINVAL;
-			switch (prog->type) {
-			case BPF_PROG_TYPE_TRACING:
-				/* fentry/fexit/fmod_ret progs can be sleepable only if they are
-				 * attached to ALLOW_ERROR_INJECTION and are not in denylist.
-				 */
-				if (!check_non_sleepable_error_inject(btf_id) &&
-				    within_error_injection_list(addr))
-					ret = 0;
-				break;
-			case BPF_PROG_TYPE_LSM:
-				/* LSM progs check that they are attached to bpf_lsm_*() funcs.
-				 * Only some of them are sleepable.
-				 */
-				if (check_sleepable_lsm_hook(btf_id))
-					ret = 0;
-				break;
-			default:
-				break;
-			}
-			if (ret)
-				bpf_log(log, "%s is not sleepable\n",
-					prog->aux->attach_func_name);
-		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
-			ret = check_attach_modify_return(prog, addr);
-			if (ret)
-				bpf_log(log, "%s() is not modifiable\n",
-					prog->aux->attach_func_name);
+	if (prog->aux->sleepable) {
+		ret = -EINVAL;
+		switch (prog->type) {
+		case BPF_PROG_TYPE_TRACING:
+			/* fentry/fexit/fmod_ret progs can be sleepable only if they are
+			 * attached to ALLOW_ERROR_INJECTION and are not in denylist.
+			 */
+			if (!check_non_sleepable_error_inject(btf_id) &&
+			    within_error_injection_list(addr))
+				ret = 0;
+			break;
+		case BPF_PROG_TYPE_LSM:
+			/* LSM progs check that they are attached to bpf_lsm_*() funcs.
+			 * Only some of them are sleepable.
+			 */
+			if (check_sleepable_lsm_hook(btf_id))
+				ret = 0;
+			break;
+		default:
+			break;
 		}
-		if (ret)
-			goto out;
-		tr->func.addr = (void *)addr;
-		prog->aux->trampoline = tr;
-out:
-		mutex_unlock(&tr->mutex);
-		if (ret)
-			bpf_trampoline_put(tr);
+		if (ret) {
+			bpf_log(log, "%s is not sleepable\n",
+				prog->aux->attach_func_name);
+			return ret;
+		}
+	}
+
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
+	}
+
+	prog->aux->attach_func_proto = t;
+	prog->aux->attach_func_name = tname;
+
+	switch (prog->expected_attach_type) {
+	case BPF_TRACE_RAW_TP:
+		/* remember two read only pointers that are valid for
+		 * the life time of the kernel
+		 */
+		prog->aux->attach_btf_trace = true;
+		return 0;
+	case BPF_TRACE_ITER:
+		if (!bpf_iter_prog_supported(prog))
+			return -EINVAL;
+		return 0;
+	case BPF_MODIFY_RETURN:
+		ret = check_attach_modify_return(prog, addr);
+		if (ret) {
+			verbose(env, "%s() is not modifiable\n",
+				prog->aux->attach_func_name);
+			return ret;
+		}
+		fallthrough;
+	default:
+		if (prog->type == BPF_PROG_TYPE_LSM) {
+			ret = bpf_lsm_verify_prog(&env->log, prog);
+			if (ret < 0)
+				return ret;
+		}
+		return bpf_trampoline_get(key, (void *)addr, &fmodel,
+					  &prog->aux->trampoline);
 	}
 }
 

