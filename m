Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDD54C74B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiFOLV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244782AbiFOLV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:21:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727EF443ED;
        Wed, 15 Jun 2022 04:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F07B81D6F;
        Wed, 15 Jun 2022 11:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED08C34115;
        Wed, 15 Jun 2022 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655292107;
        bh=KTU4AlMdJ6Qwzcq6e0SjeStZFVH5HrXYK+6yWZKNQWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiPB3hzRRUTPQ3bYn6ZtkwKeq36aaBVrQtnHters2EFVt1a3kTQ2kQOsUzFMRuG09
         Oyx3Zso3NGhHotSEI5Kq2BEFlh5SSEvMVF0y/xFqFOPfv4CLj2+Z0rWlZAZcsk9V/h
         z1z7FZqeDRadGSVKLLlZ42L1UnAEpPwyiz2KoTFqHn/t39bq0NW20Y1poUrT/DtSsZ
         4qLl0dyl6FsK8RyWAeJW9EiZ2nYsqoJDV73b/JU1D8ANQPBwC2rvtsFRXR+8f+gU6s
         VD3v6i3nCcUw83zRZQyyAhGqx4loTBANFccJIvYO6SCZA4R9wHFLKQW73t5nS72uiC
         WkM+Z7MUU9Yaw==
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
Subject: [PATCHv3 bpf 2/4] ftrace: Keep address offset in ftrace_lookup_symbols
Date:   Wed, 15 Jun 2022 13:21:16 +0200
Message-Id: <20220615112118.497303-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220615112118.497303-1-jolsa@kernel.org>
References: <20220615112118.497303-1-jolsa@kernel.org>
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
index e750fe141a60..601ccf1b2f09 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8029,15 +8029,23 @@ static int kallsyms_callback(void *data, const char *name,
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
 
@@ -8062,6 +8070,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
 	struct kallsyms_data args;
 	int err;
 
+	memset(addrs, 0, sizeof(*addrs) * cnt);
 	args.addrs = addrs;
 	args.syms = sorted_syms;
 	args.cnt = cnt;
-- 
2.35.3

