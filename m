Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643CC46702B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350856AbhLCCuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350481AbhLCCug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:36 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D38CC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r138so1600747pgr.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JFPeeIF9LdcBAftFvXJ114QsIch1nlGj9KpbveqAer4=;
        b=MiltKiyaeGmcgFdr+xyloPvGY7ryE7g77X07os83DSf+2i0VEboyGNZTwIXPWhFDzR
         o1LLatBxBLtDp5AshvP3GKwBF/psMfKmYOjf8+46eVDv0bvSUqLyVFFdEeK/lpepeqXk
         rXj7dUBl5ljhsF+kglxC/uvHf8qxWIMaisZGO/3HZSn/cgofw2NnHykxDgv3Q1zQbGOt
         uLS9GYKMehqdjolMEyodIiLHxoaCTzD0TCBHuapCMw6+L4H+6IbJLkydUO3HPsMTtmHr
         EnRTXEtdkhkMInVz+5bYM/vyjIg2SQX3ZAZG39TBrLAs+NecUtZKAI7/qBglxBQ/o4w9
         34HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JFPeeIF9LdcBAftFvXJ114QsIch1nlGj9KpbveqAer4=;
        b=pMSHvaQ1mKIQVzjYEbXwEjmmFCGW6xJJ+pD+F8tDJqzDtOdBsZmkcbwWvDMg0iiPht
         7hchPwrEvnpEWoxBRIG6/t6OdAfi/jSF/+Ktplc7BQIi3sSYx8PsO9P/sURBT6l1uWnk
         fIF1Lkum8ChEw71NxcCpJLh4fbwO/AfaOLj8gGUL3uPjBY4SI/RZTUkwniRCR8znW2Js
         QH5aBn9m/wdXYnSZSvmoMauaN25zYIxUMsfnLmeyXrpGSWtgLDjXMxxZacoVd7jaMtYV
         BmFa9a8bbrUqZuDnrDgTJUcSlhTtwVSvsF8KvpdE/AzTt7D0/yVEhca0ZZwSFv6Ysp8J
         ISkg==
X-Gm-Message-State: AOAM530/K3tbkF1nM1W0wB3k2WPbxM06JBSqrcpXycbDnhy4EKVscxNf
        /jRSvngcrX0iNgybpgyeFsI=
X-Google-Smtp-Source: ABdhPJw2XGBnxreBAvycIW7dIf2ulJDDoVc4Ami9a3X/9uQB2aKJtlX9H5iEXlrCaw8iEh7vbFoAhA==
X-Received: by 2002:a63:d257:: with SMTP id t23mr2381087pgi.533.1638499632906;
        Thu, 02 Dec 2021 18:47:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 01/23] lib: add reference counting tracking infrastructure
Date:   Thu,  2 Dec 2021 18:46:18 -0800
Message-Id: <20211203024640.1180745-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
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

