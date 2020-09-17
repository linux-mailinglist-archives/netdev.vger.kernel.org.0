Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3483926E699
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgIQUUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:20:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726408AbgIQUUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:20:13 -0400
X-Greylist: delayed 36426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 16:20:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600374010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B24KSRbIwXQOyKOl2uuXHb901ZD8uJQKrkmRJ2UO4pg=;
        b=bvCwds/oMfS2lJaxEI3PzE+MyihY9Sd6Mi4fCcroOdJFq06fb9DNUmHoxmtQleThGl1hLj
        m52JNpdRN+HxSOxL9kjb/MEzQWsrWJiv79RVVAwTR9xG51eP5Milni5ES+ATxXHK0pHPdI
        d7ndLtwPd59ohNDuELHREaxo7WAcLqI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-mGpG28YpPdqn_WdOAvgB7A-1; Thu, 17 Sep 2020 16:20:08 -0400
X-MC-Unique: mGpG28YpPdqn_WdOAvgB7A-1
Received: by mail-ed1-f71.google.com with SMTP id y1so1364635edw.16
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=B24KSRbIwXQOyKOl2uuXHb901ZD8uJQKrkmRJ2UO4pg=;
        b=s5N7ptwSAgHw8Jr9av1sP8XqIPQfD5/JVxXa0/Iv8HzRetYctC2Zl6XhPnJiaLX6uf
         Y30pUH8nQ1esPLWY7qX5mJWDJS669GmnJK9phBKwBDe/lld9VbBFIPudp9evCX2Czqot
         DrJzcB/OsjPqiz8QfrrMjXPyfUNISegfg7zacV40lckvD89LDiWD1oIuA5y9MnNfR5BG
         DwvNTZK2eW0EvS3Y4sYNFaz6nO5GtsTJ+KLk0YQLpP6eagpJVEbYO39RNruK3kwv5qET
         ykfEPQINUyIDKhrgORzrZBdTOfvPuLvzsMF8bQ9c9HiHV0wtessgxUdxZc/FTtDkYlee
         Iq4w==
X-Gm-Message-State: AOAM533Y4roIF43xVRcV6qg2vqC2p816hoYkNiHOsbtq9h/Xjx0QD2d2
        4vi4umiheg2wS6o2+veEL4zAQujnkb8j5oazW3GXs+7k4SpblzHHyxtrIPheg6nF0/0mCrFC/ML
        m1DHAG7DXJ0ElmDJf
X-Received: by 2002:a05:6402:1548:: with SMTP id p8mr36095062edx.65.1600374006460;
        Thu, 17 Sep 2020 13:20:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS6ahjX4HgiG1kLAZk/44LZz+0UJGWgPfrp0/bkpIXgTE2qyO9oc0NT7UG09v39ybEw0919w==
X-Received: by 2002:a05:6402:1548:: with SMTP id p8mr36095016edx.65.1600374005950;
        Thu, 17 Sep 2020 13:20:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qu11sm647148ejb.15.2020.09.17.13.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 13:20:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0BD1C183A90; Thu, 17 Sep 2020 22:20:05 +0200 (CEST)
Subject: [PATCH bpf-next v6 04/10] bpf: move prog->aux->linked_prog and
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
Date:   Thu, 17 Sep 2020 22:20:05 +0200
Message-ID: <160037400495.28970.10089605533997875539.stgit@toke.dk>
In-Reply-To: <160037400056.28970.7647821897296177963.stgit@toke.dk>
References: <160037400056.28970.7647821897296177963.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h     |   15 +++++++++-----
 kernel/bpf/btf.c        |    6 +++---
 kernel/bpf/core.c       |    9 ++++++---
 kernel/bpf/syscall.c    |   49 +++++++++++++++++++++++++++++++++++++++--------
 kernel/bpf/trampoline.c |   12 ++++--------
 kernel/bpf/verifier.c   |    9 +++++----
 6 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 46383741ff16..9dbac21c8091 100644
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
index 2a20c2833996..a872504c836b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -99,6 +99,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
+	mutex_init(&fp->aux->tgt_mutex);
 
 	return fp;
 }
@@ -255,6 +256,7 @@ void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
 		mutex_destroy(&fp->aux->used_maps_mutex);
+		mutex_destroy(&fp->aux->tgt_mutex);
 		free_percpu(fp->aux->stats);
 		kfree(fp->aux->poke_tab);
 		kfree(fp->aux);
@@ -2137,7 +2139,8 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	bpf_trampoline_put(aux->trampoline);
+	if (aux->tgt_trampoline)
+		bpf_trampoline_put(aux->tgt_trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
@@ -2153,8 +2156,8 @@ void bpf_prog_free(struct bpf_prog *fp)
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
index 2ce32cad5c8e..4af35a59d0d9 100644
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
@@ -2583,19 +2598,37 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		      &bpf_tracing_link_lops, prog);
 	link->attach_type = prog->expected_attach_type;
 
-	err = bpf_link_prime(&link->link, &link_primer);
-	if (err) {
-		kfree(link);
-		goto out_put_prog;
+	mutex_lock(&prog->aux->tgt_mutex);
+
+	if (!prog->aux->tgt_trampoline) {
+		err = -ENOENT;
+		goto out_unlock;
 	}
+	tr = prog->aux->tgt_trampoline;
+	tgt_prog = prog->aux->tgt_prog;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_unlock;
 
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
index e86d32f7f7dc..3145615647a5 100644
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
index 541dd5e09e60..116f3f275b98 100644
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
 	if (!tr)
 		return -ENOMEM;
 
-	prog->aux->trampoline = tr;
+	mutex_lock(&prog->aux->tgt_mutex);
+	prog->aux->tgt_trampoline = tr;
+	mutex_unlock(&prog->aux->tgt_mutex);
 	return 0;
 }
 

