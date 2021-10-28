Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB643D8A3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJ1Bfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:35:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:42863 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhJ1Bfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:35:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="210379103"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="210379103"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 18:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="486925290"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by orsmga007.jf.intel.com with ESMTP; 27 Oct 2021 18:33:28 -0700
Date:   Wed, 27 Oct 2021 18:35:44 -0700
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
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org
Subject: [PATCH ebpf v2 2/2] bpf: Make unprivileged bpf depend on
 CONFIG_CPU_SPECTRE
Message-ID: <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
References: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling unprivileged BPF would help prevent unprivileged users from
creating the conditions required for potential speculative execution
side-channel attacks on affected hardware. A deep dive on such attacks
and mitigation is available here [1].

If an architecture selects CONFIG_CPU_SPECTRE, disable unprivileged BPF
by default. An admin can enable this at runtime, if necessary.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf
---
 kernel/bpf/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index a82d6de86522..510a5a73f9a2 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
 
 config BPF_UNPRIV_DEFAULT_OFF
 	bool "Disable unprivileged BPF by default"
+	default y if CPU_SPECTRE
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

