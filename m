Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1B016401A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgBSJRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:17:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20767 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726495AbgBSJRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582103849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9H+8g76ZRLHoi0QfrBdHaCd9NKX1hy9Hlg4zvECqkTw=;
        b=atTWytk4omSeFuDnptddyFIGb9E4RGKK5pL3oU3jtq7XAmBb7rLkcI+5JYW/uyWCLx8pxo
        YuSXidFF5jkzfRBHss18s+6QDYAgUfOQUJCvhZ/YGsK3WdQmNqzrFcaY8+ecWb3C0L7Gnq
        LbtkeFcZj6+YkjksDCUsxGBte4NLENI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-dYGvu_u4PTCxgY7AnTj_Cg-1; Wed, 19 Feb 2020 04:17:18 -0500
X-MC-Unique: dYGvu_u4PTCxgY7AnTj_Cg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BE3C101FC60;
        Wed, 19 Feb 2020 09:17:16 +0000 (UTC)
Received: from krava (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B29E062660;
        Wed, 19 Feb 2020 09:17:13 +0000 (UTC)
Date:   Wed, 19 Feb 2020 10:17:11 +0100
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
Subject: Re: [PATCH 03/18] bpf: Add struct bpf_ksym
Message-ID: <20200219091711.GD439238@krava>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-4-jolsa@kernel.org>
 <d61ff7d5-f0a7-8828-cf94-54936670f244@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d61ff7d5-f0a7-8828-cf94-54936670f244@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 12:03:49AM +0100, Daniel Borkmann wrote:
> On 2/16/20 8:29 PM, Jiri Olsa wrote:
> > Adding 'struct bpf_ksym' object that will carry the
> > kallsym information for bpf symbol. Adding the start
> > and end address to begin with. It will be used by
> > bpf_prog, bpf_trampoline, bpf_dispatcher.
> > 
> > Using the bpf_func for program symbol start instead
> > of the image start, because it will be used later for
> > kallsyms program value and it makes no difference
> > (compared to the image start) for sorting bpf programs.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/linux/bpf.h |  6 ++++++
> >   kernel/bpf/core.c   | 26 +++++++++++---------------
> >   2 files changed, 17 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index be7afccc9459..5ad8eea1cd37 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -462,6 +462,11 @@ int arch_prepare_bpf_trampoline(void *image, void *image_end,
> >   u64 notrace __bpf_prog_enter(void);
> >   void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
> > +struct bpf_ksym {
> > +	unsigned long		 start;
> > +	unsigned long		 end;
> > +};
> > +
> >   enum bpf_tramp_prog_type {
> >   	BPF_TRAMP_FENTRY,
> >   	BPF_TRAMP_FEXIT,
> > @@ -643,6 +648,7 @@ struct bpf_prog_aux {
> >   	u32 size_poke_tab;
> >   	struct latch_tree_node ksym_tnode;
> >   	struct list_head ksym_lnode;
> > +	struct bpf_ksym ksym;
> >   	const struct bpf_prog_ops *ops;
> >   	struct bpf_map **used_maps;
> >   	struct bpf_prog *prog;
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 973a20d49749..39a9e4184900 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -524,17 +524,15 @@ int bpf_jit_harden   __read_mostly;
> >   long bpf_jit_limit   __read_mostly;
> >   static __always_inline void
> > -bpf_get_prog_addr_region(const struct bpf_prog *prog,
> > -			 unsigned long *symbol_start,
> > -			 unsigned long *symbol_end)
> > +bpf_get_prog_addr_region(const struct bpf_prog *prog)
> >   {
> >   	const struct bpf_binary_header *hdr = bpf_jit_binary_hdr(prog);
> >   	unsigned long addr = (unsigned long)hdr;
> >   	WARN_ON_ONCE(!bpf_prog_ebpf_jited(prog));
> > -	*symbol_start = addr;
> > -	*symbol_end   = addr + hdr->pages * PAGE_SIZE;
> > +	prog->aux->ksym.start = (unsigned long) prog->bpf_func;
> 
> Your commit descriptions are too terse. :/ What does "because it will be used
> later for kallsyms program value" mean exactly compared to how it's used today
> for programs?

there's symbol_start/symbol_end values originally used to sort
bpf_prog objects, and there's prog->bpf_func value used as address
that is displayed in the /proc/kallsyms

I'm putting prog->bpf_func to bpf_ksym->start, so it's later on
displayed as bpf_prog address in /proc/kallsyms in this patch:

	bpf: Add lnode list node to struct bpf_ksym
	---
	@@ -736,13 +736,13 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
			return ret;
	 
		rcu_read_lock();
	-       list_for_each_entry_rcu(aux, &bpf_kallsyms, ksym_lnode) {
	+       list_for_each_entry_rcu(ksym, &bpf_kallsyms, lnode) {
			if (it++ != symnum)
				continue;
	 
	-               strncpy(sym, aux->ksym.name, KSYM_NAME_LEN);
	+               strncpy(sym, ksym->name, KSYM_NAME_LEN);
	 
	-               *value = (unsigned long)aux->prog->bpf_func;
	+               *value = ksym->start;
			*type  = BPF_SYM_ELF_TYPE;


and also the prog->bpf_func value is now used as memory 'start' to
sort bpf_prog objects, which will do the same job as symbol_start

but maybe we could have 'kallsym' value in 'bpf_ksym' which would be
used as value to display in /proc/kallsyms kallsyms, like:

  struct bpf_ksym {
    unsigned long  start;
    unsigned long  end;
    unsigned long  kallsyms;
  }

and keep 'start/end' to be the whole memory bounds for sorting to
avoid any confusion and surprises in future

> 
> Is this a requirement to have them point exactly to prog->bpf_func and if so
> why? My concern is that bpf_func has a random offset from hdr, so even if the
> /proc/kallsyms would be readable with concrete addresses for !cap_sys_admin
> users, it's still not the concrete start address being exposed there, but the
> allocated range instead.

there was last review suggestion from Andrii to display the address
of the actual code start for trampolines and dispatchers instead
of the start of the who;e memory image, which is actually what we
need for perf

jirka

