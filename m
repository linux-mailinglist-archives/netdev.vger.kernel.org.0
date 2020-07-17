Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA12E223277
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGQEkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgGQEkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:40:36 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69D8C061755;
        Thu, 16 Jul 2020 21:40:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so4919261plr.8;
        Thu, 16 Jul 2020 21:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pokozdlnHNYbQDWcF5MJ4qlGuX8CtKIE8qtwic6TMDk=;
        b=A/2wug6Xd4Q05AkzWtnmO3Unq/UPp5zMPs9kGl8pzuO18zZnooXyC7MHbB63df90zB
         bdkI0Q9TD7C17pKSTjBjgAXgnPE1tcSZcvExgrwpSq2cCSE4kI6iHFdw4onYtSpe2lfe
         5hXAIiKu+iQh7bC7cH2ZTKuYY20KLTOKbmH52G7L8DV/uaNMobWSMf2BaNKQwzH3eyI5
         Ge8vzunk3b6UbshaGFo8GPB7z5EOQGrsBCSeZvyrEqB1uqAZkEiwfSPGGo32/pLZ1g8/
         4xSlkdhRyGmJYEp4bQeDh/HCsvwprdIDdawPElZ7GBbLC2bH4Xj8IZekEVgDJoFceOUI
         C/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pokozdlnHNYbQDWcF5MJ4qlGuX8CtKIE8qtwic6TMDk=;
        b=e7JDTJi9elHXpz8TrgBUhDLEoLk/HSB7dzmheLhcFhP1a7GPV3UJA8PZrpg57nv+1e
         oFWkA3tE6N64Sd59LFdoVmG2KnAP5nNl/DYsGhlB/ptDtBez3Cbu4PNy+mpeGUe+3F+N
         7rlKMehPrS+kZReUILBHzri2/oxDt2WR8e9n8v+9b5hoN8t8WmCR1AAD6HsC8/MNCku1
         jJ/vEaMuVEMNAxjePBaSv6HQgVbVLI52qLf6KV1FXGLVntPz+/MQRfb1mMewn1FKmPfX
         EAwwX9DjTcsC88K+O8hKzVDWRujvoCU+6atTBnyqO+hGPlMgSNd3jxxldeBx4JePIYZv
         CXEg==
X-Gm-Message-State: AOAM530iu9zVZdQVii5XHAwTCvOYcGkMRsbKAtX/PvYt29dQwbtZzEbq
        LhI9GDg057IpgcbpjaYWDII=
X-Google-Smtp-Source: ABdhPJwyKNzIc/Zr/z7ZxkRW4aYZ6FQ/teSkb+fvz0ezxJ39mYiN3V/vrbytTx84k7j4C49WWvjmAA==
X-Received: by 2002:a17:902:7809:: with SMTP id p9mr5822681pll.96.1594960836152;
        Thu, 16 Jul 2020 21:40:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e5sm1335389pjy.26.2020.07.16.21.40.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 21:40:35 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/4] bpf: Add bpf_prog iterator
Date:   Thu, 16 Jul 2020 21:40:28 -0700
Message-Id: <20200717044031.56412-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
References: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

It's mostly a copy paste of commit 6086d29def80 ("bpf: Add bpf_map iterator")
that is use to implement bpf_seq_file opreations to traverse all bpf programs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h    |  1 +
 kernel/bpf/Makefile    |  2 +-
 kernel/bpf/map_iter.c  | 13 ++----
 kernel/bpf/prog_iter.c | 97 ++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c   | 19 +++++++++
 5 files changed, 122 insertions(+), 10 deletions(-)
 create mode 100644 kernel/bpf/prog_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c67c88ad35f8..4ede2b0298b3 100644
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
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index c69071e334bf..343c1df100cf 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -6,7 +6,7 @@
 #include <linux/kernel.h>
 
 struct bpf_iter_seq_map_info {
-	u32 mid;
+	u32 map_id;
 };
 
 static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
@@ -14,7 +14,7 @@ static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
 	struct bpf_iter_seq_map_info *info = seq->private;
 	struct bpf_map *map;
 
-	map = bpf_map_get_curr_or_next(&info->mid);
+	map = bpf_map_get_curr_or_next(&info->map_id);
 	if (!map)
 		return NULL;
 
@@ -25,16 +25,11 @@ static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
 static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct bpf_iter_seq_map_info *info = seq->private;
-	struct bpf_map *map;
 
 	++*pos;
-	++info->mid;
+	++info->map_id;
 	bpf_map_put((struct bpf_map *)v);
-	map = bpf_map_get_curr_or_next(&info->mid);
-	if (!map)
-		return NULL;
-
-	return map;
+	return bpf_map_get_curr_or_next(&info->map_id);
 }
 
 struct bpf_iter__bpf_map {
diff --git a/kernel/bpf/prog_iter.c b/kernel/bpf/prog_iter.c
new file mode 100644
index 000000000000..b5824382eb7d
--- /dev/null
+++ b/kernel/bpf/prog_iter.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <linux/fs.h>
+#include <linux/filter.h>
+#include <linux/kernel.h>
+
+struct bpf_iter_seq_prog_info {
+	u32 prog_id;
+};
+
+static void *bpf_prog_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_prog_info *info = seq->private;
+	struct bpf_prog *prog;
+
+	prog = bpf_prog_get_curr_or_next(&info->prog_id);
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
+
+	++*pos;
+	++info->prog_id;
+	bpf_prog_put((struct bpf_prog *)v);
+	return bpf_prog_get_curr_or_next(&info->prog_id);
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
index 7ea9dfbebd8c..86df3daa13f6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3036,6 +3036,25 @@ struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
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

