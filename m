Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450704D657B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344571AbiCKP7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241374AbiCKP7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:59:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC439186421;
        Fri, 11 Mar 2022 07:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B8FDCE2952;
        Fri, 11 Mar 2022 15:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68636C340E9;
        Fri, 11 Mar 2022 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647014327;
        bh=xkk6Hyp9tf1SBuWkafNM2PoMOMKlgQKz/yoJR3HwZpE=;
        h=From:To:Cc:Subject:Date:From;
        b=X9dp/+3uU9u61M2mWfpYQV7vbOLOaMCy7Mi7rBcfrEufsJjpDBp/SGpBKs+ojtfm+
         MjPbg5vZC1Qf85kcKvp6NdLqlGIrKtEtZDi3xzYaXEpOtLyyt1knrbMLNgujn7I/nc
         F9UUzgzQM8QSJ0LjiC3AxrueCxLDio2q32AMtLEt6j63MWwfMoZX2Lva1sEhdnSjim
         VsYbjGzYsT3buixyXyoxqsSGon4aPtxkyjY1SHsuR4OmfobNqQKvvLaa54UiHeV/F0
         OwhjZRedi49lc6DbDeE4V7T0FzcDWtsEbYkOhrhwQpEetQIKEuMbcd0r5BaFmpC18v
         DkhlzPcQXHlMg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: [PATCH v11 00/12] fprobe: Introduce fprobe function entry/exit probe 
Date:   Sat, 12 Mar 2022 00:58:40 +0900
Message-Id: <164701432038.268462.3329725152949938527.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 11th version of fprobe. This version fixes some issues reported by
build bots (Thanks!) and rebased on bpf-next tree.

The previous version (v10) is here[1];

[1] https://lore.kernel.org/all/164673771096.1984170.8155877393151850116.stgit@devnote2/T/#u

This series introduces the fprobe, the function entry/exit probe
with multiple probe point support for x86, arm64 and powerpc64le.
This also introduces the rethook for hooking function return as same as
the kretprobe does. This abstraction will help us to generalize the fgraph
tracer, because we can just switch to it from the rethook in fprobe,
depending on the kernel configuration.

The patch [1/12] is from Jiri's series[2].

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

Masami Hiramatsu (11):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      arm64: rethook: Add arm64 rethook implementation
      powerpc: Add rethook support
      ARM: rethook: Add rethook arm implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst
      fprobe: Add a selftest for fprobe


 Documentation/trace/fprobe.rst                |  171 +++++++++++++
 Documentation/trace/index.rst                 |    1 
 arch/arm/Kconfig                              |    1 
 arch/arm/include/asm/stacktrace.h             |    4 
 arch/arm/kernel/stacktrace.c                  |    6 
 arch/arm/probes/Makefile                      |    1 
 arch/arm/probes/rethook.c                     |  101 ++++++++
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
 arch/x86/kernel/rethook.c                     |  119 +++++++++
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
 kernel/trace/rethook.c                        |  317 ++++++++++++++++++++++++
 lib/Kconfig.debug                             |   12 +
 lib/Makefile                                  |    2 
 lib/test_fprobe.c                             |  174 +++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  120 +++++++++
 40 files changed, 1871 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/trace/fprobe.rst
 create mode 100644 arch/arm/probes/rethook.c
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
