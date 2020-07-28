Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EBB2300D9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgG1Ema (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgG1Em3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:42:29 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A9621775;
        Tue, 28 Jul 2020 04:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595911348;
        bh=TVFr4Hno5Uz5lBGZMRwlb/sXPSLZI9gYlrUTg3PyNv8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tFIBmTcqPidPaW1mgM5rsM2re1XqYVcCw79wKN0KlWY2Mo7Z3XOA4D1IgzRcwwTXV
         yDwVl7e7L7+LhKmdikEYG5Yz0SKWs0sIfqVGb3R7KBlRDrSkouOHA2emVle5NqI5jy
         OWLcJfSNrmCSPqFGY2jQgvuMf2LqfideuH0/jtS8=
Received: by mail-lj1-f169.google.com with SMTP id 185so9440784ljj.7;
        Mon, 27 Jul 2020 21:42:28 -0700 (PDT)
X-Gm-Message-State: AOAM530oaEewmHZxYSra81OVFMtj+SSrVLI9A06FCsIwr0bMa9KGwPFB
        N8qZhwep7bQ055ofuI/DgMm1IcJyV7l7uDglwGo=
X-Google-Smtp-Source: ABdhPJzQBksVgvuZleuJzBaS8edxqJt+GcrUBHwARGnj1dgKoxj6SnxWcM3it4alIzNKUQjYYrdcJpFuwVxwtp587nk=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr11563764ljk.27.1595911346668;
 Mon, 27 Jul 2020 21:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-2-guro@fb.com>
 <CAPhsuW49mOQYCx77jucJ_NkeYhoSxOZ_cCujBUjgMdJBy3keeg@mail.gmail.com> <20200728000802.GB352883@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200728000802.GB352883@carbon.DHCP.thefacebook.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 21:42:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7v26a74JN=vyMmhTrrEV1Wnx+MMA7bM0xV+hNen6YuEQ@mail.gmail.com>
Message-ID: <CAPhsuW7v26a74JN=vyMmhTrrEV1Wnx+MMA7bM0xV+hNen6YuEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/35] bpf: memcg-based memory accounting for
 bpf progs
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 5:08 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Jul 27, 2020 at 03:11:42PM -0700, Song Liu wrote:
> > On Mon, Jul 27, 2020 at 12:20 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Include memory used by bpf programs into the memcg-based accounting.
> > > This includes the memory used by programs itself, auxiliary data
> > > and statistics.
> > >
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > ---
> > >  kernel/bpf/core.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index bde93344164d..daab8dcafbd4 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
> > >
> > >  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
> > >  {
> > > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> > >         struct bpf_prog_aux *aux;
> > >         struct bpf_prog *fp;
> > >
> > > @@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> > >         if (fp == NULL)
> > >                 return NULL;
> > >
> > > -       aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
> > > +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
> > >         if (aux == NULL) {
> > >                 vfree(fp);
> > >                 return NULL;
> > > @@ -104,7 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> > >
> > >  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
> > >  {
> > > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> > >         struct bpf_prog *prog;
> > >         int cpu;
> > >
> > > @@ -217,7 +217,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
> > >  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
> > >                                   gfp_t gfp_extra_flags)
> > >  {
> > > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> > >         struct bpf_prog *fp;
> > >         u32 pages, delta;
> > >         int ret;
> > > --
>
> Hi Song!
>
> Thank you for looking into the patchset!
>
> >
> > Do we need similar changes in
> >
> > bpf_prog_array_copy()
> > bpf_prog_alloc_jited_linfo()
> > bpf_prog_clone_create()
> >
> > and maybe a few more?
>
> I've tried to follow the rlimit-based accounting, so those objects which were
> skipped are mostly skipped now and vice versa. The main reason for that is
> simple: I don't know many parts of bpf code well enough to decide whether
> we need accounting or not.
>
> In general with memcg-based accounting we can easily cover places which were
> not covered previously: e.g. the memory used by the verifier. But I guess it's
> better to do it case-by-case.
>
> But if you're aware of any big objects which should be accounted for sure,
> please, let me know.

Thanks for the explanation. I think we can do one-to-one migration to
memcg-based accounting for now.

Song
