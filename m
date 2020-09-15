Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5426B8B9
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgIPAtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:49:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgIOLli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600170064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgEP1D81FI8N+HdhPcvEFCpdpL+CRIhETRMQsPVnENE=;
        b=dk7dHh6GCdcrLCFjobaujoHRSljH3iBpgGojbdZg9WL30KnL5tBCbAKGCQZwyPfegTVi9P
        WtdP1oGZMmD5Ukb5OmYx6hdHRR+UxY7DYp/O4aV5bFRGfipYjM8dxs3khOqfzjsxCZQ35o
        odrGhT9X2VERCxIYW1IhhQxcq90MKf0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-MBnigCEyPJ2Fy0l7xIophg-1; Tue, 15 Sep 2020 07:41:03 -0400
X-MC-Unique: MBnigCEyPJ2Fy0l7xIophg-1
Received: by mail-ed1-f69.google.com with SMTP id d13so1118278edz.18
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 04:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JgEP1D81FI8N+HdhPcvEFCpdpL+CRIhETRMQsPVnENE=;
        b=hw+NUBeFPcClL8SFXVFuBCt9s0VcQwluoRNmfht58LgojN+nKapdc0sXzelrDAJPps
         tbm2HrV0l39QRDr7MszNaCGRDJ9h/Gr76C6pWnCJpG90wZXNH9Ys13G5KvJlg+mOuI7w
         P/vRw1gCewKJR3X1def//VvOUFJLHXEEXjPkWzc+kBYWkgqekbWqoRrzuZwkk9uK8CzV
         /MJovGZ37weYBXWgIeHvz0CxmzYwbrz3618QVseiYaJtAlp3aPb6aE5s8eIxDVyo14K2
         YFn/LUhMPTOrj+HjSGNEjeRaQIDMtamrKKxzQj7bCvvUPyfZxGIbqyPfnq+vMSJBowAw
         Hs3A==
X-Gm-Message-State: AOAM531ZuARiigog8TqDJOHzxvMrQRtbaTVIC8Gk0ug46XtqZLSmaGmI
        gcopp/v/TOeph9OXeI4DdMfgka2+KUU3X8qy7o+GzcB22ypUe/AMb22TSnLdcrEBZVPQpFo7utY
        dBN1uL1cv6sNaTAbL
X-Received: by 2002:a50:fa88:: with SMTP id w8mr22066088edr.179.1600170061469;
        Tue, 15 Sep 2020 04:41:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDSHYEmi7qmqULKM8vR5D6F3SJvWxvV1ZwKDafsJrKKdz+3rTJrAc3eIQ1hMHxL8eJCxcl7g==
X-Received: by 2002:a50:fa88:: with SMTP id w8mr22066069edr.179.1600170061216;
        Tue, 15 Sep 2020 04:41:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v25sm11603515edr.29.2020.09.15.04.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 04:41:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 520791829CB; Tue, 15 Sep 2020 13:41:00 +0200 (CEST)
Subject: [PATCH bpf-next v5 3/8] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
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
Date:   Tue, 15 Sep 2020 13:41:00 +0200
Message-ID: <160017006024.98230.18011033601869719353.stgit@toke.dk>
In-Reply-To: <160017005691.98230.13648200635390228683.stgit@toke.dk>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

In preparation for allowing multiple attachments of freplace programs, move
the references to the target program and trampoline into the
bpf_tracing_link structure when that is created. To do this atomically,
introduce a new mutex in prog->aux to protect writing to the two pointers
to target prog and trampoline, and rename the members to make it clear that
they are related.

With this change, it is no longer possible to attach the same tracing
program multiple times (detaching in-between), since the reference from the
tracing program to the target disappears on the first attach. However,
since the next patch will let the caller supply an attach target, that will
also make it possible to attach to the same place multiple times.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h     |   15 +++++++++------
 kernel/bpf/btf.c        |    6 +++---
 kernel/bpf/core.c       |    9 ++++++---
 kernel/bpf/syscall.c    |   46 ++++++++++++++++++++++++++++++++++++++++------
 kernel/bpf/trampoline.c |   12 ++++--------
 kernel/bpf/verifier.c   |    9 +++++----
 6 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dcf0c70348a4..939b37c78d55 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -614,8 +614,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 }
 #ifdef CONFIG_BPF_JIT
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
-int bpf_trampoline_link_prog(struct bpf_prog *prog);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
 struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
 					  struct btf_func_model *fmodel);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -666,11 +666,13 @@ static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	return NULL;
 }
-static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
+static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
+					   struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
 }
-static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
+					     struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
 }
@@ -738,14 +740,15 @@ struct bpf_prog_aux {
 	u32 max_rdonly_access;
 	u32 max_rdwr_access;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
-	struct bpf_prog *linked_prog;
+	struct mutex tgt_mutex; /* protects writing of tgt_* pointers below */
+	struct bpf_prog *tgt_prog;
+	struct bpf_trampoline *tgt_trampoline;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
 	bool sleepable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
-	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2ace56c99c36..9228af9917a8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3706,7 +3706,7 @@ struct btf *btf_parse_vmlinux(void)
 
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *tgt_prog = prog->aux->tgt_prog;
 
 	if (tgt_prog) {
 		return tgt_prog->aux->btf;
@@ -3733,7 +3733,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    struct bpf_insn_access_aux *info)
 {
 	const struct btf_type *t = prog->aux->attach_func_proto;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_prog *tgt_prog = prog->aux->tgt_prog;
 	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
@@ -4572,7 +4572,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 		return -EFAULT;
 	}
 	if (prog_type == BPF_PROG_TYPE_EXT)
-		prog_type = prog->aux->linked_prog->type;
+		prog_type = prog->aux->tgt_prog->type;
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..1f11484c2ec2 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -98,6 +98,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->jit_requested = ebpf_jit_enabled();
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
+	mutex_init(&fp->aux->tgt_mutex);
 
 	return fp;
 }
@@ -253,6 +254,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
+		mutex_destroy(&fp->aux->tgt_mutex);
 		free_percpu(fp->aux->stats);
 		kfree(fp->aux->poke_tab);
 		kfree(fp->aux);
@@ -2130,7 +2132,8 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	bpf_trampoline_put(aux->trampoline);
+	if (aux->tgt_trampoline)
+		bpf_trampoline_put(aux->tgt_trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
@@ -2146,8 +2149,8 @@ void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
 
-	if (aux->linked_prog)
-		bpf_prog_put(aux->linked_prog);
+	if (aux->tgt_prog)
+		bpf_prog_put(aux->tgt_prog);
 	INIT_WORK(&aux->work, bpf_prog_free_deferred);
 	schedule_work(&aux->work);
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4108ef3b828b..fc2bca2d9f05 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2161,7 +2161,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 			err = PTR_ERR(tgt_prog);
 			goto free_prog_nouncharge;
 		}
-		prog->aux->linked_prog = tgt_prog;
+		mutex_lock(&prog->aux->tgt_mutex);
+		prog->aux->tgt_prog = tgt_prog;
+		mutex_unlock(&prog->aux->tgt_mutex);
 	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
@@ -2498,11 +2500,22 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 struct bpf_tracing_link {
 	struct bpf_link link;
 	enum bpf_attach_type attach_type;
+	struct bpf_trampoline *trampoline;
+	struct bpf_prog *tgt_prog;
 };
 
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
+	struct bpf_tracing_link *tr_link =
+		container_of(link, struct bpf_tracing_link, link);
+
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
+						tr_link->trampoline));
+
+	bpf_trampoline_put(tr_link->trampoline);
+
+	if (tr_link->tgt_prog)
+		bpf_prog_put(tr_link->tgt_prog);
 }
 
 static void bpf_tracing_link_dealloc(struct bpf_link *link)
@@ -2545,7 +2558,9 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
 	struct bpf_link_primer link_primer;
+	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_tracing_link *link;
+	struct bpf_trampoline *tr;
 	int err;
 
 	switch (prog->type) {
@@ -2583,19 +2598,38 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		      &bpf_tracing_link_lops, prog);
 	link->attach_type = prog->expected_attach_type;
 
+	mutex_lock(&prog->aux->tgt_mutex);
+
+	if (!prog->aux->tgt_trampoline) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+	tr = prog->aux->tgt_trampoline;
+	tgt_prog = prog->aux->tgt_prog;
+
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
-		kfree(link);
-		goto out_put_prog;
+		goto out_unlock;
 	}
 
-	err = bpf_trampoline_link_prog(prog);
+	err = bpf_trampoline_link_prog(prog, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
-		goto out_put_prog;
+		link = NULL;
+		goto out_unlock;
 	}
 
+	link->tgt_prog = tgt_prog;
+	link->trampoline = tr;
+
+	prog->aux->tgt_prog = NULL;
+	prog->aux->tgt_trampoline = NULL;
+	mutex_unlock(&prog->aux->tgt_mutex);
+
 	return bpf_link_settle(&link_primer);
+out_unlock:
+	mutex_unlock(&prog->aux->tgt_mutex);
+	kfree(link);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7845913e7e41..e010a0641e99 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -261,14 +261,12 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog)
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err = 0;
 	int cnt;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (tr->extension_prog) {
@@ -301,7 +299,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	}
 	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
@@ -312,13 +310,11 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
@@ -330,7 +326,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d38678319ca4..02f704367014 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2628,8 +2628,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 
 static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
 {
-	return prog->aux->linked_prog ? prog->aux->linked_prog->type
-				      : prog->type;
+	return prog->aux->tgt_prog ? prog->aux->tgt_prog->type : prog->type;
 }
 
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
@@ -11271,8 +11270,8 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	u32 btf_id = prog->aux->attach_btf_id;
+	struct bpf_prog *tgt_prog = prog->aux->tgt_prog;
 	struct btf_func_model fmodel;
 	struct bpf_trampoline *tr;
 	const struct btf_type *t;
@@ -11336,7 +11335,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	if (IS_ERR(tr))
 		return PTR_ERR(tr);
 
-	prog->aux->trampoline = tr;
+	mutex_lock(&prog->aux->tgt_mutex);
+	prog->aux->tgt_trampoline = tr;
+	mutex_unlock(&prog->aux->tgt_mutex);
 	return 0;
 }
 

