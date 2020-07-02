Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1B2119B5
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgGBBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgGBBkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 21:40:04 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A18C08C5C1;
        Wed,  1 Jul 2020 18:40:04 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e8so12651851pgc.5;
        Wed, 01 Jul 2020 18:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=51AUnoQ4Cnz88Kbm4onJmgeuZ1Abce+MfMXT9uG9jmA=;
        b=cdxiNcGVhWxXObTtYxl/9RVRQ2+z9RYQSijhVLa1JZ1T4kjecGPK2A1cQNdiOaJF5V
         UUphxBm1DhSMh/+q436D0wneCmhb4ZGY/8AtJBgV0crtt0Bbn+7cLxfDghh9C8SAM9TM
         xAUNL/AXuG9S0Jyqb9eSYccokdVEzH3D6S7EYDugGysdxC2uO8aC9YYq4FpzJT3TW5As
         H6AabWihCZzSPHRzti5n9vNpMikCRJLL1p8UuZlaBzYsFcEK20iAxPrlBx4lvMfmrxIo
         n48aozcY3t5G6URVn+f83f/qkM7U0QUr/6JcetopLl53kmwhP70Zsg065xmQH+Jj0qIw
         U8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=51AUnoQ4Cnz88Kbm4onJmgeuZ1Abce+MfMXT9uG9jmA=;
        b=tyvAkiG3GZBxViUT6kILruLZLLLxh/2/ORIrxQL2fAHEt9hUXS1OHq0ofBglUDE/2o
         VLMKQPMBcwbQXmxQZYpdQncDPEx3W37MdnBADL1CxSuputrUcRVOGB8Bn7+Rd4cqFF9X
         sA1F8ANuUL1mInhOTQRH4TG1NWgbF+qpKNbyz4eMAnC8kgcOnzvBXwdGA9qKt6fP9roV
         qDKhKN9Kp5gIRUvg8YQCxU3ryTzpmfjlblyTfc7sKLczU6b9ebV+kjnKamXC1W2Srah1
         x57lFNF6IhhL3h5jPLwTXhXhw9o9Gr25GKw9SLnvPHWstcfrT8vB1tPMQUWXt8VfijKx
         5O2A==
X-Gm-Message-State: AOAM531YXV9jZX0hNef5XMr0ZvRRD1lEPLKy52yoDA6+fhhLozERG37M
        F45B8LK8k9B4pco9VvDoNgE3Hg+B
X-Google-Smtp-Source: ABdhPJwZmZ4lExn+a3iT4LDtwexery19H+/aAN78rGMg1PNpZwfik+OmGTJnNvcL3/g2XHNGti17iA==
X-Received: by 2002:a63:ff54:: with SMTP id s20mr23343990pgk.251.1593654004179;
        Wed, 01 Jul 2020 18:40:04 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id c14sm6976669pfj.82.2020.07.01.18.40.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jul 2020 18:40:03 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Add bpf_prog iterator
Date:   Wed,  1 Jul 2020 18:40:01 -0700
Message-Id: <20200702014001.37945-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

It's mostly a copy paste of commit 6086d29def80 ("bpf: Add bpf_map iterator")
that is use to implement bpf_seq_file opreations to traverse all bpf programs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
No selftests?!
They're coming as part of "usermode_driver for iterators" set.
This patch is trivial and independent, so sending it first.

 include/linux/bpf.h    |   1 +
 kernel/bpf/Makefile    |   2 +-
 kernel/bpf/prog_iter.c | 102 +++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c   |  19 ++++++++
 4 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/prog_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0cd7f6884c5c..3c659f36591d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1112,6 +1112,7 @@ int  generic_map_delete_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
 			      union bpf_attr __user *uattr);
 struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
+struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 1131a921e1a6..e6eb9c0402da 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -2,7 +2,7 @@
 obj-y := core.o
 CFLAGS_core.o += $(call cc-disable-warning, override-init)
 
-obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
+obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
diff --git a/kernel/bpf/prog_iter.c b/kernel/bpf/prog_iter.c
new file mode 100644
index 000000000000..3080abd4d8ad
--- /dev/null
+++ b/kernel/bpf/prog_iter.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <linux/fs.h>
+#include <linux/filter.h>
+#include <linux/kernel.h>
+
+struct bpf_iter_seq_prog_info {
+	u32 mid;
+};
+
+static void *bpf_prog_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_prog_info *info = seq->private;
+	struct bpf_prog *prog;
+
+	prog = bpf_prog_get_curr_or_next(&info->mid);
+	if (!prog)
+		return NULL;
+
+	++*pos;
+	return prog;
+}
+
+static void *bpf_prog_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpf_iter_seq_prog_info *info = seq->private;
+	struct bpf_prog *prog;
+
+	++*pos;
+	++info->mid;
+	bpf_prog_put((struct bpf_prog *)v);
+	prog = bpf_prog_get_curr_or_next(&info->mid);
+	if (!prog)
+		return NULL;
+
+	return prog;
+}
+
+struct bpf_iter__bpf_prog {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct bpf_prog *, prog);
+};
+
+DEFINE_BPF_ITER_FUNC(bpf_prog, struct bpf_iter_meta *meta, struct bpf_prog *prog)
+
+static int __bpf_prog_seq_show(struct seq_file *seq, void *v, bool in_stop)
+{
+	struct bpf_iter__bpf_prog ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	ctx.meta = &meta;
+	ctx.prog = v;
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, in_stop);
+	if (prog)
+		ret = bpf_iter_run_prog(prog, &ctx);
+
+	return ret;
+}
+
+static int bpf_prog_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_prog_seq_show(seq, v, false);
+}
+
+static void bpf_prog_seq_stop(struct seq_file *seq, void *v)
+{
+	if (!v)
+		(void)__bpf_prog_seq_show(seq, v, true);
+	else
+		bpf_prog_put((struct bpf_prog *)v);
+}
+
+static const struct seq_operations bpf_prog_seq_ops = {
+	.start	= bpf_prog_seq_start,
+	.next	= bpf_prog_seq_next,
+	.stop	= bpf_prog_seq_stop,
+	.show	= bpf_prog_seq_show,
+};
+
+static const struct bpf_iter_reg bpf_prog_reg_info = {
+	.target			= "bpf_prog",
+	.seq_ops		= &bpf_prog_seq_ops,
+	.init_seq_private	= NULL,
+	.fini_seq_private	= NULL,
+	.seq_priv_size		= sizeof(struct bpf_iter_seq_prog_info),
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__bpf_prog, prog),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+};
+
+static int __init bpf_prog_iter_init(void)
+{
+	return bpf_iter_reg_target(&bpf_prog_reg_info);
+}
+
+late_initcall(bpf_prog_iter_init);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..e236a6c0aea4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3035,6 +3035,25 @@ struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
 	return map;
 }
 
+struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id)
+{
+	struct bpf_prog *prog;
+
+	spin_lock_bh(&prog_idr_lock);
+again:
+	prog = idr_get_next(&prog_idr, id);
+	if (prog) {
+		prog = bpf_prog_inc_not_zero(prog);
+		if (IS_ERR(prog)) {
+			(*id)++;
+			goto again;
+		}
+	}
+	spin_unlock_bh(&prog_idr_lock);
+
+	return prog;
+}
+
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
 
 struct bpf_prog *bpf_prog_by_id(u32 id)
-- 
2.23.0

