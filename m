Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5B180D62
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgCKBQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:16:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38191 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKBQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:16:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id t11so450197wrw.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 18:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=neIXy3h1DsWxcKFhlx7Xa5OnnJX/454pLZ9VItQYYtY=;
        b=N1Yyy1f3fcflPKHIaPlhkwAODm+Of8QaiKUeJmBbJ+Ue5ZwU3pX8Yxp0bUrke2P41Y
         zyC2DsMB50yvUnud3rJBLdp+cHwfV0GCwFAQdh2m7SmOjDguCQfvVxaW8HQHj1QCmq/a
         Af4g9FX0wPyrWB32gewixBGFKNVdGRQc498VifOosMVbdv57eUwAppcjnVTEbM68AQjU
         Ao416+z5o9qRWV6jJRyycagvVbRfg26VRNG5Yoy/a1Ior47t4WnqI3ILRrnOVBLcrLYW
         OyY3Y1hGbztBIB/5KH1zDKG4+DjtoKC0mSeR6nb5itsoD6BXya4/KEK9KppVaKa4pEOj
         gGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=neIXy3h1DsWxcKFhlx7Xa5OnnJX/454pLZ9VItQYYtY=;
        b=JYj52x5H7htfohWoLry25PZl3fF9qh1OW1Zl09c1xZjoJQC+8Mtk4eIL3qBPyd0oD8
         iKez+HynbsbzXhhDUc/FpQ5dPMZoeNjVcEcMK64xvk6W2il1kQL1FxMPfbWuTgRDEmti
         8dpNoKf9IsxdINKZQQu0hJbkLpbGhLZb4Vd55tR+2AL9AKLaAZKgUFevI6yi6Od6GExk
         rM8hek6ja6hXP3tz48fD5L8YU2GhmfxeXhr668Y4/+IYf59KjRPszV3eRtkJDxf1eLDQ
         r31cbgQMPF1HlfyWr2t5AWtllcDpDUklYdf8Wkv0aOICG3XPKY2YdARIPKPSF6i9+hEX
         3Ieg==
X-Gm-Message-State: ANhLgQ09GeiCEgaPM/kyuvJol4/9RD4u/21inamPsXSWF3PuncclVsff
        X/csjRxe4cpqEEHqK7PrmTdsktexXuijf2Ddfyzw
X-Google-Smtp-Source: ADFU+vt+trGp4q+6QcRHrlD50i3gnMWm36j4zM/d0MIcvuL3uQFSvVWTDtsx6peG05fsw7MuO51aYMml9SGSXcMYIws=
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr785020wrt.271.1583889360892;
 Tue, 10 Mar 2020 18:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200311003906.3643037-1-ast@kernel.org>
In-Reply-To: <20200311003906.3643037-1-ast@kernel.org>
From:   KP Singh <kpsingh@google.com>
Date:   Wed, 11 Mar 2020 02:15:43 +0100
Message-ID: <CAFLU3Ktok8WnjjPTuSOgecKFcz+ZsrUOzCKpjc2btb-UwapFwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix trampoline generation for fmod_ret programs
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>,
        Jann Horn <jannh@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch and thanks for fixing this!

On Wed, Mar 11, 2020 at 1:39 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> fmod_ret progs are emitted as:
>
> start = __bpf_prog_enter();
> call fmod_ret
> *(u64 *)(rbp - 8) = rax
> __bpf_prog_exit(, start);
> test eax, eax
> jne do_fexit
>
> That 'test eax, eax' is working by accident. The compiler is free to use rax
> inside __bpf_prog_exit() or inside functions that __bpf_prog_exit() is calling.
> Which caused "test_progs -t modify_return" to sporadically fail depending on
> compiler version and kconfig. Fix it by using 'cmp [rbp - 8], 0' instead of
> 'test eax, eax'.
>
> Fixes: ae24082331d9 ("bpf: Introduce BPF_MODIFY_RETURN")
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 31 +++++--------------------------
>  1 file changed, 5 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b1fd000feb89..5ea7c2cf7ab4 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1449,23 +1449,6 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
>         return 0;
>  }
>
> -static int emit_mod_ret_check_imm8(u8 **pprog, int value)
> -{
> -       u8 *prog = *pprog;
> -       int cnt = 0;
> -
> -       if (!is_imm8(value))
> -               return -EINVAL;
> -
> -       if (value == 0)
> -               EMIT2(0x85, add_2reg(0xC0, BPF_REG_0, BPF_REG_0));
> -       else
> -               EMIT3(0x83, add_1reg(0xF8, BPF_REG_0), value);
> -
> -       *pprog = prog;
> -       return 0;
> -}
> -
>  static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
>                       struct bpf_tramp_progs *tp, int stack_size)
>  {
> @@ -1485,7 +1468,7 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
>                               u8 **branches)
>  {
>         u8 *prog = *pprog;
> -       int i;
> +       int i, cnt = 0;
>
>         /* The first fmod_ret program will receive a garbage return value.
>          * Set this to 0 to avoid confusing the program.
> @@ -1496,16 +1479,12 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
>                 if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, true))
>                         return -EINVAL;
>
> -               /* Generate a branch:
> -                *
> -                * if (ret !=  0)
> +               /* mod_ret prog stored return value into [rbp - 8]. Emit:
> +                * if (*(u64 *)(rbp - 8) !=  0)
>                  *      goto do_fexit;
> -                *
> -                * If needed this can be extended to any integer value which can
> -                * be passed by user-space when the program is loaded.
>                  */
> -               if (emit_mod_ret_check_imm8(&prog, 0))
> -                       return -EINVAL;
> +               /* cmp QWORD PTR [rbp - 0x8], 0x0 */
> +               EMIT4(0x48, 0x83, 0x7d, 0xf8); EMIT1(0x00);
>
>                 /* Save the location of the branch and Generate 6 nops
>                  * (4 bytes for an offset and 2 bytes for the jump) These nops
> --
> 2.23.0
>

Acked-by: KP Singh <kpsingh@google.com>
