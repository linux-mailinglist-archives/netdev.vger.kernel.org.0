Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D46A6A04
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfICNhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:37:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:29014 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfICNhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 09:37:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 06:37:39 -0700
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="182125814"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 06:37:36 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     jani.nikula@intel.com,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/2] linux/kernel.h: add yesno(), onoff(), enableddisabled(), plural() helpers
Date:   Tue,  3 Sep 2019 16:37:30 +0300
Message-Id: <20190903133731.2094-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel has plenty of ternary operators to choose between constant
strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
"s":

$ git grep '? "yes" : "no"' | wc -l
258
$ git grep '? "on" : "off"' | wc -l
204
$ git grep '? "enabled" : "disabled"' | wc -l
196
$ git grep '? "" : "s"' | wc -l
25

Additionally, there are some occurences of the same in reverse order,
split to multiple lines, or otherwise not caught by the simple grep.

Add helpers to return the constant strings. Remove existing equivalent
and conflicting functions in i915, cxgb4, and USB core. Further
conversion can be done incrementally.

While the main goal here is to abstract recurring patterns, and slightly
clean up the code base by not open coding the ternary operators, there
are also some space savings to be had via better string constant
pooling.

Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: Vishal Kulkarni <vishal@chelsio.com>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/i915_utils.h             | 15 -------------
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 11 ----------
 drivers/usb/core/config.c                     |  5 -----
 drivers/usb/core/generic.c                    |  5 -----
 include/linux/kernel.h                        | 21 +++++++++++++++++++
 5 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 2987219a6300..9754e277622f 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -355,19 +355,4 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
 #define MBps(x) KBps(1000 * (x))
 #define GBps(x) ((u64)1000 * MBps((x)))
 
-static inline const char *yesno(bool v)
-{
-	return v ? "yes" : "no";
-}
-
-static inline const char *onoff(bool v)
-{
-	return v ? "on" : "off";
-}
-
-static inline const char *enableddisabled(bool v)
-{
-	return v ? "enabled" : "disabled";
-}
-
 #endif /* !__I915_UTILS_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index d692251ee252..d0be14d93df7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2023,17 +2023,6 @@ static const struct file_operations rss_debugfs_fops = {
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
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 9d6cb709ca7b..7da06aa06ced 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -19,11 +19,6 @@
 #define USB_MAXCONFIG			8	/* Arbitrary limit */
 
 
-static inline const char *plural(int n)
-{
-	return (n == 1 ? "" : "s");
-}
-
 static int find_next_descriptor(unsigned char *buffer, int size,
     int dt1, int dt2, int *num_skipped)
 {
diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 1ac9c1e5f773..95a87b6cd35f 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -24,11 +24,6 @@
 #include <uapi/linux/usb/audio.h>
 #include "usb.h"
 
-static inline const char *plural(int n)
-{
-	return (n == 1 ? "" : "s");
-}
-
 static int is_rndis(struct usb_interface_descriptor *desc)
 {
 	return desc->bInterfaceClass == USB_CLASS_COMM
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4fa360a13c1e..3375f054aefd 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -1008,4 +1008,25 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
 	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
 	 (perms))
+
+static inline const char *yesno(bool v)
+{
+	return v ? "yes" : "no";
+}
+
+static inline const char *onoff(bool v)
+{
+	return v ? "on" : "off";
+}
+
+static inline const char *enableddisabled(bool v)
+{
+	return v ? "enabled" : "disabled";
+}
+
+static inline const char *plural(long v)
+{
+	return v == 1 ? "" : "s";
+}
+
 #endif
-- 
2.20.1

