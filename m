Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F8B8687E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbfHHSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHSLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 14:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE3821743;
        Thu,  8 Aug 2019 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565287866;
        bh=VQIOY0vBzuYscrqn68EABa55zxTZLbGjt3/l6q9cOAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xdrkj+0hZtP1qj4oUD1AxSDlDuoiKG8VcdttnCp4FelzfZoC5uDp0WRnRMAyxMQKE
         jxGWs49FzLgOld8rhoJP/En/UFXtE8Xaobwq2BVzMH5PBJ07EfuCUsjuQYcWQ+ikb8
         rNwGD0At0fsoxKJO2Ncnb9rM9MEIarZLVK+AJQt0=
Date:   Thu, 8 Aug 2019 20:11:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 bpf-next] btf: expose BTF info through sysfs
Message-ID: <20190808181104.GA31357@kroah.com>
References: <20190808003215.1462821-1-andriin@fb.com>
 <89a6e282-0250-4264-128d-469be99073e9@fb.com>
 <20190808060812.GA25150@kroah.com>
 <CAEf4BzaWtumTrc7h1t3w8hA1L8mVo2Cm0B+eLSe4eSghFAu3iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaWtumTrc7h1t3w8hA1L8mVo2Cm0B+eLSe4eSghFAu3iw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 10:53:44AM -0700, Andrii Nakryiko wrote:
> On Wed, Aug 7, 2019 at 11:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Aug 08, 2019 at 04:24:25AM +0000, Yonghong Song wrote:
> > >
> > >
> > > On 8/7/19 5:32 PM, Andrii Nakryiko wrote:
> > > > Make .BTF section allocated and expose its contents through sysfs.
> >
> > Was this original patch not on bpf@vger?  I can't find it in my
> > archive.  Anyway...
> >
> > > > /sys/kernel/btf directory is created to contain all the BTFs present
> > > > inside kernel. Currently there is only kernel's main BTF, represented as
> > > > /sys/kernel/btf/kernel file. Once kernel modules' BTFs are supported,
> > > > each module will expose its BTF as /sys/kernel/btf/<module-name> file.
> >
> > Why are you using sysfs for this?  Who uses "BTF"s?  Are these debugging
> > images that only people working on developing bpf programs are going to
> > need, or are these things that you are going to need on a production
> > system?
> 
> We need it in production system. One immediate and direct use case is
> BPF CO-RE (Compile Once - Run Everywhere), which aims to allow to
> pre-compile BPF applications (even those that read internal kernel
> structures) using any local kernel headers, and then distribute and
> run them in binary form on all target production machines without
> dependencies on kernel headers and having Clang on target machine to
> compile C to BPF IR. Libbpf is doing all those adjustments/relocations
> based on kernel's actual BTF. See [0] for a summary and slides, if you
> curious to learn more.
> 
>   [0] http://vger.kernel.org/bpfconf2019.html#session-2

Ok, then a binary sysfs file is fine, no objection from me.

> > I ask as maybe debugfs is the best place for this if they are not needed
> > on production systems.
> >
> >
> > > >
> > > > Current approach relies on a few pieces coming together:
> > > > 1. pahole is used to take almost final vmlinux image (modulo .BTF and
> > > >     kallsyms) and generate .BTF section by converting DWARF info into
> > > >     BTF. This section is not allocated and not mapped to any segment,
> > > >     though, so is not yet accessible from inside kernel at runtime.
> > > > 2. objcopy dumps .BTF contents into binary file and subsequently
> > > >     convert binary file into linkable object file with automatically
> > > >     generated symbols _binary__btf_kernel_bin_start and
> > > >     _binary__btf_kernel_bin_end, pointing to start and end, respectively,
> > > >     of BTF raw data.
> > > > 3. final vmlinux image is generated by linking this object file (and
> > > >     kallsyms, if necessary). sysfs_btf.c then creates
> > > >     /sys/kernel/btf/kernel file and exposes embedded BTF contents through
> > > >     it. This allows, e.g., libbpf and bpftool access BTF info at
> > > >     well-known location, without resorting to searching for vmlinux image
> > > >     on disk (location of which is not standardized and vmlinux image
> > > >     might not be even available in some scenarios, e.g., inside qemu
> > > >     during testing).
> > > >
> > > > Alternative approach using .incbin assembler directive to embed BTF
> > > > contents directly was attempted but didn't work, because sysfs_proc.o is
> > > > not re-compiled during link-vmlinux.sh stage. This is required, though,
> > > > to update embedded BTF data (initially empty data is embedded, then
> > > > pahole generates BTF info and we need to regenerate sysfs_btf.o with
> > > > updated contents, but it's too late at that point).
> > > >
> > > > If BTF couldn't be generated due to missing or too old pahole,
> > > > sysfs_btf.c handles that gracefully by detecting that
> > > > _binary__btf_kernel_bin_start (weak symbol) is 0 and not creating
> > > > /sys/kernel/btf at all.
> > > >
> > > > v1->v2:
> > > > - allow kallsyms stage to re-use vmlinux generated by gen_btf();
> > > >
> > > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >   kernel/bpf/Makefile     |  3 +++
> > > >   kernel/bpf/sysfs_btf.c  | 52 ++++++++++++++++++++++++++++++++++++++
> > > >   scripts/link-vmlinux.sh | 55 +++++++++++++++++++++++++++--------------
> > > >   3 files changed, 91 insertions(+), 19 deletions(-)
> > > >   create mode 100644 kernel/bpf/sysfs_btf.c
> >
> > First rule, you can't create new sysfs files without a matching
> > Documentation/ABI/ set of entries.  Please do that for the next version
> > of this patch so we can properly check to see if what you are
> > documenting lines up with the code.  Otherwise we just have to guess as
> > to what the entries you are creating actually do.
> 
> Yep, sure, I wasn't aware, will add in v3.

thanks.

> > > > +static int __init btf_kernel_init(void)
> > > > +{
> > > > +   if (!_binary__btf_kernel_bin_start)
> > > > +           return 0;
> > > > +
> > > > +   btf_kernel_attr.size = _binary__btf_kernel_bin_end -
> > > > +                          _binary__btf_kernel_bin_start;
> > > > +
> > > > +   return sysfs_create_group(kernel_kobj, &btf_group_attr);
> >
> > You are nesting directories here without a "real" kobject in the middle.
> > Are you _sure_ you want to do that?  It's going to get really tricky
> > later on based on your comments above about creating multiple files in
> > that directory over time once "modules" are allowed.
> 
> My thinking was that when we have BTF for modules, I'll need to do
> some code adjustments anyway, at which point it will be more clear how
> we want to structure that. But I can add explicit kobject as static
> variable right now, no problems. Later on we probably will just switch
> it to be exported, so that modules can self-register/unregister their
> BTFs autonomously.

A "real" kobject to start with here would probably be best.  Keeps
things simpler later as well.

thanks,

greg k-h
