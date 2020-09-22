Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987B027484C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgIVSiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30463 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgIVSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWkCtc9TNxoTLJRN95UnCkNAJbGgVao69Y9w+0OUO2c=;
        b=YKwAsdMlXhxPwIxFgGPVSrx+YHL4sFkli/d57mlE4EPNa0GVkuQMVCX0U1lmw3pJyiGBEF
        AVVDg+zsGUEqw/stRTsj8USQBRpJh72677CNkwxRTVm131rKHbxIOayrNK3IdQ4IIEPMNB
        MbQTWzPHwqIcVug4ga1ESuBZv2GYlNA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-z3jFXuVNOSesIuxnMjZ9dw-1; Tue, 22 Sep 2020 14:38:47 -0400
X-MC-Unique: z3jFXuVNOSesIuxnMjZ9dw-1
Received: by mail-pj1-f70.google.com with SMTP id e4so2808031pjd.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IWkCtc9TNxoTLJRN95UnCkNAJbGgVao69Y9w+0OUO2c=;
        b=oAo2+YIWIyBY98KhzPcc0VOIug4MYMaFmTfqmitrp26uThIDZ/5edvqUsVQjV3KhR1
         /E5hKVG63UWzgHK9rcYS+wFyoPZUp9BRcqx7MiDT87TI7UxrkLKmcL9GVTwlDnX4rq4/
         f76ucXGYS7aUC15P6mGizSPlM7CqRjWFeB3j3gFEkuedNWQTAkQAb4+blgWdpA7sVcE2
         NYvs2YI+XBVYd/ew1JtKPTSHAfYp4Ss8zozmhbUXt2yoAeVk7AE6hm1cMaMtgIZu7PBu
         AWtt5T8oNvXRgXwWxZlZ4m4b0jro2gdXTrgcrniw5rpCVp0GWZTaSVfTiydtkZ9Ny9X9
         OByQ==
X-Gm-Message-State: AOAM530BMKKgtZvtNBF7yGyCoOcePaDE7nnH5bMWVonNwJydrpSmbBHY
        ChwxeKi6tKtLJiCJ38KKrYCwMhd9TSXiww2NGicACZ/Qs0DN2rUA7I3XN7PSdnCiWeUxuVJ63FP
        +KqkJX878YTr1Syjy
X-Received: by 2002:aa7:9ab0:0:b029:13c:1611:66bb with SMTP id x16-20020aa79ab00000b029013c161166bbmr5314006pfi.6.1600799925583;
        Tue, 22 Sep 2020 11:38:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsxYv2uVulLSs6stlOkR3TRfKIAWRoYuz6zsXAScEa9h/NlAZyLEQKgcAFiwCHQzZuvrhPHg==
X-Received: by 2002:aa7:9ab0:0:b029:13c:1611:66bb with SMTP id x16-20020aa79ab00000b029013c161166bbmr5313977pfi.6.1600799925153;
        Tue, 22 Sep 2020 11:38:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b203sm15412418pfb.205.2020.09.22.11.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 36359183A97; Tue, 22 Sep 2020 20:38:39 +0200 (CEST)
Subject: [PATCH bpf-next v8 05/11] bpf: support attaching freplace programs to
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
Date:   Tue, 22 Sep 2020 20:38:39 +0200
Message-ID: <160079991915.8301.7262542368795622735.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
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
 include/uapi/linux/bpf.h       |    9 +++-
 kernel/bpf/syscall.c           |  102 +++++++++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c          |    9 ++++
 tools/include/uapi/linux/bpf.h |    9 +++-
 5 files changed, 108 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f0fc110ac0fb..dfbab195a166 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -751,6 +751,8 @@ struct bpf_prog_aux {
 	struct mutex tgt_mutex; /* protects tgt_* pointers below, *after* prog becomes visible */
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
index a2db33f4753e..5671a99f1350 100644
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
@@ -2549,12 +2550,17 @@ static const struct bpf_link_ops bpf_tracing_link_lops = {
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
@@ -2583,6 +2589,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
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
@@ -2594,12 +2622,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
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
@@ -2614,16 +2658,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 
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
@@ -2737,7 +2789,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog, 0, 0);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
@@ -3921,10 +3973,15 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
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
 
@@ -3938,18 +3995,25 @@ static int link_create(union bpf_attr *attr)
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
@@ -3977,7 +4041,7 @@ static int link_create(union bpf_attr *attr)
 		ret = -EINVAL;
 	}
 
-err_out:
+out:
 	if (ret < 0)
 		bpf_prog_put(prog);
 	return ret;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 647fac170f19..cd67bae4a05e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11379,6 +11379,12 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
 
@@ -11481,6 +11487,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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

