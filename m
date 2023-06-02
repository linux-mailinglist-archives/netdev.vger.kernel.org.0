Return-Path: <netdev+bounces-7371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D137B71FEE8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51DC81C20A3E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5C4182BE;
	Fri,  2 Jun 2023 10:21:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ABB18019
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:21:57 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976A1BB;
	Fri,  2 Jun 2023 03:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685701316; x=1717237316;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=zE3fWaYeE6trgqGwGYv7PWW89Tapp2xoEGU1qSP+vII=;
  b=iw1L7hlJnicpg/DVb7yMCDA4lOaQrkGLwkqEZhJRmLouCnS/oIv5HsWT
   dubeogLVr0l7xV0LrlHD5NLS83sRK8go45DGSbcic3/QnjiwkDe+8XO+C
   VxUaj/BMiQ/AdLcTXwz8bA3fFKhrtpNOnuA2lVwR5Pp4mYeCRk3LtzZnS
   ucZiJrsxOP6Pe/+6l6SS9F7LxVjXiIShaxlb3Mdyo6xMIAaKaA1Z99aP0
   7AJ6Tsm/mDHR67d9rqW4o83mglNqo9dpejco+xXqUCr/pwF1BOSmceQ8V
   A3uGOEY3eSkAPB8Ae0j/Uj0vJKrBCkaRPA+juqxumVHxu2W/ueLgB5Sba
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="358267589"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="358267589"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:21:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="707804960"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="707804960"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:21:52 -0700
From: Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH v9 0/4] drm/i915: use ref_tracker library for tracking
 wakerefs
Date: Fri, 02 Jun 2023 12:21:32 +0200
Message-Id: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKzCeWQC/3XQwU7EIBQF0F+ZsBYFSoG68j+MMfB4TIkz1ABpx
 kz678LsbOzyPjhc4E4K5oiFvJ7uJOMaS1xSC9PTicBs0xlp9C0TwcTAhJC0Zgtfn+dKuRu8Nc5
 b8Jq07c4WpC7bBHMHCStNeKsvVxtTX//OGOLtUfX+0fIcS13yz6N55X36T8nKKaNtJNikAnhQb
 zFVvDzDciX9kFUeQdmgVBKNdRIm6/ZwPIJjg1o7NCoIMFrsoTqCql/Vg1GMB89E2EN9BHWDnAd
 mhtEAR9hDcwRNf6NTI9eouMM/n7Nt2y+0EXL23QEAAA==
To: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, 
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>, 
 netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
 Andi Shyti <andi.shyti@linux.intel.com>, 
 Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

This is reviewed series of ref_tracker patches, ready to merge
via network tree, rebased on net-next/main.
i915 patches will be merged later via intel-gfx tree.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
Changes in v9:
- removed i915 patches, just to merge network part
- added r-b-s
- Link to v8: https://lore.kernel.org/r/20230224-track_gt-v8-0-4b6517e61be6@intel.com

Changes in v8:
- addressed comments from Eric, Zhou and CI, thanks,
- added ref_tracker_dir_init name argument to all callers in one patch
- moved intel_wakeref_tracker_show to *.c
- s/intel_wakeref_tracker_show/intel_ref_tracker_show/
- removed 'default n' from Kconfig
- changed strlcpy to strscpy,
- removed assignement from if condition,
- removed long lines from patch description
- added tags
- Link to v7: https://lore.kernel.org/r/20230224-track_gt-v7-0-11f08358c1ec@intel.com

Changes in v7:
- removed 8th patch (hold wakeref), as it was already merged
- added tags (thx Andi)
- Link to v6: https://lore.kernel.org/r/20230224-track_gt-v6-0-0dc8601fd02f@intel.com

Changes in v6:
- rebased to solve minor conflict and allow CI testing
- Link to v5: https://lore.kernel.org/r/20230224-track_gt-v5-0-77be86f2c872@intel.com

Changes in v5 (thx Andi for review):
- use *_locked convention instead of __*,
- improved commit messages,
- re-worked i915 patches, squashed separation and conversion patches,
- added tags,
- Link to v4: https://lore.kernel.org/r/20230224-track_gt-v4-0-464e8ab4c9ab@intel.com

Changes in v4:
- split "Separate wakeref tracking" to smaller parts
- fixed typos,
- Link to v1-v3: https://patchwork.freedesktop.org/series/100327/

---
Andrzej Hajda (4):
      lib/ref_tracker: add unlocked leak print helper
      lib/ref_tracker: improve printing stats
      lib/ref_tracker: add printing to memory buffer
      lib/ref_tracker: remove warnings in case of allocation failure

 include/linux/ref_tracker.h |  25 ++++++-
 lib/ref_tracker.c           | 179 ++++++++++++++++++++++++++++++++++++--------
 lib/test_ref_tracker.c      |   2 +-
 net/core/dev.c              |   2 +-
 net/core/net_namespace.c    |   4 +-
 5 files changed, 176 insertions(+), 36 deletions(-)
---
base-commit: 23fcb62bc19c37adb72a585d5dc702ac55b74fb1
change-id: 20230224-track_gt-1b3da8bdacd7

Best regards,
-- 
Andrzej Hajda <andrzej.hajda@intel.com>


