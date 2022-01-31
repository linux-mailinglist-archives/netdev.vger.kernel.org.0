Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337C14A3D04
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 06:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiAaFAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 00:00:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49314 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiAaFAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 00:00:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F1C611CB;
        Mon, 31 Jan 2022 05:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FECFC340E8;
        Mon, 31 Jan 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643605231;
        bh=SPlApvXmSAF/EmHfhsNx/9J8MUckNRlaZjFc5d87Irk=;
        h=From:To:Cc:Subject:Date:From;
        b=beHhSAPAUaVm4tVLK4IevjpquuaPE3nPWHRczFcRIYwQE0s7WPVVCz2LOZo7HLCGG
         +NsIbKvzULUzHLcGOjQXblFkfGhLXXf8qV6Ymm3X6XfTRZzyJzfY3OgHwVvYMba3ED
         zpkqPW+wRTG9me68utz+JLOQhOdFEazdLhKSRil/i6lt/FcSZMrLepHzZtdwbWZphT
         6AlvyUQO2bFhI6HTcL4VihXnv7IHyDULNRjN2lJEX4+aGCAdOlQ1kY9uUkXQGSnEpC
         AEyigayX7pJG8Q9Nm2oqj7S+KO67Iwth5nOo40lT1zgKKyUqyrUbv9daULlKJMj+4E
         1OIeKDTyivDIw==
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
Subject: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit probe 
Date:   Mon, 31 Jan 2022 14:00:24 +0900
Message-Id: <164360522462.65877.1891020292202285106.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 7th version of fprobe. This version fixes unregister_fprobe()
ensures that exit_handler is not called after returning from the
unregister_fprobe(), and fixes some comments and documents.

The previous version is here[1];

[1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support. This also introduces the rethook
for hooking function return as same as the kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch to it from the rethook in fprobe,
depending on the kernel configuration.

The patch [1/10] is from Jiri's series[2].

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
if user wants to share the same code (or share a same resource) on the
fprobe and the kprobes.

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


 Documentation/trace/fprobe.rst                |  171 +++++++++++++
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
 kernel/trace/Kconfig                          |   26 ++
 kernel/trace/Makefile                         |    2 
 kernel/trace/fprobe.c                         |  341 +++++++++++++++++++++++++
 kernel/trace/ftrace.c                         |   58 ++++
 kernel/trace/rethook.c                        |  313 +++++++++++++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  120 +++++++++
 34 files changed, 1572 insertions(+), 14 deletions(-)
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
