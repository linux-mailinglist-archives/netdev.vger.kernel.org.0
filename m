Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348EB173714
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgB1MRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 07:17:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725827AbgB1MRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 07:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582892242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=77v08dGJVTiEAiSliIKZUBYfJvTtBNUksgwduvb2KTk=;
        b=N8SP5m0B0O5esZhOkTkfccZTCxor2CWzyZ2SrFR6pIHdtUHplWGWWphWG51XdRnapz13E6
        pGDV0vB5xrEDilPQeyGjZEFLfjHPZ1AYQ5c2goXk2QDLkFgp3NvYrxDZ/qjX3OqnT1QIub
        6jeUo8tbQ4hON0xVMM0ckMLC4Zg92as=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-Rb-bRqSiM4OsjID-jrDhnQ-1; Fri, 28 Feb 2020 07:17:17 -0500
X-MC-Unique: Rb-bRqSiM4OsjID-jrDhnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE1281882CCC;
        Fri, 28 Feb 2020 12:17:14 +0000 (UTC)
Received: from krava (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 572D75C1B5;
        Fri, 28 Feb 2020 12:17:11 +0000 (UTC)
Date:   Fri, 28 Feb 2020 13:17:08 +0100
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
Subject: Re: [PATCH 10/18] bpf: Re-initialize lnode in bpf_ksym_del
Message-ID: <20200228121708.GH5451@krava>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-11-jolsa@kernel.org>
 <20200227195034.jq76twzwxdlfcwpd@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227195034.jq76twzwxdlfcwpd@ast-mbp>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 11:50:36AM -0800, Alexei Starovoitov wrote:
> On Wed, Feb 26, 2020 at 02:03:37PM +0100, Jiri Olsa wrote:
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
> >  kernel/bpf/core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index c95424fc53de..1af2109b45c7 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -672,6 +672,13 @@ void bpf_ksym_del(struct bpf_ksym *ksym)
> >  	spin_lock_bh(&bpf_lock);
> >  	__bpf_ksym_del(ksym);
> >  	spin_unlock_bh(&bpf_lock);
> > +
> > +	/*
> > +	 * As explained in list_del_rcu, We must call synchronize_rcu
> > +	 * before changing list_head pointers.
> > +	 */
> > +	synchronize_rcu();
> > +	INIT_LIST_HEAD_RCU(&ksym->lnode);
> 
> I don't understand what this is for.
> The comment made it even more confusing.
> What kind of ksym reuse are you expecting?
> 
> Looking at trampoline and dispatcher patches I think cnt == 0
> condition is unnecessary. Just add them to ksym at creation time
> and remove from ksym at destroy. Both are executable code sections.
> Though RIP should never point into them while there are no progs
> I think it's better to keep them in ksym always.
> Imagine sw race conditions in destruction. CPU bugs. What not.

aah ok, that should also solve your first question,
because the code above won't be needed anymore

I wish I read this comment before I prepared elabored ascii/code
picture of why the code above is needed ;-))

> 
> In patch 3 the name
> bpf_get_prog_addr_region(const struct bpf_prog *prog)
> became wrong and 'const' pointer makes it even more misleading.
> The function is not getting prog addr. It's setting ksym's addr.
> I think it should be called:
> bpf_ksym_set_addr(struct bpf_ksym *ksym);
> __always_inline should be removed too.

ok, will change

> 
> Similar in patch 4:
> static void bpf_get_prog_name(const struct bpf_prog *prog)
> also is wrong for the same reasons.
> It probably should be:
> static void bpf_ksym_set_name(struct bpf_ksym *ksym);

ok

> 
> I'm still not confortable with patch 15 sorting bit.
> next = rb_next(&ksym->tnode.node[0]);
> if (next)
> is too tricky for me. I cannot wrap my head yet.
> Since user space doesn't rely on sorted order could you drop it?

yes, as I said I only added it because I liked how simple it
turned out to be

> 
> Do patches 16-18 strongly depend on patches 1-15 ?
> We can take them via bpf-next tree. No problem. Just need Arnaldo's ack.

actualy there're some changes on the list from this week, that touch
the same code, so we might need to take them through Arnaldo's code

I'l double check

> 
> Overall looks great. All around important work.
> Please address above and respin. I would like to land it soon.
> 

will respin soon, thanks for review

jirka

