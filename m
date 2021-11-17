Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D70454DCC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhKQTXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhKQTXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:23:36 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5E8C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u17so3044371plg.9
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0dczHRTuF0MtcdBihOYS7TZ7Ay8loThSAgm6mpvJ4g=;
        b=jOvlT/xXCtd54iVSPo+5lwvMKpOrdRV9WDZtiCtCKc0aCp9/8165h80HTnY7l/iwm/
         A/zPzpgRrTKAe/lOosc+mmS2x5HHDoANHLYKtEpSEmffcloxGO8w2UOlwLvywenSbJKZ
         bhZwVXht0Vd5/V/SzRWioa21YgA73aol9Sj9aGN+T8iSpI6Kgw2jigGVf7+NzySeZOJ/
         RWrVvF3hpOpGdUkYASchfvqDNP5MGk3jlkX7/Nadh4YS9bJ1EuoeqapMUjxKCPKtCSxP
         T0+i9sVn1LcoSyyeaxC0JpU5Vk7fT+P46CoOPjCQvFZbz9yjdiHf7uGB8iw7sfMuZOY3
         u6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0dczHRTuF0MtcdBihOYS7TZ7Ay8loThSAgm6mpvJ4g=;
        b=yEDclH/j/FPSDkbtSUpvmNVIwOteH5wrfxhqYDiiuppA0xhcFsd8sFLcJKZdila5EL
         dDIO6M2V822XyU58OYVq5cax8uBtFTjroHcMUc2sRcv8smpBz/KLmmDYrxbvQygCdrrf
         i4denpz55PjIHCbS1S7HBohh5zGyhPLwqK3r3kd/MRKnP+2og24guwdBiQx6TJCNxls1
         qNIIo43HsFekFyzCHrOrPHW1BavSaxfJvjICZo1qB77D5AClRxQCzr1TqDyfgyJQDdVw
         mRDTHFgAkRD6bI/MaYSne5vpWitgFQW2H62QxGnl2NuaMLeiepVsX5zEWYtDTLdx3AHM
         Fr3g==
X-Gm-Message-State: AOAM53187UpjrzVjttEDXS6cBl9yE8dmO9Wt32n/trbqEOCDjSdOEvwd
        iUphp59eMj026leBJCNWDOlPwagBe50=
X-Google-Smtp-Source: ABdhPJyHC1ru0n68eMAna0+PEUrltYFjjLp0NpSwnatoJaZ31tgbJnHUVQZnbuHA+1rAvkfi7K5wDg==
X-Received: by 2002:a17:902:7595:b0:144:ce0e:d42 with SMTP id j21-20020a170902759500b00144ce0e0d42mr495818pll.39.1637176837671;
        Wed, 17 Nov 2021 11:20:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id e15sm376698pfc.134.2021.11.17.11.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 11:20:37 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC -next 1/2] lib: add reference counting infrastructure
Date:   Wed, 17 Nov 2021 11:20:30 -0800
Message-Id: <20211117192031.3906502-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117192031.3906502-1-eric.dumazet@gmail.com>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It can be hard to track where references are taken and released.

In networking, we have annoying issues at device dismantles,
and we had various proposals to ease root causing them.

This patch adds new infrastructure pairing refcount increases
and decreases. This will self document code, because programmer
will have to associate increments/decrements.

This is controled by CONFIG_REF_TRACKER which can be selected
by users of this feature.

This adds both cpu and memory costs, and thus should be reserved
for debug kernel builds, or be enabled on demand with a static key.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ref_tracker.h |  78 ++++++++++++++++++++++++
 lib/Kconfig                 |   4 ++
 lib/Makefile                |   2 +
 lib/ref_tracker.c           | 116 ++++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
new file mode 100644
index 0000000000000000000000000000000000000000..1a2a3696682d40b38f9f1dd2b14663716e37d9d3
--- /dev/null
+++ b/include/linux/ref_tracker.h
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#ifndef _LINUX_REF_TRACKER_H
+#define _LINUX_REF_TRACKER_H
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/stackdepot.h>
+
+struct ref_tracker {
+#ifdef CONFIG_REF_TRACKER
+	struct list_head	head;   /* anchor into dir->list or dir->quarantine */
+	bool			dead;
+	depot_stack_handle_t	alloc_stack_handle;
+	depot_stack_handle_t	free_stack_handle;
+#endif
+};
+
+struct ref_tracker_dir {
+#ifdef CONFIG_REF_TRACKER
+	spinlock_t		lock;
+	unsigned int		quarantine_avail;
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
index 0000000000000000000000000000000000000000..e907c58c31ed49719e31c6e46abd1715d9884924
--- /dev/null
+++ b/lib/ref_tracker.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/export.h>
+#include <linux/ref_tracker.h>
+#include <linux/slab.h>
+#include <linux/stacktrace.h>
+
+#define REF_TRACKER_STACK_ENTRIES 16
+
+void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
+{
+	struct ref_tracker *tracker, *n;
+	unsigned long flags;
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
+		list_del(&tracker->head);
+		kfree(tracker);
+	}
+	spin_unlock_irqrestore(&dir->lock, flags);
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
+		tracker->dead = true;
+		if (i < display_limit) {
+			pr_err("leaked reference.\n");
+			if (tracker->alloc_stack_handle)
+				stack_depot_print(tracker->alloc_stack_handle);
+		}
+		i++;
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
+	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp);
+	if (!tracker) {
+		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
+		return -ENOMEM;
+	}
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
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
+	unsigned int nr_entries;
+	unsigned long flags;
+
+	if (!tracker)
+		return -EEXIST;
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
+		return -EINVAL;
+	}
+	tracker->dead = true;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
+	tracker->free_stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
+
+	list_move_tail(&tracker->head, &dir->quarantine);
+	if (!dir->quarantine_avail) {
+		tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
+		list_del(&tracker->head);
+		kfree(tracker);
+	} else {
+		dir->quarantine_avail--;
+	}
+	spin_unlock_irqrestore(&dir->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ref_tracker_free);
-- 
2.34.0.rc1.387.gb447b232ab-goog

