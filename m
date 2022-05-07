Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC39E51E73B
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 14:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446507AbiEGNBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446446AbiEGNBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EF14B413;
        Sat,  7 May 2022 05:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98B760920;
        Sat,  7 May 2022 12:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F8CC385A5;
        Sat,  7 May 2022 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651928267;
        bh=aDprmzPJjly6FaPGeFMauML0ykC9vs5hDKffxwEHhY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUJ1i8zTKEVK+Zm2kIJtPAY3caDa0SCgUl+w2VUZqw3DExZfTeGGL3o3i6XMrOrhI
         mLq6zomeG5Bd+a+NhCHuo6ak1UlwrM4RLwHbPwqtIEoFBiySK6FVQA3KCLI+HBgjIM
         1brA/lZkkOy97GqQ8V1sjwN978sJXI9nGQHg6GzXiAzJxhNt+AvMdwcS62ANvmco1W
         wSiaSdBbhw6i0C128B8EJxcKpxl55hd4orrG4CeJ4j0/a/7xpoWQfYCey4cIobvfCs
         OIXSscmjjJ6oyOCbAkAsGUSE1JLsKUhFlO9ORJLVRcEHjONnoEM7h+m99bwpDus5jl
         unenFb+y1ctCQ==
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv5 bpf-next 3/5] fprobe: Resolve symbols with ftrace_lookup_symbols
Date:   Sat,  7 May 2022 14:57:09 +0200
Message-Id: <20220507125711.2022238-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507125711.2022238-1-jolsa@kernel.org>
References: <20220507125711.2022238-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using ftrace_lookup_symbols to speed up symbols lookup
in register_fprobe_syms API.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/fprobe.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 89d9f994ebb0..aac63ca9c3d1 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -85,39 +85,31 @@ static void fprobe_exit_handler(struct rethook_node *rh, void *data,
 }
 NOKPROBE_SYMBOL(fprobe_exit_handler);
 
+static int symbols_cmp(const void *a, const void *b)
+{
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
+
+	return strcmp(*str_a, *str_b);
+}
+
 /* Convert ftrace location address from symbols */
 static unsigned long *get_ftrace_locations(const char **syms, int num)
 {
-	unsigned long addr, size;
 	unsigned long *addrs;
-	int i;
 
 	/* Convert symbols to symbol address */
 	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs)
 		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; i < num; i++) {
-		addr = kallsyms_lookup_name(syms[i]);
-		if (!addr)	/* Maybe wrong symbol */
-			goto error;
-
-		/* Convert symbol address to ftrace location. */
-		if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
-			goto error;
+	/* ftrace_lookup_symbols expects sorted symbols */
+	sort(syms, num, sizeof(*syms), symbols_cmp, NULL);
 
-		addr = ftrace_location_range(addr, addr + size - 1);
-		if (!addr) /* No dynamic ftrace there. */
-			goto error;
+	if (!ftrace_lookup_symbols(syms, num, addrs))
+		return addrs;
 
-		addrs[i] = addr;
-	}
-
-	return addrs;
-
-error:
 	kfree(addrs);
-
 	return ERR_PTR(-ENOENT);
 }
 
-- 
2.35.1

