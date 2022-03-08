Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862CB4D15B6
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346165AbiCHLJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiCHLJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:09:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AAF37ABC;
        Tue,  8 Mar 2022 03:08:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9715B81624;
        Tue,  8 Mar 2022 11:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E83C340EB;
        Tue,  8 Mar 2022 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646737717;
        bh=9qsWMcTZ9dCfNEJRbna3y6MzWHIHDbd52umBk7yDHOE=;
        h=From:To:Cc:Subject:Date:From;
        b=f7FO4I+xcsMm+cZGcoMrn2CJarb6Bhbp12sfm2LGX0OQ85ifhynMXiPYr31cF/act
         uc92VonQfHR4Ik2OwK9fYZdRbJzpetjrFhDi3bwNrBQ5XUXQESMNepQIzrP8O4ssw2
         haJJ3j2LIN8riLt3jFg4BqdDo/RS3FbWTpR3+ZD3giDItoRzZrlUmDERkIvV2+a8z5
         cAW5YOz0C6T5s4NRlmXd2zSTO/0RM4MbgMs7RgEtY7XQZjo7tH3IBhE2PJ/ojTUSkD
         apq5lgXJerCmmJTevpvIGuXFMXqIm5IbS//EOgimMW6LceW772JjoZ1WLcOU5yuShi
         q7wWgKL9A67RA==
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
Subject: [PATCH v10 00/12] fprobe: Introduce fprobe function entry/exit probe 
Date:   Tue,  8 Mar 2022 20:08:31 +0900
Message-Id: <164673771096.1984170.8155877393151850116.stgit@devnote2>
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

Here is the 10th version of fprobe. In this version, the rethook arm support
([7/12]) comes back :-D, add an internal rethook flag for identify the context
([3-8/12]), and simplifies the ftrace_location lookup loops([2/12]) according
to Jiri's comment :)

The previous version (v9) is here[1];

[1] https://lore.kernel.org/all/164655933970.1674510.3809060481512713846.stgit@devnote2/T/#u

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
 kernel/trace/rethook.c                        |  317 ++++++++++++++++++++++++
 lib/Kconfig.debug                             |   12 +
 lib/Makefile                                  |    2 
 lib/test_fprobe.c                             |  174 +++++++++++++
 samples/Kconfig                               |    7 +
 samples/Makefile                              |    1 
 samples/fprobe/Makefile                       |    3 
 samples/fprobe/fprobe_example.c               |  120 +++++++++
 40 files changed, 1867 insertions(+), 14 deletions(-)
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
