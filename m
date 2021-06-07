Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C990539D62C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 09:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFGHks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 03:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGHkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 03:40:47 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDB9C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 00:38:56 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id p21so192537qtw.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 00:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FkDnZkLm7S26Fub+7GJQrbQgH8zlz9fkqHVVt8EUVII=;
        b=nHm4WK6cYXy60WGLih3X49PfQoCmkrbdxEffYKfbL3/RwZaUJn+ZpFlw1f4qhBKOsh
         ahRqwNfz/pELzJOgvhEH7fSmrENCdPGqiDPPnxASXGD5q9sd6Dk5WUdbdBbPUArWSpgz
         YhjtWV0vG8EhX7zQlQ+lNbW/aFKCucpeFKWsmDvBb4gvT3urI0A7KLePEk+N9605Vxec
         pkm2nZH26PbCFEe3Rt8MWK2GYZWEhX1zJkTawVJymWS9/t+exzEZtixnPBaQ3CKp7qxO
         KJPc74KVXSeqk4iHCZH7tGPVflFVx/UFdpy6RZ1xAkh+rjGRzUNDiP+yZ5nLQUld/tUh
         Nh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FkDnZkLm7S26Fub+7GJQrbQgH8zlz9fkqHVVt8EUVII=;
        b=KaenvHB2VWoUYLebToZPkATiDggqbCIoOIlDlfSGh6I1FzyDg69tm7h/zqulTEb/3o
         S5dGqNpyyOlnnG4QR4OUOXfQoqWPx50xhP70oL1Kywch5ZcBXqtGvAIw8/GxuVqeIM7n
         S5/hsE6of5BWRcX4bo49IRkmaQ5ZhrX3NIe14VWDuBIg73TrCwEbliz3HO0BWBjOuzoM
         kV2EpUNxQjURkPAK5n5Vc1j0GJ+tqjGaPUZojIGEIma91Wimm3yTcClTjg6RTQwCrOaZ
         CJ/A0zbnG9X4VYNEsy5Pa6Ozi1btnwMfoXzgumwrAg/d6YIkYvSCV6lBI8uWjEFBcovg
         twHA==
X-Gm-Message-State: AOAM531eO2GqLPMcJDusCUgwxWKD+3RU1eU4yY03jHojKapX0t11Gi/B
        VJK6mjXmogaDsnqQ2VZCD007+8a08ScAen1c5XehCQ==
X-Google-Smtp-Source: ABdhPJw+kgwDX9eCqL8hOPDdudAvKTGNSsQ1Stvnfjs7IZaa/qdT3iEe5T8MNwE87hz52U2sn3g3U6qP7w8/LoXc35w=
X-Received: by 2002:ac8:7c4e:: with SMTP id o14mr14825948qtv.290.1623051534847;
 Mon, 07 Jun 2021 00:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c2987605be907e41@google.com> <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com> <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com> <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
In-Reply-To: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Jun 2021 09:38:43 +0200
Message-ID: <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > kernel/bpf/core.c:1414:2.
> >
> > This is not enough. We need more information on why this happens
> > so we can judge whether the patch indeed fixed the issue.
> >
> > >
> > > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > > missing them and return with error when detected.
> > >
> > > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > > ---
> > >
> > > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> > >
> > > Changelog:
> > > ----------
> > > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> > >       Fix commit message.
> > > v3 - Make it clearer what the fix is for.
> > > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > >       check in check_alu_op() in verifier.c.
> > > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > >       check in ___bpf_prog_run().
> > >
> > > thanks
> > >
> > > kind regards
> > >
> > > Kurt
> > >
> > >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> > >   1 file changed, 9 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 94ba5163d4c5..ed0eecf20de5 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > >       u32_min_val = src_reg.u32_min_value;
> > >       u32_max_val = src_reg.u32_max_value;
> > >
> > > +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > > +                     umax_val >= insn_bitness) {
> > > +             /* Shifts greater than 31 or 63 are undefined.
> > > +              * This includes shifts by a negative number.
> > > +              */
> > > +             verbose(env, "invalid shift %lld\n", umax_val);
> > > +             return -EINVAL;
> > > +     }
> >
> > I think your fix is good. I would like to move after
>
> I suspect such change will break valid programs that do shift by register.
>
> > the following code though:
> >
> >          if (!src_known &&
> >              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> >                  __mark_reg_unknown(env, dst_reg);
> >                  return 0;
> >          }
> >
> > > +
> > >       if (alu32) {
> > >               src_known = tnum_subreg_is_const(src_reg.var_off);
> > >               if ((src_known &&
> > > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > >               scalar_min_max_xor(dst_reg, &src_reg);
> > >               break;
> > >       case BPF_LSH:
> > > -             if (umax_val >= insn_bitness) {
> > > -                     /* Shifts greater than 31 or 63 are undefined.
> > > -                      * This includes shifts by a negative number.
> > > -                      */
> > > -                     mark_reg_unknown(env, regs, insn->dst_reg);
> > > -                     break;
> > > -             }
> >
> > I think this is what happens. For the above case, we simply
> > marks the dst reg as unknown and didn't fail verification.
> > So later on at runtime, the shift optimization will have wrong
> > shift value (> 31/64). Please correct me if this is not right
> > analysis. As I mentioned in the early please write detailed
> > analysis in commit log.
>
> The large shift is not wrong. It's just undefined.
> syzbot has to ignore such cases.

Hi Alexei,

The report is produced by KUBSAN. I thought there was an agreement on
cleaning up KUBSAN reports from the kernel (the subset enabled on
syzbot at least).
What exactly cases should KUBSAN ignore?
+linux-hardening/kasan-dev for KUBSAN false positive
