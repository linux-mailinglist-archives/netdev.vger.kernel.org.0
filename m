Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E84301852
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbhAWUQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:16:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbhAWUQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:16:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611432928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WlLkcbbh75RGPk5JxgfyipxpMbnbZsxB7tUvYuilHNg=;
        b=OqOTrHqRz1mNdMiuw6KG10bvNi3oUMCy4q325mwAKHuRjZg08/QXhLG0R1niwHS8lzQiI8
        dKrPKNEvGSnbtfexZmqw02U+Z6rRJugGr7USJ6RY518JXrBhNK/Bl0JH8bM7LHzdLVScKp
        B1A1Gw/7g0rs8zB868ggA51bZ+O9/PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-MK3q52p4Oeenwe1ynbkLVQ-1; Sat, 23 Jan 2021 15:15:24 -0500
X-MC-Unique: MK3q52p4Oeenwe1ynbkLVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 285D0801FAE;
        Sat, 23 Jan 2021 20:15:22 +0000 (UTC)
Received: from krava (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3E25B19C44;
        Sat, 23 Jan 2021 20:15:14 +0000 (UTC)
Date:   Sat, 23 Jan 2021 21:15:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Mark Wielaard <mark@klomp.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
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
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210123201514.GB117714@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
 <20210122204654.GB70760@krava>
 <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
 <20210123185143.GA117714@krava>
 <d5e30947541a3571bd111e24b3a28dfb1770556c.camel@klomp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5e30947541a3571bd111e24b3a28dfb1770556c.camel@klomp.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 09:08:15PM +0100, Mark Wielaard wrote:
> Hi Jiri,
> 
> On Sat, 2021-01-23 at 19:51 +0100, Jiri Olsa wrote:
> > On Fri, Jan 22, 2021 at 02:55:51PM -0800, Andrii Nakryiko wrote:
> > > 
> > > > I don't understand this..  gelf_getsymshndx will return both
> > > > symbol and proper index, no? also sym_sec_idx is already
> > > > assigned from previou call
> > > 
> > > Reading (some) implementation of gelf_getsymshndx() that I found
> > > online, it won't set sym_sec_idx, if the symbol *doesn't* use
> > > extended
> > > numbering. But it will still return symbol data. So to return the
> > 
> > the latest upstream code seems to set it always,
> > but I agree we should be careful
> > 
> > Mark, any insight in here? thanks
> 
> GElf_Sym *
> gelf_getsymshndx (Elf_Data *symdata, Elf_Data *shndxdata, int ndx,
>                   GElf_Sym *dst, Elf32_Word *dstshndx)
> 
> Will always set *dst, but only set *dstshndx if both it and shndxdata
> are not NULL and no error occurred (the function returns NULL and set
> libelf_error in case of error).
> 
> So as long as shndxdata != NULL you can rely on *dstshndx being set.
> Otherwise you get the section index from dst->st_shndx.

ok, so it's as Andrii said, I'll make the extra check then

thanks,
jirka

