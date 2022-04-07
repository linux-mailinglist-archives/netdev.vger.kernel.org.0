Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF444F7F86
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbiDGMy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245497AbiDGMyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:54:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF910259B78;
        Thu,  7 Apr 2022 05:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DC12B8276E;
        Thu,  7 Apr 2022 12:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31EAC385A7;
        Thu,  7 Apr 2022 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649335971;
        bh=yEgxalyouDOhCPVfvRQ3DDbeM5FBr/AeYPdte+FiyQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7uBFAD9XglW/HNYFw6X+3fEDChWBUurYqWLUh7RBoh21sHzbuHaVGc38F4uUVQcD
         7SkK/Q8Ql7pE7Hvw3Vm2FOh9BltPh+ddqvzbM43Za3ZzDSgSZxgrmy8cNMXkqw2cQ8
         cr038MpkV9dRZrGnToFvKeMu2PdHJin9UpltKIoAm1ptKVDTZhWBz9x86tQzuDCg4s
         iqcw0YYbtBPqpCOnDbvkBQTujHqVh2+iqSEJPEfQuqkw0xK+hr3zH2zaWIorAxknRC
         lhz0u8shbFQNLr7LwDzSYWF75Ub4AvicwkmoE5ADX5FMK76FPxAjYJSHdVN2XMVGLx
         MLW5f6v5g9+qg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Date:   Thu,  7 Apr 2022 14:52:21 +0200
Message-Id: <20220407125224.310255-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407125224.310255-1-jolsa@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding kallsyms_lookup_names function that resolves array of symbols
with single pass over kallsyms.

The user provides array of string pointers with count and pointer to
allocated array for resolved values.

  int kallsyms_lookup_names(const char **syms, u32 cnt,
                            unsigned long *addrs)

Before we iterate kallsyms we sort user provided symbols by name and
then use that in kalsyms iteration to find each kallsyms symbol in
user provided symbols.

We also check each symbol to pass ftrace_location, because this API
will be used for fprobe symbols resolving. This can be optional in
future if there's a need.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kallsyms.h |  6 +++++
 kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..5320a5e77f61 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
+{
+	return -ERANGE;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 79f2eb617a62..a3738ddf9e87 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -29,6 +29,8 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 
 /*
  * These will be re-linked against their real values
@@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
 	return __sprint_symbol(buffer, address, -1, 1, 1);
 }
 
+static int symbols_cmp(const void *a, const void *b)
+{
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
+
+	return strcmp(*str_a, *str_b);
+}
+
+struct kallsyms_data {
+	unsigned long *addrs;
+	const char **syms;
+	u32 cnt;
+	u32 found;
+};
+
+static int kallsyms_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
+{
+	struct kallsyms_data *args = data;
+
+	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
+		return 0;
+
+	addr = ftrace_location(addr);
+	if (!addr)
+		return 0;
+
+	args->addrs[args->found++] = addr;
+	return args->found == args->cnt ? 1 : 0;
+}
+
+int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
+{
+	struct kallsyms_data args;
+
+	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
+
+	args.addrs = addrs;
+	args.syms = syms;
+	args.cnt = cnt;
+	args.found = 0;
+	kallsyms_on_each_symbol(kallsyms_callback, &args);
+
+	return args.found == args.cnt ? 0 : -EINVAL;
+}
+
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
 struct kallsym_iter {
 	loff_t pos;
-- 
2.35.1

