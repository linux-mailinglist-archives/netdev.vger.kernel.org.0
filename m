Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB1F4BA28F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbiBQOFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiBQOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00943BD2C3;
        Thu, 17 Feb 2022 06:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106702; x=1676642702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hKcMNiYsgJWI/tUBCVHZc6qZhjqO+LBrBiPvfP3KNy0=;
  b=QZgoHPTkcBhTw8KIvy0qtpJQsngBiJMW2xwU9/m4NaPm8P47m5Mz6C9f
   u5jakao1vbXs/sq6yd0QBYusWvDbPEqc+7xtPDEOBXuMg/MgFR1AxLvVd
   WnnhoQlJ2a+ak7D8QNx07L+TmkU9a6vZQoim0NZCLxjBVoA1nEcvml8jL
   qA8GLbyYfOmm6tJOLWb+Rtqyu3t+ZjhNBquY5zip0INTDAzQt/N2dYezq
   GD0l2E1b+R7NhxPPrZgFwAwlJ0otRWSPI9Nh8DzNqb5DHkdsWeBV5KQtU
   tE7fHSOlBAnJ2NxQYWaXPI0zu1NZ4Y2kTxRBXwpZ0imM21VOxK4O2/C5r
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501843"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501843"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241142"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:04:59 -0800
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
Subject: [PATCH 2/9] lib/ref_tracker: compact stacktraces before printing
Date:   Thu, 17 Feb 2022 15:04:34 +0100
Message-Id: <20220217140441.1218045-3-andrzej.hajda@intel.com>
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

In cases references are taken alternately on multiple exec paths leak
report can grow substantially, sorting and grouping leaks by stack_handle
allows to compact it.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
---
 lib/ref_tracker.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 1b0c6d645d64a..0e9c7d2828ccb 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <linux/export.h>
+#include <linux/list_sort.h>
 #include <linux/ref_tracker.h>
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
@@ -14,23 +15,41 @@ struct ref_tracker {
 	depot_stack_handle_t	free_stack_handle;
 };
 
+static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct list_head *b)
+{
+	const struct ref_tracker *ta = list_entry(a, const struct ref_tracker, head);
+	const struct ref_tracker *tb = list_entry(b, const struct ref_tracker, head);
+
+	return ta->alloc_stack_handle - tb->alloc_stack_handle;
+}
+
 void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
 			   unsigned int display_limit)
 {
+	unsigned int i = 0, count = 0;
 	struct ref_tracker *tracker;
-	unsigned int i = 0;
+	depot_stack_handle_t stack;
 
 	lockdep_assert_held(&dir->lock);
 
+	if (list_empty(&dir->list))
+		return;
+
+	list_sort(NULL, &dir->list, ref_tracker_cmp);
+
 	list_for_each_entry(tracker, &dir->list, head) {
-		if (i < display_limit) {
-			pr_err("leaked reference.\n");
-			if (tracker->alloc_stack_handle)
-				stack_depot_print(tracker->alloc_stack_handle);
-			i++;
-		} else {
+		if (i++ >= display_limit)
 			break;
-		}
+		if (!count++)
+			stack = tracker->alloc_stack_handle;
+		if (stack == tracker->alloc_stack_handle &&
+		    !list_is_last(&tracker->head, &dir->list))
+			continue;
+
+		pr_err("leaked %d references.\n", count);
+		if (stack)
+			stack_depot_print(stack);
+		count = 0;
 	}
 }
 EXPORT_SYMBOL(__ref_tracker_dir_print);
-- 
2.25.1

