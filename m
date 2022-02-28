Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F464C7EC3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 00:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiB1XyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 18:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiB1XyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 18:54:24 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C454F1323E5;
        Mon, 28 Feb 2022 15:53:43 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOppf-0005Bx-JM; Tue, 01 Mar 2022 00:53:35 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOppf-000FFU-6y; Tue, 01 Mar 2022 00:53:35 +0100
Subject: Re: [PATCH bpf-next v3 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable
 in Kconfig
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
 <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b2aa5233-282e-004c-1ba3-63417cbccd58@iogearbox.net>
Date:   Tue, 1 Mar 2022 00:53:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26467/Mon Feb 28 10:24:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tiezhu,

(patch 1/2 applied so far, thanks!)

On 2/22/22 10:57 AM, Tiezhu Yang wrote:
> Currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
> the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
> without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
> 1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
> the users can not change it to 0 or 2, it seems bad for some users. We

Can you elaborate on the "it seems bad for some users" part? What's the concrete
use case? Also, why not add (e.g. mips) JIT to ARCH_WANT_DEFAULT_BPF_JIT if the
CI suite passes with high degree/confidence?

> can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
> but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
> a chance.
> 
> Additionally, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
> BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when make
> menuconfig, it seems flexible for some developers.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   kernel/bpf/Kconfig | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index f3db15a..8521874 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -54,6 +54,7 @@ config BPF_JIT
>   config BPF_JIT_ALWAYS_ON
>   	bool "Permanently enable BPF JIT and remove BPF interpreter"
>   	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
> +	select BPF_JIT_DEFAULT_ON

Is the above needed if ...

>   	help
>   	  Enables BPF JIT and removes BPF interpreter to avoid speculative
>   	  execution of BPF instructions by the interpreter.
> @@ -63,8 +64,16 @@ config BPF_JIT_ALWAYS_ON
>   	  failure.
>   
>   config BPF_JIT_DEFAULT_ON
> -	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
> -	depends on HAVE_EBPF_JIT && BPF_JIT
> +	bool "Enable BPF JIT by default"
> +	default y if ARCH_WANT_DEFAULT_BPF_JIT

... we retain the prior `default y if ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON` ?

> +	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT

Why is the extra BPF_SYSCALL dependency needed? You could still have this for cBPF->eBPF
translations when BPF syscall is compiled out (e.g. seccomp, sock/packet filters, etc).

> +	help
> +	  Enables BPF JIT by default to avoid speculative execution of BPF
> +	  instructions by the interpreter.
> +
> +	  When CONFIG_BPF_JIT_DEFAULT_ON is enabled but CONFIG_BPF_JIT_ALWAYS_ON
> +	  is disabled, /proc/sys/net/core/bpf_jit_enable is set to 1 by default
> +	  and can be changed to 0 or 2.
>   
>   config BPF_UNPRIV_DEFAULT_OFF
>   	bool "Disable unprivileged BPF by default"
> 

