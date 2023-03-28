Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A6F6CC5CC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjC1PSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjC1PRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:17:43 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BFAEB78;
        Tue, 28 Mar 2023 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680016609; x=1711552609;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=V3l4oFrTXgNaHDsFH5ny9LhlqFRgL1aXxFRyebnTRqc=;
  b=KL7XwqF6TkSV1/5HIh8nOR4qMTpZpQAJmac17MzESTu76AW5iEh3QZsR
   33s7uWN6a7wMU2cZ4mOX/QWmcv1+97jMUiGwrJkUPGRRUV2P6S4vC9EFb
   lT0amzSLeYTYFQq52ZKdAPJ0se34ecGdb8b8gj6+K9ZBkxmsf7XpvSFDb
   U6/GoGHiQBMDXWtrSwNopSYfzf00xp32Lw2t01RNyluo9rRPrpqYLI0Yp
   zmPQoJQO0pBkVadJJaUJziywjeKXik8rx5S2lRW1oyn1AhL5lG3377ERq
   jcV9iU2fbA9aJLFEUMmB1PNcHBS7aqlLefl1kzZcn/ALvmHzvDTqLw3W4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403208688"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403208688"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="773181764"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="773181764"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:15:56 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Tue, 28 Mar 2023 17:15:27 +0200
Subject: [PATCH v5 4/8] lib/ref_tracker: remove warnings in case of allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v5-4-77be86f2c872@intel.com>
References: <20230224-track_gt-v5-0-77be86f2c872@intel.com>
In-Reply-To: <20230224-track_gt-v5-0-77be86f2c872@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Library can handle allocation failures. To avoid allocation warnings
__GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
replaced with GFP_NOWAIT in case of stack allocation on tracker free
call.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
---
 lib/ref_tracker.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index cce4614b07940f..cf5609b1ca7936 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -189,7 +189,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
 	struct ref_tracker *tracker;
 	unsigned int nr_entries;
-	gfp_t gfp_mask = gfp;
+	gfp_t gfp_mask = gfp | __GFP_NOWARN;
 	unsigned long flags;
 
 	WARN_ON_ONCE(dir->dead);
@@ -237,7 +237,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		return -EEXIST;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
+	stack_handle = stack_depot_save(entries, nr_entries,
+					GFP_NOWAIT | __GFP_NOWARN);
 
 	spin_lock_irqsave(&dir->lock, flags);
 	if (tracker->dead) {

-- 
2.34.1
