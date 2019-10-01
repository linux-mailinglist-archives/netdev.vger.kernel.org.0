Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C2C43E6
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfJAWpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:45:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:43792 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbfJAWpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:45:40 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFQtk-0007gz-8O; Wed, 02 Oct 2019 00:45:36 +0200
Date:   Wed, 2 Oct 2019 00:45:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Message-ID: <20191001224535.GB10044@pc-63.home>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930185855.4115372-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25589/Tue Oct  1 10:30:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:58:51AM -0700, Andrii Nakryiko wrote:
> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> are installed along the other libbpf headers.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

[...]
> new file mode 100644
> index 000000000000..fbe28008450f
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_endian.h
> @@ -0,0 +1,72 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __BPF_ENDIAN__
> +#define __BPF_ENDIAN__
> +
> +#include <linux/stddef.h>
> +#include <linux/swab.h>
> +
> +/* LLVM's BPF target selects the endianness of the CPU
> + * it compiles on, or the user specifies (bpfel/bpfeb),
> + * respectively. The used __BYTE_ORDER__ is defined by
> + * the compiler, we cannot rely on __BYTE_ORDER from
> + * libc headers, since it doesn't reflect the actual
> + * requested byte order.
> + *
> + * Note, LLVM's BPF target has different __builtin_bswapX()
> + * semantics. It does map to BPF_ALU | BPF_END | BPF_TO_BE
> + * in bpfel and bpfeb case, which means below, that we map
> + * to cpu_to_be16(). We could use it unconditionally in BPF
> + * case, but better not rely on it, so that this header here
> + * can be used from application and BPF program side, which
> + * use different targets.
> + */
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +# define __bpf_ntohs(x)			__builtin_bswap16(x)
> +# define __bpf_htons(x)			__builtin_bswap16(x)
> +# define __bpf_constant_ntohs(x)	___constant_swab16(x)
> +# define __bpf_constant_htons(x)	___constant_swab16(x)
> +# define __bpf_ntohl(x)			__builtin_bswap32(x)
> +# define __bpf_htonl(x)			__builtin_bswap32(x)
> +# define __bpf_constant_ntohl(x)	___constant_swab32(x)
> +# define __bpf_constant_htonl(x)	___constant_swab32(x)
> +# define __bpf_be64_to_cpu(x)		__builtin_bswap64(x)
> +# define __bpf_cpu_to_be64(x)		__builtin_bswap64(x)
> +# define __bpf_constant_be64_to_cpu(x)	___constant_swab64(x)
> +# define __bpf_constant_cpu_to_be64(x)	___constant_swab64(x)
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +# define __bpf_ntohs(x)			(x)
> +# define __bpf_htons(x)			(x)
> +# define __bpf_constant_ntohs(x)	(x)
> +# define __bpf_constant_htons(x)	(x)
> +# define __bpf_ntohl(x)			(x)
> +# define __bpf_htonl(x)			(x)
> +# define __bpf_constant_ntohl(x)	(x)
> +# define __bpf_constant_htonl(x)	(x)
> +# define __bpf_be64_to_cpu(x)		(x)
> +# define __bpf_cpu_to_be64(x)		(x)
> +# define __bpf_constant_be64_to_cpu(x)  (x)
> +# define __bpf_constant_cpu_to_be64(x)  (x)
> +#else
> +# error "Fix your compiler's __BYTE_ORDER__?!"
> +#endif
> +
> +#define bpf_htons(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_htons(x) : __bpf_htons(x))
> +#define bpf_ntohs(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_ntohs(x) : __bpf_ntohs(x))
> +#define bpf_htonl(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_htonl(x) : __bpf_htonl(x))
> +#define bpf_ntohl(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_ntohl(x) : __bpf_ntohl(x))
> +#define bpf_cpu_to_be64(x)			\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
> +#define bpf_be64_to_cpu(x)			\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))

Nit: if we move this into a public API for libbpf, we should probably
also define for sake of consistency a bpf_cpu_to_be{64,32,16}() and
bpf_be{64,32,16}_to_cpu() and have the latter two point to the existing
bpf_hton{l,s}() and bpf_ntoh{l,s}() macros.

> +#endif /* __BPF_ENDIAN__ */

> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> new file mode 100644
> index 000000000000..a1d9b97b8e15
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -0,0 +1,527 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __BPF_HELPERS__
> +#define __BPF_HELPERS__
> +
> +#define __uint(name, val) int (*name)[val]
> +#define __type(name, val) val *name
> +
> +/* helper macro to print out debug messages */
> +#define bpf_printk(fmt, ...)				\
> +({							\
> +	char ____fmt[] = fmt;				\
> +	bpf_trace_printk(____fmt, sizeof(____fmt),	\
> +			 ##__VA_ARGS__);		\
> +})

Did you double check if by now via .rodata we can have the fmt as
const char * and add __attribute__ ((format (printf, 1, 2))) to it?
If that works we should avoid having to copy the string as above in
the API.

> +/* helper macro to place programs, maps, license in
> + * different sections in elf_bpf file. Section names
> + * are interpreted by elf_bpf loader
> + */
> +#define SEC(NAME) __attribute__((section(NAME), used))
> +
> +/* helper functions called from eBPF programs written in C */

As mentioned earlier, the whole helper function description below
should get a big cleanup in here when moved into libbpf API.

> +static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> +	(void *) BPF_FUNC_map_lookup_elem;
> +static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
> +				  unsigned long long flags) =
[...]
> +
> +/* llvm builtin functions that eBPF C program may use to
> + * emit BPF_LD_ABS and BPF_LD_IND instructions
> + */
> +struct sk_buff;
> +unsigned long long load_byte(void *skb,
> +			     unsigned long long off) asm("llvm.bpf.load.byte");
> +unsigned long long load_half(void *skb,
> +			     unsigned long long off) asm("llvm.bpf.load.half");
> +unsigned long long load_word(void *skb,
> +			     unsigned long long off) asm("llvm.bpf.load.word");

These should be removed from the public API, no point in adding legacy/
deprecated stuff in there.

> +/* a helper structure used by eBPF C program
> + * to describe map attributes to elf_bpf loader
> + */
> +struct bpf_map_def {
> +	unsigned int type;
> +	unsigned int key_size;
> +	unsigned int value_size;
> +	unsigned int max_entries;
> +	unsigned int map_flags;
> +	unsigned int inner_map_idx;
> +	unsigned int numa_node;
> +};
> +
> +#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
> +	struct ____btf_map_##name {				\
> +		type_key key;					\
> +		type_val value;					\
> +	};							\
> +	struct ____btf_map_##name				\
> +	__attribute__ ((section(".maps." #name), used))		\
> +		____btf_map_##name = { }

Same here.

> +static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
> +	(void *) BPF_FUNC_skb_load_bytes;
[...]

Given we already move bpf_endian.h to a separate header, I'd do the
same for all tracing specifics as well, e.g. bpf_tracing.h.

> +/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
> +#if defined(__TARGET_ARCH_x86)
> +	#define bpf_target_x86
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_s390)
> +	#define bpf_target_s390
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_arm)
> +	#define bpf_target_arm
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_arm64)
> +	#define bpf_target_arm64
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_mips)
> +	#define bpf_target_mips
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_powerpc)
> +	#define bpf_target_powerpc
> +	#define bpf_target_defined
> +#elif defined(__TARGET_ARCH_sparc)
> +	#define bpf_target_sparc
> +	#define bpf_target_defined
> +#else
> +	#undef bpf_target_defined
> +#endif
> +
> +/* Fall back to what the compiler says */
> +#ifndef bpf_target_defined
> +#if defined(__x86_64__)
> +	#define bpf_target_x86
> +#elif defined(__s390__)
> +	#define bpf_target_s390
> +#elif defined(__arm__)
> +	#define bpf_target_arm
> +#elif defined(__aarch64__)
> +	#define bpf_target_arm64
> +#elif defined(__mips__)
> +	#define bpf_target_mips
> +#elif defined(__powerpc__)
> +	#define bpf_target_powerpc
> +#elif defined(__sparc__)
> +	#define bpf_target_sparc
> +#endif
> +#endif
> +
> +#if defined(bpf_target_x86)
> +
> +#ifdef __KERNEL__
> +#define PT_REGS_PARM1(x) ((x)->di)
> +#define PT_REGS_PARM2(x) ((x)->si)
> +#define PT_REGS_PARM3(x) ((x)->dx)
> +#define PT_REGS_PARM4(x) ((x)->cx)
> +#define PT_REGS_PARM5(x) ((x)->r8)
> +#define PT_REGS_RET(x) ((x)->sp)
> +#define PT_REGS_FP(x) ((x)->bp)
> +#define PT_REGS_RC(x) ((x)->ax)
> +#define PT_REGS_SP(x) ((x)->sp)
> +#define PT_REGS_IP(x) ((x)->ip)
> +#else
> +#ifdef __i386__
> +/* i386 kernel is built with -mregparm=3 */
> +#define PT_REGS_PARM1(x) ((x)->eax)
> +#define PT_REGS_PARM2(x) ((x)->edx)
> +#define PT_REGS_PARM3(x) ((x)->ecx)
> +#define PT_REGS_PARM4(x) 0
> +#define PT_REGS_PARM5(x) 0
> +#define PT_REGS_RET(x) ((x)->esp)
> +#define PT_REGS_FP(x) ((x)->ebp)
> +#define PT_REGS_RC(x) ((x)->eax)
> +#define PT_REGS_SP(x) ((x)->esp)
> +#define PT_REGS_IP(x) ((x)->eip)
> +#else
> +#define PT_REGS_PARM1(x) ((x)->rdi)
> +#define PT_REGS_PARM2(x) ((x)->rsi)
> +#define PT_REGS_PARM3(x) ((x)->rdx)
> +#define PT_REGS_PARM4(x) ((x)->rcx)
> +#define PT_REGS_PARM5(x) ((x)->r8)
> +#define PT_REGS_RET(x) ((x)->rsp)
> +#define PT_REGS_FP(x) ((x)->rbp)
> +#define PT_REGS_RC(x) ((x)->rax)
> +#define PT_REGS_SP(x) ((x)->rsp)
> +#define PT_REGS_IP(x) ((x)->rip)
> +#endif
> +#endif
> +
> +#elif defined(bpf_target_s390)
> +
> +/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
> +struct pt_regs;
> +#define PT_REGS_S390 const volatile user_pt_regs
> +#define PT_REGS_PARM1(x) (((PT_REGS_S390 *)(x))->gprs[2])
> +#define PT_REGS_PARM2(x) (((PT_REGS_S390 *)(x))->gprs[3])
> +#define PT_REGS_PARM3(x) (((PT_REGS_S390 *)(x))->gprs[4])
> +#define PT_REGS_PARM4(x) (((PT_REGS_S390 *)(x))->gprs[5])
> +#define PT_REGS_PARM5(x) (((PT_REGS_S390 *)(x))->gprs[6])
> +#define PT_REGS_RET(x) (((PT_REGS_S390 *)(x))->gprs[14])
> +/* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_FP(x) (((PT_REGS_S390 *)(x))->gprs[11])
> +#define PT_REGS_RC(x) (((PT_REGS_S390 *)(x))->gprs[2])
> +#define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
> +#define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
> +
> +#elif defined(bpf_target_arm)
> +
> +#define PT_REGS_PARM1(x) ((x)->uregs[0])
> +#define PT_REGS_PARM2(x) ((x)->uregs[1])
> +#define PT_REGS_PARM3(x) ((x)->uregs[2])
> +#define PT_REGS_PARM4(x) ((x)->uregs[3])
> +#define PT_REGS_PARM5(x) ((x)->uregs[4])
> +#define PT_REGS_RET(x) ((x)->uregs[14])
> +#define PT_REGS_FP(x) ((x)->uregs[11]) /* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_RC(x) ((x)->uregs[0])
> +#define PT_REGS_SP(x) ((x)->uregs[13])
> +#define PT_REGS_IP(x) ((x)->uregs[12])
> +
> +#elif defined(bpf_target_arm64)
> +
> +/* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
> +struct pt_regs;
> +#define PT_REGS_ARM64 const volatile struct user_pt_regs
> +#define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
> +#define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
> +#define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
> +#define PT_REGS_PARM4(x) (((PT_REGS_ARM64 *)(x))->regs[3])
> +#define PT_REGS_PARM5(x) (((PT_REGS_ARM64 *)(x))->regs[4])
> +#define PT_REGS_RET(x) (((PT_REGS_ARM64 *)(x))->regs[30])
> +/* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_FP(x) (((PT_REGS_ARM64 *)(x))->regs[29])
> +#define PT_REGS_RC(x) (((PT_REGS_ARM64 *)(x))->regs[0])
> +#define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
> +#define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
> +
> +#elif defined(bpf_target_mips)
> +
> +#define PT_REGS_PARM1(x) ((x)->regs[4])
> +#define PT_REGS_PARM2(x) ((x)->regs[5])
> +#define PT_REGS_PARM3(x) ((x)->regs[6])
> +#define PT_REGS_PARM4(x) ((x)->regs[7])
> +#define PT_REGS_PARM5(x) ((x)->regs[8])
> +#define PT_REGS_RET(x) ((x)->regs[31])
> +#define PT_REGS_FP(x) ((x)->regs[30]) /* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_RC(x) ((x)->regs[1])
> +#define PT_REGS_SP(x) ((x)->regs[29])
> +#define PT_REGS_IP(x) ((x)->cp0_epc)
> +
> +#elif defined(bpf_target_powerpc)
> +
> +#define PT_REGS_PARM1(x) ((x)->gpr[3])
> +#define PT_REGS_PARM2(x) ((x)->gpr[4])
> +#define PT_REGS_PARM3(x) ((x)->gpr[5])
> +#define PT_REGS_PARM4(x) ((x)->gpr[6])
> +#define PT_REGS_PARM5(x) ((x)->gpr[7])
> +#define PT_REGS_RC(x) ((x)->gpr[3])
> +#define PT_REGS_SP(x) ((x)->sp)
> +#define PT_REGS_IP(x) ((x)->nip)
> +
> +#elif defined(bpf_target_sparc)
> +
> +#define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
> +#define PT_REGS_PARM2(x) ((x)->u_regs[UREG_I1])
> +#define PT_REGS_PARM3(x) ((x)->u_regs[UREG_I2])
> +#define PT_REGS_PARM4(x) ((x)->u_regs[UREG_I3])
> +#define PT_REGS_PARM5(x) ((x)->u_regs[UREG_I4])
> +#define PT_REGS_RET(x) ((x)->u_regs[UREG_I7])
> +#define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
> +#define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
> +
> +/* Should this also be a bpf_target check for the sparc case? */
> +#if defined(__arch64__)
> +#define PT_REGS_IP(x) ((x)->tpc)
> +#else
> +#define PT_REGS_IP(x) ((x)->pc)
> +#endif
> +
> +#endif
> +
> +#if defined(bpf_target_powerpc)
> +#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = (ctx)->link; })
> +#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
> +#elif defined(bpf_target_sparc)
> +#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = PT_REGS_RET(ctx); })
> +#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
> +#else
> +#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({				\
> +		bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
> +#define BPF_KRETPROBE_READ_RET_IP(ip, ctx)	({				\
> +		bpf_probe_read(&(ip), sizeof(ip),				\
> +				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
> +#endif
> +
> +/*
> + * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> + * relocation for source address using __builtin_preserve_access_index()
> + * built-in, provided by Clang.
> + *
> + * __builtin_preserve_access_index() takes as an argument an expression of
> + * taking an address of a field within struct/union. It makes compiler emit
> + * a relocation, which records BTF type ID describing root struct/union and an
> + * accessor string which describes exact embedded field that was used to take
> + * an address. See detailed description of this relocation format and
> + * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h.
> + *
> + * This relocation allows libbpf to adjust BPF instruction to use correct
> + * actual field offset, based on target kernel BTF type that matches original
> + * (local) BTF, used to record relocation.
> + */
> +#define BPF_CORE_READ(dst, src)						\
> +	bpf_probe_read((dst), sizeof(*(src)),				\
> +		       __builtin_preserve_access_index(src))
> +
> +#endif
> -- 
> 2.17.1
> 
