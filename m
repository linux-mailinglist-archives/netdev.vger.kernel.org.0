Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6DE567719
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiGETDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiGETDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836DC13EB3;
        Tue,  5 Jul 2022 12:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13067B8191D;
        Tue,  5 Jul 2022 19:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B82CC341C7;
        Tue,  5 Jul 2022 19:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657047807;
        bh=7lim26PhrH9UscD530EbLXPzArYaPcRW/g+FHGSq21A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaoGsS7vB1LGM2pNZxWB8UN5LcLVqPPLsl3EAwHq74yH5dQ7yvf/IxrBQEVuE1eHv
         BwMyQJpZrLbczkqjNYtgx3vyBz1FwrmqGCf+HmwtMHAmq/U5Tps5Oo4NQj8p7FZ5ob
         dbWt2lty+djASz2LohnH/9HDDt42XRaWG1GZJRODho6OD1s0P8Lo54k2qQZlf66waV
         sYAVT+5IDko+xbMRG3Kz3XQVD5l5pXjbCgrWBbbC+z7M5Qmwq8KG7Ts7TH4UQz0tae
         /qxjs+IAple9IgdcNUcfIvJfVnk8J4aTBw3Pfl+ucgidNR7J8FtiodFCWqXr78QeY9
         qyINTU3KHZBtg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martynas Pumputis <m@lambda.lt>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
Subject: [PATCH RFC bpf-next 1/4] bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT
Date:   Tue,  5 Jul 2022 21:03:05 +0200
Message-Id: <20220705190308.1063813-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220705190308.1063813-1-jolsa@kernel.org>
References: <20220705190308.1063813-1-jolsa@kernel.org>
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

Martynas reported bpf_get_func_ip returning +4 address when
CONFIG_X86_KERNEL_IBT option is enabled.

When CONFIG_X86_KERNEL_IBT is enabled we'll have endbr instruction
at the function entry, which screws return value of bpf_get_func_ip()
helper that should return the function address.

There's short term workaround [1] for kprobe_multi bpf program made
by Alexei [1], but we need this fixup also for bpf_get_attach_cookie,
that returns cookie based on the entry_ip value.

Moving the fixup in the fprobe handler, so both bpf_get_func_ip
and bpf_get_attach_cookie get expected function address when
CONFIG_X86_KERNEL_IBT option is enabled.

Keeping the resolved 'addr' in kallsyms_callback, instead of taking
ftrace_location value, because we depend on symbol address in the
cookie related code. With CONFIG_X86_KERNEL_IBT option the
ftrace_location value differs from symbol address.

Reported-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c                         | 3 +++
 kernel/trace/ftrace.c                            | 3 +--
 tools/testing/selftests/bpf/progs/kprobe_multi.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4be976cf7d63..ad1e7616c16d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2419,6 +2419,9 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 {
 	struct bpf_kprobe_multi_link *link;
 
+#ifdef CONFIG_X86_KERNEL_IBT
+	entry_ip -= ENDBR_INSN_SIZE;
+#endif
 	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
 	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e750fe141a60..c866855e77e6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8033,8 +8033,7 @@ static int kallsyms_callback(void *data, const char *name,
 	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
 		return 0;
 
-	addr = ftrace_location(addr);
-	if (!addr)
+	if (!ftrace_location(addr))
 		return 0;
 
 	args->addrs[args->found++] = addr;
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index 93510f4f0f3a..8c6155e17572 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -44,7 +44,7 @@ static void kprobe_multi_check(void *ctx, bool is_return)
 		return;
 
 	__u64 cookie = test_cookie ? bpf_get_attach_cookie(ctx) : 0;
-	__u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
+	__u64 addr = bpf_get_func_ip(ctx);
 
 #define SET(__var, __addr, __cookie) ({			\
 	if (((const void *) addr == __addr) &&		\
-- 
2.35.3

