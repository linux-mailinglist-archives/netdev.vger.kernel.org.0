Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D98315E612
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404319AbgBNQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:45:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55551 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392969AbgBNQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:33 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diB-0003Hz-Sn; Fri, 14 Feb 2020 17:21:03 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 8ADA81004EC;
        Fri, 14 Feb 2020 17:21:03 +0100 (CET)
Message-Id: <20200214133917.304937432@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:17 +0100
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
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 00/19] bpf: Make BPF and PREEMPT_RT co-exist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is a follow up to the initial patch series which David posted a while
ago:

 https://lore.kernel.org/bpf/20191207.160357.828344895192682546.davem@davemloft.net/

which was (while non-functional on RT) a good starting point for further
investigations.

PREEMPT_RT aims to make the kernel fully preemptible except for a few low
level operations which have to be unpreemptible, like scheduler, low level
entry/exit code, low level interrupt handling, locking internals etc.

This is achieved by the following main transformations (there are some
more minor ones, but they don't matter in this context):

   1) All interrupts, which are not explicitely marked IRQF_NO_THREAD, are
      forced into threaded interrupt handlers. This applies to almost all
      device interrupt handlers.

   2) hrtimers which are not explicitely marked to expire in hard interrupt
      context are expired in soft interrupt context.

   3) Soft interrupts are also forced into thread context. They run either
      in the context of a threaded interrupt handler (similar to the !RT
      mode of running on return from interrupt), in ksoftirqd or in a
      thread context which raised a soft interrupt (same as in !RT).

      Soft interrupts (BH) are serialized per CPU so the usual bottom half
      protections still work.

   4) spinlocks and rwlocks are substituted with 'sleeping spin/rwlocks'.
      The internal representation is a priority inheritance aware rtmutex
      which has glue code attached to preserve the spin/rwlock semantics
      vs. task state. They neither disable preemption nor interrupts, which
      is fine as the interrupt handler they want to be protected against is
      forced into thread context.

      The true hard interrupt handlers are not affecting these sections as
      they are completely independent.

      The code pathes which need to be atomic are using raw_spinlocks which
      disable preemption (and/or interrupts).

      On a non RT kernel spinlocks are mapped to raw_spinlocks so everything
      works as usual.

As a consequence allocation of memory is not possible from truly atomic
contexts on RT, even with GFP_ATOMIC set. This is required because the slab
allocator can run into a situation even with GPF_ATOMIC where it needs to
call into the page allocator, which in turn takes regular spinlocks. As the
RT substitution of regular spinlocks might sleep, it's obvious that memory
allocations from truly atomic contexts on RT are not permitted. The page
allocator locks cannot be converted to raw locks as the length of the
resulting preempt/interrupt disabled sections are way above the tolerance
level of demanding realtime applications.

So this leads to a conflict with the current BPF implementation. BPF
disables preemption around:

  1) The invocation of BPF programs. This is required to guarantee
     that the program runs to completion on one CPU

  2) The invocation of map operations from sys_bpf(). This is required
     to protect the operation against BPF programs which access the
     same map from perf, kprobes or tracing context because the syscall
     operation has to lock the hashtab bucket lock.

     If the perf NMI, kprobe or tracepoint happens inside the bucket lock
     held region and the BPF program needs to access the same bucket then
     the system would deadlock.

     The mechanism used for this is to increment the per CPU recursion
     protection which prevents such programs to be executed. The same per
     CPU variable is used to prevent recursion of the programs themself,
     which might happen when e.g. a kprobe attached BPF program triggers
     another kprobe attached BPF program.

In principle this works on RT as well as long as the BPF programs use
preallocated maps, which is required for trace type programs to prevent
deadlocks of all sorts. Other BPF programs which run in softirq context,
e.g. packet filtering, or in thread context, e.g. syscall auditing have no
requirement for preallocated maps. They can allocate memory when required.

But as explained above on RT memory allocation from truly atomic context is
not permitted, which required a few teaks to the BPF code.

The initial misunderstanding on my side was that the preempt disable around
the invocations of BPF programs is not only required to prevent migration
to a different CPU (in case the program is invoked from preemptible
context) but is also required to prevent reentrancy from a preempting
task. In hindsight I should have figured out myself that this is not the
case because the same program can run concurrently on a different CPU or
from a different context (e.g. interrupt). Alexei thankfully enlightened me
recently over a beer that the real intent here is to guarantee that the
program runs to completion on the same CPU where it started. The same is
true for the syscall side as this just has to guarantee the per CPU
recursion protection.

This part of the problem is trivial. RT provides a true migrate_disable()
mechanism which does not disable preemption. So the preempt_disable /
enable() pairs can be replaced with migrate_disable / enable() pairs.
migrate_disable / enable() maps to preempt_disable / enable() on a
not-RT kernel, so there is no functional change when RT is disabled.

But there is another issue which is not as straight forward to solve:

The map operations which deal with elements in hashtab buckets (or other
map mechanisms) have spinlocks to protect them against concurrent access
from other CPUs. These spinlocks are raw_spinlocks, so they disable
preemption and interrupts (_irqsave()). Not a problem per se, but some of
these code pathes invoke memory allocations with a bucket lock held. This
obviously conflicts with the RT semantics.

The easy way out would be to convert these locks to regular spinlocks which
can be substituted by RT. Works like a charm for both RT and !RT for BPF
programs which run in thread context (includes soft interrupt and device
interrupt handler context on RT).

But there are also the BPF programs which run in truly atomic context even
on a RT kernel, i.e. tracing types (perf, perf NMI, kprobes and trace).

For obvious reasons these context cannot take regular spinlocks on RT
because RT substitutes them with sleeping spinlocks. might_sleep() splats
from NMI context are not really desired and on lock contention the
scheduler explodes in colourful ways. Same problem for kprobes and
tracepoints. So these program types need a raw spinlock which brings us
back to square one.

But, there is an important detail to the rescue. The trace type programs
require preallocated maps to prevent deadlocks of all sorts in the memory
allocator. Preallocated maps never call into the memory allocator or other
code pathes which might sleep on a RT kernel. The allocation type is known
when the program and the map is initialized.

This allows to differentiate between lock types for preallocated and
run-time allocated maps. While not pretty, the proposed solution is to have
a lock union in the bucket:

	union {
		raw_spinlock_t	raw_lock;
		spinlock_t	lock;
	};

and have init/lock/unlock helpers which handle the lock type depending on
the allocation mechanism, i.e. for preallocated maps it uses the raw lock
and for dynamic allocations it uses the regular spinlock. The locks in the
percpu_freelist need to stay raw as well as they nest into the bucket lock
held section, which works for both the raw and the regular spinlock
variant.

I'm not proud of that, but I really couldn't come up with anything better
aside of completely splitting the code pathes which would be even worse due
to the resulting code duplication.

The locks in the LPM trie map needs to become a regular spinlock as well as
trie map is based on dynamic allocation, but again not a problem as this
map cannot be used for the critical types anyway.

I kept the LRU and the stack map locks raw for now as they do not use
dynamic allocations, but I haven't done any testing on latency impact
yet. The stack map critical sections are truly short, so they should not
matter at all, but the LRU ones could. That can be revisited once we have
numbers. I assume that LRU is not the right choice for the trace type
programs anyway, but who knows.

The last and trivial to solve (Dave solved that already) issue is the non
owner release of mmap sem, which is forbidden on RT as well. So this just
forces the IP fallback path.

On a non RT kernel this does not change anything. The compiler optimizes
the lock magic out and everything maps to the state before these changes.

This survives the selftests and a bunch of different invocations of
bpftrace on mainline and on a backport to 5.4-rt.

But of course I surely have missed some details here and there, so please
have a close look at this.

The diffstat of hashtab.c is so large because I sat down and documented the
above write up in condensed form in a comment on top of the file as I
wanted to spare others the dubious experience of having to reverse engineer
the inner workings of BPF.

Thanks,

	tglx

8<----------------
 include/linux/bpf.h          |    8 +-
 include/linux/filter.h       |   33 ++++++--
 include/linux/kernel.h       |    7 +
 include/linux/preempt.h      |   30 +++++++
 kernel/bpf/hashtab.c         |  164 ++++++++++++++++++++++++++++++++-----------
 kernel/bpf/lpm_trie.c        |   12 +--
 kernel/bpf/percpu_freelist.c |   20 ++---
 kernel/bpf/stackmap.c        |   18 +++-
 kernel/bpf/syscall.c         |   16 ++--
 kernel/bpf/trampoline.c      |    9 +-
 kernel/events/core.c         |    2 
 kernel/seccomp.c             |    4 -
 kernel/trace/bpf_trace.c     |    6 -
 lib/test_bpf.c               |    4 -
 net/bpf/test_run.c           |    8 +-
 net/core/flow_dissector.c    |    4 -
 net/core/skmsg.c             |    8 --
 net/kcm/kcmsock.c            |    4 -
 18 files changed, 248 insertions(+), 109 deletions(-)





