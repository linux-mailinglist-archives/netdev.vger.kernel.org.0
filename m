Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A14493C68
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355479AbiASO6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355402AbiASO6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:58:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779CBC06175A;
        Wed, 19 Jan 2022 06:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140DD61480;
        Wed, 19 Jan 2022 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA47C004E1;
        Wed, 19 Jan 2022 14:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642604286;
        bh=AGdswND/skwO7CuRhjnhUztIarwXZ50Sy0S/WnqRJXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/xGqStVrRjwbChx7k7KjoMlZ5585T4m3hETH31hebk6CMwbmTilYZPWcMTazweVz
         uFJMiR6cD5+TorSOIjn57YiIu4uaxefKelGGgSGX0jOzOOw4J1E/ejHue3GU5PCaZi
         IZ28fyZndiQoOuqLIQjuIx+3q7rYMdkmWtzAu7uR8QknQNvNNfhov+7g46zZRw9SRD
         n7vKE3nWUypic+YMF7fdL0xpn0O59vUKLXFc5rqwZK6jvZ+9QstvWE7iUoi1lrn1pP
         e9/njftMYUiVcOnf8M1HOxdoTdwOqFBRaGLvMyonn5WVXSjafbsPDl0ejMioWuvun4
         5VobgVkjE7cpA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH v3 8/9] [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample
Date:   Wed, 19 Jan 2022 23:58:01 +0900
Message-Id: <164260428108.657731.16447173618084051958.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164260419349.657731.13913104835063027148.stgit@devnote2>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not intended to be merged to upstream code (since this
expose some kernel internal functions just for an example.)

But this is good to show how the fprobe is time-efficient
for registering a probe on thousands of functions.

 # time insmod fprobe_example.ko symbol='btrfs_*'
[   36.130947] fprobe_init: 1028 symbols found
[   36.177901] fprobe_init: Planted fprobe at btrfs_*
real	0m 0.08s
user	0m 0.00s
sys	0m 0.07s

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/kallsyms.c               |    1 +
 kernel/trace/ftrace.c           |    1 +
 samples/fprobe/fprobe_example.c |   69 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3011bc33a5ba..d0c4073acbfd 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -246,6 +246,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
 #endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 39350aa38649..7ce604bc9529 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1580,6 +1580,7 @@ unsigned long ftrace_location(unsigned long ip)
 {
 	return ftrace_location_range(ip, ip);
 }
+EXPORT_SYMBOL_GPL(ftrace_location);
 
 /**
  * ftrace_text_reserved - return true if range contains an ftrace location
diff --git a/samples/fprobe/fprobe_example.c b/samples/fprobe/fprobe_example.c
index c28320537f98..df034e00661e 100644
--- a/samples/fprobe/fprobe_example.c
+++ b/samples/fprobe/fprobe_example.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
+#include <linux/glob.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/fprobe.h>
@@ -37,16 +38,51 @@ static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_r
 
 static char *symbuf;
 
+struct sym_search_param {
+	unsigned long *addrs;
+	const char *pat;
+	int cnt;
+};
+
+#define MAX_FPROBE_ENTS	(16 * 1024)
+
+static int wildcard_match(void *data, const char *symbol, struct module *mod,
+			  unsigned long addr)
+{
+	struct sym_search_param *param = (struct sym_search_param *)data;
+
+	if (glob_match(param->pat, symbol)) {
+		if (!ftrace_location(addr))
+			return 0;
+
+		if (param->addrs)
+			param->addrs[param->cnt] = addr;
+		param->cnt++;
+		if (param->cnt >= MAX_FPROBE_ENTS)
+			return -E2BIG;
+	}
+	return 0;
+}
+
 static int __init fprobe_init(void)
 {
-	const char **syms;
+	struct sym_search_param param = {.pat = symbol, .addrs = NULL, .cnt = 0};
+	unsigned long *addrs = NULL;
+	const char **syms = NULL;
 	char *p;
 	int ret, count, i;
+	bool wildcard = false;
 
 	sample_probe.entry_handler = sample_entry_handler;
 	sample_probe.exit_handler = sample_exit_handler;
 
-	if (strchr(symbol, ',')) {
+	if (strchr(symbol, '*')) {
+		kallsyms_on_each_symbol(wildcard_match, &param);
+		count = param.cnt;
+		if (!count)
+			return -ENOENT;
+		wildcard = true;
+	} else if (strchr(symbol, ',')) {
 		symbuf = kstrdup(symbol, GFP_KERNEL);
 		if (!symbuf)
 			return -ENOMEM;
@@ -58,19 +94,31 @@ static int __init fprobe_init(void)
 		count = 1;
 		symbuf = symbol;
 	}
-	pr_info("%d symbols found\n", count);
 
-	syms = kcalloc(count, sizeof(char *), GFP_KERNEL);
-	if (!syms) {
+	if (wildcard)
+		addrs = kcalloc(count, sizeof(unsigned long), GFP_KERNEL);
+	else
+		syms = kcalloc(count, sizeof(char *), GFP_KERNEL);
+	if (!syms && !addrs) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	p = symbuf;
-	for (i = 0; i < count; i++)
-		syms[i] = strsep(&p, ",");
+	if (wildcard) {
+		param.addrs = addrs;
+		param.cnt = 0;
+
+		kallsyms_on_each_symbol(wildcard_match, &param);
+		count = param.cnt;
+		sample_probe.addrs = addrs;
+	} else {
+		p = symbuf;
+		for (i = 0; i < count; i++)
+			syms[i] = strsep(&p, ",");
+		sample_probe.syms = syms;
+	}
+	pr_info("%d symbols found\n", count);
 
-	sample_probe.syms = syms;
 	sample_probe.nentry = count;
 
 	ret = register_fprobe(&sample_probe);
@@ -82,6 +130,8 @@ static int __init fprobe_init(void)
 	return 0;
 
 error:
+	kfree(addrs);
+	kfree(syms);
 	if (symbuf != symbol)
 		kfree(symbuf);
 	return ret;
@@ -92,6 +142,7 @@ static void __exit fprobe_exit(void)
 	unregister_fprobe(&sample_probe);
 
 	kfree(sample_probe.syms);
+	kfree(sample_probe.addrs);
 	if (symbuf != symbol)
 		kfree(symbuf);
 

