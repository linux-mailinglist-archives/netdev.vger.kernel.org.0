Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4557D1D5BA0
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEOVa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:30:26 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34056 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgEOV2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:28:53 -0400
Received: by mail-pj1-f67.google.com with SMTP id l73so4405794pjb.1;
        Fri, 15 May 2020 14:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6DYtMtUC5VyzJjkaI1PbcryyaFQEBo8w9yp476+Y/8k=;
        b=KE8hQEUk9b7d3DxEQoFt2WpLPBQA115RLNE5o3cJ6QVUSCA8/eKsqouK2EJ4AJhWV7
         FGcfFLuYRx4Vv5Ux7mhtloN14BIMB4AX3fbQ5ajpRAwWDOejwAQpd0cHReTYFRY4HjqD
         SUf+gglEzlv1WoOliV5DhLSBDA6H3O8rmxr+EIS8JAnOrQAaHJwvAahJDZGGs+XJKPt8
         OJQw4lxhfbckcm4FA5ImMtPlLpDE+lTv2eM4/EEDG7sxSjlgukrZpiJhqpC79cAwUiYF
         rwCmQsUvRFx0oulJYNKPIW1FtxasLVX6nTiC0HqGyIyR5kY+MPFxlBUdmcyvCRn4NTHs
         KEpg==
X-Gm-Message-State: AOAM531OwB2wd29/5Azz+e5r5ybr83yaiY0rUYGANLts1gXdBhd+oefV
        LO23cvLKqXHrrpVGa6UXRcE=
X-Google-Smtp-Source: ABdhPJxXfmLp+gvIUNO8TU4BMrhu87/QAIPcxxYwYq0djFtBbeCPpZgFKZuASiN+4EgG4W9iOStsEg==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr1597671plp.286.1589578132568;
        Fri, 15 May 2020 14:28:52 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 14sm2700222pfy.38.2020.05.15.14.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:50 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 863A040E7B; Fri, 15 May 2020 21:28:49 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 01/15] taint: add module firmware crash taint support
Date:   Fri, 15 May 2020 21:28:32 +0000
Message-Id: <20200515212846.1347-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device driver firmware can crash, and sometimes, this can leave your
system in a state which makes the device or subsystem completely
useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
of scraping some magical words from the kernel log, which is driver
specific, is much easier. So instead provide a helper which lets drivers
annotate this.

Once this happens, scrapers can easily look for modules taint flags
for a firmware crash. This will taint both the kernel and respective
calling module.

The new helper module_firmware_crashed() uses LOCKDEP_STILL_OK as this
fact should in no way shape or form affect lockdep. This taint is device
driver specific.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 Documentation/admin-guide/tainted-kernels.rst |  6 ++++++
 include/linux/kernel.h                        |  3 ++-
 include/linux/module.h                        | 13 +++++++++++++
 include/trace/events/module.h                 |  3 ++-
 kernel/module.c                               |  5 +++--
 kernel/panic.c                                |  1 +
 tools/debugging/kernel-chktaint               |  7 +++++++
 7 files changed, 34 insertions(+), 4 deletions(-)

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
index 04a5885cec1b..19e1541c82c7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -601,7 +601,8 @@ extern enum system_states {
 #define TAINT_LIVEPATCH			15
 #define TAINT_AUX			16
 #define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
+#define TAINT_FIRMWARE_CRASH		18
+#define TAINT_FLAGS_COUNT		19
 
 struct taint_flag {
 	char c_true;	/* character printed when tainted */
diff --git a/include/linux/module.h b/include/linux/module.h
index 2c2e988bcf10..221200078180 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -697,6 +697,14 @@ static inline bool is_livepatch_module(struct module *mod)
 bool is_module_sig_enforced(void);
 void set_module_sig_enforced(void);
 
+void add_taint_module(struct module *mod, unsigned flag,
+		      enum lockdep_ok lockdep_ok);
+
+static inline void module_firmware_crashed(void)
+{
+	add_taint_module(THIS_MODULE, TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
+}
+
 #else /* !CONFIG_MODULES... */
 
 static inline struct module *__module_address(unsigned long addr)
@@ -844,6 +852,11 @@ void *dereference_module_function_descriptor(struct module *mod, void *ptr)
 	return ptr;
 }
 
+static inline void module_firmware_crashed(void)
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
 
diff --git a/kernel/module.c b/kernel/module.c
index 80faaf2116dd..f98e8c25c6b4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -325,12 +325,13 @@ static inline int strong_try_module_get(struct module *mod)
 		return -ENOENT;
 }
 
-static inline void add_taint_module(struct module *mod, unsigned flag,
-				    enum lockdep_ok lockdep_ok)
+void add_taint_module(struct module *mod, unsigned flag,
+		      enum lockdep_ok lockdep_ok)
 {
 	add_taint(flag, lockdep_ok);
 	set_bit(flag, &mod->taints);
 }
+EXPORT_SYMBOL_GPL(add_taint_module);
 
 /*
  * A thread that wants to hold a reference to a module only while it
diff --git a/kernel/panic.c b/kernel/panic.c
index ec6d7d788ce7..504fb926947e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -384,6 +384,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
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

