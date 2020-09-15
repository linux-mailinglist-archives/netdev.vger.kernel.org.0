Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0378526B8B7
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgIPAtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:49:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23000 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726405AbgIOLli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600170066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxaNRdqeUWws340/khcAu0DCU4w/nKnErCzUcLE36/I=;
        b=LNhoVuUYWv/VA3dp/yD0teFTpcEgdd8yxol4nUj+RhlROf6fg0jc5WZJDSL1sX0S/MJ2z+
        YalNQIKXd2yu4kYVZLBzOWHz/ow0Q+mnq8ayPsNuK782TemPRYHP3sO9SKJ75aDXZXlXqZ
        Pq9ExfSXZzKbwNEX9E6fqgF12InWJUY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-JwgrKqFvOUeFoQMAiUW_oQ-1; Tue, 15 Sep 2020 07:41:04 -0400
X-MC-Unique: JwgrKqFvOUeFoQMAiUW_oQ-1
Received: by mail-ed1-f71.google.com with SMTP id d13so1118307edz.18
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 04:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gxaNRdqeUWws340/khcAu0DCU4w/nKnErCzUcLE36/I=;
        b=dQaeAZSWMDjC6s0Urm0T9RlvBsSXskbcbYgou91OiHtDSr5Hzy+fxYVDpBCebB3ZGP
         +omlyJvTh6H/HbQLmwd8KL2wzrka8+Nb6GyzcjEBYNPLsqU4/I/yzjOVVzfuZsANxAXp
         gGzeAR72lteKc7G7ZubdLvqVCWcTmgMnmxmdmLeZq0nRc/3TY9yfPhCQThuirnxVDPYs
         d8ZqLxwZqYRaHR3tRH8XV2HsYql28PMJTE7KxCnIC2lZigcRTTa+JbI3WdjM1+l3VGqO
         gte8A+6olOe6OPF59XCWrTdNWdvI3Mc5fwCWlpxBbbwFMulbnvgM6+V99j2ulC+bF6vd
         Nw4A==
X-Gm-Message-State: AOAM532dLk3stC1eucQ365pyON9Y5lbtux6fUg++L+f3KEq2lrOQnCch
        3+MVj+WHdpymlzv8WRsxA6YByoUEizcV8liNB/qCnmuza+FLxcPFPfw/NwrO+gAWqtLCPIKJINC
        lzsG0o0DZUYGeQo16
X-Received: by 2002:aa7:d959:: with SMTP id l25mr21467320eds.383.1600170063322;
        Tue, 15 Sep 2020 04:41:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKzrIT6b9hQT1r0dnnnse74w6mbb51/BN2sV/26Ssr4//+vYJkwpGC2YJsY1+OWcjI9hVrzw==
X-Received: by 2002:aa7:d959:: with SMTP id l25mr21467277eds.383.1600170062655;
        Tue, 15 Sep 2020 04:41:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id nm7sm10051208ejb.70.2020.09.15.04.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 04:41:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6617A1829CB; Tue, 15 Sep 2020 13:41:01 +0200 (CEST)
Subject: [PATCH bpf-next v5 4/8] bpf: support attaching freplace programs to
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
Date:   Tue, 15 Sep 2020 13:41:01 +0200
Message-ID: <160017006133.98230.8867570651560085505.stgit@toke.dk>
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
 include/linux/bpf.h            |    2 +
 include/uapi/linux/bpf.h       |    2 +
 kernel/bpf/syscall.c           |   92 ++++++++++++++++++++++++++++++++++------
 kernel/bpf/verifier.c          |    9 ++++
 tools/include/uapi/linux/bpf.h |    2 +
 5 files changed, 94 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 939b37c78d55..360e8291e6bb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -743,6 +743,8 @@ struct bpf_prog_aux {
 	struct mutex tgt_mutex; /* protects writing of tgt_* pointers below */
 	struct bpf_prog *tgt_prog;
 	struct bpf_trampoline *tgt_trampoline;
+	enum bpf_prog_type tgt_prog_type;
+	enum bpf_attach_type tgt_attach_type;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
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
index fc2bca2d9f05..429afa820c6f 100644
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
@@ -2555,12 +2556,18 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 	.fill_link_info = bpf_tracing_link_fill_link_info,
 };
 
-static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+static int bpf_tracing_prog_attach(struct bpf_prog *prog,
+				   int tgt_prog_fd,
+				   u32 btf_id)
 {
 	struct bpf_link_primer link_primer;
 	struct bpf_prog *tgt_prog = NULL;
 	struct bpf_tracing_link *link;
+	struct btf_func_model fmodel;
+	bool new_trampoline = false;
 	struct bpf_trampoline *tr;
+	long addr;
+	u64 key;
 	int err;
 
 	switch (prog->type) {
@@ -2588,6 +2595,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
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
 
 	link = kzalloc(sizeof(*link), GFP_USER);
 	if (!link) {
@@ -2600,33 +2625,65 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
 	mutex_lock(&prog->aux->tgt_mutex);
 
-	if (!prog->aux->tgt_trampoline) {
-		err = -ENOENT;
-		goto out_unlock;
+	if (!prog->aux->tgt_trampoline ||
+	    (tgt_prog && prog->aux->tgt_trampoline->key != key)) {
+		new_trampoline = true;
+	} else {
+		if (tgt_prog) {
+			/* re-using ref to tgt_prog, don't take another */
+			bpf_prog_put(tgt_prog);
+		}
+		tr = prog->aux->tgt_trampoline;
+		tgt_prog = prog->aux->tgt_prog;
+	}
+
+	if (new_trampoline) {
+		if (!tgt_prog) {
+			err = -ENOENT;
+			goto out_unlock;
+		}
+
+		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
+					      &fmodel, &addr, NULL, NULL);
+		if (err) {
+			bpf_prog_put(tgt_prog);
+			goto out_unlock;
+		}
+
+		tr = bpf_trampoline_get(key, (void *)addr, &fmodel);
+		if (IS_ERR(tr)) {
+			err = PTR_ERR(tr);
+			bpf_prog_put(tgt_prog);
+			goto out_unlock;
+		}
 	}
-	tr = prog->aux->tgt_trampoline;
-	tgt_prog = prog->aux->tgt_prog;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
-		goto out_unlock;
+		goto out_put_tgt;
 	}
 
 	err = bpf_trampoline_link_prog(prog, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
-		goto out_unlock;
+		goto out_put_tgt;
 	}
 
 	link->tgt_prog = tgt_prog;
 	link->trampoline = tr;
-
-	prog->aux->tgt_prog = NULL;
-	prog->aux->tgt_trampoline = NULL;
+	if (!new_trampoline) {
+		prog->aux->tgt_trampoline = NULL;
+		prog->aux->tgt_prog = NULL;
+	}
 	mutex_unlock(&prog->aux->tgt_mutex);
 
 	return bpf_link_settle(&link_primer);
+out_put_tgt:
+	if (new_trampoline) {
+		bpf_prog_put(tgt_prog);
+		bpf_trampoline_put(tr);
+	}
 out_unlock:
 	mutex_unlock(&prog->aux->tgt_mutex);
 	kfree(link);
@@ -2744,7 +2801,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog, 0, 0);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -2864,6 +2921,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_TRACE_FREPLACE:
+		return BPF_PROG_TYPE_EXT;
 	case BPF_TRACE_ITER:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
@@ -3924,10 +3983,16 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
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
@@ -3961,6 +4026,7 @@ static int link_create(union bpf_attr *attr)
 		ret = cgroup_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_TRACING:
+	case BPF_PROG_TYPE_EXT:
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 02f704367014..2dd5e2ad7f31 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11202,6 +11202,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
 
@@ -11300,6 +11306,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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

