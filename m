Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421E14BA27F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbiBQOFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiBQOFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:25 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFF1128DC8;
        Thu, 17 Feb 2022 06:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106710; x=1676642710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pUuimvezQ3JaPbwU/OO8a8pmkIn4yGNg2mdyK8ncgME=;
  b=JmL8UwUACGQMfrbT3+Z2RYylZjYeBinHlgXkKUBUUrELuWphqqvtDS4N
   bwHjXj2r2qw64ABcOt5xdwhHC9tfhEdL2opq6RmcBjAe3jiTPuatWFMcF
   AMgEY2T4TSA8+VXw9+CIL+iyzS/QJ0XrMR2PqVlcS2UofrlnoiUCHv/SW
   tV0DsGyZA89aELtfvheAbTzQGzDmmIvR/r+lXiwPVm/1fJwbHU+GzDVrO
   mlVfT08W3BjnbvOUMlo6PeFoJ25gDpAccNRFUQK2cQBDaso3S7/msUyUl
   eq0lVdz4Hq5vJo6XbnQZaGNLgbWJt/Jg1z7S8NXEFPAL3dGxK5ezvWwfT
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501872"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501872"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241244"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:06 -0800
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
Subject: [PATCH 4/9] lib/ref_tracker: add printing to memory buffer
Date:   Thu, 17 Feb 2022 15:04:36 +0100
Message-Id: <20220217140441.1218045-5-andrzej.hajda@intel.com>
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

In case one wants to show stats via debugfs.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
---
 include/linux/ref_tracker.h |  8 ++++++
 lib/ref_tracker.c           | 52 ++++++++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 090230e5b485d..6d2634590ee5a 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -46,6 +46,8 @@ void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
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
index 943cff08110e3..7b00bca300043 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -27,8 +27,27 @@ static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct l
 	return ta->alloc_stack_handle - tb->alloc_stack_handle;
 }
 
-void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
-			   unsigned int display_limit)
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
 	unsigned int i = 0, count = 0, total = 0;
 	struct ref_tracker *tracker;
@@ -58,16 +77,24 @@ void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
 
 		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
 			sbuf[0] = 0;
-		pr_err("%s@%pK has %d/%d users at\n%s\n",
-		       dir->name, dir, count, total, sbuf);
+		pr_ostream(s, "%s@%pK has %d/%d users at\n%s\n",
+			   dir->name, dir, count, total, sbuf);
 		count = 0;
 	}
 	if (i > display_limit)
-		pr_err("%s@%pK skipped %d/%d reports with %d unique stacks.\n",
-		       dir->name, dir, count, total, i - display_limit);
+		pr_ostream(s, "%s@%pK skipped %d/%d reports with %d unique stacks.\n",
+			   dir->name, dir, count, total, i - display_limit);
 
 	kfree(sbuf);
 }
+
+void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
+			   unsigned int display_limit)
+{
+	struct ostream os = {};
+
+	__ref_tracker_dir_pr_ostream(dir, display_limit, &os);
+}
 EXPORT_SYMBOL(__ref_tracker_dir_print);
 
 void ref_tracker_dir_print(struct ref_tracker_dir *dir,
@@ -81,6 +108,19 @@ void ref_tracker_dir_print(struct ref_tracker_dir *dir,
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
2.25.1

