Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309B33A34EB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhFJUh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:37:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhFJUh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623357360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mUSTArUf0cCNwQyD71eRlKWDfYCC76nXsXa6tP5qMA4=;
        b=iqY5XLr1c13UCrd8q1wp3Dja8WznWMtKXgvBwf7Y0F8DsfraBwRYXGphf02AXfteBQZiDl
        EywwU09adEn2sLAU8cUowmna2RAI40RqlFxqfX5vvyZ8L2bfyBYW19oSXhtLuBorT8hclX
        SkdkRwaKwy2OqXAuxTwoG1M8tVSj8RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-j2HlkI7LNhqkqvE-op6GAQ-1; Thu, 10 Jun 2021 16:35:57 -0400
X-MC-Unique: j2HlkI7LNhqkqvE-op6GAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A30098042A3;
        Thu, 10 Jun 2021 20:35:55 +0000 (UTC)
Received: from krava (unknown [10.40.195.165])
        by smtp.corp.redhat.com (Postfix) with SMTP id C688719D9D;
        Thu, 10 Jun 2021 20:35:52 +0000 (UTC)
Date:   Thu, 10 Jun 2021 22:35:51 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing
 program
Message-ID: <YMJ3p0A7kJMvMRTi@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-16-jolsa@kernel.org>
 <CAEf4BzaCWG1WtkQA6gZGvvGUhk3Si9jkZ2s6ToWowKhU4cXMuw@mail.gmail.com>
 <YMDNeve5/TColRcq@krava>
 <CAEf4Bzb-_SJpubQ4oiO4chGG8+EMUGbnChAC9tUB3FftRJzceA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb-_SJpubQ4oiO4chGG8+EMUGbnChAC9tUB3FftRJzceA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:05:39AM -0700, Andrii Nakryiko wrote:

SNIP

> > > > +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
> > > > +{
> > > > +       char *pattern = prog->sec_name + prog->sec_def->len;
> > > > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > > > +       enum bpf_attach_type attach_type;
> > > > +       int prog_fd, link_fd, cnt, err;
> > > > +       struct bpf_link *link = NULL;
> > > > +       __s32 *ids = NULL;
> > > > +
> > > > +       prog_fd = bpf_program__fd(prog);
> > > > +       if (prog_fd < 0) {
> > > > +               pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> > > > +               return ERR_PTR(-EINVAL);
> > > > +       }
> > > > +
> > > > +       err = bpf_object__load_vmlinux_btf(prog->obj, true);
> > > > +       if (err)
> > > > +               return ERR_PTR(err);
> > > > +
> > > > +       cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
> > > > +                                       BTF_KIND_FUNC, &ids);
> > >
> > > I wonder if it would be better to just support a simplified glob
> > > patterns like "prefix*", "*suffix", "exactmatch", and "*substring*"?
> > > That should be sufficient for majority of cases. For the cases where
> > > user needs something more nuanced, they can just construct BTF ID list
> > > with custom code and do manual attach.
> >
> > as I wrote earlier the function is just for the purpose of the test,
> > and we can always do the manual attach
> >
> > I don't mind adding that simplified matching you described
> 
> I use that in retsnoop and that seems to be simple but flexible enough
> for all the purposes, so far. It matches typical file globbing rules
> (with extra limitations, of course), so it's also intuitive.
> 
> But I still am not sure about making it a public API, because in a lot
> of cases you'll want a list of patterns (both allowing and denying
> different patterns), so it should be generalized to something like
> 
> btf__find_by_glob_kind(btf, allow_patterns, deny_patterns, ids)
> 
> which gets pretty unwieldy. I'd start with telling users to just
> iterate BTF on their own and apply whatever custom filtering they
> need. For simple cases libbpf will just initially support a simple and
> single glob filter declaratively (e.g, SEC("fentry.multi/bpf_*")).

ok, I'll scan retsnoop and see what I can steal ;-)

jirka

