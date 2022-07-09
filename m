Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADF56C4D1
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiGIAFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 20:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiGIAE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 20:04:59 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B6365590
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 17:04:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e4-20020a631e04000000b004128f83af17so136220pge.16
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 17:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v20gnutu/ufQXZDdUdIZi6V4CsuvNhARBlTT9+Un1TE=;
        b=QDVsak6tzkCg3jXOe1QLGJXVoYQhidBvh5IeADScjILAXb1zhpg0lqtsCaMhh94w5C
         EtzjzO8xevuKRpR8DoUMK6EeKOjskjka4d/OEI3AWKz8I03QlFTbYnq45I+5MrAEneIK
         vTQG/wo5jhD5VqSge3tCYttZiZoGLKEQ+ogRYxXnEzmD+0Rm1Z2/7/ekh6LMIPPbnKxR
         sjEIuSKMOlZsoaoZYiVP/cdW9VQVrZ3H/W82/+96z8swunsKP+n7yiU+VyZKC6fF0eoQ
         H6vAqxVbLOdiJ67l6/nB9SG7DMkkbDrsCv/LweDYvi3fhku3t7m5ucI404yDg2HBXH8X
         ii5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v20gnutu/ufQXZDdUdIZi6V4CsuvNhARBlTT9+Un1TE=;
        b=2raevt4WmOmCrhzUeWr0ch1q0JfcNpJWgCM46bqC4AR8vP0Jy3HloXIjkPWjgoyRdN
         iMqE/FLp4Jmm2xtbzgvJM0rY6Up5vY/hAKn6ExRB1ALOqqFjFM3GXX4cRqJQdBYRG3DX
         DMSvUCif/O9O6sd8C3OtcsKn2+Nn1Q43uZqxQnNIbefLRFwqHh6XM11rXeSH5gm4gHLB
         hZQ/Ot2hDfP7k2EVch2iPpnlNDN3hSG7Rs1p9sN9vWjl3WvSSlDGF5rZ5LOtEgcQx5P0
         An5SilxxeY6bkvt0s644M40YlpgPRRbL2T76OxYkDgXHrOHLoNH+h6pFLCTdV+4DKlze
         bcmA==
X-Gm-Message-State: AJIora/0ezaUQZ8+RjOTt7YxjhyqM6JLXjTOZlF4ef43jcK+wbeGHUBt
        Er/tpGynWDuKvq89DcG2NaF4xiUSRWZRxWZ6
X-Google-Smtp-Source: AGRyM1uOKhcLdg89myIctQOWRz9L7xaYYSK4ZUKjomu0n3XUoONJH1PInzGWlLhcAXf1qlgSs7T8+IlHNCatHH4j
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:8c0a:b0:1ef:7c95:3f00 with SMTP
 id a10-20020a17090a8c0a00b001ef7c953f00mr2661448pjo.180.1657325094262; Fri,
 08 Jul 2022 17:04:54 -0700 (PDT)
Date:   Sat,  9 Jul 2022 00:04:35 +0000
In-Reply-To: <20220709000439.243271-1-yosryahmed@google.com>
Message-Id: <20220709000439.243271-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Luo <haoluo@google.com>

Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:

 - walking a cgroup's descendants in pre-order.
 - walking a cgroup's descendants in post-order.
 - walking a cgroup's ancestors.

When attaching cgroup_iter, one can set a cgroup to the iter_link
created from attaching. This cgroup is passed as a file descriptor and
serves as the starting point of the walk. If no cgroup is specified,
the starting point will be the root cgroup.

For walking descendants, one can specify the order: either pre-order or
post-order. For walking ancestors, the walk starts at the specified
cgroup and ends at the root.

One can also terminate the walk early by returning 1 from the iter
program.

Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
program is called with cgroup_mutex held.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h                           |   8 +
 include/uapi/linux/bpf.h                      |  21 ++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 242 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  21 ++
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 6 files changed, 297 insertions(+), 2 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b21f2a3452ff..5de9de06e2551 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -47,6 +47,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct cgroup;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1714,7 +1715,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 	int __init bpf_iter_ ## target(args) { return 0; }
 
 struct bpf_iter_aux_info {
+	/* for map_elem iter */
 	struct bpf_map *map;
+
+	/* for cgroup iter */
+	struct {
+		struct cgroup *start; /* starting cgroup */
+		int order;
+	} cgroup;
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 379e68fb866fc..6f5979e221927 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
 };
 
+enum bpf_iter_cgroup_traversal_order {
+	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
+	BPF_ITER_CGROUP_POST,		/* post-order traversal */
+	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
+};
+
 union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+
+	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
+	 * of a given cgroup.
+	 */
+	struct {
+		/* Cgroup file descriptor. This is root of the subtree if for walking the
+		 * descendants; this is the starting cgroup if for walking the ancestors.
+		 */
+		__u32	cgroup_fd;
+		__u32	traversal_order;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,6 +6151,10 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u32 traversal_order;
+					__aligned_u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 057ba8e01e70f..00e05b69a4df1 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -24,6 +24,9 @@ endif
 ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
 endif
+ifeq ($(CONFIG_CGROUPS),y)
+obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
+endif
 obj-$(CONFIG_CGROUP_BPF) += cgroup.o
 ifeq ($(CONFIG_INET),y)
 obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
new file mode 100644
index 0000000000000..8f50b326016e6
--- /dev/null
+++ b/kernel/bpf/cgroup_iter.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Google */
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+
+#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
+
+/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
+ *
+ *  1. Walk the descendants of a cgroup in pre-order.
+ *  2. Walk the descendants of a cgroup in post-order.
+ *  2. Walk the ancestors of a cgroup.
+ *
+ * For walking descendants, cgroup_iter can walk in either pre-order or
+ * post-order. For walking ancestors, the iter walks up from a cgroup to
+ * the root.
+ *
+ * The iter program can terminate the walk early by returning 1. Walk
+ * continues if prog returns 0.
+ *
+ * The prog can check (seq->num == 0) to determine whether this is
+ * the first element. The prog may also be passed a NULL cgroup,
+ * which means the walk has completed and the prog has a chance to
+ * do post-processing, such as outputing an epilogue.
+ *
+ * Note: the iter_prog is called with cgroup_mutex held.
+ */
+
+struct bpf_iter__cgroup {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct cgroup *, cgroup);
+};
+
+struct cgroup_iter_priv {
+	struct cgroup_subsys_state *start_css;
+	bool terminate;
+	int order;
+};
+
+static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct cgroup_iter_priv *p = seq->private;
+
+	mutex_lock(&cgroup_mutex);
+
+	/* support only one session */
+	if (*pos > 0)
+		return NULL;
+
+	++*pos;
+	p->terminate = false;
+	if (p->order == BPF_ITER_CGROUP_PRE)
+		return css_next_descendant_pre(NULL, p->start_css);
+	else if (p->order == BPF_ITER_CGROUP_POST)
+		return css_next_descendant_post(NULL, p->start_css);
+	else /* BPF_ITER_CGROUP_PARENT_UP */
+		return p->start_css;
+}
+
+static int __cgroup_iter_seq_show(struct seq_file *seq,
+				  struct cgroup_subsys_state *css, int in_stop);
+
+static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
+{
+	/* pass NULL to the prog for post-processing */
+	if (!v)
+		__cgroup_iter_seq_show(seq, NULL, true);
+	mutex_unlock(&cgroup_mutex);
+}
+
+static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
+	struct cgroup_iter_priv *p = seq->private;
+
+	++*pos;
+	if (p->terminate)
+		return NULL;
+
+	if (p->order == BPF_ITER_CGROUP_PRE)
+		return css_next_descendant_pre(curr, p->start_css);
+	else if (p->order == BPF_ITER_CGROUP_POST)
+		return css_next_descendant_post(curr, p->start_css);
+	else /* BPF_ITER_CGROUP_PARENT_UP */
+		return curr->parent;
+}
+
+static int __cgroup_iter_seq_show(struct seq_file *seq,
+				  struct cgroup_subsys_state *css, int in_stop)
+{
+	struct cgroup_iter_priv *p = seq->private;
+	struct bpf_iter__cgroup ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	/* cgroup is dead, skip this element */
+	if (css && cgroup_is_dead(css->cgroup))
+		return 0;
+
+	ctx.meta = &meta;
+	ctx.cgroup = css ? css->cgroup : NULL;
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, in_stop);
+	if (prog)
+		ret = bpf_iter_run_prog(prog, &ctx);
+
+	/* if prog returns > 0, terminate after this element. */
+	if (ret != 0)
+		p->terminate = true;
+
+	return 0;
+}
+
+static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
+{
+	return __cgroup_iter_seq_show(seq, (struct cgroup_subsys_state *)v,
+				      false);
+}
+
+static const struct seq_operations cgroup_iter_seq_ops = {
+	.start  = cgroup_iter_seq_start,
+	.next   = cgroup_iter_seq_next,
+	.stop   = cgroup_iter_seq_stop,
+	.show   = cgroup_iter_seq_show,
+};
+
+BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
+
+static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
+{
+	struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
+	struct cgroup *cgrp = aux->cgroup.start;
+
+	p->start_css = &cgrp->self;
+	p->terminate = false;
+	p->order = aux->cgroup.order;
+	return 0;
+}
+
+static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
+	.seq_ops                = &cgroup_iter_seq_ops,
+	.init_seq_private       = cgroup_iter_seq_init,
+	.seq_priv_size          = sizeof(struct cgroup_iter_priv),
+};
+
+static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
+				  union bpf_iter_link_info *linfo,
+				  struct bpf_iter_aux_info *aux)
+{
+	int fd = linfo->cgroup.cgroup_fd;
+	int order = linfo->cgroup.traversal_order;
+	struct cgroup *cgrp;
+
+	if (order != BPF_ITER_CGROUP_PRE &&
+	    order != BPF_ITER_CGROUP_POST &&
+	    order != BPF_ITER_CGROUP_PARENT_UP)
+		return -EINVAL;
+
+	if (fd)
+		cgrp = cgroup_get_from_fd(fd);
+	else /* walk the entire hierarchy by default. */
+		cgrp = cgroup_get_from_path("/");
+
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	aux->cgroup.start = cgrp;
+	aux->cgroup.order = order;
+	return 0;
+}
+
+static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
+{
+	cgroup_put(aux->cgroup.start);
+}
+
+static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
+					struct seq_file *seq)
+{
+	char *buf;
+
+	buf = kzalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf) {
+		seq_puts(seq, "cgroup_path:\t<unknown>\n");
+		goto show_order;
+	}
+
+	/* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
+	 * will print nothing.
+	 *
+	 * Path is in the calling process's cgroup namespace.
+	 */
+	cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
+		       current->nsproxy->cgroup_ns);
+	seq_printf(seq, "cgroup_path:\t%s\n", buf);
+	kfree(buf);
+
+show_order:
+	if (aux->cgroup.order == BPF_ITER_CGROUP_PRE)
+		seq_puts(seq, "traversal_order: pre\n");
+	else if (aux->cgroup.order == BPF_ITER_CGROUP_POST)
+		seq_puts(seq, "traversal_order: post\n");
+	else /* BPF_ITER_CGROUP_PARENT_UP */
+		seq_puts(seq, "traversal_order: parent_up\n");
+}
+
+static int bpf_iter_cgroup_fill_link_info(const struct bpf_iter_aux_info *aux,
+					  struct bpf_link_info *info)
+{
+	info->iter.cgroup.traversal_order = aux->cgroup.order;
+	info->iter.cgroup.cgroup_id = cgroup_id(aux->cgroup.start);
+	return 0;
+}
+
+DEFINE_BPF_ITER_FUNC(cgroup, struct bpf_iter_meta *meta,
+		     struct cgroup *cgroup)
+
+static struct bpf_iter_reg bpf_cgroup_reg_info = {
+	.target			= "cgroup",
+	.attach_target		= bpf_iter_attach_cgroup,
+	.detach_target		= bpf_iter_detach_cgroup,
+	.show_fdinfo		= bpf_iter_cgroup_show_fdinfo,
+	.fill_link_info		= bpf_iter_cgroup_fill_link_info,
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__cgroup, cgroup),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		= &cgroup_iter_seq_info,
+};
+
+static int __init bpf_cgroup_iter_init(void)
+{
+	bpf_cgroup_reg_info.ctx_arg_info[0].btf_id = bpf_cgroup_btf_id[0];
+	return bpf_iter_reg_target(&bpf_cgroup_reg_info);
+}
+
+late_initcall(bpf_cgroup_iter_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 379e68fb866fc..6f5979e221927 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
 };
 
+enum bpf_iter_cgroup_traversal_order {
+	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
+	BPF_ITER_CGROUP_POST,		/* post-order traversal */
+	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
+};
+
 union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+
+	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
+	 * of a given cgroup.
+	 */
+	struct {
+		/* Cgroup file descriptor. This is root of the subtree if for walking the
+		 * descendants; this is the starting cgroup if for walking the ancestors.
+		 */
+		__u32	cgroup_fd;
+		__u32	traversal_order;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,6 +6151,10 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u32 traversal_order;
+					__aligned_u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 5fce7008d1ff3..604a40777cfa8 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -764,8 +764,8 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 
 	/* union with nested struct */
 	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
-			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
-			   { .map = { .map_fd = 1 }});
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd = (__u32)1,.traversal_order = (__u32)1,},}",
+			   { .cgroup = { .cgroup_fd = 1, .traversal_order = 1, }});
 
 	/* struct skb with nested structs/unions; because type output is so
 	 * complex, we don't do a string comparison, just verify we return
-- 
2.37.0.rc0.161.g10f37bed90-goog

