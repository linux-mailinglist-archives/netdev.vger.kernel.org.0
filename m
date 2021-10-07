Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CDB425FC3
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhJGWUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231613AbhJGWUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 18:20:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D4E7610A5;
        Thu,  7 Oct 2021 22:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633645090;
        bh=o3HyU5jqAqPNRg9hfrwZ4loOhmjmqptEncRybeMTxf8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LcmX8vNDuNyQV5Wb3Kf7aJgSGxj1A6Qxuy7nrdo8CKermmCxwTu77FKyx83OS6zGt
         whV5dvLyJiM31hWiLQNadYgRtaygfI5B1G5KinbqVFlbhlvuNy00ZfwAZtbW/rhXbo
         VDLdbzwMLksBoIblkrcsE/taA9yEbYJHrzlkoSLe8hab/aTr/eacv+Eu08+lX94HMZ
         konnmdgJsFcJ5j5UPnAgtw8cO1qbdnkU+xl9yaLSI7gOCz5Rqp/RQp+Hc7NdA0Om/M
         CooHhhL7sDucyIGR0Jj4mGkc5akB+4VxXNhnaKs/uEzLJUov/8226VcQfaPU+9aeZw
         EQ3JfMpoGeicg==
Received: by mail-lf1-f52.google.com with SMTP id z11so22597173lfj.4;
        Thu, 07 Oct 2021 15:18:10 -0700 (PDT)
X-Gm-Message-State: AOAM530wO80x+wBKGDu/Ii0Gzw9jk6JxOtrldKXWwfYwAVp7RiAd4upt
        fo+LWyh4XVMBjItiWp/1z5spugTUdnjr/2ZVyhs=
X-Google-Smtp-Source: ABdhPJwYQDJPFW1bq1LBO58XAXalmf3bjkoX1PJTWrzj0nosMn5fGxkAGROQ3ixa9lVTxpiuWPF4C+l56QGkIdQRMmk=
X-Received: by 2002:a05:6512:3046:: with SMTP id b6mr6795847lfb.650.1633645088817;
 Thu, 07 Oct 2021 15:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-3-memxor@gmail.com>
 <CAPhsuW6nCQK71aeyR1YthvMWGNgH--RwbLnA0_rhi071juTsYg@mail.gmail.com> <20211007220114.igqbftwpox3batj2@apollo.localdomain>
In-Reply-To: <20211007220114.igqbftwpox3batj2@apollo.localdomain>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 15:17:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7fAFdHy+uS02dpSCZ1vJVFPF4X+zsu7QqT8npmD6R1=g@mail.gmail.com>
Message-ID: <CAPhsuW7fAFdHy+uS02dpSCZ1vJVFPF4X+zsu7QqT8npmD6R1=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/6] libbpf: Add typeless and weak ksym
 support to gen_loader
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 3:01 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Fri, Oct 08, 2021 at 03:15:10AM IST, Song Liu wrote:
> > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > This patch adds typeless and weak ksym support to BTF_KIND_VAR
> > > relocation code in gen_loader. For typeless ksym, we use the newly added
> > > bpf_kallsyms_lookup_name helper.
> > >
> > > For weak ksym, we simply skip error check, and fix up the srg_reg for
> > > the insn, as keeping it as BPF_PSEUDO_BTF_ID for weak ksym with its
> > > insn[0].imm and insn[1].imm set as 0 will cause a failure.  This is
> > > consistent with how libbpf relocates these two cases of BTF_KIND_VAR.
> > >
> > > We also modify cleanup_relos to check for typeless ksyms in fd closing
> > > loop, since those have no fd associated with the ksym. For this we can
> > > reuse the unused 'off' member of ksym_desc.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > [...]
> >
> > Everything above (trimmed) makes sense to me.
> >
> > > +/* Expects:
> > > + * BPF_REG_8 - pointer to instruction
> > > + */
> > > +static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
> > > +{
> >
> > But I don't quite follow why we need these changes to emit_relo_ksym_btf.
> > Maybe we should have these changes in a separate patch and add some
> > more explanations?
> >
>
> Before, if the bpf_btf_find_by_name_kind call failed, we just bailed out due to
> the emit_check_err. Now, if it is weak, the error check is conditional, so
> we set 0 as the default values and skip the store for btf_id and btf_fd if the
> btf lookup failed. Till here, it is similar to the case for emit_relo_kfunc_btf.
>
> Note that we only reach this path once for each unique symbol: the next time, we
> enter the kdesc->ref > 1 branch, which copies from the existing insn.
>
> Regarding src_reg stuff: in bpf_object__relocate_data, for obj->gen_loader,
> ext->is_set is always true. For the normal libbpf case, it is only true if the
> lookup succeeded for BTF (in bpf_object__resolve_ksym_var_btf_id). So depending
> on if ext->is_set, it skips assigning BPF_PSEUDO_BTF_ID to src_reg and zeroes
> out insn[0].imm and insn[1].imm. Also, the case for ext->is_set = false for
> libbpf is only reached if we don't fail on lookup error, and that depends on
> ext->is_weak. TLDR; ext->is_weak and lookup failure means src_reg is not
> assigned.
>
> For gen_loader, since this src_reg assignment is always there, we need to clear
> it for the case where lookup failed, hence the:
> -log:
> +       emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
>
> otherwise we end up with src_reg = BPF_PSEUDO_BTF_ID, imm[0] = 0, imm[1] = 0,
> which ends up failing the load.
>
> Similarly, we jump over the src_reg adjustment from the kdesc->ref > 1 case if
> imm is not equal to 0 (if it were 0, then this is weak ksym). Error check
> ensures this instruction is only reached if relo->is_weak (for the same symbol),
> so we don't need to check it again there.
>
> Doing it the other way around (not assigning BPF_PSEUDO_BTF_ID by default for
> gen_loader) would still involve writing to it in the success case, so IMO
> touching it seems unavoidable. If there are better ideas, please lmk.
>
> I added the debug statements so that the selftest reloc result can be inspected
> easily, but not sure I can/should verify it from the selftest itself.  I'll
> split typeless and weak ksym support into separate patches next time, and
> explain this in the commit message.

Thanks for these explanations.It will be helpful to include them in
the commit log.

Song
