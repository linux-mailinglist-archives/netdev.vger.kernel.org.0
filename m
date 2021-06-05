Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB3939C7CE
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhFELNQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:16 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:37438 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230281AbhFELNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-3mPzuhRfNpuQyfc12O2vRw-1; Sat, 05 Jun 2021 07:11:22 -0400
X-MC-Unique: 3mPzuhRfNpuQyfc12O2vRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23166C73A0;
        Sat,  5 Jun 2021 11:11:21 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67DA114108;
        Sat,  5 Jun 2021 11:11:18 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 13/19] bpf: Add support to link multi func tracing program
Date:   Sat,  5 Jun 2021 13:10:28 +0200
Message-Id: <20210605111034.1810858-14-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to attach multiple functions to tracing program
by using the link_create/link_update interface.

Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
API, that define array of functions btf ids that will be attached
to prog_fd.

The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).

The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
link type, which creates separate bpf_trampoline and registers it
as direct function for all specified btf ids.

The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
standard trampolines, so all registered functions need to be free
of direct functions, otherwise the link fails.

The new bpf_trampoline will store and pass to bpf program the highest
number of arguments from all given functions.

New programs (fentry or fexit) can be added to the existing trampoline
through the link_update interface via new_prog_fd descriptor.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |   3 +
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/syscall.c           | 185 ++++++++++++++++++++++++++++++++-
 kernel/bpf/trampoline.c        |  53 +++++++---
 tools/include/uapi/linux/bpf.h |   5 +
 5 files changed, 237 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 23221e0e8d3c..99a81c6c22e6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -661,6 +661,7 @@ struct bpf_trampoline {
 	struct bpf_tramp_image *cur_image;
 	u64 selector;
 	struct module *mod;
+	bool multi;
 };
 
 struct bpf_attach_target_info {
@@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
 int bpf_jit_charge_modmem(u32 pages);
 void bpf_jit_uncharge_modmem(u32 pages);
+struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
+void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
 					   struct bpf_trampoline *tr)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ad9340fb14d4..5fd6ff64e8dc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1007,6 +1007,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_TRACING_MULTI = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1454,6 +1455,10 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			struct {
+				__aligned_u64	multi_btf_ids;		/* addresses to attach */
+				__u32		multi_btf_ids_cnt;	/* addresses count */
+			};
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8f59090280b5..44446cc67af7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/btf_ids.h>
+#include <linux/ftrace.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2810,6 +2811,184 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	return err;
 }
 
+struct bpf_tracing_multi_link {
+	struct bpf_link link;
+	enum bpf_attach_type attach_type;
+	struct ftrace_ops ops;
+	struct bpf_trampoline *tr;
+};
+
+static void bpf_tracing_multi_link_release(struct bpf_link *link)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+	const struct bpf_prog_aux *aux;
+	int kind;
+
+	unregister_ftrace_direct_multi(&tr_link->ops);
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry(aux, &tr_link->tr->progs_hlist[kind], tramp_hlist)
+			bpf_prog_put(aux->prog);
+	}
+}
+
+static void bpf_tracing_multi_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	bpf_trampoline_multi_free(tr_link->tr);
+	kfree(tr_link);
+}
+
+static void bpf_tracing_multi_link_show_fdinfo(const struct bpf_link *link,
+					       struct seq_file *seq)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	seq_printf(seq, "attach_type:\t%d\n", tr_link->attach_type);
+}
+
+static int bpf_tracing_multi_link_fill_link_info(const struct bpf_link *link,
+						 struct bpf_link_info *info)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	info->tracing.attach_type = tr_link->attach_type;
+	return 0;
+}
+
+static int check_multi_prog_type(struct bpf_prog *prog)
+{
+	if (!prog->aux->multi_func &&
+	    prog->type != BPF_PROG_TYPE_TRACING)
+		return -EINVAL;
+	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
+	    prog->expected_attach_type != BPF_TRACE_FEXIT)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_tracing_multi_link_update(struct bpf_link *link,
+					 struct bpf_prog *new_prog,
+					 struct bpf_prog *old_prog __maybe_unused)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+	int err;
+
+	if (check_multi_prog_type(new_prog))
+		return -EINVAL;
+
+	err = bpf_trampoline_link_prog(new_prog, tr_link->tr);
+	if (err)
+		return err;
+
+	err = modify_ftrace_direct_multi(&tr_link->ops,
+					 (unsigned long) tr_link->tr->cur_image->image);
+	return WARN_ON(err);
+}
+
+static const struct bpf_link_ops bpf_tracing_multi_link_lops = {
+	.release = bpf_tracing_multi_link_release,
+	.dealloc = bpf_tracing_multi_link_dealloc,
+	.show_fdinfo = bpf_tracing_multi_link_show_fdinfo,
+	.fill_link_info = bpf_tracing_multi_link_fill_link_info,
+	.update_prog = bpf_tracing_multi_link_update,
+};
+
+static void bpf_func_model_nargs(struct btf_func_model *m, int nr_args)
+{
+	int i;
+
+	for (i = 0; i < nr_args; i++)
+		m->arg_size[i] = 8;
+	m->ret_size = 8;
+	m->nr_args = nr_args;
+}
+
+static int bpf_tracing_multi_attach(struct bpf_prog *prog,
+				    const union bpf_attr *attr)
+{
+	void __user *ubtf_ids = u64_to_user_ptr(attr->link_create.multi_btf_ids);
+	u32 size, i, cnt = attr->link_create.multi_btf_ids_cnt;
+	struct bpf_tracing_multi_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	struct bpf_trampoline *tr = NULL;
+	int err = -EINVAL;
+	u8 nr_args = 0;
+	u32 *btf_ids;
+
+	if (check_multi_prog_type(prog))
+		return -EINVAL;
+
+	size = cnt * sizeof(*btf_ids);
+	btf_ids = kmalloc(size, GFP_USER | __GFP_NOWARN);
+	if (!btf_ids)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	if (ubtf_ids && copy_from_user(btf_ids, ubtf_ids, size))
+		goto out_free;
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		goto out_free;
+
+	for (i = 0; i < cnt; i++) {
+		struct bpf_attach_target_info tgt_info = {};
+
+		err = bpf_check_attach_target(NULL, prog, NULL, btf_ids[i],
+					      &tgt_info);
+		if (err)
+			goto out_free;
+
+		if (ftrace_set_filter_ip(&link->ops, tgt_info.tgt_addr, 0, 0))
+			goto out_free;
+
+		if (nr_args < tgt_info.fmodel.nr_args)
+			nr_args = tgt_info.fmodel.nr_args;
+	}
+
+	tr = bpf_trampoline_multi_alloc();
+	if (!tr)
+		goto out_free;
+
+	bpf_func_model_nargs(&tr->func.model, nr_args);
+
+	err = bpf_trampoline_link_prog(prog, tr);
+	if (err)
+		goto out_free;
+
+	err = register_ftrace_direct_multi(&link->ops, (unsigned long) tr->cur_image->image);
+	if (err)
+		goto out_free;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
+		      &bpf_tracing_multi_link_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_unlink;
+
+	link->tr = tr;
+	/* Take extra ref so we are even with progs added by link_update. */
+	bpf_prog_inc(prog);
+	return bpf_link_settle(&link_primer);
+
+out_unlink:
+	unregister_ftrace_direct_multi(&link->ops);
+out_free:
+	kfree(tr);
+	kfree(btf_ids);
+	kfree(link);
+	return err;
+}
+
 struct bpf_raw_tp_link {
 	struct bpf_link link;
 	struct bpf_raw_event_map *btp;
@@ -3043,6 +3222,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
 		return BPF_PROG_TYPE_SK_LOOKUP;
@@ -4099,6 +4280,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, uattr, prog);
+	else if (prog->aux->multi_func)
+		return bpf_tracing_multi_attach(prog, attr);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
@@ -4106,7 +4289,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.multi_btf_ids_cnt
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 2755fdcf9fbf..660b8197c27f 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -58,7 +58,7 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
 			   PAGE_SIZE, true, ksym->name);
 }
 
-static struct bpf_trampoline *bpf_trampoline_alloc(void)
+static struct bpf_trampoline *bpf_trampoline_alloc(bool multi)
 {
 	struct bpf_trampoline *tr;
 	int i;
@@ -72,6 +72,7 @@ static struct bpf_trampoline *bpf_trampoline_alloc(void)
 	mutex_init(&tr->mutex);
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
+	tr->multi = multi;
 	return tr;
 }
 
@@ -88,7 +89,7 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 			goto out;
 		}
 	}
-	tr = bpf_trampoline_alloc();
+	tr = bpf_trampoline_alloc(false);
 	if (tr) {
 		tr->key = key;
 		hlist_add_head(&tr->hlist, head);
@@ -343,14 +344,16 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	struct bpf_tramp_image *im;
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
-	int err, total;
+	bool update = !tr->multi;
+	int err = 0, total;
 
 	tprogs = bpf_trampoline_get_progs(tr, &total);
 	if (IS_ERR(tprogs))
 		return PTR_ERR(tprogs);
 
 	if (total == 0) {
-		err = unregister_fentry(tr, tr->cur_image->image);
+		if (update)
+			err = unregister_fentry(tr, tr->cur_image->image);
 		bpf_tramp_image_put(tr->cur_image);
 		tr->cur_image = NULL;
 		tr->selector = 0;
@@ -363,9 +366,15 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 		goto out;
 	}
 
+	if (tr->multi)
+		flags |= BPF_TRAMP_F_IP_ARG;
+
 	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
-	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
+	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+		if (tr->multi)
+			flags |= BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_IP_ARG;
+	}
 
 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
 					  &tr->func.model, flags, tprogs,
@@ -373,16 +382,19 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	if (err < 0)
 		goto out;
 
+	err = 0;
 	WARN_ON(tr->cur_image && tr->selector == 0);
 	WARN_ON(!tr->cur_image && tr->selector);
-	if (tr->cur_image)
-		/* progs already running at this address */
-		err = modify_fentry(tr, tr->cur_image->image, im->image);
-	else
-		/* first time registering */
-		err = register_fentry(tr, im->image);
-	if (err)
-		goto out;
+	if (update) {
+		if (tr->cur_image)
+			/* progs already running at this address */
+			err = modify_fentry(tr, tr->cur_image->image, im->image);
+		else
+			/* first time registering */
+			err = register_fentry(tr, im->image);
+		if (err)
+			goto out;
+	}
 	if (tr->cur_image)
 		bpf_tramp_image_put(tr->cur_image);
 	tr->cur_image = im;
@@ -436,6 +448,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 			err = -EBUSY;
 			goto out;
 		}
+		if (tr->multi) {
+			err = -EINVAL;
+			goto out;
+		}
 		tr->extension_prog = prog;
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
 					 prog->bpf_func);
@@ -529,6 +545,17 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	mutex_unlock(&trampoline_mutex);
 }
 
+struct bpf_trampoline *bpf_trampoline_multi_alloc(void)
+{
+	return bpf_trampoline_alloc(true);
+}
+
+void bpf_trampoline_multi_free(struct bpf_trampoline *tr)
+{
+	bpf_tramp_image_put(tr->cur_image);
+	kfree(tr);
+}
+
 #define NO_START_TIME 1
 static u64 notrace bpf_prog_start_time(void)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ad9340fb14d4..5fd6ff64e8dc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1007,6 +1007,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_ITER = 4,
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
+	BPF_LINK_TYPE_TRACING_MULTI = 7,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1454,6 +1455,10 @@ union bpf_attr {
 				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
 				__u32		iter_info_len;	/* iter_info length */
 			};
+			struct {
+				__aligned_u64	multi_btf_ids;		/* addresses to attach */
+				__u32		multi_btf_ids_cnt;	/* addresses count */
+			};
 		};
 	} link_create;
 
-- 
2.31.1

