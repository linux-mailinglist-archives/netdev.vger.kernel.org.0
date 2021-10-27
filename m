Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB543D7A1
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhJ0Xjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:39:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:17497 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhJ0Xjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 19:39:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="227744238"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="227744238"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 16:37:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="529804966"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2021 16:37:26 -0700
Date:   Wed, 27 Oct 2021 16:39:43 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH ebpf] bpf: Disallow unprivileged bpf by default
Message-ID: <20211027233943.kehyrdbibp2d2u4c@gupta-dev2.localdomain>
References: <d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com>
 <bd4db8da-0d44-1785-5767-1731bdaebef8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <bd4db8da-0d44-1785-5767-1731bdaebef8@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.10.2021 23:21, Daniel Borkmann wrote:
>Hello Pawan,
>
>On 10/27/21 10:51 PM, Pawan Gupta wrote:
>>Disabling unprivileged BPF by default would help prevent unprivileged
>>users from creating the conditions required for potential speculative
>>execution side-channel attacks on affected hardware as demonstrated by
>>[1][2][3].
>>
>>This will sync mainline with what most distros are currently applying.
>>An admin can enable this at runtime if necessary.
>>
>>Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>>
>>[1] https://access.redhat.com/security/cve/cve-2019-7308
>>[2] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3490
>>[3] https://bugzilla.redhat.com/show_bug.cgi?id=1672355#c5
>
>Some of your above quoted links are just random ?! For example, [2] has really _zero_ to
>do with what you wrote with regards to speculative execution side-channel attacks ...
>
>We recently did a deep dive on our mitigation work we did in BPF here [0]. This also includes
>an appendix with an extract of the main commits related to the different Spectre variants.
>
>I'd suggest to link to that one instead to avoid confusion on what is related and what not.
>
>  [0] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf

Sure, I will add reference to this presentation.

>>---
>>  kernel/bpf/Kconfig | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>>diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
>>index a82d6de86522..73d446294455 100644
>>--- a/kernel/bpf/Kconfig
>>+++ b/kernel/bpf/Kconfig
>>@@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
>>  config BPF_UNPRIV_DEFAULT_OFF
>>  	bool "Disable unprivileged BPF by default"
>>+	default y
>
>Hm, arm arch has a CPU_SPECTRE Kconfig symbol, see commit c58d237d0852 ("ARM: spectre:
>add Kconfig symbol for CPUs vulnerable to Spectre") that can be selected.
>
>Would be good to generalize it for reuse so archs can select it, and make the above as
>'default y if CPU_SPECTRE'.

Thanks for your feedback, I will send a v2 soon. I guess below is how
you want it to be:

---
diff --git a/arch/Kconfig b/arch/Kconfig
index 8df1c7102643..6aa856d51cb7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1091,6 +1091,9 @@ config ARCH_SUPPORTS_RT
  config CPU_NO_EFFICIENT_FFS
  	def_bool n
  
+config CPU_SPECTRE
+	bool
+
  config HAVE_ARCH_VMAP_STACK
  	def_bool n
  	help
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8355c3895894..44551465fd03 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -828,9 +828,6 @@ config CPU_BPREDICT_DISABLE
  	help
  	  Say Y here to disable branch prediction.  If unsure, say N.
  
-config CPU_SPECTRE
-	bool
-
  config HARDEN_BRANCH_PREDICTOR
  	bool "Harden the branch predictor against aliasing attacks" if EXPERT
  	depends on CPU_SPECTRE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d9830e7e1060..769739da67c6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
  	select CLKEVT_I8253
  	select CLOCKSOURCE_VALIDATE_LAST_CYCLE
  	select CLOCKSOURCE_WATCHDOG
+	select CPU_SPECTRE
  	select DCACHE_WORD_ACCESS
  	select EDAC_ATOMIC_SCRUB
  	select EDAC_SUPPORT
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
