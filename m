Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6D2502096
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348738AbiDOCjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 22:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiDOCjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 22:39:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C94BB9B;
        Thu, 14 Apr 2022 19:37:21 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KfgRN509VzQj6r;
        Fri, 15 Apr 2022 10:35:28 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 10:37:18 +0800
Subject: Re: [PATCH bpf-next v2 0/6] bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
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
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
References: <20220414162220.1985095-1-xukuohai@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <b9d38c43-a2a7-ae6d-79e1-51507103ef88@huawei.com>
Date:   Fri, 15 Apr 2022 10:37:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220414162220.1985095-1-xukuohai@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/15/2022 12:22 AM, Xu Kuohai wrote:
> Add bpf trampoline support for arm64. Most of the logic is the same as
> x86.
>
> Tested on qemu, result:
>  #55 fentry_fexit:OK
>  #56 fentry_test:OK
>  #58 fexit_sleep:OK
>  #59 fexit_stress:OK
>  #60 fexit_test:OK
>  #67 get_func_args_test:OK
>  #68 get_func_ip_test:OK
>  #101 modify_return:OK
bpf_struct_ops also depends on bpf trampoline, could you please also add the
test results for bpf_struct_ops related tests case ?
>
> v2:
> - Add Song's ACK
> - Change the multi-line comment in is_valid_bpf_tramp_flags() into net
>   style (patch 3)
> - Fix a deadloop issue in ftrace selftest (patch 2)
> - Replace pt_regs->x0 with pt_regs->orig_x0 in patch 1 commit message 
> - Replace "bpf trampoline" with "custom trampoline" in patch 1, as
>   ftrace direct call is not only used by bpf trampoline.
>
> v1: https://lore.kernel.org/bpf/20220413054959.1053668-1-xukuohai@huawei.com/
>
> Xu Kuohai (6):
>   arm64: ftrace: Add ftrace direct call support
>   ftrace: Fix deadloop caused by direct call in ftrace selftest
>   bpf: Move is_valid_bpf_tramp_flags() to the public trampoline code
>   bpf, arm64: Impelment bpf_arch_text_poke() for arm64
>   bpf, arm64: bpf trampoline for arm64
>   selftests/bpf: Fix trivial typo in fentry_fexit.c
>
>  arch/arm64/Kconfig                            |   2 +
>  arch/arm64/include/asm/ftrace.h               |  10 +
>  arch/arm64/kernel/asm-offsets.c               |   1 +
>  arch/arm64/kernel/entry-ftrace.S              |  28 +-
>  arch/arm64/net/bpf_jit.h                      |  14 +-
>  arch/arm64/net/bpf_jit_comp.c                 | 390 +++++++++++++++++-
>  arch/x86/net/bpf_jit_comp.c                   |  20 -
>  include/linux/bpf.h                           |   5 +
>  kernel/bpf/bpf_struct_ops.c                   |   4 +-
>  kernel/bpf/trampoline.c                       |  35 +-
>  kernel/trace/trace_selftest.c                 |   4 +-
>  .../selftests/bpf/prog_tests/fentry_fexit.c   |   4 +-
>  12 files changed, 482 insertions(+), 35 deletions(-)
>

