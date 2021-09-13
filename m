Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D54D408329
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbhIMDcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 23:32:13 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46771 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238149AbhIMDcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 23:32:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0Uo74YxF_1631503852;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Uo74YxF_1631503852)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 11:30:53 +0800
Subject: [PATCH] perf: fix panic by disable ftrace on fault.c
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:X86 MM" <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
Message-ID: <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 11:30:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with ftrace function enabled, we observed panic
as below:

  traps: PANIC: double fault, error_code: 0x0
  [snip]
  RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
  [snip]
  Call Trace:
   <NMI>
   perf_trace_buf_alloc+0x26/0xd0
   perf_ftrace_function_call+0x18f/0x2e0
   kernelmode_fixup_or_oops+0x5/0x120
   __bad_area_nosemaphore+0x1b8/0x280
   do_user_addr_fault+0x410/0x920
   exc_page_fault+0x92/0x300
   asm_exc_page_fault+0x1e/0x30
  RIP: 0010:__get_user_nocheck_8+0x6/0x13
   perf_callchain_user+0x266/0x2f0
   get_perf_callchain+0x194/0x210
   perf_callchain+0xa3/0xc0
   perf_prepare_sample+0xa5/0xa60
   perf_event_output_forward+0x7b/0x1b0
   __perf_event_overflow+0x67/0x120
   perf_swevent_overflow+0xcb/0x110
   perf_swevent_event+0xb0/0xf0
   perf_tp_event+0x292/0x410
   perf_trace_run_bpf_submit+0x87/0xc0
   perf_trace_lock_acquire+0x12b/0x170
   lock_acquire+0x1bf/0x2e0
   perf_output_begin+0x70/0x4b0
   perf_log_throttle+0xe2/0x1a0
   perf_event_nmi_handler+0x30/0x50
   nmi_handle+0xba/0x2a0
   default_do_nmi+0x45/0xf0
   exc_nmi+0x155/0x170
   end_repeat_nmi+0x16/0x55

According to the trace we know the story is like this, the NMI
triggered perf IRQ throttling and call perf_log_throttle(),
which triggered the swevent overflow, and the overflow process
do perf_callchain_user() which triggered a user PF, and the PF
process triggered perf ftrace which finally lead into a suspected
stack overflow.

This patch disable ftrace on fault.c, which help to avoid the panic.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 arch/x86/mm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5864219..1dbdca5 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,5 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Kernel does not boot with instrumentation of tlb.c and mem_encrypt*.c
+
+# Disable ftrace to avoid stack overflow.
+CFLAGS_REMOVE_fault.o = $(CC_FLAGS_FTRACE)
+
 KCOV_INSTRUMENT_tlb.o			:= n
 KCOV_INSTRUMENT_mem_encrypt.o		:= n
 KCOV_INSTRUMENT_mem_encrypt_identity.o	:= n
-- 
1.8.3.1

