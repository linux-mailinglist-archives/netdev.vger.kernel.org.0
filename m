Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BA3C2E9B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbfJAIHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:07:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:18682 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfJAIHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:07:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 01:07:48 -0700
X-IronPort-AV: E=Sophos;i="5.64,570,1559545200"; 
   d="scan'208";a="190517127"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 01:07:44 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jani Nikula <jani.nikula@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v3] string-choice: add yesno(), onoff(), enableddisabled(), plural() helpers
Date:   Tue,  1 Oct 2019 11:07:39 +0300
Message-Id: <20191001080739.18513-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk>
References: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset=UTF-8
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
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # v1
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

v2: add string-choice.[ch] to not clutter kernel.h and to actually save
space on string constants.

v3: back to static inlines based on Rasmus' feedback

Example of further cleanup possibilities are at [1], to be done
incrementally afterwards.

[1] http://lore.kernel.org/r/20190903133731.2094-2-jani.nikula@intel.com
---
 drivers/gpu/drm/i915/i915_utils.h             | 16 +---------
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 12 +------
 drivers/usb/core/config.c                     |  6 +---
 drivers/usb/core/generic.c                    |  6 +---
 include/linux/string-choice.h                 | 31 +++++++++++++++++++
 5 files changed, 35 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/string-choice.h

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 562f756da421..794f02a90efe 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -28,6 +28,7 @@
 #include <linux/list.h>
 #include <linux/overflow.h>
 #include <linux/sched.h>
+#include <linux/string-choice.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -395,21 +396,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
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
 static inline void add_taint_for_CI(unsigned int taint)
 {
 	/*
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index ae6a47dd7dc9..d9123dae1d00 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -35,6 +35,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/string_helpers.h>
+#include <linux/string-choice.h>
 #include <linux/sort.h>
 #include <linux/ctype.h>
 
@@ -2023,17 +2024,6 @@ static const struct file_operations rss_debugfs_fops = {
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
index 151a74a54386..52cee9067eb4 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/string-choice.h>
 #include <asm/byteorder.h>
 #include "usb.h"
 
@@ -19,11 +20,6 @@
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
index 38f8b3e31762..a784a09794d6 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -21,14 +21,10 @@
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/string-choice.h>
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
diff --git a/include/linux/string-choice.h b/include/linux/string-choice.h
new file mode 100644
index 000000000000..320b598bd8f0
--- /dev/null
+++ b/include/linux/string-choice.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2019 Intel Corporation
+ */
+
+#ifndef __STRING_CHOICE_H__
+#define __STRING_CHOICE_H__
+
+#include <linux/types.h>
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
+#endif /* __STRING_CHOICE_H__ */
-- 
2.20.1

