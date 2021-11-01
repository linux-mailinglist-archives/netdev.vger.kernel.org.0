Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB256441AF3
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 12:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhKAMAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:00:17 -0400
Received: from foss.arm.com ([217.140.110.172]:39158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhKAMAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 08:00:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54F23D6E;
        Mon,  1 Nov 2021 04:57:43 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.81.163])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 153A13F5A1;
        Mon,  1 Nov 2021 04:57:39 -0700 (PDT)
Date:   Mon, 1 Nov 2021 11:57:29 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH ebpf v3] bpf: Disallow unprivileged bpf by default
Message-ID: <YX/WKa4qYamp1ml9@FVFF77S0Q05N>
References: <0ace9ce3f97656d5f62d11093ad7ee81190c3c25.1635535215.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ace9ce3f97656d5f62d11093ad7ee81190c3c25.1635535215.git.pawan.kumar.gupta@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 12:43:54PM -0700, Pawan Gupta wrote:
> Disabling unprivileged BPF would help prevent unprivileged users from
> creating the conditions required for potential speculative execution
> side-channel attacks on affected hardware. A deep dive on such attacks
> and mitigation is available here [1].
> 
> Sync with what many distros are currently applying, disable unprivileged
> BPF by default. An admin can enable this at runtime, if necessary.
> 
> [1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> v3:
> - Drop the conditional default for CONFIG_BPF_UNPRIV_DEFAULT_OFF until
>   we have an arch generic way to determine arch-common spectre type bugs.
>   [Mark Rutland, Daniel Borkmann].
> - Also drop the patch to Generalize ARM's CONFIG_CPU_SPECTRE.
> - Minor changes to commit message.
> 
> v2: https://lore.kernel.org/lkml/cover.1635383031.git.pawan.kumar.gupta@linux.intel.com/
> - Generalize ARM's CONFIG_CPU_SPECTRE to be available for all architectures.
> - Make CONFIG_BPF_UNPRIV_DEFAULT_OFF depend on CONFIG_CPU_SPECTRE.
> - Updated commit message to reflect the dependency on CONFIG_CPU_SPECTRE.
> - Add reference to BPF spectre presentation in commit message.
> 
> v1: https://lore.kernel.org/all/d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com/
> 
>  kernel/bpf/Kconfig | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index a82d6de86522..73d446294455 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
>  
>  config BPF_UNPRIV_DEFAULT_OFF
>  	bool "Disable unprivileged BPF by default"
> +	default y
>  	depends on BPF_SYSCALL
>  	help
>  	  Disables unprivileged BPF by default by setting the corresponding
> @@ -72,6 +73,10 @@ config BPF_UNPRIV_DEFAULT_OFF
>  	  disable it by setting it to 1 (from which no other transition to
>  	  0 is possible anymore).
>  
> +	  Unprivileged BPF can be used to exploit potential speculative
> +	  execution side-channel vulnerabilities on affected hardware. If you
> +	  are concerned about it, answer Y.
> +
>  source "kernel/bpf/preload/Kconfig"
>  
>  config BPF_LSM
> -- 
> 2.31.1
> 
