Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3404823F465
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgHGVaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgHGV3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:29:41 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63928C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:29:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v188so2386371qkb.17
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Xwhl6oTAS7prpbXCRZdZshg5xz57JrEbZ056Cu9NiLQ=;
        b=FbP0RxUpuIXc9TPHeycYqgrsWHy+edJZOunO3xzH9xgd3XMesTsydOHKMec+qxUJFA
         FlXnrJi21QCaDcqgirJGJT0eBkQ0v3Vq6LIzdTyTYf6I4CV8iPofNCGuawph3tfsMnfh
         rVST9SGjyClH8eIIJqualzLP+dJgXyLWWuF3VRTq6ejnpWajSiynlSZz5Y285bh+tnSW
         ZxEvaLhRHfrOvoRGHyx1uzFMrik/lFM8Yi0f5EOQG7sM80OuBBVAKF1eI2Nt5evM5J/V
         ZSfJtPKRCyz4Ary7BmVgPJgTRfuuh+/bHoAJlAFzxb/0O1Zu489t0ofM9yH0JSH6UL05
         9KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xwhl6oTAS7prpbXCRZdZshg5xz57JrEbZ056Cu9NiLQ=;
        b=it+aY2LuIPkLR+Ckefq5gldtoUI2G7t8HeJcRF1wI7/CJO7VHrTEqa/x8pbipTWPoe
         ngcfVhVrZgieiyJ1Kv2O7Mg1ii95Dh/MQH2S5INEx3AdivmFylD/joXwNlcYSHdcRaLx
         NfkwoLY5NImzwoGh01+MlY9v9m/GZXfhCR0sYMbn+9EMolvt4Azb+Fn5/68wpWyuCJ2C
         xPopzrk4YBgJ+hMfn11amseLtpAfWZXAyBo/JTYYrY4qy8nIXw42xcfpp9QonCon8hJs
         M2OC3tUw2TPRNGFeZ28U8VC+XZ3hGSklxyS4o9PmPYMjgxhFnNZstjC4g+Ek9lA5+Cyi
         +j0Q==
X-Gm-Message-State: AOAM533K6/53xsrTssshrjkmTWZ5dScxpKB3uJ4/7DoTomWvW6VGr91z
        SLA8tU1CMA8l9+6XrkddYbqC6X7HvFw=
X-Google-Smtp-Source: ABdhPJyLLX7R17IOCOR3CY0ZoHgSxM9yzJvgcbYl6HaF+KCt80M13Jn4ki0ErUlYpRFS5LWuyydOwJIuc87a
X-Received: by 2002:ad4:5502:: with SMTP id az2mr16402089qvb.148.1596835779896;
 Fri, 07 Aug 2020 14:29:39 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:12 -0700
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Message-Id: <20200807212916.2883031-4-jwadams@google.com>
Mime-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 3/7] core/metricfs: metric for kernel warnings
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count kernel warnings by function name of the caller.

Each time WARN() is called, which includes WARN_ON(), increment a counter
in a 256-entry hash table. The table key is the entry point of the calling
function, which is found using kallsyms.

We store the name of the function in the table (because it may be a
module address); reporting the metric just walks the table and prints
the values.

The "warnings" metric is cumulative.

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-rc6, removed google-isms,
	added lockdep_assert_held(), NMI handling, ..._unknown*_counts
	and locking in warn_tbl_fn(); renamed warn_metric... to
	warn_tbl...

	The original work was done in 2012 by an engineer no longer
	at Google.
---
 kernel/panic.c | 131 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index e2157ca387c8..c019b41ab387 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -31,6 +31,9 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/utsname.h>
+#include <linux/hash.h>
+#include <linux/metricfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -568,6 +571,133 @@ void oops_exit(void)
 	kmsg_dump(KMSG_DUMP_OOPS);
 }
 
+#ifdef CONFIG_METRICFS
+
+/*
+ * Hash table from function address to count of WARNs called within that
+ * function.
+ * So far this is an add-only hash table (ie, entries never removed), so some
+ * simplifying assumptions are made.
+ */
+#define WARN_TBL_BITS (8)
+#define WARN_TBL_SIZE (1<<WARN_TBL_BITS)
+static struct {
+	void *function;
+	int count;
+	char function_name[KSYM_NAME_LEN];
+} warn_tbl[WARN_TBL_SIZE];
+
+static DEFINE_SPINLOCK(warn_tbl_lock);
+static atomic_t warn_tbl_unknown_lookup_count = ATOMIC_INIT(0);
+static atomic_t warn_tbl_unknown_nmi_count = ATOMIC_INIT(0);
+static int warn_tbl_unknown_count;
+
+/*
+ * Find the entry corresponding to the given function address.
+ * Insert a new entry if one doesn't exist yet.
+ * Returns -1 if the hash table is full.
+ */
+static int tbl_find(void *caller_function)
+{
+	int entry, start_entry;
+
+	lockdep_assert_held(&warn_tbl_lock);
+
+	start_entry = hash_ptr(caller_function, WARN_TBL_BITS);
+	entry = start_entry;
+	do {
+		if (warn_tbl[entry].function == caller_function)
+			return entry;
+		if (warn_tbl[entry].function == NULL) {
+			if (!kallsyms_lookup((unsigned long)caller_function,
+					NULL, NULL, NULL,
+					warn_tbl[entry].function_name))
+				return -1;
+			warn_tbl[entry].function = caller_function;
+			return entry;
+		}
+		entry = (entry + 1) % (WARN_TBL_SIZE);
+	} while (entry != start_entry);
+
+	return -1;
+}
+
+static void tbl_increment(void *caller)
+{
+	void *caller_function;
+	unsigned long caller_offset;
+	unsigned long flags;
+	int entry;
+
+	if (!kallsyms_lookup_size_offset(
+			(unsigned long)caller, NULL, &caller_offset)) {
+		atomic_inc(&warn_tbl_unknown_lookup_count);
+		return;
+	}
+	/* use function entrypoint */
+	caller_function = caller - caller_offset;
+
+	if (in_nmi()) {
+		if (!spin_trylock_irqsave(&warn_tbl_lock, flags)) {
+			atomic_inc(&warn_tbl_unknown_nmi_count);
+			return;
+		}
+	} else {
+		spin_lock_irqsave(&warn_tbl_lock, flags);
+	}
+	entry = tbl_find(caller_function);
+	if (entry >= 0)
+		warn_tbl[entry].count++;
+	else
+		warn_tbl_unknown_count++;
+
+	spin_unlock_irqrestore(&warn_tbl_lock, flags);
+}
+
+/*
+ * Export the hash table to metricfs.
+ */
+static void warn_tbl_fn(struct metric_emitter *e)
+{
+	int i;
+	unsigned long flags;
+	int unknown_count = READ_ONCE(warn_tbl_unknown_count) +
+		atomic_read(&warn_tbl_unknown_nmi_count) +
+		atomic_read(&warn_tbl_unknown_lookup_count);
+
+	if (unknown_count != 0)
+		METRIC_EMIT_INT(e, unknown_count, "(unknown)", NULL);
+
+	spin_lock_irqsave(&warn_tbl_lock, flags);
+	for (i = 0; i < WARN_TBL_SIZE; i++) {
+		unsigned long fn = (unsigned long)warn_tbl[i].function;
+		const char *function_name = warn_tbl[i].function_name;
+		int count = warn_tbl[i].count;
+
+		if (!fn)
+			continue;
+
+		// function_name[] is constant once function is non-NULL
+		spin_unlock_irqrestore(&warn_tbl_lock, flags);
+		METRIC_EMIT_INT(e, count, function_name, NULL);
+		spin_lock_irqsave(&warn_tbl_lock, flags);
+	}
+	spin_unlock_irqrestore(&warn_tbl_lock, flags);
+}
+METRIC_EXPORT_COUNTER(warnings, "Count of calls to WARN().",
+		      "function", NULL, warn_tbl_fn);
+
+static int __init metricfs_panic_init(void)
+{
+	metric_init_warnings(NULL);
+	return 0;
+}
+late_initcall(metricfs_panic_init);
+
+#else  /* CONFIG_METRICFS */
+inline void tbl_increment(void *caller) {}
+#endif
+
 struct warn_args {
 	const char *fmt;
 	va_list args;
@@ -576,6 +706,7 @@ struct warn_args {
 void __warn(const char *file, int line, void *caller, unsigned taint,
 	    struct pt_regs *regs, struct warn_args *args)
 {
+	tbl_increment(caller);
 	disable_trace_on_warning();
 
 	if (file)
-- 
2.28.0.236.gb10cc79966-goog

