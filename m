Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A64BEE0F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiBUXSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:18:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiBUXR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:17:59 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469FA2458C;
        Mon, 21 Feb 2022 15:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485455; x=1677021455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hKcMNiYsgJWI/tUBCVHZc6qZhjqO+LBrBiPvfP3KNy0=;
  b=eiuylxvohcefrmbZjrk0rkrhxxfPkDJ59lV/fVVflPT4Cjy5LIDlcIJK
   KEnmHz3ErJ531cAkbuR+Ws4uqukpzy36mRmqjnoNMWnTIpmWZUE01e9ZS
   DkZ93H5ohJXb4q+xZcifFmsoGYOsgRTpo06v5BMN9SmAuKClvveB7pvxr
   CF7sl4852lyyAtg8c3n83f27Np4V9McEGxgNaSXDgECXP+cTCe4+0fNnG
   2oYi5FQ30AaQ/wh95Rsa/AZiKQc/Je7UWaAWeFr9x0lMSofsPuB12zpoN
   bDYVVqzPNat3WZjI8W6n0l/6eHQHOCrzI2iSo7ez4/UDIj0Hmhv5FtONO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251530372"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251530372"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="638694396"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:30 -0800
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
Subject: [PATCH v2 2/9] lib/ref_tracker: compact stacktraces before printing
Date:   Tue, 22 Feb 2022 00:16:47 +0100
Message-Id: <20220221231705.1481059-6-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221231705.1481059-1-andrzej.hajda@intel.com>
References: <20220221231705.1481059-1-andrzej.hajda@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

