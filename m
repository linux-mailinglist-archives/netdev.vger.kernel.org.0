Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C007427786F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgIXSVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:21:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:39336 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgIXSVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:21:39 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLVs9-00040S-L2; Thu, 24 Sep 2020 20:21:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper for bpf programs
Date:   Thu, 24 Sep 2020 20:21:25 +0200
Message-Id: <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1600967205.git.daniel@iogearbox.net>
References: <cover.1600967205.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
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

We're also using __throw_build_bug() macro in different places as a neat
trick to trigger compilation errors when compiler does not remove code at
compilation time. This works for the BPF backend as it does not implement
the __builtin_trap().

  [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 1106777df00b..18b75a4c82e6 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -53,6 +53,38 @@
 	})
 #endif
 
+/*
+ * Misc useful helper macros
+ */
+#ifndef __throw_build_bug
+# define __throw_build_bug()	__builtin_trap()
+#endif
+
+static __always_inline void
+bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
+{
+	if (!__builtin_constant_p(slot))
+		__throw_build_bug();
+
+	/*
+	 * Don't gamble, but _guarantee_ that LLVM won't optimize setting
+	 * r2 and r3 from different paths ending up at the same call insn as
+	 * otherwise we won't be able to use the jmpq/nopl retpoline-free
+	 * patching by the x86-64 JIT in the kernel.
+	 *
+	 * Note on clobber list: we need to stay in-line with BPF calling
+	 * convention, so even if we don't end up using r0, r4, r5, we need
+	 * to mark them as clobber so that LLVM doesn't end up using them
+	 * before / after the call.
+	 */
+	asm volatile("r1 = %[ctx]\n\t"
+		     "r2 = %[map]\n\t"
+		     "r3 = %[slot]\n\t"
+		     "call 12\n\t"
+		     :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
+		     : "r0", "r1", "r2", "r3", "r4", "r5");
+}
+
 /*
  * Helper structure used by eBPF C program
  * to describe BPF map attributes to libbpf loader
-- 
2.21.0

