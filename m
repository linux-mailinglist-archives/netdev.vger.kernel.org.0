Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5865453EE17
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiFFSsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiFFSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:48:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542EA1B4363;
        Mon,  6 Jun 2022 11:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE4061423;
        Mon,  6 Jun 2022 18:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6A9C385A9;
        Mon,  6 Jun 2022 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654541280;
        bh=oenzZKBwu+yYvuKRKzmfDgx5zIbYMMw/HD87fYbkTCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8nZoxtGviHxv1D34flnChvIGDNF0DgmOxsB1sxtkcQ1wrnkOuj8sRWqhGs2FC3t1
         RbOSREKzxDPELadYHijNxeMGkQCQ8hC425AA5usH4LkHxYxZLxCzPfQ8pvimjWOHy5
         zvojYImseHB4VxQi1JPOvczGIXzkZlklHSG9DPUzkFbs2ckI6K86JXWY81e1M1ywmm
         4BG0uWjVfs7Yssp0Pghe7vtRYWyj9Ays9kkrge0bAFuYwPPLJ3zFUK9E1ipLah+Bqz
         fGZZiolhPwZyp2eOIsCsBdxymAxKnX/sj1UZR/ZvhLXLNvb/+07Tjs6pxQlvDjndcG
         k95nUpfk3RauA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCHv2 bpf 2/3] ftrace: Keep address offset in ftrace_lookup_symbols
Date:   Mon,  6 Jun 2022 20:47:30 +0200
Message-Id: <20220606184731.437300-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606184731.437300-1-jolsa@kernel.org>
References: <20220606184731.437300-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 674add0aafb3..ee9260ee0b80 100644
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
 
+	memset(addrs, 0, sizeof(*addrs) * cnt);
 	args.addrs = addrs;
 	args.syms = sorted_syms;
 	args.cnt = cnt;
-- 
2.35.3

