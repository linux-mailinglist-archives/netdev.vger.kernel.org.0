Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2EC232219
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgG2QEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:04:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596038671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zz13flG+/aJ40UGJfd/JWdTkBYnJ+8dyXlk6Ta+Hbvo=;
        b=IYSLW7R8PATXZFXg8H7/YwM/TJ0LJTeS6j1Q1CYnU5aIwyZDY4zD8loP04Fh5bxMnWpQbA
        Nn/COY7oziL0ymE2spMFjKtUTc0HzcSiFOsU/MtgnkLNWNxs++pPxvAkFtAMi9azoXpy0S
        XeEsxP7oMbUHRJE6KwevJ/JVSMh4yg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-XkHr9teUOkWJF4tWR8KKBA-1; Wed, 29 Jul 2020 12:04:26 -0400
X-MC-Unique: XkHr9teUOkWJF4tWR8KKBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50F421893DC2;
        Wed, 29 Jul 2020 16:04:24 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id F017219D82;
        Wed, 29 Jul 2020 16:04:19 +0000 (UTC)
Date:   Wed, 29 Jul 2020 18:04:19 +0200
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
Subject: Re: [PATCH v8 bpf-next 07/13] bpf: Add btf_struct_ids_match function
Message-ID: <20200729160419.GM1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-8-jolsa@kernel.org>
 <CAEf4BzacqauEc8=o29EBUsmvTMs3FZ+-Kcc4cSJ9Te4yh5-7qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzacqauEc8=o29EBUsmvTMs3FZ+-Kcc4cSJ9Te4yh5-7qg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 04:35:16PM -0700, Andrii Nakryiko wrote:

SNIP

> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index bae557ff2da8..c981e258fed3 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1306,6 +1306,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                       const struct btf_type *t, int off, int size,
> >                       enum bpf_access_type atype,
> >                       u32 *next_btf_id);
> > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > +                         int off, u32 id, u32 mid);
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int);
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 1ab5fd5bf992..562d4453fad3 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4140,6 +4140,35 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >         return -EINVAL;
> >  }
> >
> > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > +                         int off, u32 id, u32 mid)
> > +{
> > +       const struct btf_type *type;
> > +       u32 nid;
> > +       int err;
> > +
> 
> mid and nid are terrible names, especially as an input argument name.
> mid == need_type_id? nid == cur_type_id or something along those
> lines?

'mid' was for matching id, 'nid' for nested id ;-)
need_type_id/cur_type_id sound good

> 
> > +       do {
> > +               type = btf_type_by_id(btf_vmlinux, id);
> > +               if (!type)
> > +                       return false;
> > +               err = btf_struct_walk(log, type, off, 1, &nid);
> > +               if (err < 0)
> > +                       return false;
> > +
> > +               /* We found nested struct object. If it matches
> > +                * the requested ID, we're done. Otherwise let's
> > +                * continue the search with offset 0 in the new
> > +                * type.
> > +                */
> > +               if (err == walk_struct && mid == nid)
> > +                       return true;
> > +               off = 0;
> > +               id = nid;
> > +       } while (err == walk_struct);
> 
> This seems like a slightly more obvious control flow:
> 
> again:
> 
>    ...
> 
>    if (err != walk_struct)
>       return false;

ok, and perhaps use in here the switch(err) as in the previous patch?

thanks,
jirka

> 
>    if (mid != nid) {
>       off = 0;
>       id = nid;
>       goto again;
>    }
> 
>    return true;
> 
> > +
> > +       return false;
> > +}
> > +
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int arg)
> >  {
> 
> [...]
> 

