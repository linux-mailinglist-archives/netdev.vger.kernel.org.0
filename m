Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77CC213011
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGBX1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgGBX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:26:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52574C08C5DE
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:26:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f16so2770771pjt.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ln6rO86x9ZxOiyZZPuxFfPT8Nugldwg64LyJUHiqZT0=;
        b=YYtApD/6rs1BT/ZzA44IlQCH/zgH3loPHO4nrJjyar1pcWSs1f1U/7EWSBhEGCnNpn
         8b0/wokfQx35rbyVYIClE0w0NMPrndlLoC+wumiIdrB2Y4ekwvsxyhRYnCbn/1sCRXHP
         Gx5nfmAXpl7AHzdKNGugYuKJOZHn9lUV3gJ1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ln6rO86x9ZxOiyZZPuxFfPT8Nugldwg64LyJUHiqZT0=;
        b=qCpeU0rHiEQ3liRI5xJNDAOR1Ay4AsOy0JADjjav52d8n93/hyq2XRXjQA/6+P5+yS
         sTLTQFYGQl8XZD3t8p9chq+c1YBwboKcSDnh3rFp7OCNFYY5V7DTRFiFYS8UWj8VSacm
         ogoGDMmmGgh8RDR3ck+jiIaTvfGkpbdqdmZlMu9Ya/wNDHOHmxSKfOv04EH+jEK96At+
         Syfd1XhkiAWelfxudsLxFEQdfMUJVvMrs6N9eIQPdApkqszaFOHGLmLRHkjMDpF2Jw6q
         dN+TZm4t5AwEvcbkRXvHtRxJNkzJH8UeqOmZrAQhVUiNJ9oQts1cToW8S43sLHZrP4iw
         tMqg==
X-Gm-Message-State: AOAM5336TnF5+OIKL3PlWhuFVp/Fz2BPjNaXevYfS0dd9HhgCLAJ8Npb
        pMhO4q+4BF5qgYf+5lVJWmML1A==
X-Google-Smtp-Source: ABdhPJwfJJ4gw99qjzyTNpCmCsOoWMzyap43GRDeaqgnGHrygOWaZADTDGp6Bqu/EDIf8o0sxOAFGw==
X-Received: by 2002:a17:902:704a:: with SMTP id h10mr27952959plt.85.1593732404766;
        Thu, 02 Jul 2020 16:26:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m140sm9987328pfd.195.2020.07.02.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] kallsyms: Refactor kallsyms_show_value() to take cred
Date:   Thu,  2 Jul 2020 16:26:34 -0700
Message-Id: <20200702232638.2946421-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702232638.2946421-1-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to perform future tests against the cred saved during open(),
switch kallsyms_show_value() to operate on a cred, and have all current
callers pass current_cred(). This makes it very obvious where callers
are checking the wrong credential in their "read" contexts. These will
be fixed in the coming patches.

Additionally switch return value to bool, since it is always used as a
direct permission check, not a 0-on-success, negative-on-error style
function return.

Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/filter.h   |  2 +-
 include/linux/kallsyms.h |  5 +++--
 kernel/kallsyms.c        | 17 +++++++++++------
 kernel/kprobes.c         |  4 ++--
 kernel/module.c          |  2 +-
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..55104f6c78e8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -889,7 +889,7 @@ static inline bool bpf_dump_raw_ok(void)
 	/* Reconstruction of call-sites is dependent on kallsyms,
 	 * thus make dump the same restriction.
 	 */
-	return kallsyms_show_value() == 1;
+	return kallsyms_show_value(current_cred());
 }
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 98338dc6b5d2..481273f0c72d 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -18,6 +18,7 @@
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
+struct cred;
 struct module;
 
 static inline int is_kernel_inittext(unsigned long addr)
@@ -98,7 +99,7 @@ int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
 /* How and when do we show kallsyms values? */
-extern int kallsyms_show_value(void);
+extern bool kallsyms_show_value(const struct cred *cred);
 
 #else /* !CONFIG_KALLSYMS */
 
@@ -158,7 +159,7 @@ static inline int lookup_symbol_attrs(unsigned long addr, unsigned long *size, u
 	return -ERANGE;
 }
 
-static inline int kallsyms_show_value(void)
+static inline bool kallsyms_show_value(const struct cred *cred)
 {
 	return false;
 }
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 16c8c605f4b0..bb14e64f62a4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -644,19 +644,20 @@ static inline int kallsyms_for_perf(void)
  * Otherwise, require CAP_SYSLOG (assuming kptr_restrict isn't set to
  * block even that).
  */
-int kallsyms_show_value(void)
+bool kallsyms_show_value(const struct cred *cred)
 {
 	switch (kptr_restrict) {
 	case 0:
 		if (kallsyms_for_perf())
-			return 1;
+			return true;
 	/* fallthrough */
 	case 1:
-		if (has_capability_noaudit(current, CAP_SYSLOG))
-			return 1;
+		if (security_capable(cred, &init_user_ns, CAP_SYSLOG,
+				     CAP_OPT_NOAUDIT) == 0)
+			return true;
 	/* fallthrough */
 	default:
-		return 0;
+		return false;
 	}
 }
 
@@ -673,7 +674,11 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	reset_iter(iter, 0);
 
-	iter->show_value = kallsyms_show_value();
+	/*
+	 * Instead of checking this on every s_show() call, cache
+	 * the result here at open time.
+	 */
+	iter->show_value = kallsyms_show_value(file->f_cred);
 	return 0;
 }
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 4a904cc56d68..d4de217e4a91 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2448,7 +2448,7 @@ static void report_probe(struct seq_file *pi, struct kprobe *p,
 	else
 		kprobe_type = "k";
 
-	if (!kallsyms_show_value())
+	if (!kallsyms_show_value(current_cred()))
 		addr = NULL;
 
 	if (sym)
@@ -2540,7 +2540,7 @@ static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 	 * If /proc/kallsyms is not showing kernel address, we won't
 	 * show them here either.
 	 */
-	if (!kallsyms_show_value())
+	if (!kallsyms_show_value(current_cred()))
 		seq_printf(m, "0x%px-0x%px\t%ps\n", NULL, NULL,
 			   (void *)ent->start_addr);
 	else
diff --git a/kernel/module.c b/kernel/module.c
index e8a198588f26..a5022ae84e50 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4377,7 +4377,7 @@ static int modules_open(struct inode *inode, struct file *file)
 
 	if (!err) {
 		struct seq_file *m = file->private_data;
-		m->private = kallsyms_show_value() ? NULL : (void *)8ul;
+		m->private = kallsyms_show_value(current_cred()) ? NULL : (void *)8ul;
 	}
 
 	return err;
-- 
2.25.1

