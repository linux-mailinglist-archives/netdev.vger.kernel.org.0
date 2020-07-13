Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A17F21E13E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGMUMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:12:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23891 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726892AbgGMUMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1/BPEQw8RfyZcO+NWLHyd7BgTIrRVhqDQkxeEyIIXA=;
        b=GFsskRwG0gwuhzItEJNbP26/plZdBe7sV0p40OtoeaUjtHuQ+9lHjbqbQymSeuDwp3bDYG
        rhzsGN7B2WXlDlHYe82WhD3U97QDOxWnBycLUgklgaDLT0M9xWn7y7DzHxqexDrwkqWyxj
        59cK7tXdbuR/OR2bvylqLAYWs92n9fc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-Ljz77xGfN_aUHw_wb2GHPw-1; Mon, 13 Jul 2020 16:12:29 -0400
X-MC-Unique: Ljz77xGfN_aUHw_wb2GHPw-1
Received: by mail-wr1-f70.google.com with SMTP id y18so18752004wrq.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=i1/BPEQw8RfyZcO+NWLHyd7BgTIrRVhqDQkxeEyIIXA=;
        b=G1dcScaIGkI2A2ZelzUB+9oT1upvn6S5Y72cTb2zAZT1ww4nobMIGwVpARr+m9CW0o
         SWYlG0aL99qqmDF8XnEtP+yqXCJccpmkTx4zEDHjbLTO4ugOBMDAsqgrpceKKxN00mQE
         blyykANQiyGc1couiF5W/PQGikmYsPO3GsIygCJiksCLJzesrUgWiEUuFBMroYNAqq70
         V4Qn0xiimarJhP/zJWR2htkdw+uh63XSjH+nTQjjuLaJDyjD9TOfeEoZAchsKubPLjHN
         6l8fVp26EzhkvmIBRBFFvc1w8EylwjH/hqnGFdzRlmDv9VbGm9MEqA+Ke9McOPHlh907
         BkTA==
X-Gm-Message-State: AOAM532mmwODMCA5dm1qGoxSSd69hxsgLw2J6BZHHGFgnF1l0Nz4Qsv/
        fTtY9WUBNIxDmd6DBFRoDz8B04aFuG4PL8iQNb/uSHvDtx1N3TKfugGZz0O14A/EhqXnhtZrrYN
        Xx2fAWVX5YiDbVOQK
X-Received: by 2002:a1c:7fd3:: with SMTP id a202mr1015711wmd.67.1594671147320;
        Mon, 13 Jul 2020 13:12:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxenBix3eFC0SsE9tO/h8hP/73/jfawbkU8TBpwBkAB5ElGGORP5U76cppDD3ZB1+Lzd0F82w==
X-Received: by 2002:a1c:7fd3:: with SMTP id a202mr1015691wmd.67.1594671146944;
        Mon, 13 Jul 2020 13:12:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l1sm25853364wrb.12.2020.07.13.13.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:12:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0D8711804F0; Mon, 13 Jul 2020 22:12:23 +0200 (CEST)
Subject: [PATCH bpf-next 3/6] bpf: support attaching freplace programs to
 multiple attach points
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 13 Jul 2020 22:12:23 +0200
Message-ID: <159467114297.370286.13434549915540848776.stgit@toke.dk>
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

This enables support for attaching freplace programs to multiple attach
points. It does this by amending UAPI for bpf_raw_tracepoint_open with a
target prog fd and btf ID pair that can be used to supply the new
attachment point. The target must be compatible with the target that was
supplied at program load time.

Since the checks for the attach target compatibility will output debug
information about why the attachment was rejected to the verifier log, also
add support for supplying a log buffer to bpf_raw_tracepoint_open.

The implementation reuses the checks that were factored out of
check_attach_btf_id() in the previous patch. It also moves the BPF
trampoline out of prog->aux and into struct bpf_tracking_link where it is
managed as part of the bpf_link structure. When a new target is specified,
a reference to the target program is also kept in the bpf_link structure
which removes the need to keep references to all attach targets in the
bpf_prog structure itself.

The code could theoretically support multiple-attach of other types of
tracing programs as well, but since I don't have a use case for any of
those, the bpf_tracing_prog_attach() function will reject new targets for
anything other than PROG_TYPE_EXT programs.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h      |   14 ++++---
 include/uapi/linux/bpf.h |    9 +++-
 kernel/bpf/core.c        |    1 
 kernel/bpf/syscall.c     |   96 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/bpf/trampoline.c  |   14 +++----
 kernel/bpf/verifier.c    |   16 +++++---
 6 files changed, 121 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 67310595f720..3d43778a1d05 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -568,8 +568,8 @@ static __always_inline unsigned int bpf_dispatcher_nop_func(
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
@@ -621,11 +621,13 @@ static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
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
@@ -697,10 +699,12 @@ struct bpf_prog_aux {
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
 	enum bpf_tramp_prog_type trampoline_prog_type;
-	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
+	/* target BPF prog types for trace programs */
+	enum bpf_prog_type tgt_prog_type;
+	enum bpf_attach_type tgt_attach_type;
 	/* function name for valid attach_btf_id */
 	const char *attach_func_name;
 	struct bpf_prog **func;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index da9bf35a26f8..662a15e4a1a1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -573,8 +573,13 @@ union bpf_attr {
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-		__u64 name;
-		__u32 prog_fd;
+		__u64		name;
+		__u32		prog_fd;
+		__u32		log_level;	/* verbosity level of log */
+		__u32		log_size;	/* size of user buffer */
+		__aligned_u64	log_buf;	/* user supplied buffer */
+		__u32		tgt_prog_fd;
+		__u32		tgt_btf_id;
 	} raw_tracepoint;
 
 	struct { /* anonymous struct for BPF_BTF_LOAD */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9df4cc9a2907..ed4d7259316a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2087,7 +2087,6 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	bpf_trampoline_put(aux->trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..eec6dc0f0a54 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
+#include <linux/bpf_verifier.h>
 #include <linux/btf.h>
 #include <linux/syscalls.h>
 #include <linux/slab.h>
@@ -2483,11 +2484,21 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
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
+	if (tr_link->tgt_prog)
+		bpf_prog_put(tr_link->tgt_prog);
 }
 
 static void bpf_tracing_link_dealloc(struct bpf_link *link)
@@ -2527,10 +2538,18 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 	.fill_link_info = bpf_tracing_link_fill_link_info,
 };
 
-static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+static int bpf_tracing_prog_attach(struct bpf_prog *prog,
+				   int tgt_prog_fd,
+				   u32 btf_id,
+				   struct bpf_verifier_log *log)
 {
 	struct bpf_link_primer link_primer;
+	struct bpf_trampoline *tr = NULL;
+	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_tracing_link *link;
+	struct btf_func_model fmodel;
+	long addr;
+	u64 key;
 	int err;
 
 	switch (prog->type) {
@@ -2559,6 +2578,43 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
+	if (tgt_prog_fd) {
+		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
+		if (prog->type != BPF_PROG_TYPE_EXT ||
+		    !btf_id) {
+			err = -EINVAL;
+			goto out_put_prog;
+		}
+		tgt_prog = bpf_prog_get(tgt_prog_fd);
+		if (IS_ERR(tgt_prog)) {
+			err = PTR_ERR(tgt_prog);
+			tgt_prog = NULL;
+			goto out_put_prog;
+		}
+
+	} else if (btf_id) {
+		err = -EINVAL;
+		goto out_put_prog;
+	} else {
+		btf_id = prog->aux->attach_btf_id;
+		tgt_prog = prog->aux->linked_prog;
+		if (tgt_prog)
+			bpf_prog_inc(tgt_prog); /* we call bpf_prog_put() on link release */
+	}
+	err = bpf_check_attach_target(log, prog, tgt_prog, btf_id,
+				      &fmodel, &addr, NULL, NULL);
+	if (err)
+		goto out_put_prog;
+
+	if (tgt_prog)
+		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
+	else
+		key = btf_id;
+
+	err = bpf_trampoline_get(key, (void *)addr, &fmodel, &tr);
+	if (err)
+		goto out_put_prog;
+
 	link = kzalloc(sizeof(*link), GFP_USER);
 	if (!link) {
 		err = -ENOMEM;
@@ -2574,15 +2630,21 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
-	err = bpf_trampoline_link_prog(prog);
+	err = bpf_trampoline_link_prog(prog, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		goto out_put_prog;
 	}
+	link->trampoline = tr;
+	link->tgt_prog = tgt_prog;
 
 	return bpf_link_settle(&link_primer);
 out_put_prog:
 	bpf_prog_put(prog);
+	if (tgt_prog)
+		bpf_prog_put(tgt_prog);
+	if (tr)
+		bpf_trampoline_put(tr);
 	return err;
 }
 
@@ -2660,11 +2722,12 @@ static const struct bpf_link_ops bpf_raw_tp_link_lops = {
 	.fill_link_info = bpf_raw_tp_link_fill_link_info,
 };
 
-#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
+#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.tgt_btf_id
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
 	struct bpf_link_primer link_primer;
+	struct bpf_verifier_log log = {};
 	struct bpf_raw_tp_link *link;
 	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
@@ -2679,13 +2742,30 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
+	if (attr->raw_tracepoint.log_level ||
+	    attr->raw_tracepoint.log_buf ||
+	    attr->raw_tracepoint.log_size) {
+		/* user requested verbose verifier output
+		 * and supplied buffer to store the verification trace
+		 */
+		log.level = attr->raw_tracepoint.log_level;
+		log.ubuf = (char __user *) (unsigned long) attr->raw_tracepoint.log_buf;
+		log.len_total = attr->raw_tracepoint.log_size;
+
+		/* log attributes have to be sane */
+		if (log.len_total < 128 || log.len_total > UINT_MAX >> 2 ||
+		    !log.level || !log.ubuf || log.level & ~BPF_LOG_MASK)
+			return -EINVAL;
+	}
+
 	switch (prog->type) {
 	case BPF_PROG_TYPE_TRACING:
 	case BPF_PROG_TYPE_EXT:
 	case BPF_PROG_TYPE_LSM:
 		if (attr->raw_tracepoint.name) {
-			/* The attach point for this category of programs
-			 * should be specified via btf_id during program load.
+			/* The attach point for this category of programs should
+			 * be specified via btf_id during program load, or using
+			 * tgt_btf_id.
 			 */
 			err = -EINVAL;
 			goto out_put_prog;
@@ -2695,7 +2775,9 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog,
+					       attr->raw_tracepoint.tgt_prog_fd,
+					       attr->raw_tracepoint.tgt_btf_id, &log);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index fadfa330f728..40797405f1a0 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -256,14 +256,13 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog)
+int bpf_trampoline_link_prog(struct bpf_prog *prog,
+			     struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err = 0;
 	int cnt;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (tr->extension_prog) {
@@ -296,7 +295,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	}
 	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 	if (err) {
 		hlist_del(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
@@ -307,13 +306,12 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
+			       struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
-	struct bpf_trampoline *tr;
 	int err;
 
-	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
@@ -325,7 +323,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(prog->aux->trampoline);
+	err = bpf_trampoline_update(tr);
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ff3c5c53982c..867bc14f5610 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10889,6 +10889,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
 
+		if ((prog->aux->tgt_prog_type &&
+		     prog->aux->tgt_prog_type != tgt_prog->type) ||
+		    (prog->aux->tgt_attach_type &&
+		     prog->aux->tgt_attach_type != tgt_prog->expected_attach_type))
+			return -EINVAL;
+
 		if (tgt_prog && conservative)
 			t = NULL;
 
@@ -10931,7 +10937,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	const char *tname;
 	long addr;
 	int ret;
-	u64 key;
 
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
 		return check_struct_ops_btf_id(env);
@@ -10947,13 +10952,13 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return ret;
 
 	if (tgt_prog) {
+		prog->aux->tgt_prog_type = tgt_prog->type;
+		prog->aux->tgt_attach_type = tgt_prog->expected_attach_type;
+
 		if (prog->type == BPF_PROG_TYPE_EXT) {
 			env->ops = bpf_verifier_ops[tgt_prog->type];
 			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
-		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
-	} else {
-		key = btf_id;
 	}
 
 	prog->aux->attach_func_proto = t;
@@ -10984,8 +10989,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			if (ret < 0)
 				return ret;
 		}
-		return bpf_trampoline_get(key, (void *)addr, &fmodel,
-					  &prog->aux->trampoline);
+		return 0;
 	}
 }
 

