Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9812FF8FD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbhAUXfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:35:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbhAUXfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:35:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611272060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eFyXgt4mgXzIQyLKAsWYVk/6OuV8bw2c5hFSKOGxRF8=;
        b=Yz54fuOtA8JEOizQNlNj92bcjUAqyZ2G3KBKzfskteaW98+Zi+tzrd6rraFSNHpOc4prtf
        jdWkd1DtceGoCLy8anm6GEP0E3f0f9VYfWMz8BeXaEkURYNXcnmJfwJO4G09VfWIoQr452
        L2NHpvzvvnuSn3SharyXBcKEcycRbbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-kfZ7_lOhMMKbDGhzxOoTNA-1; Thu, 21 Jan 2021 18:34:18 -0500
X-MC-Unique: kfZ7_lOhMMKbDGhzxOoTNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4189A835BA7;
        Thu, 21 Jan 2021 23:34:16 +0000 (UTC)
Received: from krava (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id B37A858822;
        Thu, 21 Jan 2021 23:34:06 +0000 (UTC)
Date:   Fri, 22 Jan 2021 00:34:05 +0100
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
Subject: Re: [PATCH 1/3] elf_symtab: Add support for SHN_XINDEX index to
 elf_section_by_name
Message-ID: <20210121233405.GA14067@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-2-jolsa@kernel.org>
 <CAEf4BzY5CSNjoe19V4GAbFM1N4o4jM38G6yahAhr5bAaDVcYxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY5CSNjoe19V4GAbFM1N4o4jM38G6yahAhr5bAaDVcYxA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 03:10:25PM -0800, Andrii Nakryiko wrote:
> On Thu, Jan 21, 2021 at 12:24 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > In case the elf's header e_shstrndx contains SHN_XINDEX,
> > we need to call elf_getshdrstrndx to get the proper
> > string table index.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  dutil.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/dutil.c b/dutil.c
> > index 7b667647420f..9e0fdca3ae04 100644
> > --- a/dutil.c
> > +++ b/dutil.c
> > @@ -179,13 +179,17 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
> >  {
> >         Elf_Scn *sec = NULL;
> >         size_t cnt = 1;
> > +       size_t str_idx;
> > +
> > +       if (elf_getshdrstrndx(elf, &str_idx))
> > +               return NULL;
> >
> >         while ((sec = elf_nextscn(elf, sec)) != NULL) {
> >                 char *str;
> >
> >                 gelf_getshdr(sec, shp);
> > -               str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> > -               if (!strcmp(name, str)) {
> > +               str = elf_strptr(elf, str_idx, shp->sh_name);
> > +               if (str && !strcmp(name, str)) {
> 
> if (!str) would be an error? should we bail out here?

seems like if elf_nextscn returns NULL, it will be the case for all the
sections in here.. but bailing out on (!str) is more direct and safer

I'll send an update

thanks,
jirka

> 
> >                         if (index)
> >                                 *index = cnt;
> >                         break;
> > --
> > 2.27.0
> >
> 

