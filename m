Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F15624E9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbiF3VNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbiF3VND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:13:03 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76977220C6;
        Thu, 30 Jun 2022 14:13:02 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o71T6-0001kM-0I; Thu, 30 Jun 2022 23:12:56 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o71T5-0002uc-Ak; Thu, 30 Jun 2022 23:12:55 +0200
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
Date:   Thu, 30 Jun 2022 23:12:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220625161255.547944-1-xukuohai@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26589/Thu Jun 30 10:08:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Mark,

On 6/25/22 6:12 PM, Xu Kuohai wrote:
> This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
> native calling convention to bpf calling convention and is used to implement
> various bpf features, such as fentry, fexit, fmod_ret and struct_ops.
> 
> The trampoline introduced does essentially the same thing as the bpf
> trampoline does on x86.
> 
> Tested on raspberry pi 4b and qemu:
> 
>   #18 /1     bpf_tcp_ca/dctcp:OK
>   #18 /2     bpf_tcp_ca/cubic:OK
>   #18 /3     bpf_tcp_ca/invalid_license:OK
>   #18 /4     bpf_tcp_ca/dctcp_fallback:OK
>   #18 /5     bpf_tcp_ca/rel_setsockopt:OK
>   #18        bpf_tcp_ca:OK
>   #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
>   #51 /2     dummy_st_ops/dummy_init_ret_value:OK
>   #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
>   #51 /4     dummy_st_ops/dummy_multiple_args:OK
>   #51        dummy_st_ops:OK
>   #57 /1     fexit_bpf2bpf/target_no_callees:OK
>   #57 /2     fexit_bpf2bpf/target_yes_callees:OK
>   #57 /3     fexit_bpf2bpf/func_replace:OK
>   #57 /4     fexit_bpf2bpf/func_replace_verify:OK
>   #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
>   #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
>   #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
>   #57 /8     fexit_bpf2bpf/func_replace_multi:OK
>   #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
>   #57        fexit_bpf2bpf:OK
>   #237       xdp_bpf2bpf:OK
> 
> v6:
> - Since Mark is refactoring arm64 ftrace to support long jump and reduce the
>    ftrace trampoline overhead, it's not clear how we'll attach bpf trampoline
>    to regular kernel functions, so remove ftrace related patches for now.
> - Add long jump support for attaching bpf trampoline to bpf prog, since bpf
>    trampoline and bpf prog are allocated via vmalloc, there is chance the
>    distance exceeds the max branch range.
> - Collect ACK/Review-by, not sure if the ACK and Review-bys for bpf_arch_text_poke()
>    should be kept, since the changes to it is not trivial
> - Update some commit messages and comments

Given you've been taking a look and had objections in v5, would be great if you
can find some cycles for this v6.

Thanks a lot,
Daniel
