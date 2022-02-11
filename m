Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5524B24F9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349740AbiBKL4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:56:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349737AbiBKL4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:56:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDC9EBD;
        Fri, 11 Feb 2022 03:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BBE7B828C7;
        Fri, 11 Feb 2022 11:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3517EC340EF;
        Fri, 11 Feb 2022 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580553;
        bh=/ceLyYUgo5D//sGNcrPm+ipEgbcJDRS33ngvk9SWe1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhPl9odlZtgWVxNz9FAjvH36WXvsurcm0jEOe6dCkupfkwHoFSkJup2SjZ/NMtgs0
         KOMR0027r6Bh2op/sY7VoLg0kHq7WrDLdksHEtl39fxsxTe9qPc5nBgcq92/bD5Tk6
         Fka7VNa7Vqw/PNwuRWUScZ8XJASAf53PdX1jBQG5xrJDp/PKWfjqFW1z4rQwtUgDlB
         WbUncn/i6bKLFTH4KHwBqBVvnn2c323Y50PyB2A/2hB68wrHtItfLkQZxCiq5rnY67
         XyScMpVJXuejY0MaaSl7HFNvkAPvGwrN7wi+ljgfcdYC5hOwU4etIyR4dIGtu7aMCE
         8Ab8fTm/IZ36A==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
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
Subject: [PATCH v8 09/11] fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
Date:   Fri, 11 Feb 2022 20:55:48 +0900
Message-Id: <164458054774.586276.10729358509653050241.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164458044634.586276.3261555265565111183.stgit@devnote2>
References: <164458044634.586276.3261555265565111183.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d733c0d9cb09..4881b98f35ab 100644
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
@@ -109,7 +123,10 @@ static unsigned long *get_ftrace_locations(const char **syms, int num)
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
 

