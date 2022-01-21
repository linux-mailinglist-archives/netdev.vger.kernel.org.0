Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEF495EF2
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380320AbiAUMYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:24:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36280 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380297AbiAUMYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 07:24:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AD16199C;
        Fri, 21 Jan 2022 12:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE4FC340E1;
        Fri, 21 Jan 2022 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642767857;
        bh=hBZUb0mh6dd9Oooj7DGxq6E/nDsItqULZkSGJF/J+Es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9zkBbrJ/4C84Cfe15GZlbZi/IxQyUeQ+Q8XEJ2xx65Ho2kIf8y6vUkEX154kEheT
         Hg0BX9+33Bdx9J824clJ0SBHAeQ+Ybw6P6dlMVlr4FZ5vhQKK2FQbXYI94fhoNs6DP
         p0B4dVaDziICUlNS9vokoFK81OfcECj1CSJVVwp9xgxaEyjbvrcYk2yDc72BPJsFil
         4N2oDfbFwXg88HatxOzRhQX7juDWGdRvngjBAzFifZIxBbzGUMUpNXJX99GJYqWL7T
         31ucExYNBq2QHRC0jJ8F+ZOFYbN260yEr8pTWErpsQ/00nKFWmbtjHT4718XFhfkNu
         ggfJKFB5J7nIA==
Date:   Fri, 21 Jan 2022 20:16:32 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Mayuresh Chitale <mchitale@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 11/12] riscv: extable: add a dedicated uaccess handler
Message-ID: <YeqkIKUsdHH0ORxf@xhacker>
References: <20211118192130.48b8f04c@xhacker>
 <20211118192651.605d0c80@xhacker>
 <CAN37VV6vfee+T18UkbDLe1ts87+Zvg25oQR1+VJD3e6SJFPPiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN37VV6vfee+T18UkbDLe1ts87+Zvg25oQR1+VJD3e6SJFPPiA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:45:34PM +0530, Mayuresh Chitale wrote:
> Hello Jisheng,

Hi,

> 
> Just wanted to inform you that this patch breaks the writev02 test
> case in LTP and if it is reverted then the test passes. If we run the
> test through strace then we see that the test hangs and following is
> the last line printed by strace:
> 
> "writev(3, [{iov_base=0x7fff848a6000, iov_len=8192}, {iov_base=NULL,
> iov_len=0}]"
> 

Thanks for the bug report. I will try to fix it.

> Thanks,
> Mayuresh.
> 
> 
> On Thu, Nov 18, 2021 at 5:05 PM Jisheng Zhang <jszhang3@mail.ustc.edu.cn> wrote:
> >
> > From: Jisheng Zhang <jszhang@kernel.org>
> >
> > Inspired by commit 2e77a62cb3a6("arm64: extable: add a dedicated
> > uaccess handler"), do similar to riscv to add a dedicated uaccess
> > exception handler to update registers in exception context and
> > subsequently return back into the function which faulted, so we remove
> > the need for fixups specialized to each faulting instruction.
> >
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > ---
> >  arch/riscv/include/asm/asm-extable.h | 23 +++++++++
> >  arch/riscv/include/asm/futex.h       | 23 +++------
> >  arch/riscv/include/asm/uaccess.h     | 74 +++++++++-------------------
> >  arch/riscv/mm/extable.c              | 27 ++++++++++
> >  4 files changed, 78 insertions(+), 69 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/asm-extable.h b/arch/riscv/include/asm/asm-extable.h
> > index 1b1f4ffd8d37..14be0673f5b5 100644
> > --- a/arch/riscv/include/asm/asm-extable.h
> > +++ b/arch/riscv/include/asm/asm-extable.h
> > @@ -5,6 +5,7 @@
> >  #define EX_TYPE_NONE                   0
> >  #define EX_TYPE_FIXUP                  1
> >  #define EX_TYPE_BPF                    2
> > +#define EX_TYPE_UACCESS_ERR_ZERO       3
> >
> >  #ifdef __ASSEMBLY__
> >
> > @@ -23,7 +24,9 @@
> >
> >  #else /* __ASSEMBLY__ */
> >
> > +#include <linux/bits.h>
> >  #include <linux/stringify.h>
> > +#include <asm/gpr-num.h>
> >
> >  #define __ASM_EXTABLE_RAW(insn, fixup, type, data)     \
> >         ".pushsection   __ex_table, \"a\"\n"            \
> > @@ -37,6 +40,26 @@
> >  #define _ASM_EXTABLE(insn, fixup)      \
> >         __ASM_EXTABLE_RAW(#insn, #fixup, __stringify(EX_TYPE_FIXUP), "0")
> >
> > +#define EX_DATA_REG_ERR_SHIFT  0
> > +#define EX_DATA_REG_ERR                GENMASK(4, 0)
> > +#define EX_DATA_REG_ZERO_SHIFT 5
> > +#define EX_DATA_REG_ZERO       GENMASK(9, 5)
> > +
> > +#define EX_DATA_REG(reg, gpr)                                          \
> > +       "((.L__gpr_num_" #gpr ") << " __stringify(EX_DATA_REG_##reg##_SHIFT) ")"
> > +
> > +#define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)          \
> > +       __DEFINE_ASM_GPR_NUMS                                           \
> > +       __ASM_EXTABLE_RAW(#insn, #fixup,                                \
> > +                         __stringify(EX_TYPE_UACCESS_ERR_ZERO),        \
> > +                         "("                                           \
> > +                           EX_DATA_REG(ERR, err) " | "                 \
> > +                           EX_DATA_REG(ZERO, zero)                     \
> > +                         ")")
> > +
> > +#define _ASM_EXTABLE_UACCESS_ERR(insn, fixup, err)                     \
> > +       _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)
> > +
> >  #endif /* __ASSEMBLY__ */
> >
> >  #endif /* __ASM_ASM_EXTABLE_H */
> > diff --git a/arch/riscv/include/asm/futex.h b/arch/riscv/include/asm/futex.h
> > index 2e15e8e89502..fc8130f995c1 100644
> > --- a/arch/riscv/include/asm/futex.h
> > +++ b/arch/riscv/include/asm/futex.h
> > @@ -21,20 +21,14 @@
> >
> >  #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)     \
> >  {                                                              \
> > -       uintptr_t tmp;                                          \
> >         __enable_user_access();                                 \
> >         __asm__ __volatile__ (                                  \
> >         "1:     " insn "                                \n"     \
> >         "2:                                             \n"     \
> > -       "       .section .fixup,\"ax\"                  \n"     \
> > -       "       .balign 4                               \n"     \
> > -       "3:     li %[r],%[e]                            \n"     \
> > -       "       jump 2b,%[t]                            \n"     \
> > -       "       .previous                               \n"     \
> > -               _ASM_EXTABLE(1b, 3b)                            \
> > +       _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %[r])                  \
> >         : [r] "+r" (ret), [ov] "=&r" (oldval),                  \
> > -         [u] "+m" (*uaddr), [t] "=&r" (tmp)                    \
> > -       : [op] "Jr" (oparg), [e] "i" (-EFAULT)                  \
> > +         [u] "+m" (*uaddr)                                     \
> > +       : [op] "Jr" (oparg)                                     \
> >         : "memory");                                            \
> >         __disable_user_access();                                \
> >  }
> > @@ -96,15 +90,10 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> >         "2:     sc.w.aqrl %[t],%z[nv],%[u]              \n"
> >         "       bnez %[t],1b                            \n"
> >         "3:                                             \n"
> > -       "       .section .fixup,\"ax\"                  \n"
> > -       "       .balign 4                               \n"
> > -       "4:     li %[r],%[e]                            \n"
> > -       "       jump 3b,%[t]                            \n"
> > -       "       .previous                               \n"
> > -               _ASM_EXTABLE(1b, 4b)                    \
> > -               _ASM_EXTABLE(2b, 4b)                    \
> > +               _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %[r])  \
> > +               _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %[r])  \
> >         : [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
> > -       : [ov] "Jr" (oldval), [nv] "Jr" (newval), [e] "i" (-EFAULT)
> > +       : [ov] "Jr" (oldval), [nv] "Jr" (newval)
> >         : "memory");
> >         __disable_user_access();
> >
> > diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
> > index 40e6099af488..a4716c026386 100644
> > --- a/arch/riscv/include/asm/uaccess.h
> > +++ b/arch/riscv/include/asm/uaccess.h
> > @@ -81,22 +81,14 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
> >
> >  #define __get_user_asm(insn, x, ptr, err)                      \
> >  do {                                                           \
> > -       uintptr_t __tmp;                                        \
> >         __typeof__(x) __x;                                      \
> >         __asm__ __volatile__ (                                  \
> >                 "1:\n"                                          \
> > -               "       " insn " %1, %3\n"                      \
> > +               "       " insn " %1, %2\n"                      \
> >                 "2:\n"                                          \
> > -               "       .section .fixup,\"ax\"\n"               \
> > -               "       .balign 4\n"                            \
> > -               "3:\n"                                          \
> > -               "       li %0, %4\n"                            \
> > -               "       li %1, 0\n"                             \
> > -               "       jump 2b, %2\n"                          \
> > -               "       .previous\n"                            \
> > -                       _ASM_EXTABLE(1b, 3b)                    \
> > -               : "+r" (err), "=&r" (__x), "=r" (__tmp)         \
> > -               : "m" (*(ptr)), "i" (-EFAULT));                 \
> > +               _ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 2b, %0, %1)   \
> > +               : "+r" (err), "=&r" (__x)                       \
> > +               : "m" (*(ptr)));                                \
> >         (x) = __x;                                              \
> >  } while (0)
> >
> > @@ -108,27 +100,18 @@ do {                                                              \
> >  do {                                                           \
> >         u32 __user *__ptr = (u32 __user *)(ptr);                \
> >         u32 __lo, __hi;                                         \
> > -       uintptr_t __tmp;                                        \
> >         __asm__ __volatile__ (                                  \
> >                 "1:\n"                                          \
> > -               "       lw %1, %4\n"                            \
> > +               "       lw %1, %3\n"                            \
> >                 "2:\n"                                          \
> > -               "       lw %2, %5\n"                            \
> > +               "       lw %2, %4\n"                            \
> >                 "3:\n"                                          \
> > -               "       .section .fixup,\"ax\"\n"               \
> > -               "       .balign 4\n"                            \
> > -               "4:\n"                                          \
> > -               "       li %0, %6\n"                            \
> > -               "       li %1, 0\n"                             \
> > -               "       li %2, 0\n"                             \
> > -               "       jump 3b, %3\n"                          \
> > -               "       .previous\n"                            \
> > -                       _ASM_EXTABLE(1b, 4b)                    \
> > -                       _ASM_EXTABLE(2b, 4b)                    \
> > -               : "+r" (err), "=&r" (__lo), "=r" (__hi),        \
> > -                       "=r" (__tmp)                            \
> > -               : "m" (__ptr[__LSW]), "m" (__ptr[__MSW]),       \
> > -                       "i" (-EFAULT));                         \
> > +               _ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 3b, %0, %1)   \
> > +               _ASM_EXTABLE_UACCESS_ERR_ZERO(2b, 3b, %0, %1)   \
> > +               : "+r" (err), "=&r" (__lo), "=r" (__hi)         \
> > +               : "m" (__ptr[__LSW]), "m" (__ptr[__MSW]))       \
> > +       if (err)                                                \
> > +               __hi = 0;                                       \
> >         (x) = (__typeof__(x))((__typeof__((x)-(x)))(            \
> >                 (((u64)__hi << 32) | __lo)));                   \
> >  } while (0)
> > @@ -216,21 +199,14 @@ do {                                                              \
> >
> >  #define __put_user_asm(insn, x, ptr, err)                      \
> >  do {                                                           \
> > -       uintptr_t __tmp;                                        \
> >         __typeof__(*(ptr)) __x = x;                             \
> >         __asm__ __volatile__ (                                  \
> >                 "1:\n"                                          \
> > -               "       " insn " %z3, %2\n"                     \
> > +               "       " insn " %z2, %1\n"                     \
> >                 "2:\n"                                          \
> > -               "       .section .fixup,\"ax\"\n"               \
> > -               "       .balign 4\n"                            \
> > -               "3:\n"                                          \
> > -               "       li %0, %4\n"                            \
> > -               "       jump 2b, %1\n"                          \
> > -               "       .previous\n"                            \
> > -                       _ASM_EXTABLE(1b, 3b)                    \
> > -               : "+r" (err), "=r" (__tmp), "=m" (*(ptr))       \
> > -               : "rJ" (__x), "i" (-EFAULT));                   \
> > +               _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %0)            \
> > +               : "+r" (err), "=m" (*(ptr))                     \
> > +               : "rJ" (__x));                                  \
> >  } while (0)
> >
> >  #ifdef CONFIG_64BIT
> > @@ -244,22 +220,16 @@ do {                                                              \
> >         uintptr_t __tmp;                                        \
> >         __asm__ __volatile__ (                                  \
> >                 "1:\n"                                          \
> > -               "       sw %z4, %2\n"                           \
> > +               "       sw %z3, %1\n"                           \
> >                 "2:\n"                                          \
> > -               "       sw %z5, %3\n"                           \
> > +               "       sw %z4, %2\n"                           \
> >                 "3:\n"                                          \
> > -               "       .section .fixup,\"ax\"\n"               \
> > -               "       .balign 4\n"                            \
> > -               "4:\n"                                          \
> > -               "       li %0, %6\n"                            \
> > -               "       jump 3b, %1\n"                          \
> > -               "       .previous\n"                            \
> > -                       _ASM_EXTABLE(1b, 4b)                    \
> > -                       _ASM_EXTABLE(2b, 4b)                    \
> > -               : "+r" (err), "=r" (__tmp),                     \
> > +               _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %0)            \
> > +               _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %0)            \
> > +               : "+r" (err),                                   \
> >                         "=m" (__ptr[__LSW]),                    \
> >                         "=m" (__ptr[__MSW])                     \
> > -               : "rJ" (__x), "rJ" (__x >> 32), "i" (-EFAULT)); \
> > +               : "rJ" (__x), "rJ" (__x >> 32));                \
> >  } while (0)
> >  #endif /* CONFIG_64BIT */
> >
> > diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> > index 91e52c4bb33a..05978f78579f 100644
> > --- a/arch/riscv/mm/extable.c
> > +++ b/arch/riscv/mm/extable.c
> > @@ -7,10 +7,12 @@
> >   */
> >
> >
> > +#include <linux/bitfield.h>
> >  #include <linux/extable.h>
> >  #include <linux/module.h>
> >  #include <linux/uaccess.h>
> >  #include <asm/asm-extable.h>
> > +#include <asm/ptrace.h>
> >
> >  static inline unsigned long
> >  get_ex_fixup(const struct exception_table_entry *ex)
> > @@ -25,6 +27,29 @@ static bool ex_handler_fixup(const struct exception_table_entry *ex,
> >         return true;
> >  }
> >
> > +static inline void regs_set_gpr(struct pt_regs *regs, unsigned int offset,
> > +                               unsigned long val)
> > +{
> > +       if (unlikely(offset > MAX_REG_OFFSET))
> > +               return;
> > +
> > +       if (!offset)
> > +               *(unsigned long *)((unsigned long)regs + offset) = val;
> > +}
> > +
> > +static bool ex_handler_uaccess_err_zero(const struct exception_table_entry *ex,
> > +                                       struct pt_regs *regs)
> > +{
> > +       int reg_err = FIELD_GET(EX_DATA_REG_ERR, ex->data);
> > +       int reg_zero = FIELD_GET(EX_DATA_REG_ZERO, ex->data);
> > +
> > +       regs_set_gpr(regs, reg_err, -EFAULT);
> > +       regs_set_gpr(regs, reg_zero, 0);
> > +
> > +       regs->epc = get_ex_fixup(ex);
> > +       return true;
> > +}
> > +
> >  bool fixup_exception(struct pt_regs *regs)
> >  {
> >         const struct exception_table_entry *ex;
> > @@ -38,6 +63,8 @@ bool fixup_exception(struct pt_regs *regs)
> >                 return ex_handler_fixup(ex, regs);
> >         case EX_TYPE_BPF:
> >                 return ex_handler_bpf(ex, regs);
> > +       case EX_TYPE_UACCESS_ERR_ZERO:
> > +               return ex_handler_uaccess_err_zero(ex, regs);
> >         }
> >
> >         BUG();
> > --
> > 2.33.0
> >
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
