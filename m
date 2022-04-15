Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59076502090
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 04:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiDOChT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 22:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiDOChS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 22:37:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565303B283;
        Thu, 14 Apr 2022 19:34:51 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KfgNV5DVczgYnH;
        Fri, 15 Apr 2022 10:32:58 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 10:34:48 +0800
Subject: Re: [PATCH bpf-next v2 4/6] bpf, arm64: Impelment
 bpf_arch_text_poke() for arm64
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
 <20220414162220.1985095-5-xukuohai@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <ba838451-1a96-2c83-9188-a994f45d7523@huawei.com>
Date:   Fri, 15 Apr 2022 10:34:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220414162220.1985095-5-xukuohai@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
> Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
> it to replace nop with jump, or replace jump with nop.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/arm64/net/bpf_jit_comp.c | 52 +++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 8ab4035dea27..1a1c3ea75ee2 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/bpf.h>
> +#include <linux/memory.h>
>  #include <linux/filter.h>
>  #include <linux/printk.h>
>  #include <linux/slab.h>
> @@ -18,6 +19,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/insn.h>
> +#include <asm/patching.h>
>  #include <asm/set_memory.h>
>  
>  #include "bpf_jit.h"
> @@ -1529,3 +1531,53 @@ void bpf_jit_free_exec(void *addr)
>  {
>  	return vfree(addr);
>  }
> +
> +static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
> +			     void *addr, u32 *insn)
> +{
> +	if (!addr)
> +		*insn = aarch64_insn_gen_nop();
> +	else
> +		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
> +						    (unsigned long)addr,
> +						    type);
> +
> +	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
> +}
> +
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
> +		       void *old_addr, void *new_addr)
> +{
> +	int ret;
> +	u32 old_insn;
> +	u32 new_insn;
> +	u32 replaced;
> +	enum aarch64_insn_branch_type branch_type;
> +
In bpf_arch_text_poke() of x86, it disables the poking of kernel module, can you
explain why it is OK to do so in arm64 ? Because there is no test cases for
fentry on linux kernel module, could you please add some tests for it ?
> +	if (poke_type == BPF_MOD_CALL)
> +		branch_type = AARCH64_INSN_BRANCH_LINK;
> +	else
> +		branch_type = AARCH64_INSN_BRANCH_NOLINK;
> +
> +	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
> +		return -EFAULT;
> +
> +	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
> +		return -EFAULT;
> +
> +	mutex_lock(&text_mutex);
> +	if (aarch64_insn_read(ip, &replaced)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (replaced != old_insn) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret =  aarch64_insn_patch_text_nosync((void *)ip, new_insn);
> +out:
> +	mutex_unlock(&text_mutex);
> +	return ret;
> +}

