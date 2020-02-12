Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76A415A6FA
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBLKtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:49:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49595 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725767AbgBLKtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ImvaTCw+dfgkvwmLbrF5U0c7XCE+TYy6OwrRp1tuwwU=;
        b=FeB2l3VRE2JLJB1HOgNpAJQ60HA9EL8xgRJwgEUkbhtKbwOQ2/6rtDEuI3nU4BTtYmUL7m
        NvtIeEUR0TmTmra54GdLslZ+6bXfIvy5rpmSxZ//9ByUDmv1e11SnvHWbLYQ/OE23MXVAn
        z0QqhzX8uVwln1kgNVTvQXruI3J+aqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-195IGnEqOd6TRvf3DxWv8w-1; Wed, 12 Feb 2020 05:49:44 -0500
X-MC-Unique: 195IGnEqOd6TRvf3DxWv8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9B24800D41;
        Wed, 12 Feb 2020 10:49:42 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 145B16E3EE;
        Wed, 12 Feb 2020 10:49:39 +0000 (UTC)
Date:   Wed, 12 Feb 2020 11:49:37 +0100
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
Subject: Re: [PATCH 06/14] bpf: Add bpf_kallsyms_tree tree
Message-ID: <20200212104937.GC183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-7-jolsa@kernel.org>
 <CAEf4BzYyJBh+zh0NYTEXV=ocCCtJJ_+skeRJQJt1AKQSAEEWqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYyJBh+zh0NYTEXV=ocCCtJJ_+skeRJQJt1AKQSAEEWqw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 10:21:10AM -0800, Andrii Nakryiko wrote:
> On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The bpf_tree is used both for kallsyms iterations and searching
> > for exception tables of bpf programs, which is needed only for
> > bpf programs.
> >
> > Adding bpf_kallsyms_tree that will hold symbols for all bpf_prog,
> > bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> > only for bpf_prog objects exception tables search to keep it fast.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h |  1 +
> >  kernel/bpf/core.c   | 60 ++++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 55 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index da67ca3afa2f..151d7b1c8435 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -468,6 +468,7 @@ struct bpf_ksym {
> >         unsigned long            end;
> >         char                     name[KSYM_NAME_LEN];
> >         struct list_head         lnode;
> > +       struct latch_tree_node   tnode;
> >  };
> >
> >  enum bpf_tramp_prog_type {
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index b9b7077e60f3..1daa72341450 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -606,8 +606,46 @@ static const struct latch_tree_ops bpf_tree_ops = {
> >         .comp   = bpf_tree_comp,
> >  };
> >
> > +static __always_inline unsigned long
> > +bpf_get_ksym_start(struct latch_tree_node *n)
> 
> I thought static functions are never marked as inline in kernel
> sources. Are there some special cases when its ok/necessary?

I followed the other latch tree ops functions and did not think
much about that.. will check

> 
> > +{
> > +       const struct bpf_ksym *ksym;
> > +
> > +       ksym = container_of(n, struct bpf_ksym, tnode);
> > +       return ksym->start;
> > +}
> > +
> > +static __always_inline bool
> > +bpf_ksym_tree_less(struct latch_tree_node *a,
> > +                  struct latch_tree_node *b)
> > +{
> > +       return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
> > +}
> > +
> > +static __always_inline int
> > +bpf_ksym_tree_comp(void *key, struct latch_tree_node *n)
> > +{
> > +       unsigned long val = (unsigned long)key;
> > +       const struct bpf_ksym *ksym;
> > +
> > +       ksym = container_of(n, struct bpf_ksym, tnode);
> > +
> > +       if (val < ksym->start)
> > +               return -1;
> > +       if (val >= ksym->end)
> > +               return  1;
> > +
> > +       return 0;
> > +}
> > +
> > +static const struct latch_tree_ops bpf_kallsyms_tree_ops = {
> 
> Given all the helper functions use bpf_ksym_tree and bpf_ksym
> (bpf_ksym_find) prefixes, call this bpf_ksym_tree_ops?

right, should be bpf_ksym_tree_ops as you said

> 
> > +       .less   = bpf_ksym_tree_less,
> > +       .comp   = bpf_ksym_tree_comp,
> > +};
> > +
> >  static DEFINE_SPINLOCK(bpf_lock);
> >  static LIST_HEAD(bpf_kallsyms);
> > +static struct latch_tree_root bpf_kallsyms_tree __cacheline_aligned;
> 
> same as above, bpf_ksym_tree for consistency?

right, thanks

jirka

