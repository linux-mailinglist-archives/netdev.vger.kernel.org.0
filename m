Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD4D3BA683
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 02:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhGCAtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 20:49:22 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43703 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhGCAtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 20:49:19 -0400
Received: by mail-pf1-f173.google.com with SMTP id a127so10677544pfa.10;
        Fri, 02 Jul 2021 17:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ykYM5WRrnE1nm+O/fDZiZNjtxGSEofuXtbIkwGTHmzU=;
        b=esXkfayUayN4Mk4yVn63dJzk29g2D1Pw/GdpCXlisTYFjAWbE2+M0qVLE8ojW+/6FD
         /pLdXAdfN+UOpdLi449MKx6x+OUtiABUVm82Zu2r/zqO2L51aqpJ5N4kAzGNDoSnpVPl
         Yqe8jWoimRmGNrMvbSfKgTVhofxO43Zax2VLuos9jKPN4zg0VGN/B6LMo5xAQRlb1rgw
         k75h3rtcgMYYN5v6iFITJUI8ugFQAg5aYxweHe2H+QgJarFXCrFMlL9nuRENuHrSYw5j
         7Y2X4H4hDSm7boIJVyDmVYJelIgZZC13A9Xt2C7jwhB174v7VVKF6+Tyd5nrkBfc8zSI
         u3ng==
X-Gm-Message-State: AOAM531fAPRO/fniySN5gPliGwDJDm9dPo8y+mCL2IsPjfFhMGN0qvy8
        9lRD6uxd61uGauXyjPCkh0E=
X-Google-Smtp-Source: ABdhPJzkZugUCvsS4bqLBBREOquIOgH37m655YWFnvGaqcj5Yic27emXJlQCc67IfRP+HNf3VSPKTw==
X-Received: by 2002:a65:6a16:: with SMTP id m22mr2659864pgu.29.1625273205556;
        Fri, 02 Jul 2021 17:46:45 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id a65sm668448pfa.11.2021.07.02.17.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 17:46:44 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] kernfs: add initial failure injection support
Date:   Fri,  2 Jul 2021 17:46:30 -0700
Message-Id: <20210703004632.621662-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210703004632.621662-1-mcgrof@kernel.org>
References: <20210703004632.621662-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds initial failure injection support to kernfs. We start
off with debug knobs which when enabled allow test drivers, such as
test_sysfs, to then make use of these to try to force certain
difficult races to take place with a high degree of certainty.

This only adds runtime code *iff* the new bool CONFIG_FAIL_KERNFS_KNOBS is
enabled in your kernel. If you don't have this enabled this provides
no new functional. When CONFIG_FAIL_KERNFS_KNOBS is disabled the new
routine kernfs_debug_should_wait() ends up being transformed to if
(false), and so the compiler should optimize these out as dead code
producing no new effective binary changes.

We start off with enabling failure injections in kernfs by allowing us to
alter the way kernfs_fop_write_iter() behaves. We allow for the routine
kernfs_fop_write_iter() to wait for a certain condition in the kernel to
occur, after which it will sleep a predefined amount of time. This lets
kernfs users to time exactly when it want kernfs_fop_write_iter() to
complete, allowing for developing race conditions and test for correctness
in kernfs.

You'd boot with this enabled on your kernel command line:

fail_kernfs_fop_write_iter=1,100,0,1

The values are <interval,probability,size,times>, we don't care for
size, so for now we ignore it. The above ensures a failure will trigger
only once.

*How* we allow for this routine to change behaviour is left to knobs we
expose under debugfs:

 # ls -1 /sys/kernel/debug/kernfs/config_fail_kernfs_fop_write_iter/
wait_after_active
wait_after_mutex
wait_at_start
wait_before_mutex

A debugfs entry also exists to allow us to sleep a configurabler amount
of time after the completion:

/sys/kernel/debug/kernfs/sleep_after_wait_ms

These two sets of knobs allow us to construct races and demonstrate
how the kernfs active reference should suffice to project against
races.

Enabling CONFIG_FAULT_INJECTION_DEBUG_FS enables us to configure the
differnt fault injection parametres for the new fail_kernfs_fop_write_iter
fault injection at run time:

ls -1 /sys/kernel/debug/kernfs/fail_kernfs_fop_write_iter/
interval
probability
space
task-filter
times
verbose
verbose_ratelimit_burst
verbose_ratelimit_interval_ms

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

kernfs: fix for latest linux-next

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 .../fault-injection/fault-injection.rst       | 22 +++++
 MAINTAINERS                                   |  2 +-
 fs/kernfs/Makefile                            |  1 +
 fs/kernfs/failure-injection.c                 | 83 +++++++++++++++++++
 fs/kernfs/file.c                              | 13 +++
 fs/kernfs/kernfs-internal.h                   | 72 ++++++++++++++++
 include/linux/kernfs.h                        |  5 ++
 lib/Kconfig.debug                             | 10 +++
 8 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 fs/kernfs/failure-injection.c

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index f47d05ed0d94..d27620196ee8 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -24,6 +24,28 @@ Available fault injection capabilities
 
   injects futex deadlock and uaddr fault errors.
 
+- fail_kernfs_fop_write_iter
+
+  Allows for failures to be enabled inside kernfs_fop_write_iter(). Enabling
+  this does not immediately enable any errors to occur. You must configure
+  how you want this routine to fail or change behaviour by using the debugfs
+  knobs for it:
+
+  # ls -1 /sys/kernel/debug/kernfs/config_fail_kernfs_fop_write_iter/
+  wait_after_active
+  wait_after_mutex
+  wait_at_start
+  wait_before_mutex
+
+  You can also configure how long to sleep after a wait under
+
+  /sys/kernel/debug/kernfs/sleep_after_wait_ms
+
+  If you enable CONFIG_FAULT_INJECTION_DEBUG_FS the fail_add_disk failure
+  injection parameters are placed under:
+
+  /sys/kernel/debug/kernfs/fail_kernfs_fop_write_iter/
+
 - fail_make_request
 
   injects disk IO errors on devices permitted by setting
diff --git a/MAINTAINERS b/MAINTAINERS
index fd369ed50040..419405b2378a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10246,7 +10246,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	Tejun Heo <tj@kernel.org>
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
-F:	fs/kernfs/
+F:	fs/kernfs/*
 F:	include/linux/kernfs.h
 
 KEXEC
diff --git a/fs/kernfs/Makefile b/fs/kernfs/Makefile
index 4ca54ff54c98..bc5b32ca39f9 100644
--- a/fs/kernfs/Makefile
+++ b/fs/kernfs/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-y		:= mount.o inode.o dir.o file.o symlink.o
+obj-$(CONFIG_FAIL_KERNFS_KNOBS)    += failure-injection.o
diff --git a/fs/kernfs/failure-injection.c b/fs/kernfs/failure-injection.c
new file mode 100644
index 000000000000..7019385e8145
--- /dev/null
+++ b/fs/kernfs/failure-injection.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/fault-inject.h>
+#include <linux/delay.h>
+
+#include "kernfs-internal.h"
+
+static DECLARE_FAULT_ATTR(fail_kernfs_fop_write_iter);
+struct kernfs_config_fail kernfs_config_fail;
+
+#define kernfs_config_fail(when) \
+	kernfs_config_fail.kernfs_fop_write_iter_fail.wait_ ## when
+
+#define kernfs_config_fail(when) \
+	kernfs_config_fail.kernfs_fop_write_iter_fail.wait_ ## when
+
+static int __init setup_fail_kernfs_fop_write_iter(char *str)
+{
+	return setup_fault_attr(&fail_kernfs_fop_write_iter, str);
+}
+
+__setup("fail_kernfs_fop_write_iter=", setup_fail_kernfs_fop_write_iter);
+
+struct dentry *kernfs_debugfs_root;
+struct dentry *config_fail_kernfs_fop_write_iter;
+
+static int __init kernfs_init_failure_injection(void)
+{
+	kernfs_config_fail.sleep_after_wait_ms = 100;
+	kernfs_debugfs_root = debugfs_create_dir("kernfs", NULL);
+
+	fault_create_debugfs_attr("fail_kernfs_fop_write_iter",
+				  kernfs_debugfs_root, &fail_kernfs_fop_write_iter);
+
+	config_fail_kernfs_fop_write_iter =
+		debugfs_create_dir("config_fail_kernfs_fop_write_iter",
+				   kernfs_debugfs_root);
+
+	debugfs_create_u32("sleep_after_wait_ms", 0600,
+			   kernfs_debugfs_root,
+			   &kernfs_config_fail.sleep_after_wait_ms);
+
+	debugfs_create_bool("wait_at_start", 0600,
+			    config_fail_kernfs_fop_write_iter,
+			    &kernfs_config_fail(at_start));
+	debugfs_create_bool("wait_before_mutex", 0600,
+			    config_fail_kernfs_fop_write_iter,
+			    &kernfs_config_fail(before_mutex));
+	debugfs_create_bool("wait_after_mutex", 0600,
+			    config_fail_kernfs_fop_write_iter,
+			    &kernfs_config_fail(after_mutex));
+	debugfs_create_bool("wait_after_active", 0600,
+			    config_fail_kernfs_fop_write_iter,
+			    &kernfs_config_fail(after_active));
+	return 0;
+}
+late_initcall(kernfs_init_failure_injection);
+
+int __kernfs_debug_should_wait_kernfs_fop_write_iter(bool evaluate)
+{
+	if (!evaluate)
+		return 0;
+
+	return should_fail(&fail_kernfs_fop_write_iter, 0);
+}
+
+DECLARE_COMPLETION(kernfs_debug_wait_completion);
+EXPORT_SYMBOL_NS_GPL(kernfs_debug_wait_completion, KERNFS_DEBUG_PRIVATE);
+
+void kernfs_debug_wait(void)
+{
+	wait_for_completion(&kernfs_debug_wait_completion);
+	pr_info("%s received completion\n", __func__);
+
+	/**
+	 * The goal is wait for an event, and *then* once we have
+	 * reached it, the other side will try to do something which
+	 * it thinks will break. So we must give it some time to do
+	 * that. The amount of time is configurable.
+	 */
+	msleep(kernfs_config_fail.sleep_after_wait_ms);
+	pr_info("%s ended\n", __func__);
+}
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index c75719312147..d45954600f11 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -259,6 +259,9 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	const struct kernfs_ops *ops;
 	char *buf;
 
+	if (kernfs_debug_should_wait(kernfs_fop_write_iter, at_start))
+		kernfs_debug_wait();
+
 	if (of->atomic_write_len) {
 		if (len > of->atomic_write_len)
 			return -E2BIG;
@@ -280,17 +283,27 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	}
 	buf[len] = '\0';	/* guarantee string termination */
 
+	if (kernfs_debug_should_wait(kernfs_fop_write_iter, before_mutex))
+		kernfs_debug_wait();
+
 	/*
 	 * @of->mutex nests outside active ref and is used both to ensure that
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
+
+	if (kernfs_debug_should_wait(kernfs_fop_write_iter, after_mutex))
+		kernfs_debug_wait();
+
 	if (!kernfs_get_active(of->kn)) {
 		mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
 	}
 
+	if (kernfs_debug_should_wait(kernfs_fop_write_iter, after_active))
+		kernfs_debug_wait();
+
 	ops = kernfs_ops(of->kn);
 	if (ops->write)
 		len = ops->write(of, buf, len, iocb->ki_pos);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index ccc3b44f6306..221f341991d9 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -17,6 +17,7 @@
 
 #include <linux/kernfs.h>
 #include <linux/fs_context.h>
+#include <linux/stringify.h>
 
 struct kernfs_iattrs {
 	kuid_t			ia_uid;
@@ -127,4 +128,75 @@ void kernfs_drain_open_files(struct kernfs_node *kn);
  */
 extern const struct inode_operations kernfs_symlink_iops;
 
+/*
+ * failure-injection.c
+ */
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+
+/**
+ * struct kernfs_fop_write_iter_fail - how kernfs_fop_write_iter_fail fails
+ *
+ * This lets you configure what part of kernfs_fop_write_iter() should behave
+ * in a specific way to allow userspace to capture possible failures in
+ * kernfs. The wait knobs are allowed to let you design capture possible
+ * race conditions which would otherwise be difficult to reproduce. A
+ * secondary driver would tell kernfs's wait completion when it is done.
+ *
+ * The point to the wait completion failure injection tests are to confirm
+ * that the kernfs active refcount suffice to ensure other objects in other
+ * layers are also gauranteed to exist, even they are opaque to kernfs. This
+ * includes kobjects, devices, and other objects built on top of this, like
+ * the block layer when using sysfs block device attributes.
+ *
+ * @wait_at_start: waits for completion from a third party at the start of
+ *	the routine.
+ * @wait_before_mutex: waits for completion from a third party before we
+ *	are allowed to continue before the of->mutex is held.
+ * @wait_after_mutex: waits for completion from a third party after we
+ *	have held the of->mutex.
+ * @wait_after_active: waits for completion from a thid party after we
+ *	have refcounted the struct kernfs_node.
+ */
+struct kernfs_fop_write_iter_fail {
+	bool wait_at_start;
+	bool wait_before_mutex;
+	bool wait_after_mutex;
+	bool wait_after_active;
+};
+
+/**
+ * struct kernfs_config_fail - kernfs configuration for failure injection
+ *
+ * You can kernfs failure injection on boot, and in particular we currently
+ * only support failures for kernfs_fop_write_iter(). However, we don't
+ * want to always enable errors on this call when failure injection is enabled
+ * as this routine is used by many parts of the kernel for proper functionality.
+ * The compromise we make is we let userspace start enabling which parts it
+ * wants to fail after boot, if and only if failure injection has been enabled.
+ *
+ * @kernfs_fop_write_iter_fail: configuration for how we want to allow
+ *	for failure injection on kernfs_fop_write_iter()
+ * @sleep_after_wait_ms: how many ms to wait after completion is received.
+ */
+struct kernfs_config_fail {
+	struct kernfs_fop_write_iter_fail kernfs_fop_write_iter_fail;
+	u32 sleep_after_wait_ms;
+};
+
+extern struct kernfs_config_fail kernfs_config_fail;
+
+#define __kernfs_config_wait_var(func, when) \
+	(kernfs_config_fail.  func  ## _fail.wait_  ## when)
+#define __kernfs_debug_should_wait_func_name(func) __kernfs_debug_should_wait_## func
+
+#define kernfs_debug_should_wait(func, when) \
+	__kernfs_debug_should_wait_func_name(func)(__kernfs_config_wait_var(func, when))
+int __kernfs_debug_should_wait_kernfs_fop_write_iter(bool evaluate);
+void kernfs_debug_wait(void);
+#else
+static inline void kernfs_init_failure_injection(void) {}
+#define kernfs_debug_should_wait(when) (false)
+static inline void kernfs_debug_wait(void) {}
+#endif
+
 #endif	/* __KERNFS_INTERNAL_H */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9e8ca8743c26..0da36b8e18e1 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -410,6 +410,11 @@ void kernfs_init(void);
 
 struct kernfs_node *kernfs_find_and_get_node_by_id(struct kernfs_root *root,
 						   u64 id);
+
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+extern struct completion kernfs_debug_wait_completion;
+#endif
+
 #else	/* CONFIG_KERNFS */
 
 static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 568838ac1189..7dbfbfbd3cfc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1930,6 +1930,16 @@ config FAULT_INJECTION_USERCOPY
 	  Provides fault-injection capability to inject failures
 	  in usercopy functions (copy_from_user(), get_user(), ...).
 
+config FAIL_KERNFS_KNOBS
+	bool "Fault-injection support in kernfs"
+	depends on FAULT_INJECTION
+	help
+	  Provide fault-injection capability for kernfs. This only enables
+	  the error injection functionality. To use it you must configure which
+	  which path you want to trigger on error on using debugfs under
+	  /sys/kernel/debug/kernfs/config_fail_kernfs_fop_write_iter/. By
+	  default all of these are disabled.
+
 config FAIL_MAKE_REQUEST
 	bool "Fault-injection capability for disk IO"
 	depends on FAULT_INJECTION && BLOCK
-- 
2.27.0

