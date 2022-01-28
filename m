Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8184549FBAF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349186AbiA1OcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:32:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49238 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiA1OcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:32:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E1FB825E0;
        Fri, 28 Jan 2022 14:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F0DC340E0;
        Fri, 28 Jan 2022 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380322;
        bh=N06BY2yD0VIgGQaKtb6SY9NmneyUIuGwmMP6EC6ffQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=Lf+JcRWzIGneC6irqlFyqnmvCe7fJlC5Jg5R9K62vsJgjhwbKFwSMgdpUxFrlm3eG
         YoK0v83zPBf2p9H8CqKebN+xcW6w2WHrTWyfDoDcx9V236C4iLRbauiyxC2JpBVm/q
         QkkkchjRitE0JMD1UYecQk1R7ZGzGgzG3GFiFZ1eZZb1Wdg8r74oXFlqYSZe/H5nPG
         /SHwAKl5K3H+9rAA/SjSY+831qJPuWWZd8JeuZ5Fj6S2bl9Yw7yweH957V8UjlPVl5
         PGOmqpF53O7Ol+kEfCwPcqfpMoQFnwEFYJ0VdzPqC+hNQ9PV3zPpunGdOje01lSxx+
         FWDNAqiebGNlg==
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
Subject: [PATCH v6 00/10] fprobe: Introduce fprobe function entry/exit probe 
Date:   Fri, 28 Jan 2022 23:31:56 +0900
Message-Id: <164338031590.2429999.6203979005944292576.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 6th version of fprobe. This version changes fprobe interface
accroding to the discussion with Steve, adds a new flag for compatibility
with the kprobes, and fixes some issues pointed in the previous version.

The previous version is here[1];

[1] https://lore.kernel.org/all/164311269435.1933078.6963769885544050138.stgit@devnote2/T/#u

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support. This also introduces the rethook
for hooking function return as same as kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch it from rethook in fprobe, depending
on the kernel configuration.

The patch [1/10] is from Jiri's series[2].

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

I update this patch to fix typo and add a comment as Steve pointed.

I also found that the fprobe spec about recursion is a bit different from
kprobes. This may be a problem if user wants to run the same code from
fprobe and the kprobes. To avoid this issue, I introduced the
FPROBE_FL_KPROBE_SHARED flag[9/10].

I would like to confirm that the eBPF is recursion safe or detect recursion
by itself. If not, please try the above flag.

Thank you,

---

Jiri Olsa (1):
      ftrace: Add ftrace_set_filter_ips function

Masami Hiramatsu (9):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      ARM: rethook: Add rethook arm implementation
      arm64: rethook: Add arm64 rethook implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst


 Documentation/trace/fprobe.rst                |  161 ++++++++++++
 Documentation/trace/index.rst                 |    1 
 arch/arm/Kconfig                              |    1 
 arch/arm/include/asm/stacktrace.h             |    4 
 arch/arm/kernel/stacktrace.c                  |    6 
 arch/arm/probes/Makefile                      |    1 
 arch/arm/probes/rethook.c                     |   71 +++++
 arch/arm64/Kconfig                            |    1 
 arch/arm64/include/asm/stacktrace.h           |    2 
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 ++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 ++++++
 arch/arm64/kernel/stacktrace.c                |    7 -
 arch/x86/Kconfig                              |    1 
 arch/x86/include/asm/unwind.h                 |    8 +
 arch/x86/kernel/Makefile                      |    1 
 arch/x86/kernel/kprobes/common.h              |    1 
 arch/x86/kernel/rethook.c                     |  115 ++++++++
 include/linux/fprobe.h                        |   97 +++++++
 include/linux/ftrace.h                        |    3 
 include/linux/kprobes.h                       |    3 
 include/linux/rethook.h                       |  100 +++++++
 include/linux/sched.h                         |    3 
 kernel/exit.c                                 |    2 
 kernel/fork.c                                 |    3 
 kernel/trace/Kconfig                          |   25 ++
 kernel/trace/Makefile                         |    2 
 kernel/trace/fprobe.c                         |  339 +++++++++++++++++++++++++
 kernel/trace/ftrace.c                         |   58 ++++
 kernel/trace/rethook.c                        |  313 +++++++++++++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  120 +++++++++
 34 files changed, 1559 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/trace/fprobe.rst
 create mode 100644 arch/arm/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
