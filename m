Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E1048C571
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353862AbiALOC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:02:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55692 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241882AbiALOCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:02:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A88B81EF5;
        Wed, 12 Jan 2022 14:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174EFC36AEB;
        Wed, 12 Jan 2022 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641996172;
        bh=uayWTdYWx3QbqMgJdDejzmI6ICpH34KGHB/icIksWtg=;
        h=From:To:Cc:Subject:Date:From;
        b=JPJR/+CTheUlVmrQbjmGXIw2pufHWnn5R1IqcKl0zu6GwySyVqcqxjbSWsbk86b2+
         c+cTRoL+A638l+TXhT4xjeDSNmK/T9HZRcPVRJyKtbZgdiFuo+1Zj7VwbrSPinLuDe
         x2Lvk8EHe6gvlObRoQTjXz+az65VghoZ2SlmQZr5zmgqF9yTKrgDkfhI1O7LE6RjVP
         /lR5RQ/SQGHZ0cORM2dMC7kR1zSV3m6WNpWKUZ8pqFH0f52Q03LHbySRGZT/41SmTM
         Ou2eo68X2Mq6xzEit7zxL2XPHpy43/w8lXwYwaBU47WQ3XXiwht01SJ+D6nYO6ONc2
         v0I/uayVcXdVg==
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
Subject: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit probe 
Date:   Wed, 12 Jan 2022 23:02:46 +0900
Message-Id: <164199616622.1247129.783024987490980883.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri and Alexei,

Here is the 2nd version of fprobe. This version uses the
ftrace_set_filter_ips() for reducing the registering overhead.
Note that this also drops per-probe point private data, which
is not used anyway.

This introduces the fprobe, the function entry/exit probe with
multiple probe point support. This also introduces the rethook
for hooking function return as same as kretprobe does. This
abstraction will help us to generalize the fgraph tracer,
because we can just switch it from rethook in fprobe, depending
on the kernel configuration.

The patch [1/8] and [7/8] are from your series[1]. Other libbpf
patches will not be affected by this change.

[1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u

I also added an out-of-tree (just for testing) patch at the
end of this series ([8/8]) for adding a wildcard support to
the sample program. With that patch, it shows how long the
registration will take;

# time insmod fprobe_example.ko symbol='btrfs_*'
[   36.130947] fprobe_init: 1028 symbols found
[   36.177901] fprobe_init: Planted fprobe at btrfs_*
real    0m 0.08s
user    0m 0.00s
sys     0m 0.07s

Thank you,

---

Jiri Olsa (2):
      ftrace: Add ftrace_set_filter_ips function
      bpf: Add kprobe link for attaching raw kprobes

Masami Hiramatsu (6):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample


 arch/x86/Kconfig                |    1 
 arch/x86/kernel/Makefile        |    1 
 arch/x86/kernel/rethook.c       |  115 ++++++++++++++++++++
 include/linux/bpf_types.h       |    1 
 include/linux/fprobe.h          |   57 ++++++++++
 include/linux/ftrace.h          |    3 +
 include/linux/rethook.h         |   74 +++++++++++++
 include/linux/sched.h           |    3 +
 include/uapi/linux/bpf.h        |   12 ++
 kernel/bpf/syscall.c            |  195 +++++++++++++++++++++++++++++++++-
 kernel/exit.c                   |    2 
 kernel/fork.c                   |    3 +
 kernel/kallsyms.c               |    1 
 kernel/trace/Kconfig            |   22 ++++
 kernel/trace/Makefile           |    2 
 kernel/trace/fprobe.c           |  168 +++++++++++++++++++++++++++++
 kernel/trace/ftrace.c           |   54 ++++++++-
 kernel/trace/rethook.c          |  226 +++++++++++++++++++++++++++++++++++++++
 samples/Kconfig                 |    7 +
 samples/Makefile                |    1 
 samples/fprobe/Makefile         |    3 +
 samples/fprobe/fprobe_example.c |  154 +++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h  |   12 ++
 23 files changed, 1103 insertions(+), 14 deletions(-)
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
