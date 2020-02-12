Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19015A75E
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 12:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBLLKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 06:10:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgBLLKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 06:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581505811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HOHkpNVNh7nL5GYRH5ewTywESYisLcmSPkeZ+2rKpQo=;
        b=QrBZ9HYl+TIELfro1icFiHHYrATz1nAiOgYITS1TStfRIBGChWjUtIz1OP4ezqpaXGlelt
        TGV4oQdLEfgaAplVIP+qSOlgOcewoX3P7pzigIs61dRsN11mj0xzyGXAZOLfoiWEptRxxQ
        13gjrMiIw0sOf100s9BEqEJzxIli9g4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-O_ZqU2BJP52NS-C8JziGxg-1; Wed, 12 Feb 2020 06:10:07 -0500
X-MC-Unique: O_ZqU2BJP52NS-C8JziGxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9124A100551C;
        Wed, 12 Feb 2020 11:10:05 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90D558AC24;
        Wed, 12 Feb 2020 11:10:02 +0000 (UTC)
Date:   Wed, 12 Feb 2020 12:10:00 +0100
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
Message-ID: <20200212111000.GE183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-13-jolsa@kernel.org>
 <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 10:51:27AM -0800, Andrii Nakryiko wrote:
> On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding trampolines to kallsyms. It's displayed as
> >   bpf_trampoline_<ID> [bpf]
> >
> > where ID is the BTF id of the trampoline function.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h     |  2 ++
> >  kernel/bpf/trampoline.c | 23 +++++++++++++++++++++++
> >  2 files changed, 25 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 7a4626c8e747..b91bac10d3ea 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -502,6 +502,7 @@ struct bpf_trampoline {
> >         /* Executable image of trampoline */
> >         void *image;
> >         u64 selector;
> > +       struct bpf_ksym ksym;
> >  };
> >
> >  #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
> > @@ -573,6 +574,7 @@ struct bpf_image {
> >  #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
> >  bool is_bpf_image_address(unsigned long address);
> >  void *bpf_image_alloc(void);
> > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
> >  /* Called only from code, so there's no need for stubs. */
> >  void bpf_ksym_add(struct bpf_ksym *ksym);
> >  void bpf_ksym_del(struct bpf_ksym *ksym);
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 6b264a92064b..1ee29907cbe5 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -96,6 +96,15 @@ bool is_bpf_image_address(unsigned long addr)
> >         return ret;
> >  }
> >
> > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
> > +{
> > +       struct bpf_image *image = container_of(data, struct bpf_image, data);
> > +
> > +       ksym->start = (unsigned long) image;
> > +       ksym->end = ksym->start + PAGE_SIZE;
> 
> this seems wrong, use BPF_IMAGE_SIZE instead of PAGE_SIZE?

BPF_IMAGE_SIZE is the size of the data portion of the image,
which is PAGE_SIZE - sizeof(struct bpf_image)

here we want to account the whole size = data + tree node (struct bpf_image)

> 
> > +       bpf_ksym_add(ksym);
> > +}
> > +
> >  struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >  {
> >         struct bpf_trampoline *tr;
> > @@ -131,6 +140,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >         for (i = 0; i < BPF_TRAMP_MAX; i++)
> >                 INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> >         tr->image = image;
> > +       INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
> >  out:
> >         mutex_unlock(&trampoline_mutex);
> >         return tr;
> > @@ -267,6 +277,15 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
> >         }
> >  }
> >
> > +static void bpf_trampoline_kallsyms_add(struct bpf_trampoline *tr)
> > +{
> > +       struct bpf_ksym *ksym = &tr->ksym;
> > +
> > +       snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu",
> > +                tr->key & ((u64) (1LU << 32) - 1));
> 
> why the 32-bit truncation? also, wouldn't it be more trivial as (u32)tr->key?

tr->key can have the target prog id in upper 32 bits,
I'll try to use the casting as you suggest

> 
> > +       bpf_image_ksym_add(tr->image, &tr->ksym);
> > +}
> > +
> >  int bpf_trampoline_link_prog(struct bpf_prog *prog)
> >  {
> >         enum bpf_tramp_prog_type kind;
> > @@ -311,6 +330,8 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
> >         if (err) {
> >                 hlist_del(&prog->aux->tramp_hlist);
> >                 tr->progs_cnt[kind]--;
> > +       } else if (cnt == 0) {
> > +               bpf_trampoline_kallsyms_add(tr);
> 
> You didn't handle BPF_TRAMP_REPLACE case above.

ugh, right.. will add

> 
> Also this if (err) { ... } else if (cnt == 0) { } pattern is a bit
> convoluted. How about:
> 
> if (err) {
>    ... whatever ...
>    goto out;
> }
> if (cnt == 0) { ... }

yep, that's better

> 
> >         }
> >  out:
> >         mutex_unlock(&tr->mutex);
> > @@ -336,6 +357,8 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
> >         }
> >         hlist_del(&prog->aux->tramp_hlist);
> >         tr->progs_cnt[kind]--;
> > +       if (!(tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]))
> > +               bpf_ksym_del(&tr->ksym);
> 
> same, BPF_TRAMP_REPLACE case. I'd also introduce cnt for consistency
> with bpf_trampoline_link_prog?

ok, thanks a lot for comments

jirka

