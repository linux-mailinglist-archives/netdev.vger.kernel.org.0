Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA311C8644
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgEGJ7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 05:59:50 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9027C20643;
        Thu,  7 May 2020 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588845589;
        bh=1dH5G1leAYENAhuCpe5L02sl2FX0JniYY4i2b+iiscs=;
        h=From:To:Cc:Subject:Date:From;
        b=1aUldhiQbHoUUq98QeyZox9aJSM7fUex2qh2uKAqXjx1zIHigKYWqndTApyZ8Q6h+
         kmOaWmRVk1MiImGIY8H0404e2ryIMSTusCdfZi2zrrVtdCKI+4inXLc8iYKXrGtO//
         UKpQuhTXij4WrjkTmPbAG530abAmO1w29UVHXsHQ=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 0/3] kprobes: Support nested kprobes
Date:   Thu,  7 May 2020 18:59:42 +0900
Message-Id: <158884558272.12656.7654266361809594662.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is a series to add nested-kprobes support to x86, arm64
and arm (which I can test).

These make kprobes to accept 1-level nesting instead of incrementing
missed count.

Any kprobes hits in kprobes pre/post handler context can be nested
at once. If the other kprobes hits in the nested pre/post handler
context or in the single-stepping context, that will be still
missed.

The nest level is actually easily extended, but too many nest
level can lead the overflow of the kernel stack (for each nest,
the stack will be consumed by saving registers, handling kprobes
and pre/post handlers.) Thus, at this moment it allows only one
level nest.

This feature allows BPF or ftrace user to put a kprobe on BPF
jited code or ftrace internal code running in the kprobe context
for debugging.

We can test this feature on the kernel with
CONFIG_KPROBE_EVENTS_ON_NOTRACE=y as below.

  # cd /sys/kernel/debug/tracing
  # echo p ring_buffer_lock_reserve > kprobe_events
  # echo p vfs_read >> kprobe_events
  # echo stacktrace > events/kprobes/p_ring_buffer_lock_reserve_0/trigger
  # echo 1 > events/kprobes/enable
  # cat trace
  ...
               cat-151   [000] ...1    48.669190: p_vfs_read_0: (vfs_read+0x0/0x160)
               cat-151   [000] ...2    48.669276: p_ring_buffer_lock_reserve_0: (ring_buffer_lock_reserve+0x0/0x400)
               cat-151   [000] ...2    48.669288: <stack trace>
   => kprobe_dispatcher
   => opt_pre_handler
   => optimized_callback
   => 0xffffffffa0002331
   => ring_buffer_lock_reserve
   => kprobe_trace_func
   => kprobe_dispatcher
   => opt_pre_handler
   => optimized_callback
   => 0xffffffffa00023b0
   => vfs_read
   => load_elf_phdrs
   => load_elf_binary
   => search_binary_handler.part.0
   => __do_execve_file.isra.0
   => __x64_sys_execve
   => do_syscall_64
   => entry_SYSCALL_64_after_hwframe
  
To check unoptimized code, disable optprobe and dump the log.

  # echo 0 > /proc/sys/debug/kprobes-optimization
  # echo > trace
  # cat trace
               cat-153   [000] d..1   140.581433: p_vfs_read_0: (vfs_read+0x0/0x160)
               cat-153   [000] d..2   140.581780: p_ring_buffer_lock_reserve_0: (ring_buffer_lock_reserve+0x0/0x400)
               cat-153   [000] d..2   140.581811: <stack trace>
   => kprobe_dispatcher
   => aggr_pre_handler
   => kprobe_int3_handler
   => do_int3
   => int3
   => ring_buffer_lock_reserve
   => kprobe_trace_func
   => kprobe_dispatcher
   => aggr_pre_handler
   => kprobe_int3_handler
   => do_int3
   => int3
   => vfs_read
   => load_elf_phdrs
   => load_elf_binary
   => search_binary_handler.part.0
   => __do_execve_file.isra.0
   => __x64_sys_execve
   => do_syscall_64
   => entry_SYSCALL_64_after_hwframe

So we can see the kprobe can be nested.

Thank you,

---

Masami Hiramatsu (3):
      x86/kprobes: Support nested kprobes
      arm64: kprobes: Support nested kprobes
      arm: kprobes: Support nested kprobes


 arch/arm/include/asm/kprobes.h     |    5 ++
 arch/arm/probes/kprobes/core.c     |   79 ++++++++++++++----------------
 arch/arm/probes/kprobes/core.h     |   30 +++++++++++
 arch/arm/probes/kprobes/opt-arm.c  |    6 ++
 arch/arm64/include/asm/kprobes.h   |    5 ++
 arch/arm64/kernel/probes/kprobes.c |   75 ++++++++++++++++------------
 arch/x86/include/asm/kprobes.h     |    5 ++
 arch/x86/kernel/kprobes/common.h   |   39 ++++++++++++++-
 arch/x86/kernel/kprobes/core.c     |   96 +++++++++++++++---------------------
 arch/x86/kernel/kprobes/ftrace.c   |    6 ++
 arch/x86/kernel/kprobes/opt.c      |   13 +++--
 11 files changed, 214 insertions(+), 145 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
