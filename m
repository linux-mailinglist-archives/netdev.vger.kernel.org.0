Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027655274FF
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiEOCfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiEOCfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:35:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7366C95B7
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e4-20020a635004000000b003f252bb65faso269401pgb.2
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mivptsETNqNDdcSME2iU77WtyhUxYujtfDC8wYBwYo8=;
        b=rMya0QjL40CIpu8Uv/ByKWJyDrwJG5QrMXKxZNnicY5ZklKuCvsXB5oQ2U+Z5FoVPS
         NNID7KJ++02OQhQGC/O7udgQAt+/sF5cjRYPZqcf8Mj7qgc9httTO8QX5l1pGxivwgop
         eXCz8XpLdo0k56s/4Xp2sMxYTBtxDAeEU1Lt4gvtI33dWiQaKbR2O99nlVMoQRoVY7s7
         BBXZvaQSBFuYR6uMsX3D3mTwWX1M9QSzWMCbRG5fP5THFSoKblyRNfBoPrTCL9dO8hF1
         PEq0BiUdinr0dtZQK4V8fQBCrsCqIWbguGR/Jzq4tqE9PEOy01Xl8+B35dPbm6xq8IrW
         +B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mivptsETNqNDdcSME2iU77WtyhUxYujtfDC8wYBwYo8=;
        b=Vpqx6+osDA30sIi3Bn1elFBlvHrxhHaGnTPSQ28Vdkz5TEkr7NZCt07m5N1k3PrGLm
         iCPP0KSjgcRaEQ5YnvuBvLW4IIv2mgxYnGTIgD6fxs0wZI9M7VNuuLlvW2VdNa2CxjUa
         H8unUqyfclO3VB0dC4ubyG2U50FNW5pte+Xsxhtx3SlCW4yqR6puSj88KZIaCLa/IoUy
         VfwBiDQE02iDAbFjXY/ZyKLI6KwwvbtSdB9GeM0/wHgBoGCY0XSRJLU2p2OgRZXDBH1r
         CccfOZeGR3jzbDj/N7Xr2jGFUafxag6P6zyqrZQ3gxq05fbXwACfGWch48+P7a3Lkcel
         1dZQ==
X-Gm-Message-State: AOAM530AsBovcw03pe8ua+Bgb5VchhzZ1PwBYGwpI4Siqjy6FKCoLWgr
        oLw+2KZcD71M+XIb2upl3qEice2i/wEysRxl
X-Google-Smtp-Source: ABdhPJwounggXga93PA2rBarvjkcnVYOVj3yjgHbf+4I8K2y2Goh8JfuUZYlGSM5QCQ9r6xCJ8cAfkvFDofNY+Iu
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:903:24f:b0:15c:e3b8:a640 with SMTP
 id j15-20020a170903024f00b0015ce3b8a640mr11562712plh.5.1652582119956; Sat, 14
 May 2022 19:35:19 -0700 (PDT)
Date:   Sun, 15 May 2022 02:35:02 +0000
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
Message-Id: <20220515023504.1823463-6-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC PATCH bpf-next v2 5/7] bpf: Introduce cgroup iter
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
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

Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
iter doesn't iterate a set of kernel objects. Instead, it is supposed to
be parameterized by a cgroup id and prints only that cgroup. So one
needs to specify a target cgroup id when attaching this iter. The target
cgroup's state can be read out via a link of this iter.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf.h            |   2 +
 include/uapi/linux/bpf.h       |   6 ++
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/cgroup_iter.c       | 148 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   6 ++
 5 files changed, 163 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/cgroup_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ca908a731cb4..45076c581f24 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -44,6 +44,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct cgroup;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1579,6 +1580,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
+	struct cgroup *cgroup;
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 022522174286..9a93b72bf39c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -5986,6 +5989,9 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 0487133b799f..f2a6fd0633d6 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -37,7 +37,7 @@ obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
 ifeq ($(CONFIG_CGROUPS),y)
-obj-$(CONFIG_BPF_SYSCALL) += rstat.o
+obj-$(CONFIG_BPF_SYSCALL) += rstat.o cgroup_iter.o
 endif
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
new file mode 100644
index 000000000000..86bdfe135d24
--- /dev/null
+++ b/kernel/bpf/cgroup_iter.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Google */
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+
+struct bpf_iter__cgroup {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct cgroup *, cgroup);
+};
+
+static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	/* Only one session is supported. */
+	if (*pos > 0)
+		return NULL;
+
+	if (*pos == 0)
+		++*pos;
+
+	return *(struct cgroup **)seq->private;
+}
+
+static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter__cgroup ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	ctx.meta = &meta;
+	ctx.cgroup = v;
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, false);
+	if (prog)
+		ret = bpf_iter_run_prog(prog, &ctx);
+
+	return ret;
+}
+
+static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
+{
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
+static int cgroup_iter_seq_init(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	*(struct cgroup **)priv_data = aux->cgroup;
+	return 0;
+}
+
+static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
+	.seq_ops                = &cgroup_iter_seq_ops,
+	.init_seq_private       = cgroup_iter_seq_init,
+	.seq_priv_size          = sizeof(struct cgroup *),
+};
+
+static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
+				  union bpf_iter_link_info *linfo,
+				  struct bpf_iter_aux_info *aux)
+{
+	struct cgroup *cgroup;
+
+	cgroup = cgroup_get_from_id(linfo->cgroup.cgroup_id);
+	if (!cgroup)
+		return -EBUSY;
+
+	aux->cgroup = cgroup;
+	return 0;
+}
+
+static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
+{
+	if (aux->cgroup)
+		cgroup_put(aux->cgroup);
+}
+
+static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
+					struct seq_file *seq)
+{
+	char *buf;
+
+	seq_printf(seq, "cgroup_id:\t%llu\n", cgroup_id(aux->cgroup));
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf) {
+		seq_puts(seq, "cgroup_path:\n");
+		return;
+	}
+
+	/* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
+	 * will print nothing.
+	 *
+	 * Cgroup_path is the path in the calliing process's cgroup namespace.
+	 */
+	cgroup_path_ns(aux->cgroup, buf, sizeof(buf),
+		       current->nsproxy->cgroup_ns);
+	seq_printf(seq, "cgroup_path:\t%s\n", buf);
+	kfree(buf);
+}
+
+static int bpf_iter_cgroup_fill_link_info(const struct bpf_iter_aux_info *aux,
+					  struct bpf_link_info *info)
+{
+	info->iter.cgroup.cgroup_id = cgroup_id(aux->cgroup);
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
+		  PTR_TO_BTF_ID },
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
index 022522174286..9a93b72bf39c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -5986,6 +5989,9 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
-- 
2.36.0.550.gb090851708-goog

