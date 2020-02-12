Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3E15A6B9
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgBLKnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:43:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55317 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727535AbgBLKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjRCeO/nyWvPOF/c2mr64joPRjE0wRZjF1FDzleGvQE=;
        b=VcmsvNnuWJpU4j8sMjRO5NYiHCki9gFMCs/MmARyPEDu2XSpQdGA1LTi2Q+JkZ7pfzTi08
        6DDiFmAmKCmko3VmrDPXyK8EQYjDXyA+3FfZr476xBnuv0kOO1N3X1Xt2WTa+VT/URhFSg
        8Ya9p9NzDLx/ezW+ZIuZbtYdDkJym2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-9SuEL6oUMyONNpnfFsXrHg-1; Wed, 12 Feb 2020 05:43:33 -0500
X-MC-Unique: 9SuEL6oUMyONNpnfFsXrHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C8EBA0CC2;
        Wed, 12 Feb 2020 10:43:31 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5D4E8AC20;
        Wed, 12 Feb 2020 10:43:26 +0000 (UTC)
Date:   Wed, 12 Feb 2020 11:43:24 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 10/14] bpf: Re-initialize lnode in bpf_ksym_del
Message-ID: <20200212104324.GA183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-11-jolsa@kernel.org>
 <CAEf4Bzb-J67oKcKtB-7TsO7wD7bnp57NAgqNJW9giZrhrqu_+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb-J67oKcKtB-7TsO7wD7bnp57NAgqNJW9giZrhrqu_+g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 10:28:50AM -0800, Andrii Nakryiko wrote:
> On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When bpf_prog is removed from kallsyms it's on the way
> > out to be removed, so we don't care about lnode state.
> >
> > However the bpf_ksym_del will be used also by bpf_trampoline
> > and bpf_dispatcher objects, which stay allocated even when
> > they are not in kallsyms list, hence the lnode re-init.
> >
> > The list_del_rcu commentary states that we need to call
> > synchronize_rcu, before we can change/re-init the list_head
> > pointers.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> Wouldn't it make more sense to have patches 7 though 10 as a one
> patch? It's a generalization of ksym from being bpf_prog-specific to
> be more general (which this initialization fix is part of, arguably).

it was my initial change ;-) but then I realized I have to explain
several things in the changelog, and that's usually the sign that
you need to split the patch.. also I think now it's easier for review
and backporting

so I prefer it split like this, but if you guys want to squash it
together, I'll do it ;-)

jirka

> 
> >  kernel/bpf/core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 73242fd07893..66b17bea286e 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -676,6 +676,13 @@ void bpf_ksym_del(struct bpf_ksym *ksym)
> >         spin_lock_bh(&bpf_lock);
> >         __bpf_ksym_del(ksym);
> >         spin_unlock_bh(&bpf_lock);
> > +
> > +       /*
> > +        * As explained in list_del_rcu, We must call synchronize_rcu
> > +        * before changing list_head pointers.
> > +        */
> > +       synchronize_rcu();
> > +       INIT_LIST_HEAD_RCU(&ksym->lnode);
> >  }
> >
> >  static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
> > --
> > 2.24.1
> >
> 

