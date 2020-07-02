Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8F1212546
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgGBNyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:54:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:16646 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgGBNyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:54:22 -0400
IronPort-SDR: xyFv7MAg5k0HRe/rOIlma8/gt9BaRi/0yZ6StUZYvNdrRPKT/N4uR2Q6lpytDdkpEv+QWKQGwV
 pW+rcw3a++CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126510475"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126510475"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 06:54:22 -0700
IronPort-SDR: aFwwzagThDlP56JgFU+XLgbAJi6mqg/ePUB+VnW2mHTAYoYazaa54zPjfeEBzMW2NFJ0x53xQ0
 ys6f0Wqw7W+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="482009523"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2020 06:54:20 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [RFC PATCH bpf-next 1/5] bpf, x64: use %rcx instead of %rax for tail call retpolines
Date:   Thu,  2 Jul 2020 15:49:26 +0200
Message-Id: <20200702134930.4717-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, %rax is used to store the jump target when BPF program is
emitting the retpoline instructions that are handling the indirect
tailcall.

There is a plan to use %rax for different purpose, which is storing the
tail call counter. In order to preserve this value across the tailcalls,
use %rcx instead for jump target storage in retpoline instructions.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/include/asm/nospec-branch.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e7752b4038ff..e491c3d9f227 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -314,19 +314,19 @@ static inline void mds_idle_clear_cpu_buffers(void)
  *    lfence
  *    jmp spec_trap
  *  do_rop:
- *    mov %rax,(%rsp) for x86_64
+ *    mov %rcx,(%rsp) for x86_64
  *    mov %edx,(%esp) for x86_32
  *    retq
  *
  * Without retpolines configured:
  *
- *    jmp *%rax for x86_64
+ *    jmp *%rcx for x86_64
  *    jmp *%edx for x86_32
  */
 #ifdef CONFIG_RETPOLINE
 # ifdef CONFIG_X86_64
-#  define RETPOLINE_RAX_BPF_JIT_SIZE	17
-#  define RETPOLINE_RAX_BPF_JIT()				\
+#  define RETPOLINE_RCX_BPF_JIT_SIZE	17
+#  define RETPOLINE_RCX_BPF_JIT()				\
 do {								\
 	EMIT1_off32(0xE8, 7);	 /* callq do_rop */		\
 	/* spec_trap: */					\
@@ -334,7 +334,7 @@ do {								\
 	EMIT3(0x0F, 0xAE, 0xE8); /* lfence */			\
 	EMIT2(0xEB, 0xF9);       /* jmp spec_trap */		\
 	/* do_rop: */						\
-	EMIT4(0x48, 0x89, 0x04, 0x24); /* mov %rax,(%rsp) */	\
+	EMIT4(0x48, 0x89, 0x0C, 0x24); /* mov %rcx,(%rsp) */	\
 	EMIT1(0xC3);             /* retq */			\
 } while (0)
 # else /* !CONFIG_X86_64 */
@@ -352,9 +352,9 @@ do {								\
 # endif
 #else /* !CONFIG_RETPOLINE */
 # ifdef CONFIG_X86_64
-#  define RETPOLINE_RAX_BPF_JIT_SIZE	2
-#  define RETPOLINE_RAX_BPF_JIT()				\
-	EMIT2(0xFF, 0xE0);       /* jmp *%rax */
+#  define RETPOLINE_RCX_BPF_JIT_SIZE	2
+#  define RETPOLINE_RCX_BPF_JIT()				\
+	EMIT2(0xFF, 0xE1);       /* jmp *%rcx */
 # else /* !CONFIG_X86_64 */
 #  define RETPOLINE_EDX_BPF_JIT()				\
 	EMIT2(0xFF, 0xE2)        /* jmp *%edx */
-- 
2.20.1

