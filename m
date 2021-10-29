Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A6440370
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 21:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhJ2ToT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 15:44:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:57300 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhJ2ToT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 15:44:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="217920452"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="217920452"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 12:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="487693801"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by orsmga007.jf.intel.com with ESMTP; 29 Oct 2021 12:41:36 -0700
Date:   Fri, 29 Oct 2021 12:43:54 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org,
        mark.rutland@arm.com, linux@armlinux.org.uk
Subject: [PATCH ebpf v3] bpf: Disallow unprivileged bpf by default
Message-ID: <0ace9ce3f97656d5f62d11093ad7ee81190c3c25.1635535215.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling unprivileged BPF would help prevent unprivileged users from
creating the conditions required for potential speculative execution
side-channel attacks on affected hardware. A deep dive on such attacks
and mitigation is available here [1].

Sync with what many distros are currently applying, disable unprivileged
BPF by default. An admin can enable this at runtime, if necessary.

[1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
v3:
- Drop the conditional default for CONFIG_BPF_UNPRIV_DEFAULT_OFF until
  we have an arch generic way to determine arch-common spectre type bugs.
  [Mark Rutland, Daniel Borkmann].
- Also drop the patch to Generalize ARM's CONFIG_CPU_SPECTRE.
- Minor changes to commit message.

v2: https://lore.kernel.org/lkml/cover.1635383031.git.pawan.kumar.gupta@linux.intel.com/
- Generalize ARM's CONFIG_CPU_SPECTRE to be available for all architectures.
- Make CONFIG_BPF_UNPRIV_DEFAULT_OFF depend on CONFIG_CPU_SPECTRE.
- Updated commit message to reflect the dependency on CONFIG_CPU_SPECTRE.
- Add reference to BPF spectre presentation in commit message.

v1: https://lore.kernel.org/all/d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com/

 kernel/bpf/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index a82d6de86522..73d446294455 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
 
 config BPF_UNPRIV_DEFAULT_OFF
 	bool "Disable unprivileged BPF by default"
+	default y
 	depends on BPF_SYSCALL
 	help
 	  Disables unprivileged BPF by default by setting the corresponding
@@ -72,6 +73,10 @@ config BPF_UNPRIV_DEFAULT_OFF
 	  disable it by setting it to 1 (from which no other transition to
 	  0 is possible anymore).
 
+	  Unprivileged BPF can be used to exploit potential speculative
+	  execution side-channel vulnerabilities on affected hardware. If you
+	  are concerned about it, answer Y.
+
 source "kernel/bpf/preload/Kconfig"
 
 config BPF_LSM
-- 
2.31.1

