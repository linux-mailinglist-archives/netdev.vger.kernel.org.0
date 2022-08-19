Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0CD59A879
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241761AbiHSWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbiHSWW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:22:56 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01F10E7A9;
        Fri, 19 Aug 2022 15:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bzGFkTIN1eV205ENSSxwAqghJ7GC09NvM0cYNIKPVVQ=; b=AzhVCmuSU/fFLe+lgazLXq461g
        rWlTcBz9vzc3hztKuV11gnmPJswp6BdDA2jApg28Fy+Uo2w61g7jZlJSXeOqTAQYbVZxSGy9JipuB
        6w7S/xilAxGAmXMMVnsYag9AJ+2gUD82er23HSQWvozHBeiRK2SK9iQGsZSKhn9yyPpV8Pco+4beC
        LVCpCvRAuYF1FRW9z15Q1dRf5AvSGwUDCjCSlsSDONAkH3xZJOPZl/xFtZVkciKJXIQWlQoy0I/lV
        RZgBWuBnkOilm2cYi45ZELRyofmCUHbAX09+35QI1M15oTbM/cFqG5awxE9GY4iottk4EyI2EzvjL
        nk7fIA2w==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAO6-00Cb4O-O3; Sat, 20 Aug 2022 00:22:51 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, xuqiang36@huawei.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: [PATCH V3 06/11] tracing: Improve panic/die notifiers
Date:   Fri, 19 Aug 2022 19:17:26 -0300
Message-Id: <20220819221731.480795-7-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819221731.480795-1-gpiccoli@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the tracing dump_on_oops feature is implemented through
separate notifiers, one for die/oops and the other for panic;
given they have the same functionality, let's unify them.

Also improve the function comment and change the priority of the
notifier to make it execute earlier, avoiding showing useless trace
data (like the callback names for the other notifiers); finally,
we also removed an unnecessary header inclusion.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- Removed goto usage, as per Steven suggestion (thanks!).

V2:
- Different approach; instead of using IDs to distinguish die and
panic events, rely on address comparison like other notifiers do
and as per Petr's suggestion;

- Removed ACK from Steven since the code changed.


 kernel/trace/trace.c | 55 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d3005279165d..0bacdbcb132f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -19,7 +19,6 @@
 #include <linux/kallsyms.h>
 #include <linux/security.h>
 #include <linux/seq_file.h>
-#include <linux/notifier.h>
 #include <linux/irqflags.h>
 #include <linux/debugfs.h>
 #include <linux/tracefs.h>
@@ -9776,40 +9775,40 @@ static __init int tracer_init_tracefs(void)
 
 fs_initcall(tracer_init_tracefs);
 
-static int trace_panic_handler(struct notifier_block *this,
-			       unsigned long event, void *unused)
-{
-	if (ftrace_dump_on_oops)
-		ftrace_dump(ftrace_dump_on_oops);
-	return NOTIFY_OK;
-}
+static int trace_die_panic_handler(struct notifier_block *self,
+				unsigned long ev, void *unused);
 
 static struct notifier_block trace_panic_notifier = {
-	.notifier_call  = trace_panic_handler,
-	.next           = NULL,
-	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
+	.notifier_call = trace_die_panic_handler,
+	.priority = INT_MAX - 1,
 };
 
-static int trace_die_handler(struct notifier_block *self,
-			     unsigned long val,
-			     void *data)
-{
-	switch (val) {
-	case DIE_OOPS:
-		if (ftrace_dump_on_oops)
-			ftrace_dump(ftrace_dump_on_oops);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
 static struct notifier_block trace_die_notifier = {
-	.notifier_call = trace_die_handler,
-	.priority = 200
+	.notifier_call = trace_die_panic_handler,
+	.priority = INT_MAX - 1,
 };
 
+/*
+ * The idea is to execute the following die/panic callback early, in order
+ * to avoid showing irrelevant information in the trace (like other panic
+ * notifier functions); we are the 2nd to run, after hung_task/rcu_stall
+ * warnings get disabled (to prevent potential log flooding).
+ */
+static int trace_die_panic_handler(struct notifier_block *self,
+				unsigned long ev, void *unused)
+{
+	if (!ftrace_dump_on_oops)
+		return NOTIFY_DONE;
+
+	/* The die notifier requires DIE_OOPS to trigger */
+	if (self == &trace_die_notifier && ev != DIE_OOPS)
+		return NOTIFY_DONE;
+
+	ftrace_dump(ftrace_dump_on_oops);
+
+	return NOTIFY_DONE;
+}
+
 /*
  * printk is set to max of 1024, we really don't need it that big.
  * Nothing should be printing 1000 characters anyway.
-- 
2.37.2

