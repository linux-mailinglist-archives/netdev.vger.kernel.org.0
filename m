Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA9300EBE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbhAVVRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730717AbhAVUsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611348430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHnt09lcoRBbSJf5TRbRYJh5AydVBQH+pUedPgapcmQ=;
        b=gV6fgRRl9Rx50sF7s7E7ivQPbnfJWPP+7eELQL+dg0Bj/Dd+M/wJo6u5HtqKRCDdvagAch
        ekZhovXRDtwKYKNY+Xo9jOMjWxRnkBBTPGqHGptNIC5TRwKPCCtXJUsMdn1ml7UDr+HlmA
        2L2MzTgml3mcp575u9/yrPeDkCR++qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-Y9wV4EuqNEqpPX5h4BLliw-1; Fri, 22 Jan 2021 15:47:06 -0500
X-MC-Unique: Y9wV4EuqNEqpPX5h4BLliw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C208F802B40;
        Fri, 22 Jan 2021 20:47:04 +0000 (UTC)
Received: from krava (unknown [10.40.192.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 904F660C6D;
        Fri, 22 Jan 2021 20:46:55 +0000 (UTC)
Date:   Fri, 22 Jan 2021 21:46:54 +0100
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
Message-ID: <20210122204654.GB70760@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:

SNIP

> > @@ -598,9 +599,36 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
> >                 fl->mcount_stop = sym->st_value;
> >  }
> >
> > +static bool elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
> > +                        int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
> > +{
> > +       if (!gelf_getsym(syms, id, sym))
> > +               return false;
> > +
> > +       *sym_sec_idx = sym->st_shndx;
> > +
> > +       if (sym->st_shndx == SHN_XINDEX) {
> > +               if (!syms_sec_idx_table)
> > +                       return false;
> > +               if (!gelf_getsymshndx(syms, syms_sec_idx_table,
> > +                                     id, sym, sym_sec_idx))
> 
> 
> gelf_getsymshndx() is supposed to work even for cases that don't use
> extended numbering, so this should work, right?
> 
> if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
>     return false;
> 

it seems you're right, gelf_getsymshndx seem to work for
both cases, I'll check


> if (sym->st_shndx == SHN_XINDEX)
>   *sym_sec_idx = sym->st_shndx;

I don't understand this..  gelf_getsymshndx will return both
symbol and proper index, no? also sym_sec_idx is already
assigned from previou call

> 
> return true;
> 
> ?
> 
> > +                       return false;
> > +       }
> > +
> > +       return true;
> > +}
> > +
> > +#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)                \
> > +       for (id = 0, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,     \
> > +                                 id, &sym, &sym_sec_idx);                      \
> > +            id < symtab->nr_syms;                                              \
> > +            id++, elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,       \
> > +                               id, &sym, &sym_sec_idx))
> 
> what do we want to do if elf_sym__get() returns error (false)? We can
> either stop or ignore that symbol, right? But currently you are
> returning invalid symbol data.
> 
> so either
> 
> for (id = 0; id < symtab->nr_syms && elf_sym__get(symtab->syms,
> symtab->syms_sec_idx_table, d, &sym, &sym_sec_idx); id++)
> 
> or
> 
> for (id = 0; id < symtab->nr_syms; id++)
>   if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table, d, &sym,
> &sym_sec_idx))

if we go ahead with skipping symbols, this one seems good

> 
> 
> But the current variant looks broken. Oh, and
> elf_symtab__for_each_symbol() is similarly broken, can you please fix
> that as well?
> 
> And this new macro should probably be in elf_symtab.h, along the
> elf_symtab__for_each_symbol.

thanks,
jirka

