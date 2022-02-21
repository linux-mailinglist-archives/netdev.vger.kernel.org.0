Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8319F4BEE5B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiBUXSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:18:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiBUXRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:17:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F9245B2;
        Mon, 21 Feb 2022 15:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485450; x=1677021450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hxxx7U/IhkSHLnB5PbYul9lg1GjO2Izf/ptB46o3iFI=;
  b=Cto2hUqZmmwrZaR2suOPcFb0xcxSyoyJXQ7O2RQ5rytqnxmAxpHmhcw2
   5GZSDCxNq8+WzGkn1YViF6+hlaHSySRmdpGC0K31EsU70cnk8hEjAy7Ch
   qMBWbbmOk9dRstc2CKpbG5nDDZ4XGBJEzHsYItVFHcmX0686x8fqsvJ2h
   gwPwXNjcrtZ7DGASfmkhhVcwDCXIUXwzZ47ZjW+A7U1eWerUcdmq5DNI1
   bjmT7HV+U9LFLgosqKtnDEGyFk1tIHnfoi5croLk3JAeuXCKaXx54Pae8
   OdTc91oE6+INiJmmmgy+8Hm/Q2lKijnNnw2OG0694CvF52Qe6xQyClw5u
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251530348"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251530348"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="638694383"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:27 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2 02/11] [DO NOT MERGE] ref_tracker: add a count of untracked references
Date:   Tue, 22 Feb 2022 00:16:46 +0100
Message-Id: <20220221231705.1481059-5-andrzej.hajda@intel.com>
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

From: Eric Dumazet <edumazet@google.com>

We are still chasing a netdev refcount imbalance, and we suspect
we have one rogue dev_put() that is consuming a reference taken
from a dev_hold_track()

To detect this case, allow ref_tracker_alloc() and ref_tracker_free()
to be called with a NULL @trackerp parameter, and use a dedicated
refcount_t just for them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 include/linux/ref_tracker.h |  2 ++
 lib/ref_tracker.c           | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index a443abda937d8..9ca353ab712b5 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -13,6 +13,7 @@ struct ref_tracker_dir {
 	spinlock_t		lock;
 	unsigned int		quarantine_avail;
 	refcount_t		untracked;
+	refcount_t		no_tracker;
 	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
@@ -29,6 +30,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	dir->quarantine_avail = quarantine_count;
 	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
+	refcount_set(&dir->no_tracker, 1);
 	stack_depot_init();
 }
 
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 32ff6bd497f8e..9c0c2e09df666 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -38,6 +38,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 	spin_unlock_irqrestore(&dir->lock, flags);
 	WARN_ON_ONCE(leak);
 	WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
+	WARN_ON_ONCE(refcount_read(&dir->no_tracker) != 1);
 }
 EXPORT_SYMBOL(ref_tracker_dir_exit);
 
@@ -75,6 +76,10 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 
 	WARN_ON_ONCE(dir->dead);
 
+	if (!trackerp) {
+		refcount_inc(&dir->no_tracker);
+		return 0;
+	}
 	if (gfp & __GFP_DIRECT_RECLAIM)
 		gfp_mask |= __GFP_NOFAIL;
 	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
@@ -98,13 +103,18 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		     struct ref_tracker **trackerp)
 {
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
-	struct ref_tracker *tracker = *trackerp;
 	depot_stack_handle_t stack_handle;
+	struct ref_tracker *tracker;
 	unsigned int nr_entries;
 	unsigned long flags;
 
 	WARN_ON_ONCE(dir->dead);
 
+	if (!trackerp) {
+		refcount_dec(&dir->no_tracker);
+		return 0;
+	}
+	tracker = *trackerp;
 	if (!tracker) {
 		refcount_dec(&dir->untracked);
 		return -EEXIST;
-- 
2.25.1

