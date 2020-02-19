Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1590A163F57
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 09:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBSIlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 03:41:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgBSIlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 03:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582101703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8elBKO8bz2MbquCOlkktOPvafk4foe0zxZbMQ9OMdfM=;
        b=g6P1ThNTdPGVi9lHGL+9mYGZ8kHDNFg8OgRVw7N+pubE+4WUcyugbxwI62MgKdPPMa8bJb
        mFFaCaC75RIW9xZ8eQPjdGmTFcJvlsDQxR06P95TSzUOe1xkmpe2sZ49VWVpidH14bZRCm
        ZbksTayWi8S1Kb7Bn+xXpnzCQRwu8Yk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-jyzXFO6gMM2J_yhswVGXNQ-1; Wed, 19 Feb 2020 03:41:39 -0500
X-MC-Unique: jyzXFO6gMM2J_yhswVGXNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADF9710CE78E;
        Wed, 19 Feb 2020 08:41:37 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB6885D9E2;
        Wed, 19 Feb 2020 08:41:34 +0000 (UTC)
Date:   Wed, 19 Feb 2020 09:41:32 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/18] bpf: Add bpf_ksym_tree tree
Message-ID: <20200219084132.GC439238@krava>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-7-jolsa@kernel.org>
 <e869424c-eaf5-d8b1-dfde-86958f437538@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e869424c-eaf5-d8b1-dfde-86958f437538@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:34:47PM +0100, Daniel Borkmann wrote:
> On 2/16/20 8:29 PM, Jiri Olsa wrote:
> > The bpf_tree is used both for kallsyms iterations and searching
> > for exception tables of bpf programs, which is needed only for
> > bpf programs.
> > 
> > Adding bpf_ksym_tree that will hold symbols for all bpf_prog
> > bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> > only for bpf_prog objects to keep it fast.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/linux/bpf.h |  1 +
> >   kernel/bpf/core.c   | 60 ++++++++++++++++++++++++++++++++++++++++-----
> >   2 files changed, 55 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index f1174d24c185..5d6649cdc3df 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -468,6 +468,7 @@ struct bpf_ksym {
> >   	unsigned long		 end;
> >   	char			 name[KSYM_NAME_LEN];
> >   	struct list_head	 lnode;
> > +	struct latch_tree_node	 tnode;
> >   };
> >   enum bpf_tramp_prog_type {
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 604093d2153a..9fb08b4d01f7 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -606,8 +606,46 @@ static const struct latch_tree_ops bpf_tree_ops = {
> >   	.comp	= bpf_tree_comp,
> >   };
> > +static unsigned long
> > +bpf_get_ksym_start(struct latch_tree_node *n)
> > +{
> > +	const struct bpf_ksym *ksym;
> > +
> > +	ksym = container_of(n, struct bpf_ksym, tnode);
> > +	return ksym->start;
> 
> Small nit, can be simplified to:
> 
> 	return container_of(n, struct bpf_ksym, tnode)->start;

ok

> 
> > +}
> > +
> > +static bool
> > +bpf_ksym_tree_less(struct latch_tree_node *a,
> > +		   struct latch_tree_node *b)
> > +{
> > +	return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
> > +}
> > +
> > +static int
> > +bpf_ksym_tree_comp(void *key, struct latch_tree_node *n)
> > +{
> > +	unsigned long val = (unsigned long)key;
> > +	const struct bpf_ksym *ksym;
> > +
> > +	ksym = container_of(n, struct bpf_ksym, tnode);
> > +
> > +	if (val < ksym->start)
> > +		return -1;
> > +	if (val >= ksym->end)
> > +		return  1;
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct latch_tree_ops bpf_ksym_tree_ops = {
> > +	.less	= bpf_ksym_tree_less,
> > +	.comp	= bpf_ksym_tree_comp,
> > +};
> > +
> >   static DEFINE_SPINLOCK(bpf_lock);
> >   static LIST_HEAD(bpf_kallsyms);
> > +static struct latch_tree_root bpf_ksym_tree __cacheline_aligned;
> >   static struct latch_tree_root bpf_tree __cacheline_aligned;
> 
> You mention in your commit description performance being the reason on why
> we need two latch trees. Can't we maintain everything just in a single one?
> 
> What does "to keep it fast" mean here in absolute numbers that would affect
> overall system performance? It feels a bit like premature optimization with
> the above rationale as-is.
> 
> If it is about differentiating the different bpf_ksym symbols for some of the
> kallsym handling functions (?), can't we simply add an enum bpf_ksym_type {
> BPF_SYM_PROGRAM, BPF_SYM_TRAMPOLINE, BPF_SYM_DISPATCHER } instead, but still
> maintain them all in a single latch tree?

the motivation is that up to now stored in the tree only bpf_prog objects,
and the tree was used both for kallsym and exception table lookups
(in search_bpf_extables function)

but if we'd add trampoline and fispatcher objects to the same tree, then
the exception table lookups would suffer from having to traverse more
objects within the search, hence the separation of the trees

I don't have any performance numbers supporting this, just the rationale
above

jirka

