Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68B04A3F52
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbiAaJgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiAaJgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:36:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C41C061714;
        Mon, 31 Jan 2022 01:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642B96131E;
        Mon, 31 Jan 2022 09:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08142C340E8;
        Mon, 31 Jan 2022 09:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643621808;
        bh=vMgDCjwqfRkV/E2kGVpMD+Erf3jfq9HqYRlJlo+kis4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TNUlBD0pk1UDcpPQZaGZ1h96kgmTo9QxdayWPNe2geVkbaok6ra37jbJ+/N51S79K
         /A4lD6sPbzO5oTbg6nh155o/FHLuatoOtqSTIAOtgw6wtGB2xy7AwhVSe5V3BhuY/z
         kaMuXjZ/LpDHRvjUAtnk9w+1ygZzLhqTiHnn9KHqLnpnC4UvQkdjutCj6C3P/FreYS
         nG73t8GIZvtdT59DDBKa35VGMOoDNyy2TYV6iAZvoBDf6AzUjHin8SEKpcbHkKdJIO
         fXY/FxUQUfdtZdxiBRoq7H98sJJmLSlyhaYJk2JuynKvzfTLtbrVNTe0gV1yZtpYHX
         YzKqhoedV7RFg==
Date:   Mon, 31 Jan 2022 18:36:42 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220131183642.aba575006314b3988110a7e5@kernel.org>
In-Reply-To: <164360522462.65877.1891020292202285106.stgit@devnote2>
References: <164360522462.65877.1891020292202285106.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, 31 Jan 2022 14:00:24 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi,
> 
> Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> ensures that exit_handler is not called after returning from the
> unregister_fprobe(), and fixes some comments and documents.
> 
> The previous version is here[1];
> 
> [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> 
> This series introduces the fprobe, the function entry/exit probe
> with multiple probe point support. This also introduces the rethook
> for hooking function return as same as the kretprobe does. This
> abstraction will help us to generalize the fgraph tracer,
> because we can just switch to it from the rethook in fprobe,
> depending on the kernel configuration.
> 
> The patch [1/10] is from Jiri's series[2].
> 
> [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> 
> And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> if user wants to share the same code (or share a same resource) on the
> fprobe and the kprobes.

If you want to work on this series, I pushed my working branch on here;

https://git.kernel.org/pub/scm/linux/kernel/git/mhiramat/linux.git/ kprobes/fprobe

Thank you,

> 
> Thank you,
> 
> ---
> 
> Jiri Olsa (1):
>       ftrace: Add ftrace_set_filter_ips function
> 
> Masami Hiramatsu (9):
>       fprobe: Add ftrace based probe APIs
>       rethook: Add a generic return hook
>       rethook: x86: Add rethook x86 implementation
>       ARM: rethook: Add rethook arm implementation
>       arm64: rethook: Add arm64 rethook implementation
>       fprobe: Add exit_handler support
>       fprobe: Add sample program for fprobe
>       fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
>       docs: fprobe: Add fprobe description to ftrace-use.rst
> 
> 
>  Documentation/trace/fprobe.rst                |  171 +++++++++++++
>  Documentation/trace/index.rst                 |    1 
>  arch/arm/Kconfig                              |    1 
>  arch/arm/include/asm/stacktrace.h             |    4 
>  arch/arm/kernel/stacktrace.c                  |    6 
>  arch/arm/probes/Makefile                      |    1 
>  arch/arm/probes/rethook.c                     |   71 +++++
>  arch/arm64/Kconfig                            |    1 
>  arch/arm64/include/asm/stacktrace.h           |    2 
>  arch/arm64/kernel/probes/Makefile             |    1 
>  arch/arm64/kernel/probes/rethook.c            |   25 ++
>  arch/arm64/kernel/probes/rethook_trampoline.S |   87 ++++++
>  arch/arm64/kernel/stacktrace.c                |    7 -
>  arch/x86/Kconfig                              |    1 
>  arch/x86/include/asm/unwind.h                 |    8 +
>  arch/x86/kernel/Makefile                      |    1 
>  arch/x86/kernel/kprobes/common.h              |    1 
>  arch/x86/kernel/rethook.c                     |  115 ++++++++
>  include/linux/fprobe.h                        |   97 +++++++
>  include/linux/ftrace.h                        |    3 
>  include/linux/kprobes.h                       |    3 
>  include/linux/rethook.h                       |  100 +++++++
>  include/linux/sched.h                         |    3 
>  kernel/exit.c                                 |    2 
>  kernel/fork.c                                 |    3 
>  kernel/trace/Kconfig                          |   26 ++
>  kernel/trace/Makefile                         |    2 
>  kernel/trace/fprobe.c                         |  341 +++++++++++++++++++++++++
>  kernel/trace/ftrace.c                         |   58 ++++
>  kernel/trace/rethook.c                        |  313 +++++++++++++++++++++++
>  samples/Kconfig                               |    7 +
>  samples/Makefile                              |    1 
>  samples/fprobe/Makefile                       |    3 
>  samples/fprobe/fprobe_example.c               |  120 +++++++++
>  34 files changed, 1572 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/trace/fprobe.rst
>  create mode 100644 arch/arm/probes/rethook.c
>  create mode 100644 arch/arm64/kernel/probes/rethook.c
>  create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S
>  create mode 100644 arch/x86/kernel/rethook.c
>  create mode 100644 include/linux/fprobe.h
>  create mode 100644 include/linux/rethook.h
>  create mode 100644 kernel/trace/fprobe.c
>  create mode 100644 kernel/trace/rethook.c
>  create mode 100644 samples/fprobe/Makefile
>  create mode 100644 samples/fprobe/fprobe_example.c
> 
> --
> Masami Hiramatsu (Linaro) <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
