Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0043D5C2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhJ0Vb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:31:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:40550 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhJ0VbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 17:31:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="230531568"
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="230531568"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 13:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="579912633"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2021 13:49:33 -0700
Date:   Wed, 27 Oct 2021 13:51:49 -0700
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
Subject: [PATCH ebpf] bpf: Disallow unprivileged bpf by default
Message-ID: <d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling unprivileged BPF by default would help prevent unprivileged
users from creating the conditions required for potential speculative
execution side-channel attacks on affected hardware as demonstrated by
[1][2][3].

This will sync mainline with what most distros are currently applying.
An admin can enable this at runtime if necessary.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[1] https://access.redhat.com/security/cve/cve-2019-7308
[2] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3490
[3] https://bugzilla.redhat.com/show_bug.cgi?id=1672355#c5
---
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

