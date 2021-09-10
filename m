Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B8C40721C
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 21:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhIJTsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 15:48:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:41444 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJTsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 15:48:31 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOmUS-000ARV-NX; Fri, 10 Sep 2021 21:47:12 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mOmUS-000EH9-ET; Fri, 10 Sep 2021 21:47:12 +0200
Subject: Re: [PATCH bpf-next v3 13/13] bpf/tests: Add tail call limit test
 with external function call
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, paul@cilium.io
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
 <20210909143303.811171-14-johan.almbladh@anyfinetworks.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fc28efd2-53ab-4f48-89fd-6d85078e7ed3@iogearbox.net>
Date:   Fri, 10 Sep 2021 21:47:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210909143303.811171-14-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26290/Fri Sep 10 10:21:09 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 4:33 PM, Johan Almbladh wrote:
> This patch adds a tail call limit test where the program also emits
> a BPF_CALL to an external function prior to the tail call. Mainly
> testing that JITed programs preserve its internal register state, for
> example tail call count, across such external calls.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 80 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 7475abfd2186..152193b4080f 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -12202,6 +12202,30 @@ struct tail_call_test {
>   		     offset, TAIL_CALL_MARKER),	       \
>   	BPF_JMP_IMM(BPF_TAIL_CALL, 0, 0, 0)
>   
> +/*
> + * A test function to be called from a BPF program, clobbering a lot of
> + * CPU registers in the process. A JITed BPF program calling this function
> + * must save and restore any caller-saved registers it uses for internal
> + * state, for example the current tail call count.
> + */
> +BPF_CALL_1(bpf_test_func, u64, arg)
> +{
> +	char buf[64];
> +	long a = 0;
> +	long b = 1;
> +	long c = 2;
> +	long d = 3;
> +	long e = 4;
> +	long f = 5;
> +	long g = 6;
> +	long h = 7;
> +
> +	return snprintf(buf, sizeof(buf),
> +			"%ld %lu %lx %ld %lu %lx %ld %lu %x",
> +			a, b, c, d, e, f, g, h, (int)arg);
> +}
> +#define BPF_FUNC_test_func __BPF_FUNC_MAX_ID
> +
>   /*
>    * Tail call tests. Each test case may call any other test in the table,
>    * including itself, specified as a relative index offset from the calling
> @@ -12259,6 +12283,25 @@ static struct tail_call_test tail_call_tests[] = {
>   		},
>   		.result = MAX_TAIL_CALL_CNT + 1,
>   	},
> +	{
> +		"Tail call count preserved across function calls",
> +		.insns = {
> +			BPF_ALU64_IMM(BPF_ADD, R1, 1),
> +			BPF_STX_MEM(BPF_DW, R10, R1, -8),
> +			BPF_CALL_REL(BPF_FUNC_get_numa_node_id),
> +			BPF_CALL_REL(BPF_FUNC_ktime_get_ns),
> +			BPF_CALL_REL(BPF_FUNC_ktime_get_boot_ns),
> +			BPF_CALL_REL(BPF_FUNC_ktime_get_coarse_ns),
> +			BPF_CALL_REL(BPF_FUNC_jiffies64),
> +			BPF_CALL_REL(BPF_FUNC_test_func),
> +			BPF_LDX_MEM(BPF_DW, R1, R10, -8),
> +			BPF_ALU32_REG(BPF_MOV, R0, R1),
> +			TAIL_CALL(0),
> +			BPF_EXIT_INSN(),

 From discussion with Johan, there'll be a v4 respin since assumption of R0
being valid before exit insn would not hold true when going through verifier.
Fixing it confirmed the 33 limit for x86 JIT as well, so both interpreter and
JIT is 33-aligned.

> +		},
> +		.stack_depth = 8,
> +		.result = MAX_TAIL_CALL_CNT + 1,
> +	},
>   	{
>   		"Tail call error path, NULL target",
>   		.insns = {
> @@ -12333,17 +12376,19 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
>   		/* Relocate runtime tail call offsets and addresses */
>   		for (i = 0; i < len; i++) {
>   			struct bpf_insn *insn = &fp->insnsi[i];
> -
> -			if (insn->imm != TAIL_CALL_MARKER)
> -				continue;
> +			long addr = 0;
>   
>   			switch (insn->code) {
>   			case BPF_LD | BPF_DW | BPF_IMM:
