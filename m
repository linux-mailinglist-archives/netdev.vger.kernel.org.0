Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD5C230255
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgG1GG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgG1GG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 02:06:56 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BCD21744;
        Tue, 28 Jul 2020 06:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595916415;
        bh=n0RZjzOmFv1P1B9VBOEM+8Yp9qeHrah7p8zJn6BDskY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0KS7ViZq+31IYo7bzL4k6zQ9QAfIBNj3DnN1zRJyIK20utz8y7decsTMTB6/Ze3mG
         uWoTzmltY5/CRZFyOXbDwQ/eGs/PmIoLNF+bb6SLTGpObXzYzgw1D9rcURquAlDuhC
         OShvMRxvzxdJSNwxXSk4grtTTvcB7TbDAQY/8zCE=
Received: by mail-lj1-f179.google.com with SMTP id q7so19830176ljm.1;
        Mon, 27 Jul 2020 23:06:55 -0700 (PDT)
X-Gm-Message-State: AOAM530ooCyb4jWqU1zFwCz7IqriYlTX5Ef0Z+iTqnR5xjKsrDbVliuD
        Vyt68yFY+SRKYXZILJnhSjU3WQRrOytcG3EqREU=
X-Google-Smtp-Source: ABdhPJySk91Ulsxd1FeJYfxZCGLLTxq2nzYp6SOGkKpiVQP5h5KXmRp8h+Z9SB9Z4GOKiYdTTxlfDP/Q6nzD7GOi9+4=
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr11847298ljc.41.1595916413870;
 Mon, 27 Jul 2020 23:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-28-guro@fb.com>
 <CAPhsuW7jWztOVeeiRNBRK4JC_MS41qUSxzEDMywb-6=Don-ndA@mail.gmail.com> <CAEf4BzaOX_gc8F20xrHxiKFxYbwULK130m1A49rnMoT7T74T3Q@mail.gmail.com>
In-Reply-To: <CAEf4BzaOX_gc8F20xrHxiKFxYbwULK130m1A49rnMoT7T74T3Q@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 23:06:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qBxWibkYMAvS0s6yLj-gijHqy9rVxSWCk5Xr+bXqtJg@mail.gmail.com>
Message-ID: <CAPhsuW5qBxWibkYMAvS0s6yLj-gijHqy9rVxSWCk5Xr+bXqtJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 27/35] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 10:47 PM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Remove rlimit-based accounting infrastructure code, which is not used
> > > anymore.
> > >
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > [...]
> > >
> > >  static void bpf_map_put_uref(struct bpf_map *map)
> > > @@ -541,7 +484,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
> > >                    "value_size:\t%u\n"
> > >                    "max_entries:\t%u\n"
> > >                    "map_flags:\t%#x\n"
> > > -                  "memlock:\t%llu\n"
> > > +                  "memlock:\t%llu\n" /* deprecated */
> >
> > I am not sure whether we can deprecate this one.. How difficult is it
> > to keep this statistics?
> >
>
> It's factually correct now, that BPF map doesn't use any memlock memory, no?

I am not sure whether memlock really means memlock for all users... I bet there
are users who use memlock to check total memory used by the map.

>
> This is actually one way to detect whether RLIMIT_MEMLOCK is necessary
> or not: create a small map, check if it's fdinfo has memlock: 0 or not
> :)

If we do show memlock=0, this is a good check...

Thanks,
Song
