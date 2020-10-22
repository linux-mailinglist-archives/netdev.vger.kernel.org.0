Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85119295A25
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgJVIWy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:54 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:55759 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895391AbgJVIWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:52 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-HbLvGENtOjCNNqMn1YckvA-1; Thu, 22 Oct 2020 04:22:46 -0400
X-MC-Unique: HbLvGENtOjCNNqMn1YckvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D611C8049E7;
        Thu, 22 Oct 2020 08:22:44 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9ACB60BFA;
        Thu, 22 Oct 2020 08:22:38 +0000 (UTC)
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
Subject: [RFC bpf-next 14/16] libbpf: Add trampoline batch detach support
Date:   Thu, 22 Oct 2020 10:21:36 +0200
Message-Id: <20201022082138.2322434-15-jolsa@kernel.org>
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
When set to true the bpf_object__detach_skeleton will try to detach
all tracing programs via batch mode.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c      | 16 +++++++++++--
 tools/lib/bpf/bpf.h      |  1 +
 tools/lib/bpf/libbpf.c   | 50 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 21fffff5e237..9af13e511851 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -858,7 +858,7 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 }
 
-int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count)
+static int bpf_trampoline_batch(int cmd, int *ifds, int *ofds, int count)
 {
 	union bpf_attr attr;
 
@@ -867,7 +867,19 @@ int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count)
 	attr.trampoline_batch.out = ptr_to_u64(ofds);
 	attr.trampoline_batch.count = count;
 
-	return sys_bpf(BPF_TRAMPOLINE_BATCH_ATTACH, &attr, sizeof(attr));
+	return sys_bpf(cmd, &attr, sizeof(attr));
+}
+
+int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count)
+{
+	return bpf_trampoline_batch(BPF_TRAMPOLINE_BATCH_ATTACH,
+				    ifds, ofds, count);
+}
+
+int bpf_trampoline_batch_detach(int *ifds, int *ofds, int count)
+{
+	return bpf_trampoline_batch(BPF_TRAMPOLINE_BATCH_DETACH,
+				    ifds, ofds, count);
 }
 
 int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index ba3b0b6e3cb0..c6fb5977de79 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -236,6 +236,7 @@ LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 *prog_ids, __u32 *prog_cnt);
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
 LIBBPF_API int bpf_trampoline_batch_attach(int *ifds, int *ofds, int count);
+LIBBPF_API int bpf_trampoline_batch_detach(int *ifds, int *ofds, int count);
 LIBBPF_API int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf,
 			    __u32 log_buf_size, bool do_log);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 584da3b401ac..02e9e8279aa7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10874,6 +10874,47 @@ static int attach_trace_batch(struct bpf_object_skeleton *s)
 	return ret;
 }
 
+static int detach_trace_batch(struct bpf_object_skeleton *s)
+{
+	int *in_fds, *out_fds, cnt;
+	int i, ret = -ENOMEM;
+
+	in_fds = calloc(s->prog_cnt, sizeof(in_fds[0]));
+	out_fds = calloc(s->prog_cnt, sizeof(out_fds[0]));
+	if (!in_fds || !out_fds)
+		goto out_clean;
+
+	for (cnt = 0, i = 0; i < s->prog_cnt; i++) {
+		struct bpf_program *prog = *s->progs[i].prog;
+		struct bpf_link **link = s->progs[i].link;
+
+		if (!is_trampoline(prog))
+			continue;
+		in_fds[cnt++] = (*link)->fd;
+	}
+
+	ret = bpf_trampoline_batch_detach(in_fds, out_fds, cnt);
+	if (ret)
+		goto out_clean;
+
+	for (i = 0; i < s->prog_cnt; i++) {
+		struct bpf_program *prog = *s->progs[i].prog;
+		struct bpf_link **link = s->progs[i].link;
+
+		if (!is_trampoline(prog))
+			continue;
+
+		bpf_link__disconnect(*link);
+		bpf_link__destroy(*link);
+		*link = NULL;
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
 	struct bpf_object *obj = *s->obj;
@@ -10914,11 +10955,20 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 
 void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
 {
+	struct bpf_object *obj = *s->obj;
 	int i;
 
+	if (obj->trampoline_attach_batch)
+		detach_trace_batch(s);
+
 	for (i = 0; i < s->prog_cnt; i++) {
+		struct bpf_program *prog = *s->progs[i].prog;
 		struct bpf_link **link = s->progs[i].link;
 
+		/* Program was attached via batch mode. */
+		if (obj->trampoline_attach_batch && is_trampoline(prog))
+			continue;
+
 		bpf_link__destroy(*link);
 		*link = NULL;
 	}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5a5ce921956d..cfe0b3d52172 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -337,4 +337,5 @@ LIBBPF_0.2.0 {
 		perf_buffer__consume_buffer;
 		xsk_socket__create_shared;
 		bpf_trampoline_batch_attach;
+		bpf_trampoline_batch_detach;
 } LIBBPF_0.1.0;
-- 
2.26.2

