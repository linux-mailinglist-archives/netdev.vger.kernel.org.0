Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0325B540374
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344879AbiFGQLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344867AbiFGQLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5245CF5068;
        Tue,  7 Jun 2022 09:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0669617AC;
        Tue,  7 Jun 2022 16:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEC1C385A5;
        Tue,  7 Jun 2022 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654618267;
        bh=qtc/embRhXHPiGp25zYBFWJdV1Ybg67cCQgLPhgAAmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Djq+uw1XLpfVGayus11RDJXercv/w7NBIVHDvJddJb0wH7s1rBHaJ30RN8F+H0yZK
         46ial4A6sq4mN0PJYGh0kX3RMJzDxFp8KqSDbBQEm6jaakkH9u+S/N5HkEPi+UrTI8
         mzHx3QDr62uq+rg5T8wxdx/H7ZeKk3i/LjpLxuonz18HXi/bZoRydHugLaaY4rpXip
         iSCQNQwVilySL9O1XwjZKdNzbw+KoVVls4U+8IRKppf+YhnnJbcL4TOMTz+15DaPeU
         f53KUa5F5wRAHZ1glKJC3LK3Ynw7GvN9cFZUl5lj28AGL1fuQrdEEyvr8bmd177sy3
         7calfSg7D3tvQ==
From:   "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 1/2] fprobe: samples: Add use_trace option and show hit/missed counter
Date:   Wed,  8 Jun 2022 01:11:02 +0900
Message-Id: <165461826247.280167.11939123218334322352.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <165461825202.280167.12903689442217921817.stgit@devnote2>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Add use_trace option to use trace_printk() instead of pr_info()
so that the handler doesn't involve the RCU operations.
And show the hit and missed counter so that the user can check
how many times the probe handler hit and missed.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 samples/fprobe/fprobe_example.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/samples/fprobe/fprobe_example.c b/samples/fprobe/fprobe_example.c
index 24d3cf109140..aad5af0278f4 100644
--- a/samples/fprobe/fprobe_example.c
+++ b/samples/fprobe/fprobe_example.c
@@ -21,6 +21,7 @@
 #define BACKTRACE_DEPTH 16
 #define MAX_SYMBOL_LEN 4096
 struct fprobe sample_probe;
+static unsigned long nhit;
 
 static char symbol[MAX_SYMBOL_LEN] = "kernel_clone";
 module_param_string(symbol, symbol, sizeof(symbol), 0644);
@@ -28,6 +29,8 @@ static char nosymbol[MAX_SYMBOL_LEN] = "";
 module_param_string(nosymbol, nosymbol, sizeof(nosymbol), 0644);
 static bool stackdump = true;
 module_param(stackdump, bool, 0644);
+static bool use_trace = false;
+module_param(use_trace, bool, 0644);
 
 static void show_backtrace(void)
 {
@@ -40,7 +43,11 @@ static void show_backtrace(void)
 
 static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
 {
-	pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
+	if (use_trace)
+		trace_printk("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
+	else
+		pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
+	nhit++;
 	if (stackdump)
 		show_backtrace();
 }
@@ -49,8 +56,13 @@ static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_r
 {
 	unsigned long rip = instruction_pointer(regs);
 
-	pr_info("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
-		(void *)ip, (void *)ip, (void *)rip, (void *)rip);
+	if (use_trace)
+		trace_printk("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
+			(void *)ip, (void *)ip, (void *)rip, (void *)rip);
+	else
+		pr_info("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
+			(void *)ip, (void *)ip, (void *)rip, (void *)rip);
+	nhit++;
 	if (stackdump)
 		show_backtrace();
 }
@@ -112,7 +124,8 @@ static void __exit fprobe_exit(void)
 {
 	unregister_fprobe(&sample_probe);
 
-	pr_info("fprobe at %s unregistered\n", symbol);
+	pr_info("fprobe at %s unregistered. %ld times hit, %ld times missed\n",
+		symbol, nhit, sample_probe.nmissed);
 }
 
 module_init(fprobe_init)

