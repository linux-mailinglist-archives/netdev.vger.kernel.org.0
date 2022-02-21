Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BEC4BEE4A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiBUXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:18:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiBUXSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:18:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1C324BEA;
        Mon, 21 Feb 2022 15:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485467; x=1677021467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mCvpydHF1iIboEBA+Uw1DVwXJZydjDJfqmrcbQB+Qt0=;
  b=lTyCsGjf2n6WIT2zvreJYX1VNOUc7vhktSEGLfxPuNey+y8dP31QUDP3
   WRZsg6dM+E1eeoKliuJHEuEKNXbt2wIJU1MXDy2CF/mbMggHBVX5jLYLM
   0BhESim1a6+u76B0XVVoCPVOJCDSTC1Emd4qQxXiftJSvGlJ6BvfwlcTn
   0uyUgwKsD8yF7E8W4z3Ja9d4vAxGYPY+cZHtIaotAceAdpyixNzY+g2T3
   ZBM4pnEhihaBNjyAYuc4IDKAB6moOV/WZPqxwzrzETVyoefdtIp5Oanfr
   ynP02eZlZOzMabX7d1m0Im5dJDazcEJ093ZS73t7aOcJusEGDYb9O8Ke/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251530401"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251530401"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="638694463"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:43 -0800
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
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2 03/11] ref_tracker: remove filter_irq_stacks() call
Date:   Tue, 22 Feb 2022 00:16:51 +0100
Message-Id: <20220221231705.1481059-10-andrzej.hajda@intel.com>
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

After commit e94006608949 ("lib/stackdepot: always do filter_irq_stacks()
in stack_depot_save()") it became unnecessary to filter the stack
before calling stack_depot_save().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 lib/ref_tracker.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 9c0c2e09df666..dc7b14aa3431e 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -89,7 +89,6 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 		return -ENOMEM;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
 
 	spin_lock_irqsave(&dir->lock, flags);
@@ -120,7 +119,6 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		return -EEXIST;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
 
 	spin_lock_irqsave(&dir->lock, flags);
-- 
2.25.1

