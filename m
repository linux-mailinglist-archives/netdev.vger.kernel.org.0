Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D981D3642
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgENQSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:18:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:36484 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgENQSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:18:12 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZGYf-00017e-U1; Thu, 14 May 2020 18:18:05 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 1/3] bpf: restrict bpf_probe_read{,str}() only to archs where they work
Date:   Thu, 14 May 2020 18:16:05 +0200
Message-Id: <20200514161607.9212-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514161607.9212-1-daniel@iogearbox.net>
References: <20200514161607.9212-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25812/Thu May 14 14:13:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the legacy bpf_probe_read{,str}() BPF helpers are broken on archs
with overlapping address ranges, we should really take the next step to
disable them from BPF use there.

To generally fix the situation, we've recently added new helper variants
bpf_probe_read_{user,kernel}() and bpf_probe_read_{user,kernel}_str().
For details on them, see 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel}
and probe_read_{user,kernel}_str helpers").

Given bpf_probe_read{,str}() have been around for ~5 years by now, there
are plenty of users at least on x86 still relying on them today, so we
cannot remove them entirely w/o breaking the BPF tracing ecosystem.

However, their use should be restricted to archs with non-overlapping
address ranges where they are working in their current form. Therefore,
move this behind a CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE and
have x86, arm64, arm select it (other archs supporting it can follow-up
on it as well).

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 arch/arm/Kconfig         | 1 +
 arch/arm64/Kconfig       | 1 +
 arch/x86/Kconfig         | 1 +
 init/Kconfig             | 3 +++
 kernel/trace/bpf_trace.c | 6 ++++--
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 66a04f6f4775..c77c93c485a0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -12,6 +12,7 @@ config ARM
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_SETUP_DMA_OPS
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 40fb05d96c60..5d513f461957 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -20,6 +20,7 @@ config ARM64
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SETUP_DMA_OPS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1197b5596d5a..2d3f963fd6f1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -68,6 +68,7 @@ config X86
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
diff --git a/init/Kconfig b/init/Kconfig
index 9e22ee8fbd75..6fd13a051342 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2279,6 +2279,9 @@ config ASN1
 
 source "kernel/Kconfig.locks"
 
+config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	bool
+
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	bool
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a77..b83bdaa31c7b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -825,14 +825,16 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
 		return &bpf_probe_read_kernel_proto;
-	case BPF_FUNC_probe_read:
-		return &bpf_probe_read_compat_proto;
 	case BPF_FUNC_probe_read_user_str:
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
 		return &bpf_probe_read_kernel_str_proto;
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	case BPF_FUNC_probe_read:
+		return &bpf_probe_read_compat_proto;
 	case BPF_FUNC_probe_read_str:
 		return &bpf_probe_read_compat_str_proto;
+#endif
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
-- 
2.21.0

