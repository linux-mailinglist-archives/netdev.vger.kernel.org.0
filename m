Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D3F3B9BD6
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhGBFIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:08:34 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:39492 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhGBFI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 01:08:28 -0400
Received: by mail-pg1-f169.google.com with SMTP id a2so8475270pgi.6;
        Thu, 01 Jul 2021 22:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCx6J6PfIyX91HfgPbEqDtk3MeO09EffMMHkaAbKWBw=;
        b=IF65HaNTLvWXxny8YT9TVd/+zfMZJksW5wasN5suZWawa9fSJaOUDg+RlcxxFsdg3O
         PSiTEEuOCMhgaR+c08h6fePeecXHN0V7yPxIFaCY8pnkypM06u57Y7A+xdal2JtENY5P
         Comq+BLohZXEnlnohcLoiMgoiZxOjpVAQhDSn7KYvugCda+bbvcgW4zY6KJizn1dToAl
         K4QN800phTA+BNRkV5vnz5BdB4P/i2LnpKj/RtaR4IYypKqIl8XL1fTEfljTkN0n2fmV
         iCaKjYwuZudbG6FXUq+YrC3Rc7Oqi8znP3Gj7SmBh8IiPrK8v76CaqHJAT+N2vZxu8Os
         t2xA==
X-Gm-Message-State: AOAM530r8VXkYvFiDveC1BNcTQ4OO74+kGc1dCLA/lqesAgrzXS4H4TE
        tiJpHcOeBnrmjQNmWd1TcQA=
X-Google-Smtp-Source: ABdhPJzgLgaGZeCWbA1xLs7v3qGVvuNYhL+ejSTf60K3A+2TqR3EdgesuMJAvOP9vok9sl1brwj2bw==
X-Received: by 2002:a63:2dc6:: with SMTP id t189mr3315907pgt.442.1625202355677;
        Thu, 01 Jul 2021 22:05:55 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id e3sm1838814pge.85.2021.07.01.22.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 22:05:54 -0700 (PDT)
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
Subject: [PATCH 2/4] kernfs: add initial failure injection support
Date:   Thu,  1 Jul 2021 22:05:41 -0700
Message-Id: <20210702050543.2693141-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702050543.2693141-1-mcgrof@kernel.org>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
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
---
 .../fault-injection/fault-injection.rst       | 22 +++++
 MAINTAINERS                                   |  2 +-
 fs/kernfs/Makefile                            |  1 +
 fs/kernfs/failure-injection.c                 | 82 +++++++++++++++++++
 fs/kernfs/file.c                              | 13 +++
 fs/kernfs/kernfs-internal.h                   | 73 +++++++++++++++++
 include/linux/kernfs.h                        |  5 ++
 lib/Kconfig.debug                             | 10 +++
 8 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 fs/kernfs/failure-injection.c

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 31ecfe44e5b4..1cbeb1d16a23 100644
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
index 76f6bee86770..41e12dfaa528 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10065,7 +10065,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
index 000000000000..20ac895b00c7
--- /dev/null
+++ b/fs/kernfs/failure-injection.c
@@ -0,0 +1,82 @@
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
+void __init kernfs_init_failure_injection(void)
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
index ccc3b44f6306..aa80fd927df7 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -17,6 +17,7 @@
 
 #include <linux/kernfs.h>
 #include <linux/fs_context.h>
+#include <linux/stringify.h>
 
 struct kernfs_iattrs {
 	kuid_t			ia_uid;
@@ -127,4 +128,76 @@ void kernfs_drain_open_files(struct kernfs_node *kn);
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
+void kernfs_init_failure_injection(void);
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
index f9b9074c40f4..9d3c0d0db0f3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1917,6 +1917,16 @@ config FAULT_INJECTION_USERCOPY
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

