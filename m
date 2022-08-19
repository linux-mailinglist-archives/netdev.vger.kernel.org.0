Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D181459A873
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242222AbiHSW1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242215AbiHSW1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:27:06 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26700112331;
        Fri, 19 Aug 2022 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bwBb3Wqkav6yGYTcSOKgHtTuFq6y9W8T2JmU+7U+WFw=; b=FPIhhlYmbA7Ekd0SbUE79tFQuq
        sD7VF0K26UYnuYDL/GpMEqpIndV32PKyaEf3+hLJtzhpUgMvejS6b08pKh0EDi1XNiocxGbRtpA5A
        dFRzLqe44KDmWV0NpqXAEy1n9hNo/BgL5WhLnaSSGLFMIhjwuIGgJ6Y8f+5KmTj3+M6XIeLsawto5
        3LG9bcijhNeCZXf5dfWrlTxTUd8zrf3C8miCJGksaHHYASbw37n3YqclWfd35S5tONxjbfrzriRon
        GjsDoQlXa4+rQ3fkp03slSd7Di/jYXir/5aJghvsv9DM/e3vg/LUwdJt7Y35Nl7voPZEOsFUMntUi
        zWl13YyA==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAS8-00CbFM-Vn; Sat, 20 Aug 2022 00:26:59 +0200
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
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH V3 11/11] panic: Fixes the panic_print NMI backtrace setting
Date:   Fri, 19 Aug 2022 19:17:31 -0300
Message-Id: <20220819221731.480795-12-gpiccoli@igalia.com>
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

Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
introduced a setting for the "panic_print" kernel parameter to allow
users to request a NMI backtrace on panic. Problem is that the panic_print
handling happens after the secondary CPUs are already disabled, hence
this option ended-up being kind of a no-op - kernel skips the NMI trace
in idling CPUs, which is the case of offline CPUs.

Fix it by checking the NMI backtrace bit in the panic_print prior to
the CPU disabling function.

Fixes: 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
Cc: Feng Tang <feng.tang@intel.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- No changes.

V2:
- new patch, there was no V1 of this one.

Hi folks, thanks upfront for reviews. This is a new patch, fixing an issue
I found in my tests, so I shoved it into this fixes series.

Notice that while at it, I got rid of the "crash_kexec_post_notifiers"
local copy in panic(). This was introduced by commit b26e27ddfd2a
("kexec: use core_param for crash_kexec_post_notifiers boot option"),
but it is not clear from comments or commit message why this local copy
is required.

My understanding is that it's a mechanism to prevent some concurrency,
in case some other CPU modify this variable while panic() is running.
I find it very unlikely, hence I removed it - but if people consider
this copy needed, I can respin this patch and keep it, even providing a
comment about that, in order to be explict about its need.

Let me know your thoughts! Cheers,

Guilherme


 kernel/panic.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index c6eb8f8db0c0..b025a8f21c17 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -180,9 +180,6 @@ static void panic_print_sys_info(bool console_flush)
 		return;
 	}
 
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
-		trigger_all_cpu_backtrace();
-
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
@@ -199,6 +196,30 @@ static void panic_print_sys_info(bool console_flush)
 		ftrace_dump(DUMP_ALL);
 }
 
+/*
+ * Helper that triggers the NMI backtrace (if set in panic_print)
+ * and then performs the secondary CPUs shutdown - we cannot have
+ * the NMI backtrace after the CPUs are off!
+ */
+static void panic_other_cpus_shutdown(void)
+{
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
+	/*
+	 * Note that smp_send_stop() is the usual SMP shutdown function,
+	 * which unfortunately may not be hardened to work in a panic
+	 * situation. If we want to do crash dump after notifier calls
+	 * and kmsg_dump, we will need architecture dependent extra
+	 * bits in addition to stopping other CPUs, hence we rely on
+	 * crash_smp_send_stop() for that.
+	 */
+	if (!crash_kexec_post_notifiers)
+		smp_send_stop();
+	else
+		crash_smp_send_stop();
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -214,7 +235,6 @@ void panic(const char *fmt, ...)
 	long i, i_next = 0, len;
 	int state = 0;
 	int old_cpu, this_cpu;
-	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
 	if (panic_on_warn) {
 		/*
@@ -289,23 +309,10 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!_crash_kexec_post_notifiers) {
+	if (!crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
-		/*
-		 * Note smp_send_stop is the usual smp shutdown function, which
-		 * unfortunately means it may not be hardened to work in a
-		 * panic situation.
-		 */
-		smp_send_stop();
-	} else {
-		/*
-		 * If we want to do crash dump after notifier calls and
-		 * kmsg_dump, we will need architecture dependent extra
-		 * works in addition to stopping other CPUs.
-		 */
-		crash_smp_send_stop();
-	}
+	panic_other_cpus_shutdown();
 
 	/*
 	 * Run any panic handlers, including those that might need to
@@ -326,7 +333,7 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (_crash_kexec_post_notifiers)
+	if (crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
 #ifdef CONFIG_VT
-- 
2.37.2

