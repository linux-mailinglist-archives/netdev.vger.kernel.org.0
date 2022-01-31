Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCFD4A3D01
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 06:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiAaFAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 00:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiAaFAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 00:00:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA92C061714;
        Sun, 30 Jan 2022 21:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56307B81DDB;
        Mon, 31 Jan 2022 05:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1590BC340E8;
        Mon, 31 Jan 2022 05:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643605205;
        bh=SPlApvXmSAF/EmHfhsNx/9J8MUckNRlaZjFc5d87Irk=;
        h=From:To:Cc:Subject:Date:From;
        b=MJMneyKrbzhMHuT1zcq7XrHeHjGGrI2mkn/mWCkUxLgvZy8cXZStE4kONd8D7ABZS
         J5a8AQ3cu0p1fYEYwqhuEKLjkfYp5UVWHLjg2qX19s3LLUYMXlmB5d0CPsm+LV7/Ds
         8fotzCXUL9Ba7QYt7WPYUrrV6G5KAwBMaYOh30M/c6G+Pb1gPxW6NMSQFuN47qLDuq
         kjfi7e5r+BI+abWo8MFJkfSfO8FcJhSvuexM1x4mjHyLxwLofXk+iAOVcAnpWzGhdQ
         /153OoWhAVISJVWsptyzhaC3mxWeNVPmWIsKomZGjAqMTumhnRbry4XHiS0EVgjrWq
         hiZHUYSxgTCrQ==
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
Date:   Mon, 31 Jan 2022 13:59:58 +0900
Message-Id: <164360519783.65399.7103081560058537372.stgit@devnote2>
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
