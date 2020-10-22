Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F23295A21
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895374AbgJVIWt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:49 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:35761 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895326AbgJVIWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-cvUtozlHMIK0VFhYQdK8lQ-1; Thu, 22 Oct 2020 04:22:40 -0400
X-MC-Unique: cvUtozlHMIK0VFhYQdK8lQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84705107ACF5;
        Thu, 22 Oct 2020 08:22:38 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A41460BFA;
        Thu, 22 Oct 2020 08:22:35 +0000 (UTC)
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
Subject: [RFC bpf-next 13/16] libbpf: Add trampoline batch attach support
Date:   Thu, 22 Oct 2020 10:21:35 +0200
Message-Id: <20201022082138.2322434-14-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding trampoline batch attach support so it's possible to use
batch mode to load tracing programs.

Adding trampoline_attach_batch bool to struct bpf_object_open_opts.
When set to true the bpf_object__attach_skeleton will try to load
all tracing programs via batch mode.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c      | 12 +++++++
 tools/lib/bpf/bpf.h      |  1 +
 tools/lib/bpf/libbpf.c   | 76 +++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h   |  5 ++-
 tools/lib/bpf/libbpf.map |  1 +
 5 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index d27e34133973..21fffff5e237 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -858,6 +858,18 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 }
 
+int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.trampoline_batch.in = ptr_to_u64(ifds);
+	attr.trampoline_batch.out = ptr_to_u64(ofds);
+	attr.trampoline_batch.count = count;
+
+	return sys_bpf(BPF_TRAMPOLINE_BATCH_ATTACH, &attr, sizeof(attr));
+}
+
 int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
 		 bool do_log)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 875dde20d56e..ba3b0b6e3cb0 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -235,6 +235,7 @@ LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
+LIBBPF_API int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count);
 LIBBPF_API int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf,
 			    __u32 log_buf_size, bool do_log);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..584da3b401ac 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -421,6 +421,7 @@ struct bpf_object {
 
 	bool loaded;
 	bool has_subcalls;
+	bool trampoline_attach_batch;
 
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -6907,6 +6908,9 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 			return ERR_PTR(-ENOMEM);
 	}
 
+	obj->trampoline_attach_batch = OPTS_GET(opts, trampoline_attach_batch,
+						 false);
+
 	err = bpf_object__elf_init(obj);
 	err = err ? : bpf_object__check_endianness(obj);
 	err = err ? : bpf_object__elf_collect(obj);
@@ -10811,9 +10815,75 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 	return 0;
 }
 
+static bool is_trampoline(const struct bpf_program *prog)
+{
+	return prog->type == BPF_PROG_TYPE_TRACING &&
+	      (prog->expected_attach_type == BPF_TRACE_FENTRY ||
+	       prog->expected_attach_type == BPF_TRACE_FEXIT);
+}
+
+static int attach_trace_batch(struct bpf_object_skeleton *s)
+{
+	int i, prog_fd, ret = -ENOMEM;
+	int *in_fds, *out_fds, cnt;
+
+	in_fds = calloc(s->prog_cnt, sizeof(in_fds[0]));
+	out_fds = calloc(s->prog_cnt, sizeof(out_fds[0]));
+	if (!in_fds || !out_fds)
+		goto out_clean;
+
+	ret = -EINVAL;
+	for (cnt = 0, i = 0; i < s->prog_cnt; i++) {
+		struct bpf_program *prog = *s->progs[i].prog;
+
+		if (!is_trampoline(prog))
+			continue;
+
+		prog_fd = bpf_program__fd(prog);
+		if (prog_fd < 0) {
+			pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+			goto out_clean;
+		}
+		in_fds[cnt++] = prog_fd;
+	}
+
+	ret = bpf_trampoline_batch_attach(in_fds, out_fds, cnt);
+	if (ret)
+		goto out_clean;
+
+	for (cnt = 0, i = 0; i < s->prog_cnt; i++) {
+		struct bpf_program *prog = *s->progs[i].prog;
+		struct bpf_link **linkp = s->progs[i].link;
+		struct bpf_link *link;
+
+		if (!is_trampoline(prog))
+			continue;
+
+		link = calloc(1, sizeof(*link));
+		if (!link)
+			goto out_clean;
+
+		link->detach = &bpf_link__detach_fd;
+		link->fd = out_fds[cnt++];
+		*linkp = link;
+	}
+
+out_clean:
+	free(in_fds);
+	free(out_fds);
+	return ret;
+}
+
 int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 {
-	int i;
+	struct bpf_object *obj = *s->obj;
+	int i, err;
+
+	if (obj->trampoline_attach_batch) {
+		err = attach_trace_batch(s);
+		if (err)
+			return err;
+	}
 
 	for (i = 0; i < s->prog_cnt; i++) {
 		struct bpf_program *prog = *s->progs[i].prog;
@@ -10823,6 +10893,10 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 		if (!prog->load)
 			continue;
 
+		/* Program was attached via batch mode. */
+		if (obj->trampoline_attach_batch && is_trampoline(prog))
+			continue;
+
 		sec_def = find_sec_def(prog->sec_name);
 		if (!sec_def || !sec_def->attach_fn)
 			continue;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6909ee81113a..66f8e78aa9f8 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -93,8 +93,11 @@ struct bpf_object_open_opts {
 	 * system Kconfig for CONFIG_xxx externs.
 	 */
 	const char *kconfig;
+	/* Attach trampolines via batch mode.
+	 */
+	bool trampoline_attach_batch;
 };
-#define bpf_object_open_opts__last_field kconfig
+#define bpf_object_open_opts__last_field trampoline_attach_batch
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4ebfadf45b47..5a5ce921956d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -336,4 +336,5 @@ LIBBPF_0.2.0 {
 		perf_buffer__epoll_fd;
 		perf_buffer__consume_buffer;
 		xsk_socket__create_shared;
+		bpf_trampoline_batch_attach;
 } LIBBPF_0.1.0;
-- 
2.26.2

