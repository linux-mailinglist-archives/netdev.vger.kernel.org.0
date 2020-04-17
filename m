Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2BE1AE006
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgDQOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgDQOhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 10:37:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E202087E;
        Fri, 17 Apr 2020 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587134243;
        bh=NBldiNAUk7Adx+NMwtOxd+CbV2wDWhSuvlgeFgyk5iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q3RZ3wHapGFwzEFdEz5mKSBoUaCVqzOpQFxeJ0HTYIg19g8r5F741vRtxFpeLn9g/
         7eGE+n0euc3US9CCrzhAcK8kmMSUWv5XKYwDCdiGqsq4BEkKDp+Uz3Z9IMDU4Ir0St
         qR/6Omwl1XBu8cBkm/o+mS7PkChA7gMdTzAi9TJY=
Date:   Fri, 17 Apr 2020 17:37:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Borislav Petkov <bp@suse.de>,
        Jessica Yu <jeyu@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v1 4/4] kernel/module: Hide vermagic header file
 from general use
Message-ID: <20200417143718.GA3083@unreal>
References: <20200415133648.1306956-1-leon@kernel.org>
 <20200415133648.1306956-5-leon@kernel.org>
 <CAK7LNASacDbi-2sQ9uk+37gaU5J6p7YrucyWbzxYP1wQiU+NZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7LNASacDbi-2sQ9uk+37gaU5J6p7YrucyWbzxYP1wQiU+NZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 09:07:10PM +0900, Masahiro Yamada wrote:
> On Wed, Apr 15, 2020 at 10:37 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > VERMAGIC* definitions are not supposed to be used by the drivers,
> > see this [1] bug report, so simply move this header file to be visible
> > to kernel/* and scripts files only.
> >
> > In-tree module build:
> > ➜  kernel git:(vermagic) ✗ make clean
> > ➜  kernel git:(vermagic) ✗ make M=drivers/infiniband/hw/mlx5
> > ➜  kernel git:(vermagic) ✗ modinfo drivers/infiniband/hw/mlx5/mlx5_ib.ko
> > filename:       /images/leonro/src/kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
> > <...>
> > vermagic:       5.6.0+ SMP mod_unload modversions
> >
> > Out-of-tree module build:
> > ➜  mlx5 make -C /images/leonro/src/kernel clean M=/tmp/mlx5
> > ➜  mlx5 make -C /images/leonro/src/kernel M=/tmp/mlx5
> > ➜  mlx5 modinfo /tmp/mlx5/mlx5_ib.ko
> > filename:       /tmp/mlx5/mlx5_ib.ko
> > <...>
> > vermagic:       5.6.0+ SMP mod_unload modversions
> >
> > [1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
> > Reported-by: Borislav Petkov <bp@suse.de>
> > Acked-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  kernel/module.c                      | 2 +-
> >  {include/linux => kernel}/vermagic.h | 0
> >  scripts/mod/modpost.c                | 2 +-
> >  3 files changed, 2 insertions(+), 2 deletions(-)
> >  rename {include/linux => kernel}/vermagic.h (100%)
> >
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 3447f3b74870..fce06095d341 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -29,7 +29,6 @@
> >  #include <linux/moduleparam.h>
> >  #include <linux/errno.h>
> >  #include <linux/err.h>
> > -#include <linux/vermagic.h>
> >  #include <linux/notifier.h>
> >  #include <linux/sched.h>
> >  #include <linux/device.h>
> > @@ -55,6 +54,7 @@
> >  #include <linux/audit.h>
> >  #include <uapi/linux/module.h>
> >  #include "module-internal.h"
> > +#include "vermagic.h"
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/module.h>
> > diff --git a/include/linux/vermagic.h b/kernel/vermagic.h
> > similarity index 100%
> > rename from include/linux/vermagic.h
> > rename to kernel/vermagic.h
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 5c3c50c5ec52..91f86261bcfe 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -2252,7 +2252,7 @@ static void add_header(struct buffer *b, struct module *mod)
> >          * inherit the definitions.
> >          */
> >         buf_printf(b, "#include <linux/build-salt.h>\n");
> > -       buf_printf(b, "#include <linux/vermagic.h>\n");
> > +       buf_printf(b, "#include <../kernel/vermagic.h>\n");
>
>
> I hate this.

Why?

The "ifndef" solution won't achieve the main goal of this patch -
completely disallow usage of vermagic.h. Every kernel developer
knows that headers outside of include/ folder are not meant to be
used.

Once the vermagic.h inside kernel/ folder no one will even try
to include it.

But with new define, all reviewers will need to be aware that they
don't suppose to see it in "regular" patches.

So, instead of making everything clear by being explicit, we will
rely on developers + review + checkpatch and implicit logic.

>
>
> #error can break the build if the header is included in a wrong way.
>
> For example, include/acpi/platform/aclinux.h
>
>
>
> I prefer something like this if a big hammer is needed here.

If it is the only way to progress, I will change the series to use
this variant, however I don't like it both technically and aesthetically
by seeing machinery file with extremely narrow scope inside general include
header.

>
> diff --git a/include/linux/vermagic.h b/include/linux/vermagic.h
> index 9aced11e9000..d69fa4661715 100644
> --- a/include/linux/vermagic.h
> +++ b/include/linux/vermagic.h
> @@ -1,4 +1,9 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef INCLUDE_VERMAGIC
> +#error "This header can be included from kernel/module.c or *.mod.c"
> +#endif
> +
>  #include <generated/utsrelease.h>
>
>  /* Simply sanity version stamp for modules. */
> diff --git a/kernel/module.c b/kernel/module.c
> index 646f1e2330d2..8833e848b73c 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -4,6 +4,9 @@
>     Copyright (C) 2001 Rusty Russell, 2002, 2010 Rusty Russell IBM.
>
>  */
> +
> +#define INCLUDE_VERMAGIC
> +
>  #include <linux/export.h>
>  #include <linux/extable.h>
>  #include <linux/moduleloader.h>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 5c3c50c5ec52..7f7d4ee7b652 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -2251,6 +2251,7 @@ static void add_header(struct buffer *b, struct
> module *mod)
>          * Include build-salt.h after module.h in order to
>          * inherit the definitions.
>          */
> +       buf_printf(b, "#define INCLUDE_VERMAGIC\n");
>         buf_printf(b, "#include <linux/build-salt.h>\n");
>         buf_printf(b, "#include <linux/vermagic.h>\n");
>         buf_printf(b, "#include <linux/compiler.h>\n");
>
>
>
>
> --
> Best Regards
> Masahiro Yamada
