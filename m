Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4434BA287
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbiBQOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbiBQOFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E016145AFD;
        Thu, 17 Feb 2022 06:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106712; x=1676642712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mmcVCbEg/LT9UwII2j+BYuiQo6K4SH6OPf0Nj6nyyHk=;
  b=iCQnksXymfbJUZ7jW4zQzHayV0Ygi5d7F0IeHcVmMHFpVzviYs6sK09m
   tBYMPyV961rvEvXBN+jWIVNg/+42OhufmXGZgDFA9s4mMP0DLeASRECXs
   fh02kd0E/QeYbbLgOhGuc6ggQdoNhKNBaIRL369z1Jdymlq17c3K2iDTI
   W3i0ic4b9JI7tagmwNNeGhRn8DyuTInPdTqLZYALJEa93KmC7Id3tZoNH
   vLayiKooRtWhRsysRWQGiR+OjqmzsObCQhcmTtcrh8Z+Gf61bnI6eJOXY
   fV707aqhjGPeTFq2vtfKFGv0XSmz2Cneq6F82ZCL9Fuj53NUJ0QdvrvXk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501882"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501882"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241277"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:09 -0800
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
Subject: [PATCH 5/9] lib/ref_tracker: improve allocation flags
Date:   Thu, 17 Feb 2022 15:04:37 +0100
Message-Id: <20220217140441.1218045-6-andrzej.hajda@intel.com>
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

Library can be called in non-sleeping context, so it should not use
__GFP_NOFAIL. Instead it should calmly handle allocation fails, for
this __GFP_NOWARN has been added as well.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 lib/ref_tracker.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 7b00bca300043..c8441ffbb058a 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -59,7 +59,7 @@ __ref_tracker_dir_pr_ostream(struct ref_tracker_dir *dir,
 	if (list_empty(&dir->list))
 		return;
 
-	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
+	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
 
 	list_for_each_entry(tracker, &dir->list, head)
 		++total;
@@ -154,11 +154,11 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
 	struct ref_tracker *tracker;
 	unsigned int nr_entries;
-	gfp_t gfp_mask = gfp;
+	gfp_t gfp_mask;
 	unsigned long flags;
 
-	if (gfp & __GFP_DIRECT_RECLAIM)
-		gfp_mask |= __GFP_NOFAIL;
+	gfp |= __GFP_NOWARN;
+	gfp_mask = (gfp & __GFP_DIRECT_RECLAIM) ? (gfp | __GFP_NOFAIL) : gfp;
 	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
 	if (unlikely(!tracker)) {
 		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
@@ -191,7 +191,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
 	nr_entries = filter_irq_stacks(entries, nr_entries);
-	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
+	stack_handle = stack_depot_save(entries, nr_entries,
+					GFP_NOWAIT | __GFP_NOWARN);
 
 	spin_lock_irqsave(&dir->lock, flags);
 	if (tracker->dead) {
-- 
2.25.1

