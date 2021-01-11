Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC9F2F21A4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbhAKVS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:18:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbhAKVS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610399849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SCB2GqMRzpSLrROmd2i5ytegCaTaZU6PyeFCGOKDImk=;
        b=EMmxvJYwGZDuId/+nDb1WFSygBG2d6Oee1dlFDdJA4M2qIAwMhQa6fs16rg7Eqbl4pXl2J
        Esv8g1M0YWwNsG4eU7oQyfTzXibrc6NLRECzSVEcWpia7Rp13rX/EU42ZREPZ8b5pIyED6
        E/o99a4qv9GUMbnT6UXkcmUfMdIgIy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-fuuvH0CXOAyrbopb-ZX05w-1; Mon, 11 Jan 2021 16:17:27 -0500
X-MC-Unique: fuuvH0CXOAyrbopb-ZX05w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D883C80ED8A;
        Mon, 11 Jan 2021 21:17:25 +0000 (UTC)
Received: from krava (unknown [10.40.192.185])
        by smtp.corp.redhat.com (Postfix) with SMTP id 33BDB5B4A7;
        Mon, 11 Jan 2021 21:17:20 +0000 (UTC)
Date:   Mon, 11 Jan 2021 22:17:19 +0100
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
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH] bpf: Prevent double bpf_prog_put call from
 bpf_tracing_prog_attach
Message-ID: <20210111211719.GD1210240@krava>
References: <20210111191650.1241578-1-jolsa@kernel.org>
 <CAEf4BzboXkJ96z45+CNJ0QNf74sR9=Ew7Nr94eXiBUk_5w-mDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzboXkJ96z45+CNJ0QNf74sR9=Ew7Nr94eXiBUk_5w-mDA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 12:34:48PM -0800, Andrii Nakryiko wrote:
> On Mon, Jan 11, 2021 at 11:18 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The bpf_tracing_prog_attach error path calls bpf_prog_put
> > on prog, which causes refcount underflow when it's called
> > from link_create function.
> >
> >   link_create
> >     prog = bpf_prog_get              <-- get
> >     ...
> >     tracing_bpf_link_attach(prog..
> >       bpf_tracing_prog_attach(prog..
> >         out_put_prog:
> >           bpf_prog_put(prog);        <-- put
> >
> >     if (ret < 0)
> >       bpf_prog_put(prog);            <-- put
> >
> > Removing bpf_prog_put call from bpf_tracing_prog_attach
> > and making sure its callers call it instead.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> I also double-checked all other attach functions called from
> link_create, they all seem to be fine and don't put prog on failure,
> so this should be the only needed fix. Also, missing:

it'd be easier to spot this if we use refcount_t instead of the atomic64_t,
I replaced it for this refcount and got nice console warning for this bug

then I saw:
  85192dbf4de0 bpf: Convert bpf_prog refcnt to atomic64_t

so I guess we need something like refcount64_t first

jirka

> 
> Fixes: 4a1e7c0c63e0 ("bpf: Support attaching freplace programs to
> multiple attach points")
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  kernel/bpf/syscall.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index c3bb03c8371f..e5999d86c76e 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2712,7 +2712,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> >  out_put_prog:
> >         if (tgt_prog_fd && tgt_prog)
> >                 bpf_prog_put(tgt_prog);
> > -       bpf_prog_put(prog);
> >         return err;
> >  }
> >
> > @@ -2825,7 +2824,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
> >                         tp_name = prog->aux->attach_func_name;
> >                         break;
> >                 }
> > -               return bpf_tracing_prog_attach(prog, 0, 0);
> > +               err = bpf_tracing_prog_attach(prog, 0, 0);
> > +               if (err >= 0)
> > +                       return err;
> > +               goto out_put_prog;
> >         case BPF_PROG_TYPE_RAW_TRACEPOINT:
> >         case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
> >                 if (strncpy_from_user(buf,
> > --
> > 2.26.2
> >
> 

