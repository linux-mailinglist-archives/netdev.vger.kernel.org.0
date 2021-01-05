Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0111F2EB584
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbhAEWtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 17:49:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726306AbhAEWtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609886859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q+OGyLNEQbKTxtU80nmQ5mFo6xcLzSuoiVhWxY8fk0A=;
        b=TQeO18Vv7UqQoPP7ZQS58ObZ8VHe6VJ9YqidD2yqB7+p+991u4udklQx4IPaPPJmvz9GMw
        bmb5Tct8zb0iNwu5k9Do762/ZhxoBGl0xIvixBY6G2Jiu+A63wcYvmvdcD5libVQmAvRZ3
        GpUJvEOnZkoPq0LWeel94rUJnhLBJCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-SwvYmIglMHGLPsZyRoj_Lw-1; Tue, 05 Jan 2021 17:47:35 -0500
X-MC-Unique: SwvYmIglMHGLPsZyRoj_Lw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E470801AAA;
        Tue,  5 Jan 2021 22:47:32 +0000 (UTC)
Received: from krava (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with SMTP id B102B61F5E;
        Tue,  5 Jan 2021 22:47:29 +0000 (UTC)
Date:   Tue, 5 Jan 2021 23:47:28 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Warn when having multiple
 IDs for single type
Message-ID: <20210105224728.GB936454@krava>
References: <20210105153944.951019-1-jolsa@kernel.org>
 <CAEf4Bzb95cyrku5g+SvOmAWCV6kRhqJAFayp4fdzT31dMjjVXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb95cyrku5g+SvOmAWCV6kRhqJAFayp4fdzT31dMjjVXQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 01:15:39PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 5, 2021 at 7:41 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The kernel image can contain multiple types (structs/unions)
> > with the same name. This causes distinct type hierarchies in
> > BTF data and makes resolve_btfids fail with error like:
> >
> >   BTFIDS  vmlinux
> > FAILED unresolved symbol udp6_sock
> >
> > as reported by Qais Yousef [1].
> >
> > This change adds warning when multiple types of the same name
> > are detected:
> >
> >   BTFIDS  vmlinux
> > WARN: multiple IDs found for 'file' (526, 113351)
> > WARN: multiple IDs found for 'sk_buff' (2744, 113958)
> >
> > We keep the lower ID for the given type instance and let the
> > build continue.
> >
> > [1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
> > Reported-by: Qais Yousef <qais.yousef@arm.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> see comments below, but otherwise lgtm
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  tools/bpf/resolve_btfids/main.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > index e3ea569ee125..36a3b1024cdc 100644
> > --- a/tools/bpf/resolve_btfids/main.c
> > +++ b/tools/bpf/resolve_btfids/main.c
> > @@ -139,6 +139,8 @@ int eprintf(int level, int var, const char *fmt, ...)
> >  #define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
> >  #define pr_err(fmt, ...) \
> >         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_info(fmt, ...) \
> > +       eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
> 
> how is it different from pr_err? Did you forget to update verboseness
> levels or it's intentional?

intentional, I'm using pr_err to print in error paths,
so I wanted to add new one for other 'info' messages without -v

> 
> >
> >  static bool is_btf_id(const char *name)
> >  {
> > @@ -526,8 +528,13 @@ static int symbols_resolve(struct object *obj)
> >
> >                 id = btf_id__find(root, str);
> >                 if (id) {
> > -                       id->id = type_id;
> > -                       (*nr)--;
> > +                       if (id->id) {
> > +                               pr_info("WARN: multiple IDs found for '%s' (%d, %d)\n",
> > +                                       str, id->id, type_id);
> > +                       } else {
> > +                               id->id = type_id;
> > +                               (*nr)--;
> 
> btw, there is a nasty shadowing of nr variable, which is used both for
> the for() loop condition (as int) and as `int *` inside the loop body.
> It's better to rename inner (or outer) nr, it's extremely confusing as
> is.

nice, I'll change that

thanks,
jirka

> 
> > +                       }
> >                 }
> >         }
> >
> > --
> > 2.26.2
> >
> 

