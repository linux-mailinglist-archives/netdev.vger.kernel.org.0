Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF14394209
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 13:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhE1LmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 07:42:04 -0400
Received: from foss.arm.com ([217.140.110.172]:39690 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235632AbhE1Ll5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 07:41:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9AC8168F;
        Fri, 28 May 2021 04:40:22 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 889003F73B;
        Fri, 28 May 2021 04:40:16 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Jia He <justin.he@arm.com>
Subject: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for file
Date:   Fri, 28 May 2021 19:39:50 +0800
Message-Id: <20210528113951.6225-3-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210528113951.6225-1-justin.he@arm.com>
References: <20210528113951.6225-1-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have '%pD' for printing a filename. It may not be perfect (by
default it only prints one component.)

As suggested by Linus at [1]:
A dentry has a parent, but at the same time, a dentry really does
inherently have "one name" (and given just the dentry pointers, you
can't show mount-related parenthood, so in many ways the "show just
one name" makes sense for "%pd" in ways it doesn't necessarily for
"%pD"). But while a dentry arguably has that "one primary component",
a _file_ is certainly not exclusively about that last component.

Hence "file_dentry_name()" simply shouldn't use "dentry_name()" at all.
Despite that shared code origin, and despite that similar letter
choice (lower-vs-upper case), a dentry and a file really are very
different from a name standpoint.

Here stack space is preferred for file_d_path_name() because it is
much safer. The stack size 256 is a compromise between stack overflow
and too short full path.

[1] https://lore.kernel.org/lkml/CAHk-=wimsMqGdzik187YWLb-ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com/

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jia He <justin.he@arm.com>
---
 Documentation/core-api/printk-formats.rst |  5 +++--
 lib/vsprintf.c                            | 21 +++++++++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index f063a384c7c8..95ba14dc529b 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -408,12 +408,13 @@ dentry names
 ::
 
 	%pd{,2,3,4}
-	%pD{,2,3,4}
+	%pD
 
 For printing dentry name; if we race with :c:func:`d_move`, the name might
 be a mix of old and new ones, but it won't oops.  %pd dentry is a safer
 equivalent of %s dentry->d_name.name we used to use, %pd<n> prints ``n``
-last components.  %pD does the same thing for struct file.
+last components.  %pD prints full file path together with mount-related
+parenthood.
 
 Passed by reference.
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f0c35d9b65bf..2e5387b08d67 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
+#include <linux/dcache.h>
 #include <linux/kallsyms.h>
 #include <linux/math64.h>
 #include <linux/uaccess.h>
@@ -920,13 +921,25 @@ char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_sp
 }
 
 static noinline_for_stack
-char *file_dentry_name(char *buf, char *end, const struct file *f,
+char *file_d_path_name(char *buf, char *end, const struct file *f,
 			struct printf_spec spec, const char *fmt)
 {
+	const struct path *path;
+	char *p;
+	char full_path[256];
+
 	if (check_pointer(&buf, end, f, spec))
 		return buf;
 
-	return dentry_name(buf, end, f->f_path.dentry, spec, fmt);
+	path = &f->f_path;
+	if (check_pointer(&buf, end, path, spec))
+		return buf;
+
+	p = d_path_fast(path, full_path, sizeof(full_path));
+	if (IS_ERR(p))
+		return err_ptr(buf, end, p, spec);
+
+	return string_nocheck(buf, end, p, spec);
 }
 #ifdef CONFIG_BLOCK
 static noinline_for_stack
@@ -2296,7 +2309,7 @@ early_param("no_hash_pointers", no_hash_pointers_enable);
  * - 'a[pd]' For address types [p] phys_addr_t, [d] dma_addr_t and derivatives
  *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
- * - 'D[234]' Same as 'd' but for a struct file
+ * - 'D' For full path name of a struct file
  * - 'g' For block_device name (gendisk + partition number)
  * - 't[RT][dt][r]' For time and date as represented by:
  *      R    struct rtc_time
@@ -2395,7 +2408,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'C':
 		return clock(buf, end, ptr, spec, fmt);
 	case 'D':
-		return file_dentry_name(buf, end, ptr, spec, fmt);
+		return file_d_path_name(buf, end, ptr, spec, fmt);
 #ifdef CONFIG_BLOCK
 	case 'g':
 		return bdev_name(buf, end, ptr, spec, fmt);
-- 
2.17.1

