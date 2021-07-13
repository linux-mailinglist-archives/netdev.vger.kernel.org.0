Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1116A3C6C37
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhGMIsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:48:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:36908 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhGMIsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 04:48:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="295772335"
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="295772335"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 01:45:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="629972612"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2021 01:45:34 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3C634FF; Tue, 13 Jul 2021 11:46:00 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Brendan Higgins <brendanhiggins@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>, jic23@kernel.org,
        linux@rasmusvillemoes.dk
Subject: [PATCH v1 3/3] kernel.h: Split out container_of() and typeof_memeber() macros
Date:   Tue, 13 Jul 2021 11:45:41 +0300
Message-Id: <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel.h is being used as a dump for all kinds of stuff for a long time.
Here is the attempt cleaning it up by splitting out container_of() and
typeof_memeber() macros.

At the same time convert users in the header and other folders to use it.
Though for time being include new header back to kernel.h to avoid twisted
indirected includes for existing users.

Note, there are _a lot_ of headers and modules that include kernel.h solely
for one of these macros and this allows to unburden compiler for the twisted
inclusion paths and to make new code cleaner in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/kunit/test.h         | 14 ++++++++++++--
 include/linux/container_of.h | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h       | 31 +-----------------------------
 include/linux/kobject.h      | 14 +++++++-------
 include/linux/list.h         |  6 ++++--
 include/linux/llist.h        |  4 +++-
 include/linux/plist.h        |  5 ++++-
 include/media/media-entity.h |  3 ++-
 lib/radix-tree.c             |  6 +++++-
 lib/rhashtable.c             | 17 +++++++++++------
 10 files changed, 86 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/container_of.h

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 24b40e5c160b..d88d9f7ead0a 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -11,11 +11,21 @@
 
 #include <kunit/assert.h>
 #include <kunit/try-catch.h>
-#include <linux/kernel.h>
+
+#include <linux/compiler_attributes.h>
+#include <linux/container_of.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kconfig.h>
+#include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/types.h>
-#include <linux/kref.h>
+
+#include <asm/rwonce.h>
 
 struct kunit_resource;
 
diff --git a/include/linux/container_of.h b/include/linux/container_of.h
new file mode 100644
index 000000000000..f6ee1be0e784
--- /dev/null
+++ b/include/linux/container_of.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CONTAINER_OF_H
+#define _LINUX_CONTAINER_OF_H
+
+#define typeof_member(T, m)	typeof(((T*)0)->m)
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({				\
+	void *__mptr = (void *)(ptr);					\
+	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
+			 !__same_type(*(ptr), void),			\
+			 "pointer type mismatch in container_of()");	\
+	((type *)(__mptr - offsetof(type, member))); })
+
+/**
+ * container_of_safe - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ * If IS_ERR_OR_NULL(ptr), ptr is returned unchanged.
+ */
+#define container_of_safe(ptr, type, member) ({				\
+	void *__mptr = (void *)(ptr);					\
+	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
+			 !__same_type(*(ptr), void),			\
+			 "pointer type mismatch in container_of()");	\
+	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
+		((type *)(__mptr - offsetof(type, member))); })
+
+#endif	/* _LINUX_CONTAINER_OF_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 743d3c9a3227..55ea8e6bf31a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -9,6 +9,7 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/bitops.h>
 #include <linux/kstrtox.h>
 #include <linux/log2.h>
@@ -476,36 +477,6 @@ ftrace_vprintk(const char *fmt, va_list ap)
 static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({				\
-	void *__mptr = (void *)(ptr);					\
-	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
-			 !__same_type(*(ptr), void),			\
-			 "pointer type mismatch in container_of()");	\
-	((type *)(__mptr - offsetof(type, member))); })
-
-/**
- * container_of_safe - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- * If IS_ERR_OR_NULL(ptr), ptr is returned unchanged.
- */
-#define container_of_safe(ptr, type, member) ({				\
-	void *__mptr = (void *)(ptr);					\
-	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
-			 !__same_type(*(ptr), void),			\
-			 "pointer type mismatch in container_of()");	\
-	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
-		((type *)(__mptr - offsetof(type, member))); })
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ea30529fba08..c7284418a6d0 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -15,18 +15,18 @@
 #ifndef _KOBJECT_H_
 #define _KOBJECT_H_
 
-#include <linux/types.h>
-#include <linux/list.h>
-#include <linux/sysfs.h>
+#include <linux/atomic.h>
 #include <linux/compiler.h>
-#include <linux/spinlock.h>
+#include <linux/container_of.h>
+#include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/kobject_ns.h>
-#include <linux/kernel.h>
 #include <linux/wait.h>
-#include <linux/atomic.h>
-#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
 #include <linux/uidgid.h>
+#include <linux/workqueue.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			64	/* number of env pointers */
diff --git a/include/linux/list.h b/include/linux/list.h
index f2af4b4aa4e9..5dc679b373da 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -2,11 +2,13 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
 
+#include <linux/container_of.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
-#include <linux/const.h>
-#include <linux/kernel.h>
+
+#include <asm/barrier.h>
 
 /*
  * Circular doubly linked list implementation.
diff --git a/include/linux/llist.h b/include/linux/llist.h
index 24f207b0190b..85bda2d02d65 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -49,7 +49,9 @@
  */
 
 #include <linux/atomic.h>
-#include <linux/kernel.h>
+#include <linux/container_of.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
 
 struct llist_head {
 	struct llist_node *first;
diff --git a/include/linux/plist.h b/include/linux/plist.h
index 66bab1bca35c..0f352c1d3c80 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -73,8 +73,11 @@
 #ifndef _LINUX_PLIST_H_
 #define _LINUX_PLIST_H_
 
-#include <linux/kernel.h>
+#include <linux/container_of.h>
 #include <linux/list.h>
+#include <linux/types.h>
+
+#include <asm/bug.h>
 
 struct plist_head {
 	struct list_head node_list;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 09737b47881f..fea489f03d57 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -13,10 +13,11 @@
 
 #include <linux/bitmap.h>
 #include <linux/bug.h>
+#include <linux/container_of.h>
 #include <linux/fwnode.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
+#include <linux/types.h>
 
 /* Enums used internally at the media controller to represent graphs */
 
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index b3afafe46fff..a0f346a095df 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -12,19 +12,21 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
+#include <linux/container_of.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/idr.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/kmemleak.h>
+#include <linux/math.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>		/* in_interrupt() */
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/types.h>
 #include <linux/xarray.h>
 
 /*
@@ -285,6 +287,8 @@ radix_tree_node_alloc(gfp_t gfp_mask, struct radix_tree_node *parent,
 	return ret;
 }
 
+extern void radix_tree_node_rcu_free(struct rcu_head *head);
+
 void radix_tree_node_rcu_free(struct rcu_head *head)
 {
 	struct radix_tree_node *node =
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index e12bbfb240b8..64823476bb53 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -12,19 +12,24 @@
  */
 
 #include <linux/atomic.h>
-#include <linux/kernel.h>
+#include <linux/bit_spinlock.h>
+#include <linux/container_of.h>
+#include <linux/err.h>
+#include <linux/export.h>
 #include <linux/init.h>
+#include <linux/jhash.h>
+#include <linux/lockdep.h>
 #include <linux/log2.h>
 #include <linux/sched.h>
-#include <linux/rculist.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/mm.h>
-#include <linux/jhash.h>
+#include <linux/mutex.h>
 #include <linux/random.h>
+#include <linux/rculist.h>
 #include <linux/rhashtable.h>
-#include <linux/err.h>
-#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 
 #define HASH_DEFAULT_SIZE	64UL
 #define HASH_MIN_SIZE		4U
-- 
2.30.2

