Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECAB2009CA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgFSNSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:18:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45997 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725806AbgFSNSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wXzLP0jvY3lOyge2s7+F9ufg/cubrwVgsqonGIGw6pY=;
        b=V2medkaN+hl0QdLkxY+ydCrXWJQEsr+HtCtFxmPx/fzoplnCDq/0XqqilMVN9u7Q6QzdqB
        oyz+GZ3QMgwEaFHqWGMm1reegqgKP73auhzwiOxVy5w05n7YdN7pza3oANxkUGLedLmUZ2
        nxaPrujwnWwtz/gyysnD3uD4dbu48vA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-iwP5TOzZO-ajxeM4nkLn5w-1; Fri, 19 Jun 2020 09:18:07 -0400
X-MC-Unique: iwP5TOzZO-ajxeM4nkLn5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48DA4801503;
        Fri, 19 Jun 2020 13:18:05 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id D4E6110013C4;
        Fri, 19 Jun 2020 13:18:01 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:18:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/11] bpf: Remove btf_id helpers resolving
Message-ID: <20200619131800.GF2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-6-jolsa@kernel.org>
 <CAEf4BzYw0VciF-7CS164Nk8LLnZ4odtdYQyX1MS4eWDN5WbcSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYw0VciF-7CS164Nk8LLnZ4odtdYQyX1MS4eWDN5WbcSg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 06:10:29PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Now when we moved the helpers btf_id into .BTF_ids section,
> > we can remove the code that resolve those IDs in runtime.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> Nice! :)
> 
> BTW, have you looked at bpf_ctx_convert stuff? Would we be able to
> replace it with your btfids thing as well?

good, another usage ;-) I'll check

> 
> 
> >  kernel/bpf/btf.c | 88 +++---------------------------------------------
> >  1 file changed, 4 insertions(+), 84 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 58c9af1d4808..aea7b2cc8d26 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4049,96 +4049,16 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >         return -EINVAL;
> >  }
> >
> 
> [...]
> 
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int arg)
> >  {
> > -       int *btf_id = &fn->btf_id[arg];
> > -       int ret;
> > -
> >         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> >                 return -EINVAL;
> >
> > -       ret = READ_ONCE(*btf_id);
> > -       if (ret)
> > -               return ret;
> > -       /* ok to race the search. The result is the same */
> > -       ret = __btf_resolve_helper_id(log, fn->func, arg);
> > -       if (!ret) {
> > -               /* Function argument cannot be type 'void' */
> > -               bpf_log(log, "BTF resolution bug\n");
> > -               return -EFAULT;
> > -       }
> > -       WRITE_ONCE(*btf_id, ret);
> > -       return ret;
> > +       if (WARN_ON_ONCE(!fn->btf_id))
> > +               return -EINVAL;
> > +
> > +       return fn->btf_id[arg];
> 
> It probably would be a good idea to add some sanity checking here,
> making sure that btf_id is >0 (void is never a right type) and <=
> nr_types in vmlinux_btf?

yep, will add it ;-)

jirka

