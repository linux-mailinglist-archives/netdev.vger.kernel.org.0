Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF12498446
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243432AbiAXQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241925AbiAXQJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:09:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406F7C06173B;
        Mon, 24 Jan 2022 08:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D386060907;
        Mon, 24 Jan 2022 16:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE52C340E5;
        Mon, 24 Jan 2022 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040568;
        bh=ENESVzvy5zShp1NelCApLRU9rhgIjz+UqegaWzoG/EM=;
        h=From:To:Cc:Subject:Date:From;
        b=T05rJH45oJL2ZYVBIT0hqOn1c1sbl8TO7ARu2Q/yGVi4VtbF/maFF9uDjrgZiSF++
         m2rrks8PLljz1Pj+2QdpAFra2GZsuA5l6wsS4K5+Jc4CH3SFcCO8RiXb8/AHenbABg
         E6s6wl4prsOXEgjFSYkloVv2hVdvKw/TB6iyaxlHsCpFBPyL92mKk9qFND/Y3XG6yI
         LYSFMmXsLnNRTc1z6heKIzAkbAGhbACmSCVy/w3W+3suGuBaElU/k301X8dc0sxndo
         DYRjSowHqPIfw5EAY63nUAO2qan8b/Jns5SDi3Zss9BVnmT8pD7KzxsGIPPbzcL7ZA
         O/N3W19Z7GwfA==
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
Subject: [PATCH v4 0/9] fprobe: Introduce fprobe function entry/exit probe 
Date:   Tue, 25 Jan 2022 01:09:21 +0900
Message-Id: <164304056155.1680787.14081905648619647218.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

Here is the 4th version of fprobe. I fixed some issues on fprobe
and rethook. I dropped out-of-tree patches and Jiri's bpf patch
and add rethook arm/arm64 support and fprobe documentation.
The previous version is here[1];

[1] https://lore.kernel.org/all/164260419349.657731.13913104835063027148.stgit@devnote2/T/#u

The biggest change of this version is supporting ftrace location
conversion correctly. Previous version can not find ftrace location
if the dynamic ftrace nop is not placed a the symbol address.

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support. This also introduces the rethook
for hooking function return as same as kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch it from rethook in fprobe, depending
on the kernel configuration.

The patch [1/9] is from Jiri's series[2].

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

I'll continue porting rethook to other archs, and after that replace
the current kretprobe with the rethook. This design change will make
the fgraph/kretprobe integration easier because if fgraph is not available,
kretprobe can use rethook.


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
 arch/arm/kernel/stacktrace.c                  |    4 
 arch/arm/probes/Makefile                      |    1 
 arch/arm/probes/rethook.c                     |   71 ++++++
 arch/arm64/Kconfig                            |    1 
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 ++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 +++++++
 arch/arm64/kernel/stacktrace.c                |    3 
 arch/x86/Kconfig                              |    1 
 arch/x86/include/asm/unwind.h                 |    4 
 arch/x86/kernel/Makefile                      |    1 
 arch/x86/kernel/rethook.c                     |  115 +++++++++
 include/linux/fprobe.h                        |   86 +++++++
 include/linux/ftrace.h                        |    3 
 include/linux/rethook.h                       |   99 ++++++++
 include/linux/sched.h                         |    3 
 kernel/exit.c                                 |    2 
 kernel/fork.c                                 |    3 
 kernel/trace/Kconfig                          |   24 ++
 kernel/trace/Makefile                         |    2 
 kernel/trace/fprobe.c                         |  198 ++++++++++++++++
 kernel/trace/ftrace.c                         |   53 ++++
 kernel/trace/rethook.c                        |  311 +++++++++++++++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  103 ++++++++
 30 files changed, 1336 insertions(+), 9 deletions(-)
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
