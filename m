Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12A63A1CA2
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhFISXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:23:31 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38509 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFISXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:23:30 -0400
Received: by mail-pf1-f181.google.com with SMTP id z26so19077199pfj.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pMNtPdB4yeaOaJg4oKXM0D8sPt6m955IeGjoIXPrk70=;
        b=PazdJpi79UQEsNsJQD2CIaSYmwpf00Mw0MCZeW5GC2zdnsa0IB92sYjdiUDujBLmOv
         3yiW/7qHaVhsPjbZomfBsLbYDeD+/ig/7taYFSIjA7Cs35U9xgJInZA2nA7XIhz+eX/f
         YAYlYYJX5H3ZqKlrBYtQLFY0ybk6rdc7RljwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMNtPdB4yeaOaJg4oKXM0D8sPt6m955IeGjoIXPrk70=;
        b=jiBZkezBHTRciAnmYShJuqJ8NKMu3yLbetc+Lmp+GMtWOozWVekXnUO7fiFZigO1lg
         BWU6wNdcWpJ2Mgk0z4nXvQPa827qEzla7rm44vnH660Na8XVoA7bz/QBGnwE+GD7kom5
         qJdkUvvLj5xvCAGrpMYBWmqAKw++Lt4d8h4Tm5H0Do/MWx0ExVD7lq51MqVJWOP5MH/0
         Cfq3wUQvpRFfb8/AEWLuTqk2/MuMk2NRdPiUdtZFEo1yRSPd/1PKN1qNlIBZbjG2+Uc4
         NdThXYm593rmf9+8VrKTMvgNnYjJcyupFMoBDHrRN5aMjZT/1tuzZUjjRj8mWX+QFdNt
         l/DQ==
X-Gm-Message-State: AOAM530gkt0I8SleXmz1uxoTq39pHOTuDXaXJOxS5eKm/3WoKf4C/NvF
        P6NqmWnPVTxX/Z3CLbfyAkQJKw==
X-Google-Smtp-Source: ABdhPJwLivfhU+7xTPT8sWB9xanESizvLeRBJblRt/PXXDrCMVDmnpcAtkIZk9u/qQeEhmYEwcu4IA==
X-Received: by 2002:a62:3444:0:b029:2ec:9658:a755 with SMTP id b65-20020a6234440000b02902ec9658a755mr1010418pfa.71.1623262835683;
        Wed, 09 Jun 2021 11:20:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p14sm445214pgk.6.2021.06.09.11.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:20:34 -0700 (PDT)
Date:   Wed, 9 Jun 2021 11:20:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        nathan@kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <202106091119.84A88B6FE7@keescook>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
> On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > > kernel/bpf/core.c:1414:2.
> > >
> > > This is not enough. We need more information on why this happens
> > > so we can judge whether the patch indeed fixed the issue.
> > >
> > > >
> > > > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > > > missing them and return with error when detected.
> > > >
> > > > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > > > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > > > ---
> > > >
> > > > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> > > >
> > > > Changelog:
> > > > ----------
> > > > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> > > >       Fix commit message.
> > > > v3 - Make it clearer what the fix is for.
> > > > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > > >       check in check_alu_op() in verifier.c.
> > > > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > > >       check in ___bpf_prog_run().
> > > >
> > > > thanks
> > > >
> > > > kind regards
> > > >
> > > > Kurt
> > > >
> > > >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> > > >   1 file changed, 9 insertions(+), 21 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 94ba5163d4c5..ed0eecf20de5 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > > >       u32_min_val = src_reg.u32_min_value;
> > > >       u32_max_val = src_reg.u32_max_value;
> > > >
> > > > +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > > > +                     umax_val >= insn_bitness) {
> > > > +             /* Shifts greater than 31 or 63 are undefined.
> > > > +              * This includes shifts by a negative number.
> > > > +              */
> > > > +             verbose(env, "invalid shift %lld\n", umax_val);
> > > > +             return -EINVAL;
> > > > +     }
> > >
> > > I think your fix is good. I would like to move after
> >
> > I suspect such change will break valid programs that do shift by register.
> >
> > > the following code though:
> > >
> > >          if (!src_known &&
> > >              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> > >                  __mark_reg_unknown(env, dst_reg);
> > >                  return 0;
> > >          }
> > >
> > > > +
> > > >       if (alu32) {
> > > >               src_known = tnum_subreg_is_const(src_reg.var_off);
> > > >               if ((src_known &&
> > > > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > > >               scalar_min_max_xor(dst_reg, &src_reg);
> > > >               break;
> > > >       case BPF_LSH:
> > > > -             if (umax_val >= insn_bitness) {
> > > > -                     /* Shifts greater than 31 or 63 are undefined.
> > > > -                      * This includes shifts by a negative number.
> > > > -                      */
> > > > -                     mark_reg_unknown(env, regs, insn->dst_reg);
> > > > -                     break;
> > > > -             }
> > >
> > > I think this is what happens. For the above case, we simply
> > > marks the dst reg as unknown and didn't fail verification.
> > > So later on at runtime, the shift optimization will have wrong
> > > shift value (> 31/64). Please correct me if this is not right
> > > analysis. As I mentioned in the early please write detailed
> > > analysis in commit log.
> >
> > The large shift is not wrong. It's just undefined.
> > syzbot has to ignore such cases.
> 
> Hi Alexei,
> 
> The report is produced by KUBSAN. I thought there was an agreement on
> cleaning up KUBSAN reports from the kernel (the subset enabled on
> syzbot at least).
> What exactly cases should KUBSAN ignore?
> +linux-hardening/kasan-dev for KUBSAN false positive

Can check_shl_overflow() be used at all? Best to just make things
readable and compiler-happy, whatever the implementation. :)

-- 
Kees Cook
