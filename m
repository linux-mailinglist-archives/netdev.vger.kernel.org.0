Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9D4B24FC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345988AbiBKL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:56:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242851AbiBKL4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:56:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CADEAE;
        Fri, 11 Feb 2022 03:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5FDDB829BA;
        Fri, 11 Feb 2022 11:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C156C340E9;
        Fri, 11 Feb 2022 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580576;
        bh=7sATuuDqAcojlAyHB1i8K/Qi0QaM5oTky+sMu4eAtfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dm6HKuEWUnquWuqoXpxq+42D8JDIUOl4q1uFhaDVZQqxD6PkD25qvi+UW5LVT/Ava
         U59vIgtZVE8GJnHnhsHBbcExdGkxGcaqkM+/pMqb+BN3bxdfioUbhuUiTbjYl3xfqh
         h2AC5OGhR3X8cRNsTVnX1QmCsK7mXeKS+YmKh9NfFep1Xa1pMCRIXLY2iBUPIyvgck
         MT3IFZYTSjCRWwHQyZPpG1++7pzm8H+NbAb/ayoYxWqJyMIB8DKxhFOAMVXY0kTboC
         92liNBZmufDMqOC+Ez1v3eUoHAKNF0tVPl6KSkftCzLnQdSGTyrKLTDo6GcvxWyQk8
         IFqmmgiRwE1Qg==
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
Subject: [PATCH v8 11/11] fprobe: Add a selftest for fprobe
Date:   Fri, 11 Feb 2022 20:56:11 +0900
Message-Id: <164458057084.586276.17748870220459914222.stgit@devnote2>
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

Add a KUnit based selftest for fprobe interface.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 lib/Kconfig.debug |   12 +++++
 lib/Makefile      |    2 +
 lib/test_fprobe.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+)
 create mode 100644 lib/test_fprobe.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 14b89aa37c5c..1506e47b521c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2100,6 +2100,18 @@ config KPROBES_SANITY_TEST
 
 	  Say N if you are unsure.
 
+config FPROBE_SANITY_TEST
+	tristate "Self test for fprobe"
+	depends on DEBUG_KERNEL
+	depends on FPROBE
+	depends on KUNIT
+	help
+	  This option will enable testing the fprobe when the system boot.
+	  A series of tests are made to verify that the fprobe is functioning
+	  properly.
+
+	  Say N if you are unsure.
+
 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 300f569c626b..154008764b16 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -103,6 +103,8 @@ obj-$(CONFIG_TEST_HMM) += test_hmm.o
 obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
+CFLAGS_test_fprobe.o += $(CC_FLAGS_FTRACE)
+obj-$(CONFIG_FPROBE_SANITY_TEST) += test_fprobe.o
 #
 # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
 # off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
diff --git a/lib/test_fprobe.c b/lib/test_fprobe.c
new file mode 100644
index 000000000000..8b98f1ed7863
--- /dev/null
+++ b/lib/test_fprobe.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * test_fprobe.c - simple sanity test for fprobe
+ */
+
+#include <linux/kernel.h>
+#include <linux/fprobe.h>
+#include <linux/random.h>
+#include <kunit/test.h>
+
+#define div_factor 3
+
+static struct kunit *current_test;
+
+static u32 rand1, entry_val, exit_val;
+
+/* Use indirect calls to avoid inlining the target functions */
+static u32 (*target)(u32 value);
+static u32 (*target2)(u32 value);
+
+static noinline u32 fprobe_target(u32 value)
+{
+	return (value / div_factor);
+}
+
+static noinline u32 fprobe_target2(u32 value)
+{
+	return (value / div_factor) + 1;
+}
+
+static notrace void fp_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	KUNIT_EXPECT_FALSE(current_test, preemptible());
+	/* This can be called on the fprobe_target and the fprobe_target2 */
+	if (ip != (unsigned long)fprobe_target)
+		KUNIT_EXPECT_EQ(current_test, ip, (unsigned long)fprobe_target2);
+	entry_val = (rand1 / div_factor);
+}
+
+static notrace void fp_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+{
+	unsigned long ret = regs_return_value(regs);
+
+	KUNIT_EXPECT_FALSE(current_test, preemptible());
+	if (ip != (unsigned long)fprobe_target) {
+		KUNIT_EXPECT_EQ(current_test, ip, (unsigned long)fprobe_target2);
+		KUNIT_EXPECT_EQ(current_test, ret, (rand1 / div_factor) + 1);
+	} else
+		KUNIT_EXPECT_EQ(current_test, ret, (rand1 / div_factor));
+	KUNIT_EXPECT_EQ(current_test, entry_val, (rand1 / div_factor));
+	exit_val = entry_val + div_factor;
+}
+
+static struct fprobe fp = {
+	.entry_handler = fp_entry_handler,
+	.exit_handler = fp_exit_handler,
+};
+
+static void test_fprobe(struct kunit *test)
+{
+	current_test = test;
+	KUNIT_EXPECT_EQ(test, 0, register_fprobe(&fp, "fprobe_target*", NULL));
+
+	entry_val = 0;
+	exit_val = 0;
+	target(rand1);
+	KUNIT_EXPECT_NE(test, 0, entry_val);
+	KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
+
+	entry_val = 0;
+	exit_val = 0;
+	target2(rand1);
+	KUNIT_EXPECT_NE(test, 0, entry_val);
+	KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
+
+	KUNIT_EXPECT_EQ(test, 0, unregister_fprobe(&fp));
+}
+
+static void test_fprobe_syms(struct kunit *test)
+{
+	const char *syms[] = {"fprobe_target", "fprobe_target2"};
+
+	current_test = test;
+	KUNIT_EXPECT_EQ(test, 0, register_fprobe_syms(&fp, syms, 2));
+
+	entry_val = 0;
+	exit_val = 0;
+	target(rand1);
+	KUNIT_EXPECT_NE(test, 0, entry_val);
+	KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
+
+	entry_val = 0;
+	exit_val = 0;
+	target2(rand1);
+	KUNIT_EXPECT_NE(test, 0, entry_val);
+	KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
+
+	KUNIT_EXPECT_EQ(test, 0, unregister_fprobe(&fp));
+}
+
+static int fprobe_test_init(struct kunit *test)
+{
+	do {
+		rand1 = prandom_u32();
+	} while (rand1 <= div_factor);
+	target = fprobe_target;
+	target2 = fprobe_target2;
+	return 0;
+}
+
+static struct kunit_case fprobe_testcases[] = {
+	KUNIT_CASE(test_fprobe),
+	KUNIT_CASE(test_fprobe_syms),
+	{}
+};
+
+static struct kunit_suite fprobe_test_suite = {
+	.name = "fprobe_test",
+	.init = fprobe_test_init,
+	.test_cases = fprobe_testcases,
+};
+
+kunit_test_suites(&fprobe_test_suite);
+
+MODULE_LICENSE("GPL");

