Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46941CBD6D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIEgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:36:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33239 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIEgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id a4so1871853pgc.0;
        Fri, 08 May 2020 21:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cBDEUQMC+fxVo+rJgGTTJoIY6zpQy1pm40eE67u+Uqg=;
        b=PqTNg7ruGWk3ai1A4d7SqhsimzRkgpjhLulF3FMPBT2EsRC6e/t7UzmS2oPAVr+7A6
         jnMA6t7AgURJHyIiReVAnsv7kwzWZs2ItzPGU5FyZjaAMXTk32ucUhJJwSbaAqQ/+lhT
         YGS91gb1FNfTTZBZeC28JSyG0uQf1rTjhzv8i5RiJdeF2A/CczcWpexrySdLfIFs7BY+
         5NPkHHTkl4hmHWNt4/u6frJsBJAGLd20fJu/c7ONeUcD16YPeJCHSG2+BQZmOgiFuXbi
         9Y+/iNS/z1OfkgVAfvOmhr/Z0LlKxvfVl7Tjw71qDXQoMgjO6JABP5SKPovEi2dGuz8k
         /klw==
X-Gm-Message-State: AGi0PuYXf/J4IwfLwWkJJuqdd9hbY6KfP7y3BDdSvQdjbSbs6P7cZsRm
        eti+HyxjYKTQ/kzYSFYDd+c=
X-Google-Smtp-Source: APiQypJjvjDWOMPqgykaQj7RJnenYgarjSOjuLsWtrHeyobTh/wPyLwuHtwWcWuICsu5VeQKOL8DbA==
X-Received: by 2002:a62:75d1:: with SMTP id q200mr6142351pfc.238.1588998963744;
        Fri, 08 May 2020 21:36:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o99sm3682368pjo.8.2020.05.08.21.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B4C334063E; Sat,  9 May 2020 04:36:00 +0000 (UTC)
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
Subject: [PATCH 01/15] taint: add module firmware crash taint support
Date:   Sat,  9 May 2020 04:35:38 +0000
Message-Id: <20200509043552.8745-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
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
 include/linux/kernel.h        |  3 ++-
 include/linux/module.h        | 13 +++++++++++++
 include/trace/events/module.h |  3 ++-
 kernel/module.c               |  5 +++--
 kernel/panic.c                |  1 +
 5 files changed, 21 insertions(+), 4 deletions(-)

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
-- 
2.25.1

