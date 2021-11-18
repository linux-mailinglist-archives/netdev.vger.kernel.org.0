Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F179A455A55
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbhKRLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343894AbhKRLaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bifxS4z5leMtv9W8fU/+OTbvzsJd1lcEkpE8E9OLG6I=;
        b=OAIZf4x/yaPDg+mMZgRWjAtxv/ADg5YGlbjOrUiieGZRayzMMyCvkOC6JJR9Gfm09mbkJj
        /3Gq5HRMy7gGFivX/Ou1pIDqGNFYFb/H8e7YtgImzP2MdxHd4NtfoeN7hqDbvmYI/rWjpl
        4IWfFN8itOfEgJXDzxXNpeKD5myw3xc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-hpS6kK2JPXaPk37fC68Tfw-1; Thu, 18 Nov 2021 06:27:10 -0500
X-MC-Unique: hpS6kK2JPXaPk37fC68Tfw-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003e29de5badbso4965072edd.18
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bifxS4z5leMtv9W8fU/+OTbvzsJd1lcEkpE8E9OLG6I=;
        b=HoFtOwGQZPB/Wy8WJ2zUFMFTifLKb3JwOdPFs0tQE6rxxYqvnObfxSfJdxU8fQKfeW
         1QmR6+WhwYdNXJeGaAafL0fdy2IVxveV88NneQPaf5alQ64VxRr66+VQWYEpKEr6wdux
         BrseuJODrkjhatCVXagkdpAQ8kzo+AlYB5bfEYd8LrxxFLG4UwPpkApCBy8jMTRhz371
         CS0N5sSe2zEWTyXfzS0obAQDlOO+VknKuARyRh3G7Cjls0bZPFu5QSZ3sjT+MONiBDV4
         AcpX+dlLT3N2HG5ZsIc1/ZfAsjjzmi39AGdAXUCYYgWEgkEWM6XOT15BTDr2iOmTOgTP
         LHDQ==
X-Gm-Message-State: AOAM532j45GigTTq+uMFTLgHtuvV/GWoDfvbvMbZrRGpMx+V/YznFuxO
        Rmz0ueXV36uJoaMPfpNYl6ONwZvgc3O+kp9VmcwgQBOK7YrmIHH6338Lbz0O5oJ09ls/OV9l5wL
        92NRk7JaFG0c4VvqW
X-Received: by 2002:a17:907:972a:: with SMTP id jg42mr33022580ejc.398.1637234829295;
        Thu, 18 Nov 2021 03:27:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXNac21cC6ptXLwE8vb976WG6H1rW4zE4vFEKA+xATsZW9m+DG21K1kz5v58zfN/C4PnINUw==
X-Received: by 2002:a17:907:972a:: with SMTP id jg42mr33022545ejc.398.1637234829081;
        Thu, 18 Nov 2021 03:27:09 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id bd12sm1464972edb.11.2021.11.18.03.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:27:08 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 22/29] libbpf: Add support to link multi func tracing program
Date:   Thu, 18 Nov 2021 12:24:48 +0100
Message-Id: <20211118112455.475349-23-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to link multi func tracing program
through link_create interface.

Adding special types for multi func programs:

  fentry.multi
  fexit.multi

so you can define multi func programs like:

  SEC("fentry.multi/bpf_fentry_test*")
  int BPF_PROG(test1, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)

that defines test1 to be attached to bpf_fentry_test* functions.
The test1 program is loaded with BPF_F_MULTI_FUNC flag.

If functions are not specified the program needs to be attached
manually.

Adding new btf_ids/btf_ids_cnt fields to bpf_link_create_opts,
that define functions to attach the program to.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c    |  7 +++++
 tools/lib/bpf/bpf.h    |  6 +++-
 tools/lib/bpf/libbpf.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 94560ba31724..86a95419e501 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -784,6 +784,13 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
+		attr.link_create.multi.btf_ids = (__u64) OPTS_GET(opts, multi.btf_ids, 0);
+		attr.link_create.multi.btf_ids_cnt = OPTS_GET(opts, multi.btf_ids_cnt, 0);
+		if (!OPTS_ZEROED(opts, multi))
+			return libbpf_err(-EINVAL);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 079cc81ac51e..e55abf3528b3 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -249,10 +249,14 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			__u32 *btf_ids;
+			__u32  btf_ids_cnt;
+		} multi;
 	};
 	size_t :0;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field multi
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index de7e09a6b5ec..4c11d38b1f92 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -246,6 +246,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program type allows multiple functions attachment */
+	SEC_MULTI_FUNC = 32,
 };
 
 struct bpf_sec_def {
@@ -6723,6 +6725,9 @@ static int bpf_object_init_progs(struct bpf_object *obj, const struct bpf_object
 			continue;
 		}
 
+		if (prog->sec_def->cookie & SEC_MULTI_FUNC)
+			prog->prog_flags |= BPF_F_MULTI_FUNC;
+
 		bpf_program__set_type(prog, prog->sec_def->prog_type);
 		bpf_program__set_expected_attach_type(prog, prog->sec_def->expected_attach_type);
 
@@ -8318,6 +8323,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cooki
 static struct bpf_link *attach_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie);
+static struct bpf_link *attach_trace_multi(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_lsm(const struct bpf_program *prog, long cookie);
 static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie);
 
@@ -8345,6 +8351,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("fentry.s/",		TRACING, BPF_TRACE_FENTRY, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
 	SEC_DEF("fmod_ret.s/",		TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
 	SEC_DEF("fexit.s/",		TRACING, BPF_TRACE_FEXIT, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_trace),
+	SEC_DEF("fentry.multi/",	TRACING, BPF_TRACE_FENTRY, SEC_MULTI_FUNC, attach_trace_multi),
+	SEC_DEF("fexit.multi/",		TRACING, BPF_TRACE_FEXIT, SEC_MULTI_FUNC, attach_trace_multi),
 	SEC_DEF("freplace/",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("lsm/",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
@@ -8797,6 +8805,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, const char *attac
 	__u32 attach_prog_fd = prog->attach_prog_fd;
 	int err = 0;
 
+	if (prog->prog_flags & BPF_F_MULTI_FUNC)
+		return 0;
+
 	/* BPF program's BTF ID */
 	if (attach_prog_fd) {
 		err = libbpf_find_prog_btf_id(attach_name, attach_prog_fd);
@@ -10216,6 +10227,61 @@ static struct bpf_link *bpf_program__attach_btf_id(const struct bpf_program *pro
 	return (struct bpf_link *)link;
 }
 
+static struct bpf_link *bpf_program__attach_multi(const struct bpf_program *prog)
+{
+	char *pattern = prog->sec_name + strlen(prog->sec_def->sec);
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	enum bpf_attach_type attach_type;
+	int prog_fd, link_fd, cnt, err;
+	struct bpf_link *link = NULL;
+	__u32 *ids = NULL;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = bpf_object__load_vmlinux_btf(prog->obj, true);
+	if (err)
+		return ERR_PTR(err);
+
+	cnt = btf__find_by_glob_kind(prog->obj->btf_vmlinux, BTF_KIND_FUNC,
+				     pattern, NULL, &ids);
+	if (cnt <= 0)
+		return ERR_PTR(-EINVAL);
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	opts.multi.btf_ids = ids;
+	opts.multi.btf_ids_cnt = cnt;
+
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
+	if (link_fd < 0) {
+		err = -errno;
+		goto out_err;
+	}
+	link->fd = link_fd;
+	free(ids);
+	return link;
+
+out_err:
+	free(link);
+	free(ids);
+	return ERR_PTR(err);
+}
+
+static struct bpf_link *attach_trace_multi(const struct bpf_program *prog, long cookie)
+{
+	return bpf_program__attach_multi(prog);
+}
+
 struct bpf_link *bpf_program__attach_trace(const struct bpf_program *prog)
 {
 	return bpf_program__attach_btf_id(prog);
-- 
2.31.1

