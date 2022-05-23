Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3B53130A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbiEWQJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238408AbiEWQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:09:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F0D06470D;
        Mon, 23 May 2022 09:09:50 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28883139F;
        Mon, 23 May 2022 09:09:50 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.9.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 055253F73D;
        Mon, 23 May 2022 09:09:43 -0700 (PDT)
Date:   Mon, 23 May 2022 17:09:39 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Xu Kuohai <xukuohai@huawei.com>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v5 5/6] bpf, arm64: bpf trampoline for arm64
Message-ID: <YouxwxJddrz95289@FVFF77S0Q05N>
References: <20220518131638.3401509-1-xukuohai@huawei.com>
 <20220518131638.3401509-6-xukuohai@huawei.com>
 <CAADnVQJr8Sc5d+XUAY2UnNbZ2TP5OCAQNm3eyTponbMfcpXbkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJr8Sc5d+XUAY2UnNbZ2TP5OCAQNm3eyTponbMfcpXbkQ@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 02:18:20PM -0700, Alexei Starovoitov wrote:
> On Wed, May 18, 2022 at 6:54 AM Xu Kuohai <xukuohai@huawei.com> wrote:
> >
> > Add bpf trampoline support for arm64. Most of the logic is the same as
> > x86.
> >
> > Tested on raspberry pi 4b and qemu with KASLR disabled (avoid long jump),
> > result:
> >  #9  /1     bpf_cookie/kprobe:OK
> >  #9  /2     bpf_cookie/multi_kprobe_link_api:FAIL
> >  #9  /3     bpf_cookie/multi_kprobe_attach_api:FAIL
> >  #9  /4     bpf_cookie/uprobe:OK
> >  #9  /5     bpf_cookie/tracepoint:OK
> >  #9  /6     bpf_cookie/perf_event:OK
> >  #9  /7     bpf_cookie/trampoline:OK
> >  #9  /8     bpf_cookie/lsm:OK
> >  #9         bpf_cookie:FAIL
> >  #18 /1     bpf_tcp_ca/dctcp:OK
> >  #18 /2     bpf_tcp_ca/cubic:OK
> >  #18 /3     bpf_tcp_ca/invalid_license:OK
> >  #18 /4     bpf_tcp_ca/dctcp_fallback:OK
> >  #18 /5     bpf_tcp_ca/rel_setsockopt:OK
> >  #18        bpf_tcp_ca:OK
> >  #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
> >  #51 /2     dummy_st_ops/dummy_init_ret_value:OK
> >  #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
> >  #51 /4     dummy_st_ops/dummy_multiple_args:OK
> >  #51        dummy_st_ops:OK
> >  #55        fentry_fexit:OK
> >  #56        fentry_test:OK
> >  #57 /1     fexit_bpf2bpf/target_no_callees:OK
> >  #57 /2     fexit_bpf2bpf/target_yes_callees:OK
> >  #57 /3     fexit_bpf2bpf/func_replace:OK
> >  #57 /4     fexit_bpf2bpf/func_replace_verify:OK
> >  #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
> >  #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
> >  #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
> >  #57 /8     fexit_bpf2bpf/func_replace_multi:OK
> >  #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
> >  #57        fexit_bpf2bpf:OK
> >  #58        fexit_sleep:OK
> >  #59        fexit_stress:OK
> >  #60        fexit_test:OK
> >  #67        get_func_args_test:OK
> >  #68        get_func_ip_test:OK
> >  #104       modify_return:OK
> >  #237       xdp_bpf2bpf:OK
> >
> > bpf_cookie/multi_kprobe_link_api and bpf_cookie/multi_kprobe_attach_api
> > failed due to lack of multi_kprobe on arm64.
> >
> > Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> 
> Catalin, Will, Mark,
> 
> could you please ack this patch that you don't mind us
> taking this set through bpf-next ?

This is on my queue of things to review alongside some other ftrace and kprobes
patches; I'll try to get that out of the way this week.

From a quick glance I'm not too keen on the change to the ftrace trampoline, as
to get rid of some existing unsoundness I'd really wanted to move that entirely
away from using regs (and had a sketch for how to handle different op
handlers). I'd discussed that with Steven and Masami in another thread:

  https://lore.kernel.org/linux-arm-kernel/YnJUTuOIX9YoJq23@FVFF77S0Q05N/

I'll see if it's possible to make this all work together. It's not entirely
clear to me how the FTRACE_DIRECT its are supposed to play with dynamically
allocated trampolines, and we might need to take a step back and reconsider.

Thanks,
Mark.
