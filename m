Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7B41353A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhIUOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:22:47 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:53151 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhIUOWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 10:22:46 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HDNrr4P3rz9sTH;
        Tue, 21 Sep 2021 16:21:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XbTzWHWhH7j9; Tue, 21 Sep 2021 16:21:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HDNrr2sLnz9sT9;
        Tue, 21 Sep 2021 16:21:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 470418B765;
        Tue, 21 Sep 2021 16:21:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PE1hNpxh9zx8; Tue, 21 Sep 2021 16:21:16 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.127])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1B6948B763;
        Tue, 21 Sep 2021 16:21:15 +0200 (CEST)
Subject: Re: [PATCH v3 6/8] bpf ppc64: Access only if addr is kernel address
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210921132943.489732-1-hbathini@linux.ibm.com>
 <20210921132943.489732-7-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <837a3cee-4dc1-ccf2-c976-a9ab89e92b1f@csgroup.eu>
Date:   Tue, 21 Sep 2021 16:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921132943.489732-7-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 21/09/2021 à 15:29, Hari Bathini a écrit :
> From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> 
> On PPC64 with KUAP enabled, any kernel code which wants to
> access userspace needs to be surrounded by disable-enable KUAP.
> But that is not happening for BPF_PROBE_MEM load instruction.
> So, when BPF program tries to access invalid userspace address,
> page-fault handler considers it as bad KUAP fault:
> 
>    Kernel attempted to read user page (d0000000) - exploit attempt? (uid: 0)
> 
> Considering the fact that PTR_TO_BTF_ID (which uses BPF_PROBE_MEM
> mode) could either be a valid kernel pointer or NULL but should
> never be a pointer to userspace address, execute BPF_PROBE_MEM load
> only if addr is kernel address, otherwise set dst_reg=0 and move on.
> 
> This will catch NULL, valid or invalid userspace pointers. Only bad
> kernel pointer will be handled by BPF exception table.
> 
> [Alexei suggested for x86]
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> ---
> 
> Changes in v3:
> * Used is_kernel_addr() logic instead of using TASK_SIZE_MAX check
>    all the time.
> * Addressed other comments from Christophe.
> 
> 
>   arch/powerpc/net/bpf_jit_comp64.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index 506934c13ef7..06e1206a4266 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -734,6 +734,35 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>   		case BPF_LDX | BPF_MEM | BPF_DW:
>   			fallthrough;
>   		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
> +			/*
> +			 * As PTR_TO_BTF_ID that uses BPF_PROBE_MEM mode could either be a valid
> +			 * kernel pointer or NULL but not a userspace address, execute BPF_PROBE_MEM
> +			 * load only if addr is kernel address (see is_kernel_addr()), otherwise
> +			 * set dst_reg=0 and move on.
> +			 */
> +			if (BPF_MODE(code) == BPF_PROBE_MEM) {
> +				EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], src_reg, off));
> +#ifdef CONFIG_PPC_BOOK3E_64

It is better to use IS_ENABLED() whenever possible,

		if (IS_ENABLED((CONFIG_PPC_BOOK3E_64))
			PPC_LI64(b2p[TMP_REG_2], 0x8000000000000000ul);
		else
			PPC_LI64(b2p[TMP_REG_2], PAGE_OFFSET);


> +				PPC_LI64(b2p[TMP_REG_2], 0x8000000000000000ul);
> +#elif defined(CONFIG_PPC_BOOK3S_64)
> +				PPC_LI64(b2p[TMP_REG_2], PAGE_OFFSET);
> +#else
> +				PPC_LI64(b2p[TMP_REG_2], TASK_SIZE);
> +#endif

PPC64 is either CONFIG_PPC_BOOK3S_64 or CONFIG_PPC_BOOK3E_64. The else 
is PPC32.


> +				EMIT(PPC_RAW_CMPLD(b2p[TMP_REG_1], b2p[TMP_REG_2]));
> +				PPC_BCC(COND_GT, (ctx->idx + 4) * 4);
> +				EMIT(PPC_RAW_LI(dst_reg, 0));
> +				/*
> +				 * Check if 'off' is word aligned because PPC_BPF_LL()
> +				 * (BPF_DW case) generates two instructions if 'off' is not
> +				 * word-aligned and one instruction otherwise.
> +				 */
> +				if (BPF_SIZE(code) == BPF_DW && (off & 3))
> +					PPC_JMP((ctx->idx + 3) * 4);
> +				else
> +					PPC_JMP((ctx->idx + 2) * 4);
> +			}
> +
>   			switch (size) {
>   			case BPF_B:
>   				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
> 
