Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0723259A863
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241906AbiHSWXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241767AbiHSWXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:23:33 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEED2CDC8;
        Fri, 19 Aug 2022 15:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d2an8K4S3oBRBmk7SIJDz4Oai1o8VvWFhnH8gpD08U0=; b=X2+kGd13kauJptBzv6orQ1U7yS
        4aVfkn5eFTKuYn33XLrObdbdfBscRW7PnPpTi00KjX722oTJFFbDGBByOFk/diOtlqyJUfXp1qqtk
        wdAyoKW3PdYKCTsCYnvnraOEqwCd466jDzHdiLOwLKF9ZjNoUljXl9a8OK3JS3DA64x+It+MtEgjo
        9j46jITNnxNXwQM8p6iXaD+6u+VxqJqBPZbsVtVKQDuWHrqQ2/urSChnRWiPaMvc2L+ukkn4Fmyax
        j1lFef3s95ENI6oiTnHSrbeqhX4dTAauX2TwiB5awED4vpx4s2jm8I3rnXNRpHJaRpI5R0QmdmdLU
        O+2sMEDw==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAOh-00Cb6O-5U; Sat, 20 Aug 2022 00:23:25 +0200
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
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
Subject: [PATCH V3 07/11] notifiers: Add tracepoints to the notifiers infrastructure
Date:   Fri, 19 Aug 2022 19:17:27 -0300
Message-Id: <20220819221731.480795-8-gpiccoli@igalia.com>
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

Currently there is no way to show the callback names for registered,
unregistered or executed notifiers. This is very useful for debug
purposes, hence add this functionality here in the form of notifiers'
tracepoints, one per operation.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- Yet another major change - thanks to Arjan's great suggestion,
refactored the code to make use of tracepoints instead of guarding
the output with a Kconfig debug setting.

V2:
- Major improvement thanks to the great idea from Xiaoming - changed
all the ksym wheel reinvention to printk %ps modifier;

- Instead of ifdefs, using IS_ENABLED() - thanks Steven.

- Removed an unlikely() hint on debug path.


 include/trace/events/notifiers.h | 69 ++++++++++++++++++++++++++++++++
 kernel/notifier.c                |  6 +++
 2 files changed, 75 insertions(+)
 create mode 100644 include/trace/events/notifiers.h

diff --git a/include/trace/events/notifiers.h b/include/trace/events/notifiers.h
new file mode 100644
index 000000000000..e8f30631aef5
--- /dev/null
+++ b/include/trace/events/notifiers.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM notifiers
+
+#if !defined(_TRACE_NOTIFIERS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NOTIFIERS_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(notifiers_info,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb),
+
+	TP_STRUCT__entry(
+		__field(void *, cb)
+	),
+
+	TP_fast_assign(
+		__entry->cb = cb;
+	),
+
+	TP_printk("%ps", __entry->cb)
+);
+
+/*
+ * notifiers_register - called upon notifier callback registration
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_register,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+/*
+ * notifiers_unregister - called upon notifier callback unregistration
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_unregister,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+/*
+ * notifiers_run - called upon notifier callback execution
+ *
+ * @cb:		callback pointer
+ *
+ */
+DEFINE_EVENT(notifiers_info, notifiers_run,
+
+	TP_PROTO(void *cb),
+
+	TP_ARGS(cb)
+);
+
+#endif /* _TRACE_NOTIFIERS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 0d5bd62c480e..2f2783f59a31 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -7,6 +7,9 @@
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/notifiers.h>
+
 /*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
@@ -37,6 +40,7 @@ static int notifier_chain_register(struct notifier_block **nl,
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
+	trace_notifiers_register((void*)n->notifier_call);
 	return 0;
 }
 
@@ -46,6 +50,7 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
+			trace_notifiers_unregister((void*)n->notifier_call);
 			return 0;
 		}
 		nl = &((*nl)->next);
@@ -84,6 +89,7 @@ static int notifier_call_chain(struct notifier_block **nl,
 			continue;
 		}
 #endif
+		trace_notifiers_run((void*)nb->notifier_call);
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
-- 
2.37.2

