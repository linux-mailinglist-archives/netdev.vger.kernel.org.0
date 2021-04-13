Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2427235DE7A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhDMMQ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:28 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:22855 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344217AbhDMMQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-KGhuL3XPMLKUv4IYbETgew-1; Tue, 13 Apr 2021 08:15:51 -0400
X-MC-Unique: KGhuL3XPMLKUv4IYbETgew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81CE483DE6B;
        Tue, 13 Apr 2021 12:15:38 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C30F10023B0;
        Tue, 13 Apr 2021 12:15:34 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCHv2 RFC bpf-next 5/7] libbpf: Add support to load and attach ftrace probe
Date:   Tue, 13 Apr 2021 14:15:14 +0200
Message-Id: <20210413121516.1467989-6-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to load and attach ftrace probe.

Adding new section type 'fentry.ftrace', that identifies
ftrace probe and assigns BPF_TRACE_FTRACE_ENTRY to prog's
expected_attach_type.

The attach function creates bpf_functions object and
makes an ftrace link with the program.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c      | 12 +++++++
 tools/lib/bpf/bpf.h      |  5 ++-
 tools/lib/bpf/libbpf.c   | 74 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index bba48ff4c5c0..b3195ac3e32e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -643,6 +643,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.target_fd = target_fd;
 	attr.link_create.attach_type = attach_type;
 	attr.link_create.flags = OPTS_GET(opts, flags, 0);
+	attr.link_create.funcs_fd = OPTS_GET(opts, funcs_fd, 0);
 
 	if (iter_info_len) {
 		attr.link_create.iter_info =
@@ -971,3 +972,14 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
 
 	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
 }
+
+int bpf_functions_add(int fd, int btf_id)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.functions_add.fd = fd;
+	attr.functions_add.btf_id = btf_id;
+
+	return sys_bpf(BPF_FUNCTIONS_ADD, &attr, sizeof(attr));
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 875dde20d56e..f677fe06262b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -175,8 +175,9 @@ struct bpf_link_create_opts {
 	union bpf_iter_link_info *iter_info;
 	__u32 iter_info_len;
 	__u32 target_btf_id;
+	__u32 funcs_fd;
 };
-#define bpf_link_create_opts__last_field target_btf_id
+#define bpf_link_create_opts__last_field funcs_fd
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
@@ -278,6 +279,8 @@ struct bpf_test_run_opts {
 LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
 				      struct bpf_test_run_opts *opts);
 
+LIBBPF_API int bpf_functions_add(int fd, int btf_id);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ed5586cce227..b3cb43990524 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8838,6 +8838,10 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_ITER,
 		.is_attach_btf = true,
 		.attach_fn = attach_iter),
+	SEC_DEF("fentry.ftrace/", TRACING,
+		.expected_attach_type = BPF_TRACE_FTRACE_ENTRY,
+		.is_attach_btf = true,
+		.attach_fn = attach_trace),
 	BPF_EAPROG_SEC("xdp_devmap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
@@ -9125,6 +9129,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
 #define BTF_ITER_PREFIX "bpf_iter_"
+#define BTF_FTRACE_PROBE "bpf_ftrace_probe"
 #define BTF_MAX_NAME_SIZE 128
 
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
@@ -9158,6 +9163,9 @@ static inline int find_attach_btf_id(struct btf *btf, const char *name,
 	else if (attach_type == BPF_TRACE_ITER)
 		err = find_btf_by_prefix_kind(btf, BTF_ITER_PREFIX, name,
 					      BTF_KIND_FUNC);
+	else if (attach_type == BPF_TRACE_FTRACE_ENTRY)
+		err = btf__find_by_name_kind(btf, BTF_FTRACE_PROBE,
+					     BTF_KIND_FUNC);
 	else
 		err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
 
@@ -10191,8 +10199,74 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
 	return (struct bpf_link *)link;
 }
 
+static struct bpf_link *bpf_program__attach_ftrace(struct bpf_program *prog)
+{
+	char *pattern = prog->sec_name + prog->sec_def->len;
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int prog_fd, link_fd, cnt, err, i;
+	enum bpf_attach_type attach_type;
+	struct bpf_link *link = NULL;
+	__s32 *ids = NULL;
+	int funcs_fd = -1;
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
+	cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
+					BTF_KIND_FUNC, &ids);
+	if (cnt <= 0)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < cnt; i++) {
+		err = bpf_functions_add(funcs_fd, ids[i]);
+		if (err < 0) {
+			pr_warn("prog '%s': can't attach function BTF ID %d\n",
+				prog->name, ids[i]);
+			goto out_err;
+		}
+		if (funcs_fd == -1)
+			funcs_fd = err;
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	link->detach = &bpf_link__detach_fd;
+
+	opts.funcs_fd = funcs_fd;
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
+	if (funcs_fd != -1)
+		close(funcs_fd);
+	free(link);
+	free(ids);
+	return ERR_PTR(err);
+}
+
 struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 {
+	if (prog->expected_attach_type == BPF_TRACE_FTRACE_ENTRY)
+		return bpf_program__attach_ftrace(prog);
+
 	return bpf_program__attach_btf_id(prog);
 }
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..69cbe54125e3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -355,6 +355,7 @@ LIBBPF_0.4.0 {
 	global:
 		btf__add_float;
 		btf__add_type;
+		bpf_functions_add;
 		bpf_linker__add_file;
 		bpf_linker__finalize;
 		bpf_linker__free;
-- 
2.30.2

