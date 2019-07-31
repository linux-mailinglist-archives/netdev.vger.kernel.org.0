Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD827B760
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGaBBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:01:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40011 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfGaBBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:01:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so64882503qtn.7;
        Tue, 30 Jul 2019 18:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JY+l75kh7XNhDv7Bk6TjcbYbp2FSyUBbmVmdsy0DTFU=;
        b=RDLqAL904643iMbj6UPP3UbtfPYDgIlfQ8zns0mx065qYeXIdW10TXR1jk/KBYegU2
         Ai1LzQz5TcHmzWmtBLXJx6wNLJgmS1RrU73P7Rdo4gNF330K21r3tcwt5iRvu6BX86Qi
         AdnlcQH9+1lS5qLIty3eB3uDwT0ZnecJnUEn7UXM76CiaztOLDREoim7hoFVLdnKi+2/
         ZtG70XVk3kIdw+TOFJenETL5YeIVgbvgWLD69noGqr9BgJZJ9kFQm3/FpZ58vY4DXFMB
         3Jm/Ki3MrihZhpFQgI4qMAGjB2z5kfEVi95hi0zgpFPTgoHopoqoCpaVIOUz2c6yoFTZ
         VGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JY+l75kh7XNhDv7Bk6TjcbYbp2FSyUBbmVmdsy0DTFU=;
        b=LUWdsIUYFv7EPXZppy0bEBWMXd8MWXqVAadaidBkyJ7Uj+zSkXgBsTf4M8O9BDWvsK
         nsDKir1d7Vl2ABAVVvNTMg9d+AJcdJEuiDUkZe7IwWz697kX7Y//frGPVKtFGMUi046m
         7DBIFRsztfd+rWMi1r+Gf8yJdZIVrFXSbtKw/rpuBKGfdENXvzk1sEh2X5j/r29Anb0o
         DYJgK4TM0EMJyu+QhqopxkLOWIaJneMNU0omzV9XgdkXYXhnGe/I/o33RWOWyu2GbC0z
         NrNcWV1z9NgJGFW2mijEvdPNoYUEPPlYvNerhl75ioJDvvEWka4EuxDaN90/E2wwpg4o
         a4UQ==
X-Gm-Message-State: APjAAAUSSMELmGUoUxmEj3mpJxOZ3owSk8Q22bnPcw7d0Fk9L2hKbgZ2
        vFihgGWPG3rt9F82nsRXpXqjMoTyH73QytmRfW2J1Hv4HDZ5nA==
X-Google-Smtp-Source: APXvYqxSJBiP86qEHD4UUMGP0Dk9mQJEm9FQDPb2djROC8C0ilnRa3Gx3PoAfLVXHL86Cg73HuX5fBww1lngjYMA9VE=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr84386643qta.117.1564534860120;
 Tue, 30 Jul 2019 18:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190730195408.670063-1-andriin@fb.com> <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com>
In-Reply-To: <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jul 2019 18:00:47 -0700
Message-ID: <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch implements the core logic for BPF CO-RE offsets relocations.
> > Every instruction that needs to be relocated has corresponding
> > bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> > to match recorded "local" relocation spec against potentially many
> > compatible "target" types, creating corresponding spec. Details of the
> > algorithm are noted in corresponding comments in the code.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 915 ++++++++++++++++++++++++++++++++++++++++-
> > tools/lib/bpf/libbpf.h |   1 +
> > 2 files changed, 909 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c

[...]

Please trim irrelevant parts. It doesn't matter with desktop Gmail,
but pretty much everywhere else is very hard to work with.

> > +
> > +     for (i = 1; i < spec->raw_len; i++) {
> > +             t = skip_mods_and_typedefs(btf, id, &id);
> > +             if (!t)
> > +                     return -EINVAL;
> > +
> > +             access_idx = spec->raw_spec[i];
> > +
> > +             if (btf_is_composite(t)) {
> > +                     const struct btf_member *m = (void *)(t + 1);
>
> Why (void *) instead of (const struct btf_member *)? There are a few more
> in the rest of the patch.
>

I just picked the most succinct and non-repetitive form. It's
immediately apparent which type it's implicitly converted to, so I
felt there is no need to repeat it. Also, just (void *) is much
shorter. :)


> > +                     __u32 offset;
> > +
> > +                     if (access_idx >= BTF_INFO_VLEN(t->info))
> > +                             return -EINVAL;
> > +

[...]
