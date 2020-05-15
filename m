Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E3E1D52B7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgEOO6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:58:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726144AbgEOO6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589554729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p+H7G6hzBr30+LKXx0+swEd83bo5aBgRovoEz/J8OyM=;
        b=Dx24HSJW0UUfD8grgUq5VJ6YU4i4TcEgyWZ5UCEnJzZuwfmhdkmdQGGjw6lrxz11I+ynaG
        DwO+/d5f2N6Srhdgx4upiCZAnMsjUpEnbJAyCFe0wQq2z9YbsJNVVhEgg5dMoKpXBG7in6
        E1JPIcZoc3mhWhGhdOP1LBGc+P0tOYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-yHP43npAOQ2idbyzQ3HAaQ-1; Fri, 15 May 2020 10:58:46 -0400
X-MC-Unique: yHP43npAOQ2idbyzQ3HAaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E14A80183C;
        Fri, 15 May 2020 14:58:44 +0000 (UTC)
Received: from krava (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with SMTP id AD1CC1001B07;
        Fri, 15 May 2020 14:58:40 +0000 (UTC)
Date:   Fri, 15 May 2020 16:58:39 +0200
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
Subject: Re: [PATCH 3/9] bpf: Add bpfwl tool to construct bpf whitelists
Message-ID: <20200515145839.GD3565839@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-4-jolsa@kernel.org>
 <CAEf4BzY=GgQ0jaTg2BLfguZ+sPjT==qgoMFeB85utGWFj5qtPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY=GgQ0jaTg2BLfguZ+sPjT==qgoMFeB85utGWFj5qtPA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:20:19PM -0700, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 6:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > This tool takes vmlinux object and whitelist directory on input
> > and produces C source object with BPF whitelist data.
> >
> > The vmlinux object needs to have a BTF information compiled in.
> >
> > The whitelist directory is expected to contain files with helper
> > names, where each file contains list of functions/probes that
> > helper is allowed to be called from - whitelist.
> >
> > The bpfwl tool has following output:
> >
> >   $ bpfwl vmlinux dir
> >   unsigned long d_path[] __attribute__((section(".BTF_whitelist_d_path"))) = \
> >   { 24507, 24511, 24537, 24539, 24545, 24588, 24602, 24920 };
> 
> why long instead of int? btf_id is 4-byte one.

ok, int it is

> 
> >
> > Each array are sorted BTF ids of the functions provided in the
> > helper file.
> >
> > Each array will be compiled into kernel and used during the helper
> > check in verifier.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/bpfwl/Build    |  11 ++
> >  tools/bpf/bpfwl/Makefile |  60 +++++++++
> >  tools/bpf/bpfwl/bpfwl.c  | 285 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 356 insertions(+)
> >  create mode 100644 tools/bpf/bpfwl/Build
> >  create mode 100644 tools/bpf/bpfwl/Makefile
> >  create mode 100644 tools/bpf/bpfwl/bpfwl.c
> 
> Sorry, I didn't want to nitpick on naming, honestly, but I think this
> is actually harmful in the long run. bpfwl is incomprehensible name,
> anyone reading link script would be like "what the hell is bpfwl?" Why
> not bpf_build_whitelist or something with "whitelist" spelled out in
> full?

hum, will pick some more generic name

> 
> >
> > diff --git a/tools/bpf/bpfwl/Build b/tools/bpf/bpfwl/Build
> > new file mode 100644
> > index 000000000000..667e30d6ce79
> > --- /dev/null
> > +++ b/tools/bpf/bpfwl/Build
> > @@ -0,0 +1,11 @@
> > +bpfwl-y += bpfwl.o
> > +bpfwl-y += rbtree.o
> > +bpfwl-y += zalloc.o
> > +
> 
> [...]
> 
> > +
> > +struct func {
> > +       char                    *name;
> > +       unsigned long            id;
> 
> as mentioned above, btf_id is 4 byte

ok, changing to int

> 
> > +       struct rb_node           rb_node;
> > +       struct list_head         list[];
> > +};
> > +
> 
> [...]
> 
> > +       btf = btf__parse_elf(vmlinux, NULL);
> > +       err = libbpf_get_error(btf);
> > +       if (err) {
> > +               fprintf(stderr, "FAILED: load BTF from %s: %s",
> > +                       vmlinux, strerror(err));
> > +               return -1;
> > +       }
> > +
> > +       nr = btf__get_nr_types(btf);
> > +
> > +       /* Iterate all the BTF types and resolve all the function IDs. */
> > +       for (id = 0; id < nr; id++) {
> 
> It has to be `for (id = 1; id <= nr; id++)`. 0 is VOID type and not
> included into nr_types. I know it's confusing, but.. life :)

right, will change

thanks,
jirka

> 
> > +               const struct btf_type *type;
> > +               struct func *func;
> > +               const char *str;
> > +
> > +               type = btf__type_by_id(btf, id);
> > +               if (!type)
> > +                       continue;
> > +
> 
> [...]
> 

