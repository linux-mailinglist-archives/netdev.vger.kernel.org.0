Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6758B14D
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiHEVtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiHEVtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:49:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A85F7B7A0
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 14:49:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m5-20020a2598c5000000b0066faab590c5so3041603ybo.7
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 14:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=jRQ+0kS3BTBBGvIFgwSUORt0aQ9BHZC04Nf8excWPsM=;
        b=ChF3h+hZpYfN/dZrEcNiR3cpKcFzgYLSVjY4ewXTfcLgk8NDHK4LVD1f3wbsJrT49M
         ru4VXucEjipc9AoIwW/przG5ggAtJipjZZHp423qiK6IK5tfa7YWPo3rA/MqLY6bmqTL
         Yuvo7N2xMhTrNwiYOva8VSfgn0P9BAz7U/x14Jpvt3kd8fhbwOu/4GnIyTCL0xnQT3gT
         /SHtTgI7WKwzGz2gjkDQHQjd1/BUD3q71wJzVahzAaoUDLIYUHES5GHRaYuWy9wYGHjl
         eAu+bwx5mwllz7EvezT+uxBaQVq27x3yYIqloqvEybN7WvxqRvEuTq/Zu71FVAlMAZKj
         CQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=jRQ+0kS3BTBBGvIFgwSUORt0aQ9BHZC04Nf8excWPsM=;
        b=6w2RV0P/chdMmDyN8g4MLjghB+h2lGtSFd2ajycUK9nbAdwofl+GRqr/hyh7o1pyAq
         ZTeBY+f12q2wimI4xe/6lyDJQMvcKi9gUlsuj81nK2XbA8hSOu0JBDcOXxvyckTvUy6A
         nJEwSMPJuvFNvp0uVLtv53fRuvZ8jkMwQfUSX2bDLTUlO1kHO9ix9mdBkjrOehQ8BIM7
         H0mMPiiitUqyfO+7nM7fN0U8x2S53W2EQK5yXE9SHpA/QA6reM1BD1UOABJfqKhnU1Y+
         X/qfR6j8FF3AnkJefCeWGfaRAJlHwxHcvZKpp8B6AoMyZkFJzTjjdPQnBCEt5v2UrwW3
         OHJA==
X-Gm-Message-State: ACgBeo2JjQM612HDlHCTNHSN5tfRHGC4jMZo0u4yg7awxunBru1ljl7z
        IwUWIGPr9yisAXXcHK5xGYGVzBHl9FM=
X-Google-Smtp-Source: AA6agR55ld0sRMI68ywvlMAMvuj/gy+QTpiHUgUMGXniT0TQpDeRMPNlawiYP1hmsEwVEzEl6DRiZqDlCgs=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:4f27:97db:8644:dc82])
 (user=haoluo job=sendgmr) by 2002:a05:6902:70e:b0:67b:7d78:5d3d with SMTP id
 k14-20020a056902070e00b0067b7d785d3dmr5127604ybt.547.1659736142180; Fri, 05
 Aug 2022 14:49:02 -0700 (PDT)
Date:   Fri,  5 Aug 2022 14:48:17 -0700
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
Message-Id: <20220805214821.1058337-5-haoluo@google.com>
Mime-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:

 - walking a cgroup's descendants in pre-order.
 - walking a cgroup's descendants in post-order.
 - walking a cgroup's ancestors.
 - process only the given cgroup.

When attaching cgroup_iter, one can set a cgroup to the iter_link
created from attaching. This cgroup is passed as a file descriptor
or cgroup id and serves as the starting point of the walk. If no
cgroup is specified, the starting point will be the root cgroup v2.

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
data is larger than the kernel buffer size, after all data in the
kernel buffer is consumed by user space, the subsequent read() syscall
will signal EOPNOTSUPP. In order to work around, the user may have to
update their program to reduce the volume of data sent to output. For
example, skip some uninteresting cgroups. In future, we may extend
bpf_iter flags to allow customizing buffer size.

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf.h                           |   8 +
 include/uapi/linux/bpf.h                      |  38 +++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 286 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  38 +++
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 6 files changed, 375 insertions(+), 2 deletions(-)
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
index 59a217ca2dfd..4d758b2e70d6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
 };
 
+enum bpf_iter_order {
+	BPF_ITER_ORDER_DEFAULT = 0,	/* default order. */
+	BPF_ITER_SELF,			/* process only a single object. */
+	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
+	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
+	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
+};
+
 union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		/* Valid values include:
+		 *  - BPF_ITER_ORDER_DEFAULT
+		 *  - BPF_ITER_SELF
+		 *  - BPF_ITER_DESCENDANTS_PRE
+		 *  - BPF_ITER_DESCENDANTS_POST
+		 *  - BPF_ITER_ANCESTORS_UP
+		 * for cgroup_iter, DEFAULT is equivalent to DESCENDANTS_PRE.
+		 */
+		__u32	order;
+
+		/* At most one of cgroup_fd and cgroup_id can be non-zero. If
+		 * both are zero, the walk starts from the default cgroup v2
+		 * root. For walking v1 hierarchy, one should always explicitly
+		 * specify cgroup_fd.
+		 */
+		__u32	cgroup_fd;
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,11 +6161,22 @@ struct bpf_link_info {
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
+					__u32 order;
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
index 000000000000..c469252d0536
--- /dev/null
+++ b/kernel/bpf/cgroup_iter.c
@@ -0,0 +1,286 @@
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
+/* cgroup_iter provides four modes of traversal to the cgroup hierarchy.
+ *
+ *  1. Walk the descendants of a cgroup in pre-order.
+ *  2. Walk the descendants of a cgroup in post-order.
+ *  3. Walk the ancestors of a cgroup.
+ *  4. Show the given cgroup only.
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
+ * is larger than the kernel buffer size, after all data in the kernel buffer
+ * is consumed by user space, the subsequent read() syscall will signal
+ * EOPNOTSUPP. In order to work around, the user may have to update their
+ * program to reduce the volume of data sent to output. For example, skip
+ * some uninteresting cgroups.
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
+	if (p->order == BPF_ITER_DESCENDANTS_PRE)
+		return css_next_descendant_pre(NULL, p->start_css);
+	else if (p->order == BPF_ITER_DESCENDANTS_POST)
+		return css_next_descendant_post(NULL, p->start_css);
+	else if (p->order == BPF_ITER_ANCESTORS_UP)
+		return p->start_css;
+	else /* BPF_ITER_SELF */
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
+	if (p->order == BPF_ITER_DESCENDANTS_PRE)
+		return css_next_descendant_pre(curr, p->start_css);
+	else if (p->order == BPF_ITER_DESCENDANTS_POST)
+		return css_next_descendant_post(curr, p->start_css);
+	else if (p->order == BPF_ITER_ANCESTORS_UP)
+		return curr->parent;
+	else  /* BPF_ITER_SELF */
+		return NULL;
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
+	u64 id = linfo->cgroup.cgroup_id;
+	int order = linfo->cgroup.order;
+	struct cgroup *cgrp;
+
+	if (order == BPF_ITER_ORDER_DEFAULT)
+		order = BPF_ITER_DESCENDANTS_PRE;
+
+	if (order != BPF_ITER_DESCENDANTS_PRE &&
+	    order != BPF_ITER_DESCENDANTS_POST &&
+	    order != BPF_ITER_ANCESTORS_UP &&
+	    order != BPF_ITER_SELF)
+		return -EINVAL;
+
+	if (fd && id)
+		return -EINVAL;
+
+	if (fd)
+		cgrp = cgroup_get_from_fd(fd);
+	else if (id)
+		cgrp = cgroup_get_from_id(id);
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
+	if (aux->cgroup.order == BPF_ITER_DESCENDANTS_PRE)
+		seq_puts(seq, "order: pre\n");
+	else if (aux->cgroup.order == BPF_ITER_DESCENDANTS_POST)
+		seq_puts(seq, "order: post\n");
+	else if (aux->cgroup.order == BPF_ITER_ANCESTORS_UP)
+		seq_puts(seq, "order: up\n");
+	else /* BPF_ITER_SELF */
+		seq_puts(seq, "order: self\n");
+}
+
+static int bpf_iter_cgroup_fill_link_info(const struct bpf_iter_aux_info *aux,
+					  struct bpf_link_info *info)
+{
+	info->iter.cgroup.order = aux->cgroup.order;
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
index 59a217ca2dfd..4d758b2e70d6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
 };
 
+enum bpf_iter_order {
+	BPF_ITER_ORDER_DEFAULT = 0,	/* default order. */
+	BPF_ITER_SELF,			/* process only a single object. */
+	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
+	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
+	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
+};
+
 union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		/* Valid values include:
+		 *  - BPF_ITER_ORDER_DEFAULT
+		 *  - BPF_ITER_SELF
+		 *  - BPF_ITER_DESCENDANTS_PRE
+		 *  - BPF_ITER_DESCENDANTS_POST
+		 *  - BPF_ITER_ANCESTORS_UP
+		 * for cgroup_iter, DEFAULT is equivalent to DESCENDANTS_PRE.
+		 */
+		__u32	order;
+
+		/* At most one of cgroup_fd and cgroup_id can be non-zero. If
+		 * both are zero, the walk starts from the default cgroup v2
+		 * root. For walking v1 hierarchy, one should always explicitly
+		 * specify cgroup_fd.
+		 */
+		__u32	cgroup_fd;
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -6134,11 +6161,22 @@ struct bpf_link_info {
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
+					__u32 order;
+				} cgroup;
+			};
 		} iter;
 		struct  {
 			__u32 netns_ino;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 5fce7008d1ff..84c1cfaa2b02 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -764,8 +764,8 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 
 	/* union with nested struct */
 	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
-			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
-			   { .map = { .map_fd = 1 }});
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},.cgroup = (struct){.order = (__u32)1,.cgroup_fd = (__u32)1,},}",
+			   { .cgroup = { .order = 1, .cgroup_fd = 1, }});
 
 	/* struct skb with nested structs/unions; because type output is so
 	 * complex, we don't do a string comparison, just verify we return
-- 
2.37.1.559.g78731f0fdb-goog

