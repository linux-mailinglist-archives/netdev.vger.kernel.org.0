Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2262B8F58
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKSJse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:48:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726841AbgKSJsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605779312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHCn/B90ShQY9gqtIz2dPsnbZY9qpN1QJdlVUR9SABY=;
        b=VQnqhq94WzM3h0IHskBCqIihpRI6eIGvJI4YeMhhh8WRp2GOUtof6R8IjUOKo7gtCoDfx7
        csvpr4GEiRnIjkUMyjoBjzQiN21jJyp+KbNaFRo+HDnSiQbffSyhtU32UK9nwKbzr9Q0Ab
        4ZmkiP2r+IaQizHdKPoeMl8ABvqVjIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-bLTms5kEOH6t4J-aU7gVJA-1; Thu, 19 Nov 2020 04:48:27 -0500
X-MC-Unique: bLTms5kEOH6t4J-aU7gVJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 777981005D5E;
        Thu, 19 Nov 2020 09:48:25 +0000 (UTC)
Received: from krava (unknown [10.40.195.116])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2BCE75D6A8;
        Thu, 19 Nov 2020 09:48:21 +0000 (UTC)
Date:   Thu, 19 Nov 2020 10:48:21 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] libbpf: Fix VERSIONED_SYM_COUNT number parsing
Message-ID: <20201119094821.GB1475102@krava>
References: <20201118211350.1493421-1-jolsa@kernel.org>
 <CAEf4BzYdQz7p3khLPbNA_1cKbVJv-XJCcKtpxbsoXzExo+g_DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYdQz7p3khLPbNA_1cKbVJv-XJCcKtpxbsoXzExo+g_DQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 05:57:25PM -0800, Andrii Nakryiko wrote:
> On Wed, Nov 18, 2020 at 1:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > We remove "other info" from "readelf -s --wide" output when
> > parsing GLOBAL_SYM_COUNT variable, which was added in [1].
> > But we don't do that for VERSIONED_SYM_COUNT and it's failing
> > the check_abi target on powerpc Fedora 33.
> >
> > The extra "other info" wasn't problem for VERSIONED_SYM_COUNT
> > parsing until commit [2] added awk in the pipe, which assumes
> > that the last column is symbol, but it can be "other info".
> >
> > Adding "other info" removal for VERSIONED_SYM_COUNT the same
> > way as we did for GLOBAL_SYM_COUNT parsing.
> >
> > [1] aa915931ac3e ("libbpf: Fix readelf output parsing for Fedora")
> > [2] 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
> >
> > Cc: Tony Ambardar <tony.ambardar@gmail.com>
> > Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > Fixes: 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> LGTM. For the future, though, please specify the destination tree: [PATCH bpf].

ugh, sry will do

jirka

> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> 
> >  tools/lib/bpf/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index 5f9abed3e226..55bd78b3496f 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -146,6 +146,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
> >                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> >                            sort -u | wc -l)
> >  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> > +                             sed 's/\[.*\]//' | \
> >                               awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
> >                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
> >
> > @@ -214,6 +215,7 @@ check_abi: $(OUTPUT)libbpf.so
> >                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> >                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
> >                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> > +                   sed 's/\[.*\]//' |                                   \
> >                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
> >                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
> >                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> > --
> > 2.26.2
> >
> 

