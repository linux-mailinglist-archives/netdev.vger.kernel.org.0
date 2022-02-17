Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54CD4BA285
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbiBQOFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbiBQOFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448919D049;
        Thu, 17 Feb 2022 06:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106706; x=1676642706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ysWCOx8Qe0FgPrL7lCitOlIRN7GA/uTSmYciHcbFL0=;
  b=Eu0DY79JluxUYCKICrFz7YC2DIxV0CqJ3e1/X7zShpA/g4mIkm12QYrI
   ehAkLBHTqgDhbwRa7mEhuV+7FTXRPIghziG7ORS7iIeDG7FXGSJOrrv3I
   IdfS80/R5kO5CoO/9wYLefOCVdp212HWLDdNEajmN5npP7gyqb9S7Tuuz
   UZZ30Q3irT7ZIlurUWAaHiKNMtij/YjQihe6jLSlB6G5KPPj08Ye5NJHQ
   fT7yZZx7K9KVVu4/GqwdO9OTP2S+FxOdPEDb1fe0DCn8Vyhoefo+jVEwE
   nDr7S8iOXApnvwxw2NaUXlQk96WlAqFfkucJNQboZFWbOCnF7T2j/q6H9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501861"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501861"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241205"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:02 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/9] lib/ref_tracker: __ref_tracker_dir_print improve printing
Date:   Thu, 17 Feb 2022 15:04:35 +0100
Message-Id: <20220217140441.1218045-4-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220217140441.1218045-1-andrzej.hajda@intel.com>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve readibility of ref_tracker printing following changes
have been performed:
- added display name for ref_tracker_dir,
- stack trace is printed indented, in the same printk call,
- total number of references is printed every time,
- print info about dropped references.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
---
 include/linux/ref_tracker.h | 15 ++++++++++++---
 lib/ref_tracker.c           | 28 ++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index b9c968a716483..090230e5b485d 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -15,18 +15,26 @@ struct ref_tracker_dir {
 	refcount_t		untracked;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
+	char			name[32];
 #endif
 };
 
 #ifdef CONFIG_REF_TRACKER
-static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+
+// Temporary allow two and three arguments, until consumers are converted
+#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
+#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
+
+static inline void __ref_tracker_dir_init(struct ref_tracker_dir *dir,
+					unsigned int quarantine_count,
+					const char *name)
 {
 	INIT_LIST_HEAD(&dir->list);
 	INIT_LIST_HEAD(&dir->quarantine);
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
 	refcount_set(&dir->untracked, 1);
+	strlcpy(dir->name, name, sizeof(dir->name));
 	stack_depot_init();
 }
 
@@ -47,7 +55,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 #else /* CONFIG_REF_TRACKER */
 
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+					unsigned int quarantine_count,
+					...)
 {
 }
 
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 0e9c7d2828ccb..943cff08110e3 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
+
+#define pr_fmt(fmt) "ref_tracker: " fmt
+
 #include <linux/export.h>
 #include <linux/list_sort.h>
 #include <linux/ref_tracker.h>
@@ -7,6 +10,7 @@
 #include <linux/stackdepot.h>
 
 #define REF_TRACKER_STACK_ENTRIES 16
+#define STACK_BUF_SIZE 1024
 
 struct ref_tracker {
 	struct list_head	head;   /* anchor into dir->list or dir->quarantine */
@@ -26,31 +30,43 @@ static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct l
 void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
 			   unsigned int display_limit)
 {
-	unsigned int i = 0, count = 0;
+	unsigned int i = 0, count = 0, total = 0;
 	struct ref_tracker *tracker;
 	depot_stack_handle_t stack;
+	char *sbuf;
 
 	lockdep_assert_held(&dir->lock);
 
 	if (list_empty(&dir->list))
 		return;
 
+	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
+
+	list_for_each_entry(tracker, &dir->list, head)
+		++total;
+
 	list_sort(NULL, &dir->list, ref_tracker_cmp);
 
 	list_for_each_entry(tracker, &dir->list, head) {
-		if (i++ >= display_limit)
-			break;
 		if (!count++)
 			stack = tracker->alloc_stack_handle;
 		if (stack == tracker->alloc_stack_handle &&
 		    !list_is_last(&tracker->head, &dir->list))
 			continue;
+		if (i++ >= display_limit)
+			continue;
 
-		pr_err("leaked %d references.\n", count);
-		if (stack)
-			stack_depot_print(stack);
+		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
+			sbuf[0] = 0;
+		pr_err("%s@%pK has %d/%d users at\n%s\n",
+		       dir->name, dir, count, total, sbuf);
 		count = 0;
 	}
+	if (i > display_limit)
+		pr_err("%s@%pK skipped %d/%d reports with %d unique stacks.\n",
+		       dir->name, dir, count, total, i - display_limit);
+
+	kfree(sbuf);
 }
 EXPORT_SYMBOL(__ref_tracker_dir_print);
 
-- 
2.25.1

