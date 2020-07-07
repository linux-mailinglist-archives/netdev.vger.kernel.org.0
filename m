Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4374D217286
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgGGPfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:35:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727079AbgGGPfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594136121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivVNSMcbJF65hKWwG/H5LBC+U8oQzuS+tuEvFIY7aUY=;
        b=G0RyWbGvmE/VfVfuOtscdbUwj9Pid3JIAveVpq5HJ15BgUuV1IeLY6WTLXWyfjcLsZo3Nr
        vpUxGRTG7Y6QbWQkDk4GrWfjmaBzLAS7WBbR81dQcoNvvWM1JczqrNz+IDlZoan1OyHkwc
        JUX3oSUhi87lAp49lNkN3hB+cRZxq+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-r9VFWpgsPyeB57z9Jd07rg-1; Tue, 07 Jul 2020 11:35:17 -0400
X-MC-Unique: r9VFWpgsPyeB57z9Jd07rg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02B9518FE887;
        Tue,  7 Jul 2020 15:35:07 +0000 (UTC)
Received: from krava (unknown [10.40.195.209])
        by smtp.corp.redhat.com (Postfix) with SMTP id DC12873FEA;
        Tue,  7 Jul 2020 15:35:02 +0000 (UTC)
Date:   Tue, 7 Jul 2020 17:35:01 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 bpf-next 4/9] bpf: Resolve BTF IDs in vmlinux image
Message-ID: <20200707153501.GF3424581@krava>
References: <20200703095111.3268961-1-jolsa@kernel.org>
 <20200703095111.3268961-5-jolsa@kernel.org>
 <CAEf4BzaDVGWpmMVuL5HG_pfRdqOVnq92EP8BSibwX7t+0FL4ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaDVGWpmMVuL5HG_pfRdqOVnq92EP8BSibwX7t+0FL4ZQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 05:38:54PM -0700, Andrii Nakryiko wrote:
> On Fri, Jul 3, 2020 at 2:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Using BTF_ID_LIST macro to define lists for several helpers
> > using BTF arguments.
> >
> > And running resolve_btfids on vmlinux elf object during linking,
> > so the .BTF_ids section gets the IDs resolved.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Makefile                 | 3 ++-
> >  kernel/trace/bpf_trace.c | 9 +++++++--
> >  net/core/filter.c        | 9 +++++++--
> >  scripts/link-vmlinux.sh  | 6 ++++++
> >  4 files changed, 22 insertions(+), 5 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 8db4fd8097e0..def58d4f9ed7 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -448,6 +448,7 @@ OBJSIZE             = $(CROSS_COMPILE)size
> >  STRIP          = $(CROSS_COMPILE)strip
> >  endif
> >  PAHOLE         = pahole
> > +RESOLVE_BTFIDS = $(srctree)/tools/bpf/resolve_btfids/resolve_btfids
> 
> Oh, this is probably wrong and why out-of-tree build fails. Why don't
> you follow how this is done for objtool?

right, should be $(objtree) in there

jirka

> 
> >  LEX            = flex
> >  YACC           = bison
> >  AWK            = awk
> > @@ -510,7 +511,7 @@ GCC_PLUGINS_CFLAGS :=
> >  CLANG_FLAGS :=
> >
> >  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
> > -export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
> > +export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
> >  export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
> >  export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ
> >  export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
> 
> [...]
> 

