Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A4D32B380
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352625AbhCCEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377071AbhCBLPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614683652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZjwZOlNFnMgEc5U9Vx9A266uXH2z9pjdV5QAx0QGYm4=;
        b=CUg0Nz543gf06F58oZzINDxk3U5ILtJP8qsaEcY2HCPg2qBwCWEBWBi6lFCH3wuUMzhcS8
        QmBplBkY6nhblokux/u8hLzO7MkFBxX/K964B7PZxg/J3CagPO0lc3Y1w1Ps30EafbTIzd
        UoVxseZqBRg8PEwiP9ScL5By509AVt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-pVWwIBewOAiSfhMSawriMA-1; Tue, 02 Mar 2021 06:14:10 -0500
X-MC-Unique: pVWwIBewOAiSfhMSawriMA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D0DFDF8A4;
        Tue,  2 Mar 2021 11:14:09 +0000 (UTC)
Received: from krava (unknown [10.40.195.211])
        by smtp.corp.redhat.com (Postfix) with SMTP id DABAF5C8AB;
        Tue,  2 Mar 2021 11:14:02 +0000 (UTC)
Date:   Tue, 2 Mar 2021 12:14:01 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <YD4d+dmay+oKyiot@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 04:34:24PM -0800, Andrii Nakryiko wrote:
> On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When testing uprobes we the test gets GEP (Global Entry Point)
> > address from kallsyms, but then the function is called locally
> > so the uprobe is not triggered.
> >
> > Fixing this by adjusting the address to LEP (Local Entry Point)
> > for powerpc arch.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > @@ -2,6 +2,22 @@
> >  #include <test_progs.h>
> >  #include "test_attach_probe.skel.h"
> >
> > +#if defined(__powerpc64__)
> > +/*
> > + * We get the GEP (Global Entry Point) address from kallsyms,
> > + * but then the function is called locally, so we need to adjust
> > + * the address to get LEP (Local Entry Point).
> > + */
> > +#define LEP_OFFSET 8
> > +
> > +static ssize_t get_offset(ssize_t offset)
> 
> if we mark this function __weak global, would it work as is? Would it
> get an address of a global entry point? I know nothing about this GEP
> vs LEP stuff, interesting :)

you mean get_base_addr? it's already global

all the calls to get_base_addr within the object are made
to get_base_addr+0x8

00000000100350c0 <test_attach_probe>:
    ...
    100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>
    ...
    100358a8:   91 f5 ff 4b     bl      10034e38 <get_base_addr+0x8>


I'm following perf fix we had for similar issue:
  7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup

I'll get more info on that

jirka

> 
> > +{
> > +       return offset + LEP_OFFSET;
> > +}
> > +#else
> > +#define get_offset(offset) (offset)
> > +#endif
> > +
> >  ssize_t get_base_addr() {
> >         size_t start, offset;
> >         char buf[256];
> > @@ -36,7 +52,7 @@ void test_attach_probe(void)
> >         if (CHECK(base_addr < 0, "get_base_addr",
> >                   "failed to find base addr: %zd", base_addr))
> >                 return;
> > -       uprobe_offset = (size_t)&get_base_addr - base_addr;
> > +       uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
> >
> >         skel = test_attach_probe__open_and_load();
> >         if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > --
> > 2.29.2
> >
> 

