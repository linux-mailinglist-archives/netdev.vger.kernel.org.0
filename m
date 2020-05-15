Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02DC1D52B5
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgEOO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:58:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgEOO6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589554686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XyAjxCJarjx6PEcgWq1TcjhIzDwVBN4tXt9727zeXbM=;
        b=Y4+kHwWLzSBwHFmJbgc3C6WWY0KuBIu3Lo9DZ1IG68Jtr1K0FO3LfgcSecKe0CqnAGryLP
        DllTlvpVwFif0LS0bjcidsE5JoHO7gHIuOo8khkk8km4ClMCF6RHrc6o6PhK8a6ZI/BUbM
        r6qi9rvq/+e/z+7NhaZ8agxE4hdzZKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-8evijlnxPpKrtrQY1fDEpg-1; Fri, 15 May 2020 10:57:59 -0400
X-MC-Unique: 8evijlnxPpKrtrQY1fDEpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BFA280B71E;
        Fri, 15 May 2020 14:57:57 +0000 (UTC)
Received: from krava (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with SMTP id CF7531C8;
        Fri, 15 May 2020 14:57:53 +0000 (UTC)
Date:   Fri, 15 May 2020 16:57:52 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/9] bpf: Compile bpfwl tool at kernel compilation start
Message-ID: <20200515145752.GC3565839@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-7-jolsa@kernel.org>
 <CAEf4BzYQyWAGtJtv=fvS3PRXjL66L0OJdjGf1t92a65S9pJQvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYQyWAGtJtv=fvS3PRXjL66L0OJdjGf1t92a65S9pJQvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:38:57PM -0700, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 6:31 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The bpfwl tool will be used during the vmlinux linking,
> > so it's necessary it's ready.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Makefile           | 21 +++++++++++++++++----
> >  tools/Makefile     |  3 +++
> >  tools/bpf/Makefile |  5 ++++-
> >  3 files changed, 24 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 
> >
> > +prepare-bpfwl: $(bpfwl_target)
> > +ifeq ($(SKIP_BTF_WHITELIST_GENERATION),1)
> > +       @echo "warning: Cannot use BTF whitelist checks, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
> > +endif
> 
> When we added BTF dedup and generation first time, we also made pahole
> unavailability or any error during deduplication process an error. It
> actually was very confusing to users and they often missed that BTF
> generation didn't happen, but they would notice it only at runtime
> (after a confusing debugging session).
> 
> So I wonder if it's better to make this an error instead? Just guard
> whitelist generation on whether CONFIG_DEBUG_INFO_BTF is enabled or
> not?

ok, makes sense.. I'll let it fail if there's CONFIG_DEBUG_INFO_BTF
enabled and we'are missing libelf

> 
> >  # Generate some files
> >  # ---------------------------------------------------------------------------
> >
> > diff --git a/tools/Makefile b/tools/Makefile
> > index bd778812e915..85af6ebbce91 100644
> > --- a/tools/Makefile
> > +++ b/tools/Makefile
> > @@ -67,6 +67,9 @@ cpupower: FORCE
> >  cgroup firewire hv guest bootconfig spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging: FORCE
> >         $(call descend,$@)
> >
> > +bpf/%: FORCE
> > +       $(call descend,$@)
> > +
> >  liblockdep: FORCE
> >         $(call descend,lib/lockdep)
> >
> > diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
> > index f897eeeb0b4f..d4ea2b5a2e58 100644
> > --- a/tools/bpf/Makefile
> > +++ b/tools/bpf/Makefile
> > @@ -124,5 +124,8 @@ runqslower_install:
> >  runqslower_clean:
> >         $(call descend,runqslower,clean)
> >
> > +bpfwl:
> > +       $(call descend,bpfwl)
> > +
> >  .PHONY: all install clean bpftool bpftool_install bpftool_clean \
> > -       runqslower runqslower_install runqslower_clean
> > +       runqslower runqslower_install runqslower_clean bpfwl
> 
> what about install/clean subcommands? At least clean seems like a good idea?

not sure about install, does not seem necessary for this tool,
but I'll add propagation of clean (it's defined in bpfwl already)

thanks,
jirka

