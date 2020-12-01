Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892502CAC6E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404267AbgLATd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLATd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:33:29 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8E220679;
        Tue,  1 Dec 2020 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606851168;
        bh=a74wrcvSdNVouX66ceR1u93Jt6L/lg6Baa0mbtbwhN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IrUm2r/Eami47ViRMKJ4EU634PV4FUp0Q1Lvu3vP1TXFiqxWFs0OcJ7SXMA5dzz+w
         BwY7vio9ApsRvMQJBgkLxRHixU/wh5H5rz9srfZ99tI76frObamA2fuNgZQPNMfnBu
         HxmXCzYVuNa2h5ph+EhTu8WIQM42tuCOCAJOu3qc=
Date:   Tue, 1 Dec 2020 21:32:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Edward Srouji <edwards@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] kbuild: Restore ability to build out-of-tree
 modules
Message-ID: <20201201193243.GG3286@unreal>
References: <20201201143700.719828-1-leon@kernel.org>
 <CAEf4BzaSL+rmVYNipsfczsF2v684KOhZgFPtUG9opvk7d6zruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSL+rmVYNipsfczsF2v684KOhZgFPtUG9opvk7d6zruA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:01:23AM -0800, Andrii Nakryiko wrote:
> On Tue, Dec 1, 2020 at 6:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The out-of-tree modules are built without vmlinux target and request
> > to recompile that target unconditionally causes to the following
> > compilation error.
> >
> > [root@server kernel]# make
> > <..>
> > make -f ./scripts/Makefile.modpost
> > make -f ./scripts/Makefile.modfinal
> > make[3]: *** No rule to make target 'vmlinux', needed by '/my_temp/out-of-tree-module/kernel/test.ko'.  Stop.
> > make[2]: *** [scripts/Makefile.modpost:117: __modpost] Error 2
> > make[1]: *** [Makefile:1703: modules] Error 2
> > make[1]: Leaving directory '/usr/src/kernels/5.10.0-rc5_for_upstream_base_2020_11_29_11_34'
> > make: *** [Makefile:80: modules] Error 2
> >
> > As a solution separate between build paths that has vmlinux target and paths without.
> >
> > Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
> > Reported-by: Edward Srouji <edwards@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
>
> e732b538f455 ("kbuild: Skip module BTF generation for out-of-tree
> external modules") ([0]) was supposed to take care of this. Did you
> try it?

My tree doesn't have this patch yet, so my questions can be stupid:
1. Will it print "Skipping BTF generation for ... due to unavailability
of vmlinux" line if my .config doesn't have "CONFIG_DEBUG_INFO_BTF_MODULES"?
I hope it is not.
2. Reliance on existence of vmlinux can be problematic, no one promises
us that "make clean" is called before and there are no other leftovers
from previous builds.

And in general, the idea that such invasive change in build infrastructure
came without any Ack from relevant maintainers doesn't look right to me.

Thanks

>
>   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201121070829.2612884-1-andrii@kernel.org/
>
>
> > Not proficient enough in Makefile, but it fixes the issue.
> > ---
> >  scripts/Makefile.modfinal | 5 +++++
> >  scripts/Makefile.modpost  | 4 ++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > index 02b892421f7a..8a7d0604e7d0 100644
> > --- a/scripts/Makefile.modfinal
> > +++ b/scripts/Makefile.modfinal
> > @@ -48,9 +48,14 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
> >         $(cmd);                                                              \
> >         printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
> >
> > +ifdef MODPOST_VMLINUX
> >  # Re-generate module BTFs if either module's .ko or vmlinux changed
> >  $(modules): %.ko: %.o %.mod.o scripts/module.lds vmlinux FORCE
> >         +$(call if_changed_except,ld_ko_o,vmlinux)
> > +else
> > +$(modules): %.ko: %.o %.mod.o scripts/module.lds FORCE
> > +       +$(call if_changed_except,ld_ko_o)
> > +endif
> >  ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> >         +$(if $(newer-prereqs),$(call cmd,btf_ko))
> >  endif
> > diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> > index f54b6ac37ac2..f5aa5b422ad7 100644
> > --- a/scripts/Makefile.modpost
> > +++ b/scripts/Makefile.modpost
> > @@ -114,8 +114,12 @@ targets += $(output-symdump)
> >
> >  __modpost: $(output-symdump)
> >  ifneq ($(KBUILD_MODPOST_NOFINAL),1)
> > +ifdef MODPOST_VMLINUX
> > +       $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal MODPOST_VMLINUX=1
> > +else
> >         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal
> >  endif
> > +endif
> >
> >  PHONY += FORCE
> >  FORCE:
> > --
> > 2.28.0
> >
