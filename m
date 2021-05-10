Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B885E377FD2
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhEJJvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:51:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhEJJvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620640211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nTudUvpz6RoslSVcQC6MaQyMsBToVri/EUElXBnDO3o=;
        b=c2+5ILjohC6My5Ii/UB9kNjwZHW+YjtjoOQ2uvJrc6W8qHxzpzQjvTLAwUQVb9rt1Vkn6P
        QGx986fF1IyE8ttqbWK9dcuCO9EBq5dWn8rSnjvYvVNYjvmkYnItoJymPRyd6Wukr7IKBI
        qsvuzgl+ttkZnewi+53iGbKYJ1CSG0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-DXpWDaDVOR-0Am4PC7PI7g-1; Mon, 10 May 2021 05:50:07 -0400
X-MC-Unique: DXpWDaDVOR-0Am4PC7PI7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C796D246;
        Mon, 10 May 2021 09:50:05 +0000 (UTC)
Received: from krava (unknown [10.40.194.219])
        by smtp.corp.redhat.com (Postfix) with SMTP id 72CC25E26A;
        Mon, 10 May 2021 09:50:02 +0000 (UTC)
Date:   Mon, 10 May 2021 11:50:01 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2] bpf: Add deny list of btf ids check for tracing
 programs
Message-ID: <YJkByQ4bGa7jrvWR@krava>
References: <20210429114712.43783-1-jolsa@kernel.org>
 <CAADnVQLDwjE8KFcqbzB5op5b=fC2941tnnWOtQ+X1DYi6Yw1xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLDwjE8KFcqbzB5op5b=fC2941tnnWOtQ+X1DYi6Yw1xA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 06:36:38PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 29, 2021 at 4:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The recursion check in __bpf_prog_enter and __bpf_prog_exit
> > leaves some (not inlined) functions unprotected:
> >
> > In __bpf_prog_enter:
> >   - migrate_disable is called before prog->active is checked
> >
> > In __bpf_prog_exit:
> >   - migrate_enable,rcu_read_unlock_strict are called after
> >     prog->active is decreased
> >
> > When attaching trampoline to them we get panic like:
> >
> >   traps: PANIC: double fault, error_code: 0x0
> >   double fault: 0000 [#1] SMP PTI
> >   RIP: 0010:__bpf_prog_enter+0x4/0x50
> >   ...
> >   Call Trace:
> >    <IRQ>
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    ...
> >
> > Fixing this by adding deny list of btf ids for tracing
> > programs and checking btf id during program verification.
> > Adding above functions to this list.
> >
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > v2 changes:
> >   - drop check for EXT programs [Andrii]
> >
> >  kernel/bpf/verifier.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 2579f6fbb5c3..42311e51ac71 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >         return 0;
> >  }
> >
> > +BTF_SET_START(btf_id_deny)
> > +BTF_ID_UNUSED
> > +#ifdef CONFIG_SMP
> > +BTF_ID(func, migrate_disable)
> > +BTF_ID(func, migrate_enable)
> > +#endif
> > +#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
> > +BTF_ID(func, rcu_read_unlock_strict)
> > +#endif
> > +BTF_SET_END(btf_id_deny)
> 
> I was wondering whether it makes sense to do this on pahole side instead ?
> It can do more flexible regex matching and excluding all such functions
> from vmlinux btf without the kernel having to do a maze of #ifdef
> depending on config.
> On one side we will lose BTF info about such functions, but what do we
> need it for?
> On the other side it will be a tiny reduction in vmlinux btf :)
> Thoughts?

we just removed the ftrace filter so BTF will have 'all' functions

I think the filtering on pahole side could cause problems like
the recent one with cubictcp_state.. it's just 3 functions, but
what if they rename? this way we at least get compilation error ;-)

I'd go with all functions in BTF and restrict attachment for those
that cause problems

jirka

