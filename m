Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F4B1E24BB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgEZO63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:58:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46592 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbgEZO60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:58:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id 131so1906858pfv.13;
        Tue, 26 May 2020 07:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EvSxJvzu8CuJNVtnMN+6EPtAduMBjuHw07i/r14VRgA=;
        b=Is2tpGym8gzbx0crDhBSjU2sp3DGafM9CeR1DqYxWmWhneuziQa0UR9PVE2aBQMKL0
         md14tfuZT+jDe5VMt6OoH09VltZ5GqMgjvZ4A6NJNg3UYR4I1O6JbpE2dwLm7ZoiqlrT
         e4YzWuTItW82cjZgDQh0NeGLOk4oRRThf0g4YW/KkoGkTqW/iGTnND0bx4mpokAHx0Me
         XOwiMZosPpfnuV4NB+UKkHdQxw28WcNSvGHSjQBqTalzYs0slE4naa/XJ8WVbEaqPvsM
         QyBwmKnJpDAzkDla1RMEI0b97VGHUOhfP2Xu5O6JKVRZTGLyVdAd/8D0F4G7jxncqKPQ
         Vqxg==
X-Gm-Message-State: AOAM533Pbykkqz1uTEfgnIcDYv71oiswuVW3PEYazRp7lv79TxO4/459
        oQzrqhS2QHLwkRs0wtDVqHnvzwnTJEZiGg==
X-Google-Smtp-Source: ABdhPJxnO0fX0HJIoxald0Wt4I5kJb9sYmEvLY5dFdfg1I0//8tMTs+SRIAt5tW4ZCLckmZj7qQyMg==
X-Received: by 2002:a63:f442:: with SMTP id p2mr1439345pgk.234.1590505104559;
        Tue, 26 May 2020 07:58:24 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id m18sm77891pjl.14.2020.05.26.07.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:58:22 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 2FDE941D00; Tue, 26 May 2020 14:58:18 +0000 (UTC)
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
Subject: [PATCH v3 3/8] taint: add firmware crash taint support
Date:   Tue, 26 May 2020 14:58:10 +0000
Message-Id: <20200526145815.6415-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device drivers firmware can crash, and *sometimes*, this can leave your
system in a state which makes the device or subsystem completely useless.
In the worst of cases not even removing the module and adding it back again
will correct your situation and you are left with no other option but to do
a full system reboot. Some drivers have work arounds for these situations,
and sometimes they can recover the device / functionality but not all
device drivers have these arrangements and in the worst cases requiring
a full reboot is completely hidden from the user experience, leaving them
dumbfounded with what has happened.

Detecting this by inspecting /proc/sys/kernel/tainted instead of scraping
some magical words from the kernel log, which is driver specific, is much
easier. So instead provide a helper which lets drivers annotate this.

Once this happens, scrapers can easily look for modules taint flags for a
firmware crash. This will taint both the kernel and respective calling
module.

The new helper taint_firmware_crashed() uses LOCKDEP_STILL_OK as this fact
should in no way shape or form affect lockdep. This taint is device driver
specific.

While extending the declaration of add_taint_module(), just make the flag
unsigned int clear.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 Documentation/admin-guide/tainted-kernels.rst |  6 ++++++
 include/linux/kernel.h                        |  2 +-
 include/linux/module.h                        | 13 +++++++++++++
 include/trace/events/module.h                 |  3 ++-
 include/uapi/linux/kernel.h                   |  1 +
 kernel/module.c                               | 13 +++++++++----
 kernel/panic.c                                |  1 +
 tools/debugging/kernel-chktaint               |  7 +++++++
 8 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/tainted-kernels.rst b/Documentation/admin-guide/tainted-kernels.rst
index 71e9184a9079..92530f1d60ae 100644
--- a/Documentation/admin-guide/tainted-kernels.rst
+++ b/Documentation/admin-guide/tainted-kernels.rst
@@ -100,6 +100,7 @@ Bit  Log  Number  Reason that got the kernel tainted
  15  _/K   32768  kernel has been live patched
  16  _/X   65536  auxiliary taint, defined for and used by distros
  17  _/T  131072  kernel was built with the struct randomization plugin
+ 18  _/Q  262144  driver firmware crash annotation
 ===  ===  ======  ========================================================
 
 Note: The character ``_`` is representing a blank in this table to make reading
@@ -162,3 +163,8 @@ More detailed explanation for tainting
      produce extremely unusual kernel structure layouts (even performance
      pathological ones), which is important to know when debugging. Set at
      build time.
+
+ 18) ``Q`` used by device drivers to annotate that the device driver's firmware
+     has crashed and the device's operation has been severely affected. The
+     device may be left in a crippled state, requiring full driver removal /
+     addition, system reboot, or it is unclear how long recovery will take.
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 337634363d00..a1974907c320 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -571,7 +571,7 @@ extern int root_mountflags;
 extern bool early_boot_irqs_disabled;
 extern enum system_states  system_state;
 
-#define TAINT_FLAGS_COUNT		18
+#define TAINT_FLAGS_COUNT		19
 #define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
 
 struct taint_flag {
diff --git a/include/linux/module.h b/include/linux/module.h
index 2e6670860d27..b3e143d2993e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -705,6 +705,14 @@ static inline bool is_livepatch_module(struct module *mod)
 bool is_module_sig_enforced(void);
 void set_module_sig_enforced(void);
 
+void add_taint_module(struct module *mod, unsigned int flag,
+		      enum lockdep_ok lockdep_ok);
+
+static inline void taint_firmware_crashed(void)
+{
+	add_taint_module(THIS_MODULE, TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
+}
+
 #else /* !CONFIG_MODULES... */
 
 static inline struct module *__module_address(unsigned long addr)
@@ -852,6 +860,11 @@ void *dereference_module_function_descriptor(struct module *mod, void *ptr)
 	return ptr;
 }
 
+static inline void taint_firmware_crashed(void)
+{
+	add_taint(TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
+}
+
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 097485c73c01..b749ea25affd 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -26,7 +26,8 @@ struct module;
 	{ (1UL << TAINT_OOT_MODULE),		"O" },		\
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
 	{ (1UL << TAINT_CRAP),			"C" },		\
-	{ (1UL << TAINT_UNSIGNED_MODULE),	"E" })
+	{ (1UL << TAINT_UNSIGNED_MODULE),	"E" },		\
+	{ (1UL << TAINT_FIRMWARE_CRASH),	"Q" })
 
 TRACE_EVENT(module_load,
 
diff --git a/include/uapi/linux/kernel.h b/include/uapi/linux/kernel.h
index 4bbd4093eb64..1e364659afca 100644
--- a/include/uapi/linux/kernel.h
+++ b/include/uapi/linux/kernel.h
@@ -45,6 +45,7 @@ enum system_states {
 #define TAINT_LIVEPATCH			15
 #define TAINT_AUX			16
 #define TAINT_RANDSTRUCT		17
+#define TAINT_FIRMWARE_CRASH		18
 /* be sure to update TAINT_FLAGS_COUNT when extending this */
 
 #endif /* _UAPI_LINUX_KERNEL_H */
diff --git a/kernel/module.c b/kernel/module.c
index 9b85d58441a2..538def226332 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -326,13 +326,18 @@ static inline int strong_try_module_get(struct module *mod)
 		return -ENOENT;
 }
 
-static inline void add_taint_module(struct module *mod, unsigned flag,
-				    enum lockdep_ok lockdep_ok)
+void add_taint_module(struct module *mod, unsigned int flag,
+		      enum lockdep_ok lockdep_ok)
 {
 	add_taint(flag, lockdep_ok);
-	set_bit(flag, &mod->taints);
-	panic_uevent_taint(flag, mod);
+
+	/* Skip this if the module is built-in */
+	if (mod) {
+		set_bit(flag, &mod->taints);
+		panic_uevent_taint(flag, mod);
+	}
 }
+EXPORT_SYMBOL_GPL(add_taint_module);
 
 /*
  * A thread that wants to hold a reference to a module only while it
diff --git a/kernel/panic.c b/kernel/panic.c
index 48e9e2efa5bb..cb1c5619e983 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -387,6 +387,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
 	[ TAINT_AUX ]			= { 'X', ' ', true },
 	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
+	[ TAINT_FIRMWARE_CRASH ]	= { 'Q', ' ', true },
 };
 
 /**
diff --git a/tools/debugging/kernel-chktaint b/tools/debugging/kernel-chktaint
index 2240cb56e6e5..c397c6aabea7 100755
--- a/tools/debugging/kernel-chktaint
+++ b/tools/debugging/kernel-chktaint
@@ -194,6 +194,13 @@ else
 	addout "T"
 	echo " * kernel was built with the struct randomization plugin (#17)"
 fi
+T=`expr $T / 2`
+if [ `expr $T % 2` -eq 0 ]; then
+	addout " "
+else
+	addout "Q"
+	echo " * a device driver's firmware has crashed (#18)"
+fi
 
 echo "For a more detailed explanation of the various taint flags see"
 echo " Documentation/admin-guide/tainted-kernels.rst in the the Linux kernel sources"
-- 
2.26.2

