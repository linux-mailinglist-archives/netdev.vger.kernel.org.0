Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE672653AD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgIJVjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:39:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23502 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730552AbgIJNKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599743398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7rEQuoKvsQuQ7UN/WAG0AyU9Tep54WX3TlbS6iNeoLI=;
        b=Dqtfs4qKGpTOeacb1+Dkv31JsNlA27Q76wO+MR2FjB/Gf73BcFRQzQhErQ9m29fiNQv5HW
        4SYirArswx0jWQGU5BcXzkOVZ/BUXmtvbfX7+9808uLzbfa8CCtZuuQf+gAZljUNXDEmi3
        Nc3PcqXX84FMHqhylWuU0lAT/3Oijcw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-xErPQzzlNQCgzJ0XdgJT1A-1; Thu, 10 Sep 2020 09:09:56 -0400
X-MC-Unique: xErPQzzlNQCgzJ0XdgJT1A-1
Received: by mail-wm1-f71.google.com with SMTP id b73so227wmb.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 06:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7rEQuoKvsQuQ7UN/WAG0AyU9Tep54WX3TlbS6iNeoLI=;
        b=h/UD1vgninCcxam0IdQ/6sALFt+/nUPIcTpMtlyUjOJsrSoV1IdLnCKHvaGtsGaVvZ
         V7KHwgAwBwMcE4jnGJ1kU5kmi9yBOSJ1NezJbHUd3R4Z2uV6ZVISeJuMhiv9CbEVc7A1
         9QGbaM2Osr5mQSzcrGP7DmFiu5vNjQryszJAV6zP/LRufwjEtHg/4pwLN5ItAjq+SKRQ
         NA1dnBcbt4GLzS5jc0pIjbywLUaAVFI1wvh8ypTFJRnD4bl1HQrrbgYm0LlJ0KpMDxX5
         /02bwtzCrbdI5gnCA4eACe4NGQ9Z+D2Zp4Oi+ZP6WQF5q6PYmL8QELiZKXhawe0jQTYV
         iMag==
X-Gm-Message-State: AOAM532HT6qopanvIFLiFb3ZwG0fNAPhChKJuw6FBt7EYySZrdFlXhhD
        QUDjSifIA5aWtKl/fhI97++T0W0ffuHLBTZuN+uIh+stCqmhgxaA8SIxXPWIVLQEH8MPLR0Jut0
        ETTBlEN6TAEZy7Nv1
X-Received: by 2002:a1c:2003:: with SMTP id g3mr7937725wmg.99.1599743395137;
        Thu, 10 Sep 2020 06:09:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCQ/VDSUcVQ55C8b8uBmq9D1lbGhszNIiR38Iee5GygDxrn6zCB5U83bXcbJZ84LZmG8qx/A==
X-Received: by 2002:a1c:2003:: with SMTP id g3mr7937694wmg.99.1599743394843;
        Thu, 10 Sep 2020 06:09:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k12sm8903173wrn.39.2020.09.10.06.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 06:09:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E672D1829D4; Thu, 10 Sep 2020 15:09:53 +0200 (CEST)
Subject: [PATCH bpf-next v3 4/9] bpf: support attaching freplace programs to
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
Date:   Thu, 10 Sep 2020 15:09:53 +0200
Message-ID: <159974339386.129227.3474557539203649741.stgit@toke.dk>
In-Reply-To: <159974338947.129227.5610774877906475683.stgit@toke.dk>
References: <159974338947.129227.5610774877906475683.stgit@toke.dk>
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

The implementation reuses the checks that were factored out of
check_attach_btf_id() to ensure compatibility between the BTF types of the
old and new attachment. If these match, a new bpf_tracing_link will be
created for the new attach target, allowing multiple attachments to
co-exist simultaneously.

The code could theoretically support multiple-attach of other types of
tracing programs as well, but since I don't have a use case for any of
those, the bpf_tracing_prog_attach() function will reject new targets for
anything other than PROG_TYPE_EXT programs.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h      |    3 +
 include/uapi/linux/bpf.h |    6 ++-
 kernel/bpf/syscall.c     |   96 +++++++++++++++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c    |    9 ++++
 4 files changed, 97 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 722c60f1c1fc..c6b856b2d296 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -753,6 +753,9 @@ struct bpf_prog_aux {
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
index 90359cab501d..0885ab6ac8d9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -595,8 +595,10 @@ union bpf_attr {
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-		__u64 name;
-		__u32 prog_fd;
+		__u64		name;
+		__u32		prog_fd;
+		__u32		tgt_prog_fd;
+		__u32		tgt_btf_id;
 	} raw_tracepoint;
 
 	struct { /* anonymous struct for BPF_BTF_LOAD */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2d238aa8962e..7b1da5f063eb 100644
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
@@ -2582,10 +2583,16 @@ static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog *prog,
 	return link;
 }
 
-static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+static int bpf_tracing_prog_attach(struct bpf_prog *prog,
+				   int tgt_prog_fd,
+				   u32 btf_id)
 {
-	struct bpf_tracing_link *link, *olink;
 	struct bpf_link_primer link_primer;
+	struct bpf_prog *tgt_prog = NULL;
+	struct bpf_tracing_link *link;
+	struct btf_func_model fmodel;
+	long addr;
+	u64 key;
 	int err;
 
 	switch (prog->type) {
@@ -2613,28 +2620,80 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		err = -EINVAL;
 		goto out_put_prog;
 	}
+	if (tgt_prog_fd) {
+		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
+		if (prog->type != BPF_PROG_TYPE_EXT ||
+		    !btf_id) {
+			err = -EINVAL;
+			goto out_put_prog;
+		}
 
-	link = READ_ONCE(prog->aux->tgt_link);
-	if (!link) {
-		err = -ENOENT;
+		tgt_prog = bpf_prog_get(tgt_prog_fd);
+		if (IS_ERR(tgt_prog)) {
+			err = PTR_ERR(tgt_prog);
+			tgt_prog = NULL;
+			goto out_put_prog;
+		}
+
+		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
+	} else if (btf_id) {
+		err = -EINVAL;
 		goto out_put_prog;
 	}
-	olink = cmpxchg(&prog->aux->tgt_link, link, NULL);
-	if (olink != link) {
-		err = -ENOENT;
-		goto out_put_prog;
+
+	link = READ_ONCE(prog->aux->tgt_link);
+	if (link) {
+		if (tgt_prog && link->trampoline->key != key) {
+			link = NULL;
+		} else {
+			struct bpf_tracing_link *olink;
+
+			olink = cmpxchg(&prog->aux->tgt_link, link, NULL);
+			if (olink != link) {
+				link = NULL;
+			} else if (tgt_prog) {
+				/* re-using link that already has ref on
+				 * tgt_prog, don't take another
+				 */
+				bpf_prog_put(tgt_prog);
+				tgt_prog = NULL;
+			}
+		}
+	}
+
+	if (!link) {
+		if (!tgt_prog) {
+			err = -ENOENT;
+			goto out_put_prog;
+		}
+
+		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
+					      &fmodel, &addr, NULL, NULL);
+		if (err)
+			goto out_put_prog;
+
+		link = bpf_tracing_link_create(prog, tgt_prog);
+		if (IS_ERR(link)) {
+			err = PTR_ERR(link);
+			goto out_put_prog;
+		}
+		tgt_prog = NULL;
+
+		err = bpf_trampoline_get(key, (void *)addr, &fmodel, &link->trampoline);
+		if (err)
+			goto out_put_link;
 	}
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
 		kfree(link);
-		goto out_put_prog;
+		goto out_put_link;
 	}
 
 	err = bpf_trampoline_link_prog(prog, link->trampoline);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
-		goto out_put_prog;
+		goto out_put_link;
 	}
 
 	/* at this point the link is no longer referenced from struct bpf_prog,
@@ -2643,8 +2702,12 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	link->link.prog = prog;
 
 	return bpf_link_settle(&link_primer);
+out_put_link:
+	bpf_link_put(&link->link);
 out_put_prog:
 	bpf_prog_put(prog);
+	if (tgt_prog)
+		bpf_prog_put(tgt_prog);
 	return err;
 }
 
@@ -2722,7 +2785,7 @@ static const struct bpf_link_ops bpf_raw_tp_link_lops = {
 	.fill_link_info = bpf_raw_tp_link_fill_link_info,
 };
 
-#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
+#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.tgt_btf_id
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
@@ -2746,8 +2809,9 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
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
@@ -2757,7 +2821,9 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog);
+		return bpf_tracing_prog_attach(prog,
+					       attr->raw_tracepoint.tgt_prog_fd,
+					       attr->raw_tracepoint.tgt_btf_id);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d6714c24c4e7..df01e71b118d 100644
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
 
@@ -11300,6 +11306,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return ret;
 
 	if (tgt_prog) {
+		prog->aux->tgt_prog_type = tgt_prog->type;
+		prog->aux->tgt_attach_type = tgt_prog->expected_attach_type;
+
 		if (prog->type == BPF_PROG_TYPE_EXT) {
 			env->ops = bpf_verifier_ops[tgt_prog->type];
 			prog->expected_attach_type =

