Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94247221884
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGOXlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:41:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:52501 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgGOXlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:41:37 -0400
IronPort-SDR: 7wzktafRfyjtvhIpfTpr52lYvaESRrQEHhXW+VLcZQA7xILw9Su6HSC2+96rkf8UnWjWTwVsJw
 aCeBop94TKMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210823652"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210823652"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 16:41:35 -0700
IronPort-SDR: h0P+YvFbVHhppQQpMvRX1nk+cITnHr6AmqvOGJdjYHn9Wvi+i6RmndSiGQejuyUqYelm45YcuG
 e2Q5jp3QJkBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="390935565"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2020 16:41:33 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/5] bpf: tailcalls in BPF subprograms
Date:   Thu, 16 Jul 2020 01:36:29 +0200
Message-Id: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC->v1:
- rename poke->ip/poke->ip_aux pair to
  poke->tailcall_target/poke->tailcall_bypass (Alexei)
- get rid of x86-specific code in prog_array_map_poke_run (Alexei)
- use synchronize_rcu in prog_array_map_poke_run so that other CPUs in
  the middle of execution will finish running the program and will not
  stumble upon the incorrect state (Alexei)
- update performance reports
- drop the RFC-ish narration from descriptions
- rebase


Hello,

today bpf2bpf calls and tailcalls exclude each other. This set makes them
to work together.

To give you an overview how this work started, previously I posted RFC
that was targetted at getting rid of push/pop instructions for callee
saved registers in x86-64 JIT that are not used by the BPF program.
Alexei saw a potential that that work could be lifted a bit and
tailcalls could work with BPF subprograms. More on that in [1], [2].

For previous discussions on RFC version, see [3].

In [1], Alexei says:

"The prologue will look like:
nop5
xor eax,eax  // two new bytes if bpf_tail_call() is used in this
function
push rbp
mov rbp, rsp
sub rsp, rounded_stack_depth
push rax // zero init tail_call counter
variable number of push rbx,r13,r14,r15

Then bpf_tail_call will pop variable number rbx,..
and final 'pop rax'
Then 'add rsp, size_of_current_stack_frame'
jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov
rbp, rsp'

This way new function will set its own stack size and will init tail
call counter with whatever value the parent had.

If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
Instead it would need to have 'nop2' in there."

So basically I gave a shot at that suggestion. Patch 4 has a description
of implementation.

Quick overview of patches:
Patch 1 changes BPF retpoline to use %rcx instead of %rax to store
address of BPF tailcall target program
Patch 2 relaxes verifier's restrictions about tailcalls being used with
BPF subprograms
Patch 3 propagates poke descriptors from main program to each subprogram
Patch 4 is the main dish in this set. It implements new prologue layout
that was suggested by Alexei and reworks tailcall handling.
Patch 5 is the new selftest that proves tailcalls can be used from
within BPF subprogram.

-------------------------------------------------------------------
prog_array_map_poke_run changes:

Before the tailcall and with the new prologue layout, stack need to be
unwinded and callee saved registers need to be popped. Instructions
responsible for that are generated, but they should not be executed if
target program is not present. To address that, new poke target
'tailcall_bypass' is introduced to poke descriptor that will be used for
skipping these instructions. This means there are two poke targets for
handling direct tailcalls. Simplified flow can be presented as three
sections:

1. skip call or nop (poke->tailcall_bypass)
2. stack unwind
3. call tail or nop (poke->tailcall_target)

It would be possible under specific circumstances that one of CPU might
be in point 2 and point 3 is not yet updated (nop), which would lead to
problems mentioned in patch 4 commit message, IOW unwind section should
not be executed if there is no target program.

We can define the following state matrix for that (courtesy of Bjorn):
A nop, unwind, nop
B nop, unwind, tail
C skip, unwind, nop
D skip, unwind, tail

A is forbidden (lead to incorrectness). The state transitions between
tailcall install/update/remove will work as follows:

First install tail call f: C->D->B(f)
 * poke the tailcall, after that get rid of the skip
Update tail call f to f': B(f)->B(f')
 * poke the tailcall (poke->tailcall_target) and do NOT touch the
   poke->tailcall_bypass
Remove tail call: B(f')->C(f')
 * poke->tailcall_bypass is poked back to jump, then we wait the RCU
   grace period so that other programs will finish its execution and
   after that we are safe to remove the poke->tailcall_target
Install new tail call (f''): C(f')->D(f'')->B(f'').
 * same as first step

This way CPU can never be exposed to "unwind, tail" state.

-------------------------------------------------------------------
Performance impact:

All of this work, as stated in [2], started as a way to speed up AF-XDP
by dropping the push/pop of unused callee saved registers in prologue
and epilogue. Impact is positive, 15% of performance gain.

However, it is obvious that it will have a negative impact on BPF
programs that utilize tailcalls, but we think its volume is acceptable
for the feature that this set contains.

Below are te numbers from 'perf stat' for two scenarios.
First scenario is the output of command:

$ sudo perf stat -ddd -r 1024 ./test_progs -t tailcalls

tailcalls kselftest was modified in a following way:
- only taicall1 subtest is enabled
- each of the bpf_prog_test_run() calls got set 'repeat' argument to
  1000000

Numbers without this set:

 Performance counter stats for './test_progs -t tailcalls' (1024 runs):

            261.68 msec task-clock                #    0.998 CPUs utilized            ( +-  0.12% )
                 5      context-switches          #    0.017 K/sec                    ( +-  0.54% )
                 0      cpu-migrations            #    0.000 K/sec                    ( +- 23.37% )
               113      page-faults               #    0.433 K/sec                    ( +-  0.03% )
       877,156,850      cycles                    #    3.352 GHz                      ( +-  0.11% )  (30.31%)
     1,379,322,515      instructions              #    1.57  insn per cycle           ( +-  0.02% )  (38.17%)
       218,869,567      branches                  #  836.395 M/sec                    ( +-  0.01% )  (38.46%)
        11,954,183      branch-misses             #    5.46% of all branches          ( +-  0.01% )  (38.74%)
       283,350,418      L1-dcache-loads           # 1082.805 M/sec                    ( +-  0.01% )  (39.00%)
           156,323      L1-dcache-load-misses     #    0.06% of all L1-dcache hits    ( +-  0.74% )  (39.05%)
            37,309      LLC-loads                 #    0.143 M/sec                    ( +-  1.02% )  (31.08%)
            15,263      LLC-load-misses           #   40.91% of all LL-cache hits     ( +-  0.90% )  (30.95%)
   <not supported>      L1-icache-loads
           130,427      L1-icache-load-misses                                         ( +-  0.45% )  (30.80%)
       285,369,370      dTLB-loads                # 1090.520 M/sec                    ( +-  0.01% )  (30.64%)
             1,154      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  1.26% )  (30.46%)
             2,015      iTLB-loads                #    0.008 M/sec                    ( +-  1.12% )  (30.31%)
               551      iTLB-load-misses          #   27.34% of all iTLB cache hits   ( +-  1.29% )  (30.20%)
   <not supported>      L1-dcache-prefetches
   <not supported>      L1-dcache-prefetch-misses

          0.262276 +- 0.000316 seconds time elapsed  ( +-  0.12% )

With:

 Performance counter stats for './test_progs -t tailcalls' (1024 runs):

            362.37 msec task-clock                #    0.671 CPUs utilized            ( +-  0.11% )
                28      context-switches          #    0.077 K/sec                    ( +-  0.15% )
                 0      cpu-migrations            #    0.001 K/sec                    ( +-  4.46% )
               113      page-faults               #    0.313 K/sec                    ( +-  0.03% )
       895,804,416      cycles                    #    2.472 GHz                      ( +-  0.08% )  (30.50%)
     1,339,401,398      instructions              #    1.50  insn per cycle           ( +-  0.04% )  (38.29%)
       302,718,849      branches                  #  835.385 M/sec                    ( +-  0.04% )  (38.39%)
        11,962,089      branch-misses             #    3.95% of all branches          ( +-  0.05% )  (38.56%)
       248,044,443      L1-dcache-loads           #  684.505 M/sec                    ( +-  0.03% )  (38.70%)
           239,882      L1-dcache-load-misses     #    0.10% of all L1-dcache hits    ( +-  0.49% )  (38.69%)
            76,904      LLC-loads                 #    0.212 M/sec                    ( +-  0.96% )  (30.88%)
            23,472      LLC-load-misses           #   30.52% of all LL-cache hits     ( +-  0.98% )  (30.85%)
   <not supported>      L1-icache-loads
           193,803      L1-icache-load-misses                                         ( +-  0.53% )  (30.81%)
       249,775,412      dTLB-loads                #  689.282 M/sec                    ( +-  0.04% )  (30.81%)
             2,176      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  1.53% )  (30.73%)
             2,914      iTLB-loads                #    0.008 M/sec                    ( +-  1.23% )  (30.59%)
               978      iTLB-load-misses          #   33.57% of all iTLB cache hits   ( +-  1.29% )  (30.48%)
   <not supported>      L1-dcache-prefetches
   <not supported>      L1-dcache-prefetch-misses

          0.540236 +- 0.000454 seconds time elapsed  ( +-  0.08% )

Second conducted measurement was on BPF kselftest flow_dissector that is
using the progs/bpf_flow.c with 'repeat' argument on
bpf_prog_test_run_xattr set also to 1000000.

Without:

Performance counter stats for './test_progs -t flow_dissector' (1024 runs):

          1,355.18 msec task-clock                #    0.989 CPUs utilized            ( +-  0.11% )
                28      context-switches          #    0.021 K/sec                    ( +-  0.49% )
                 0      cpu-migrations            #    0.000 K/sec                    ( +-  7.86% )
               125      page-faults               #    0.093 K/sec                    ( +-  0.03% )
     4,609,228,676      cycles                    #    3.401 GHz                      ( +-  0.03% )  (30.70%)
     6,735,946,489      instructions              #    1.46  insn per cycle           ( +-  0.01% )  (38.42%)
     1,130,187,926      branches                  #  833.979 M/sec                    ( +-  0.01% )  (38.47%)
        29,150,986      branch-misses             #    2.58% of all branches          ( +-  0.01% )  (38.51%)
     1,737,548,851      L1-dcache-loads           # 1282.158 M/sec                    ( +-  0.01% )  (38.56%)
           659,851      L1-dcache-load-misses     #    0.04% of all L1-dcache hits    ( +-  0.78% )  (38.56%)
            71,196      LLC-loads                 #    0.053 M/sec                    ( +-  0.97% )  (30.81%)
            22,218      LLC-load-misses           #   31.21% of all LL-cache hits     ( +-  0.83% )  (30.79%)
   <not supported>      L1-icache-loads
           770,586      L1-icache-load-misses                                         ( +-  0.67% )  (30.77%)
     1,742,104,224      dTLB-loads                # 1285.520 M/sec                    ( +-  0.01% )  (30.74%)
             7,060      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  2.08% )  (30.72%)
             4,282      iTLB-loads                #    0.003 M/sec                    ( +- 16.98% )  (30.70%)
             1,261      iTLB-load-misses          #   29.46% of all iTLB cache hits   ( +-  7.14% )  (30.68%)
   <not supported>      L1-dcache-prefetches
   <not supported>      L1-dcache-prefetch-misses

           1.37087 +- 0.00145 seconds time elapsed  ( +-  0.11% )

With:

 Performance counter stats for './test_progs -t flow_dissector' (1024 runs):

          1,385.56 msec task-clock                #    0.989 CPUs utilized            ( +-  0.06% )
                28      context-switches          #    0.020 K/sec                    ( +-  0.48% )
                 0      cpu-migrations            #    0.000 K/sec                    ( +-  7.20% )
               125      page-faults               #    0.091 K/sec                    ( +-  0.03% )
     4,642,599,630      cycles                    #    3.351 GHz                      ( +-  0.03% )  (30.69%)
     6,901,261,616      instructions              #    1.49  insn per cycle           ( +-  0.01% )  (38.41%)
     1,130,623,950      branches                  #  816.006 M/sec                    ( +-  0.01% )  (38.45%)
        29,161,215      branch-misses             #    2.58% of all branches          ( +-  0.01% )  (38.50%)
     1,796,850,740      L1-dcache-loads           # 1296.842 M/sec                    ( +-  0.01% )  (38.55%)
           673,908      L1-dcache-load-misses     #    0.04% of all L1-dcache hits    ( +-  0.89% )  (38.56%)
            70,394      LLC-loads                 #    0.051 M/sec                    ( +-  1.08% )  (30.82%)
            24,575      LLC-load-misses           #   34.91% of all LL-cache hits     ( +-  0.66% )  (30.80%)
   <not supported>      L1-icache-loads
           729,421      L1-icache-load-misses                                         ( +-  0.85% )  (30.77%)
     1,800,871,042      dTLB-loads                # 1299.743 M/sec                    ( +-  0.01% )  (30.75%)
             6,133      dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  2.55% )  (30.73%)
             1,998      iTLB-loads                #    0.001 M/sec                    ( +-  9.36% )  (30.70%)
             1,152      iTLB-load-misses          #   57.66% of all iTLB cache hits   ( +-  3.02% )  (30.68%)
   <not supported>      L1-dcache-prefetches
   <not supported>      L1-dcache-prefetch-misses

          1.400577 +- 0.000780 seconds time elapsed  ( +-  0.06% )


Interesting fact is that I observed the huge iTLB-load-misses counts on
clean kernel as well:

flow_dissector test:
             2,613      iTLB-loads                #    0.002 M/sec ( +- 21.90% )  (30.70%)
            16,483      iTLB-load-misses          #  630.78% of all iTLB cache hits   ( +- 79.63% )  (30.68%)
tailcalls test:
             1,996      iTLB-loads                #    0.008 M/sec ( +-  1.08% )  (30.33%)
             7,272      iTLB-load-misses          #  364.24% of all iTLB cache hits   ( +- 92.01% )  (30.21%)

So probably Alexei's suspicion about get_random_int() doing strange was
right.

-------------------------------------------------------------------

Thank you,
Maciej

[1]: https://lore.kernel.org/bpf/20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com/
[2]: https://lore.kernel.org/bpf/20200511143912.34086-1-maciej.fijalkowski@intel.com/
[3]: https://lore.kernel.org/bpf/20200702134930.4717-1-maciej.fijalkowski@intel.com/


Maciej Fijalkowski (5):
  bpf, x64: use %rcx instead of %rax for tail call retpolines
  bpf: allow for tailcalls in BPF subprograms
  bpf: propagate poke descriptors to subprograms
  bpf, x64: rework pro/epilogue and tailcall handling in JIT
  selftests: bpf: add dummy prog for bpf2bpf with tailcall

 arch/x86/include/asm/nospec-branch.h          |  16 +-
 arch/x86/net/bpf_jit_comp.c                   | 241 +++++++++++++-----
 include/linux/bpf.h                           |   8 +-
 kernel/bpf/arraymap.c                         |  61 ++++-
 kernel/bpf/core.c                             |   3 +-
 kernel/bpf/verifier.c                         |  14 +-
 .../selftests/bpf/prog_tests/tailcalls.c      |  85 ++++++
 tools/testing/selftests/bpf/progs/tailcall6.c |  38 +++
 8 files changed, 379 insertions(+), 87 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall6.c

-- 
2.20.1

