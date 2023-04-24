Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57FF6ED77D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjDXWGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjDXWGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:06:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1908D8A40;
        Mon, 24 Apr 2023 15:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682373967; x=1713909967;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=aF+00fMmCxB5g2z9dZZXQyc7aZrPeManS84M0BOgQmc=;
  b=ORKByxqBPUjhYAArNQa8k4UBVM5OxY1JwAOAagCPK/PpC0Jz0/zo++9k
   iuNRrl992qYdFA7TaHcd+LZj+5+ftp6GQOqEsPSX719PBVIrHeE7ohxId
   D3aKxrewj+ZFboAxWJCCV/CYVJHazqvnZF+cNeHjUqlm7jev+5T90m0a5
   2/kmB0SP/VW6q9jPSEBsNz0Sh5t9lcmeK13r4Jo+5WkikMGepEKXw0JBj
   PIoWQft/TBPj0wAbAf4rYv0CkJ3Xgx/51nlIzxjFCoDK2PeG43qde0bKd
   ZAMfl2SF3aPW5jO3D8FrmaUGsImAHdWSaI3WJeGuxKWSQUNOsX71YW7az
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335473719"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="335473719"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:06:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="939500256"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="939500256"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:06:03 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Tue, 25 Apr 2023 00:05:41 +0200
Subject: [PATCH v8 4/7] lib/ref_tracker: remove warnings in case of allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v8-4-4b6517e61be6@intel.com>
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

Library can handle allocation failures. To avoid allocation warnings
__GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
replaced with GFP_NOWAIT in case of stack allocation on tracker free
call.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
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
