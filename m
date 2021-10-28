Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2D43E2DE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhJ1OAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:00:46 -0400
Received: from foss.arm.com ([217.140.110.172]:55408 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhJ1OAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:00:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0BE61FB;
        Thu, 28 Oct 2021 06:58:10 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0105A3F70D;
        Thu, 28 Oct 2021 06:58:08 -0700 (PDT)
Date:   Thu, 28 Oct 2021 14:57:51 +0100
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
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH ebpf v2 2/2] bpf: Make unprivileged bpf depend on
 CONFIG_CPU_SPECTRE
Message-ID: <20211028135751.GA41384@lakrids.cambridge.arm.com>
References: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:35:44PM -0700, Pawan Gupta wrote:
> Disabling unprivileged BPF would help prevent unprivileged users from
> creating the conditions required for potential speculative execution
> side-channel attacks on affected hardware. A deep dive on such attacks
> and mitigation is available here [1].
> 
> If an architecture selects CONFIG_CPU_SPECTRE, disable unprivileged BPF
> by default. An admin can enable this at runtime, if necessary.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> [1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf
> ---
>  kernel/bpf/Kconfig | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index a82d6de86522..510a5a73f9a2 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
>  
>  config BPF_UNPRIV_DEFAULT_OFF
>  	bool "Disable unprivileged BPF by default"
> +	default y if CPU_SPECTRE

Why can't this just be "default y"?

This series makes that the case on x86, and if SW is going to have to
deal with that we may as well do that everywhere, and say that on all
architectures we leave it to the sysadmin or kernel builder to optin to
permitting unprivileged BPF.

If we can change the default for x86 I see no reason we can't change
this globally, and we avoid tying this to CPU_SPECTRE specifically.

Thanks,
Mark.

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
