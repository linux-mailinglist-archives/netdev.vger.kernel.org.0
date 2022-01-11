Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2EA48B015
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243032AbiAKPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:00:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242802AbiAKPAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:00:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84FE8B81B2F;
        Tue, 11 Jan 2022 15:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CA2C36AE3;
        Tue, 11 Jan 2022 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641913224;
        bh=vc7azLNoekjPJ7ttnBna/PtB27oQO40d88goKeCy6ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYffuG+LZ1PJ6cyAtMHefBpKjbdkhoFTOrLp4VRE8TmzdMGTa9K/qqufCYCCY2GJl
         p79NfNYe4B9E7Qtu/EZA5ZJnpRtloBIc/7Erm0/zTwUhrgZvRzdbIuzuwVZzSM0AVc
         6lYryHguaLS448+I9VKFN61hjzBcgve7GIFhbkEGUU4ikCys/qcZLIdzQjejjHE8CJ
         cFQS1kMl2TlZ9Ov+ndmfKEAy/w9aFnV7FyMix6Ru/N4nUeWe7RvsVqyQPurUz8L2ml
         HfcccV90JfloclxPFrkCj4B7dBvUnl9cLe3RHErWztXDd2DNuaoSPqoqCMi1JDZXxn
         cSX574I3nGoyg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [RFC PATCH 0/6] fprobe: Introduce fprobe function entry/exit probe 
Date:   Wed, 12 Jan 2022 00:00:17 +0900
Message-Id: <164191321766.806991.7930388561276940676.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Here is a short series of patches, which shows what I replied
to your series.

This introduces the fprobe, the function entry/exit probe with
multiple probe point support. This also introduces the rethook
for hooking function return, which I cloned from kretprobe.

I also rewrite your [08/13] bpf patch to use this fprobe instead
of kprobes. I didn't tested that one, but the sample module seems
to work. Please test bpf part with your libbpf updates.

BTW, while implementing the fprobe, I introduced the per-probe
point private data, but I'm not sure why you need it. It seems
that data is not used from bpf...

If this is good for you, I would like to proceed this with
the rethook and rewrite the kretprobe to use the rethook to
hook the functions. That should be much cleaner (and easy to
prepare for the fgraph tracer integration)

Thank you,

---

Jiri Olsa (1):
      bpf: Add kprobe link for attaching raw kprobes

Masami Hiramatsu (5):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe


 arch/x86/Kconfig                |    1 
 arch/x86/kernel/Makefile        |    1 
 arch/x86/kernel/rethook.c       |  115 ++++++++++++++++++++
 include/linux/bpf_types.h       |    1 
 include/linux/fprobes.h         |   75 +++++++++++++
 include/linux/rethook.h         |   74 +++++++++++++
 include/linux/sched.h           |    3 +
 include/uapi/linux/bpf.h        |   12 ++
 kernel/bpf/syscall.c            |  199 +++++++++++++++++++++++++++++++++-
 kernel/exit.c                   |    2 
 kernel/fork.c                   |    3 +
 kernel/trace/Kconfig            |   22 ++++
 kernel/trace/Makefile           |    2 
 kernel/trace/fprobes.c          |  187 ++++++++++++++++++++++++++++++++
 kernel/trace/rethook.c          |  226 +++++++++++++++++++++++++++++++++++++++
 samples/Kconfig                 |    6 +
 samples/Makefile                |    1 
 samples/fprobe/Makefile         |    3 +
 samples/fprobe/fprobe_example.c |  103 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h  |   12 ++
 20 files changed, 1043 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/rethook.c
 create mode 100644 include/linux/fprobes.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/fprobes.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
