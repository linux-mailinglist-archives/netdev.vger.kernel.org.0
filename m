Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5B15B42E
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgBLW6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:58:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727692AbgBLW6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581548317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQP9qG8d5vgjF4rMsNwiNK+TcFc63/FkSrLWfUt+xtg=;
        b=Vx4TgR4xKqb1zEyrYedm3c3x/83gV2/I11tdsOchNYq/EaaFEd/RBWF8wCwthvcRGMU7c+
        riao//G8cMLBcBkp8IQUugJF4+PGg3FZWBcpoVJzM9xt3ACO+yRYFAIiyh7lndoHjtpXBY
        QqF7XHOXKQyQT77IkZwR3BJtieI8MSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-a89KWLt9NmqrFzPqrGuBbg-1; Wed, 12 Feb 2020 17:58:32 -0500
X-MC-Unique: a89KWLt9NmqrFzPqrGuBbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FF7A107ACC7;
        Wed, 12 Feb 2020 22:58:29 +0000 (UTC)
Received: from krava (ovpn-204-72.brq.redhat.com [10.40.204.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A61665C1B0;
        Wed, 12 Feb 2020 22:58:25 +0000 (UTC)
Date:   Wed, 12 Feb 2020 23:58:22 +0100
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
Subject: Re: [PATCH 12/14] bpf: Add trampolines to kallsyms
Message-ID: <20200212225822.GB233036@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-13-jolsa@kernel.org>
 <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com>
 <20200212111000.GE183981@krava>
 <CAEf4BzZEVOZ36xx882WO30ReG=jkazug-gmWnXhxmA8Ka6PuhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZEVOZ36xx882WO30ReG=jkazug-gmWnXhxmA8Ka6PuhQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 08:33:49AM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 12, 2020 at 3:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Feb 11, 2020 at 10:51:27AM -0800, Andrii Nakryiko wrote:
> > > On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding trampolines to kallsyms. It's displayed as
> > > >   bpf_trampoline_<ID> [bpf]
> > > >
> > > > where ID is the BTF id of the trampoline function.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  include/linux/bpf.h     |  2 ++
> > > >  kernel/bpf/trampoline.c | 23 +++++++++++++++++++++++
> > > >  2 files changed, 25 insertions(+)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 7a4626c8e747..b91bac10d3ea 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -502,6 +502,7 @@ struct bpf_trampoline {
> > > >         /* Executable image of trampoline */
> > > >         void *image;
> > > >         u64 selector;
> > > > +       struct bpf_ksym ksym;
> > > >  };
> > > >
> > > >  #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
> > > > @@ -573,6 +574,7 @@ struct bpf_image {
> > > >  #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
> > > >  bool is_bpf_image_address(unsigned long address);
> > > >  void *bpf_image_alloc(void);
> > > > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
> > > >  /* Called only from code, so there's no need for stubs. */
> > > >  void bpf_ksym_add(struct bpf_ksym *ksym);
> > > >  void bpf_ksym_del(struct bpf_ksym *ksym);
> > > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > > index 6b264a92064b..1ee29907cbe5 100644
> > > > --- a/kernel/bpf/trampoline.c
> > > > +++ b/kernel/bpf/trampoline.c
> > > > @@ -96,6 +96,15 @@ bool is_bpf_image_address(unsigned long addr)
> > > >         return ret;
> > > >  }
> > > >
> > > > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
> > > > +{
> > > > +       struct bpf_image *image = container_of(data, struct bpf_image, data);
> > > > +
> > > > +       ksym->start = (unsigned long) image;
> > > > +       ksym->end = ksym->start + PAGE_SIZE;
> > >
> > > this seems wrong, use BPF_IMAGE_SIZE instead of PAGE_SIZE?
> >
> > BPF_IMAGE_SIZE is the size of the data portion of the image,
> > which is PAGE_SIZE - sizeof(struct bpf_image)
> >
> > here we want to account the whole size = data + tree node (struct bpf_image)
> 
> Why? Seems like the main use case for this is resolve IP to symbol
> (function, dispatcher, trampoline, bpf program, etc). For this
> purpose, you only need part of trampoline actually containing
> executable code?

right, executable code is enough for perf to resolve the symbol

> 
> Also, for bpf_dispatcher in later patch, you are not including struct
> bpf_dispatcher itself, you only include image, so if the idea is to
> include all the code and supporting data structures, that already
> failed for bpf_dispatcher (and can't even work for that case, due to
> dispatcher and image not being part of the same blob of memory, so
> you'll need two symbols).
> 
> So I guess it would be good to be clear on why we include these
> symbols and not mix data and executable parts.

ok it should be only the executable part then, there's more
on the data side that wasn't included and we don't need it

thanks,
jirka

