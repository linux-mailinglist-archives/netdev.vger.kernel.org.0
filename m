Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA6493563
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351991AbiASHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:24:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:35948 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346191AbiASHY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 02:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642577066; x=1674113066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/OrAiPNrt/9lj+aGW23gkFpAZKkskoTrY7P6r7EA2oI=;
  b=JN5X4IyNPaaH4dk3t7+KLARSssPwWYavF+DT2VA0g6pEdZt+RvUSx2LO
   WlcB6rezGNrwJuK+QfYRjkeBYkL3L23NSXTxAQqeUerIIUBzX4dZxOTah
   XOmQwKrXspkMPM8schmyrrjkioubwJ8u6pOnVGFKXiwItmlx4j0TQ28kg
   m+ddofxtr3Q6Jfmgy6JapYuOuJcd50aDYWZZylUSmytCprlmLMVGxQ30A
   GFtRcRVMqz9xvhAL/W+H3qh3soPoIzuXTLGbfEDXBUJpQMrQ0mD2H8xxb
   KgHgYxu8328Tpg7CJUpN1I0U8YgyLiQCysc9rW6tCqPNN67RZDKkk1fis
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="244799929"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="244799929"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:24:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="530544498"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:24:25 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH 1/3] lib/string_helpers: Consolidate yesno() implementation
Date:   Tue, 18 Jan 2022 23:24:48 -0800
Message-Id: <20220119072450.2890107-2-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119072450.2890107-1-lucas.demarchi@intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few implementations of yesno() in the tree. Consolidate them
in include/linux/string_helpers.h.  Quite a few users of open coded
yesno() could later be converted to the new function:

$ git grep '?\s*"yes"\s*' | wc -l
286
$ git grep '?\s*"no"\s*' | wc -l
20

The inlined function should keep the const strings local to each
compilation unit, the same way it's now, thus not changing the current
behavior.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  6 +-----
 drivers/gpu/drm/i915/i915_utils.h              |  5 -----
 .../net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 11 -----------
 include/linux/string_helpers.h                 |  2 ++
 security/tomoyo/audit.c                        |  2 +-
 security/tomoyo/common.c                       | 18 ++++--------------
 security/tomoyo/common.h                       |  1 -
 7 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 9d43ecb1f692..b59760f91bf6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 
 #include "dc.h"
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
index 7a5925072466..2a8781cc648b 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -414,11 +414,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
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
index 7d49fd4edc9e..61a04d7abc1f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2015,17 +2015,6 @@ static const struct file_operations rss_debugfs_fops = {
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
diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 4ba39e1403b2..e980dec05d31 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -102,4 +102,6 @@ char *kstrdup_quotable_file(struct file *file, gfp_t gfp);
 
 void kfree_strarray(char **array, size_t n);
 
+static inline const char *yesno(bool v) { return v ? "yes" : "no"; }
+
 #endif
diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index d79bf07e16be..1458e27361e8 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -166,7 +166,7 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
 		       "#%04u/%02u/%02u %02u:%02u:%02u# profile=%u mode=%s granted=%s (global-pid=%u) task={ pid=%u ppid=%u uid=%u gid=%u euid=%u egid=%u suid=%u sgid=%u fsuid=%u fsgid=%u }",
 		       stamp.year, stamp.month, stamp.day, stamp.hour,
 		       stamp.min, stamp.sec, r->profile, tomoyo_mode[r->mode],
-		       tomoyo_yesno(r->granted), gpid, tomoyo_sys_getpid(),
+		       yesno(r->granted), gpid, tomoyo_sys_getpid(),
 		       tomoyo_sys_getppid(),
 		       from_kuid(&init_user_ns, current_uid()),
 		       from_kgid(&init_user_ns, current_gid()),
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 5c64927bf2b3..304ed0f426dd 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <linux/string_helpers.h>
 #include "common.h"
 
 /* String table for operation mode. */
@@ -174,16 +175,6 @@ static bool tomoyo_manage_by_non_root;
 
 /* Utility functions. */
 
-/**
- * tomoyo_yesno - Return "yes" or "no".
- *
- * @value: Bool value.
- */
-const char *tomoyo_yesno(const unsigned int value)
-{
-	return value ? "yes" : "no";
-}
-
 /**
  * tomoyo_addprintf - strncat()-like-snprintf().
  *
@@ -730,8 +721,8 @@ static void tomoyo_print_config(struct tomoyo_io_buffer *head, const u8 config)
 {
 	tomoyo_io_printf(head, "={ mode=%s grant_log=%s reject_log=%s }\n",
 			 tomoyo_mode[config & 3],
-			 tomoyo_yesno(config & TOMOYO_CONFIG_WANT_GRANT_LOG),
-			 tomoyo_yesno(config & TOMOYO_CONFIG_WANT_REJECT_LOG));
+			 yesno(config & TOMOYO_CONFIG_WANT_GRANT_LOG),
+			 yesno(config & TOMOYO_CONFIG_WANT_REJECT_LOG));
 }
 
 /**
@@ -1354,8 +1345,7 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
 	case 3:
 		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
 			tomoyo_io_printf(head, " grant_log=%s",
-					 tomoyo_yesno(cond->grant_log ==
-						      TOMOYO_GRANTLOG_YES));
+					 yesno(cond->grant_log == TOMOYO_GRANTLOG_YES));
 		tomoyo_set_lf(head);
 		return true;
 	}
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 85246b9df7ca..ca285f362705 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -959,7 +959,6 @@ char *tomoyo_read_token(struct tomoyo_acl_param *param);
 char *tomoyo_realpath_from_path(const struct path *path);
 char *tomoyo_realpath_nofollow(const char *pathname);
 const char *tomoyo_get_exe(void);
-const char *tomoyo_yesno(const unsigned int value);
 const struct tomoyo_path_info *tomoyo_compare_name_union
 (const struct tomoyo_path_info *name, const struct tomoyo_name_union *ptr);
 const struct tomoyo_path_info *tomoyo_get_domainname
-- 
2.34.1

