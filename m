Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9E29834A
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418418AbgJYTC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:02:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1418340AbgJYTC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603652547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aOb840c4dRDXQR8LBDLeAEhLa30RDzC1GYc76rsxsU8=;
        b=fiCMifkYTWDFmhUrcuyX3Wt61hi4LEDbMOzQ8vd//LwKPdYu+qGD3hQxzEPMCfjFBZCD+H
        ZvaEzT12WPOi0UFDvS2DnVHuZKWD8Rjyuz6DKYieNsELDcSO6dI4wD6jazn0ALxnNQ3pwJ
        mZmt+6a4NkezsNfwfZ9dCRSCydQ3HTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-ajpQF2YjN02G7HG8ySInsA-1; Sun, 25 Oct 2020 15:02:23 -0400
X-MC-Unique: ajpQF2YjN02G7HG8ySInsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 679A81006C8D;
        Sun, 25 Oct 2020 19:02:21 +0000 (UTC)
Received: from krava (unknown [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with SMTP id 50A9460BF3;
        Sun, 25 Oct 2020 19:02:15 +0000 (UTC)
Date:   Sun, 25 Oct 2020 20:02:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 08/16] bpf: Use delayed link free in bpf_link_put
Message-ID: <20201025190214.GB2681365@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-9-jolsa@kernel.org>
 <CAEf4BzZ9zwA=SrLTx9JT50OeM6fVPg0Py0Gx+K9ah2we8YtCRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ9zwA=SrLTx9JT50OeM6fVPg0Py0Gx+K9ah2we8YtCRA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 12:46:15PM -0700, Andrii Nakryiko wrote:
> On Thu, Oct 22, 2020 at 8:01 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Moving bpf_link_free call into delayed processing so we don't
> > need to wait for it when releasing the link.
> >
> > For example bpf_tracing_link_release could take considerable
> > amount of time in bpf_trampoline_put function due to
> > synchronize_rcu_tasks call.
> >
> > It speeds up bpftrace release time in following example:
> >
> > Before:
> >
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
> >     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> >
> >      3,290,457,628      cycles:k                                 ( +-  0.27% )
> >        933,581,973      cycles:u                                 ( +-  0.20% )
> >
> >              50.25 +- 4.79 seconds time elapsed  ( +-  9.53% )
> >
> > After:
> >
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
> >     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> >
> >      2,535,458,767      cycles:k                                 ( +-  0.55% )
> >        940,046,382      cycles:u                                 ( +-  0.27% )
> >
> >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/syscall.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 1110ecd7d1f3..61ef29f9177d 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2346,12 +2346,8 @@ void bpf_link_put(struct bpf_link *link)
> >         if (!atomic64_dec_and_test(&link->refcnt))
> >                 return;
> >
> > -       if (in_atomic()) {
> > -               INIT_WORK(&link->work, bpf_link_put_deferred);
> > -               schedule_work(&link->work);
> > -       } else {
> > -               bpf_link_free(link);
> > -       }
> > +       INIT_WORK(&link->work, bpf_link_put_deferred);
> > +       schedule_work(&link->work);
> 
> We just recently reverted this exact change. Doing this makes it
> non-deterministic from user-space POV when the BPF program is
> **actually** detached. This makes user-space programming much more
> complicated and unpredictable. So please don't do this. Let's find
> some other way to speed this up.

ok, makes sense

jirka

> 
> >  }
> >
> >  static int bpf_link_release(struct inode *inode, struct file *filp)
> > --
> > 2.26.2
> >
> 

