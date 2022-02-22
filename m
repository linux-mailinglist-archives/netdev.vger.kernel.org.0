Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5E4BFE58
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiBVQUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiBVQUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:20:38 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBCB166A50;
        Tue, 22 Feb 2022 08:20:12 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id p23so17454383pgj.2;
        Tue, 22 Feb 2022 08:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ClOtmGzsE/+HFZkogsicuQKY5HWGG1zJS6eXPncIitU=;
        b=HoclMKcRSJ8/OGIfdwj9QiopD81m5GxvFpIRP8nyIb+9pEqsKjt8u1KtIrMmwhpM7q
         9jSKoCxWn+ZU1dPY5gBmUkHdwHgxRdDEzdkjzghC4HuE33SJuJ2kMzppv9U6wxqMjiee
         OngocmrEWA59n+RD5coWWq0IgAsDl8/qIUiTTJl/xr7+24Bn3bitbKIaV2nbxbDq+B24
         N30lJ8QD/asC13Fpp6rhxW2NpR7TaBR6T8QM343XnysFdlE6HSc/FSvTTSNDIndXwpd+
         79z1b8NqWuQ2EATEmxknp2KPG/tf3oVMiBSVKpWI+VWSULO7lZea0dvwzqnJLRxW1dRt
         9p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ClOtmGzsE/+HFZkogsicuQKY5HWGG1zJS6eXPncIitU=;
        b=h7l/+WOzsklOYMhnVzV4iNSGZlRCrLin6McaZs2mVnGSGJlgZ4OR0F3wwHmljA9gWJ
         w5zUkUJHpCpcsh/CjdHgkuXH+cKnH/C69aYOZr/hmHumy2S4hE8bi+AwAGibM2pDhpb7
         CZpve/PrIg144F6tsRrbC5M0Jm7OmvVHlwtuMb57l/VZi8lWcBeTimM05kTgd54pbhp+
         fFl204sBWgK0McI4KnV591dKydeXH8N0Kc6N2Fbap6+dx8FfIRXODdhenWmQm1A96L9m
         QcMa0jYwOsz7u12yaaP39xKaV83Ch/wReQBTAFJf+i3noG/9NbBi4rJ2RBC6bpD1JyBw
         81uQ==
X-Gm-Message-State: AOAM533T1oBqBVdNt03Dz6OQ9QxKfFW8eRAsfw4yV0mY2MM76wdrknWw
        YwY2nTzSmUuv8i1PWo3YXFKwMfC9H3L0K4bIKPk=
X-Google-Smtp-Source: ABdhPJzPUZkc4gu9S98Ee5lwt2NifFZpjjzglk9u7AJ2eIcW8vD5rugqM7bIi3trF9wS+Be5A6YTuCmhsjl5DIggXrc=
X-Received: by 2002:a05:6a00:809:b0:4f1:14bb:40b1 with SMTP id
 m9-20020a056a00080900b004f114bb40b1mr14233900pfk.69.1645546811808; Tue, 22
 Feb 2022 08:20:11 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com> <20220220134813.3411982-5-memxor@gmail.com>
 <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com> <20220222071026.fqdjmd5fhjbl56xl@apollo.legion>
In-Reply-To: <20220222071026.fqdjmd5fhjbl56xl@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Feb 2022 08:20:00 -0800
Message-ID: <CAADnVQLba_X7fZczY774+1GGrGcC5sopD5pzMaDK_O8P+Aeyig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced
 PTR_TO_BTF_ID in map
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 11:10 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Feb 22, 2022 at 12:23:49PM IST, Alexei Starovoitov wrote:
> > On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
> > >  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
> > >                         int off, int bpf_size, enum bpf_access_type t,
> > > -                       int value_regno, bool strict_alignment_once)
> > > +                       int value_regno, bool strict_alignment_once,
> > > +                       struct bpf_reg_state *atomic_load_reg)
> >
> > No new side effects please.
> > value_regno is not pretty already.
> > At least its known ugliness that we need to clean up one day.
> >
> > >  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
> > >  {
> > > +   struct bpf_reg_state atomic_load_reg;
> > >     int load_reg;
> > >     int err;
> > >
> > > +   __mark_reg_unknown(env, &atomic_load_reg);
> > > +
> > >     switch (insn->imm) {
> > >     case BPF_ADD:
> > >     case BPF_ADD | BPF_FETCH:
> > > @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > >             else
> > >                     load_reg = insn->src_reg;
> > >
> > > +           atomic_load_reg = *reg_state(env, load_reg);
> > >             /* check and record load of old value */
> > >             err = check_reg_arg(env, load_reg, DST_OP);
> > >             if (err)
> > > @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> > >     }
> > >
> > >     /* Check whether we can read the memory, with second call for fetch
> > > -    * case to simulate the register fill.
> > > +    * case to simulate the register fill, which also triggers checks
> > > +    * for manipulation of BTF ID pointers embedded in BPF maps.
> > >      */
> > >     err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > > -                          BPF_SIZE(insn->code), BPF_READ, -1, true);
> > > +                          BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
> > >     if (!err && load_reg >= 0)
> > >             err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > >                                    BPF_SIZE(insn->code), BPF_READ, load_reg,
> > > -                                  true);
> > > +                                  true, load_reg >= 0 ? &atomic_load_reg : NULL);
> >
> > Special xchg logic should be down outside of check_mem_access()
> > instead of hidden by layers of calls.
>
> Right, it's ugly, but if we don't capture the reg state before that
> check_reg_arg(env, load_reg, DST_OP), it's not possible to see the actual
> PTR_TO_BTF_ID being moved into the map, since check_reg_arg will do a
> mark_reg_unknown for value_regno. Any other ideas on what I can do?
>
> 37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
> changed the order of check_mem_access and DST_OP check_reg_arg.

That highlights my point that side effects are bad.
That commit tries to work around that behavior and makes things
harder to extend like you found out with xchg logic.
Another option would be to add bpf_kptr_xchg() helper
instead of dealing with insn. It will be tiny bit slower,
but it will work on all architectures. While xchg bpf jit is
on x86,s390,mips so far.
We need to think more on how to refactor check_mem_acess without
digging ourselves into an even bigger hole.
