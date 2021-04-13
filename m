Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAF635DE81
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbhDMMQk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:40 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:31273 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237650AbhDMMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:20 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-EYkf5d-YPb2VxoWsmJmK7Q-1; Tue, 13 Apr 2021 08:15:54 -0400
X-MC-Unique: EYkf5d-YPb2VxoWsmJmK7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 513C88B459E;
        Tue, 13 Apr 2021 12:15:31 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2912610023B0;
        Tue, 13 Apr 2021 12:15:27 +0000 (UTC)
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
Subject: [PATCHv2 RFC bpf-next 3/7] bpf: Add support to attach program to ftrace probe
Date:   Tue, 13 Apr 2021 14:15:12 +0200
Message-Id: <20210413121516.1467989-4-jolsa@kernel.org>
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

Adding support to attach bpf program to ftrace probes.

The program needs to loaded with BPF_TRACE_FTRACE_ENTRY
as its expected_attach_type. With such program we can
create a link with new 'funcs_fd' field, which holds
fd of the bpf_function object.

The attach will create ftrace_ops object and set filter
to the bpf_functions functions.

The ftrace bpf program gets following arguments on entry:
  ip, parent_ip

It's possible to add registers in the future, but I have
no use for them at the moment. Currently bpftrace is using
'ip' to identify the probe.

Adding 'entry' support for now, 'exit' support can be added
later when it's supported in ftrace.

Forcing userspace to use bpf_ftrace_probe BTF ID as probed
function, which is used in verifier to check on probe's
data accesses. The verifier now checks that we use directly
bpf_ftrace_probe as probe, but we could change it to use any
function with same prototype if needed.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |   3 +
 kernel/bpf/syscall.c           | 147 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |  30 +++++++
 net/bpf/test_run.c             |   1 +
 tools/include/uapi/linux/bpf.h |   3 +
 5 files changed, 184 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5d616735fe1b..dbedbcdc8122 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -980,6 +980,7 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_TRACE_FTRACE_ENTRY,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -993,6 +994,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_FTRACE = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1427,6 +1429,7 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			__u32		funcs_fd;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b240a500cae5..c83515d41020 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1965,6 +1965,11 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 	    prog_type != BPF_PROG_TYPE_EXT)
 		return -EINVAL;
 
+	if (prog_type == BPF_PROG_TYPE_TRACING &&
+	    expected_attach_type == BPF_TRACE_FTRACE_ENTRY &&
+	    !IS_ENABLED(CONFIG_FUNCTION_TRACER))
+		return -EINVAL;
+
 	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 		switch (expected_attach_type) {
@@ -2861,6 +2866,144 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	return err;
 }
 
+#ifdef CONFIG_FUNCTION_TRACER
+struct bpf_tracing_ftrace_link {
+	struct bpf_link link;
+	enum bpf_attach_type attach_type;
+	struct ftrace_ops ops;
+};
+
+static void bpf_tracing_ftrace_link_release(struct bpf_link *link)
+{
+	struct bpf_tracing_ftrace_link *tr_link =
+		container_of(link, struct bpf_tracing_ftrace_link, link);
+
+	WARN_ON(unregister_ftrace_function(&tr_link->ops));
+}
+
+static void bpf_tracing_ftrace_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_tracing_ftrace_link *tr_link =
+		container_of(link, struct bpf_tracing_ftrace_link, link);
+
+	kfree(tr_link);
+}
+
+static void bpf_tracing_ftrace_link_show_fdinfo(const struct bpf_link *link,
+					       struct seq_file *seq)
+{
+	struct bpf_tracing_ftrace_link *tr_link =
+		container_of(link, struct bpf_tracing_ftrace_link, link);
+
+	seq_printf(seq,
+		   "attach_type:\t%d\n",
+		   tr_link->attach_type);
+}
+
+static int bpf_tracing_ftrace_link_fill_link_info(const struct bpf_link *link,
+						 struct bpf_link_info *info)
+{
+	struct bpf_tracing_ftrace_link *tr_link =
+		container_of(link, struct bpf_tracing_ftrace_link, link);
+
+	info->tracing.attach_type = tr_link->attach_type;
+	return 0;
+}
+
+static const struct bpf_link_ops bpf_tracing_ftrace_lops = {
+	.release = bpf_tracing_ftrace_link_release,
+	.dealloc = bpf_tracing_ftrace_link_dealloc,
+	.show_fdinfo = bpf_tracing_ftrace_link_show_fdinfo,
+	.fill_link_info = bpf_tracing_ftrace_link_fill_link_info,
+};
+
+static void
+bpf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
+			 struct ftrace_ops *ops,  struct ftrace_regs *fregs)
+{
+	struct bpf_tracing_ftrace_link *tr_link;
+	struct bpf_prog *prog;
+	u64 start;
+
+	tr_link = container_of(ops, struct bpf_tracing_ftrace_link, ops);
+	prog = tr_link->link.prog;
+
+	if (prog->aux->sleepable)
+		start = __bpf_prog_enter_sleepable(prog);
+	else
+		start = __bpf_prog_enter(prog);
+
+	if (start)
+		bpf_trace_run2(tr_link->link.prog, ip, parent_ip);
+
+	if (prog->aux->sleepable)
+		__bpf_prog_exit_sleepable(prog, start);
+	else
+		__bpf_prog_exit(prog, start);
+}
+
+static int bpf_tracing_ftrace_attach(struct bpf_prog *prog, int funcs_fd)
+{
+	struct bpf_tracing_ftrace_link *link;
+	struct bpf_link_primer link_primer;
+	struct bpf_functions *funcs;
+	struct ftrace_ops *ops;
+	int err = -ENOMEM;
+	struct fd orig;
+	int i;
+
+	if (prog->type != BPF_PROG_TYPE_TRACING)
+		return -EINVAL;
+
+	if (prog->expected_attach_type != BPF_TRACE_FTRACE_ENTRY)
+		return -EINVAL;
+
+	funcs = bpf_functions_get_from_fd(funcs_fd, &orig);
+	if (IS_ERR(funcs))
+		return PTR_ERR(funcs);
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		goto out_free;
+
+	ops = &link->ops;
+	ops->func = bpf_ftrace_function_call;
+	ops->flags = FTRACE_OPS_FL_DYNAMIC;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_FTRACE,
+		      &bpf_tracing_ftrace_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_free;
+
+	for (i = 0; i < funcs->cnt; i++) {
+		err = ftrace_set_filter_ip(ops, funcs->addrs[i], 0, 0);
+		if (err)
+			goto out_free;
+	}
+
+	err = register_ftrace_function(ops);
+	if (err)
+		goto out_free;
+
+	fdput(orig);
+	return bpf_link_settle(&link_primer);
+
+out_free:
+	kfree(link);
+	fdput(orig);
+	return err;
+}
+#else
+static int bpf_tracing_ftrace_attach(struct bpf_prog *prog __maybe_unused,
+				     int funcs_fd __maybe_unused)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_FUNCTION_TRACER */
+
 struct bpf_raw_tp_link {
 	struct bpf_link link;
 	struct bpf_raw_event_map *btp;
@@ -3093,6 +3236,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_TRACE_FTRACE_ENTRY:
 	case BPF_TRACE_ITER:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
@@ -4149,6 +4293,9 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, prog);
+	else if (prog->expected_attach_type == BPF_TRACE_FTRACE_ENTRY)
+		return bpf_tracing_ftrace_attach(prog,
+						 attr->link_create.funcs_fd);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 852541a435ef..ea001aec66f6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8946,6 +8946,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 			break;
 		case BPF_TRACE_RAW_TP:
 		case BPF_MODIFY_RETURN:
+		case BPF_TRACE_FTRACE_ENTRY:
 			return 0;
 		case BPF_TRACE_ITER:
 			break;
@@ -12794,6 +12795,14 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
 }
 
+__maybe_unused
+void bpf_ftrace_probe(unsigned long ip __maybe_unused,
+		      unsigned long parent_ip __maybe_unused)
+{
+}
+
+BTF_ID_LIST_SINGLE(btf_ftrace_probe_id, func, bpf_ftrace_probe);
+
 int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *prog,
 			    const struct bpf_prog *tgt_prog,
@@ -13021,6 +13030,25 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		}
 
 		break;
+	case BPF_TRACE_FTRACE_ENTRY:
+		if (tgt_prog) {
+			bpf_log(log,
+				"Only FENTRY/FEXIT progs are attachable to another BPF prog\n");
+			return -EINVAL;
+		}
+		if (btf_id != btf_ftrace_probe_id[0]) {
+			bpf_log(log,
+				"Only btf id '%d' allowed for ftrace probe\n",
+				btf_ftrace_probe_id[0]);
+			return -EINVAL;
+		}
+		t = btf_type_by_id(btf, t->type);
+		if (!btf_type_is_func_proto(t))
+			return -EINVAL;
+		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
+		if (ret < 0)
+			return ret;
+		break;
 	}
 	tgt_info->tgt_addr = addr;
 	tgt_info->tgt_name = tname;
@@ -13081,6 +13109,8 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
 		return 0;
+	} else if (prog->expected_attach_type == BPF_TRACE_FTRACE_ENTRY) {
+		return 0;
 	}
 
 	if (prog->type == BPF_PROG_TYPE_LSM) {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index a5d72c48fb66..0a891c27bad0 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -285,6 +285,7 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
+	case BPF_TRACE_FTRACE_ENTRY:
 		if (bpf_fentry_test1(1) != 2 ||
 		    bpf_fentry_test2(2, 3) != 5 ||
 		    bpf_fentry_test3(4, 5, 6) != 15 ||
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d616735fe1b..dbedbcdc8122 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -980,6 +980,7 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_TRACE_FTRACE_ENTRY,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -993,6 +994,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_FTRACE = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1427,6 +1429,7 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			__u32		funcs_fd;
 		};
 	} link_create;
 
-- 
2.30.2

