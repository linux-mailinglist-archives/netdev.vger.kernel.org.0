Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C30512441
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiD0VHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiD0VHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:07:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012BE8878B;
        Wed, 27 Apr 2022 14:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8992B82AD8;
        Wed, 27 Apr 2022 21:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A74BC385AA;
        Wed, 27 Apr 2022 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651093462;
        bh=5FwLa1xFrkFZPWtTKRF4rYoUZEPf40so8YMj+Ov7/5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hq2F+2bBa8XOBoycOV7ws1Kz8fuIrlUnfVnPJ5XyTMPpvpZ3OV4gIh52KcEjkTJjq
         NKZTQJ4T4GuoiNIe7sfAWXjuKfcvNcjY/X2RjoXXNt/nCJYY2HlZbIwLT0q8sbAZKc
         vQbdkNB+f2SLPZ5uYMNLXwF0ATM0oUCYAYREFwWfkMD0XcCw563Hi2XBwlXnKx0rXs
         2HNOosDYu26baMD3BPnl0G1pQgQLEdyJ8e20G8ZKpvicexROTakFeRs+GpHnW3dMtK
         XkXNtsze1RU+jGPqaGFfx+YszePxZEHZXRlxS/SqmJQzZ+2mQLRR2CGqmWu+d8rjcC
         T1fSIOPtbv7aw==
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
Subject: [PATCHv3 bpf-next 3/5] fprobe: Resolve symbols with ftrace_lookup_symbols
Date:   Wed, 27 Apr 2022 23:03:43 +0200
Message-Id: <20220427210345.455611-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427210345.455611-1-jolsa@kernel.org>
References: <20220427210345.455611-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using ftrace_lookup_symbols to speed up symbols lookup
in register_fprobe_syms API.

This requires syms array to be alphabetically sorted.

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

