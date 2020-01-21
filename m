Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97987143A10
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgAUJ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:56:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728826AbgAUJ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579600584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iOa1sC3/AVktbj+jAQ0sD61zOCtTdHzvUutS6GN0AiQ=;
        b=MXtxev4Jou/k3B3lj2Jyzs1ghOwLV3urj5j+D+xM93Zkm+YMyTjL8KIQSA+O8FkgRGDsek
        TPniJtupwRygqjxxe+XF/oUuBUVxT5UsMOngyD/rKd4W6qBd5G5q66BMwLLbKC0GpteXvo
        3Z32aOQyjyf/P0jYxO9yeSo8M8A631A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-0EksdND7MBWocWiE4sjqiA-1; Tue, 21 Jan 2020 04:56:21 -0500
X-MC-Unique: 0EksdND7MBWocWiE4sjqiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE66B10120A1;
        Tue, 21 Jan 2020 09:56:19 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFD4F8BE1B;
        Tue, 21 Jan 2020 09:56:16 +0000 (UTC)
Date:   Tue, 21 Jan 2020 10:56:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 5/6] bpf: Allow to resolve bpf trampoline and dispatcher
 in unwind
Message-ID: <20200121095614.GB707582@krava>
References: <20200118134945.493811-1-jolsa@kernel.org>
 <20200118134945.493811-6-jolsa@kernel.org>
 <133ecb39-c739-02b9-3c83-37ee24846037@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <133ecb39-c739-02b9-3c83-37ee24846037@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:55:10AM +0100, Daniel Borkmann wrote:
> On 1/18/20 2:49 PM, Jiri Olsa wrote:
> > When unwinding the stack we need to identify each address
> > to successfully continue. Adding latch tree to keep trampolines
> > for quick lookup during the unwind.
> > 
> > The patch uses first 48 bytes for latch tree node, leaving 4048
> > bytes from the rest of the page for trampoline or dispatcher
> > generated code.
> > 
> > It's still enough not to affect trampoline and dispatcher progs
> > maximum counts.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/linux/bpf.h     | 12 ++++++-
> >   kernel/bpf/core.c       |  2 ++
> >   kernel/bpf/dispatcher.c |  4 +--
> >   kernel/bpf/trampoline.c | 76 +++++++++++++++++++++++++++++++++++++----
> >   4 files changed, 84 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 8e3b8f4ad183..41eb0cf663e8 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -519,7 +519,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
> >   int bpf_trampoline_link_prog(struct bpf_prog *prog);
> >   int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> >   void bpf_trampoline_put(struct bpf_trampoline *tr);
> > -void *bpf_jit_alloc_exec_page(void);
> >   #define BPF_DISPATCHER_INIT(name) {			\
> >   	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
> >   	.func = &name##func,				\
> > @@ -551,6 +550,13 @@ void *bpf_jit_alloc_exec_page(void);
> >   #define BPF_DISPATCHER_PTR(name) (&name)
> >   void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
> >   				struct bpf_prog *to);
> > +struct bpf_image {
> > +	struct latch_tree_node tnode;
> > +	unsigned char data[];
> > +};
> > +#define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
> > +bool is_bpf_image(void *addr);
> > +void *bpf_image_alloc(void);
> >   #else
> >   static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >   {
> > @@ -572,6 +578,10 @@ static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
> >   static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
> >   					      struct bpf_prog *from,
> >   					      struct bpf_prog *to) {}
> > +static inline bool is_bpf_image(void *addr)
> > +{
> > +	return false;
> > +}
> >   #endif
> >   struct bpf_func_info_aux {
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 29d47aae0dd1..b3299dc9adda 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -704,6 +704,8 @@ bool is_bpf_text_address(unsigned long addr)
> >   	rcu_read_lock();
> >   	ret = bpf_prog_kallsyms_find(addr) != NULL;
> > +	if (!ret)
> > +		ret = is_bpf_image((void *) addr);
> >   	rcu_read_unlock();
> 
> Btw, shouldn't this be a separate entity entirely to avoid unnecessary inclusion
> in bpf_arch_text_poke() for the is_bpf_text_address() check there?

right, we dont want poking in trampolines/dispatchers.. I'll change that

> 
> Did you drop the bpf_{trampoline,dispatcher}_<...> entry addition in kallsyms?

working on that, will send it separately

jirka

