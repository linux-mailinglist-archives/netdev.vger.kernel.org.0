Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133BD27D9EF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgI2VXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:23:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:53026 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729537AbgI2VXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:23:18 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNN5f-00077H-Pu; Tue, 29 Sep 2020 23:23:15 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 4/6] bpf, libbpf: add bpf_tail_call_static helper for bpf programs
Date:   Tue, 29 Sep 2020 23:23:04 +0200
Message-Id: <e48b3d8798d7fca0440886e156f73323b56e745e.1601414174.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601414174.git.daniel@iogearbox.net>
References: <cover.1601414174.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port of tail_call_static() helper function from Cilium's BPF code base [0]
to libbpf, so others can easily consume it as well. We've been using this
in production code for some time now. The main idea is that we guarantee
that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
JITed BPF insns with direct jumps instead of having to fall back to using
expensive retpolines. By using inline asm, we guarantee that the compiler
won't merge the call from different paths with potentially different
content of r2/r3.

We're also using Cilium's __throw_build_bug() macro (here as: __bpf_unreachable())
in different places as a neat trick to trigger compilation errors when
compiler does not remove code at compilation time. This works for the BPF
back end as it does not implement the __builtin_trap().

  [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 1106777df00b..2bdb7d6dbad2 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -53,6 +53,52 @@
 	})
 #endif
 
+/*
+ * Helper macro to throw a compilation error if __bpf_unreachable() gets
+ * built into the resulting code. This works given BPF back end does not
+ * implement __builtin_trap(). This is useful to assert that certain paths
+ * of the program code are never used and hence eliminated by the compiler.
+ *
+ * For example, consider a switch statement that covers known cases used by
+ * the program. __bpf_unreachable() can then reside in the default case. If
+ * the program gets extended such that a case is not covered in the switch
+ * statement, then it will throw a build error due to the default case not
+ * being compiled out.
+ */
+#ifndef __bpf_unreachable
+# define __bpf_unreachable()	__builtin_trap()
+#endif
+
+/*
+ * Helper function to perform a tail call with a constant/immediate map slot.
+ */
+static __always_inline void
+bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
+{
+	if (!__builtin_constant_p(slot))
+		__bpf_unreachable();
+
+	/*
+	 * Provide a hard guarantee that LLVM won't optimize setting r2 (map
+	 * pointer) and r3 (constant map index) from _different paths_ ending
+	 * up at the _same_ call insn as otherwise we won't be able to use the
+	 * jmpq/nopl retpoline-free patching by the x86-64 JIT in the kernel
+	 * given they mismatch. See also d2e4c1e6c294 ("bpf: Constant map key
+	 * tracking for prog array pokes") for details on verifier tracking.
+	 *
+	 * Note on clobber list: we need to stay in-line with BPF calling
+	 * convention, so even if we don't end up using r0, r4, r5, we need
+	 * to mark them as clobber so that LLVM doesn't end up using them
+	 * before / after the call.
+	 */
+	asm volatile("r1 = %[ctx]\n\t"
+		     "r2 = %[map]\n\t"
+		     "r3 = %[slot]\n\t"
+		     "call 12"
+		     :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
+		     : "r0", "r1", "r2", "r3", "r4", "r5");
+}
+
 /*
  * Helper structure used by eBPF C program
  * to describe BPF map attributes to libbpf loader
-- 
2.21.0

