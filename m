Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F16ED775
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjDXWGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjDXWGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:06:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A9E8A74;
        Mon, 24 Apr 2023 15:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682373963; x=1713909963;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=9543xZcCMZfDtzLHnM5dTa2W9tWhV6LjC/60obdR+TE=;
  b=MMSDwdWYPY0afh/6S5wrIv9uUi7xfMhfUdt+U0XR4u1f3l2vS6QGHWC0
   6Kw1qhCdT0STSr8jkGgrD60v6zpNEKHAgbE1rycGtn4ibrbLf30noms1D
   lTerNV2IIExiTAT+wLGuX/mkAjpSX7WBJjcxuoPoifOCOvVafz0cjRC8/
   Cxb6DKw+ad6us2jeBFHYECDLoCXHKXlL6Ftv34TENs4nAgUrPfLj1YHTe
   QiFJSUTfgnDRFE70O23HS3/pzumVIoJnx+4muigYA5nG+RAY1N6FlSOnP
   8HOQTdzFWQ0YQxSjO/XezIDW04U5YmzvYSODUrd/b0UkbyPzbNc9iV41N
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335473696"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="335473696"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:06:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="939500186"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="939500186"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:05:59 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Tue, 25 Apr 2023 00:05:40 +0200
Subject: [PATCH v8 3/7] lib/ref_tracker: add printing to memory buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v8-3-4b6517e61be6@intel.com>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
In-Reply-To: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to stack_(depot|trace)_snprint the patch
adds helper to printing stats to memory buffer.
It will be helpful in case of debugfs.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
---
 include/linux/ref_tracker.h |  8 +++++++
 lib/ref_tracker.c           | 56 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 19a69e7809d6c1..8eac4f3d52547c 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -46,6 +46,8 @@ void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
 void ref_tracker_dir_print(struct ref_tracker_dir *dir,
 			   unsigned int display_limit);
 
+int ref_tracker_dir_snprint(struct ref_tracker_dir *dir, char *buf, size_t size);
+
 int ref_tracker_alloc(struct ref_tracker_dir *dir,
 		      struct ref_tracker **trackerp, gfp_t gfp);
 
@@ -74,6 +76,12 @@ static inline void ref_tracker_dir_print(struct ref_tracker_dir *dir,
 {
 }
 
+static inline int ref_tracker_dir_snprint(struct ref_tracker_dir *dir,
+					  char *buf, size_t size)
+{
+	return 0;
+}
+
 static inline int ref_tracker_alloc(struct ref_tracker_dir *dir,
 				    struct ref_tracker **trackerp,
 				    gfp_t gfp)
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 2ffe79c90c1771..cce4614b07940f 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -62,8 +62,27 @@ ref_tracker_get_stats(struct ref_tracker_dir *dir, unsigned int limit)
 	return stats;
 }
 
-void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
-				  unsigned int display_limit)
+struct ostream {
+	char *buf;
+	int size, used;
+};
+
+#define pr_ostream(stream, fmt, args...) \
+({ \
+	struct ostream *_s = (stream); \
+\
+	if (!_s->buf) { \
+		pr_err(fmt, ##args); \
+	} else { \
+		int ret, len = _s->size - _s->used; \
+		ret = snprintf(_s->buf + _s->used, len, pr_fmt(fmt), ##args); \
+		_s->used += min(ret, len); \
+	} \
+})
+
+static void
+__ref_tracker_dir_pr_ostream(struct ref_tracker_dir *dir,
+			     unsigned int display_limit, struct ostream *s)
 {
 	struct ref_tracker_dir_stats *stats;
 	unsigned int i = 0, skipped;
@@ -77,8 +96,8 @@ void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
 
 	stats = ref_tracker_get_stats(dir, display_limit);
 	if (IS_ERR(stats)) {
-		pr_err("%s@%pK: couldn't get stats, error %pe\n",
-		       dir->name, dir, stats);
+		pr_ostream(s, "%s@%pK: couldn't get stats, error %pe\n",
+			   dir->name, dir, stats);
 		return;
 	}
 
@@ -88,19 +107,27 @@ void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
 		stack = stats->stacks[i].stack_handle;
 		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
 			sbuf[0] = 0;
-		pr_err("%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
-		       stats->stacks[i].count, stats->total, sbuf);
+		pr_ostream(s, "%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
+			   stats->stacks[i].count, stats->total, sbuf);
 		skipped -= stats->stacks[i].count;
 	}
 
 	if (skipped)
-		pr_err("%s@%pK skipped reports about %d/%d users.\n",
-		       dir->name, dir, skipped, stats->total);
+		pr_ostream(s, "%s@%pK skipped reports about %d/%d users.\n",
+			   dir->name, dir, skipped, stats->total);
 
 	kfree(sbuf);
 
 	kfree(stats);
 }
+
+void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
+				  unsigned int display_limit)
+{
+	struct ostream os = {};
+
+	__ref_tracker_dir_pr_ostream(dir, display_limit, &os);
+}
 EXPORT_SYMBOL(ref_tracker_dir_print_locked);
 
 void ref_tracker_dir_print(struct ref_tracker_dir *dir,
@@ -114,6 +141,19 @@ void ref_tracker_dir_print(struct ref_tracker_dir *dir,
 }
 EXPORT_SYMBOL(ref_tracker_dir_print);
 
+int ref_tracker_dir_snprint(struct ref_tracker_dir *dir, char *buf, size_t size)
+{
+	struct ostream os = { .buf = buf, .size = size };
+	unsigned long flags;
+
+	spin_lock_irqsave(&dir->lock, flags);
+	__ref_tracker_dir_pr_ostream(dir, 16, &os);
+	spin_unlock_irqrestore(&dir->lock, flags);
+
+	return os.used;
+}
+EXPORT_SYMBOL(ref_tracker_dir_snprint);
+
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 {
 	struct ref_tracker *tracker, *n;

-- 
2.34.1
