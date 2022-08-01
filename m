Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02D7586FDF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiHARzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiHARy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:54:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D22833E0A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:54:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-324989683fdso37836527b3.12
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 10:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MfJbn/+Bnj50s3X00LYlEGOyrPvTavI2uXbIMgCsuFQ=;
        b=W8ZJBEhyhVfZwot28SX4AsNcoIwH6zIyZzxm1lQvR0/9OEwUDEV4vFC5MxvLi10+fx
         XQ++Ra+XyRSdEhHJ4jceKlYKP+PFxx35fLIbZhOmxo7FxN1nVoxoZ/C9laRwtMt+HT4m
         t4rSpBv0kIhe1UPs5USQ3XvgoeONxl9aofQnYELmd0hJTdUEdetUMUYPmZfQXBB8fI78
         6+hpqW7U4Kju7DMkIxRUr70niF5AHv/CWbdoo39odY2gX5F0ROcvHDO/+aY/mUdJQu/s
         2gVJ3m6Yq+Cac1UN/3mbppnuleho+ogVAV1wr9yL2+FCjGkllM/aETIlrgDpKJRGT36Z
         G0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MfJbn/+Bnj50s3X00LYlEGOyrPvTavI2uXbIMgCsuFQ=;
        b=PjWEqh4cN4gwvy35XwtAsDPsfW9aanrjZUEduhCESJHfBtdZrOEo7+tkJBZ+jfaqZ8
         LPSOdAGuUiGs+wQfWFuV23zmuRknyMk3O+mj0F8OiBYmmcPN+4FQ9r/r9R8PuD6PjwOu
         3ehXwSNLBmTPgjlAFN2s1FgTvrkOQzh+8td5S79HDpeKwE6m9VA0DvylvxvnYuvQGcZe
         KGPADJgL+2QAgoRJlwqHH50qc5sjH/m3RE/BJyEFxPvGowbZiTEDmStyf5UWmchpVJqw
         zRPec5I8TZT5kQjBB4EsuNspNtnGsEJ7bnXUWcrJYImHFYZ6nbWbvcyKURXDK4ZoJAWR
         tB3w==
X-Gm-Message-State: ACgBeo2yguDGj8JpP8b3fy6ZS1CwCmPahmrv+13TsuK3oCFn57evIKYt
        +aRReyw5Gkny0bky/y8xSpSZljj2yNg=
X-Google-Smtp-Source: AA6agR4QUewsK9HMJqjL7NOmTzbfCYuJTK2ShaOWyd2cd0wLI6xhR7p9DJNTdf6Zl5DnqL2ot9hnm3zp2Cg=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:7c9:7b32:e73f:6716])
 (user=haoluo job=sendgmr) by 2002:a25:bf86:0:b0:671:3607:1381 with SMTP id
 l6-20020a25bf86000000b0067136071381mr12540646ybk.355.1659376484395; Mon, 01
 Aug 2022 10:54:44 -0700 (PDT)
Date:   Mon,  1 Aug 2022 10:54:03 -0700
In-Reply-To: <20220801175407.2647869-1-haoluo@google.com>
Message-Id: <20220801175407.2647869-5-haoluo@google.com>
Mime-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH bpf-next v6 4/8] bpf: Introduce cgroup iter
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Currently only one session is supported, which means, depending on the
volume of data bpf program intends to send to user space, the number
of cgroups that can be walked is limited. For example, given the current
buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
be walked is 512. This is a limitation of cgroup_iter. If the output
data is larger than the buffer size, the second read() will signal
EOPNOTSUPP. In order to work around, the user may have to update their
program to reduce the volume of data sent to output. For example, skip
some uninteresting cgroups. In future, we may extend bpf_iter flags to
allow customizing buffer size.

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h                           |   8 +
 include/uapi/linux/bpf.h                      |  31 ++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 268 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  31 ++
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 6 files changed, 343 insertions(+), 2 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 20c26aed7896..09b5c2167424 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -48,6 +48,7 @@ struct mem_cgroup;
 struct module;
 struct bpf_func_state;
 struct ftrace_ops;
+struct cgroup;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
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
index 59a217ca2dfd..b8e0644bf43c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
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
+	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
+	 * ancestors of a given cgroup.
+	 */
+	struct {
+		/* Cgroup file descriptor. This is root of the subtree if walking
+		 * descendants; it's the starting cgroup if walking the ancestors.
+		 * If it is left 0, the traversal starts from the default cgroup v2
+		 * root. For walking v1 hierarchy, one should always explicitly
+		 * specify the cgroup_fd.
+		 */
+		__u32	cgroup_fd;
+		__u32	traversal_order;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,11 +6154,22 @@ struct bpf_link_info {
 		struct {
 			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
 			__u32 target_name_len;	   /* in/out: target_name buffer len */
+
+			/* If the iter specific field is 32 bits, it can be put
+			 * in the first or second union. Otherwise it should be
+			 * put in the second union.
+			 */
 			union {
 				struct {
 					__u32 map_id;
 				} map;
 			};
+			union {
+				struct {
+					__u64 cgroup_id;
+					__u32 traversal_order;
+				} cgroup;
+			};
 		} iter;
 		struct  {
 			__u32 netns_ino;
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 057ba8e01e70..00e05b69a4df 100644
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
index 000000000000..e56178fbcc85
--- /dev/null
+++ b/kernel/bpf/cgroup_iter.c
@@ -0,0 +1,268 @@
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
+ *
+ * Currently only one session is supported, which means, depending on the
+ * volume of data bpf program intends to send to user space, the number
+ * of cgroups that can be walked is limited. For example, given the current
+ * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
+ * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
+ * be walked is 512. This is a limitation of cgroup_iter. If the output data
+ * is larger than the buffer size, the second read() will signal EOPNOTSUPP.
+ * In order to work around, the user may have to update their program to
+ * reduce the volume of data sent to output. For example, skip some
+ * uninteresting cgroups.
+ */
+
+struct bpf_iter__cgroup {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct cgroup *, cgroup);
+};
+
+struct cgroup_iter_priv {
+	struct cgroup_subsys_state *start_css;
+	bool visited_all;
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
+	/* cgroup_iter doesn't support read across multiple sessions. */
+	if (*pos > 0) {
+		if (p->visited_all)
+			return NULL;
+
+		/* Haven't visited all, but because cgroup_mutex has dropped,
+		 * return -EOPNOTSUPP to indicate incomplete iteration.
+		 */
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	++*pos;
+	p->terminate = false;
+	p->visited_all = false;
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
+	struct cgroup_iter_priv *p = seq->private;
+
+	mutex_unlock(&cgroup_mutex);
+
+	/* pass NULL to the prog for post-processing */
+	if (!v) {
+		__cgroup_iter_seq_show(seq, NULL, true);
+		p->visited_all = true;
+	}
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
+	p->visited_all = false;
+	p->order = aux->cgroup.order;
+	return 0;
+}
+
+static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
+	.seq_ops		= &cgroup_iter_seq_ops,
+	.init_seq_private	= cgroup_iter_seq_init,
+	.seq_priv_size		= sizeof(struct cgroup_iter_priv),
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
index 59a217ca2dfd..b8e0644bf43c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
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
+	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
+	 * ancestors of a given cgroup.
+	 */
+	struct {
+		/* Cgroup file descriptor. This is root of the subtree if walking
+		 * descendants; it's the starting cgroup if walking the ancestors.
+		 * If it is left 0, the traversal starts from the default cgroup v2
+		 * root. For walking v1 hierarchy, one should always explicitly
+		 * specify the cgroup_fd.
+		 */
+		__u32	cgroup_fd;
+		__u32	traversal_order;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,11 +6154,22 @@ struct bpf_link_info {
 		struct {
 			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
 			__u32 target_name_len;	   /* in/out: target_name buffer len */
+
+			/* If the iter specific field is 32 bits, it can be put
+			 * in the first or second union. Otherwise it should be
+			 * put in the second union.
+			 */
 			union {
 				struct {
 					__u32 map_id;
 				} map;
 			};
+			union {
+				struct {
+					__u64 cgroup_id;
+					__u32 traversal_order;
+				} cgroup;
+			};
 		} iter;
 		struct  {
 			__u32 netns_ino;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 5fce7008d1ff..604a40777cfa 100644
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
2.37.1.455.g008518b4e5-goog

