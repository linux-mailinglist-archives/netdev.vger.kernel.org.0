Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E43166956
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgBTU6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44157 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729178AbgBTU4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:39 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4sra-0007T1-Ix; Thu, 20 Feb 2020 21:56:02 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id DFF49104085;
        Thu, 20 Feb 2020 21:56:01 +0100 (CET)
Message-Id: <20200220204517.863202864@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:17 +0100
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
Subject: [patch V2 00/20] bpf: Make BPF and PREEMPT_RT co-exist
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is the second version of the BPF/RT patch set which makes both coexist
nicely. The long explanation can be found in the cover letter of the V1
submission:

  https://lore.kernel.org/r/20200214133917.304937432@linutronix.de

The following changes vs. V1 have been made:

  - New patch to enforce preallocation for all instrumentation type
    programs

  - New patches which make the recursion protection safe against preemption
    on RT (Mathieu)

  - New patch which removes the unnecessary recursion protection around
    the rcu_free() invocation

  - Converted macro to inline (Mathieu)

  - Added explanation about the seccomp loop to the changelog (Vinicius)

  - Fixed the explicitely typos (Jakub)

  - Dropped the migrate* stubs patches and merged them into the tip
    tree. See below.

The series applies on top of:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-for-bpf-2020-02-20

This tag contains only the two migrate stub commits on top of 5.6-rc2 and
can be pulled into BPF. The commits are immutable and will be carried also
in tip so further changes in this area can be applied.

Thanks,

	tglx

---
 include/linux/bpf.h          |   38 ++++++++-
 include/linux/filter.h       |   33 ++++++--
 kernel/bpf/hashtab.c         |  172 ++++++++++++++++++++++++++++++-------------
 kernel/bpf/lpm_trie.c        |   12 +--
 kernel/bpf/percpu_freelist.c |   20 ++---
 kernel/bpf/stackmap.c        |   18 +++-
 kernel/bpf/syscall.c         |   27 ++----
 kernel/bpf/trampoline.c      |    9 +-
 kernel/bpf/verifier.c        |   18 ++--
 kernel/events/core.c         |    2 
 kernel/seccomp.c             |    4 -
 kernel/trace/bpf_trace.c     |    6 -
 lib/test_bpf.c               |    4 -
 net/bpf/test_run.c           |    8 +-
 net/core/flow_dissector.c    |    4 -
 net/core/skmsg.c             |    8 --
 net/kcm/kcmsock.c            |    4 -
 17 files changed, 252 insertions(+), 135 deletions(-)
