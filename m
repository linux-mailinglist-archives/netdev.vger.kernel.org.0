Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A5D265D41
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgIKKAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:00:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725849AbgIKJ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnZcYFBaqv6PrwVTvBXmqSm8JrdpRmlPpeWyZynCKo0=;
        b=IY+JNEQi/xDPeazPoy/5Xpshe8lLZJ5RdNBjxF2L5sKleTiBjZ21CsxvyjXCI9mWuKrs+H
        LPY4JjOP2sNPgLDREX+eMEI782acbLjAFAYjdxntq44Cd2Xz4WRfDZZtb/4GHSgXmx8wH7
        kGZ/gxDTXiNj90ENYUZMaT6n5MCmzLY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-CB0WkQn0NGyTOlUQA1TMBg-1; Fri, 11 Sep 2020 05:59:20 -0400
X-MC-Unique: CB0WkQn0NGyTOlUQA1TMBg-1
Received: by mail-wm1-f69.google.com with SMTP id c72so1166200wme.4
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 02:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mnZcYFBaqv6PrwVTvBXmqSm8JrdpRmlPpeWyZynCKo0=;
        b=sK6Q9VMvp30bqBQ6w+9Ja2uJl9JO/gtXEY4U9DaykJswo2y0IkpBG1oXnCpW+M6Wht
         vpweMDB1KXR/vJvBkNpTaTmG9nKFr6u3pQR6/2RqBF8brVj2cLUcSE5pQlXplEpgH9Bm
         RJYuehhDBZFW4EVqSdHMoPdu0JTAt2a+hyR9SlR9K6tUunYO/mul5CsPNSxdTfPHNQaq
         V7uIheB44IbHLXE9Vq5Nv8OlkfFRhMRbJ/4HFL+tyiwcQI6gCBDt1Cv1nDaUggvjEY9s
         +qJH0DWbpFchyh1HxpsOjVR+yAcGNWlI/JnTMuoPqNREQ8UQUtsfA2rIKlA2LktegYpK
         GFxA==
X-Gm-Message-State: AOAM5303EDoXokv5TT8qJo4yMbFiMYN3QwBiIYk2xQd9/rGh6Ne23qyD
        UZ+edJi1HOiz2Qcv1v1PY7q00mM+C0d83/uilpmRJM20mOT1FFGMIRN7sAGLc5hMZ0iotykaPuF
        evX/S6wYVemGkA4Ee
X-Received: by 2002:adf:e488:: with SMTP id i8mr1348953wrm.116.1599818359211;
        Fri, 11 Sep 2020 02:59:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqaMKGhKZkSxwgHNpktLY9u2G2rOs5Rg7VB1+jkrtEg9uZHumC63tTi0LuWSH2sUyeIUfnTA==
X-Received: by 2002:adf:e488:: with SMTP id i8mr1348937wrm.116.1599818358947;
        Fri, 11 Sep 2020 02:59:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z19sm3149156wmi.3.2020.09.11.02.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:59:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 12D321829D5; Fri, 11 Sep 2020 11:59:18 +0200 (CEST)
Subject: [PATCH RESEND bpf-next v3 3/9] bpf: wrap prog->aux->linked_prog in a
 bpf_tracing_link
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
Date:   Fri, 11 Sep 2020 11:59:18 +0200
Message-ID: <159981835802.134722.18147008746583957688.stgit@toke.dk>
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

The bpf_tracing_link structure is a convenient data structure to contain
the reference to a linked program; in preparation for supporting multiple
attachments for the same freplace program, move the linked_prog in
prog->aux into a bpf_tracing_link wrapper.

With this change, it is no longer possible to attach the same tracing
program multiple times (detaching in-between), since the reference from the
tracing program to the target disappears on the first attach. However,
since the next patch will let the caller supply an attach target, that will
also make it possible to attach to the same place multiple times.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h     |   21 +++++++++---
 kernel/bpf/btf.c        |   13 +++++---
 kernel/bpf/core.c       |    5 +--
 kernel/bpf/syscall.c    |   81 +++++++++++++++++++++++++++++++++++++----------
 kernel/bpf/trampoline.c |   12 ++-----
 kernel/bpf/verifier.c   |   13 +++++---
 6 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7f19c3216370..722c60f1c1fc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -26,6 +26,7 @@ struct bpf_verifier_log;
 struct perf_event;
 struct bpf_prog;
 struct bpf_prog_aux;
+struct bpf_tracing_link;
 struct bpf_map;
 struct sock;
 struct seq_file;
@@ -614,8 +615,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
 }
 #ifdef CONFIG_BPF_JIT
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
-int bpf_trampoline_link_prog(struct bpf_prog *prog);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
 int bpf_trampoline_get(u64 key, void *addr,
 		       struct btf_func_model *fmodel,
 		       struct bpf_trampoline **trampoline);
@@ -667,11 +668,13 @@ static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
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
@@ -740,14 +743,13 @@ struct bpf_prog_aux {
 	u32 max_rdonly_access;
 	u32 max_rdwr_access;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
-	struct bpf_prog *linked_prog;
+	struct bpf_tracing_link *tgt_link;
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
@@ -827,6 +829,13 @@ struct bpf_link {
 	struct work_struct work;
 };
 
+struct bpf_tracing_link {
+	struct bpf_link link;
+	enum bpf_attach_type attach_type;
+	struct bpf_trampoline *trampoline;
+	struct bpf_prog *tgt_prog;
+};
+
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2ace56c99c36..e10f13f8251c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3706,10 +3706,10 @@ struct btf *btf_parse_vmlinux(void)
 
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_tracing_link *tgt_link = prog->aux->tgt_link;
 
-	if (tgt_prog) {
-		return tgt_prog->aux->btf;
+	if (tgt_link && tgt_link->tgt_prog) {
+		return tgt_link->tgt_prog->aux->btf;
 	} else {
 		return btf_vmlinux;
 	}
@@ -3733,14 +3733,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    struct bpf_insn_access_aux *info)
 {
 	const struct btf_type *t = prog->aux->attach_func_proto;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
+	struct bpf_prog *tgt_prog = NULL;
 	const struct btf_param *args;
 	u32 nr_args, arg;
 	int i, ret;
 
+	if (prog->aux->tgt_link)
+		tgt_prog = prog->aux->tgt_link->tgt_prog;
+
 	if (off % 8) {
 		bpf_log(log, "func '%s' offset %d is not multiple of 8\n",
 			tname, off);
@@ -4572,7 +4575,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 		return -EFAULT;
 	}
 	if (prog_type == BPF_PROG_TYPE_EXT)
-		prog_type = prog->aux->linked_prog->type;
+		prog_type = prog->aux->tgt_link->tgt_prog->type;
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..54c125cec218 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2130,7 +2130,6 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	bpf_trampoline_put(aux->trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
@@ -2146,8 +2145,8 @@ void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
 
-	if (aux->linked_prog)
-		bpf_prog_put(aux->linked_prog);
+	if (aux->tgt_link)
+		bpf_link_put(&aux->tgt_link->link);
 	INIT_WORK(&aux->work, bpf_prog_free_deferred);
 	schedule_work(&aux->work);
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4108ef3b828b..2d238aa8962e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2095,10 +2095,13 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
 
+static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog *prog,
+							struct bpf_prog *tgt_prog);
+
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
 	enum bpf_prog_type type = attr->prog_type;
-	struct bpf_prog *prog;
+	struct bpf_prog *prog, *tgt_prog = NULL;
 	int err;
 	char license[128];
 	bool is_gpl;
@@ -2154,14 +2157,27 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
 	if (attr->attach_prog_fd) {
-		struct bpf_prog *tgt_prog;
-
 		tgt_prog = bpf_prog_get(attr->attach_prog_fd);
 		if (IS_ERR(tgt_prog)) {
 			err = PTR_ERR(tgt_prog);
 			goto free_prog_nouncharge;
 		}
-		prog->aux->linked_prog = tgt_prog;
+	}
+
+	if (tgt_prog || prog->aux->attach_btf_id) {
+		struct bpf_tracing_link *link;
+
+		link = bpf_tracing_link_create(prog, tgt_prog);
+		if (IS_ERR(link)) {
+			err = PTR_ERR(link);
+			if (tgt_prog)
+				bpf_prog_put(tgt_prog);
+			goto free_prog_nouncharge;
+		}
+		prog->aux->tgt_link = link;
+
+		/* avoid circular ref - will be set on link activation */
+		link->link.prog = NULL;
 	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
@@ -2495,14 +2511,21 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 	return link;
 }
 
-struct bpf_tracing_link {
-	struct bpf_link link;
-	enum bpf_attach_type attach_type;
-};
-
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
+	struct bpf_tracing_link *tr_link =
+		container_of(link, struct bpf_tracing_link, link);
+
+	if (tr_link->trampoline) {
+		if (link->id)
+			WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
+								tr_link->trampoline));
+
+		bpf_trampoline_put(tr_link->trampoline);
+	}
+
+	if (tr_link->tgt_prog)
+		bpf_prog_put(tr_link->tgt_prog);
 }
 
 static void bpf_tracing_link_dealloc(struct bpf_link *link)
@@ -2542,10 +2565,27 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 	.fill_link_info = bpf_tracing_link_fill_link_info,
 };
 
+static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog *prog,
+							struct bpf_prog *tgt_prog)
+{
+	struct bpf_tracing_link *link;
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
+		      &bpf_tracing_link_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+	link->tgt_prog = tgt_prog;
+
+	return link;
+}
+
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
+	struct bpf_tracing_link *link, *olink;
 	struct bpf_link_primer link_primer;
-	struct bpf_tracing_link *link;
 	int err;
 
 	switch (prog->type) {
@@ -2574,14 +2614,16 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
-	link = kzalloc(sizeof(*link), GFP_USER);
+	link = READ_ONCE(prog->aux->tgt_link);
 	if (!link) {
-		err = -ENOMEM;
+		err = -ENOENT;
+		goto out_put_prog;
+	}
+	olink = cmpxchg(&prog->aux->tgt_link, link, NULL);
+	if (olink != link) {
+		err = -ENOENT;
 		goto out_put_prog;
 	}
-	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
-		      &bpf_tracing_link_lops, prog);
-	link->attach_type = prog->expected_attach_type;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
@@ -2589,12 +2631,17 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
-	err = bpf_trampoline_link_prog(prog);
+	err = bpf_trampoline_link_prog(prog, link->trampoline);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		goto out_put_prog;
 	}
 
+	/* at this point the link is no longer referenced from struct bpf_prog,
+	 * so we can populate this without introducing a circular reference.
+	 */
+	link->link.prog = prog;
+
 	return bpf_link_settle(&link_primer);
 out_put_prog:
 	bpf_prog_put(prog);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index cb442c7ece10..abdd431dd502 100644
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
index f2624784b915..d6714c24c4e7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2628,8 +2628,10 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 
 static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
 {
-	return prog->aux->linked_prog ? prog->aux->linked_prog->type
-				      : prog->type;
+	if (prog->aux->tgt_link && prog->aux->tgt_link->tgt_prog)
+		return prog->aux->tgt_link->tgt_prog->type;
+
+	return prog->type;
 }
 
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
@@ -11266,8 +11268,8 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
-	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	u32 btf_id = prog->aux->attach_btf_id;
+	struct bpf_prog *tgt_prog = NULL;
 	struct btf_func_model fmodel;
 	const struct btf_type *t;
 	const char *tname;
@@ -11275,6 +11277,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	int ret;
 	u64 key;
 
+	if (prog->aux->tgt_link)
+		tgt_prog = prog->aux->tgt_link->tgt_prog;
+
 	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
 	    prog->type != BPF_PROG_TYPE_LSM) {
 		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
@@ -11334,7 +11339,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				return ret;
 		}
 		return bpf_trampoline_get(key, (void *)addr, &fmodel,
-					  &prog->aux->trampoline);
+					  &prog->aux->tgt_link->trampoline);
 	}
 }
 

