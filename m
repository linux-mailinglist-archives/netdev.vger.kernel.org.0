Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8864A21E138
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGMUMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:12:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31883 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726830AbgGMUMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MasVFjyf+3i++tabfefew/QxMQNTXbpb8QnnRXeUgHo=;
        b=BiKkAoH5kHkuzRYNd1pDeEAe8cNMP1zZ0eHxISjhs1jAxZX0Mggv/ct+V3In4hQ7hdHkDs
        6jzP08E+O/Wj601swRZltS7GaRBR4FEF1phOfRpiyn1mBW2S6Ja3Ee4elD7QIsQ2Mlfpwx
        Q5a7q10V8DAUOul6offfqWNVargV+sY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-1lhtjc7ONNegp5_XdwEgjw-1; Mon, 13 Jul 2020 16:12:25 -0400
X-MC-Unique: 1lhtjc7ONNegp5_XdwEgjw-1
Received: by mail-wr1-f70.google.com with SMTP id d11so18677519wrw.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MasVFjyf+3i++tabfefew/QxMQNTXbpb8QnnRXeUgHo=;
        b=oCMJuLPGzqC0SaWBVzx5MssKerZUu0xRtnt+2M7FnIX9pefGHq48xmYupdAhfxcAex
         m4bUZIEsFEVmwt95zJW5sAFPSSjGorByUc/6slEGF7nGdXS1GRev+QQ6LkhHbtKiOo95
         TCc9g3aQc9S424OJMcPPpIx8JOoPrxyENZcFVmWXseefxbi6aHBZ/4EaqdRVfbVuZ78K
         Q5hQU6tdrvixMce//ZlK67hdR934E9gxrtdSJInAKj7sBQYfbI4GtNO1OHD1JzR7bHsY
         /zuSZk3d4dV+t23xnDs10Jyipc/ZpOekAOvsCOHeF+7qPr1ka3md8+iT5ONKQFIriIJH
         AoOA==
X-Gm-Message-State: AOAM5303eb2Yp35HIuYu+QKVjnzaNPbxaUlBcRFXX2IGPja4iJLUnSkb
        q2t2DeJKiXfyyWw6JC3K03r1Dsz1FZm+LWhm8vhG8XqOKRkja8vUs4d1PSy5ddfPLeuHvWJJmUc
        rl28+PGyoVxdbruqU
X-Received: by 2002:adf:e68d:: with SMTP id r13mr1145667wrm.141.1594671143304;
        Mon, 13 Jul 2020 13:12:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynHsF4eWH0HdBHdA2iw+WN4fRZIug1K5PB5wKUb4QlF7HFhiR00A9gMibXr2DQFaYSO1f4nw==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr1145651wrm.141.1594671142919;
        Mon, 13 Jul 2020 13:12:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t15sm933781wmj.14.2020.07.13.13.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:12:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ED2671804F0; Mon, 13 Jul 2020 22:12:21 +0200 (CEST)
Subject: [PATCH bpf-next 2/6] bpf: verifier: refactor check_attach_btf_id()
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 13 Jul 2020 22:12:21 +0200
Message-ID: <159467114191.370286.3577295271355257627.stgit@toke.dk>
In-Reply-To: <159467113970.370286.17656404860101110795.stgit@toke.dk>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
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
 kernel/bpf/trampoline.c      |   22 ++++++
 kernel/bpf/verifier.c        |  165 ++++++++++++++++++++++++------------------
 4 files changed, 133 insertions(+), 72 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c547065387e4..67310595f720 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -570,6 +570,9 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
 int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+int bpf_trampoline_get(u64 key, void *addr,
+		       struct btf_func_model *fmodel,
+		       struct bpf_trampoline **trampoline);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
@@ -626,6 +629,12 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
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
index 53c7bd568c5d..b882185257cc 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -446,4 +446,13 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
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
index 9be85aa4ec5f..fadfa330f728 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -331,6 +331,28 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
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
index 0db338567cf9..ff3c5c53982c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10724,31 +10724,23 @@ static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
 	return -EINVAL;
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
 	long addr;
-	u64 key;
-
-	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
-		return check_struct_ops_btf_id(env);
-
-	if (prog->type != BPF_PROG_TYPE_TRACING &&
-	    prog->type != BPF_PROG_TYPE_LSM &&
-	    !prog_extension)
-		return 0;
 
 	if (!btf_id) {
 		bpf_log(log, "Tracing programs must provide btf_id\n");
@@ -10794,8 +10786,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			env->ops = bpf_verifier_ops[tgt_prog->type];
-			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -10831,13 +10821,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10867,13 +10855,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10883,12 +10865,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10897,13 +10877,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10915,24 +10888,14 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10944,27 +10907,85 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
 
-		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
-			ret = check_attach_modify_return(prog, addr);
-			if (ret)
-				bpf_log(log, "%s() is not modifiable\n",
-					prog->aux->attach_func_name);
-		}
+	*tgt_addr = addr;
+	if (tgt_name)
+		*tgt_name = tname;
+	if (tgt_type)
+		*tgt_type = t;
+	return 0;
+}
 
-		if (ret)
-			goto out;
-		tr->func.addr = (void *)addr;
-		prog->aux->trampoline = tr;
-out:
-		mutex_unlock(&tr->mutex);
-		if (ret)
-			bpf_trampoline_put(tr);
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
+			prog->expected_attach_type = tgt_prog->expected_attach_type;
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
 

