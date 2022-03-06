Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1AB4CEA37
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 10:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiCFJgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 04:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiCFJgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 04:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A5E2C12A;
        Sun,  6 Mar 2022 01:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 713BCB80E5C;
        Sun,  6 Mar 2022 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C393C340EC;
        Sun,  6 Mar 2022 09:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646559346;
        bh=t5Grv799NgfRF6jY7CEP/rCuf6Q+tLfGdN3EoP7Y4Rw=;
        h=From:To:Cc:Subject:Date:From;
        b=VIWBwIOPH4AfEMU1SwzwtZHGoDSE42uGFS5l7oImg6ZcRvwVtDx5DU7S8xio9pyQ4
         j5Lp+FjiKe/ZyVY3r1eWcFZE8pBU/GC0EB9Ss6QQRQ11BBDSYEIFj8EEUJ0tAI2d77
         c08i8UkWkTG8l85D3ByOM+90L3+eCfgvUDeTGO1LCHjfitLPt0ckXrq/MjXh6C6oRN
         PstU6tsbxXjbI87l9wRT6/QbM9QxSrhX1akB8JyDqkyeDGmOv5yA7T9PSrqGobYsr3
         QLAnFu6Ia5400EunYnwl4kOjsamlPrQF4CsF4RhwfUvEHWe1tOIn5nfHSRSF8XE81+
         sV1V4gRF/5zDQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v9 00/11] fprobe: Introduce fprobe function entry/exit probe 
Date:   Sun,  6 Mar 2022 18:35:40 +0900
Message-Id: <164655933970.1674510.3809060481512713846.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 9th version of fprobe. This version has some updates (mainly
cleanup the code, drop arm rethook and adding powerpc rethook) and selftest
bugfixes.

The previous version (v8) is here[1];

[1] https://lore.kernel.org/all/164458044634.586276.3261555265565111183.stgit@devnote2/T/#u

In this version, I fixed fprobe to check the symbol size and unify the code
of register_fprobe_syms() and register_fprobe_ips() ([2/11]), add port the
rethook to powerpc64([6/11]), and fix fprobe reuse bug in the selftest
([11/11]). I also drop rethook arm-port, because I found complicated stack
magic for ftrace implementation on arm. I need more investigation since it
seems to show different call-frame on pt_regs at the actual function entry
and the ftrace callback, and compiled by gcc/clang too.

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support for x86, arm64 and powerpc64le.
This also introduces the rethook for hooking function return as same as
the kretprobe does. This abstraction will help us to generalize the fgraph
tracer, because we can just switch to it from the rethook in fprobe,
depending on the kernel configuration.

The patch [1/10] is from Jiri's series[2].

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
if user wants to share the same code (or share a same resource) on the
fprobe and the kprobes.

I forcibly updated my kprobes/fprobe branch, you can pull this series
from:

 https://git.kernel.org/pub/scm/linux/kernel/git/mhiramat/linux.git kprobes/fprobe

Thank you,

---

Jiri Olsa (1):
      ftrace: Add ftrace_set_filter_ips function

Masami Hiramatsu (10):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      arm64: rethook: Add arm64 rethook implementation
      powerpc: Add rethook support
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst
      fprobe: Add a selftest for fprobe


 Documentation/trace/fprobe.rst                |  171 +++++++++++++
 Documentation/trace/index.rst                 |    1 
 arch/arm64/Kconfig                            |    1 
 arch/arm64/include/asm/stacktrace.h           |    2 
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 ++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 +++++++
 arch/arm64/kernel/stacktrace.c                |    7 -
 arch/powerpc/Kconfig                          |    1 
 arch/powerpc/kernel/Makefile                  |    1 
 arch/powerpc/kernel/rethook.c                 |   72 +++++
 arch/x86/Kconfig                              |    1 
 arch/x86/include/asm/unwind.h                 |    8 +
 arch/x86/kernel/Makefile                      |    1 
 arch/x86/kernel/kprobes/common.h              |    1 
 arch/x86/kernel/rethook.c                     |  115 +++++++++
 include/linux/fprobe.h                        |  105 ++++++++
 include/linux/ftrace.h                        |    3 
 include/linux/kprobes.h                       |    3 
 include/linux/rethook.h                       |  100 ++++++++
 include/linux/sched.h                         |    3 
 kernel/exit.c                                 |    2 
 kernel/fork.c                                 |    3 
 kernel/trace/Kconfig                          |   26 ++
 kernel/trace/Makefile                         |    2 
 kernel/trace/fprobe.c                         |  332 +++++++++++++++++++++++++
 kernel/trace/ftrace.c                         |   58 ++++
 kernel/trace/rethook.c                        |  313 ++++++++++++++++++++++++
 lib/Kconfig.debug                             |   12 +
 lib/Makefile                                  |    2 
 lib/test_fprobe.c                             |  174 +++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  120 +++++++++
 35 files changed, 1752 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/trace/fprobe.rst
 create mode 100644 arch/arm64/kernel/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S
 create mode 100644 arch/powerpc/kernel/rethook.c
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 lib/test_fprobe.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
