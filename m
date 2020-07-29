Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61AA23220E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgG2P7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:59:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2P7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596038387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yyGEnj8PhQ1aPPSJJnQHsf34uSqQpvqLWxRR//cvG98=;
        b=LmLXx2VoNqKSdYBMZOnYZQUZqvC6bO0+qORpecqb+R2u11KD4PJyXUTcUGBLWU9L27pCZi
        zQxqUtMpE9NX3TC1m+rjCgVPWy8ZLEKkTUqn/N1uJXFKV9djLZcxMmiDY7WUhdDClR6IJu
        BIc2Ri8x7xlSYQEOgV0EufygW+fbRFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-kQIygvkZMOuMvp5i4U73Pg-1; Wed, 29 Jul 2020 11:59:43 -0400
X-MC-Unique: kQIygvkZMOuMvp5i4U73Pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FDB2800480;
        Wed, 29 Jul 2020 15:59:41 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0934010027AB;
        Wed, 29 Jul 2020 15:59:37 +0000 (UTC)
Date:   Wed, 29 Jul 2020 17:59:37 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 bpf-next 06/13] bpf: Factor btf_struct_access function
Message-ID: <20200729155937.GL1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-7-jolsa@kernel.org>
 <CAEf4BzbS_JFW70Z_68hDtN4VTkLfohkR0PV0d9jCJRjZEhc01Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbS_JFW70Z_68hDtN4VTkLfohkR0PV0d9jCJRjZEhc01Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 04:27:21PM -0700, Andrii Nakryiko wrote:

SNIP

> 
> >  kernel/bpf/btf.c | 73 +++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 60 insertions(+), 13 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 841be6c49f11..1ab5fd5bf992 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3873,16 +3873,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >         return true;
> >  }
> >
> > -int btf_struct_access(struct bpf_verifier_log *log,
> > -                     const struct btf_type *t, int off, int size,
> > -                     enum bpf_access_type atype,
> > -                     u32 *next_btf_id)
> > +enum walk_return {
> > +       /* < 0 error */
> > +       walk_scalar = 0,
> > +       walk_ptr,
> > +       walk_struct,
> > +};
> 
> let's keep enum values in ALL_CAPS? walk_return is also a bit generic,
> maybe something like bpf_struct_walk_result?

ok

> 
> > +
> > +static int btf_struct_walk(struct bpf_verifier_log *log,
> > +                          const struct btf_type *t, int off, int size,
> > +                          u32 *rid)
> >  {
> >         u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
> >         const struct btf_type *mtype, *elem_type = NULL;
> >         const struct btf_member *member;
> >         const char *tname, *mname;
> > -       u32 vlen;
> > +       u32 vlen, elem_id, mid;
> >
> >  again:
> >         tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> > @@ -3924,8 +3930,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                         goto error;
> >
> >                 off = (off - moff) % elem_type->size;
> > -               return btf_struct_access(log, elem_type, off, size, atype,
> > -                                        next_btf_id);
> > +               return btf_struct_walk(log, elem_type, off, size, rid);
> 
> oh, btw, this is a recursion in the kernel, let's fix that? I think it
> could easily be just `goto again` here?

probably, I'll put it into separate change then

SNIP

> 
> > @@ -4066,11 +4080,10 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                                         mname, moff, tname, off, size);
> >                                 return -EACCES;
> >                         }
> > -
> >                         stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
> >                         if (btf_type_is_struct(stype)) {
> > -                               *next_btf_id = id;
> > -                               return PTR_TO_BTF_ID;
> > +                               *rid = id;
> 
> nit: rid is a very opaque name, I find next_btf_id more appropriate
> (even if it's meaning changes depending on walk_ptr vs walk_struct.

ok, will change

SNIP

> > +int btf_struct_access(struct bpf_verifier_log *log,
> > +                     const struct btf_type *t, int off, int size,
> > +                     enum bpf_access_type atype __maybe_unused,
> > +                     u32 *next_btf_id)
> > +{
> > +       int err;
> > +       u32 id;
> > +
> > +       do {
> > +               err = btf_struct_walk(log, t, off, size, &id);
> > +               if (err < 0)
> > +                       return err;
> > +
> > +               /* We found the pointer or scalar on t+off,
> > +                * we're done.
> > +                */
> > +               if (err == walk_ptr) {
> > +                       *next_btf_id = id;
> > +                       return PTR_TO_BTF_ID;
> > +               }
> > +               if (err == walk_scalar)
> > +                       return SCALAR_VALUE;
> > +
> > +               /* We found nested struct, so continue the search
> > +                * by diving in it. At this point the offset is
> > +                * aligned with the new type, so set it to 0.
> > +                */
> > +               t = btf_type_by_id(btf_vmlinux, id);
> > +               off = 0;
> 
> It's very easy to miss that this case corresponds to walk_struct here.
> If someone in the future adds a 4th special value, it will be too easy
> to forget to update this piece of logic. So when dealing with enums, I
> generally prefer this approach:
> 
> switch (err) {
> case walk_ptr:
>     ...
> case walk_scalar:
>     ...
> case walk_struct:
>     ...
> default: /* complain loudly here */
> }
> 
> WDYT?

right, I like it, make sense for future.. will change

thanks,
jirka

