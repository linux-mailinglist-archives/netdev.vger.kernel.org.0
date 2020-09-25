Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0326279370
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgIYVZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729619AbgIYVZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZePSMZKdhTWwCjXYF3t1YvSBUgn1mRclK/98VmFbIg=;
        b=dizKwmNLwHxpX7Cn1Jfw5ZHS5K6Nrbq42crFewwGLY9/GPb1NZBOuKeMPOcOsH+TNWT3AA
        PnLxi8MApzhU09CzJrlOLi+W2wp+mQzQIrB6oYu30mqbU/Wa9lG7T+Tp5KCWEzkR66L0BD
        SWc2eViZhr383t2XkEZ6i+nmWLXcXMI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-9tXrwAvqO8O_m00JSuzy4A-1; Fri, 25 Sep 2020 17:25:07 -0400
X-MC-Unique: 9tXrwAvqO8O_m00JSuzy4A-1
Received: by mail-wm1-f72.google.com with SMTP id s24so160897wmh.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dZePSMZKdhTWwCjXYF3t1YvSBUgn1mRclK/98VmFbIg=;
        b=MLk7VcqhG2jJruuOqzftoJD2gd/5fKe3y0HETlXANGn/CLw48UxV8DAic8oyj12POT
         PUefIsOexESPkObLQ1KHIRWEKyzH9hiSa0X5nK1sgoo6D7CCT3bXnmsyGuQJNILxaHWz
         v2oahENoOJG6loE8pz57AiqxUbGXLw0OioABzS6o2DN+AVBI7vrd7TWZiAjMU3cMUq7I
         /7A0A/YkLTa/YFFzgO71AFylhXpqhkgNQ2OncYd7hssWXgM1UqfvV6m90A/pcSxHERg0
         AW/wvfY9Vyl5XUo7OjMu2HhqMof4bgvCL7d4lNHeXv5qats5F++kIA7vZ/bwjBXOeqMa
         jjMg==
X-Gm-Message-State: AOAM531BFix+eEU7DNX1uJJBgquBGjOkANQzsy8DPCYLg5i13IdZjqvM
        xI/kWwuK/ruIkx1KRMS5nQCe00JD4t1Fg97nMclCtLyFPU/nnjUOa4VGmbmKt13maVqGzMSSTsi
        bmOueyoGjn7jazVKf
X-Received: by 2002:a1c:a949:: with SMTP id s70mr513445wme.42.1601069106472;
        Fri, 25 Sep 2020 14:25:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOwJrEyAOfG3eaL+aLHtopFmrhIWk7xYJVwkrFY44DwN8rbHFLl3b645SfPHAUTGmmxxNrPQ==
X-Received: by 2002:a1c:a949:: with SMTP id s70mr513407wme.42.1601069105910;
        Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h204sm289171wmf.35.2020.09.25.14.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DFF84183C5C; Fri, 25 Sep 2020 23:25:04 +0200 (CEST)
Subject: [PATCH bpf-next v9 05/11] bpf: support attaching freplace programs to
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
Date:   Fri, 25 Sep 2020 23:25:04 +0200
Message-ID: <160106910487.27725.11983967672504271627.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h            |    2 +
 include/uapi/linux/bpf.h       |    9 ++-
 kernel/bpf/syscall.c           |  132 +++++++++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c          |   11 +++
 tools/include/uapi/linux/bpf.h |    9 ++-
 5 files changed, 143 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8f80dd3ed5ed..d45cda3ab441 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -753,6 +753,8 @@ struct bpf_prog_aux {
 	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
 	struct bpf_prog *dst_prog;
 	struct bpf_trampoline *dst_trampoline;
+	enum bpf_prog_type saved_dst_prog_type;
+	enum bpf_attach_type saved_dst_attach_type;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..feff1ed49f86 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -632,8 +632,13 @@ union bpf_attr {
 		};
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
-		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
-		__u32		iter_info_len;	/* iter_info length */
+		union {
+			__u32		target_btf_id;	/* btf_id of target to attach to */
+			struct {
+				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
+				__u32		iter_info_len;	/* iter_info length */
+			};
+		};
 	} link_create;
 
 	struct { /* struct used by BPF_LINK_UPDATE command */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 099a651efe8b..743953f6bf21 100644
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
@@ -2554,12 +2555,15 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
 	.fill_link_info = bpf_tracing_link_fill_link_info,
 };
 
-static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+static int bpf_tracing_prog_attach(struct bpf_prog *prog,
+				   int tgt_prog_fd,
+				   u32 btf_id)
 {
 	struct bpf_link_primer link_primer;
 	struct bpf_prog *tgt_prog = NULL;
+	struct bpf_trampoline *tr = NULL;
 	struct bpf_tracing_link *link;
-	struct bpf_trampoline *tr;
+	u64 key = 0;
 	int err;
 
 	switch (prog->type) {
@@ -2588,6 +2592,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
+	if (!!tgt_prog_fd != !!btf_id) {
+		err = -EINVAL;
+		goto out_put_prog;
+	}
+
+	if (tgt_prog_fd) {
+		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
+		if (prog->type != BPF_PROG_TYPE_EXT) {
+			err = -EINVAL;
+			goto out_put_prog;
+		}
+
+		tgt_prog = bpf_prog_get(tgt_prog_fd);
+		if (IS_ERR(tgt_prog)) {
+			err = PTR_ERR(tgt_prog);
+			tgt_prog = NULL;
+			goto out_put_prog;
+		}
+
+		key = bpf_trampoline_compute_key(tgt_prog, btf_id);
+	}
+
 	link = kzalloc(sizeof(*link), GFP_USER);
 	if (!link) {
 		err = -ENOMEM;
@@ -2599,12 +2625,58 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
 	mutex_lock(&prog->aux->dst_mutex);
 
-	if (!prog->aux->dst_trampoline) {
+	/* There are a few possible cases here:
+	 *
+	 * - if prog->aux->dst_trampoline is set, the program was just loaded
+	 *   and not yet attached to anything, so we can use the values stored
+	 *   in prog->aux
+	 *
+	 * - if prog->aux->dst_trampoline is NULL, the program has already been
+         *   attached to a target and its initial target was cleared (below)
+	 *
+	 * - if tgt_prog != NULL, the caller specified tgt_prog_fd +
+	 *   target_btf_id using the link_create API.
+	 *
+	 * - if tgt_prog == NULL when this function was called using the old
+         *   raw_tracepoint_open API, and we need a target from prog->aux
+         *
+         * The combination of no saved target in prog->aux, and no target
+         * specified on load is illegal, and we reject that here.
+	 */
+	if (!prog->aux->dst_trampoline && !tgt_prog) {
 		err = -ENOENT;
 		goto out_unlock;
 	}
-	tr = prog->aux->dst_trampoline;
-	tgt_prog = prog->aux->dst_prog;
+
+	if (!prog->aux->dst_trampoline ||
+	    (key && key != prog->aux->dst_trampoline->key)) {
+		/* If there is no saved target, or the specified target is
+		 * different from the destination specified at load time, we
+		 * need a new trampoline and a check for compatibility
+		 */
+		struct bpf_attach_target_info tgt_info = {};
+
+		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
+					      &tgt_info);
+		if (err)
+			goto out_unlock;
+
+		tr = bpf_trampoline_get(key, &tgt_info);
+		if (!tr) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+	} else {
+		/* The caller didn't specify a target, or the target was the
+		 * same as the destination supplied during program load. This
+		 * means we can reuse the trampoline and reference from program
+		 * load time, and there is no need to allocate a new one. This
+		 * can only happen once for any program, as the saved values in
+		 * prog->aux are cleared below.
+		 */
+		tr = prog->aux->dst_trampoline;
+		tgt_prog = prog->aux->dst_prog;
+	}
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
@@ -2620,15 +2692,31 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	link->tgt_prog = tgt_prog;
 	link->trampoline = tr;
 
+	/* Always clear the trampoline and target prog from prog->aux to make
+	 * sure the original attach destination is not kept alive after a
+	 * program is (re-)attached to another target.
+	 */
+	if (prog->aux->dst_prog &&
+	    (tgt_prog_fd || tr != prog->aux->dst_trampoline))
+		/* got extra prog ref from syscall, or attaching to different prog */
+		bpf_prog_put(prog->aux->dst_prog);
+	if (prog->aux->dst_trampoline && tr != prog->aux->dst_trampoline)
+		/* we allocated a new trampoline, so free the old one */
+		bpf_trampoline_put(prog->aux->dst_trampoline);
+
 	prog->aux->dst_prog = NULL;
 	prog->aux->dst_trampoline = NULL;
 	mutex_unlock(&prog->aux->dst_mutex);
 
 	return bpf_link_settle(&link_primer);
 out_unlock:
+	if (tr && tr != prog->aux->dst_trampoline)
+		bpf_trampoline_put(tr);
 	mutex_unlock(&prog->aux->dst_mutex);
 	kfree(link);
 out_put_prog:
+	if (tgt_prog_fd && tgt_prog)
+		bpf_prog_put(tgt_prog);
 	bpf_prog_put(prog);
 	return err;
 }
@@ -2742,7 +2830,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog, 0, 0);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -3926,10 +4014,15 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
 static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
-	if (attr->link_create.attach_type == BPF_TRACE_ITER &&
-	    prog->expected_attach_type == BPF_TRACE_ITER)
-		return bpf_iter_link_attach(attr, prog);
+	if (attr->link_create.attach_type != prog->expected_attach_type)
+		return -EINVAL;
 
+	if (prog->expected_attach_type == BPF_TRACE_ITER)
+		return bpf_iter_link_attach(attr, prog);
+	else if (prog->type == BPF_PROG_TYPE_EXT)
+		return bpf_tracing_prog_attach(prog,
+					       attr->link_create.target_fd,
+					       attr->link_create.target_btf_id);
 	return -EINVAL;
 }
 
@@ -3943,18 +4036,25 @@ static int link_create(union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_LINK_CREATE))
 		return -EINVAL;
 
-	ptype = attach_type_to_prog_type(attr->link_create.attach_type);
-	if (ptype == BPF_PROG_TYPE_UNSPEC)
-		return -EINVAL;
-
-	prog = bpf_prog_get_type(attr->link_create.prog_fd, ptype);
+	prog = bpf_prog_get(attr->link_create.prog_fd);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
 	ret = bpf_prog_attach_check_attach_type(prog,
 						attr->link_create.attach_type);
 	if (ret)
-		goto err_out;
+		goto out;
+
+	if (prog->type == BPF_PROG_TYPE_EXT) {
+		ret = tracing_bpf_link_attach(attr, prog);
+		goto out;
+	}
+
+	ptype = attach_type_to_prog_type(attr->link_create.attach_type);
+	if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	switch (ptype) {
 	case BPF_PROG_TYPE_CGROUP_SKB:
@@ -3982,7 +4082,7 @@ static int link_create(union bpf_attr *attr)
 		ret = -EINVAL;
 	}
 
-err_out:
+out:
 	if (ret < 0)
 		bpf_prog_put(prog);
 	return ret;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8fe93c84df90..aa1b725706da 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11374,6 +11374,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
 
+		if ((prog->aux->saved_dst_prog_type &&
+		     prog->aux->saved_dst_prog_type != dst_prog->type) ||
+		    (prog->aux->saved_dst_attach_type &&
+		     prog->aux->saved_dst_attach_type != dst_prog->expected_attach_type))
+			return -EINVAL;
+
 		if (dst_prog && conservative)
 			t = NULL;
 
@@ -11482,6 +11488,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	prog->aux->attach_func_proto = tgt_info.tgt_type;
 	prog->aux->attach_func_name = tgt_info.tgt_name;
 
+	if (dst_prog) {
+		prog->aux->saved_dst_prog_type = dst_prog->type;
+		prog->aux->saved_dst_attach_type = dst_prog->expected_attach_type;
+	}
+
 	if (prog->expected_attach_type == BPF_TRACE_RAW_TP) {
 		prog->aux->attach_btf_trace = true;
 		return 0;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..feff1ed49f86 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -632,8 +632,13 @@ union bpf_attr {
 		};
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
-		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
-		__u32		iter_info_len;	/* iter_info length */
+		union {
+			__u32		target_btf_id;	/* btf_id of target to attach to */
+			struct {
+				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
+				__u32		iter_info_len;	/* iter_info length */
+			};
+		};
 	} link_create;
 
 	struct { /* struct used by BPF_LINK_UPDATE command */

