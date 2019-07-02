Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F485D5C0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGBRzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:55:07 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46643 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBRzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:55:07 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so25285812iol.13;
        Tue, 02 Jul 2019 10:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U/Z4Dj4Y0qCwdeyEvtqgR34poFjwE8weburaMF45MeQ=;
        b=s3N41a7kPqOIX37fs5hOJz20BwsXZJD2/DvSrm03Otz2GraweucH2293NQXQ4xcUc/
         qHiHPm5xV/4FlbfEIyy2F4bjbCjxt01ZPQvcnoX4nZQJMKaiC9UBNEjR6qtYsq7BpiZc
         s0WY6CydtXoprZ8xU9uvQaGUzZKbhL2h+p2W5HOcTf/L4w19Eq69A8FccnxC/AUNOT7s
         Y7hfrKaw23ZT1WLidKh9Yg0JBvuxsr4P/0G6GDUzztPr/fwwORGqaGFFHE64PRXtJZKH
         ecJK4ddelBZ1XI2mB+4en6wDAKbahp8+1c4Zh1jTPxyF+pwNB3pNctfynWfB7YSyuwK0
         2hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/Z4Dj4Y0qCwdeyEvtqgR34poFjwE8weburaMF45MeQ=;
        b=mr1ASSWBLGS7s2Qy0GAslrslZGhTaaN8GBK8f5z90jpuV0gRrHlyrEbAI6EqzfCLHh
         GEhARUVwyiCeszygR7VzqOweKdy4dNpUHGhKSr+FPxK3q7v+mxBmE14fKZ8vbV2+TxCj
         db/x+nD5NuVoGmNnWks9QweoUoMFL545/ZjV15HW6fc0Dm/vlZr//GZMqKWvn891Nkyo
         NZwumLtgOmKu+3Nb/aZ8ns1r3P6g+fr0RuOIxLg1YE5hZT4bRlKEGaR4D9ZltYyiGgNr
         02CnvaIx3LVgi3dBekbTDF6bUmvYUGcUagG9/Qn5KauwcsotVpieBjyMsNdzlRtXrdCs
         ireQ==
X-Gm-Message-State: APjAAAVGbWM3WfDRZx9b5wuGuNK9pzQ/vTA04d6bdUCRaJVtR3/qljz+
        XtbxMSxgBnAxpA0HxJaNlFIsVcxy0ixcmwyXsx2ylpbwH0U=
X-Google-Smtp-Source: APXvYqyJ7J/5mF5SmC9nDXpaZLD88ofj1dqhd9nZh2LiPIHrtBNayhXrkSUr0pePIGuGLEUAgU7Z9UJkQC3JYcEWuWU=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr6268331iol.97.1562090106352;
 Tue, 02 Jul 2019 10:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190702153908.41562-1-iii@linux.ibm.com>
In-Reply-To: <20190702153908.41562-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 10:54:30 -0700
Message-ID: <CAH3MdRV2_GSBRqBc_vB--N4=tg-BzfHXho2Gz_4g-FnDdALh-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:40 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
>
> Pass -D__TARGET_ARCH_$(ARCH) to selftests in order to choose a proper
> PT_REGS_RC variant.
>
> Fix s930 -> s390 typo.
>
> On s390, provide the forward declaration of struct pt_regs and cast it
> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
> of the full struct pt_regs, s390 exposes only its first field
> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
> (in selftests) and kernel (in samples) headers.
>
> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390, x86
> provides struct pt_regs to both userspace and kernel, however, with
> different field names.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  tools/testing/selftests/bpf/Makefile      |  4 +-
>  tools/testing/selftests/bpf/bpf_helpers.h | 46 +++++++++++++++--------
>  tools/testing/selftests/bpf/progs/loop1.c |  2 +-
>  tools/testing/selftests/bpf/progs/loop2.c |  2 +-
>  tools/testing/selftests/bpf/progs/loop3.c |  2 +-
>  5 files changed, 37 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index d60fee59fbd1..599b320bef65 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  include ../../../../scripts/Kbuild.include
> +include ../../../scripts/Makefile.arch
>
>  LIBDIR := ../../../lib
>  BPFDIR := $(LIBDIR)/bpf
> @@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
>
>  CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
>               $(CLANG_SYS_INCLUDES) \
> -             -Wno-compare-distinct-pointer-types
> +             -Wno-compare-distinct-pointer-types \
> +             -D__TARGET_ARCH_$(ARCH)
>
>  $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
>  $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 1a5b1accf091..faf86d83301a 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -312,8 +312,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #if defined(__TARGET_ARCH_x86)
>         #define bpf_target_x86
>         #define bpf_target_defined
> -#elif defined(__TARGET_ARCH_s930x)
> -       #define bpf_target_s930x
> +#elif defined(__TARGET_ARCH_s390)
> +       #define bpf_target_s390
>         #define bpf_target_defined
>  #elif defined(__TARGET_ARCH_arm)
>         #define bpf_target_arm
> @@ -338,8 +338,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #ifndef bpf_target_defined
>  #if defined(__x86_64__)
>         #define bpf_target_x86
> -#elif defined(__s390x__)
> -       #define bpf_target_s930x
> +#elif defined(__s390__)
> +       #define bpf_target_s390
>  #elif defined(__arm__)
>         #define bpf_target_arm
>  #elif defined(__aarch64__)
> @@ -355,6 +355,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>
>  #if defined(bpf_target_x86)
>
> +#ifdef __KERNEL__
>  #define PT_REGS_PARM1(x) ((x)->di)
>  #define PT_REGS_PARM2(x) ((x)->si)
>  #define PT_REGS_PARM3(x) ((x)->dx)
> @@ -365,19 +366,34 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #define PT_REGS_RC(x) ((x)->ax)
>  #define PT_REGS_SP(x) ((x)->sp)
>  #define PT_REGS_IP(x) ((x)->ip)
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
>
> -#elif defined(bpf_target_s390x)
> +#elif defined(bpf_target_s390)
>
> -#define PT_REGS_PARM1(x) ((x)->gprs[2])
> -#define PT_REGS_PARM2(x) ((x)->gprs[3])
> -#define PT_REGS_PARM3(x) ((x)->gprs[4])
> -#define PT_REGS_PARM4(x) ((x)->gprs[5])
> -#define PT_REGS_PARM5(x) ((x)->gprs[6])
> -#define PT_REGS_RET(x) ((x)->gprs[14])
> -#define PT_REGS_FP(x) ((x)->gprs[11]) /* Works only with CONFIG_FRAME_POINTER */
> -#define PT_REGS_RC(x) ((x)->gprs[2])
> -#define PT_REGS_SP(x) ((x)->gprs[15])
> -#define PT_REGS_IP(x) ((x)->psw.addr)
> +/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
> +struct pt_regs;
> +#define PT_REGS_PARM1(x) (((const volatile user_pt_regs *)(x))->gprs[2])
> +#define PT_REGS_PARM2(x) (((const volatile user_pt_regs *)(x))->gprs[3])
> +#define PT_REGS_PARM3(x) (((const volatile user_pt_regs *)(x))->gprs[4])
> +#define PT_REGS_PARM4(x) (((const volatile user_pt_regs *)(x))->gprs[5])
> +#define PT_REGS_PARM5(x) (((const volatile user_pt_regs *)(x))->gprs[6])
> +#define PT_REGS_RET(x) (((const volatile user_pt_regs *)(x))->gprs[14])
> +/* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_FP(x) (((const volatile user_pt_regs *)(x))->gprs[11])
> +#define PT_REGS_RC(x) (((const volatile user_pt_regs *)(x))->gprs[2])
> +#define PT_REGS_SP(x) (((const volatile user_pt_regs *)(x))->gprs[15])
> +#define PT_REGS_IP(x) (((const volatile user_pt_regs *)(x))->psw.addr)
>
>  #elif defined(bpf_target_arm)
>
> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> index dea395af9ea9..7cdb7f878310 100644
> --- a/tools/testing/selftests/bpf/progs/loop1.c
> +++ b/tools/testing/selftests/bpf/progs/loop1.c
> @@ -18,7 +18,7 @@ int nested_loops(volatile struct pt_regs* ctx)
>         for (j = 0; j < 300; j++)
>                 for (i = 0; i < j; i++) {
>                         if (j & 1)
> -                               m = ctx->rax;
> +                               m = PT_REGS_RC(ctx);
>                         else
>                                 m = j;
>                         sum += i * m;
> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> index 0637bd8e8bcf..9b2f808a2863 100644
> --- a/tools/testing/selftests/bpf/progs/loop2.c
> +++ b/tools/testing/selftests/bpf/progs/loop2.c
> @@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
>         int i = 0;
>
>         while (true) {
> -               if (ctx->rax & 1)
> +               if (PT_REGS_RC(ctx) & 1)
>                         i += 3;
>                 else
>                         i += 7;
> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> index 30a0f6cba080..d727657d51e2 100644
> --- a/tools/testing/selftests/bpf/progs/loop3.c
> +++ b/tools/testing/selftests/bpf/progs/loop3.c
> @@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
>         __u64 i = 0, sum = 0;
>         do {
>                 i++;
> -               sum += ctx->rax;
> +               sum += PT_REGS_RC(ctx);
>         } while (i < 0x100000000ULL);
>         return sum;
>  }
> --
> 2.21.0
>
