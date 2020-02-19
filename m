Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0AB163F1F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 09:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgBSIas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 03:30:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726598AbgBSIar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 03:30:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582101046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=foOFcmIVQGxB8iP7ecwwHhtaDTShseLOhJBfsRwfGaI=;
        b=gcsnD+1G0Qu/E/8b+l3zn1aIVJzTWnfg7HmFGHCFLmDUbMLFcMDREZIyknK8P+r9vtazG1
        oV9FqNgGpgV/sOzTtuan3ZjW2b+5zPW6IOGVBiQ+rz7Y+a69rsVE6V/s45HV/IbgS71Cie
        rOlXapMMHw25LXGqnEEpdaYojfOI/Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-CRjTsfbfNXuyUXOlpi-nCg-1; Wed, 19 Feb 2020 03:30:42 -0500
X-MC-Unique: CRjTsfbfNXuyUXOlpi-nCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 869DC1005510;
        Wed, 19 Feb 2020 08:30:40 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FBAC62660;
        Wed, 19 Feb 2020 08:30:37 +0000 (UTC)
Date:   Wed, 19 Feb 2020 09:30:34 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 15/18] bpf: Sort bpf kallsyms symbols
Message-ID: <20200219083034.GB439238@krava>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-16-jolsa@kernel.org>
 <20200218231816.own6y5ijjx25kti6@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218231816.own6y5ijjx25kti6@ast-mbp>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 03:18:17PM -0800, Alexei Starovoitov wrote:
> On Sun, Feb 16, 2020 at 08:30:02PM +0100, Jiri Olsa wrote:
> > Currently we don't sort bpf_kallsyms and display symbols
> > in proc/kallsyms as they come in via __bpf_ksym_add.
> > 
> > Using the latch tree to get the next bpf_ksym object
> > and insert the new symbol ahead of it.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/core.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 2f857bbfe05c..fa814179730c 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -651,9 +651,28 @@ static struct latch_tree_root bpf_progs_tree __cacheline_aligned;
> >  
> >  static void __bpf_ksym_add(struct bpf_ksym *ksym)
> >  {
> > +	struct list_head *head = &bpf_kallsyms;
> > +	struct rb_node *next;
> > +
> >  	WARN_ON_ONCE(!list_empty(&ksym->lnode));
> > -	list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
> >  	latch_tree_insert(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
> > +
> > +	/*
> > +	 * Add ksym into bpf_kallsyms in ordered position,
> > +	 * which is prepared for us by latch tree addition.
> > +	 *
> > +	 * Find out the next symbol and insert ksym right
> > +	 * ahead of it. If ksym is the last one, just tail
> > +	 * add to the bpf_kallsyms.
> > +	 */
> > +	next = rb_next(&ksym->tnode.node[0]);
> > +	if (next) {
> > +		struct bpf_ksym *ptr;
> > +
> > +		ptr = container_of(next, struct bpf_ksym, tnode.node[0]);
> > +		head = &ptr->lnode;
> > +	}
> > +	list_add_tail_rcu(&ksym->lnode, head);
> 
> what is the motivation for sorting? do you want perf and other user space
> to depend on it? Or purely aesthetics?

initially I thought perf depends on it, but it does its own sorting

but it turned out to be really easy and fast to sort bpf symbols
at the end, so I included it, because core symbols in kallsyms
are also sorted, I should have mentioned this in changelog

jirka

