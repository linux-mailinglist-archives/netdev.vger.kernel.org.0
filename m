Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCAA4567E0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhKSCNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:13:01 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26329 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbhKSCNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:13:00 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HwKk46rXQzbhjk;
        Fri, 19 Nov 2021 10:05:00 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 19 Nov 2021 10:09:57 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 19 Nov 2021 10:09:55 +0800
Subject: Re: [PATCH 03/12] riscv: switch to relative exception tables
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Nick Desaulniers" <ndesaulniers@google.com>
References: <20211118192130.48b8f04c@xhacker>
 <20211118192251.749c04f7@xhacker>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
From:   tongtiangen <tongtiangen@huawei.com>
Message-ID: <bc466684-b02e-c6b0-13cf-a071eeebff8c@huawei.com>
Date:   Fri, 19 Nov 2021 10:09:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211118192251.749c04f7@xhacker>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi jisheng:
eBPF's exception tables needs to be modified to relative synchronously.

I modified and verified the code as follows:

===================
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -499,7 +499,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
         offset = pc - (long)&ex->insn;
         if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
                 return -ERANGE;
-       ex->insn = pc;
+       ex->insn = offset;
===================

Thanks.

Reviewed-by:Tong Tiangen <tongtiangen@huawei.com>

On 2021/11/18 19:22, Jisheng Zhang wrote:
> From: Jisheng Zhang <jszhang@kernel.org>
>
> Similar as other architectures such as arm64, x86 and so on, use
> offsets relative to the exception table entry values rather than
> absolute addresses for both the exception locationand the fixup.
>
> However, RISCV label difference will actually produce two relocations,
> a pair of R_RISCV_ADD32 and R_RISCV_SUB32. Take below simple code for
> example:
>
> $ cat test.S
> .section .text
> 1:
>         nop
> .section __ex_table,"a"
>         .balign 4
>         .long (1b - .)
> .previous
>
> $ riscv64-linux-gnu-gcc -c test.S
> $ riscv64-linux-gnu-readelf -r test.o
> Relocation section '.rela__ex_table' at offset 0x100 contains 2 entries:
>   Offset          Info           Type           Sym. Value    Sym. Name + Addend
> 000000000000  000600000023 R_RISCV_ADD32     0000000000000000 .L1^B1 + 0
> 000000000000  000500000027 R_RISCV_SUB32     0000000000000000 .L0  + 0
>
> The modpost will complain the R_RISCV_SUB32 relocation, so we need to
> patch modpost.c to skip this relocation for .rela__ex_table section.
>
> After this patch, the __ex_table section size of defconfig vmlinux is
> reduced from 7072 Bytes to 3536 Bytes.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  arch/riscv/include/asm/Kbuild    |  1 -
>  arch/riscv/include/asm/extable.h | 25 +++++++++++++++++++++++++
>  arch/riscv/include/asm/uaccess.h |  4 ++--
>  arch/riscv/lib/uaccess.S         |  4 ++--
>  arch/riscv/mm/extable.c          |  2 +-
>  scripts/mod/modpost.c            | 15 +++++++++++++++
>  scripts/sorttable.c              |  2 +-
>  7 files changed, 46 insertions(+), 7 deletions(-)
>  create mode 100644 arch/riscv/include/asm/extable.h
>
> diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
> index 445ccc97305a..57b86fd9916c 100644
> --- a/arch/riscv/include/asm/Kbuild
> +++ b/arch/riscv/include/asm/Kbuild
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  generic-y += early_ioremap.h
> -generic-y += extable.h
>  generic-y += flat.h
>  generic-y += kvm_para.h
>  generic-y += user.h
> diff --git a/arch/riscv/include/asm/extable.h b/arch/riscv/include/asm/extable.h
> new file mode 100644
> index 000000000000..84760392fc69
> --- /dev/null
> +++ b/arch/riscv/include/asm/extable.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_RISCV_EXTABLE_H
> +#define _ASM_RISCV_EXTABLE_H
> +
> +/*
> + * The exception table consists of pairs of relative offsets: the first
> + * is the relative offset to an instruction that is allowed to fault,
> + * and the second is the relative offset at which the program should
> + * continue. No registers are modified, so it is entirely up to the
> + * continuation code to figure out what to do.
> + *
> + * All the routines below use bits of fixup code that are out of line
> + * with the main instruction path.  This means when everything is well,
> + * we don't even have to jump over them.  Further, they do not intrude
> + * on our cache or tlb entries.
> + */
> +
> +struct exception_table_entry {
> +	int insn, fixup;
> +};
> +
> +#define ARCH_HAS_RELATIVE_EXTABLE
> +
> +int fixup_exception(struct pt_regs *regs);
> +#endif
> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
> index 714cd311d9f1..0f2c5b9d2e8f 100644
> --- a/arch/riscv/include/asm/uaccess.h
> +++ b/arch/riscv/include/asm/uaccess.h
> @@ -12,8 +12,8 @@
>
>  #define _ASM_EXTABLE(from, to)						\
>  	"	.pushsection	__ex_table, \"a\"\n"			\
> -	"	.balign "	RISCV_SZPTR "	 \n"			\
> -	"	" RISCV_PTR	"(" #from "), (" #to ")\n"		\
> +	"	.balign		4\n"					\
> +	"	.long		(" #from " - .), (" #to " - .)\n"	\
>  	"	.popsection\n"
>
>  /*
> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
> index 63bc691cff91..55f80f84e23f 100644
> --- a/arch/riscv/lib/uaccess.S
> +++ b/arch/riscv/lib/uaccess.S
> @@ -7,8 +7,8 @@
>  100:
>  	\op \reg, \addr
>  	.section __ex_table,"a"
> -	.balign RISCV_SZPTR
> -	RISCV_PTR 100b, \lbl
> +	.balign 4
> +	.long (100b - .), (\lbl - .)
>  	.previous
>  	.endm
>
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index ddb7d3b99e89..d8d239c2c1bd 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -28,6 +28,6 @@ int fixup_exception(struct pt_regs *regs)
>  		return rv_bpf_fixup_exception(fixup, regs);
>  #endif
>
> -	regs->epc = fixup->fixup;
> +	regs->epc = (unsigned long)&fixup->fixup + fixup->fixup;
>  	return 1;
>  }
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index cb8ab7d91d30..6bfa33217914 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1830,6 +1830,14 @@ static int addend_mips_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
>  	return 0;
>  }
>
> +#ifndef EM_RISCV
> +#define EM_RISCV		243
> +#endif
> +
> +#ifndef R_RISCV_SUB32
> +#define R_RISCV_SUB32		39
> +#endif
> +
>  static void section_rela(const char *modname, struct elf_info *elf,
>  			 Elf_Shdr *sechdr)
>  {
> @@ -1866,6 +1874,13 @@ static void section_rela(const char *modname, struct elf_info *elf,
>  		r_sym = ELF_R_SYM(r.r_info);
>  #endif
>  		r.r_addend = TO_NATIVE(rela->r_addend);
> +		switch (elf->hdr->e_machine) {
> +		case EM_RISCV:
> +			if (!strcmp("__ex_table", fromsec) &&
> +			    ELF_R_TYPE(r.r_info) == R_RISCV_SUB32)
> +				continue;
> +			break;
> +		}
>  		sym = elf->symtab_start + r_sym;
>  		/* Skip special sections */
>  		if (is_shndx_special(sym->st_shndx))
> diff --git a/scripts/sorttable.c b/scripts/sorttable.c
> index b7c2ad71f9cf..0c031e47a419 100644
> --- a/scripts/sorttable.c
> +++ b/scripts/sorttable.c
> @@ -376,6 +376,7 @@ static int do_file(char const *const fname, void *addr)
>  	case EM_PARISC:
>  	case EM_PPC:
>  	case EM_PPC64:
> +	case EM_RISCV:
>  		custom_sort = sort_relative_table;
>  		break;
>  	case EM_ARCOMPACT:
> @@ -383,7 +384,6 @@ static int do_file(char const *const fname, void *addr)
>  	case EM_ARM:
>  	case EM_MICROBLAZE:
>  	case EM_MIPS:
> -	case EM_RISCV:
>  	case EM_XTENSA:
>  		break;
>  	default:
>
