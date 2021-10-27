Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD043D540
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhJ0VZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:25:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:57098 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244524AbhJ0VYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 17:24:34 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfqMv-0001Do-AK; Wed, 27 Oct 2021 23:21:57 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfqMu-0008yD-V2; Wed, 27 Oct 2021 23:21:56 +0200
Subject: Re: [PATCH ebpf] bpf: Disallow unprivileged bpf by default
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com, gregkh@linuxfoundation.org
References: <d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bd4db8da-0d44-1785-5767-1731bdaebef8@iogearbox.net>
Date:   Wed, 27 Oct 2021 23:21:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26335/Wed Oct 27 10:28:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pawan,

On 10/27/21 10:51 PM, Pawan Gupta wrote:
> Disabling unprivileged BPF by default would help prevent unprivileged
> users from creating the conditions required for potential speculative
> execution side-channel attacks on affected hardware as demonstrated by
> [1][2][3].
> 
> This will sync mainline with what most distros are currently applying.
> An admin can enable this at runtime if necessary.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> [1] https://access.redhat.com/security/cve/cve-2019-7308
> [2] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3490
> [3] https://bugzilla.redhat.com/show_bug.cgi?id=1672355#c5

Some of your above quoted links are just random ?! For example, [2] has really _zero_ to
do with what you wrote with regards to speculative execution side-channel attacks ...

We recently did a deep dive on our mitigation work we did in BPF here [0]. This also includes
an appendix with an extract of the main commits related to the different Spectre variants.

I'd suggest to link to that one instead to avoid confusion on what is related and what not.

   [0] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf

> ---
>   kernel/bpf/Kconfig | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index a82d6de86522..73d446294455 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -64,6 +64,7 @@ config BPF_JIT_DEFAULT_ON
>   
>   config BPF_UNPRIV_DEFAULT_OFF
>   	bool "Disable unprivileged BPF by default"
> +	default y

Hm, arm arch has a CPU_SPECTRE Kconfig symbol, see commit c58d237d0852 ("ARM: spectre:
add Kconfig symbol for CPUs vulnerable to Spectre") that can be selected.

Would be good to generalize it for reuse so archs can select it, and make the above as
'default y if CPU_SPECTRE'.

>   	depends on BPF_SYSCALL
>   	help
>   	  Disables unprivileged BPF by default by setting the corresponding
> @@ -72,6 +73,10 @@ config BPF_UNPRIV_DEFAULT_OFF
>   	  disable it by setting it to 1 (from which no other transition to
>   	  0 is possible anymore).
>   
> +	  Unprivileged BPF can be used to exploit potential speculative
> +	  execution side-channel vulnerabilities on affected hardware. If you
> +	  are concerned about it, answer Y.
> +
>   source "kernel/bpf/preload/Kconfig"
>   
>   config BPF_LSM
> 

Thanks,
Daniel
