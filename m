Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60782FD0CA
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbhATMwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733288AbhATM2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:28:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611145623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RVtx5OM9lrNbMwajYs+XPwUc9ia/t8QLsSQbiLfcync=;
        b=Byi/47FITHQJHVutreZyzhpzjq72MrPubk4tDeOATKh4tmpWx6MSvwTTMZrqD3hFyPa4HZ
        NYsEvaW/cqx3vB3gX/gNkLAcy2m/blVbv5NKWoGXxbfbyQzOLyx51EZBO70TVXoBDwBatv
        xUSmoh+8GeYz5GztSkyUoDeAMSx2TuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-sHXGSNbeM1yDDOqFGH6ofQ-1; Wed, 20 Jan 2021 07:26:59 -0500
X-MC-Unique: sHXGSNbeM1yDDOqFGH6ofQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D2D8180A093;
        Wed, 20 Jan 2021 12:26:57 +0000 (UTC)
Received: from krava (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with SMTP id 15411614FF;
        Wed, 20 Jan 2021 12:26:46 +0000 (UTC)
Date:   Wed, 20 Jan 2021 13:26:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Use string table index from index
 table if needed
Message-ID: <20210120122646.GC1760208@krava>
References: <20210119221220.1745061-1-jolsa@kernel.org>
 <20210119221220.1745061-4-jolsa@kernel.org>
 <CAEf4BzZNPJZBfz7Ga9MGvGGYge4MCP1O16JVuFjdzu-bCEQFLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZNPJZBfz7Ga9MGvGGYge4MCP1O16JVuFjdzu-bCEQFLQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 05:22:08PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 19, 2021 at 2:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > For very large ELF objects (with many sections), we could
> > get special value SHN_XINDEX (65535) for elf object's string
> > table index - e_shstrndx.
> >
> > In such case we need to call elf_getshdrstrndx to get the
> > proper string table index.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 3c3f2bc6c652..4fe987846bc0 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -863,6 +863,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >         Elf_Scn *scn = NULL;
> >         Elf *elf = NULL;
> >         GElf_Ehdr ehdr;
> > +       size_t shstrndx;
> >
> >         if (elf_version(EV_CURRENT) == EV_NONE) {
> >                 pr_warn("failed to init libelf for %s\n", path);
> > @@ -887,7 +888,16 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >                 pr_warn("failed to get EHDR from %s\n", path);
> >                 goto done;
> >         }
> > -       if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
> > +
> > +       /*
> > +        * Get string table index from extended section index
> > +        * table if needed.
> > +        */
> > +       shstrndx = ehdr.e_shstrndx;
> > +       if (shstrndx == SHN_XINDEX && elf_getshdrstrndx(elf, &shstrndx))
> > +               goto done;
> 
> just use elf_getshdrstrndx() unconditionally, it works for extended
> and non-extended numbering (see libbpf.c).

I did not see that, ok

thanks,
jirka

> 
> > +
> > +       if (!elf_rawdata(elf_getscn(elf, shstrndx), NULL)) {
> >                 pr_warn("failed to get e_shstrndx from %s\n", path);
> >                 goto done;
> >         }
> > @@ -902,7 +912,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >                                 idx, path);
> >                         goto done;
> >                 }
> > -               name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
> > +               name = elf_strptr(elf, shstrndx, sh.sh_name);
> >                 if (!name) {
> >                         pr_warn("failed to get section(%d) name from %s\n",
> >                                 idx, path);
> > --
> > 2.27.0
> >
> 

