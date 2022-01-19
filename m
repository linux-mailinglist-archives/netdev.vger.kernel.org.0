Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0710493C4A
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355312AbiASO4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:56:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43790 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbiASO4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:56:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6410BB8197E;
        Wed, 19 Jan 2022 14:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9181BC004E1;
        Wed, 19 Jan 2022 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642604200;
        bh=1uD/CVvMFthjPQFwDtjL8KkaRGWHDmG9ZZ5l4sxzrt0=;
        h=From:To:Cc:Subject:Date:From;
        b=MyF6k+KDrSYUByhIRHaaC+Dk0kfJhEkpyHmlsgzt5aBL3wamQSNLA76NHfQlrNiAN
         3mXQh5xqJ8rO2qiOcybH171tzf7Xlr9BPjcGiI2JOUlHd/5164V9sXruSaexzSwBJC
         8n+yDeR32i8fGriX+euY5MWhsU7/lW0RXFWx/wVxLcleYKmNPm2sFEoMRkOWgo17ON
         D1K5bHQv01dYeRiZhcY1Il7seLMfJ+rhn6Gw+DjXQnPzodN0fsW2CNpY0yE+eJ/f2p
         mkkiqWNcpIZ7kvG0XawBA0Ugan/ZFb2jCNnhqyQ8l76l/wK5N5w2WbFIagYU0urtSO
         DoEevO0EpUYYA==
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
Subject: [RFC PATCH v3 0/9] fprobe: Introduce fprobe function entry/exit probe 
Date:   Wed, 19 Jan 2022 23:56:33 +0900
Message-Id: <164260419349.657731.13913104835063027148.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

Here is the 3rd version of fprobe. I added some comments and
fixed some issues. But I still saw some problems when I add
your selftest patches.

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support. This also introduces the rethook
for hooking function return as same as kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch it from rethook in fprobe, depending
on the kernel configuration.

The patch [1/9] and [7/9] are from Jiri's series[1]. Other libbpf
patches will not be affected by this change.

[1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

However, when I applied all other patches on top of this series,
I saw the "#8 bpf_cookie" test case has been stacked (maybe related
to the bpf_cookie issue which Andrii and Jiri talked?) And when I
remove the last selftest patch[2], the selftest stopped at "#112
raw_tp_test_run".

[2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#m242d2b3a3775eeb5baba322424b15901e5e78483 

Note that I used tools/testing/selftests/bpf/vmtest.sh to check it.

This added 2 more out-of-tree patches. [8/9] is for adding wildcard
support to the sample program, [9/9] is a testing patch for replacing
kretprobe trampoline with rethook.
According to this work, I noticed that using rethook in kretprobe
needs 2 steps.
 1. port the rethook on all architectures which supports kretprobes.
    (some arch requires CONFIG_KPROBES for rethook)
 2. replace kretprobe trampoline with rethook for all archs, at once.
    This must be done by one treewide patch.

Anyway, I'll do the kretprobe update in the next step as another series.
(This testing patch is just for confirming the rethook is correctly
 implemented.)

BTW, on the x86, ftrace (with fentry) location address is same as
symbol address. But on other archs, it will be different (e.g. arm64
will need 2 instructions to save link-register and call ftrace, the
2nd instruction will be the ftrace location.)
Does libbpf correctly handle it?

Thank you,

---

Jiri Olsa (2):
      ftrace: Add ftrace_set_filter_ips function
      bpf: Add kprobe link for attaching raw kprobes

Masami Hiramatsu (7):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample
      [DO NOT MERGE] out-of-tree: kprobes: Use rethook for kretprobe


 arch/x86/Kconfig                |    1 
 arch/x86/include/asm/unwind.h   |    8 +
 arch/x86/kernel/Makefile        |    1 
 arch/x86/kernel/kprobes/core.c  |  106 --------------
 arch/x86/kernel/rethook.c       |  115 +++++++++++++++
 include/linux/bpf_types.h       |    1 
 include/linux/fprobe.h          |   84 +++++++++++
 include/linux/ftrace.h          |    3 
 include/linux/kprobes.h         |   85 +----------
 include/linux/rethook.h         |   99 +++++++++++++
 include/linux/sched.h           |    4 -
 include/uapi/linux/bpf.h        |   12 ++
 kernel/bpf/syscall.c            |  195 +++++++++++++++++++++++++-
 kernel/exit.c                   |    3 
 kernel/fork.c                   |    4 -
 kernel/kallsyms.c               |    1 
 kernel/kprobes.c                |  265 +++++------------------------------
 kernel/trace/Kconfig            |   22 +++
 kernel/trace/Makefile           |    2 
 kernel/trace/fprobe.c           |  179 ++++++++++++++++++++++++
 kernel/trace/ftrace.c           |   54 ++++++-
 kernel/trace/rethook.c          |  295 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_kprobe.c     |    4 -
 kernel/trace/trace_output.c     |    2 
 samples/Kconfig                 |    7 +
 samples/Makefile                |    1 
 samples/fprobe/Makefile         |    3 
 samples/fprobe/fprobe_example.c |  154 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h  |   12 ++
 29 files changed, 1283 insertions(+), 439 deletions(-)
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
