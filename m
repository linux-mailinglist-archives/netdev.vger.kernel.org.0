Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03241783BD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgCCUMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:12:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56686 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727862AbgCCUMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:12:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583266367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dxWG2muo17acaB7/aJ4BP2oSXZTXhZFiLlw38h5RkZ8=;
        b=FuBQP/NDNxxrjTbVoJICq0ZwN5oTN8Gkj2MKjQ/D7yNyIvs9nU12oEGXdr1vxM8Tt4+dDh
        CjqxYwFcJyNNRGqzzlyww2MhsBTeyrCox4eFGjgCjzYdEs7Bn3CxuE1+GOkqBF+V2y1/9O
        RmKeNAlgwZ1F2xi9IN099J8oVT9Kj14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-2a1tYo-UOva3sXf8guU5mA-1; Tue, 03 Mar 2020 15:12:43 -0500
X-MC-Unique: 2a1tYo-UOva3sXf8guU5mA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA0161005512;
        Tue,  3 Mar 2020 20:12:40 +0000 (UTC)
Received: from krava (ovpn-206-59.brq.redhat.com [10.40.206.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E3331001B3F;
        Tue,  3 Mar 2020 20:12:37 +0000 (UTC)
Date:   Tue, 3 Mar 2020 21:12:26 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 06/15] bpf: Add bpf_ksym_tree tree
Message-ID: <20200303201226.GC74093@krava>
References: <20200302143154.258569-1-jolsa@kernel.org>
 <20200302143154.258569-7-jolsa@kernel.org>
 <20200303180318.vblj7izq2miken6e@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303180318.vblj7izq2miken6e@ast-mbp>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 10:03:19AM -0800, Alexei Starovoitov wrote:
> On Mon, Mar 02, 2020 at 03:31:45PM +0100, Jiri Olsa wrote:
> > The bpf_tree is used both for kallsyms iterations and searching
> > for exception tables of bpf programs, which is needed only for
> > bpf programs.
> > 
> > Adding bpf_ksym_tree that will hold symbols for all bpf_prog
> > bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> > only for bpf_prog objects to keep it fast.
> 
> ...
> 
> >  static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
> > @@ -616,6 +650,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
> >  	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
> >  	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
> >  	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
> > +	latch_tree_insert(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
> >  }
> >  
> >  static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
> > @@ -624,6 +659,7 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
> >  		return;
> >  
> >  	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
> > +	latch_tree_erase(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
> 
> I have to agree with Daniel here.
> Having bpf prog in two latch trees is unnecessary.
> Especially looking at the patch 7 that moves update to the other tree.
> The whole thing becomes assymetrical and harder to follow.
> Consider that walking extable is slow anyway. It's a page fault.
> Having trampoline and dispatch in the same tree will not be measurable
> on the speed of search_bpf_extables->bpf_prog_kallsyms_find.
> So please consolidate.

ok

> 
> Also I don't see a hunk that deletes tnode from 'struct bpf_image'.
> These patches suppose to generalize it too, no?

__bpf_ksym_del function added in patch:

    bpf: Separate kallsyms add/del functions

> And at the end kernel_text_address() suppose to call
> is_bpf_text_address() only, right?
> Instead of is_bpf_text_address() || is_bpf_image_address() ?
> That _will_ actually speed up backtrace collection.

right, this one could have already used just the ksym tree

will send new version.. meanwhile I was checking struct_ops,
so will include kallsyms support them as well

thanks,
jirka

