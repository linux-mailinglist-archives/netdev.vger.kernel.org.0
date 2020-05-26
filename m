Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D450F1E24B6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgEZO61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:58:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44321 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbgEZO6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:58:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh7so1872637plb.11;
        Tue, 26 May 2020 07:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7++pOXk6IJDsuFeObZU4Im4lkvw0LhpJw7+dPj+k3k8=;
        b=TT/vdWtCoPbp1LFQwFZLf1olQQW7pJG4uYK4dYXiomV9OAnWErbtcx3AsHnRuq0YiW
         nfbNWt9EBOTmvFz3TVl7jaqPpruSKIaO6Iv4Cm5X0eK1llN72TGY+UCA2WJSTHq/Yy1C
         mUpYR1xJpClQzstw7OhI0apORAwx3mJyXmxhXV7E+mEWICAbndA4o9bTyOTx/gyWSju3
         56RNBiPSaBEIQA4WWPOa4KTRIYb/1qNgnYcAxlK67RT1OtwUYPLjtUhrN7B0ynO1+Qrt
         KS2mWqjpOcr7wJSq7j9YAwAWozzOnEjEqfWMQ95uLFkwcJuOWYSNT1GK7oZq6jLuoKn4
         v/YA==
X-Gm-Message-State: AOAM533VChB2HqwFhtKU4pZam95myQ7txULPpW1L6IAds3ol2sLDO+gj
        Mv+jmHejgpMzTUVHFImwLF/0UaK1WB0gfw==
X-Google-Smtp-Source: ABdhPJxc0f9zyf1bsCUFFimsaSXbWx26kDs05cct6Ahl0GZLNsFeqf8irQoif4N5P1t5Hk1u5hJWYg==
X-Received: by 2002:a17:902:d218:: with SMTP id t24mr1450276ply.292.1590505102269;
        Tue, 26 May 2020 07:58:22 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i10sm30778pgq.36.2020.05.26.07.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:58:22 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id DF70F41C6A; Tue, 26 May 2020 14:58:17 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     michael.chan@broadcom.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, akpm@linux-foundation.org,
        arnd@arndb.de, rostedt@goodmis.org, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, derosier@gmail.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 2/8] panic: add uevent support
Date:   Tue, 26 May 2020 14:58:09 +0000
Message-Id: <20200526145815.6415-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to let panic events such as taints trigger uevents.
If you don't have a journalctl -k -f window going and you're not
actively monitoring what is going on in the kernel you may not
realize that your kernel is hosed. Only those clueful that
something may be off might inspect the kernel logs. Since
not everyone is, add support to throw some bones to userspace
that something might be fishy.

Let userspace figure out how to inform users, and what to do.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 MAINTAINERS                       |   8 +
 include/linux/panic_events.h      |  26 +++
 include/uapi/linux/panic_events.h |  17 ++
 init/main.c                       |   1 +
 kernel/Makefile                   |   1 +
 kernel/module.c                   |   2 +
 kernel/panic.c                    |   7 +-
 kernel/panic_events.c             | 289 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |  13 ++
 9 files changed, 363 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/panic_events.h
 create mode 100644 include/uapi/linux/panic_events.h
 create mode 100644 kernel/panic_events.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a003f310574..5bb467c0b36f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12876,6 +12876,14 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/panasonic-laptop.c
 
+PANIC EVENTS
+M:	Luis Chamberlain <mcgrof@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/panic_events.h
+F:	include/uapi/linux/panic_events.h
+F:	kernel/panic_events.c
+
 PARALLAX PING IIO SENSOR DRIVER
 M:	Andreas Klinger <ak@it-klinger.de>
 L:	linux-iio@vger.kernel.org
diff --git a/include/linux/panic_events.h b/include/linux/panic_events.h
new file mode 100644
index 000000000000..8e7e331ecaaf
--- /dev/null
+++ b/include/linux/panic_events.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _LINUX_PANIC_EVENTS_H
+
+#include <linux/module.h>
+#include <uapi/linux/panic_events.h>
+
+#ifdef CONFIG_PANIC_EVENTS
+
+void panic_uevent(enum panic_uevent event);
+void panic_uevent_taint(unsigned int flag, struct module *mod);
+
+#else
+static inline void panic_events_init(void)
+{
+}
+
+static inline panic_uevent(enum panic_uevent event)
+{
+}
+
+static inline void panic_uevent_taint(unsigned int flag, struct module *mod)
+{
+}
+#endif
+
+#endif /* _LINUX_PANIC_EVENTS_H */
diff --git a/include/uapi/linux/panic_events.h b/include/uapi/linux/panic_events.h
new file mode 100644
index 000000000000..4f409597be52
--- /dev/null
+++ b/include/uapi/linux/panic_events.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _UAPI_PANIC_EVENTS_H
+#define _UAPI_PANIC_EVENTS_H
+
+/**
+ * enum panic_uevent - panic uevents
+ *
+ * @PANIC_LOCKDEP_DISABLED: lockdep has been disabled
+ * @PANIC_TAINT: lockdep has been disabled
+ */
+enum panic_uevent {
+	PANIC_LOCKDEP_DISABLED,
+	PANIC_TAINT,
+	__PANIC_MAX, /* non-ABI */
+};
+
+#endif /* _UAPI_PANIC_EVENTS_H */
diff --git a/init/main.c b/init/main.c
index 0ead83e86b5a..2bf33b5ec7b4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -96,6 +96,7 @@
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
 #include <linux/kcsan.h>
+#include <linux/panic_events.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
diff --git a/kernel/Makefile b/kernel/Makefile
index 0bd4ed7ca157..0c1794818579 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -12,6 +12,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o
 
+obj-$(CONFIG_PANIC_EVENTS) += panic_events.o
 obj-$(CONFIG_MODULES) += kmod.o
 obj-$(CONFIG_MULTIUSER) += groups.o
 
diff --git a/kernel/module.c b/kernel/module.c
index 128bfc3e7ada..9b85d58441a2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -56,6 +56,7 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/panic_events.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -330,6 +331,7 @@ static inline void add_taint_module(struct module *mod, unsigned flag,
 {
 	add_taint(flag, lockdep_ok);
 	set_bit(flag, &mod->taints);
+	panic_uevent_taint(flag, mod);
 }
 
 /*
diff --git a/kernel/panic.c b/kernel/panic.c
index e2157ca387c8..48e9e2efa5bb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -30,6 +30,7 @@
 #include <linux/console.h>
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
+#include <linux/panic_events.h>
 #include <linux/debugfs.h>
 #include <asm/sections.h>
 
@@ -440,8 +441,10 @@ unsigned long get_taint(void)
  */
 void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
 {
-	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off())
+	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off()) {
 		pr_warn("Disabling lock debugging due to kernel taint\n");
+		panic_uevent(PANIC_LOCKDEP_DISABLED);
+	}
 
 	set_bit(flag, &tainted_mask);
 
@@ -449,6 +452,8 @@ void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
 		panic_on_taint = 0;
 		panic("panic_on_taint set ...");
 	}
+
+	panic_uevent_taint(flag, NULL);
 }
 EXPORT_SYMBOL(add_taint);
 
diff --git a/kernel/panic_events.c b/kernel/panic_events.c
new file mode 100644
index 000000000000..5a53a1b1fd9a
--- /dev/null
+++ b/kernel/panic_events.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/panic_events.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+/**
+ *  DOC: Panic events
+ *
+ *  Panic events are sent to userspace to inform userspace that something
+ *  critical has happened to the kernel. These events can happen in any
+ *  context, and so to send these events to userspace we preallocate memory
+ *  needed during initialization as needed for operation. The events are
+ *  queued and later dispatched. The uevents sent are best effort, if we are
+ *  short of memory kobject_uevent_env() can fail.
+ */
+
+/* The max amount of lines on a uevent we support */
+#define PANIC_UEVENT_MAX_LINES	8
+
+/* We assume each possible CPU can trigger these events */
+#define PANIC_MAX_EVENTS_PER_CPU 4
+
+/* The max number of concurrent uvents we support, otherwise we drop events */
+#define PANIC_NUM_CACHE_EVENTS (num_possible_cpus() * PANIC_MAX_EVENTS_PER_CPU)
+
+static LIST_HEAD(panic_free_list);
+static spinlock_t free_lock;
+
+static LIST_HEAD(panic_pend_list);
+static spinlock_t pend_lock;
+
+struct panic_event {
+	enum panic_uevent uevent;
+	char module_name[MODULE_NAME_LEN];
+	enum system_states sys_state;
+	unsigned int flag;
+	struct list_head list;
+};
+
+static struct panic_event *panic_events;
+
+static struct kset *panic_kset;
+static struct kobj_type empty_ktype;
+static struct kobject *panic_events_kobj;
+static struct kobject _panic_events_kobj;
+
+static void panic_process_events(struct work_struct *work);
+static DECLARE_WORK(panic_events_work, panic_process_events);
+
+static char (*panic_envp)[PATH_MAX];
+/* Protects panic_envp */
+static DEFINE_MUTEX(panic_mutex);
+
+struct panic_event *get_free_panic_event(void)
+{
+	struct panic_event *event = NULL;
+
+	spin_lock(&free_lock);
+	if (list_empty(&panic_free_list)) {
+		pr_warn_once("Not enough free panic pool events, we need to bump PANIC_NUM_CACHE_EVENTS, please report this\n");
+		goto out;
+	}
+	event = list_first_entry(&panic_free_list, struct panic_event, list);
+	list_del_init(&event->list);
+
+out:
+	spin_unlock(&free_lock);
+
+	return event;
+}
+
+static void queue_panic_event(struct panic_event *event)
+{
+	spin_lock(&pend_lock);
+	list_add_tail(&event->list, &panic_pend_list);
+	spin_unlock(&pend_lock);
+}
+
+struct panic_event *get_pend_panic_event(void)
+{
+	struct panic_event *event = NULL;
+
+	spin_lock(&pend_lock);
+	if (list_empty(&panic_pend_list))
+		goto out;
+
+	event = list_first_entry(&panic_pend_list, struct panic_event, list);
+	list_del_init(&event->list);
+
+out:
+	spin_unlock(&pend_lock);
+
+	return event;
+}
+
+static void panic_send_event(struct panic_event *event)
+{
+	unsigned int idx = 0, i;
+	bool pending = false;
+	char *envp[PANIC_UEVENT_MAX_LINES];
+	int r;
+
+	mutex_lock(&panic_mutex);
+	memset(panic_envp, 0, PATH_MAX * PANIC_UEVENT_MAX_LINES);
+	snprintf(panic_envp[idx++], PATH_MAX, "SYSTEM_STATE=%d",
+		 event->sys_state);
+	snprintf(panic_envp[idx++], PATH_MAX, "EVENT=%d", event->uevent);
+
+	if (event->uevent == PANIC_LOCKDEP_DISABLED)
+		goto out_send;
+
+	/*
+	 * add_taint_module() will trigger two uevents, one for the kernel,
+	 * and another for the module, if the module was not built-in.
+	 */
+	if (event->uevent == PANIC_TAINT) {
+		snprintf(panic_envp[idx++], PATH_MAX, "TAINT=%d", event->flag);
+		if (strcmp(event->module_name, "") != 0)
+			snprintf(panic_envp[idx++], PATH_MAX, "MODULE_NAME=%s",
+				 event->module_name);
+	}
+
+out_send:
+	for (i = 0; i < idx; i++)
+		envp[i] = panic_envp[i];
+	envp[idx] = NULL;
+
+	r = kobject_uevent_env(panic_events_kobj, KOBJ_CHANGE, envp);
+	if (!r)
+		pr_debug("failed to sent uevent: %d\n", event->uevent);
+	mutex_unlock(&panic_mutex);
+
+	memset(event, 0, sizeof(struct panic_event));
+
+	spin_lock(&free_lock);
+	list_add_tail(&event->list, &panic_free_list);
+	spin_unlock(&free_lock);
+
+	spin_lock(&pend_lock);
+	if (!list_empty(&panic_pend_list))
+		pending = true;
+	spin_unlock(&pend_lock);
+
+	if (pending)
+		schedule_work(&panic_events_work);
+}
+
+static void panic_process_events(struct work_struct *work)
+{
+	struct panic_event *event;
+	bool pending = false;
+
+	event = get_pend_panic_event();
+	if (!event)
+		goto out;
+
+	panic_send_event(event);
+
+out:
+	spin_lock(&pend_lock);
+	if (!list_empty(&panic_pend_list))
+		pending = true;
+	spin_unlock(&pend_lock);
+
+	if (pending)
+		schedule_work(&panic_events_work);
+}
+
+/* For simple panic uvents which only need an event type specified */
+void panic_uevent(enum panic_uevent uevent)
+{
+	struct panic_event *event;
+
+	if (!panic_events_kobj)
+		return;
+
+	event = get_free_panic_event();
+	if (!event)
+		return;
+
+	event->uevent = uevent;
+	event->sys_state = system_state;
+
+	queue_panic_event(event);
+	schedule_work(&panic_events_work);
+}
+
+void panic_uevent_taint(unsigned int flag, struct module *mod)
+{
+	struct panic_event *event;
+
+	if (!panic_events_kobj)
+		return;
+
+	event = get_free_panic_event();
+	if (!event)
+		return;
+
+	event->uevent = PANIC_TAINT;
+	event->sys_state = system_state;
+	event->flag = flag;
+
+	if (mod)
+		strncpy(event->module_name, module_name(mod), MODULE_NAME_LEN);
+
+	queue_panic_event(event);
+	schedule_work(&panic_events_work);
+}
+
+static __init void panic_events_init(void)
+{
+	struct panic_event *event;
+	char *envp[2];
+	unsigned int i;
+	size_t used;
+	int r;
+
+	spin_lock_init(&free_lock);
+	spin_lock_init(&pend_lock);
+
+	mutex_lock(&panic_mutex);
+
+	panic_envp = kzalloc(PATH_MAX * PANIC_UEVENT_MAX_LINES, GFP_KERNEL);
+	if (!panic_envp)
+		goto out_unlock;
+
+	panic_events = kzalloc(sizeof(struct panic_event) *
+			       PANIC_NUM_CACHE_EVENTS, GFP_KERNEL);
+	if (!panic_events)
+		goto out_env;
+
+	for (i = 0; i < PANIC_NUM_CACHE_EVENTS; i++) {
+		event = &panic_events[i];
+		list_add_tail(&event->list, &panic_free_list);
+	}
+
+	snprintf(panic_envp[0], PATH_MAX, "MAX_EVENT_SUPPORTED=%d",
+		 __PANIC_MAX-1);
+
+	envp[0] = panic_envp[0];
+	envp[1] = NULL;
+
+	panic_kset = kset_create_and_add("panic", NULL, kernel_kobj);
+	if (!panic_kset)
+		goto out_events;
+
+	_panic_events_kobj.kset = panic_kset;
+
+	r = kobject_init_and_add(&_panic_events_kobj, &empty_ktype,
+				 NULL, "events");
+	if (r) {
+		pr_warn("Could not add panic events kobject\n");
+		goto out_kset;
+	}
+
+	/* Without this set this infrastructure is ignored */
+	panic_events_kobj = &_panic_events_kobj;
+
+	/* Inform userspace which events we'll send uevents for */
+	r = kobject_uevent_env(panic_events_kobj, KOBJ_ADD, envp);
+	if (r != 0)
+		pr_debug("failed to send first event\n");
+
+	mutex_unlock(&panic_mutex);
+
+	used = (PATH_MAX * PANIC_UEVENT_MAX_LINES) +
+	       (sizeof(struct panic_event) * PANIC_NUM_CACHE_EVENTS);
+
+	pr_info("initialized using %zu preallocated bytes\n", used);
+
+	return;
+
+out_kset:
+	kset_unregister(panic_kset);
+out_events:
+	kfree(panic_events);
+out_env:
+	kfree(panic_envp);
+out_unlock:
+	mutex_unlock(&panic_mutex);
+}
+
+core_initcall(panic_events_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cf77b3881a21..966e8eaad09e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -835,6 +835,19 @@ config DEBUG_SHIRQ
 
 menu "Debug Oops, Lockups and Hangs"
 
+config PANIC_EVENTS
+	bool "Enable uevents relating to panics or taints"
+	help
+	  Say Y here to enable the kernel to send uevents relating to panics or
+	  when taint events happen. This may be useful if you want to craft some
+	  userspace component to analyze a taint, or inform the user of this
+	  event. These events are useful later in boot, prior to device driver
+	  initialization, so it won't capture events early in boot. The events
+	  are also best effort, if the system is low on memory some uevents
+	  not reach userspace.
+
+	  Say N if unsure.
+
 config PANIC_ON_OOPS
 	bool "Panic on Oops"
 	help
-- 
2.26.2

