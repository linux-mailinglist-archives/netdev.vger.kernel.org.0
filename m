Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426D23017D4
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 19:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAWSxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 13:53:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbhAWSx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 13:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611427920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oLnuKKVFcP+jX7dsGpygkLnCbNNWlvIsEBxJq1BWIw=;
        b=bbMl4ld7fPElROlT0rXIWcOklW89ipdUEoCKYtHbVvrDGmRTYWSDinyP7xBq4nvlaoaWjb
        18QXfIgCEGvGUWX8XYL61FXzLyoE6xqTfChywmvC3o/X01bD713SIqT4vjrO3OAoFiAZos
        zgo6wSPAEN1rt56qWwry+375O1Zv5/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-RnZdjAXlMzO42_QSCJ_OOA-1; Sat, 23 Jan 2021 13:51:56 -0500
X-MC-Unique: RnZdjAXlMzO42_QSCJ_OOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06CA4806661;
        Sat, 23 Jan 2021 18:51:54 +0000 (UTC)
Received: from krava (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id C73AF10016FF;
        Sat, 23 Jan 2021 18:51:44 +0000 (UTC)
Date:   Sat, 23 Jan 2021 19:51:43 +0100
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
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210123185143.GA117714@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
 <20210122204654.GB70760@krava>
 <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:55:51PM -0800, Andrii Nakryiko wrote:
> On Fri, Jan 22, 2021 at 12:47 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > @@ -598,9 +599,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> > > >                 fl->mcount_stop = sym->st_value;
> > > >  }
> > > >
> > > > +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> > > > +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
> > > > +{
> > > > +       if (!gelf_getsym(syms, id, sym))
> > > > +               return false;
> > > > +
> > > > +       *sym_sec_idx = sym->st_shndx;
> > > > +
> > > > +       if (sym->st_shndx == SHN_XINDEX) {
> > > > +               if (!syms_sec_idx_table)
> > > > +                       return false;
> > > > +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> > > > +                                     id, sym, sym_sec_idx))
> > >
> > >
> > > gelf_getsymshndx() is supposed to work even for cases that don't use
> > > extended numbering, so this should work, right?
> > >
> > > if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
> > >     return false;
> > >
> >
> > it seems you're right, gelf_getsymshndx seem to work for
> > both cases, I'll check
> >
> >
> > > if (sym->st_shndx == SHN_XINDEX)
> > >   *sym_sec_idx = sym->st_shndx;
> >
> > I don't understand this..  gelf_getsymshndx will return both
> > symbol and proper index, no? also sym_sec_idx is already
> > assigned from previou call
> 
> Reading (some) implementation of gelf_getsymshndx() that I found
> online, it won't set sym_sec_idx, if the symbol *doesn't* use extended
> numbering. But it will still return symbol data. So to return the

the latest upstream code seems to set it always,
but I agree we should be careful

Mark, any insight in here? thanks

> section index in all cases, we need to check again *after* we got
> symbol, and if it's not extended, then set index manually.

hum, then we should use '!=', right?

  if (sym->st_shndx != SHN_XINDEX)
    *sym_sec_idx = sym->st_shndx;

SNIP

> > > so either
> > >
> > > for (id = 0; id < symtab->nr_syms && elf_sym__get(symtab->syms,
> > > symtab->syms_sec_idx_table, d, &sym, &sym_sec_idx); id++)
> > >
> > > or
> > >
> > > for (id = 0; id < symtab->nr_syms; id++)
> > >   if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table, d, &sym,
> > > &sym_sec_idx))
> >
> > if we go ahead with skipping symbols, this one seems good
> 
> I think skipping symbols is nicer. If ELF is totally broken, then all
> symbols are going to be ignored anyway. If it's some one-off issue for
> a specific symbol, we'll just ignore it (unfortunately, silently).

agreed, I'll use this

thanks,
jirka

