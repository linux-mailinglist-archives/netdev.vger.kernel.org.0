Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43B270DBA
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgISLt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:49:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbgISLt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600516193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6fUFZaIDwQCSqJNePVbsmAMHox46PgemVqJ3Y5xqnUc=;
        b=begh8CfGNYGRlkWG2/LwbQx3bf3YQve4h1XqyQ6z1I8jq9Idrr0lCshIcJBmMESK2KMuVt
        FFGqC0VKosORxU5M8s7Hpf2bRMw+gdCYlh4WKqzFJM7BFl1/NYUCLlb9DCHFVnruT5gOZB
        mAs8H2wfgeaWBOAeEa8tk0la5U3xiu0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-wtbq76B-MA-YlwX3MB1l1w-1; Sat, 19 Sep 2020 07:49:51 -0400
X-MC-Unique: wtbq76B-MA-YlwX3MB1l1w-1
Received: by mail-ej1-f72.google.com with SMTP id hh10so3135606ejb.13
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 04:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6fUFZaIDwQCSqJNePVbsmAMHox46PgemVqJ3Y5xqnUc=;
        b=oWIYRM+AxqyMbe1nvLxaZg9W03J1tYEDqTTZi3DL5EEnA4VRHoFuLvnnw+3sd3s6a5
         ec7Q48RpgtECeZoAnbLijB8sOhKwZ8TZLHWyEgCfHLt6SqyGggW/IpP7ojaJIdk9OSb1
         aN9/0GUapRCZ2JUkLjEc5PeapWnDiLpOoUR4tDgca9wtyDPHNe+lx7SpC1WMfcT0Zf/z
         unJoGY1UkAm5k11efV0chauocDx8oyWR25RF33emjrv7uoCXp1Y2yM1ZtoBvAjL57AXY
         Hcw8xklVJpa3iPC40twI4HRs7ng3q07G9bzhSKo6xgpHKR21qz1U6SdQ4Ga3kiWgAo1L
         Q6Ew==
X-Gm-Message-State: AOAM533C8efzSRmZummuec1t4tcWbInGwK/+7iZqAONNCO3psbpYNrZ0
        Ci1LKwGCxWQl2+HT03i3zGe9uhdCQGIzm/xJcs16HPmIo6TWZ/AlEq9amEBmfqWiCK54zvzUpI1
        rjXvzeZuYIdqCEqqd
X-Received: by 2002:aa7:d04d:: with SMTP id n13mr44749773edo.354.1600516189968;
        Sat, 19 Sep 2020 04:49:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNdrRvgLDRmTbuA0d40rl7isdLNOALbDEEc8SrQu6WemCdJhi/ekWR00MlPHZQrpjyj0axPw==
X-Received: by 2002:aa7:d04d:: with SMTP id n13mr44749748edo.354.1600516189589;
        Sat, 19 Sep 2020 04:49:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g10sm4316510ejp.34.2020.09.19.04.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 04:49:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8CF74183A94; Sat, 19 Sep 2020 13:49:48 +0200 (CEST)
Subject: [PATCH bpf-next v7 05/10] bpf: support attaching freplace programs to
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
Date:   Sat, 19 Sep 2020 13:49:48 +0200
Message-ID: <160051618846.58048.6000955286403207701.stgit@toke.dk>
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
 include/uapi/linux/bpf.h       |    9 +++-
 kernel/bpf/syscall.c           |  102 +++++++++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c          |    9 ++++
 tools/include/uapi/linux/bpf.h |    9 +++-
 5 files changed, 108 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7aabea7fab31..9829524af0f7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -746,6 +746,8 @@ struct bpf_prog_aux {
 	struct mutex tgt_mutex; /* protects writing of tgt_* pointers below */
 	struct bpf_prog *tgt_prog;
 	struct bpf_trampoline *tgt_trampoline;
+	enum bpf_prog_type tgt_prog_type;
+	enum bpf_attach_type tgt_attach_type;
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
index 4af35a59d0d9..bbb61ac9c826 100644
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
@@ -2555,12 +2556,17 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
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
+	struct btf_func_model fmodel;
+	u64 key = 0;
+	long addr;
 	int err;
 
 	switch (prog->type) {
@@ -2589,6 +2595,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
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
+		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
+	}
+
 	link = kzalloc(sizeof(*link), GFP_USER);
 	if (!link) {
 		err = -ENOMEM;
@@ -2600,12 +2628,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
 	mutex_lock(&prog->aux->tgt_mutex);
 
-	if (!prog->aux->tgt_trampoline) {
+	if (!prog->aux->tgt_trampoline && !tgt_prog) {
 		err = -ENOENT;
 		goto out_unlock;
 	}
-	tr = prog->aux->tgt_trampoline;
-	tgt_prog = prog->aux->tgt_prog;
+
+	if (!prog->aux->tgt_trampoline ||
+	    (key && key != prog->aux->tgt_trampoline->key)) {
+
+		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
+					      &fmodel, &addr, NULL, NULL);
+		if (err)
+			goto out_unlock;
+
+		tr = bpf_trampoline_get(key, (void *)addr, &fmodel);
+		if (!tr) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+	} else {
+		tr = prog->aux->tgt_trampoline;
+		tgt_prog = prog->aux->tgt_prog;
+	}
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
@@ -2620,16 +2664,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
 	link->tgt_prog = tgt_prog;
 	link->trampoline = tr;
-
-	prog->aux->tgt_prog = NULL;
-	prog->aux->tgt_trampoline = NULL;
+	if (tr == prog->aux->tgt_trampoline) {
+		/* if we got a new ref from syscall, drop existing one from prog */
+		if (tgt_prog_fd)
+			bpf_prog_put(prog->aux->tgt_prog);
+		prog->aux->tgt_trampoline = NULL;
+		prog->aux->tgt_prog = NULL;
+	}
 	mutex_unlock(&prog->aux->tgt_mutex);
 
 	return bpf_link_settle(&link_primer);
 out_unlock:
+	if (tr && tr != prog->aux->tgt_trampoline)
+		bpf_trampoline_put(tr);
 	mutex_unlock(&prog->aux->tgt_mutex);
 	kfree(link);
 out_put_prog:
+	if (tgt_prog_fd && tgt_prog)
+		bpf_prog_put(tgt_prog);
 	bpf_prog_put(prog);
 	return err;
 }
@@ -2743,7 +2795,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog, 0, 0);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -3927,10 +3979,15 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
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
 
@@ -3944,18 +4001,25 @@ static int link_create(union bpf_attr *attr)
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
@@ -3983,7 +4047,7 @@ static int link_create(union bpf_attr *attr)
 		ret = -EINVAL;
 	}
 
-err_out:
+out:
 	if (ret < 0)
 		bpf_prog_put(prog);
 	return ret;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7a53736e67b4..39a549103407 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11349,6 +11349,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
 
@@ -11447,6 +11453,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return ret;
 
 	if (tgt_prog) {
+		prog->aux->tgt_prog_type = tgt_prog->type;
+		prog->aux->tgt_attach_type = tgt_prog->expected_attach_type;
+
 		if (prog->type == BPF_PROG_TYPE_EXT) {
 			env->ops = bpf_verifier_ops[tgt_prog->type];
 			prog->expected_attach_type =
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

