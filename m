Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75454232E4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhJEVgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:36:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:25070 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhJEVgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:36:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10128"; a="212795849"
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="212795849"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 14:34:25 -0700
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="477855541"
Received: from pwali-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.213.170.68])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 14:34:24 -0700
Date:   Tue, 5 Oct 2021 14:34:23 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under
 string.h hood
Message-ID: <20211005213423.dklsii4jx37pjvb4@ldmartin-desk2>
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:21:35PM +0200, Andy Shevchenko wrote:
>We have already few similar implementation and a lot of code that can benefit
>of the yesno() helper.  Consolidate yesno() helpers under string.h hood.

I was taking a look on i915_utils.h to reduce it and move some of it
elsewhere to be shared with others.  I was starting with these helpers
and had [1] done, then Jani pointed me to this thread and also his
previous tentative. I thought the natural place for this would be
include/linux/string_helpers.h, but I will leave it up to you.

After reading the threads, I don't see real opposition to it.
Is there a tree you plan to take this through?

thanks
Lucas De Marchi

[1] https://lore.kernel.org/lkml/20211005212634.3223113-1-lucas.demarchi@intel.com/T/#u

>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>---
> .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c    |  6 +-----
> drivers/gpu/drm/i915/i915_utils.h                    |  6 +-----
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c   | 12 +-----------
> include/linux/string.h                               |  5 +++++
> 4 files changed, 8 insertions(+), 21 deletions(-)
>
>diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
>index 360952129b6d..7fde4f90e513 100644
>--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
>+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
>@@ -23,6 +23,7 @@
>  *
>  */
>
>+#include <linux/string.h>
> #include <linux/uaccess.h>
>
> #include <drm/drm_debugfs.h>
>@@ -49,11 +50,6 @@ struct dmub_debugfs_trace_entry {
> 	uint32_t param1;
> };
>
>-static inline const char *yesno(bool v)
>-{
>-	return v ? "yes" : "no";
>-}
>-
> /* parse_write_buffer_into_params - Helper function to parse debugfs write buffer into an array
>  *
>  * Function takes in attributes passed to debugfs write entry
>diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
>index abd4dcd9f79c..e6da5a951132 100644
>--- a/drivers/gpu/drm/i915/i915_utils.h
>+++ b/drivers/gpu/drm/i915/i915_utils.h
>@@ -27,6 +27,7 @@
>
> #include <linux/list.h>
> #include <linux/overflow.h>
>+#include <linux/string.h>
> #include <linux/sched.h>
> #include <linux/types.h>
> #include <linux/workqueue.h>
>@@ -408,11 +409,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
> #define MBps(x) KBps(1000 * (x))
> #define GBps(x) ((u64)1000 * MBps((x)))
>
>-static inline const char *yesno(bool v)
>-{
>-	return v ? "yes" : "no";
>-}
>-
> static inline const char *onoff(bool v)
> {
> 	return v ? "on" : "off";
>diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
>index 7d49fd4edc9e..c857d73abbd7 100644
>--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
>+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
>@@ -34,6 +34,7 @@
>
> #include <linux/seq_file.h>
> #include <linux/debugfs.h>
>+#include <linux/string.h>
> #include <linux/string_helpers.h>
> #include <linux/sort.h>
> #include <linux/ctype.h>
>@@ -2015,17 +2016,6 @@ static const struct file_operations rss_debugfs_fops = {
> /* RSS Configuration.
>  */
>
>-/* Small utility function to return the strings "yes" or "no" if the supplied
>- * argument is non-zero.
>- */
>-static const char *yesno(int x)
>-{
>-	static const char *yes = "yes";
>-	static const char *no = "no";
>-
>-	return x ? yes : no;
>-}
>-
> static int rss_config_show(struct seq_file *seq, void *v)
> {
> 	struct adapter *adapter = seq->private;
>diff --git a/include/linux/string.h b/include/linux/string.h
>index 9521d8cab18e..fd946a5e18c8 100644
>--- a/include/linux/string.h
>+++ b/include/linux/string.h
>@@ -308,4 +308,9 @@ static __always_inline size_t str_has_prefix(const char *str, const char *prefix
> 	return strncmp(str, prefix, len) == 0 ? len : 0;
> }
>
>+static inline const char *yesno(bool yes)
>+{
>+	return yes ? "yes" : "no";
>+}
>+
> #endif /* _LINUX_STRING_H_ */
>-- 
>2.30.0
>
>
