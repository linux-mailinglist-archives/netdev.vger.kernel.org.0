Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2832739CAAF
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 21:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFETNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 15:13:41 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:33658 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFETNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 15:13:40 -0400
Received: by mail-lf1-f43.google.com with SMTP id t7so12070071lff.0;
        Sat, 05 Jun 2021 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bi0pwEi0pQ/oYx7SVz3LT6qWBi6qRoYFdBg0PjjtkiU=;
        b=LuXg4DkraiESutoTGMgFWtNaz/vXvFOcBH/rRyEA8MkW6FvWC7kW37LoUs75OFaVGk
         y//mqBrjlcZ/SmtFqs6n2tgyMGvdNczJlR586At142OeIxXINk2wnuAjo5flaxHqe2oN
         V+ROfCEaSuOUCKOtjF5iFK0SW+RPFMswCGkddaiXBvImx3VMDNhT8O5JJ/oq2UA9adQb
         EsHaTJvHNyycot71/VHlUzNR893T2H9nSUO85iph/BXbeiUjcSkZH4hA0A4oKUvz+di3
         zUvvwB35QRYUqcxy1vtZaHY2zS9Joe5MvEfCo1B6qVZVa5/t5fRqBErEro5W10YYZJ6L
         Ewng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bi0pwEi0pQ/oYx7SVz3LT6qWBi6qRoYFdBg0PjjtkiU=;
        b=B+LhKU8T1x+9CCf5nR6U+km0/aGdm5BRPOpHxT3hB03CX4xsptomW9xHr3C0WCJyG0
         Hox6FT/A7+y4IN7sXWsbz0ibl/Wdcr4e2XSTc2NQOFJkEmj2jJLOdnsTaCEq8veOby3m
         SYo1Z2MU+wEqo3i5nBS76vyia10dlacNx/0S+YUL8jaw8Z0jZSvp8KoVCiollEriHL64
         aEATcX67/E7dMJsfcnlCknRxVi+vOp2mhwnaCC/0ulUUDeJ3GVEY379xSMRJtH9Ikh4C
         FkOIc1cbrXPfHIVJgi+vrwcjRFCfiPX1zriZPZz5xOOK2FvBJwZBQLys3+s2yIXoZi8L
         dPrg==
X-Gm-Message-State: AOAM532cC0jrCf8ILhGdaS2+UrOKceckNxCWSYKcp/LM+fTWU74zAmop
        gd2z8FitRyQ8LlO5KmKNLAl1JDTLA2RresICmx4=
X-Google-Smtp-Source: ABdhPJxkGuWFy365VSP1rud7bkI+QSPlqLX2IOttcHb7321Z43JZOgQDYk9TcAqdmKPMWykGTZgGvbVJNE4GoJz1uJM=
X-Received: by 2002:a05:6512:2010:: with SMTP id a16mr4002379lfb.38.1622920238423;
 Sat, 05 Jun 2021 12:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c2987605be907e41@google.com> <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com> <87609-531187-curtm@phaethon> <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
In-Reply-To: <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 5 Jun 2021 12:10:26 -0700
Message-ID: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Yonghong Song <yhs@fb.com>
Cc:     Kurt Manucredo <fuzzybritches0@gmail.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > kernel/bpf/core.c:1414:2.
>
> This is not enough. We need more information on why this happens
> so we can judge whether the patch indeed fixed the issue.
>
> >
> > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > missing them and return with error when detected.
> >
> > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > ---
> >
> > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> >
> > Changelog:
> > ----------
> > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> >       Fix commit message.
> > v3 - Make it clearer what the fix is for.
> > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >       check in check_alu_op() in verifier.c.
> > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >       check in ___bpf_prog_run().
> >
> > thanks
> >
> > kind regards
> >
> > Kurt
> >
> >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> >   1 file changed, 9 insertions(+), 21 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 94ba5163d4c5..ed0eecf20de5 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >       u32_min_val = src_reg.u32_min_value;
> >       u32_max_val = src_reg.u32_max_value;
> >
> > +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > +                     umax_val >= insn_bitness) {
> > +             /* Shifts greater than 31 or 63 are undefined.
> > +              * This includes shifts by a negative number.
> > +              */
> > +             verbose(env, "invalid shift %lld\n", umax_val);
> > +             return -EINVAL;
> > +     }
>
> I think your fix is good. I would like to move after

I suspect such change will break valid programs that do shift by register.

> the following code though:
>
>          if (!src_known &&
>              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
>                  __mark_reg_unknown(env, dst_reg);
>                  return 0;
>          }
>
> > +
> >       if (alu32) {
> >               src_known = tnum_subreg_is_const(src_reg.var_off);
> >               if ((src_known &&
> > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >               scalar_min_max_xor(dst_reg, &src_reg);
> >               break;
> >       case BPF_LSH:
> > -             if (umax_val >= insn_bitness) {
> > -                     /* Shifts greater than 31 or 63 are undefined.
> > -                      * This includes shifts by a negative number.
> > -                      */
> > -                     mark_reg_unknown(env, regs, insn->dst_reg);
> > -                     break;
> > -             }
>
> I think this is what happens. For the above case, we simply
> marks the dst reg as unknown and didn't fail verification.
> So later on at runtime, the shift optimization will have wrong
> shift value (> 31/64). Please correct me if this is not right
> analysis. As I mentioned in the early please write detailed
> analysis in commit log.

The large shift is not wrong. It's just undefined.
syzbot has to ignore such cases.
