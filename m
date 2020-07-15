Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C27221886
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGOXll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:41:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:52501 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgGOXll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:41:41 -0400
IronPort-SDR: o6rDFv9xQw9pQV4dVLxMm38kkeO659jqIJNSRaOPTe9dOlhIiCrrDrwK/1ZIXrP684CK7EszC4
 0t1JyJDi77AQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210823662"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210823662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 16:41:40 -0700
IronPort-SDR: DZiKgIF1zsDDThR+ngJ9CKcOqgO1KH0RfW71YSewmRl9JafTA8FvTPL46SY6ecm9nIyjFjazMn
 W8j3BLezwrZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="390935576"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2020 16:41:39 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/5] bpf, x64: use %rcx instead of %rax for tail call retpolines
Date:   Thu, 16 Jul 2020 01:36:30 +0200
Message-Id: <20200715233634.3868-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
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

