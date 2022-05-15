Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D4D5274F2
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiEOCfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiEOCfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:35:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA79FBF55
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x190-20020a6386c7000000b003d82199c4fdso5664303pgd.16
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YC2InFXwdRtQDPboyxfsyUWhY4pdSELhBce0hzw3bTk=;
        b=S+1kFWym/zN0rJudekoPvUvDDe7UznkyF8SCOJE4pOoY6ys9Cjzha6SrMSikpVNITA
         qMVIV+5G8bo4Eo+4tW+WsKUJR1Gi3b4QZj+BMMXcGIbuiXOdS6E/zhC9KNrtrJfsD7NF
         jZFfJNKlJlPYn8fXmpsZvFdJcQwpjhyOfQQPvEmmkNNhkAMz7Khtdpm6AsOcR513IN1m
         wfYwXH25ptqUui06Q9CjTBDKmb7BRUkvzInP8gx0BJw2j3IlZ4Wt3WjISXP1ndUrf2WJ
         6pjikGNl/J5x4KW89rpGiU/BqnoOmHf/4+xGLZttCoJFfqU+Fs2YuiXg8zRsDsUsj6hm
         8xfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YC2InFXwdRtQDPboyxfsyUWhY4pdSELhBce0hzw3bTk=;
        b=pHS5Iu/FDPVW8QmtjRSuVFCn1JoLVGzofSmIAuCD5I+pGhuq7BrWzjdTgGh6JjdKYw
         1gY1rvPvU8qVqm2QYEBqTetuFKQTl9RUvdC53rxaXen/7vd6GRAN8Yigq+QoAxGrpvdu
         7bfDgKsgYkxp/E1wHPuVYoN1M5zXMCEL0bwgVM6augKftOGIrpFOlmZlbJwiqD6uAxM2
         iCfNLNwTmMzCX8V1qmwZeXBTHBWtM3//viYWhl3O30PwinEJbeXDWtrbDr2xBefjtw+f
         KWwdBUvFaCNvF2humuFH84GdSbiBfqQDRCJQvgVfacqhJzN4tkasGySyX0xvuB55eUpy
         UtvQ==
X-Gm-Message-State: AOAM532q8V8c/uqP8Mtmk8lo2jYds82m86R4tnEUqV/3XSZUW3911zHe
        JJ50E140tWr972uv0oqAUXYcxVEfWn4kRduN
X-Google-Smtp-Source: ABdhPJwqr95MHkBE6vkF0FYJcNxo4nTNVNVgGU6dH9U7Nz3DXXdajDF+Tp0ZOs5jRbpk6+zaGyVlGvaV19h1ibTF
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:d88a:b0:156:1609:1e62 with SMTP
 id b10-20020a170902d88a00b0015616091e62mr11370656plz.143.1652582113258; Sat,
 14 May 2022 19:35:13 -0700 (PDT)
Date:   Sun, 15 May 2022 02:34:58 +0000
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
Message-Id: <20220515023504.1823463-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC PATCH bpf-next v2 1/7] bpf: introduce RSTAT_FLUSH program type
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new bpf program type, RSTAT_FLUSH,
with new corresponding link and attach types.

These programs acts as a callback for the rstat framework to call when a
stats flush is ongoing. It allows BPF programs to collect and maintain
hierarchical stats cgroup stats efficiently by integrating with the rstat
framework.

See the selftest in the final patch for a practical example.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf-rstat.h      |  25 +++++
 include/linux/bpf_types.h      |   4 +
 include/uapi/linux/bpf.h       |   9 ++
 kernel/bpf/Makefile            |   3 +
 kernel/bpf/rstat.c             | 166 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |   6 ++
 tools/include/uapi/linux/bpf.h |   9 ++
 7 files changed, 222 insertions(+)
 create mode 100644 include/linux/bpf-rstat.h
 create mode 100644 kernel/bpf/rstat.c

diff --git a/include/linux/bpf-rstat.h b/include/linux/bpf-rstat.h
new file mode 100644
index 000000000000..23cad23b5fc2
--- /dev/null
+++ b/include/linux/bpf-rstat.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2022 Google LLC.
+ */
+#ifndef _BPF_RSTAT_H_
+#define _BPF_RSTAT_H_
+
+#include <linux/bpf.h>
+
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_CGROUPS)
+
+int bpf_rstat_link_attach(const union bpf_attr *attr,
+				 struct bpf_prog *prog);
+
+#else /* defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_CGROUPS) */
+
+static inline int bpf_rstat_link_attach(const union bpf_attr *attr,
+					struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
+
+#endif /* defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_CGROUPS) */
+
+#endif  /* _BPF_RSTAT */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 2b9112b80171..ff92299f76a9 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -77,6 +77,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
 #endif
+#ifdef CONFIG_CGROUPS
+BPF_PROG_TYPE(BPF_PROG_TYPE_RSTAT_FLUSH, rstat_flush,
+	      struct bpf_rstat_flush_ctx, struct bpf_rstat_flush_ctx)
+#endif /* CONFIG_CGROUPS */
 BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 	      void *, void *)
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0210f85131b3..968e3cb02580 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_RSTAT_FLUSH,
 };
 
 enum bpf_attach_type {
@@ -998,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_RSTAT_FLUSH,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1014,6 +1016,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_PERF_EVENT = 7,
 	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 	BPF_LINK_TYPE_STRUCT_OPS = 9,
+	BPF_LINK_TYPE_RSTAT = 10,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -6359,6 +6362,12 @@ struct bpf_cgroup_dev_ctx {
 	__u32 minor;
 };
 
+struct bpf_rstat_flush_ctx {
+	__bpf_md_ptr(struct cgroup *, cgrp);
+	__bpf_md_ptr(struct cgroup *, parent);
+	__s32 cpu;
+};
+
 struct bpf_raw_tracepoint_args {
 	__u64 args[0];
 };
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 057ba8e01e70..0487133b799f 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -36,6 +36,9 @@ obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
+ifeq ($(CONFIG_CGROUPS),y)
+obj-$(CONFIG_BPF_SYSCALL) += rstat.o
+endif
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
 $(obj)/relo_core.o: $(srctree)/tools/lib/bpf/relo_core.c FORCE
diff --git a/kernel/bpf/rstat.c b/kernel/bpf/rstat.c
new file mode 100644
index 000000000000..5f529002d4b9
--- /dev/null
+++ b/kernel/bpf/rstat.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Functions to manage eBPF programs attached to cgroup subsystems
+ *
+ * Copyright 2022 Google LLC.
+ */
+
+#include <linux/bpf-rstat.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/filter.h>
+
+static LIST_HEAD(bpf_rstat_flushers);
+static DEFINE_SPINLOCK(bpf_rstat_flushers_lock);
+
+
+struct bpf_rstat_flusher {
+	struct bpf_prog *prog;
+	/* List of BPF rtstat flushers, anchored at subsys->bpf */
+	struct list_head list;
+};
+
+struct bpf_rstat_link {
+	struct bpf_link link;
+	struct bpf_rstat_flusher *flusher;
+};
+
+static int bpf_rstat_flush_attach(struct bpf_prog *prog,
+				  struct bpf_rstat_link *rlink)
+{
+	struct bpf_rstat_flusher *flusher;
+
+	flusher = kmalloc(sizeof(*flusher), GFP_KERNEL);
+	if (!flusher)
+		return -ENOMEM;
+
+	flusher->prog = prog;
+	rlink->flusher = flusher;
+
+	spin_lock(&bpf_rstat_flushers_lock);
+	list_add(&flusher->list, &bpf_rstat_flushers);
+	spin_unlock(&bpf_rstat_flushers_lock);
+
+	return 0;
+}
+
+static void bpf_rstat_flush_detach(struct bpf_rstat_link *rstat_link)
+{
+	struct bpf_rstat_flusher *flusher = rstat_link->flusher;
+
+	if (!flusher)
+		return;
+
+	spin_lock(&bpf_rstat_flushers_lock);
+	list_del(&flusher->list);
+	bpf_prog_put(flusher->prog);
+	kfree(flusher);
+	spin_unlock(&bpf_rstat_flushers_lock);
+}
+
+static const struct bpf_func_proto *
+bpf_rstat_flush_func_proto(enum bpf_func_id func_id,
+			   const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+BTF_ID_LIST_SINGLE(bpf_cgroup_btf_ids, struct, cgroup)
+
+static bool bpf_rstat_flush_is_valid_access(int off, int size,
+					    enum bpf_access_type type,
+					    const struct bpf_prog *prog,
+					    struct bpf_insn_access_aux *info)
+{
+	if (type == BPF_WRITE)
+		return false;
+
+	if (off < 0 || off + size > sizeof(struct bpf_rstat_flush_ctx))
+		return false;
+	/* The verifier guarantees that size > 0 */
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range_ptr(struct bpf_rstat_flush_ctx, cgrp):
+		info->reg_type = PTR_TO_BTF_ID;
+		info->btf_id = bpf_cgroup_btf_ids[0];
+		info->btf = bpf_get_btf_vmlinux();
+		return !IS_ERR(info->btf) && info->btf && size == sizeof(__u64);
+	case bpf_ctx_range_ptr(struct bpf_rstat_flush_ctx, parent):
+		info->reg_type = PTR_TO_BTF_ID_OR_NULL;
+		info->btf_id = bpf_cgroup_btf_ids[0];
+		info->btf = bpf_get_btf_vmlinux();
+		return !IS_ERR(info->btf) && info->btf && size == sizeof(__u64);
+	case bpf_ctx_range(struct bpf_rstat_flush_ctx, cpu):
+		return size == sizeof(__s32);
+	default:
+		return false;
+	}
+}
+
+const struct bpf_prog_ops rstat_flush_prog_ops = {
+};
+
+const struct bpf_verifier_ops rstat_flush_verifier_ops = {
+	.get_func_proto         = bpf_rstat_flush_func_proto,
+	.is_valid_access        = bpf_rstat_flush_is_valid_access,
+};
+
+static void bpf_rstat_link_release(struct bpf_link *link)
+{
+	struct bpf_rstat_link *rlink;
+
+	rlink = container_of(link,
+			     struct bpf_rstat_link,
+			     link);
+
+	/* rstat flushers are currently the only supported rstat programs */
+	bpf_rstat_flush_detach(rlink);
+}
+
+static void bpf_rstat_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_rstat_link *rlink = container_of(link,
+						    struct bpf_rstat_link,
+						    link);
+	kfree(rlink);
+}
+
+static const struct bpf_link_ops bpf_rstat_link_lops = {
+	.release = bpf_rstat_link_release,
+	.dealloc = bpf_rstat_link_dealloc,
+};
+
+int bpf_rstat_link_attach(const union bpf_attr *attr,
+			  struct bpf_prog *prog)
+{
+	struct bpf_link_primer link_primer;
+	struct bpf_rstat_link *link;
+	int err;
+
+	if (attr->link_create.target_fd || attr->link_create.flags)
+		return -EINVAL;
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		return -ENOMEM;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_RSTAT,
+		      &bpf_rstat_link_lops, prog);
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		return err;
+	}
+
+	/* rstat flushers are currently the only supported rstat programs */
+	err = bpf_rstat_flush_attach(prog, link);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 72e53489165d..ffeed8379b35 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3,6 +3,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/bpf-rstat.h>
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
 #include <linux/bpf_verifier.h>
@@ -3416,6 +3417,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_RSTAT_FLUSH:
+		return BPF_PROG_TYPE_RSTAT_FLUSH;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -4564,6 +4567,9 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		else
 			ret = bpf_kprobe_multi_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_RSTAT_FLUSH:
+		ret = bpf_rstat_link_attach(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0210f85131b3..968e3cb02580 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_RSTAT_FLUSH,
 };
 
 enum bpf_attach_type {
@@ -998,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_TRACE_KPROBE_MULTI,
+	BPF_RSTAT_FLUSH,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1014,6 +1016,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_PERF_EVENT = 7,
 	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 	BPF_LINK_TYPE_STRUCT_OPS = 9,
+	BPF_LINK_TYPE_RSTAT = 10,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -6359,6 +6362,12 @@ struct bpf_cgroup_dev_ctx {
 	__u32 minor;
 };
 
+struct bpf_rstat_flush_ctx {
+	__bpf_md_ptr(struct cgroup *, cgrp);
+	__bpf_md_ptr(struct cgroup *, parent);
+	__s32 cpu;
+};
+
 struct bpf_raw_tracepoint_args {
 	__u64 args[0];
 };
-- 
2.36.0.550.gb090851708-goog

