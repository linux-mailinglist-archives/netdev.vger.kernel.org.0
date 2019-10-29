Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C67E8CC0
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390487AbfJ2Qcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:32:45 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:56614 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390401AbfJ2Qco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:32:44 -0400
Received: by mail-vk1-f201.google.com with SMTP id 63so6690581vkr.23
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 09:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eVNoIfefZ+XIoQSZe2yFMglEi3qqcrN7/R3rTPwzE2k=;
        b=bN568Qkzf9cfzBXGM0tzsRgQ0Lx3EdYzqb1jAt0Bn1//E0V8lDm75XaiuDu2i+Hldk
         r8WeUBTo6fLMAmljFjSiz4hLBsYJMKOfbFUqKinDA+EUy7s3jVEei/BnbHbaK4wddxGD
         vPTxypai6ZkkFjtEIRXMTXdBIRY++o22ms0aqaHBVNNfPAmvZCTSe1egkfkQWaAw3yI4
         JZvlhVV0WPBlAzm3YEc+Jp4l9RUNK01wTQ2NbNjOAoHytNireHNyGchfJWjao5W+u3T+
         l4MYlenB7GZ4BfgSrHvYVfKn7Dsvsa0+j5y1OJ4wX02oRWN3Sau7ojc5aiOdMzsWXjCQ
         arIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eVNoIfefZ+XIoQSZe2yFMglEi3qqcrN7/R3rTPwzE2k=;
        b=MwzpGROWHdz1DDP5x/liRztz6NDxI50TNwYFqpbHV2n5jjPPY+wg26nrBdSrzFtF7q
         ENya4gqTvZVo+FAUBmtusO6t/0H/1C5frXkrfLNmazs0f1zCmu8eYE/ouk2A4avilbZo
         jFf2PWDDG1fd0vgAUBMULqTWgJec/sfJe6LpEEFECwEw2rCqodOJ1SJLr9/fex6Mezi+
         dCIWCFlHnPKcA6HF0UpKjJdNRpaFhTC7arCUIixNaOGUdLd4jWHFwwdqRLpMH+M1567k
         zKx1tj/2mWo+Tedie6vEYLh9eZl412b1IYi6DPfWLIrkZusSFt1QQMHWz+XVPHRWdCSG
         8WVA==
X-Gm-Message-State: APjAAAXKffxUO3HRLLi0BYSl5Q32PlaPI7qUw4xANijAInz+kcDu26ZV
        Prmd3f6j93iEDpUiP3+ys/Y5K1boMaV0GSPG
X-Google-Smtp-Source: APXvYqz7uHV7QPNVpBBr7eWN1kOIqnVZm7Ex5hn2qm9xh3RoXWFoM0j2ut6rUXwCUkdWdzZ2mSz8bfva7folKVuF
X-Received: by 2002:a1f:5c94:: with SMTP id q142mr12039540vkb.85.1572366760456;
 Tue, 29 Oct 2019 09:32:40 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:32:27 +0100
In-Reply-To: <cover.1572366574.git.andreyknvl@google.com>
Message-Id: <e90e315426a384207edbec1d6aa89e43008e4caf.1572366574.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1572366574.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 1/3] kcov: remote coverage support
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds background thread coverage collection ability to kcov.

With KCOV_ENABLE coverage is collected only for syscalls that are issued
from the current process. With KCOV_REMOTE_ENABLE it's possible to collect
coverage for arbitrary parts of the kernel code, provided that those parts
are annotated with kcov_remote_start()/kcov_remote_stop().

This allows to collect coverage from two types of kernel background
threads: the global ones, that are spawned during kernel boot in a limited
number of instances (e.g. one USB hub_event() worker thread is spawned per
USB HCD); and the local ones, that are spawned when a user interacts with
some kernel interface (e.g. vhost workers).

To enable collecting coverage from a global background thread, a unique
global handle must be assigned and passed to the corresponding
kcov_remote_start() call. Then a userspace process can pass a list of such
handles to the KCOV_REMOTE_ENABLE ioctl in the handles array field of the
kcov_remote_arg struct. This will attach the used kcov device to the code
sections, that are referenced by those handles.

Since there might be many local background threads spawned from different
userspace processes, we can't use a single global handle per annotation.
Instead, the userspace process passes a non-zero handle through the
common_handle field of the kcov_remote_arg struct. This common handle gets
saved to the kcov_handle field in the current task_struct and needs to be
passed to the newly spawned threads via custom annotations. Those threads
should in turn be annotated with kcov_remote_start()/kcov_remote_stop().

Internally kcov stores handles as u64 integers. The top byte of a handle
is used to denote the id of a subsystem that this handle belongs to, and
the lower 4 bytes are used to denote the id of a thread instance within
that subsystem. A reserved value 0 is used as a subsystem id for common
handles as they don't belong to a particular subsystem. The bytes 4-7 are
currently reserved and must be zero. In the future the number of bytes
used for the subsystem or handle ids might be increased.

When a particular userspace proccess collects coverage by via a common
handle, kcov will collect coverage for each code section that is annotated
to use the common handle obtained as kcov_handle from the current
task_struct. However non common handles allow to collect coverage
selectively from different subsystems.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 Documentation/dev-tools/kcov.rst | 129 ++++++++
 include/linux/kcov.h             |  23 ++
 include/linux/sched.h            |   8 +
 include/uapi/linux/kcov.h        |  28 ++
 kernel/kcov.c                    | 547 +++++++++++++++++++++++++++++--
 5 files changed, 700 insertions(+), 35 deletions(-)

diff --git a/Documentation/dev-tools/kcov.rst b/Documentation/dev-tools/kcov.rst
index 42b612677799..36890b026e77 100644
--- a/Documentation/dev-tools/kcov.rst
+++ b/Documentation/dev-tools/kcov.rst
@@ -34,6 +34,7 @@ Profiling data will only become accessible once debugfs has been mounted::
 
 Coverage collection
 -------------------
+
 The following program demonstrates coverage collection from within a test
 program using kcov:
 
@@ -128,6 +129,7 @@ only need to enable coverage (disable happens automatically on thread end).
 
 Comparison operands collection
 ------------------------------
+
 Comparison operands collection is similar to coverage collection:
 
 .. code-block:: c
@@ -202,3 +204,130 @@ Comparison operands collection is similar to coverage collection:
 
 Note that the kcov modes (coverage collection or comparison operands) are
 mutually exclusive.
+
+Remote coverage collection
+--------------------------
+
+With KCOV_ENABLE coverage is collected only for syscalls that are issued
+from the current process. With KCOV_REMOTE_ENABLE it's possible to collect
+coverage for arbitrary parts of the kernel code, provided that those parts
+are annotated with kcov_remote_start()/kcov_remote_stop().
+
+This allows to collect coverage from two types of kernel background
+threads: the global ones, that are spawned during kernel boot in a limited
+number of instances (e.g. one USB hub_event() worker thread is spawned per
+USB HCD); and the local ones, that are spawned when a user interacts with
+some kernel interface (e.g. vhost workers).
+
+To enable collecting coverage from a global background thread, a unique
+global handle must be assigned and passed to the corresponding
+kcov_remote_start() call. Then a userspace process can pass a list of such
+handles to the KCOV_REMOTE_ENABLE ioctl in the handles array field of the
+kcov_remote_arg struct. This will attach the used kcov device to the code
+sections, that are referenced by those handles.
+
+Since there might be many local background threads spawned from different
+userspace processes, we can't use a single global handle per annotation.
+Instead, the userspace process passes a non-zero handle through the
+common_handle field of the kcov_remote_arg struct. This common handle gets
+saved to the kcov_handle field in the current task_struct and needs to be
+passed to the newly spawned threads via custom annotations. Those threads
+should in turn be annotated with kcov_remote_start()/kcov_remote_stop().
+
+Internally kcov stores handles as u64 integers. The top byte of a handle
+is used to denote the id of a subsystem that this handle belongs to, and
+the lower 4 bytes are used to denote the id of a thread instance within
+that subsystem. A reserved value 0 is used as a subsystem id for common
+handles as they don't belong to a particular subsystem. The bytes 4-7 are
+currently reserved and must be zero. In the future the number of bytes
+used for the subsystem or handle ids might be increased.
+
+When a particular userspace proccess collects coverage by via a common
+handle, kcov will collect coverage for each code section that is annotated
+to use the common handle obtained as kcov_handle from the current
+task_struct. However non common handles allow to collect coverage
+selectively from different subsystems.
+
+.. code-block:: c
+
+    struct kcov_remote_arg {
+	unsigned	trace_mode;
+	unsigned	area_size;
+	unsigned	num_handles;
+	uint64_t	common_handle;
+	uint64_t	handles[0];
+    };
+
+    #define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
+    #define KCOV_DISABLE			_IO('c', 101)
+    #define KCOV_REMOTE_ENABLE		_IOW('c', 102, struct kcov_remote_arg)
+
+    #define COVER_SIZE	(64 << 10)
+
+    #define KCOV_TRACE_PC	0
+
+    #define KCOV_SUBSYSTEM_COMMON	(0x00ull << 56)
+    #define KCOV_SUBSYSTEM_USB	(0x01ull << 56)
+
+    #define KCOV_SUBSYSTEM_MASK	(0xffull << 56)
+    #define KCOV_INSTANCE_MASK	(0xffffffffull)
+
+    static inline __u64 kcov_remote_handle(__u64 subsys, __u64 inst)
+    {
+	if (subsys & ~KCOV_SUBSYSTEM_MASK || inst & ~KCOV_INSTANCE_MASK)
+		return 0;
+	return subsys | inst;
+    }
+
+    #define KCOV_COMMON_ID	0x42
+    #define KCOV_USB_BUS_NUM	1
+
+    int main(int argc, char **argv)
+    {
+	int fd;
+	unsigned long *cover, n, i;
+	struct kcov_remote_arg *arg;
+
+	fd = open("/sys/kernel/debug/kcov", O_RDWR);
+	if (fd == -1)
+		perror("open"), exit(1);
+	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
+		perror("ioctl"), exit(1);
+	cover = (unsigned long*)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
+				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if ((void*)cover == MAP_FAILED)
+		perror("mmap"), exit(1);
+
+	/* Enable coverage collection via common handle and from USB bus #1. */
+	arg = calloc(1, sizeof(*arg) + sizeof(uint64_t));
+	if (!arg)
+		perror("calloc"), exit(1);
+	arg->trace_mode = KCOV_TRACE_PC;
+	arg->area_size = COVER_SIZE;
+	arg->num_handles = 1;
+	arg->common_handle = kcov_remote_handle(KCOV_SUBSYSTEM_COMMON,
+							KCOV_COMMON_ID);
+	arg->handles[0] = kcov_remote_handle(KCOV_SUBSYSTEM_USB,
+						KCOV_USB_BUS_NUM);
+	if (ioctl(fd, KCOV_REMOTE_ENABLE, arg))
+		perror("ioctl"), free(arg), exit(1);
+	free(arg);
+
+	/*
+	 * Here the user needs to trigger execution of a kernel code section
+	 * that is either annotated with the common handle, or to trigger some
+	 * activity on USB bus #1.
+	 */
+	sleep(2);
+
+	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
+	for (i = 0; i < n; i++)
+		printf("0x%lx\n", cover[i + 1]);
+	if (ioctl(fd, KCOV_DISABLE, 0))
+		perror("ioctl"), exit(1);
+	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
+		perror("munmap"), exit(1);
+	if (close(fd))
+		perror("close"), exit(1);
+	return 0;
+    }
diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index b76a1807028d..a10e84707d82 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -37,12 +37,35 @@ do {						\
 	(t)->kcov_mode &= ~KCOV_IN_CTXSW;	\
 } while (0)
 
+/* See Documentation/dev-tools/kcov.rst for usage details. */
+void kcov_remote_start(u64 handle);
+void kcov_remote_stop(void);
+u64 kcov_common_handle(void);
+
+static inline void kcov_remote_start_common(u64 id)
+{
+	kcov_remote_start(kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, id));
+}
+
+static inline void kcov_remote_start_usb(u64 id)
+{
+	kcov_remote_start(kcov_remote_handle(KCOV_SUBSYSTEM_USB, id));
+}
+
 #else
 
 static inline void kcov_task_init(struct task_struct *t) {}
 static inline void kcov_task_exit(struct task_struct *t) {}
 static inline void kcov_prepare_switch(struct task_struct *t) {}
 static inline void kcov_finish_switch(struct task_struct *t) {}
+static inline void kcov_remote_start(u64 handle) {}
+static inline void kcov_remote_stop(void) {}
+static inline u64 kcov_common_handle(void)
+{
+	return 0;
+}
+static inline void kcov_remote_start_common(u64 id) {}
+static inline void kcov_remote_start_usb(u64 id) {}
 
 #endif /* CONFIG_KCOV */
 #endif /* _LINUX_KCOV_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 67a1d86981a9..cb037c6ed72f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1203,6 +1203,8 @@ struct task_struct {
 #endif /* CONFIG_TRACING */
 
 #ifdef CONFIG_KCOV
+	/* See kernel/kcov.c for more details. */
+
 	/* Coverage collection mode enabled for this task (0 if disabled): */
 	unsigned int			kcov_mode;
 
@@ -1214,6 +1216,12 @@ struct task_struct {
 
 	/* KCOV descriptor wired with this task or NULL: */
 	struct kcov			*kcov;
+
+	/* KCOV common handle for remote coverage collection: */
+	u64				kcov_handle;
+
+	/* KCOV sequence number: */
+	int				kcov_sequence;
 #endif
 
 #ifdef CONFIG_MEMCG
diff --git a/include/uapi/linux/kcov.h b/include/uapi/linux/kcov.h
index 9529867717a8..409d3ad1e6e2 100644
--- a/include/uapi/linux/kcov.h
+++ b/include/uapi/linux/kcov.h
@@ -4,9 +4,24 @@
 
 #include <linux/types.h>
 
+/*
+ * Argument for KCOV_REMOTE_ENABLE ioctl, see Documentation/dev-tools/kcov.rst
+ * and the comment before kcov_remote_start() for usage details.
+ */
+struct kcov_remote_arg {
+	unsigned int	trace_mode;	/* KCOV_TRACE_PC or KCOV_TRACE_CMP */
+	unsigned int	area_size;	/* Length of coverage buffer in words */
+	unsigned int	num_handles;	/* Size of handles array */
+	__u64		common_handle;
+	__u64		handles[0];
+};
+
+#define KCOV_REMOTE_MAX_HANDLES		0x100
+
 #define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
 #define KCOV_ENABLE			_IO('c', 100)
 #define KCOV_DISABLE			_IO('c', 101)
+#define KCOV_REMOTE_ENABLE		_IOW('c', 102, struct kcov_remote_arg)
 
 enum {
 	/*
@@ -32,4 +47,17 @@ enum {
 #define KCOV_CMP_SIZE(n)        ((n) << 1)
 #define KCOV_CMP_MASK           KCOV_CMP_SIZE(3)
 
+#define KCOV_SUBSYSTEM_COMMON	(0x00ull << 56)
+#define KCOV_SUBSYSTEM_USB	(0x01ull << 56)
+
+#define KCOV_SUBSYSTEM_MASK	(0xffull << 56)
+#define KCOV_INSTANCE_MASK	(0xffffffffull)
+
+static inline __u64 kcov_remote_handle(__u64 subsys, __u64 inst)
+{
+	if (subsys & ~KCOV_SUBSYSTEM_MASK || inst & ~KCOV_INSTANCE_MASK)
+		return 0;
+	return subsys | inst;
+}
+
 #endif /* _LINUX_KCOV_IOCTLS_H */
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 2ee38727844a..f50354202dbe 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/hashtable.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/preempt.h>
@@ -21,8 +22,11 @@
 #include <linux/uaccess.h>
 #include <linux/kcov.h>
 #include <linux/refcount.h>
+#include <linux/log2.h>
 #include <asm/setup.h>
 
+#define kcov_debug(fmt, ...) pr_debug("%s: " fmt, __func__, ##__VA_ARGS__)
+
 /* Number of 64-bit words written per one comparison: */
 #define KCOV_WORDS_PER_CMP 4
 
@@ -44,19 +48,100 @@ struct kcov {
 	 * Reference counter. We keep one for:
 	 *  - opened file descriptor
 	 *  - task with enabled coverage (we can't unwire it from another task)
+	 *  - each code section for remote coverage collection
 	 */
 	refcount_t		refcount;
 	/* The lock protects mode, size, area and t. */
 	spinlock_t		lock;
 	enum kcov_mode		mode;
-	/* Size of arena (in long's for KCOV_MODE_TRACE). */
-	unsigned		size;
+	/* Size of arena (in long's). */
+	unsigned int		size;
 	/* Coverage buffer shared with user space. */
 	void			*area;
 	/* Task for which we collect coverage, or NULL. */
 	struct task_struct	*t;
+	/* Collecting coverage from remote (background) threads. */
+	bool			remote;
+	/* Size of remote area (in long's). */
+	unsigned int		remote_size;
+	/*
+	 * Sequence is incremented each time kcov is reenabled, used by
+	 * kcov_remote_stop(), see the comment there.
+	 */
+	int			sequence;
 };
 
+struct kcov_remote_area {
+	struct list_head	list;
+	unsigned int		size;
+};
+
+struct kcov_remote {
+	u64			handle;
+	struct kcov		*kcov;
+	struct hlist_node	hnode;
+};
+
+static DEFINE_SPINLOCK(kcov_remote_lock);
+static DEFINE_HASHTABLE(kcov_remote_map, 4);
+static struct list_head kcov_remote_areas = LIST_HEAD_INIT(kcov_remote_areas);
+
+/* Must be called with kcov_remote_lock locked. */
+static struct kcov_remote *kcov_remote_find(u64 handle)
+{
+	struct kcov_remote *remote;
+
+	hash_for_each_possible(kcov_remote_map, remote, hnode, handle) {
+		if (remote->handle == handle)
+			return remote;
+	}
+	return NULL;
+}
+
+static struct kcov_remote *kcov_remote_add(struct kcov *kcov, u64 handle)
+{
+	struct kcov_remote *remote;
+
+	if (kcov_remote_find(handle))
+		return ERR_PTR(-EEXIST);
+	remote = kmalloc(sizeof(*remote), GFP_ATOMIC);
+	if (!remote)
+		return ERR_PTR(-ENOMEM);
+	remote->handle = handle;
+	remote->kcov = kcov;
+	hash_add(kcov_remote_map, &remote->hnode, handle);
+	return remote;
+}
+
+/* Must be called with kcov_remote_lock locked. */
+static struct kcov_remote_area *kcov_remote_area_get(unsigned int size)
+{
+	struct kcov_remote_area *area;
+	struct list_head *pos;
+
+	kcov_debug("size = %u\n", size);
+	list_for_each(pos, &kcov_remote_areas) {
+		area = list_entry(pos, struct kcov_remote_area, list);
+		if (area->size == size) {
+			list_del(&area->list);
+			kcov_debug("rv = %px\n", area);
+			return area;
+		}
+	}
+	kcov_debug("rv = NULL\n");
+	return NULL;
+}
+
+/* Must be called with kcov_remote_lock locked. */
+static void kcov_remote_area_put(struct kcov_remote_area *area,
+					unsigned int size)
+{
+	kcov_debug("area = %px, size = %u\n", area, size);
+	INIT_LIST_HEAD(&area->list);
+	area->size = size;
+	list_add(&area->list, &kcov_remote_areas);
+}
+
 static notrace bool check_kcov_mode(enum kcov_mode needed_mode, struct task_struct *t)
 {
 	unsigned int mode;
@@ -73,7 +158,7 @@ static notrace bool check_kcov_mode(enum kcov_mode needed_mode, struct task_stru
 	 * in_interrupt() returns false (e.g. preempt_schedule_irq()).
 	 * READ_ONCE()/barrier() effectively provides load-acquire wrt
 	 * interrupts, there are paired barrier()/WRITE_ONCE() in
-	 * kcov_ioctl_locked().
+	 * kcov_start().
 	 */
 	barrier();
 	return mode == needed_mode;
@@ -227,6 +312,78 @@ void notrace __sanitizer_cov_trace_switch(u64 val, u64 *cases)
 EXPORT_SYMBOL(__sanitizer_cov_trace_switch);
 #endif /* ifdef CONFIG_KCOV_ENABLE_COMPARISONS */
 
+static void kcov_start(struct task_struct *t, unsigned int size,
+			void *area, enum kcov_mode mode, int sequence)
+{
+	kcov_debug("t = %px, size = %u, area = %px\n", t, size, area);
+	/* Cache in task struct for performance. */
+	t->kcov_size = size;
+	t->kcov_area = area;
+	/* See comment in check_kcov_mode(). */
+	barrier();
+	WRITE_ONCE(t->kcov_mode, mode);
+	t->kcov_sequence = sequence;
+}
+
+static void kcov_stop(struct task_struct *t)
+{
+	WRITE_ONCE(t->kcov_mode, KCOV_MODE_DISABLED);
+	barrier();
+	t->kcov_size = 0;
+	t->kcov_area = NULL;
+}
+
+static void kcov_task_reset(struct task_struct *t)
+{
+	kcov_stop(t);
+	t->kcov = NULL;
+	t->kcov_sequence = 0;
+	t->kcov_handle = 0;
+}
+
+void kcov_task_init(struct task_struct *t)
+{
+	kcov_task_reset(t);
+	t->kcov_handle = current->kcov_handle;
+}
+
+static void kcov_reset(struct kcov *kcov)
+{
+	kcov->t = NULL;
+	kcov->mode = KCOV_MODE_INIT;
+	kcov->remote = false;
+	kcov->remote_size = 0;
+	kcov->sequence++;
+}
+
+static void kcov_remote_reset(struct kcov *kcov)
+{
+	int bkt;
+	struct kcov_remote *remote;
+	struct hlist_node *tmp;
+
+	spin_lock(&kcov_remote_lock);
+	hash_for_each_safe(kcov_remote_map, bkt, tmp, remote, hnode) {
+		if (remote->kcov != kcov)
+			continue;
+		kcov_debug("removing handle %llx\n", remote->handle);
+		hash_del(&remote->hnode);
+		kfree(remote);
+	}
+	/* Do reset before unlock to prevent races with kcov_remote_start(). */
+	kcov_reset(kcov);
+	spin_unlock(&kcov_remote_lock);
+}
+
+static void kcov_disable(struct task_struct *t, struct kcov *kcov)
+{
+	kcov_task_reset(t);
+	if (kcov->remote)
+		kcov_remote_reset(kcov);
+	else
+		kcov_reset(kcov);
+}
+
 static void kcov_get(struct kcov *kcov)
 {
 	refcount_inc(&kcov->refcount);
@@ -235,20 +392,12 @@ static void kcov_get(struct kcov *kcov)
 static void kcov_put(struct kcov *kcov)
 {
 	if (refcount_dec_and_test(&kcov->refcount)) {
+		kcov_remote_reset(kcov);
 		vfree(kcov->area);
 		kfree(kcov);
 	}
 }
 
-void kcov_task_init(struct task_struct *t)
-{
-	WRITE_ONCE(t->kcov_mode, KCOV_MODE_DISABLED);
-	barrier();
-	t->kcov_size = 0;
-	t->kcov_area = NULL;
-	t->kcov = NULL;
-}
-
 void kcov_task_exit(struct task_struct *t)
 {
 	struct kcov *kcov;
@@ -256,15 +405,36 @@ void kcov_task_exit(struct task_struct *t)
 	kcov = t->kcov;
 	if (kcov == NULL)
 		return;
+
 	spin_lock(&kcov->lock);
+	kcov_debug("t = %px, kcov->t = %px\n", t, kcov->t);
+	/*
+	 * For KCOV_ENABLE devices we want to make sure that t->kcov->t == t,
+	 * which comes down to:
+	 *        WARN_ON(!kcov->remote && kcov->t != t);
+	 *
+	 * For KCOV_REMOTE_ENABLE devices, the exiting task is either:
+	 * 2. A remote task between kcov_remote_start() and kcov_remote_stop().
+	 *    In this case we should print a warning right away, since a task
+	 *    shouldn't be exiting when it's in a kcov coverage collection
+	 *    section. Here t points to the task that is collecting remote
+	 *    coverage, and t->kcov->t points to the thread that created the
+	 *    kcov device. Which means that to detect this case we need to
+	 *    check that t != t->kcov->t, and this gives us the following:
+	 *        WARN_ON(kcov->remote && kcov->t != t);
+	 *
+	 * 2. The task that created kcov exiting without calling KCOV_DISABLE,
+	 *    and then again we can make sure that t->kcov->t == t:
+	 *        WARN_ON(kcov->remote && kcov->t != t);
+	 *
+	 * By combining all three checks into one we get:
+	 */
 	if (WARN_ON(kcov->t != t)) {
 		spin_unlock(&kcov->lock);
 		return;
 	}
 	/* Just to not leave dangling references behind. */
-	kcov_task_init(t);
-	kcov->t = NULL;
-	kcov->mode = KCOV_MODE_INIT;
+	kcov_disable(t, kcov);
 	spin_unlock(&kcov->lock);
 	kcov_put(kcov);
 }
@@ -313,6 +483,7 @@ static int kcov_open(struct inode *inode, struct file *filep)
 	if (!kcov)
 		return -ENOMEM;
 	kcov->mode = KCOV_MODE_DISABLED;
+	kcov->sequence = 1;
 	refcount_set(&kcov->refcount, 1);
 	spin_lock_init(&kcov->lock);
 	filep->private_data = kcov;
@@ -325,6 +496,20 @@ static int kcov_close(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+static int kcov_get_mode(unsigned long arg)
+{
+	if (arg == KCOV_TRACE_PC)
+		return KCOV_MODE_TRACE_PC;
+	else if (arg == KCOV_TRACE_CMP)
+#ifdef CONFIG_KCOV_ENABLE_COMPARISONS
+		return KCOV_MODE_TRACE_CMP;
+#else
+		return -ENOTSUPP;
+#endif
+	else
+		return -EINVAL;
+}
+
 /*
  * Fault in a lazily-faulted vmalloc area before it can be used by
  * __santizer_cov_trace_pc(), to avoid recursion issues if any code on the
@@ -340,14 +525,35 @@ static void kcov_fault_in_area(struct kcov *kcov)
 		READ_ONCE(area[offset]);
 }
 
+static inline bool kcov_check_handle(u64 handle, bool common_valid,
+				bool uncommon_valid, bool zero_valid)
+{
+	if (handle & ~(KCOV_SUBSYSTEM_MASK | KCOV_INSTANCE_MASK))
+		return false;
+	switch (handle & KCOV_SUBSYSTEM_MASK) {
+	case KCOV_SUBSYSTEM_COMMON:
+		return (handle & KCOV_INSTANCE_MASK) ?
+			common_valid : zero_valid;
+	case KCOV_SUBSYSTEM_USB:
+		return uncommon_valid;
+	default:
+		return false;
+	}
+	return false;
+}
+
 static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 			     unsigned long arg)
 {
 	struct task_struct *t;
 	unsigned long size, unused;
+	int mode, i;
+	struct kcov_remote_arg *remote_arg;
+	struct kcov_remote *remote;
 
 	switch (cmd) {
 	case KCOV_INIT_TRACE:
+		kcov_debug("KCOV_INIT_TRACE\n");
 		/*
 		 * Enable kcov in trace mode and setup buffer size.
 		 * Must happen before anything else.
@@ -366,6 +572,7 @@ static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 		kcov->mode = KCOV_MODE_INIT;
 		return 0;
 	case KCOV_ENABLE:
+		kcov_debug("KCOV_ENABLE\n");
 		/*
 		 * Enable coverage for the current task.
 		 * At this point user must have been enabled trace mode,
@@ -378,29 +585,20 @@ static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 		t = current;
 		if (kcov->t != NULL || t->kcov != NULL)
 			return -EBUSY;
-		if (arg == KCOV_TRACE_PC)
-			kcov->mode = KCOV_MODE_TRACE_PC;
-		else if (arg == KCOV_TRACE_CMP)
-#ifdef CONFIG_KCOV_ENABLE_COMPARISONS
-			kcov->mode = KCOV_MODE_TRACE_CMP;
-#else
-		return -ENOTSUPP;
-#endif
-		else
-			return -EINVAL;
+		mode = kcov_get_mode(arg);
+		if (mode < 0)
+			return mode;
 		kcov_fault_in_area(kcov);
-		/* Cache in task struct for performance. */
-		t->kcov_size = kcov->size;
-		t->kcov_area = kcov->area;
-		/* See comment in check_kcov_mode(). */
-		barrier();
-		WRITE_ONCE(t->kcov_mode, kcov->mode);
+		kcov->mode = mode;
+		kcov_start(t, kcov->size, kcov->area, kcov->mode,
+				kcov->sequence);
 		t->kcov = kcov;
 		kcov->t = t;
-		/* This is put either in kcov_task_exit() or in KCOV_DISABLE. */
+		/* Put either in kcov_task_exit() or in KCOV_DISABLE. */
 		kcov_get(kcov);
 		return 0;
 	case KCOV_DISABLE:
+		kcov_debug("KCOV_DISABLE\n");
 		/* Disable coverage for the current task. */
 		unused = arg;
 		if (unused != 0 || current->kcov != kcov)
@@ -408,11 +606,65 @@ static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 		t = current;
 		if (WARN_ON(kcov->t != t))
 			return -EINVAL;
-		kcov_task_init(t);
-		kcov->t = NULL;
-		kcov->mode = KCOV_MODE_INIT;
+		kcov_disable(t, kcov);
 		kcov_put(kcov);
 		return 0;
+	case KCOV_REMOTE_ENABLE:
+		kcov_debug("KCOV_REMOTE_ENABLE\n");
+		if (kcov->mode != KCOV_MODE_INIT || !kcov->area)
+			return -EINVAL;
+		t = current;
+		if (kcov->t != NULL || t->kcov != NULL)
+			return -EBUSY;
+		remote_arg = (struct kcov_remote_arg *)arg;
+		mode = kcov_get_mode(remote_arg->trace_mode);
+		if (mode < 0)
+			return mode;
+		if (remote_arg->area_size > LONG_MAX / sizeof(unsigned long))
+			return -EINVAL;
+		kcov->mode = mode;
+		t->kcov = kcov;
+		kcov->t = t;
+		kcov->remote = true;
+		kcov->remote_size = remote_arg->area_size;
+		spin_lock(&kcov_remote_lock);
+		for (i = 0; i < remote_arg->num_handles; i++) {
+			kcov_debug("handle %llx\n", remote_arg->handles[i]);
+			if (!kcov_check_handle(remote_arg->handles[i],
+						false, true, false)) {
+				spin_unlock(&kcov_remote_lock);
+				kcov_disable(t, kcov);
+				return -EINVAL;
+			}
+			remote = kcov_remote_add(kcov, remote_arg->handles[i]);
+			if (IS_ERR(remote)) {
+				spin_unlock(&kcov_remote_lock);
+				kcov_disable(t, kcov);
+				return PTR_ERR(remote);
+			}
+		}
+		if (remote_arg->common_handle) {
+			kcov_debug("common handle %llx\n",
+					remote_arg->common_handle);
+			if (!kcov_check_handle(remote_arg->common_handle,
+						true, false, false)) {
+				spin_unlock(&kcov_remote_lock);
+				kcov_disable(t, kcov);
+				return -EINVAL;
+			}
+			remote = kcov_remote_add(kcov,
+					remote_arg->common_handle);
+			if (IS_ERR(remote)) {
+				spin_unlock(&kcov_remote_lock);
+				kcov_disable(t, kcov);
+				return PTR_ERR(remote);
+			}
+			t->kcov_handle = remote_arg->common_handle;
+		}
+		spin_unlock(&kcov_remote_lock);
+		/* Put either in kcov_task_exit() or in KCOV_DISABLE. */
+		kcov_get(kcov);
+		return 0;
 	default:
 		return -ENOTTY;
 	}
@@ -422,11 +674,35 @@ static long kcov_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct kcov *kcov;
 	int res;
+	struct kcov_remote_arg *remote_arg = NULL;
+	unsigned int remote_num_handles;
+	unsigned long remote_arg_size;
+
+	if (cmd == KCOV_REMOTE_ENABLE) {
+		if (get_user(remote_num_handles, (unsigned __user *)(arg +
+				offsetof(struct kcov_remote_arg, num_handles))))
+			return -EFAULT;
+		if (remote_num_handles > KCOV_REMOTE_MAX_HANDLES)
+			return -EINVAL;
+		remote_arg_size = struct_size(remote_arg, handles,
+					remote_num_handles);
+		remote_arg = memdup_user((void __user *)arg, remote_arg_size);
+		if (IS_ERR(remote_arg))
+			return PTR_ERR(remote_arg);
+		if (remote_arg->num_handles != remote_num_handles) {
+			kfree(remote_arg);
+			return -EINVAL;
+		}
+		arg = (unsigned long)remote_arg;
+	}
 
 	kcov = filep->private_data;
 	spin_lock(&kcov->lock);
 	res = kcov_ioctl_locked(kcov, cmd, arg);
 	spin_unlock(&kcov->lock);
+
+	kfree(remote_arg);
+
 	return res;
 }
 
@@ -438,6 +714,207 @@ static const struct file_operations kcov_fops = {
 	.release        = kcov_close,
 };
 
+/*
+ * kcov_remote_start() and kcov_remote_stop() can be used to annotate a section
+ * of code in a kernel background thread to allow kcov to be used to collect
+ * coverage from that part of code.
+ *
+ * The handle argument of kcov_remote_start() identifies a code section that is
+ * used for coverage collection. A userspace process passes this handle to
+ * KCOV_REMOTE_ENABLE ioctl to make the used kcov device start collecting
+ * coverage for the code section identified by this handle.
+ *
+ * The usage of these annotations in the kernel code is different depending on
+ * the type of the kernel thread whose code is being annotated.
+ *
+ * For global kernel threads that are spawned in a limited number of instances
+ * (e.g. one USB hub_event() worker thread is spawned per USB HCD), each
+ * instance must be assigned a unique 4-byte instance id. The instance id is
+ * then combined with a 1-byte subsystem id to get a handle via
+ * kcov_remote_handle(subsystem_id, instance_id).
+ *
+ * For local kernel threads that are spawned from system calls handler when a
+ * user interacts with some kernel interface (e.g. vhost workers), a handle is
+ * passed from a userspace process as the common_handle field of the
+ * kcov_remote_arg struct (note, that the user must generate a handle by using
+ * kcov_remote_handle() with KCOV_SUBSYSTEM_COMMON as the subsystem id and an
+ * arbitrary 4-byte non-zero number as the instance id). This common handle
+ * then gets saved into the task_struct of the process that issued the
+ * KCOV_REMOTE_ENABLE ioctl. When this proccess issues system calls that spawn
+ * kernel threads, the common handle must be retrived via kcov_common_handle()
+ * and passed to the spawned threads via custom annotations. Those kernel
+ * threads must in turn be annotated with kcov_remote_start(common_handle) and
+ * kcov_remote_stop(). All of the threads that are spawned by the same process
+ * obtain the same handle, hence the name "common".
+ *
+ * See Documentation/dev-tools/kcov.rst for more details.
+ *
+ * Internally, this function looks up the kcov device associated with the
+ * provided handle, allocates an area for coverage collection, and saves the
+ * pointers to kcov and area into the current task_struct to allow coverage to
+ * be collected via __sanitizer_cov_trace_pc()
+ * In turns kcov_remote_stop() clears those pointers from task_struct to stop
+ * collecting coverage and copies all collected coverage into the kcov area.
+ */
+void kcov_remote_start(u64 handle)
+{
+	struct kcov_remote *remote;
+	void *area;
+	struct task_struct *t;
+	unsigned int size;
+	enum kcov_mode mode;
+	int sequence;
+
+	if (WARN_ON(!kcov_check_handle(handle, true, true, true)))
+		return;
+	if (WARN_ON(!in_task()))
+		return;
+	t = current;
+	/*
+	 * Check that kcov_remote_start is not called twice
+	 * nor called by user tasks (with enabled kcov).
+	 */
+	if (WARN_ON(t->kcov))
+		return;
+
+	kcov_debug("handle = %llx\n", handle);
+
+	spin_lock(&kcov_remote_lock);
+	remote = kcov_remote_find(handle);
+	if (!remote) {
+		kcov_debug("no remote found");
+		spin_unlock(&kcov_remote_lock);
+		return;
+	}
+	/* Put in kcov_remote_stop(). */
+	kcov_get(remote->kcov);
+	t->kcov = remote->kcov;
+	/*
+	 * Read kcov fields before unlock to prevent races with
+	 * KCOV_DISABLE / kcov_remote_reset().
+	 */
+	size = remote->kcov->remote_size;
+	mode = remote->kcov->mode;
+	sequence = remote->kcov->sequence;
+	area = kcov_remote_area_get(size);
+	spin_unlock(&kcov_remote_lock);
+
+	if (!area) {
+		area = vmalloc(size * sizeof(unsigned long));
+		if (!area) {
+			t->kcov = NULL;
+			kcov_put(remote->kcov);
+			return;
+		}
+	}
+	/* Reset coverage size. */
+	*(u64 *)area = 0;
+
+	kcov_debug("area = %px, size = %u", area, size);
+
+	kcov_start(t, size, area, mode, sequence);
+
+}
+EXPORT_SYMBOL(kcov_remote_start);
+
+static void kcov_move_area(enum kcov_mode mode, void *dst_area,
+				unsigned int dst_area_size, void *src_area)
+{
+	u64 word_size = sizeof(unsigned long);
+	u64 count_size, entry_size_log;
+	u64 dst_len, src_len;
+	void *dst_entries, *src_entries;
+	u64 dst_occupied, dst_free, bytes_to_move, entries_moved;
+
+	kcov_debug("%px %u <= %px %lu\n",
+		dst_area, dst_area_size, src_area, *(unsigned long *)src_area);
+
+	switch (mode) {
+	case KCOV_MODE_TRACE_PC:
+		dst_len = READ_ONCE(*(unsigned long *)dst_area);
+		src_len = *(unsigned long *)src_area;
+		count_size = sizeof(unsigned long);
+		entry_size_log = __ilog2_u64(sizeof(unsigned long));
+		break;
+	case KCOV_MODE_TRACE_CMP:
+		dst_len = READ_ONCE(*(u64 *)dst_area);
+		src_len = *(u64 *)src_area;
+		count_size = sizeof(u64);
+		BUILD_BUG_ON(!is_power_of_2(KCOV_WORDS_PER_CMP));
+		entry_size_log = __ilog2_u64(sizeof(u64) * KCOV_WORDS_PER_CMP);
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	/* As arm can't divide u64 integers use log of entry size. */
+	if (dst_len > ((dst_area_size * word_size - count_size) >>
+				entry_size_log))
+		return;
+	dst_occupied = count_size + (dst_len << entry_size_log);
+	dst_free = dst_area_size * word_size - dst_occupied;
+	bytes_to_move = min(dst_free, src_len << entry_size_log);
+	dst_entries = dst_area + dst_occupied;
+	src_entries = src_area + count_size;
+	memcpy(dst_entries, src_entries, bytes_to_move);
+	entries_moved = bytes_to_move >> entry_size_log;
+
+	switch (mode) {
+	case KCOV_MODE_TRACE_PC:
+		WRITE_ONCE(*(unsigned long *)dst_area, dst_len + entries_moved);
+		break;
+	case KCOV_MODE_TRACE_CMP:
+		WRITE_ONCE(*(u64 *)dst_area, dst_len + entries_moved);
+		break;
+	default:
+		break;
+	}
+}
+
+/* See the comment before kcov_remote_start() for usage details. */
+void kcov_remote_stop(void)
+{
+	struct task_struct *t = current;
+	struct kcov *kcov = t->kcov;
+	void *area = t->kcov_area;
+	unsigned int size = t->kcov_size;
+	int sequence = t->kcov_sequence;
+
+	if (!kcov) {
+		kcov_debug("no kcov found\n");
+		return;
+	}
+
+	kcov_stop(t);
+	t->kcov = NULL;
+
+	spin_lock(&kcov->lock);
+	/*
+	 * KCOV_DISABLE could have been called between kcov_remote_start()
+	 * and kcov_remote_stop(), hence the check.
+	 */
+	kcov_debug("move if: %d == %d && %d\n",
+		sequence, kcov->sequence, (int)kcov->remote);
+	if (sequence == kcov->sequence && kcov->remote)
+		kcov_move_area(kcov->mode, kcov->area, kcov->size, area);
+	spin_unlock(&kcov->lock);
+
+	spin_lock(&kcov_remote_lock);
+	kcov_remote_area_put(area, size);
+	spin_unlock(&kcov_remote_lock);
+
+	kcov_put(kcov);
+}
+EXPORT_SYMBOL(kcov_remote_stop);
+
+/* See the comment before kcov_remote_start() for usage details. */
+u64 kcov_common_handle(void)
+{
+	return current->kcov_handle;
+}
+EXPORT_SYMBOL(kcov_common_handle);
+
 static int __init kcov_init(void)
 {
 	/*
-- 
2.24.0.rc0.303.g954a862665-goog

