Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B69570530
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiGKOQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKOQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:16:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9C931347;
        Mon, 11 Jul 2022 07:16:06 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LhQnK62X3zVfcD;
        Mon, 11 Jul 2022 22:12:21 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 22:16:01 +0800
Message-ID: <4852eba8-9fd0-6894-934c-ab89c0c7cea9@huawei.com>
Date:   Mon, 11 Jul 2022 22:16:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 4/4] bpf, arm64: bpf trampoline for arm64
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Will Deacon <will@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220708093032.1832755-1-xukuohai@huawei.com>
 <20220708093032.1832755-5-xukuohai@huawei.com> <YswQQG7CUoTXCbDa@myrica>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <YswQQG7CUoTXCbDa@myrica>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/2022 7:57 PM, Jean-Philippe Brucker wrote:
> On Fri, Jul 08, 2022 at 05:30:32AM -0400, Xu Kuohai wrote:
>> +static void invoke_bpf_prog(struct jit_ctx *ctx, struct bpf_tramp_link *l,
>> +			    int args_off, int retval_off, int run_ctx_off,
>> +			    bool save_ret)
>> +{
>> +	u32 *branch;
>> +	u64 enter_prog;
>> +	u64 exit_prog;
>> +	u8 r0 = bpf2a64[BPF_REG_0];
>> +	struct bpf_prog *p = l->link.prog;
>> +	int cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
>> +
>> +	if (p->aux->sleepable) {
>> +		enter_prog = (u64)__bpf_prog_enter_sleepable;
>> +		exit_prog = (u64)__bpf_prog_exit_sleepable;
>> +	} else {
>> +		enter_prog = (u64)__bpf_prog_enter;
>> +		exit_prog = (u64)__bpf_prog_exit;
>> +	}
>> +
>> +	if (l->cookie == 0) {
>> +		/* if cookie is zero, one instruction is enough to store it */
>> +		emit(A64_STR64I(A64_ZR, A64_SP, run_ctx_off + cookie_off), ctx);
>> +	} else {
>> +		emit_a64_mov_i64(A64_R(10), l->cookie, ctx);
>> +		emit(A64_STR64I(A64_R(10), A64_SP, run_ctx_off + cookie_off),
>> +		     ctx);
>> +	}
>> +
>> +	/* save p to callee saved register x19 to avoid loading p with mov_i64
>> +	 * each time.
>> +	 */
>> +	emit_addr_mov_i64(A64_R(19), (const u64)p, ctx);
>> +
>> +	/* arg1: prog */
>> +	emit(A64_MOV(1, A64_R(0), A64_R(19)), ctx);
>> +	/* arg2: &run_ctx */
>> +	emit(A64_ADD_I(1, A64_R(1), A64_SP, run_ctx_off), ctx);
>> +
>> +	emit_call(enter_prog, ctx);
>> +
>> +	/* if (__bpf_prog_enter(prog) == 0)
>> +	 *         goto skip_exec_of_prog;
>> +	 */
>> +	branch = ctx->image + ctx->idx;
>> +	emit(A64_NOP, ctx);
>> +
>> +	/* save return value to callee saved register x20 */
>> +	emit(A64_MOV(1, A64_R(20), A64_R(0)), ctx);
>> +
>> +	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
>> +	if (!p->jited)
>> +		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
>> +
>> +	emit_call((const u64)p->bpf_func, ctx);
>> +
>> +	/* store return value, which is held in r0 for JIT and in x0
>> +	 * for interpreter.
>> +	 */
>> +	if (save_ret)
>> +		emit(A64_STR64I(p->jited ? r0 : A64_R(0), A64_SP, retval_off),
>> +		     ctx);
> 
> This should be only A64_R(0), not r0. r0 happens to equal A64_R(0) when
> jitted due to the way build_epilogue() builds the function at the moment,
> but we shouldn't rely on that.
> 

looks like I misunderstood something, will change it to:

/* store return value, which is held in x0 for interpreter and in
 * bpf register r0 for JIT, but r0 happens to equal x0 due to the
 * way build_epilogue() builds the JIT image.
 */
if (save_ret)
        emit(A64_STR64I(A64_R(0), A64_SP, retval_off), ctx);

> Apart from that, for the series
> 
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> .
