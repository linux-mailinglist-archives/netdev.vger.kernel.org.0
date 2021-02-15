Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055D831BAF4
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBOOXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:23:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:39382 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhBOOXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 09:23:46 -0500
IronPort-SDR: zRN+L/5X7Vz6AKVSoVFsyAGvpMY7lATcljCPKpB5V1Csbw84oE5IsnjijBb0RjfZM1j4kgTpmU
 AVPNeMH+BmbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9895"; a="179190196"
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="scan'208";a="179190196"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 06:21:59 -0800
IronPort-SDR: FCMRpCe1wqWToEDOuR4p3xD8eTrfb+0xgVw9TpJbJnhvdWYjZa/OlhEhZBil5dSPZAi0g5Ubji
 syY4bvn1+o6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="scan'208";a="361288896"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2021 06:21:54 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3C7F914A; Mon, 15 Feb 2021 16:21:52 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/3] string: Consolidate yesno() helpers under string.h hood
Date:   Mon, 15 Feb 2021 16:21:35 +0200
Message-Id: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have already few similar implementation and a lot of code that can benefit
of the yesno() helper.  Consolidate yesno() helpers under string.h hood.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c    |  6 +-----
 drivers/gpu/drm/i915/i915_utils.h                    |  6 +-----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c   | 12 +-----------
 include/linux/string.h                               |  5 +++++
 4 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 360952129b6d..7fde4f90e513 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include <drm/drm_debugfs.h>
@@ -49,11 +50,6 @@ struct dmub_debugfs_trace_entry {
 	uint32_t param1;
 };
 
-static inline const char *yesno(bool v)
-{
-	return v ? "yes" : "no";
-}
-
 /* parse_write_buffer_into_params - Helper function to parse debugfs write buffer into an array
  *
  * Function takes in attributes passed to debugfs write entry
diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index abd4dcd9f79c..e6da5a951132 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -27,6 +27,7 @@
 
 #include <linux/list.h>
 #include <linux/overflow.h>
+#include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -408,11 +409,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
 #define MBps(x) KBps(1000 * (x))
 #define GBps(x) ((u64)1000 * MBps((x)))
 
-static inline const char *yesno(bool v)
-{
-	return v ? "yes" : "no";
-}
-
 static inline const char *onoff(bool v)
 {
 	return v ? "on" : "off";
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 7d49fd4edc9e..c857d73abbd7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -34,6 +34,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/string.h>
 #include <linux/string_helpers.h>
 #include <linux/sort.h>
 #include <linux/ctype.h>
@@ -2015,17 +2016,6 @@ static const struct file_operations rss_debugfs_fops = {
 /* RSS Configuration.
  */
 
-/* Small utility function to return the strings "yes" or "no" if the supplied
- * argument is non-zero.
- */
-static const char *yesno(int x)
-{
-	static const char *yes = "yes";
-	static const char *no = "no";
-
-	return x ? yes : no;
-}
-
 static int rss_config_show(struct seq_file *seq, void *v)
 {
 	struct adapter *adapter = seq->private;
diff --git a/include/linux/string.h b/include/linux/string.h
index 9521d8cab18e..fd946a5e18c8 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -308,4 +308,9 @@ static __always_inline size_t str_has_prefix(const char *str, const char *prefix
 	return strncmp(str, prefix, len) == 0 ? len : 0;
 }
 
+static inline const char *yesno(bool yes)
+{
+	return yes ? "yes" : "no";
+}
+
 #endif /* _LINUX_STRING_H_ */
-- 
2.30.0

