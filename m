Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A957554036C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344849AbiFGQK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343591AbiFGQK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F86C85EC6;
        Tue,  7 Jun 2022 09:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE16261680;
        Tue,  7 Jun 2022 16:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAA3C385A5;
        Tue,  7 Jun 2022 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654618257;
        bh=8ifnsinOmvqwHnK+WRL4Ye2Y78l6jmJecGk3v2CYFjA=;
        h=From:To:Cc:Subject:Date:From;
        b=WIA1F3GuuNqJ48lMQUzZ2T4uF5lmq1glfTX2D0NxtMUOwduOME6Gk5mS//U8QS1Lf
         30ZF3mXk10JENt8XyziLxfHYTiIL2NiVsfha9qXUaMLzKqle2JyyzHTLY/hyZu3NMl
         ZxtnOOA8Hqt+Ec/vsSo8Y1mezHiVwBDHS0KP+o1g0i8b6qlZuj9IqUfdgJ2KWOF3n+
         nTi4oepvf/XYnvjDeSQL87hIQSuK7AJuxmOx+IiofF9Hjrb5bB7p64Z8tjQmD/OJmI
         syuAM19WBW3ctP3ygJkOPNs0EHOtX9vCdDkMDxG5WefYdQpFj5ukEpRyIyVIPHXl1s
         sVLGc+pBMPt6w==
From:   "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 0/2] rethook: Reject getting a rethook if RCU is not watching
Date:   Wed,  8 Jun 2022 01:10:52 +0900
Message-Id: <165461825202.280167.12903689442217921817.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
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

Hi,

Here is the 2nd version of the patches to reject rethook if RCU is
not watching. The 1st version is here;

https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/

This is actually related to the idle function tracing issue
reported by Jiri on LKML (*)

(*) https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/

Jiri reported that fprobe (and rethook) based kprobe-multi bpf
trace kicks "suspicious RCU usage" warning. This is because the
RCU operation is used in the kprobe-multi handler. However, I
also found that the similar issue exists in the rethook because
the rethook uses RCU operation.

I added a new patch [1/2] to test this issue by fprobe_example.ko.
(with this patch, it can avoid using printk() which also involves
the RCU operation.)

 ------
 # insmod fprobe_example.ko symbol=arch_cpu_idle use_trace=1 stackdump=0 
 fprobe_init: Planted fprobe at arch_cpu_idle
 # rmmod fprobe_example.ko 
 
 =============================
 WARNING: suspicious RCU usage
 5.18.0-rc5-00019-gcae4ec21e87a-dirty #30 Not tainted
 -----------------------------
 include/trace/events/lock.h:37 suspicious rcu_dereference_check() usage!
 
 other info that might help us debug this:
 
 rcu_scheduler_active = 2, debug_locks = 1
 
 
 RCU used illegally from extended quiescent state!
 no locks held by swapper/0/0.
 
 stack backtrace:
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.0-rc5-00019-gcae4ec21e87a-dirty #30
 ------
 
After applying [2/2] fix (which avoid initializing rethook on
function entry if !rcu_watching()), this warning was gone.

 ------
 # insmod fprobe_example.ko symbol=arch_cpu_idle use_trace=1 stackdump=0
 fprobe_init: Planted fprobe at arch_cpu_idle
 # rmmod fprobe_example.ko 
 fprobe_exit: fprobe at arch_cpu_idle unregistered. 225 times hit, 230 times missed
 ------

Note that you can test this program until the arch_cpu_idle()
is marked as noinstr. After that, the function can not be
traced.

Thank you,

---

Masami Hiramatsu (Google) (2):
      fprobe: samples: Add use_trace option and show hit/missed counter
      rethook: Reject getting a rethook if RCU is not watching


 kernel/trace/rethook.c          |    9 +++++++++
 samples/fprobe/fprobe_example.c |   21 +++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

--
Signature
