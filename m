Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91F49B38D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355828AbiAYMOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:14:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355907AbiAYMLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:11:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 705A560FFB;
        Tue, 25 Jan 2022 12:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7418EC340E8;
        Tue, 25 Jan 2022 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643112700;
        bh=s/++T4vWmGwl42K8BOKMjcTgDgC5RAaZIAeyuP1TZj8=;
        h=From:To:Cc:Subject:Date:From;
        b=ZJS+FA0Q8+xLsXW24zmFHFubs1V+od2Jg1gEZG2lRCqe1+7Dc8wsIq/IH7GprIg8g
         vyFl4vH8fyW/bXzYjxKU+BReikOScUnbCVMi5M2qNw6rMc11hTQQipPf79vRx0qc20
         sMiHHeAfw/zDK4jmfqGu2ZQ/j6fTnwRzKihj2C6IZbU/QL/U/ninW9A7qKkqwA4P9S
         U/pxb/B1l9/FibMe8/6x8heEBFmQFvQ4jV8qpMG2JGVaHvmdt82/aKhLR2wP2bI9v/
         Mnj1wCaGotnXDebto6Y/WZonD4eJSBtV8h4mjPxCReXLDD9etXS0NthVd1j3PuDS8p
         DzS5IJsue/ghA==
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
Subject: [PATCH v5 0/9] fprobe: Introduce fprobe function entry/exit probe 
Date:   Tue, 25 Jan 2022 21:11:34 +0900
Message-Id: <164311269435.1933078.6963769885544050138.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 5th version of fprobe. This version fixed some build
issues on fprobe and rethook (thanks for kernel test bot to give
a hint!). The previous version is here[1];

[1] https://lore.kernel.org/all/164304056155.1680787.14081905648619647218.stgit@devnote2/

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support. This also introduces the rethook
for hooking function return as same as kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch it from rethook in fprobe, depending
on the kernel configuration.

The patch [1/9] is from Jiri's series[2].

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u


Thank you,

---

Jiri Olsa (1):
      ftrace: Add ftrace_set_filter_ips function

Masami Hiramatsu (8):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      ARM: rethook: Add rethook arm implementation
      arm64: rethook: Add arm64 rethook implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst


 Documentation/trace/fprobe.rst                |  131 +++++++++++
 Documentation/trace/index.rst                 |    1 
 arch/arm/Kconfig                              |    1 
 arch/arm/include/asm/stacktrace.h             |    4 
 arch/arm/kernel/stacktrace.c                  |    6 
 arch/arm/probes/Makefile                      |    1 
 arch/arm/probes/rethook.c                     |   71 ++++++
 arch/arm64/Kconfig                            |    1 
 arch/arm64/include/asm/stacktrace.h           |    2 
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 ++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 +++++++
 arch/arm64/kernel/stacktrace.c                |    7 -
 arch/x86/Kconfig                              |    1 
 arch/x86/include/asm/unwind.h                 |    8 +
 arch/x86/kernel/Makefile                      |    1 
 arch/x86/kernel/kprobes/common.h              |    1 
 arch/x86/kernel/rethook.c                     |  115 +++++++++
 include/linux/fprobe.h                        |   86 +++++++
 include/linux/ftrace.h                        |    3 
 include/linux/rethook.h                       |   99 ++++++++
 include/linux/sched.h                         |    3 
 kernel/exit.c                                 |    2 
 kernel/fork.c                                 |    3 
 kernel/trace/Kconfig                          |   25 ++
 kernel/trace/Makefile                         |    2 
 kernel/trace/fprobe.c                         |  198 ++++++++++++++++
 kernel/trace/ftrace.c                         |   53 ++++
 kernel/trace/rethook.c                        |  311 +++++++++++++++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  103 ++++++++
 33 files changed, 1349 insertions(+), 14 deletions(-)
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
