Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5FD13CF4C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgAOVlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:41:19 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42042 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAOVlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:41:19 -0500
Received: by mail-lj1-f196.google.com with SMTP id y4so20221607ljj.9;
        Wed, 15 Jan 2020 13:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDBG8NutCLOFud8hpELhgGOf+t8BP0JDV4SIBrUuCTE=;
        b=uJmxL7yvQFIVc9JSc/yOZ/MvmM1zht0Q3M6VXMcpBJwX60HekGWxcHKKdIyBbUnzr4
         Kzmu44i4Ret7wmvEidFap5Xo2e8HJRKJ5E7VAJqyPOdulkquHTS428/BcOLeScFa/Yyx
         G/b2eyrwrtEIqqsRSqEd1lYRepm41JAS7/FRdNdprAgMoNZfGHHmo48ls12kzB7xUlgk
         3+hFkPUVgukv8K9oKMYP/irCug1vpo3Fz+0UTYaCO0jh3CslQHjzM+etyrUebucsM2s3
         pQkIqoKUz54uMBjBXQkAubmR2Yovz5StReQ8bH3DsxW0i2c4CeVl5pJEStFSFXch6w/9
         W3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDBG8NutCLOFud8hpELhgGOf+t8BP0JDV4SIBrUuCTE=;
        b=VWoFfDU7YIvefdvpigjoIUc0eQzfJptuQ+R/1zL4TVmmVqwyFn+rZ+2gtYN4yYVkSH
         0e7nMFiUaDeetVYP4mHm7Kt9T/fkWgsdJtQJUfrsEbEoQIprDlysRVhamG7lpuWka61N
         59H+fW1m1PRU0uMEmf+a8gl82lk/H1oJ5kHQNBBU4vzWEmOj3Y2wyIwilWyn+CZIlJ5A
         1Gyvl+Rlk9Vgc5IsEAlHKzq4negyMZwYBcaiElglPdXZXz/35VtveX4Dv3vJGsk2l8+j
         Huvl5hp/JGiebrAvMMm6oa/pJGGNaBcmX4PGloMmNmgFoI5BYSmOAIVFY3LX+YTZVJfF
         Ntsw==
X-Gm-Message-State: APjAAAWgGafdNCan3+ZCnltOS21tG38MNjQqnBhcfPFUBNMCvSc1wiXq
        7WBYr2VuVf4MZ3JNPUCH89SER8L/KDH25EnkleA=
X-Google-Smtp-Source: APXvYqylSZunWd8K/Ucep/N9YeIIKHBTbXCuygF1wq/8zt6GDpFvcmwLlARU63Jf+gQ6WtdZgvovz9Flx8gdiqO1Zc4=
X-Received: by 2002:a2e:990e:: with SMTP id v14mr241914lji.23.1579124476136;
 Wed, 15 Jan 2020 13:41:16 -0800 (PST)
MIME-Version: 1.0
References: <20200115204733.16648-1-daniel@iogearbox.net> <51d3fb28-a9f9-1feb-74fb-9011ced98ffc@fb.com>
In-Reply-To: <51d3fb28-a9f9-1feb-74fb-9011ced98ffc@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jan 2020 13:41:04 -0800
Message-ID: <CAADnVQKeYoPdwTwRQb9smC6Oc9Fcc1m=y-E7UXShOsgjb+Yjpw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix incorrect verifier simulation of ARSH under ALU32
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "anatoly.trosinenko@gmail.com" <anatoly.trosinenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 1:31 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/15/20 12:47 PM, Daniel Borkmann wrote:
> > Anatoly has been fuzzing with kBdysch harness and reported a hang in one
> > of the outcomes:
> >
> >    0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> >    0: (85) call bpf_get_socket_cookie#46
> >    1: R0_w=invP(id=0) R10=fp0
> >    1: (57) r0 &= 808464432
> >    2: R0_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
> >    2: (14) w0 -= 810299440
> >    3: R0_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
> >    3: (c4) w0 s>>= 1
> >    4: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
> >    4: (76) if w0 s>= 0x30303030 goto pc+216
> >    221: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
> >    221: (95) exit
> >    processed 6 insns (limit 1000000) [...]
> >
> > Taking a closer look, the program was xlated as follows:
> >
> >    # ./bpftool p d x i 12
> >    0: (85) call bpf_get_socket_cookie#7800896
> >    1: (bf) r6 = r0
> >    2: (57) r6 &= 808464432
> >    3: (14) w6 -= 810299440
> >    4: (c4) w6 s>>= 1
> >    5: (76) if w6 s>= 0x30303030 goto pc+216
> >    6: (05) goto pc-1
> >    7: (05) goto pc-1
> >    8: (05) goto pc-1
> >    [...]
> >    220: (05) goto pc-1
> >    221: (05) goto pc-1
> >    222: (95) exit
> >
> > Meaning, the visible effect is very similar to f54c7898ed1c ("bpf: Fix
> > precision tracking for unbounded scalars"), that is, the fall-through
> > branch in the instruction 5 is considered to be never taken given the
> > conclusion from the min/max bounds tracking in w6, and therefore the
> > dead-code sanitation rewrites it as goto pc-1. However, real-life input
> > disagrees with verification analysis since a soft-lockup was observed.
> >
> > The bug sits in the analysis of the ARSH. The definition is that we shift
> > the target register value right by K bits through shifting in copies of
> > its sign bit. In adjust_scalar_min_max_vals(), we do first coerce the
> > register into 32 bit mode, same happens after simulating the operation.
> > However, for the case of simulating the actual ARSH, we don't take the
> > mode into account and act as if it's always 64 bit, but location of sign
> > bit is different:
> >
> >    dst_reg->smin_value >>= umin_val;
> >    dst_reg->smax_value >>= umin_val;
> >    dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val);
> >
> > Consider an unknown R0 where bpf_get_socket_cookie() (or others) would
> > for example return 0xffff. With the above ARSH simulation, we'd see the
> > following results:
> >
> >    [...]
> >    1: R1=ctx(id=0,off=0,imm=0) R2_w=invP65535 R10=fp0
> >    1: (85) call bpf_get_socket_cookie#46
> >    2: R0_w=invP(id=0) R10=fp0
> >    2: (57) r0 &= 808464432
> >      -> R0_runtime = 0x3030
> >    3: R0_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
> >    3: (14) w0 -= 810299440
> >      -> R0_runtime = 0xcfb40000
> >    4: R0_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
> >                                (0xffffffff)
> >    4: (c4) w0 s>>= 1
> >      -> R0_runtime = 0xe7da0000
> >    5: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
> >                                (0x67c00000)           (0x7ffbfff8)
> >    [...]
> >
> > In insn 3, we have a runtime value of 0xcfb40000, which is '1100 1111 1011
> > 0100 0000 0000 0000 0000', the result after the shift has 0xe7da0000 that
> > is '1110 0111 1101 1010 0000 0000 0000 0000', where the sign bit is correctly
> > retained in 32 bit mode. In insn4, the umax was 0xffffffff, and changed into
> > 0x7ffbfff8 after the shift, that is, '0111 1111 1111 1011 1111 1111 1111 1000'
> > and means here that the simulation didn't retain the sign bit. With above
> > logic, the updates happen on the 64 bit min/max bounds and given we coerced
> > the register, the sign bits of the bounds are cleared as well, meaning, we
> > need to force the simulation into s32 space for 32 bit alu mode.
> >
> > Verification after the fix below. We're first analyzing the fall-through branch
> > on 32 bit signed >= test eventually leading to rejection of the program in this
> > specific case:
> >
> >    0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> >    0: (b7) r2 = 808464432
> >    1: R1=ctx(id=0,off=0,imm=0) R2_w=invP808464432 R10=fp0
> >    1: (85) call bpf_get_socket_cookie#46
> >    2: R0_w=invP(id=0) R10=fp0
> >    2: (bf) r6 = r0
> >    3: R0_w=invP(id=0) R6_w=invP(id=0) R10=fp0
> >    3: (57) r6 &= 808464432
> >    4: R0_w=invP(id=0) R6_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
> >    4: (14) w6 -= 810299440
> >    5: R0_w=invP(id=0) R6_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
> >    5: (c4) w6 s>>= 1
> >    6: R0_w=invP(id=0) R6_w=invP(id=0,umin_value=3888119808,umax_value=4294705144,var_off=(0xe7c00000; 0x183bfff8)) R10=fp0
> >                                                (0x67c00000)          (0xfffbfff8)
> >    6: (76) if w6 s>= 0x30303030 goto pc+216
> >    7: R0_w=invP(id=0) R6_w=invP(id=0,umin_value=3888119808,umax_value=4294705144,var_off=(0xe7c00000; 0x183bfff8)) R10=fp0
> >    7: (30) r0 = *(u8 *)skb[808464432]
> >    BPF_LD_[ABS|IND] uses reserved fields
> >    processed 8 insns (limit 1000000) [...]
> >
> > Fixes: 9cbe1f5a32dc ("bpf/verifier: improve register value range tracking with ARSH")
> > Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
