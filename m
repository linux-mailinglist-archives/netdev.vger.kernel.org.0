Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720AB52E1D9
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbiETBVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344414AbiETBVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:21:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8D429831
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d4-20020a170902c18400b001619cd42b0aso3349131pld.19
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qrx145uZheTwW5S3ogXKwTgZQSI1uZw5vSyKKikVhSA=;
        b=CAgIAB5LDMWdv//SxiQPXDjTJlwlbBN2rmSL+nPOHdEijE1xOdZXxikE5SFGVUzPQT
         kjSilKK8B+8JGiNJdgJJEQ1CXfsIqBrjW0AukAeEjIP6fvmaYKALizTzEEm9GEJdjGMh
         e277Rxzchd/dAtUR6iSQr+g0YeVpWZd6HO+Lqnrhii+s/ZSvwAjN+7EmQWlr+9+wg3M1
         Z+4FeTeZXJ6zzpQJYpoS6/l2SeuU13lgYxw9pwqsamHmU1v+X0NPvIBBZKg/srA8xqW1
         HXJudJNsY/+9ZEGpxckZsze5cBXJHIfINh7bx4uWYb3j4ghE8vYb6avCtaR6pi/MjReR
         bKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qrx145uZheTwW5S3ogXKwTgZQSI1uZw5vSyKKikVhSA=;
        b=6zl1hxgnnzRBNPwWKu6aJgEG7AmYVrzt8YR12pgi+Ma8pVin7JoZxEfdd20ScVwqay
         t+U6Q06wCeOAM3SLixgjmPS7+EHGVzzK9zyj0OEwx28ugTuo5S6pCLkyT4qgdLkDsxag
         fW73J1VSodfhtdpTk/JLtdLnEw8rtAmtM2Ozo8mzQ/gkZFjhi0T4lQTAEJ+vTp2z2+lj
         swSKJim35u8klnl7gILTmEGVi3ANiSMoUYc1gBrOdY8rujz9PyQodMJYPPPq1pY4Ax+a
         vQrOEFaPodlJAtpuAPl1A6ymkahFZ/HXRZN+vD4CjOqWJCaBxJ5PMU17F0kTjOfynhYv
         sVpw==
X-Gm-Message-State: AOAM532/nJrNC8tobGklT7l38Xsv6N+dUrSxuQA2cVQP8txEmwvUn53s
        qCbMi0iwGqacsAVVNf8w13EvRT7FeSNVE/uV
X-Google-Smtp-Source: ABdhPJxVt9kfrm7048uGAWHslUU6OTNJ04ersU8aLYVdcbVg3H9cOlpukOXF+BPyfd0JGwUqB8vULWOmNQBYFxat
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:1348:b0:518:6ef5:ac3 with SMTP
 id k8-20020a056a00134800b005186ef50ac3mr536051pfu.69.1653009703123; Thu, 19
 May 2022 18:21:43 -0700 (PDT)
Date:   Fri, 20 May 2022 01:21:31 +0000
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
Message-Id: <20220520012133.1217211-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
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
 kernel/bpf/Makefile            |   3 +
 kernel/bpf/cgroup_iter.c       | 148 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   6 ++
 5 files changed, 165 insertions(+)
 create mode 100644 kernel/bpf/cgroup_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..74c30fe20c23 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -44,6 +44,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct cgroup;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1581,6 +1582,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
+	struct cgroup *cgroup;
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0210f85131b3..e5bc40d4bccc 100644
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
@@ -5965,6 +5968,9 @@ struct bpf_link_info {
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
index 057ba8e01e70..3e563b163d49 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -36,6 +36,9 @@ obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
+ifeq ($(CONFIG_CGROUPS),y)
+obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
+endif
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
 $(obj)/relo_core.o: $(srctree)/tools/lib/bpf/relo_core.c FORCE
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
index 0210f85131b3..e5bc40d4bccc 100644
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
@@ -5965,6 +5968,9 @@ struct bpf_link_info {
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
2.36.1.124.g0e6072fb45-goog

