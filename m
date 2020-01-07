Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D62132767
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgAGNQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:16:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727903AbgAGNQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578402964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FHoUBMZtHY5rP1lv22AoHT1HK9PQ3RLlNM6WgpTQg4E=;
        b=ekPgdR5UqYHQwt+X+q2s82kfxdGK2Lx9w8J6WdDJPQtsEVKfJI8krbJk8dfgtoysLe7UfM
        NJX4z8OrqnuUUIy2vs8vU/vkKa+6f+mPMW+HC9Dputc0cfOnQl/p8/tGehpeH9DHtbU5rI
        MXbtYay+zsZClF22X6cJv0YVITWSU98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-MsUff3fIP5i0DZDkpMTNUA-1; Tue, 07 Jan 2020 08:16:01 -0500
X-MC-Unique: MsUff3fIP5i0DZDkpMTNUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AEE610054E3;
        Tue,  7 Jan 2020 13:15:59 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF9517C34F;
        Tue,  7 Jan 2020 13:15:56 +0000 (UTC)
Date:   Tue, 7 Jan 2020 14:15:54 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>, bjorn.topel@intel.com
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
Message-ID: <20200107131554.GJ290055@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
 <fab5466e-95e7-8abf-c416-6a6f7b7151ba@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fab5466e-95e7-8abf-c416-6a6f7b7151ba@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 09:30:12AM +0100, Daniel Borkmann wrote:
> On 1/7/20 12:46 AM, Alexei Starovoitov wrote:
> > On Sun, Dec 29, 2019 at 03:37:40PM +0100, Jiri Olsa wrote:
> > > When unwinding the stack we need to identify each
> > > address to successfully continue. Adding latch tree
> > > to keep trampolines for quick lookup during the
> > > unwind.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ...
> > > +bool is_bpf_trampoline(void *addr)
> > > +{
> > > +	return latch_tree_find(addr, &tree, &tree_ops) != NULL;
> > > +}
> > > +
> > >   struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > >   {
> > >   	struct bpf_trampoline *tr;
> > > @@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > >   	for (i = 0; i < BPF_TRAMP_MAX; i++)
> > >   		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> > >   	tr->image = image;
> > > +	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
> > 
> > Thanks for the fix. I was thinking to apply it, but then realized that bpf
> > dispatcher logic has the same issue.
> > Could you generalize the fix for both?
> > May be bpf_jit_alloc_exec_page() can do latch_tree_insert() ?
> > and new version of bpf_jit_free_exec() is needed that will do latch_tree_erase().
> > Wdyt?
> 
> Also this patch is buggy since your latch lookup happens under RCU, but
> I don't see anything that waits a grace period once you remove from the
> tree. Instead you free the trampoline right away.

thanks, did not think of that.. will (try to) fix ;-)

> 
> On a different question, given we have all the kallsym infrastructure
> for BPF already in place, did you look into whether it's feasible to
> make it a bit more generic to also cover JITed buffers from trampolines?
> 

hum, it did not occur to me that we want to see it in kallsyms,
but sure.. how about: bpf_trampoline_<key> ?

key would be taken from bpf_trampoline::key as function's BTF id

jirka

