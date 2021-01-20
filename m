Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508822FD0C7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbhATMwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733092AbhATM1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611145544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jEVpAUjo+5KKJ8yncbdHPcd81vYw6ZfUlS30rsBZQGI=;
        b=TiEf1xVebdztUGOiO+0WVWHF3dlTDyQOlyvrE6T6UER7Zd7ELKi+64wGtpJLO2PMWeYa6i
        /7UuAt+ZGsTD0HC/4MY5Y/+/qUmQu4V8a8WAh8GcLFTPddc5BvICxGWsTCTTP3d/j918ra
        /MaRssYR9y5tAqIqgbYsEKHXJBv4JMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-xzc3Sq8DPZ6LqVkoVC9vfQ-1; Wed, 20 Jan 2021 07:25:40 -0500
X-MC-Unique: xzc3Sq8DPZ6LqVkoVC9vfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10FB3180A093;
        Wed, 20 Jan 2021 12:25:38 +0000 (UTC)
Received: from krava (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5EB001002382;
        Wed, 20 Jan 2021 12:25:27 +0000 (UTC)
Date:   Wed, 20 Jan 2021 13:25:26 +0100
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
Message-ID: <20210120122526.GB1760208@krava>
References: <20210119221220.1745061-1-jolsa@kernel.org>
 <20210119221220.1745061-3-jolsa@kernel.org>
 <CAEf4BzY323ioVnsDqih5kKo9Q23rOrLV6Lh-Ms+jRqAYJrCgCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY323ioVnsDqih5kKo9Q23rOrLV6Lh-Ms+jRqAYJrCgCg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 06:03:28PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 19, 2021 at 2:16 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > For very large ELF objects (with many sections), we could
> > get special value SHN_XINDEX (65535) for symbol's st_shndx.
> >
> > This patch is adding code to detect the optional extended
> > section index table and use it to resolve symbol's section
> > index id needed.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  btf_encoder.c | 18 ++++++++++++++++++
> >  elf_symtab.c  | 31 ++++++++++++++++++++++++++++++-
> >  elf_symtab.h  |  1 +
> >  3 files changed, 49 insertions(+), 1 deletion(-)
> >
> > diff --git a/btf_encoder.c b/btf_encoder.c
> > index 5557c9efd365..2ab6815dc2b3 100644
> > --- a/btf_encoder.c
> > +++ b/btf_encoder.c
> > @@ -609,6 +609,24 @@ static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
> >
> >         /* search within symtab for percpu variables */
> >         elf_symtab__for_each_symbol(btfe->symtab, core_id, sym) {
> 
> How about we introduce elf_symtab__for_each_symbol variant that uses
> gelf_getsymshndx undercover and returns a real section index as the
> 4th macro argument?

ok, that's good idea

> 
> > +               struct elf_symtab *symtab = btfe->symtab;
> > +
> > +               /*
> > +                * Symbol's st_shndx needs to be translated with the
> > +                * extended section index table.
> > +                */
> > +               if (sym.st_shndx == SHN_XINDEX) {
> > +                       Elf32_Word xndx;
> > +
> > +                       if (!symtab->syms_shndx) {
> > +                               fprintf(stderr, "SHN_XINDEX found, but no symtab shndx section.\n");
> > +                               return -1;
> > +                       }
> > +
> > +                       if (gelf_getsymshndx(symtab->syms, symtab->syms_shndx, core_id, &sym, &xndx))
> > +                               sym.st_shndx = xndx;
> 
> This bit makes me really nervous and it looks very unclean, which is
> why I think providing correct section index as part of iterator macro
> is better approach. And all this code would just go away.

ok

> 
> > +               }
> > +
> >                 if (collect_percpu_vars && collect_percpu_var(btfe, &sym))
> >                         return -1;
> >                 if (collect_function(btfe, &sym))
> > diff --git a/elf_symtab.c b/elf_symtab.c
> > index 741990ea3ed9..c1def0189652 100644
> > --- a/elf_symtab.c
> > +++ b/elf_symtab.c
> > @@ -17,11 +17,13 @@
> >
> >  struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
> >  {
> > +       size_t index;
> > +
> >         if (name == NULL)
> >                 name = ".symtab";
> >
> >         GElf_Shdr shdr;
> > -       Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, NULL);
> > +       Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, &index);
> >
> >         if (sec == NULL)
> >                 return NULL;
> > @@ -29,6 +31,8 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
> >         if (gelf_getshdr(sec, &shdr) == NULL)
> >                 return NULL;
> >
> > +       int xindex = elf_scnshndx(sec);
> 
> move this closer to where you check (xindex > 0)? Can you please leave
> a small comment that this returns extended section index table's
> section index (I know, this is horrible), if it exists. It's
> notoriously hard to find anything about libelf's API, especially for
> obscure APIs like this.

it's here because 'sec' gets overwitten shortly on with string table
I'll add some comment

> 
> > +
> >         struct elf_symtab *symtab = malloc(sizeof(*symtab));
> >         if (symtab == NULL)
> >                 return NULL;
> > @@ -49,6 +53,31 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
> >         if (symtab->symstrs == NULL)
> >                 goto out_free_name;
> >
> > +       /*
> > +        * The .symtab section has optional extended section index
> > +        * table, load its data so it can be used to resolve symbol's
> > +        * section index.
> > +        **/
> > +       if (xindex > 0) {
> > +               GElf_Shdr shdr_shndx;
> > +               Elf_Scn *sec_shndx;
> > +
> > +               sec_shndx = elf_getscn(elf, xindex);
> > +               if (sec_shndx == NULL)
> > +                       goto out_free_name;
> > +
> > +               if (gelf_getshdr(sec_shndx, &shdr_shndx) == NULL)
> > +                       goto out_free_name;
> > +
> > +               /* Extra check to verify it belongs to the .symtab */
> > +               if (index != shdr_shndx.sh_link)
> > +                       goto out_free_name;
> 
> you can also verify that section type is SHT_SYMTAB_SHNDX

ok

> 
> > +
> > +               symtab->syms_shndx = elf_getdata(elf_getscn(elf, xindex), NULL);
> 
> my mind breaks looking at all those shndxs, especially in this case

you better not look at elfutils code then ;-)

> where it's not a section number, but rather data. How about we call it
> something like symtab->syms_sec_idx_table or something similar but
> human-comprehensible?

sure, will change

> 
> > +               if (symtab->syms_shndx == NULL)
> > +                       goto out_free_name;
> > +       }
> > +
> >         symtab->nr_syms = shdr.sh_size / shdr.sh_entsize;
> >
> >         return symtab;
> > diff --git a/elf_symtab.h b/elf_symtab.h
> > index 359add69c8ab..f9277a48ed4c 100644
> > --- a/elf_symtab.h
> > +++ b/elf_symtab.h
> > @@ -16,6 +16,7 @@ struct elf_symtab {
> >         uint32_t  nr_syms;
> >         Elf_Data  *syms;
> >         Elf_Data  *symstrs;
> > +       Elf_Data  *syms_shndx;
> 
> please add comment mentioning that it's data of SHT_SYMTAB_SHNDX
> section, it will make it a bit easier to Google what that is

ok

thanks,
jirka

