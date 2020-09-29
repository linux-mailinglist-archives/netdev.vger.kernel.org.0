Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6108827D948
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgI2Uxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:53:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:13112 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgI2Uxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:53:42 -0400
IronPort-SDR: THxKQITEZfkA7SjKb04iDptbhhxWN4ecEYXxfXqOL46mbfelJ1EebfVPg0x9Qj/kjboVD3wnX8
 4qWnySPe/TJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159668557"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="159668557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 13:53:41 -0700
IronPort-SDR: SMFLMoVCblW0xNvhm/R5oKHsL/c8I8rwp3j+KmzsFG/SAnZi3mn6wFFnmWa/Ab5KmCvT8uvH1p
 9xx5XZw3QrGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="493478753"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 29 Sep 2020 13:53:39 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/2] bpf, x64: drop "pop %rcx" instruction on BPF JIT epilogue
Date:   Tue, 29 Sep 2020 22:46:52 +0200
Message-Id: <20200929204653.4325-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929204653.4325-1-maciej.fijalkowski@intel.com>
References: <20200929204653.4325-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back when all of the callee-saved registers where always pushed to stack
in x64 JIT prologue, tail call counter was placed at the bottom of the
BPF program's stack frame that had a following layout:

+-------------+
|  ret addr   |
+-------------+
|     rbp     | <- rbp
+-------------+
|             |
| free space  |
| from:       |
| sub $x,%rsp |
|             |
+-------------+
|     rbx     |
+-------------+
|     r13     |
+-------------+
|     r14     |
+-------------+
|     r15     |
+-------------+
|  tail call  | <- rsp
|   counter   |
+-------------+

In order to restore the callee saved registers, epilogue needed to
explicitly toss away the tail call counter via "pop %rbx" insn, so that
%rsp would be back at the place where %r15 was stored.

Currently, the tail call counter is placed on stack *before* the callee
saved registers (brackets on rbx through r15 mean that they are now
pushed to stack only if they are used):

+-------------+
|  ret addr   |
+-------------+
|     rbp     | <- rbp
+-------------+
|             |
| free space  |
| from:       |
| sub $x,%rsp |
|             |
+-------------+
|  tail call  |
|   counter   |
+-------------+
(     rbx     )
+-------------+
(     r13     )
+-------------+
(     r14     )
+-------------+
(     r15     ) <- rsp
+-------------+

For the record, the epilogue insns consist of (assuming all of the
callee saved registers are used by program):
pop    %r15
pop    %r14
pop    %r13
pop    %rbx
pop    %rcx
leaveq
retq

"pop %rbx" for getting rid of tail call counter was not an option
anymore as it would overwrite the restored value of %rbx register, so it
was changed to use the %rcx register.

Since epilogue can start popping the callee saved registers right away
without any additional work, the "pop %rcx" could be dropped altogether
as "leave" insn will simply move the %rbp to %rsp. IOW, tail call
counter does not need the explicit handling.

Having in mind the explanation above and the actual reason for that,
let's piggy back on "leave" insn for discarding the tail call counter
from stack and remove the "pop %rcx" from epilogue.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 26f43279b78b..a263918043ce 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1441,8 +1441,6 @@ xadd:			if (is_imm8(insn->off))
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
-			if (tail_call_reachable)
-				EMIT1(0x59); /* pop rcx, get rid of tail_call_cnt */
 			EMIT1(0xC9);         /* leave */
 			EMIT1(0xC3);         /* ret */
 			break;
-- 
2.20.1

