Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD14F16A956
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgBXPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50176 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgBXPDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:20 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFo-0004s1-Lj; Mon, 24 Feb 2020 16:02:40 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 4EDAFFFB71;
        Mon, 24 Feb 2020 16:02:40 +0100 (CET)
Message-Id: <20200224140131.461979697@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:31 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V3 00/22] bpf: Make BPF and PREEMPT_RT co-exist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is the third version of the BPF/RT patch set which makes both coexist
nicely. The long explanation can be found in the cover letter of the V1
submission:

  https://lore.kernel.org/r/20200214133917.304937432@linutronix.de

V2 is here:

  https://lore.kernel.org/r/20200220204517.863202864@linutronix.de

The following changes vs. V2 have been made:

  - Rebased to bpf-next, adjusted to the lock changes in the hashmap code.

  - Split the preallocation enforcement patch for instrumentation type BPF
    programs into two pieces:

    1) Emit a one-time warning on !RT kernels when any instrumentation type
       BPF program uses run-time allocation. Emit also a corresponding
       warning in the verifier log. But allow the program to run for
       backward compatibility sake. After a grace period this should be
       enforced.

    2) On RT reject such programs because on RT the memory allocator cannot
       be called from truly atomic contexts.
       
  - Fixed the fallout from V2 as reported by Alexei and 0-day

  - Removed the redundant preempt_disable() from trace_call_bpf()

  - Removed the unused export of trace_call_bpf()

The series applies on top of:

 git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master

Selftest result:
  # Summary: 1580 PASSED, 0 SKIPPED, 0 FAILED

Thanks,

	tglx
---
 include/linux/bpf.h          |   38 ++++++++-
 include/linux/filter.h       |   37 +++++++--
 kernel/bpf/hashtab.c         |  172 ++++++++++++++++++++++++++++++-------------
 kernel/bpf/lpm_trie.c        |   12 +--
 kernel/bpf/percpu_freelist.c |   20 ++---
 kernel/bpf/stackmap.c        |   18 +++-
 kernel/bpf/syscall.c         |   27 ++----
 kernel/bpf/trampoline.c      |    9 +-
 kernel/bpf/verifier.c        |   40 +++++++---
 kernel/events/core.c         |    2 
 kernel/seccomp.c             |    4 -
 kernel/trace/bpf_trace.c     |    7 -
 lib/test_bpf.c               |    4 -
 net/bpf/test_run.c           |    8 +-
 net/core/flow_dissector.c    |    4 -
 net/core/skmsg.c             |    8 --
 net/kcm/kcmsock.c            |    4 -
 17 files changed, 274 insertions(+), 140 deletions(-)
