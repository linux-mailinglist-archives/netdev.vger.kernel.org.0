Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4479D465CA4
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355169AbhLBDZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355151AbhLBDZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34938C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:21:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s37so15974755pga.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FgGjzv1NIC92hODa2gbn4h153F1HGBrv6ma2SYdMaOA=;
        b=HoxiYC9ox6fj/PblhfFjDbk8rjiLgKL3SEdB6V8AbljJxivTguhFa/myqb2/4Uweij
         EpNVXj8Cqp18V30+DjPOsD4oOnGurfmJMvO4DM4Q7IsjKeulZZmDhMuzmb4KpxfidbCT
         rHAfbMLCEHX0AMrZlIOVsO1BrLOjf05L2wNAg0qSUJpss6XF7HyYLm6SjdjrSbxAVV+3
         gPQrue1dWGCQQk4NmJAQYfYPYmtPeb9h28ZkbrWutkOckGJji/VCmFW0yF9F/ndcjghr
         SEl5FBm3dPir/DojqEewR0fDoaVVj9K79c2+qFcZGkdoQlhE2HY7O4uOGXxnopYf1D+S
         vXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FgGjzv1NIC92hODa2gbn4h153F1HGBrv6ma2SYdMaOA=;
        b=hrLxdTVYaDewpNcOBaBMUJw/JAubQQeyTBq/3AwBOZjsJd9B08wjkX19Em+BzIYYqW
         OFs9JY1rtou6TT1TPgPIAu70rYjh38TuhWYIoqU2UYIlxD0t44+YhwR004NeOJXnnJFU
         yfUFakulVEg/KFcyfkfhgcIgG/UeJQSJR7GItDwAJwF9jnrT/Qp64i+8g+3HpaD/opE6
         U+NVf1V67IaXLy5eGJ3nr5yvzE68DSLqaqfFhOUkU+0gi6a/6AflOsdzB139p4jPmNLv
         VHi0LWy8UYMUa2CpuQ8CyZgcwdD2H6xuRcM/UGq1Zm9YbrVEHbyTo4ZhAfgUZU1MCxUg
         djUw==
X-Gm-Message-State: AOAM533MSrrJINqr2t8aWNTzKUJg2Q+vvoeCczTtgzY/mccRQ6kunM/c
        Wdg2QuOTISjEqukQnHT8nfw=
X-Google-Smtp-Source: ABdhPJzZ5drDOIadDcQDm4vqT/xM4bszAQQtE7o6GU1HLp88fRinyF60h9xCT0rSl1BZX9XNIFOsUg==
X-Received: by 2002:a63:e50:: with SMTP id 16mr7716342pgo.619.1638415310705;
        Wed, 01 Dec 2021 19:21:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:21:50 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/19] lib: add reference counting tracking infrastructure
Date:   Wed,  1 Dec 2021 19:21:21 -0800
Message-Id: <20211202032139.3156411-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It can be hard to track where references are taken and released.

In networking, we have annoying issues at device or netns dismantles,
and we had various proposals to ease root causing them.

This patch adds new infrastructure pairing refcount increases
and decreases. This will self document code, because programmers
will have to associate increments/decrements.

This is controled by CONFIG_REF_TRACKER which can be selected
by users of this feature.

This adds both cpu and memory costs, and thus should probably be
used with care.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ref_tracker.h |  73 +++++++++++++++++++
 lib/Kconfig                 |   4 ++
 lib/Makefile                |   2 +
 lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
new file mode 100644
index 0000000000000000000000000000000000000000..c11c9db5825cf933acf529c83db441a818135f29
--- /dev/null
+++ b/include/linux/ref_tracker.h
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#ifndef _LINUX_REF_TRACKER_H
+#define _LINUX_REF_TRACKER_H
+#include <linux/refcount.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+struct ref_tracker;
+
+struct ref_tracker_dir {
+#ifdef CONFIG_REF_TRACKER
+	spinlock_t		lock;
+	unsigned int		quarantine_avail;
+	refcount_t		untracked;
+	struct list_head	list; /* List of active trackers */
+	struct list_head	quarantine; /* List of dead trackers */
+#endif
+};
+
+#ifdef CONFIG_REF_TRACKER
+static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
+					unsigned int quarantine_count)
+{
+	INIT_LIST_HEAD(&dir->list);
+	INIT_LIST_HEAD(&dir->quarantine);
+	spin_lock_init(&dir->lock);
+	dir->quarantine_avail = quarantine_count;
+	refcount_set(&dir->untracked, 1);
+}
+
+void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
+
+void ref_tracker_dir_print(struct ref_tracker_dir *dir,
+			   unsigned int display_limit);
+
+int ref_tracker_alloc(struct ref_tracker_dir *dir,
+		      struct ref_tracker **trackerp, gfp_t gfp);
+
+int ref_tracker_free(struct ref_tracker_dir *dir,
+		     struct ref_tracker **trackerp);
+
+#else /* CONFIG_REF_TRACKER */
+
+static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
+					unsigned int quarantine_count)
+{
+}
+
+static inline void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
+{
+}
+
+static inline void ref_tracker_dir_print(struct ref_tracker_dir *dir,
+					 unsigned int display_limit)
+{
+}
+
+static inline int ref_tracker_alloc(struct ref_tracker_dir *dir,
+				    struct ref_tracker **trackerp,
+				    gfp_t gfp)
+{
+	return 0;
+}
+
+static inline int ref_tracker_free(struct ref_tracker_dir *dir,
+				   struct ref_tracker **trackerp)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* _LINUX_REF_TRACKER_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 5e7165e6a346c9bec878b78c8c8c3d175fc98dfd..d01be8e9593992a7d94a46bd1716460bc33c3ae1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -680,6 +680,10 @@ config STACK_HASH_ORDER
 	 Select the hash size as a power of 2 for the stackdepot hash table.
 	 Choose a lower value to reduce the memory impact.
 
+config REF_TRACKER
+	bool
+	select STACKDEPOT
+
 config SBITMAP
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 364c23f1557816f73aebd8304c01224a4846ac6c..c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -270,6 +270,8 @@ obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 KCOV_INSTRUMENT_stackdepot.o := n
 
+obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
+
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
 	       fdt_empty_tree.o fdt_addresses.o
 $(foreach file, $(libfdt_files), \
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
new file mode 100644
index 0000000000000000000000000000000000000000..0ae2e66dcf0fdb976f4cb99e747c9448b37f22cc
--- /dev/null
+++ b/lib/ref_tracker.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/export.h>
+#include <linux/ref_tracker.h>
+#include <linux/slab.h>
+#include <linux/stacktrace.h>
+#include <linux/stackdepot.h>
+
+#define REF_TRACKER_STACK_ENTRIES 16
+
+struct ref_tracker {
+	struct list_head	head;   /* anchor into dir->list or dir->quarantine */
+	bool			dead;
+	depot_stack_handle_t	alloc_stack_handle;
+	depot_stack_handle_t	free_stack_handle;
+};
+
+void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
+{
+	struct ref_tracker *tracker, *n;
+	unsigned long flags;
+	bool leak = false;
+
+	spin_lock_irqsave(&dir->lock, flags);
+	list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
+		list_del(&tracker->head);
+		kfree(tracker);
+		dir->quarantine_avail++;
+	}
+	list_for_each_entry_safe(tracker, n, &dir->list, head) {
+		pr_err("leaked reference.\n");
+		if (tracker->alloc_stack_handle)
+			stack_depot_print(tracker->alloc_stack_handle);
+		leak = true;
+		list_del(&tracker->head);
+		kfree(tracker);
+	}
+	spin_unlock_irqrestore(&dir->lock, flags);
+	WARN_ON_ONCE(leak);
+	WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
+}
+EXPORT_SYMBOL(ref_tracker_dir_exit);
+
+void ref_tracker_dir_print(struct ref_tracker_dir *dir,
+			   unsigned int display_limit)
+{
+	struct ref_tracker *tracker;
+	unsigned long flags;
+	unsigned int i = 0;
+
+	spin_lock_irqsave(&dir->lock, flags);
+	list_for_each_entry(tracker, &dir->list, head) {
+		if (i < display_limit) {
+			pr_err("leaked reference.\n");
+			if (tracker->alloc_stack_handle)
+				stack_depot_print(tracker->alloc_stack_handle);
+			i++;
+		} else {
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&dir->lock, flags);
+}
+EXPORT_SYMBOL(ref_tracker_dir_print);
+
+int ref_tracker_alloc(struct ref_tracker_dir *dir,
+		      struct ref_tracker **trackerp,
+		      gfp_t gfp)
+{
+	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
+	struct ref_tracker *tracker;
+	unsigned int nr_entries;
+	unsigned long flags;
+
+	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
+	if (unlikely(!tracker)) {
+		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
+		refcount_inc(&dir->untracked);
+		return -ENOMEM;
+	}
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
+
+	spin_lock_irqsave(&dir->lock, flags);
+	list_add(&tracker->head, &dir->list);
+	spin_unlock_irqrestore(&dir->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ref_tracker_alloc);
+
+int ref_tracker_free(struct ref_tracker_dir *dir,
+		     struct ref_tracker **trackerp)
+{
+	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
+	struct ref_tracker *tracker = *trackerp;
+	depot_stack_handle_t stack_handle;
+	unsigned int nr_entries;
+	unsigned long flags;
+
+	if (!tracker) {
+		refcount_dec(&dir->untracked);
+		return -EEXIST;
+	}
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
+
+	spin_lock_irqsave(&dir->lock, flags);
+	if (tracker->dead) {
+		pr_err("reference already released.\n");
+		if (tracker->alloc_stack_handle) {
+			pr_err("allocated in:\n");
+			stack_depot_print(tracker->alloc_stack_handle);
+		}
+		if (tracker->free_stack_handle) {
+			pr_err("freed in:\n");
+			stack_depot_print(tracker->free_stack_handle);
+		}
+		spin_unlock_irqrestore(&dir->lock, flags);
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	tracker->dead = true;
+
+	tracker->free_stack_handle = stack_handle;
+
+	list_move_tail(&tracker->head, &dir->quarantine);
+	if (!dir->quarantine_avail) {
+		tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
+		list_del(&tracker->head);
+	} else {
+		dir->quarantine_avail--;
+		tracker = NULL;
+	}
+	spin_unlock_irqrestore(&dir->lock, flags);
+
+	kfree(tracker);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ref_tracker_free);
-- 
2.34.0.rc2.393.gf8c9666880-goog

