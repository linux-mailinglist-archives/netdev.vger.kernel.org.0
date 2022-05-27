Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B153684F
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354672AbiE0U4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354683AbiE0U4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 16:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A432E1157DE;
        Fri, 27 May 2022 13:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECDBD61ECC;
        Fri, 27 May 2022 20:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E11BC385A9;
        Fri, 27 May 2022 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653685005;
        bh=DLrBz8l/IovLpHyna3M9d/g4KiCI0WlAZfJ/FMILEVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBcLT8nls24IWn6bjrYkVJMkOWvFCxsxX4RNc9geGvjBn+QWmSGqpcpMApxOFVJA2
         vDjuXqF84gKuMJlkVnFR1AfPI6QGK1H71IEaHb7psBivbrtwt6V+Zl2dvFWxHcQ/y2
         R4hXbn0fUbDE84FXSgWe7k6PCkCKL+eNNzsdw8u7okZ6a6TWjaaMIRyfCCCNvEwaLu
         q/+yqYBdhciFhULZkKyCGCZGNOF2d/fX+knqC7NezooY1kq7FD5td2bzKhkJpjKg1+
         uAOMn32gy9lOOJpW113pjJKhd8tNU7J5wrY1/wx67Eom7pMbgdGAhH0hyvYZ3mXBaF
         Jw/xUFnxmoO5Q==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH bpf-next 2/3] ftrace: Keep address offset in ftrace_lookup_symbols
Date:   Fri, 27 May 2022 22:56:10 +0200
Message-Id: <20220527205611.655282-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220527205611.655282-1-jolsa@kernel.org>
References: <20220527205611.655282-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to store the resolved address on the same index as
the symbol string, because that's the user (bpf kprobe link)
code assumption.

Also making sure we don't store duplicates that might be
present in kallsyms.

Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 674add0aafb3..00d0ba6397ed 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7984,15 +7984,23 @@ static int kallsyms_callback(void *data, const char *name,
 			     struct module *mod, unsigned long addr)
 {
 	struct kallsyms_data *args = data;
+	const char **sym;
+	int idx;
 
-	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
+	sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
+	if (!sym)
+		return 0;
+
+	idx = sym - args->syms;
+	if (args->addrs[idx])
 		return 0;
 
 	addr = ftrace_location(addr);
 	if (!addr)
 		return 0;
 
-	args->addrs[args->found++] = addr;
+	args->addrs[idx] = addr;
+	args->found++;
 	return args->found == args->cnt ? 1 : 0;
 }
 
@@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
 	struct kallsyms_data args;
 	int err;
 
+	memset(addrs, 0x0, sizeof(*addrs) * cnt);
 	args.addrs = addrs;
 	args.syms = sorted_syms;
 	args.cnt = cnt;
-- 
2.35.3

