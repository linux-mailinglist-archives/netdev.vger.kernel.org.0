Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD61CDD7A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgEKOm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:42:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:53756 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgEKOm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 10:42:28 -0400
IronPort-SDR: cdzjbyxeLZmAgVPXN++rJzEfRjbcjD3ZxT4wRyEgxW+V/3iWGY4rd902tWe9THsJrt0cmYeLby
 H/Pena8GtllQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 07:42:27 -0700
IronPort-SDR: 3/4R6tWk5GcF1OR5bVVPayVrloBqW5lavl44TAXDnrjCmZJNuRmG3ZNHEzW2UyNBT7+2n5oBI1
 tNu0UI5bUVkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="296964606"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 11 May 2020 07:42:25 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [RFC PATCH bpf-next 0/1] bpf, x64: optimize JIT prologue/epilogue generation
Date:   Mon, 11 May 2020 16:39:11 +0200
Message-Id: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Today, BPF x86-64 JIT is preserving all of the callee-saved registers
for each BPF program being JITed, even when none of the R6-R9 registers
are used by the BPF program. Furthermore the tail call counter is always
pushed/popped to/from the stack even when there is no tail call usage in
BPF program being JITed. Optimization can be introduced that would
detect the usage of R6-R9 and based on that push/pop to/from the stack
only what is needed. Same goes for tail call counter.

Results look promising for such instruction reduction. Below are the
numbers for xdp1 sample on FVL 40G NIC receiving traffic from pktgen:

* With optimization: 22.3 Mpps
* Without:           19.0 mpps

So it's around 15% of performance improvement. Note that xdp1 is not
using any of callee saved registers, nor the tail call, hence such
speed-up.

There is one detail that needs to be handled though.

Currently, x86-64 JIT tail call implementation is skipping the prologue
of target BPF program that has constant size. With the mentioned
optimization implemented, each particular BPF program that might be
inserted onto the prog array map and therefore be the target of tail
call, could have various prologue size.

Let's have some pseudo-code example:

func1:
pro
code
epi

func2:
pro
code'
epi

func3:
pro
code''
epi

Today, pro and epi are always the same (9/7) instructions. So a tail
call from func1 to func2 is just a:

jump func2 + sizeof pro in bytes (PROLOGUE_SIZE)

With the optimization:

func1:
pro
code
epi

func2:
pro'
code'
epi'

func3:
pro''
code''
epi''

For making the tail calls up and running with the mentioned optimization
in place, x86-64 JIT should emit the pop registers instructions
that were pushed on prologue before the actual jump. Jump offset should
skip the instructions that are handling rbp/rsp, not the whole prologue.

A tail call within func1 would then need to be:
epi -> pop what pro pushed, but no leave/ret instructions
jump func2 + 16 // first push insn of pro'; if no push, then this would
                // a direct jump to code'

Magic value of 16 comes from count of bytes that represent instructions
that are skipped:
0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
55                      push   %rbp
48 89 e5                mov    %rsp,%rbp
48 81 ec 08 00 00 00    sub    $0x8,%rsp

which would in many cases add *more* instructions for tailcalls. If none
of callee-saved registers are used, then there would be no overhead with
such optimization in place.

I'm not sure how to measure properly the impact on the BPF programs that
are utilizing tail calls. Any suggestions?

Daniel, Alexei, what is your view on this?

For implementation details, see commit message of included patch.

Thank you,
Maciej


Maciej Fijalkowski (1):
  bpf, x64: optimize JIT prologue/epilogue generation

 arch/x86/net/bpf_jit_comp.c | 190 ++++++++++++++++++++++++++++--------
 1 file changed, 148 insertions(+), 42 deletions(-)

-- 
2.20.1

