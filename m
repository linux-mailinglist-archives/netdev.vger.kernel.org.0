Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36AEE132708
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgAGNF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:05:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53584 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727834AbgAGNF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578402356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7zyXIPB5Beun47R7crA6T6f7W4w5dVPrsfsDfO9g5Y=;
        b=LHol3jltF3OJvGyxZuawUzOzpRH6Fub++WhLUahsLeevMw+ZDmv5X5H8mtFoWX07oZi8Ld
        Ph6K4ZiChpA7EvvE9bG4D+WfDUfPfAlx3cMnCn9LVmVVOCwuFq5mfTivsuFVfFy7L9x/Ba
        ix2Pm2r96vNKsGoiupcHY9jVELBC1SM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-G_jYcsIIPIWUKbEFo0HuQw-1; Tue, 07 Jan 2020 08:05:53 -0500
X-MC-Unique: G_jYcsIIPIWUKbEFo0HuQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71492801E78;
        Tue,  7 Jan 2020 13:05:51 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2197F272C4;
        Tue,  7 Jan 2020 13:05:48 +0000 (UTC)
Date:   Tue, 7 Jan 2020 14:05:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>, bjorn.topel@intel.com
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
Message-ID: <20200107130546.GI290055@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 03:46:40PM -0800, Alexei Starovoitov wrote:
> On Sun, Dec 29, 2019 at 03:37:40PM +0100, Jiri Olsa wrote:
> > When unwinding the stack we need to identify each
> > address to successfully continue. Adding latch tree
> > to keep trampolines for quick lookup during the
> > unwind.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ...
> > +bool is_bpf_trampoline(void *addr)
> > +{
> > +	return latch_tree_find(addr, &tree, &tree_ops) != NULL;
> > +}
> > +
> >  struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >  {
> >  	struct bpf_trampoline *tr;
> > @@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >  	for (i = 0; i < BPF_TRAMP_MAX; i++)
> >  		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> >  	tr->image = image;
> > +	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
> 
> Thanks for the fix. I was thinking to apply it, but then realized that bpf
> dispatcher logic has the same issue.
> Could you generalize the fix for both?
> May be bpf_jit_alloc_exec_page() can do latch_tree_insert() ?
> and new version of bpf_jit_free_exec() is needed that will do latch_tree_erase().
> Wdyt?

I need to check the dispatcher code, but seems ok.. will check

jirka

