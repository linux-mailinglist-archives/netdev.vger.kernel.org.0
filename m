Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E9F32B3B9
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1572884AbhCCEFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1581619AbhCBTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614711529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T21XN9MGnhH4cwAE4X6b7/PVEGlQuBJUKF8L3IcS/E4=;
        b=eM6XHhcErsb2YYMRy4Z+vf8c96BNraHpyXKLH1ZjrxdFrgtiOaxtcWzM6kPulU2LtSR6Ju
        waf/m7dCrvOy73K9i2EuoZQelUQ6Gxh0h2Mb5Z2c55uIpkOKzKZMwemhwgBV8P5jcMBDr/
        ddSKmMXTsnzhigwzjRfZBlL6V8VuJNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-9IMvX_1NNLC3Luf6vHIGCg-1; Tue, 02 Mar 2021 13:58:47 -0500
X-MC-Unique: 9IMvX_1NNLC3Luf6vHIGCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0125A835E2A;
        Tue,  2 Mar 2021 18:58:46 +0000 (UTC)
Received: from krava (unknown [10.40.195.211])
        by smtp.corp.redhat.com (Postfix) with SMTP id ED01E61F20;
        Tue,  2 Mar 2021 18:58:39 +0000 (UTC)
Date:   Tue, 2 Mar 2021 19:58:38 +0100
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
Message-ID: <YD6K3nex6MQ09u8U@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
 <YD4d+dmay+oKyiot@krava>
 <CAEf4Bzah8Au01NvtwSogpkr3etwQ3_bObj3GObG8Lb3N0DqZwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzah8Au01NvtwSogpkr3etwQ3_bObj3GObG8Lb3N0DqZwA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 10:31:41AM -0800, Andrii Nakryiko wrote:
> On Tue, Mar 2, 2021 at 3:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Mar 01, 2021 at 04:34:24PM -0800, Andrii Nakryiko wrote:
> > > On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > When testing uprobes we the test gets GEP (Global Entry Point)
> > > > address from kallsyms, but then the function is called locally
> > > > so the uprobe is not triggered.
> > > >
> > > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > > > for powerpc arch.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > @@ -2,6 +2,22 @@
> > > >  #include <test_progs.h>
> > > >  #include "test_attach_probe.skel.h"
> > > >
> > > > +#if defined(__powerpc64__)
> > > > +/*
> > > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > > > + * but then the function is called locally, so we need to adjust
> > > > + * the address to get LEP (Local Entry Point).
> > > > + */
> > > > +#define LEP_OFFSET 8
> > > > +
> > > > +static ssize_t get_offset(ssize_t offset)
> > >
> > > if we mark this function __weak global, would it work as is? Would it
> > > get an address of a global entry point? I know nothing about this GEP
> > > vs LEP stuff, interesting :)
> >
> > you mean get_base_addr? it's already global
> >
> > all the calls to get_base_addr within the object are made
> > to get_base_addr+0x8
> >
> > 00000000100350c0 <test_attach_probe>:
> >     ...
> >     100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>
> >     ...
> >     100358a8:   91 f5 ff 4b     bl      10034e38 <get_base_addr+0x8>
> >
> >
> > I'm following perf fix we had for similar issue:
> >   7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
> >
> > I'll get more info on that
> 
> My thinking was that if you mark the function as __weak, then the
> compiler is not allowed to assume that the actual implementation of
> that function will come from the same object (because it might be
> replaced by the linker later), so it has to be pessimistic and use
> global entry, no? Totally theoritizing here, of course.

ah ok.. good idea, but it's still jumping to +8 in my test

    # nm test_progs | grep get_base_addr
    0000000010034e30 W get_base_addr

    100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>

looks like it's linker, because compiler leaves just jump to next instruction

jirka

