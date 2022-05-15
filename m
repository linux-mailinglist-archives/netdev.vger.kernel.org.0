Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A7E5279ED
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiEOUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEOUhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 16:37:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEF211C31;
        Sun, 15 May 2022 13:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B5CB80E11;
        Sun, 15 May 2022 20:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A05C385B8;
        Sun, 15 May 2022 20:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652647019;
        bh=GrCoDmkEGZhrFkRwhSQwfYPPWhwhCDYMWQ8Z6at6QAI=;
        h=From:To:Cc:Subject:Date:From;
        b=EQ3ICpYy6jfWgWmBpV4ItsGmja6AVNh1JNSf7Vb+tTCCYV3NO20oXIo5sQQ8lnBrQ
         0Ww9D62uD8n/jh6QR+M86Nql6+e2twSa//3MkdaJDF3XfmAjdI5hhS9zBWWPeLOZTW
         dZImeLoqFQbBm8PBlG9TyTM1G0dQEN3L8KUrqD5mM5bq/U+pgwH7UllN/DriFHnWOl
         b1bghyhM9ZoKnWee1E9yTDOy5uEWMcmlk9ZPMR8VOYWlQqweU627zKXF/C0OOphqr5
         LbWflqpT5UW1TOjEopiiUPHYQjQDuRDn9T00f29o2x/RYyZLIFey/a4TkGm/Fxlg1I
         cTDBRbTqfOJhg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and rcu_idle_exit noinstr
Date:   Sun, 15 May 2022 22:36:52 +0200
Message-Id: <20220515203653.4039075-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
in rcu 'not watching' context and if there's tracer attached to
them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
warning like:

  [    3.017540] WARNING: suspicious RCU usage
  ...
  [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
  [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
  [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
  [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
  [    3.018371]  fprobe_handler.part.0+0xab/0x150
  [    3.018374]  0xffffffffa00080c8
  [    3.018393]  ? arch_cpu_idle+0x5/0x10
  [    3.018398]  arch_cpu_idle+0x5/0x10
  [    3.018399]  default_idle_call+0x59/0x90
  [    3.018401]  do_idle+0x1c3/0x1d0

The call path is following:

default_idle_call
  rcu_idle_enter
  arch_cpu_idle
  rcu_idle_exit

The arch_cpu_idle and rcu_idle_exit are the only ones from above
path that are traceble and cause this problem on my setup.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/process.c | 2 +-
 kernel/rcu/tree.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b370767f5b19..1345cb0124a6 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
 /*
  * Called from the generic idle code.
  */
-void arch_cpu_idle(void)
+void noinstr arch_cpu_idle(void)
 {
 	x86_idle();
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a4b8189455d5..20d529722f51 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
  * If you add or remove a call to rcu_idle_exit(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_idle_exit(void)
+void noinstr rcu_idle_exit(void)
 {
 	unsigned long flags;
 
-- 
2.35.3

