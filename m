Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820CB3A01BC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhFHS4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236062AbhFHSx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623178296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AteLOuehZrKRBifQp7t2eCpFqM5PYx89clHcr7jZONw=;
        b=SYRC7H6s8gYPCdMgYIYEIzRutTM3CkbC2BEarWxO9ANEeztmh859tMYHHpKWQyequ33u+m
        jYfUhcS5X/y9okjRI7aN3ai0LkxnrlFvb3/aeAte0Rkte5NbxdiGLHYRXH30UdY9iwsHXW
        b6iyaMmiOgTIt1lxAeDBOYpvNzyjLyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-WXdMcdbxN8eSCRpoo4FlBw-1; Tue, 08 Jun 2021 14:51:31 -0400
X-MC-Unique: WXdMcdbxN8eSCRpoo4FlBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93882107ACC7;
        Tue,  8 Jun 2021 18:51:29 +0000 (UTC)
Received: from krava (unknown [10.40.192.49])
        by smtp.corp.redhat.com (Postfix) with SMTP id 825C45C1C2;
        Tue,  8 Jun 2021 18:51:26 +0000 (UTC)
Date:   Tue, 8 Jun 2021 20:51:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 03/19] x86/ftrace: Make function graph use ftrace directly
Message-ID: <YL+8LRsVndGdgOMF@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-4-jolsa@kernel.org>
 <CAEf4BzY5ngJz_=e2wnqG7yB996xdQAPCBfz3_4mB9P2N-1RoCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY5ngJz_=e2wnqG7yB996xdQAPCBfz3_4mB9P2N-1RoCw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 11:35:58AM -0700, Andrii Nakryiko wrote:

SNIP

> > diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
> > index b8a0d1d564fb..58e96b45e9da 100644
> > --- a/kernel/trace/fgraph.c
> > +++ b/kernel/trace/fgraph.c
> > @@ -115,6 +115,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
> >  {
> >         struct ftrace_graph_ent trace;
> >
> > +#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
> >         /*
> >          * Skip graph tracing if the return location is served by direct trampoline,
> >          * since call sequence and return addresses are unpredictable anyway.
> > @@ -124,6 +125,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
> >         if (ftrace_direct_func_count &&
> >             ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))
> >                 return -EBUSY;
> > +#endif
> >         trace.func = func;
> >         trace.depth = ++current->curr_ret_depth;
> >
> > @@ -333,10 +335,10 @@ unsigned long ftrace_graph_ret_addr(struct task_struct *task, int *idx,
> >  #endif /* HAVE_FUNCTION_GRAPH_RET_ADDR_PTR */
> >
> >  static struct ftrace_ops graph_ops = {
> > -       .func                   = ftrace_stub,
> > +       .func                   = ftrace_graph_func,
> >         .flags                  = FTRACE_OPS_FL_INITIALIZED |
> > -                                  FTRACE_OPS_FL_PID |
> > -                                  FTRACE_OPS_FL_STUB,
> > +                                  FTRACE_OPS_FL_PID
> > +                                  FTRACE_OPS_GRAPH_STUB,
> 
> nit: this looks so weird... Why not define FTRACE_OPS_GRAPH_STUB as
> zero in case of #ifdef ftrace_graph_func? Then it will be natural and
> correctly looking | FTRACE_OPS_GRAPH_STUB?

ok, I can change that

thanks,
jirka

> 
> >  #ifdef FTRACE_GRAPH_TRAMP_ADDR
> >         .trampoline             = FTRACE_GRAPH_TRAMP_ADDR,
> >         /* trampoline_size is only needed for dynamically allocated tramps */
> > --
> > 2.31.1
> >
> 

