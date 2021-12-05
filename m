Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952AE46890D
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhLEEZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhLEEZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:25:55 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9826CC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:28 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k4so4835468plx.8
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JFPeeIF9LdcBAftFvXJ114QsIch1nlGj9KpbveqAer4=;
        b=IvbPrHOtlQb1D2RT7+75f/xfTtiCls2h9H3aTFLHJlYy4+DMd44vrbv4l7dyq1uhDK
         Fy5litRt06wsd1mRKy8F3YYTNft9UIdLeDePnUlSXKo1GGsXyjIaCQgNHa10h7fxNB/K
         v4tJFC+jy3jiplrLZtie64ywnhif/O+OXOsrnxUsUKlI6GPTr0t20QjytXN26UfSZiKM
         md+OELgyBlzJDo9yvtWeM0c+AZL4oBUWhsGVaHXcPp871sjb43gyZTmyT2ecZvqCHOZj
         3uKDK0HdGRkK/csC+2B9CxN8BH6cqdDNqSd3L7Rw7mqxWQLOg+Z4Qt+6wsFDNDobF6o/
         DUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFPeeIF9LdcBAftFvXJ114QsIch1nlGj9KpbveqAer4=;
        b=02jeLN+60pM7VKRjY+trtWaZfbVyyHGWxch9ynYbKAo7AUQGUQvdcSOkdZkl8KMjcI
         T0hMLDnH9epSIFc22CsuLNgiY3aiVZuSYamu0yeZ6k036j9d+tGCq7bTCoidpm5NxBm/
         xVpQmChoLmFdo8263GtI5wafc1cJ8SOzDcssuw37NF3n5acwSzy9jzwQcD4HJ/95If/S
         m3sUP9iHcVlioY1yGAYS0nA+RTdv2H/DQ2s8MXHsEDChh+IsZoFZVE3WDkAKgrQlzTS9
         wG2G204jW9OI4TuWpKPP1d7qOhzbltBAaLDYZeQ3pe09/Cz9FnHPxEVmcpQNJoaAMh+T
         lzkQ==
X-Gm-Message-State: AOAM5316g9h5+EsehzP0cG4mPUDNUbxnf0R7fdUFsjQWYS4RDpE6G8mO
        vJExms8woMdxHobQAdyLjtU=
X-Google-Smtp-Source: ABdhPJyV+vzxc7JmI9ghp555BCVoAiBvcVFS21u+MrPPF0pLt/k694DCSa6RxseQAUJIaqlWgS0Flg==
X-Received: by 2002:a17:903:2443:b0:142:1e92:1d19 with SMTP id l3-20020a170903244300b001421e921d19mr34509648pls.24.1638678148117;
        Sat, 04 Dec 2021 20:22:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 01/23] lib: add reference counting tracking infrastructure
Date:   Sat,  4 Dec 2021 20:21:55 -0800
Message-Id: <20211205042217.982127-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
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
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
---
 include/linux/ref_tracker.h |  73 +++++++++++++++++++
 lib/Kconfig                 |   5 ++
 lib/Makefile                |   2 +
 lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
 4 files changed, 220 insertions(+)
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
index 5e7165e6a346c9bec878b78c8c8c3d175fc98dfd..655b0e43f260bfca63240794191e3f1890b2e801 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -680,6 +680,11 @@ config STACK_HASH_ORDER
 	 Select the hash size as a power of 2 for the stackdepot hash table.
 	 Choose a lower value to reduce the memory impact.
 
+config REF_TRACKER
+	bool
+	depends on STACKTRACE_SUPPORT
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
2.34.1.400.ga245620fadb-goog

