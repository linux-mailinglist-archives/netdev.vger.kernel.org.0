Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65D26917E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgINQ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:28:44 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726519AbgINQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5oPubw54gBEhkU8LHQCpNd8SkaDcVURsMVh7sKYhu8=;
        b=iFEPrEm0Ka2OlQ3cmNLYxEasZOd16UT1hihkMaDJmr07uXb6W8Mlp7qveKFKPM3qMUC583
        wLBkMH1AW2ALnT14Rimc1Qkx3IoiFxWMkiT1Bfqa5gKyPH9SQHvKz80NnczPbOaWHKfISL
        p/yLHXpFg7g+bOVha7ZcKb9bU0mliQ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-LotBjAI5MOaKpaQWHMX8Tw-1; Mon, 14 Sep 2020 12:13:29 -0400
X-MC-Unique: LotBjAI5MOaKpaQWHMX8Tw-1
Received: by mail-wm1-f69.google.com with SMTP id m125so160129wmm.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=X5oPubw54gBEhkU8LHQCpNd8SkaDcVURsMVh7sKYhu8=;
        b=OBB2ezGxdcmTL7mMJWvT4/s4skQ/fPK31MXJ7YtZ9hqIphRAQdL7wAgOhSxtOd1UYb
         xrD7CRs8YjA8iNZ0nMyxpxELaGdpjlHNRadncfRFLLAzvZ8loaQJTUKd3LfO9zXNoLY5
         9bCUctkDf+a+l/b7TvtKaIc6dTNAVB5XWNuuja+2qWGQu3kg+V865zojfWwyP7MTa41G
         zyTeszNWkoG1k1WJ6l2y40mcNA9q3R8nC9Pj8+jaun8b7ED9XUEqPUhlFcRHWrdZJlBg
         VHUSIQelBxLzS0hdL9jFhzMRqUX8eqtDgCyT0lpkycBnrMlMvXrfIbmqC7LEa596ZQ1x
         K5VQ==
X-Gm-Message-State: AOAM531Br9H1ZcumjPvYG4j00fX9x1UpTNIVyjcodnBnHOhsT4zz4rOM
        AsGWElm6PZM+1XVRyz+Vxl2YlyfgGN9r0zBGmbvAPMVwx01gNlWmwBcGEQgXu3ujnvtWvC7/3Ok
        tloZMrQAQ+CkqlFqM
X-Received: by 2002:a5d:6547:: with SMTP id z7mr16555476wrv.322.1600100008335;
        Mon, 14 Sep 2020 09:13:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwR2iQXnO1m3G0oGnUQMs1QJGSGqLFOnY0v9cFsD5UucpzWZ/euusQ9YeZFnWsR7eyfjRpU1Q==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr16555452wrv.322.1600100008057;
        Mon, 14 Sep 2020 09:13:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o15sm3004903wmh.29.2020.09.14.09.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3CED81829CB; Mon, 14 Sep 2020 18:13:27 +0200 (CEST)
Subject: [PATCH bpf-next v4 4/8] bpf: support attaching freplace programs to
 multiple attach points
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
Date:   Mon, 14 Sep 2020 18:13:27 +0200
Message-ID: <160010000716.80898.17666778529772660646.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
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
points. It does this by amending the UAPI for bpf_link_Create with a target
btf ID that can be used to supply the new attachment point along with the
target program fd. The target must be compatible with the target that was
supplied at program load time.

The implementation reuses the checks that were factored out of
check_attach_btf_id() to ensure compatibility between the BTF types of the
old and new attachment. If these match, a new bpf_tracing_link will be
created for the new attach target, allowing multiple attachments to
co-exist simultaneously.

The code could theoretically support multiple-attach of other types of
tracing programs as well, but since I don't have a use case for any of
those, there is no API support for doing so.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h            |    3 +
 include/uapi/linux/bpf.h       |    2 +
 kernel/bpf/syscall.c           |  102 +++++++++++++++++++++++++++++++++++++---
 kernel/bpf/verifier.c          |    9 ++++
 tools/include/uapi/linux/bpf.h |    2 +
 5 files changed, 110 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8949e9794dc9..6834e6af9e09 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -751,6 +751,9 @@ struct bpf_prog_aux {
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
index 7dd314176df7..46eaa3024dc3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -239,6 +239,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_TRACE_FREPLACE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -633,6 +634,7 @@ union bpf_attr {
 		__u32		flags;		/* extra flags */
 		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 		__u32		iter_info_len;	/* iter_info length */
+		__u32		target_btf_id;	/* btf_id of target to attach to */
 	} link_create;
 
 	struct { /* struct used by BPF_LINK_UPDATE command */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 266ddd695914..db0a391cd77f 100644
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
@@ -2578,6 +2579,7 @@ static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog *prog,
 	return link;
 }
 
+
 void bpf_tracing_link_free(struct bpf_tracing_link *link)
 {
 	if (!link)
@@ -2589,10 +2591,17 @@ void bpf_tracing_link_free(struct bpf_tracing_link *link)
 	kfree(link);
 }
 
-static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+static int bpf_tracing_prog_attach(struct bpf_prog *prog,
+				   int tgt_prog_fd,
+				   u32 btf_id)
 {
 	struct bpf_link_primer link_primer;
+	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_tracing_link *link;
+	struct btf_func_model fmodel;
+	bool restore_link = false;
+	long addr;
+	u64 key;
 	int err;
 
 	switch (prog->type) {
@@ -2620,16 +2629,81 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		err = -EINVAL;
 		goto out_put_prog;
 	}
+	if (tgt_prog_fd) {
+		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
+		if (prog->type != BPF_PROG_TYPE_EXT || !btf_id) {
+			err = -EINVAL;
+			goto out_put_prog;
+		}
+
+		tgt_prog = bpf_prog_get(tgt_prog_fd);
+		if (IS_ERR(tgt_prog)) {
+			err = PTR_ERR(tgt_prog);
+			goto out_put_prog;
+		}
+
+		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
+	} else if (btf_id) {
+		err = -EINVAL;
+		goto out_put_prog;
+	}
 
 	link = xchg(&prog->aux->tgt_link, NULL);
+	if (link && tgt_prog) {
+		if (link->trampoline->key != key) {
+			/* supplying a tgt_prog is always destructive of the
+			 * target ref from the extension prog, which means that
+			 * mixing old and new API is not supported.
+			 */
+			bpf_tracing_link_free(link);
+			link = NULL;
+		} else {
+			/* re-using link that already has ref on tgt_prog, don't
+			 * take another
+			 */
+			bpf_prog_put(tgt_prog);
+			tgt_prog = NULL;
+		}
+	} else if (link) {
+		/* called without a target fd, so restore link on failure for
+		 * compatibility
+		 */
+		restore_link = true;
+	}
+
 	if (!link) {
-		err = -ENOENT;
-		goto out_put_prog;
+		struct bpf_trampoline *tr;
+
+		if (!tgt_prog) {
+			err = -ENOENT;
+			goto out_put_prog;
+		}
+
+		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
+					      &fmodel, &addr, NULL, NULL);
+		if (err) {
+			bpf_prog_put(tgt_prog);
+			goto out_put_prog;
+		}
+
+		link = bpf_tracing_link_create(prog, tgt_prog);
+		if (IS_ERR(link)) {
+			bpf_prog_put(tgt_prog);
+			err = PTR_ERR(link);
+			goto out_put_prog;
+		}
+
+		tr = bpf_trampoline_get(key, (void *)addr, &fmodel);
+		if (IS_ERR(tr)) {
+			err = PTR_ERR(tr);
+			goto out_put_link;
+		}
+		link->trampoline = tr;
 	}
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-		goto out_restore_link;
+		goto out_put_link;
 
 	err = bpf_trampoline_link_prog(prog, link->trampoline);
 	if (err) {
@@ -2640,8 +2714,11 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	}
 
 	return bpf_link_settle(&link_primer);
-out_restore_link:
-	WARN_ON_ONCE(cmpxchg(&prog->aux->tgt_link, NULL, link) != NULL);
+out_put_link:
+	if (restore_link)
+		WARN_ON_ONCE(cmpxchg(&prog->aux->tgt_link, NULL, link) != NULL);
+	else
+		bpf_tracing_link_free(link);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
@@ -2756,7 +2833,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog, 0, 0);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -2876,6 +2953,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_TRACE_FREPLACE:
+		return BPF_PROG_TYPE_EXT;
 	case BPF_TRACE_ITER:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
@@ -3936,10 +4015,16 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
 	    prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, prog);
 
+	if (attr->link_create.attach_type == BPF_TRACE_FREPLACE &&
+	    !prog->expected_attach_type)
+		return bpf_tracing_prog_attach(prog,
+					       attr->link_create.target_fd,
+					       attr->link_create.target_btf_id);
+
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.target_btf_id
 static int link_create(union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
@@ -3973,6 +4058,7 @@ static int link_create(union bpf_attr *attr)
 		ret = cgroup_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_TRACING:
+	case BPF_PROG_TYPE_EXT:
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f0697a3619d7..bf8b16721c82 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11205,6 +11205,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
 
@@ -11306,6 +11312,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return ret;
 
 	if (tgt_prog) {
+		prog->aux->tgt_prog_type = tgt_prog->type;
+		prog->aux->tgt_attach_type = tgt_prog->expected_attach_type;
+
 		if (prog->type == BPF_PROG_TYPE_EXT) {
 			env->ops = bpf_verifier_ops[tgt_prog->type];
 			prog->expected_attach_type =
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7dd314176df7..46eaa3024dc3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -239,6 +239,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_TRACE_FREPLACE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -633,6 +634,7 @@ union bpf_attr {
 		__u32		flags;		/* extra flags */
 		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 		__u32		iter_info_len;	/* iter_info length */
+		__u32		target_btf_id;	/* btf_id of target to attach to */
 	} link_create;
 
 	struct { /* struct used by BPF_LINK_UPDATE command */

