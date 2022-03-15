Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666074D9CE8
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348994AbiCOODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349014AbiCOODf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:03:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0C554F8E;
        Tue, 15 Mar 2022 07:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C655B81689;
        Tue, 15 Mar 2022 14:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E136EC340E8;
        Tue, 15 Mar 2022 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647352937;
        bh=11oxb9yaROPxs0+LsOoCAd2B2Rmo0siA0o2ZuHPqprA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaD/zg9jUn5eOTv9rixl6zPBx1oKNVDQwIlOUgsgpHKIwSn+8r/yqJk9Z9XYiiXoN
         hn4+MGm5n3OS1LQtQKHS+pyocqEXLn8t3rK3gGf5dIXiSOON4C9boTobQWeyfbJVkg
         XoVXS2fFkCx3jZmuTBMoIvYVHYbeLa5qcU5LwNf/E6tFjgXogoNU85ivM+HIGvf7AC
         k9yXz0FxOprLKpvcS6nyROgftj3hYj4DTcbPiRDcgMMPB9QYYlWsu+8WlrlAoi/2z2
         X3pVHtruVKn30Oh4OeYAg4KUnn90zV5utmVFMk4HTFynmL5oc4kCoc83KBGDauE47U
         pnHvo+ncPcEYg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v12 bpf-next 10/12] fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
Date:   Tue, 15 Mar 2022 23:02:11 +0900
Message-Id: <164735293127.1084943.15687374237275817599.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164735281449.1084943.12438881786173547153.stgit@devnote2>
References: <164735281449.1084943.12438881786173547153.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce FPROBE_FL_KPROBE_SHARED flag for sharing fprobe callback with
kprobes safely from the viewpoint of recursion.

Since the recursion safety of the fprobe (and ftrace) is a bit different
from the kprobes, this may cause an issue if user wants to run the same
code from the fprobe and the kprobes.

The kprobes has per-cpu 'current_kprobe' variable which protects the
kprobe handler from recursion in any case. On the other hand, the fprobe
uses only ftrace_test_recursion_trylock(), which will allow interrupt
context calls another (or same) fprobe during the fprobe user handler is
running.

This is not a matter in cases if the common callback shared among the
kprobes and the fprobe has its own recursion detection, or it can handle
the recursion in the different contexts (normal/interrupt/NMI.)
But if it relies on the 'current_kprobe' recursion lock, it has to check
kprobe_running() and use kprobe_busy_*() APIs.

Fprobe has FPROBE_FL_KPROBE_SHARED flag to do this. If your common callback
code will be shared with kprobes, please set FPROBE_FL_KPROBE_SHARED
*before* registering the fprobe, like;

 fprobe.flags = FPROBE_FL_KPROBE_SHARED;

 register_fprobe(&fprobe, "func*", NULL);

This will protect your common callback from the nested call.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/fprobe.h  |   12 ++++++++++++
 include/linux/kprobes.h |    3 +++
 kernel/trace/fprobe.c   |   19 ++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index 8eefec2b485e..1c2bde0ead73 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -34,13 +34,25 @@ struct fprobe {
 	void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
 };
 
+/* This fprobe is soft-disabled. */
 #define FPROBE_FL_DISABLED	1
 
+/*
+ * This fprobe handler will be shared with kprobes.
+ * This flag must be set before registering.
+ */
+#define FPROBE_FL_KPROBE_SHARED	2
+
 static inline bool fprobe_disabled(struct fprobe *fp)
 {
 	return (fp) ? fp->flags & FPROBE_FL_DISABLED : false;
 }
 
+static inline bool fprobe_shared_with_kprobes(struct fprobe *fp)
+{
+	return (fp) ? fp->flags & FPROBE_FL_KPROBE_SHARED : false;
+}
+
 #ifdef CONFIG_FPROBE
 int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter);
 int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num);
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 19b884353b15..5f1859836deb 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -427,6 +427,9 @@ static inline struct kprobe *kprobe_running(void)
 {
 	return NULL;
 }
+#define kprobe_busy_begin()	do {} while (0)
+#define kprobe_busy_end()	do {} while (0)
+
 static inline int register_kprobe(struct kprobe *p)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 38073632bfe4..8b2dd5b9dcd1 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -56,6 +56,20 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 }
 NOKPROBE_SYMBOL(fprobe_handler);
 
+static void fprobe_kprobe_handler(unsigned long ip, unsigned long parent_ip,
+				  struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct fprobe *fp = container_of(ops, struct fprobe, ops);
+
+	if (unlikely(kprobe_running())) {
+		fp->nmissed++;
+		return;
+	}
+	kprobe_busy_begin();
+	fprobe_handler(ip, parent_ip, ops, fregs);
+	kprobe_busy_end();
+}
+
 static void fprobe_exit_handler(struct rethook_node *rh, void *data,
 				struct pt_regs *regs)
 {
@@ -110,7 +124,10 @@ static unsigned long *get_ftrace_locations(const char **syms, int num)
 static void fprobe_init(struct fprobe *fp)
 {
 	fp->nmissed = 0;
-	fp->ops.func = fprobe_handler;
+	if (fprobe_shared_with_kprobes(fp))
+		fp->ops.func = fprobe_kprobe_handler;
+	else
+		fp->ops.func = fprobe_handler;
 	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
 }
 

