Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D716CD325
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjC2H0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjC2H0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:26:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F5630C2;
        Wed, 29 Mar 2023 00:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680074719; x=1711610719;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=V3l4oFrTXgNaHDsFH5ny9LhlqFRgL1aXxFRyebnTRqc=;
  b=C1MofU7C1ZfVMroNkoRttYeuJnNsGduSlHpXxTy8Ciy/EqSc0ojn7I3M
   znLX/kxcYr+4R+9+mXq8pL0WL5I5+pJf5sqOmGlBTEnJoRQVAaBze8ePv
   yXOZMxX8gR4VIX+KKFGgf94egJCn6cSPzIdI8aYTLXCWYF/FbRrYXcNKA
   C2Rwrt68cjx8wnyLzTdPGbLEeO3kUIeiL8Nq/9N/osIWsheIw48Yc1ZON
   rZz/cShwhAOwU0QR56MYGf46tQsjv3lgcyVkfFJrFU8uWQ2Hc6fj8zzT+
   PF8PfT/Mg9lUj69zfbaX6K4qJ/3OItliJqwbSslxfjv90mhG9CSNGUUNA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="368569763"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="368569763"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 00:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="827772848"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="827772848"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 00:24:45 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Wed, 29 Mar 2023 09:24:15 +0200
Subject: [PATCH v6 4/8] lib/ref_tracker: remove warnings in case of allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v6-4-0dc8601fd02f@intel.com>
References: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
In-Reply-To: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
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
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
