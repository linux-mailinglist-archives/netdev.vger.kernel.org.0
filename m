Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA3B2EB85B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbhAFDIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 22:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbhAFDIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 22:08:39 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A52C06134C;
        Tue,  5 Jan 2021 19:07:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ga15so3279196ejb.4;
        Tue, 05 Jan 2021 19:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zg2coLqP9nU4JTLHR8kEQ7+2/BPytE7hyghpbsYNA8Q=;
        b=QAkHOBIABmqEMm4vQ28qot1k2Ngb50RUWs8s/0617cyS9lvR+qjpm/bLFBeSg1txo3
         ymi7qJxAB6KfToui61+put7CZ95SFKfsXtgjx4bgghJT3HzQc7rxqBTO8Rya7R6cTVZM
         dCnU/bttAdy/Yiwi9mBV6NP1iX1DG9V+TEXVub1vgeJxU8AeBdFsELqJJ8akSgDIfQUX
         ENi7g+NYkcmLJVq9SqZG9MfGFfAjhf2eKwlQZOqt8ai8RHJ2GD7KqcAqJR4k/QaQuGRo
         k/74CKkO+Xo/kNwG5UbR7JZc8pL0f7ocLAmlJ+Q27vXb25uf/73Np8OJjOqk+6/QN0vh
         SxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zg2coLqP9nU4JTLHR8kEQ7+2/BPytE7hyghpbsYNA8Q=;
        b=d3+J0VmELYo/ncYaR4h/yNRTbzG0knFOiGR64qTLpZjCXHUQeEUA0C4MIxGzCp9nyO
         xW+RRKnQJmljGKvWGIAU1zKxwfSl4ha2QLtRdShhlucHwB+NXpf4TzxVM8o8PqcBolFt
         OXCT5nZiNKHhua/VcYchvTb2trjxSOb4la1tfRzIxp484/yUtZYIVmVpjW0vtn3rmN2K
         esmEBxxsutkKY3rLT8G9fj27FAjndfCmSEt/iVi0FRZ2MUhdOcdxJpv6MePTYa5X8FXU
         iBblvT48yUnKZ7TrSwpcPcH6monQ1iQsd4F+AOlBIZF519GB1DY2ujVgX1mA04Cg4mwB
         0i5w==
X-Gm-Message-State: AOAM5317UhB+XXPW6XP3QnWrPaV95K76G7xJUcIhJtaf//TAGvsjQ4an
        ASI6VMDytU9RMwsnUnVQSQwaV+opKuQ6mQB9iQI=
X-Google-Smtp-Source: ABdhPJwOPQkdrn2LjjxlF2BA0tEJor9O1FFa1oV8vPiPoJZtb7K7A04MS7jEGIa+iN1hxuLroJckYXHPQHIAktx2RnU=
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr1510008ejn.504.1609902477257;
 Tue, 05 Jan 2021 19:07:57 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
 <1609750005-115609-1-git-send-email-dseok.yi@samsung.com> <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
 <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
In-Reply-To: <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 5 Jan 2021 22:07:21 -0500
Message-ID: <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix use-after-free when UDP GRO with shared fraglist
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Marco Elver <elver@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, namkyu78.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On 2021-01-05 06:03, Willem de Bruijn wrote:
> >
> > On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > >
> > > skbs in frag_list could be shared by pskb_expand_head() from BPF.
> >
> > Can you elaborate on the BPF connection?
>
> With the following registered ptypes,
>
> /proc/net # cat ptype
> Type Device      Function
> ALL           tpacket_rcv
> 0800          ip_rcv.cfi_jt
> 0011          llc_rcv.cfi_jt
> 0004          llc_rcv.cfi_jt
> 0806          arp_rcv
> 86dd          ipv6_rcv.cfi_jt
>
> BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
> (or ipv6_rcv). And it calls pskb_expand_head.
>
> [  132.051228] pskb_expand_head+0x360/0x378
> [  132.051237] skb_ensure_writable+0xa0/0xc4
> [  132.051249] bpf_skb_pull_data+0x28/0x60
> [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
> [  132.051273] cls_bpf_classify+0x254/0x348
> [  132.051284] tcf_classify+0xa4/0x180

Ah, you have a BPF program loaded at TC. That was not entirely obvious.

This program gets called after packet sockets with ptype_all, before
those with a specific protocol.

Tcpdump will have inserted a program with ptype_all, which cloned the
skb. This triggers skb_ensure_writable -> pskb_expand_head ->
skb_clone_fraglist -> skb_get.

> [  132.051294] __netif_receive_skb_core+0x590/0xd28
> [  132.051303] __netif_receive_skb+0x50/0x17c
> [  132.051312] process_backlog+0x15c/0x1b8
>
> >
> > > While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> > > But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> > > chain made by skb_segment_list().
> > >
> > > If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> > > multiple ptypes can see this. The skb could be released by ptypes and
> > > it causes use-after-free.
> >
> > If I understand correctly, a udp-gro-list skb makes it up the receive
> > path with one or more active packet sockets.
> >
> > The packet socket will call skb_clone after accepting the filter. This
> > replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> >
> > udp_rcv_segment later converts the udp-gro-list skb to a list of
> > regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> > Now all the frags are fully fledged packets, with headers pushed
> > before the payload. This does not change their refcount anymore than
> > the skb_clone in pf_packet did. This should be 1.
> >
> > Eventually udp_recvmsg will call skb_consume_udp on each packet.
> >
> > The packet socket eventually also frees its cloned head_skb, which triggers
> >
> >   kfree_skb_list(shinfo->frag_list)
> >     kfree_skb
> >       skb_unref
> >         refcount_dec_and_test(&skb->users)
>
> Every your understanding is right, but
>
> >
> > >
> > > [ 4443.426215] ------------[ cut here ]------------
> > > [ 4443.426222] refcount_t: underflow; use-after-free.
> > > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > > refcount_dec_and_test_checked+0xa4/0xc8
> > > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > > [ 4443.426808] Call trace:
> > > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > > [ 4443.426823]  skb_release_data+0x144/0x264
> > > [ 4443.426828]  kfree_skb+0x58/0xc4
> > > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > > [ 4443.426880]  el0_svc+0x8/0xc
> > >
> > > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > ---
> > >  net/core/skbuff.c | 20 +++++++++++++++++++-
> > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index f62cae3..1dcbda8 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > >         unsigned int delta_truesize = 0;
> > >         unsigned int delta_len = 0;
> > >         struct sk_buff *tail = NULL;
> > > -       struct sk_buff *nskb;
> > > +       struct sk_buff *nskb, *tmp;
> > > +       int err;
> > >
> > >         skb_push(skb, -skb_network_offset(skb) + offset);
> > >
> > > @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > >                 nskb = list_skb;
> > >                 list_skb = list_skb->next;
> > >
> > > +               err = 0;
> > > +               if (skb_shared(nskb)) {
> >
> > I must be missing something still. This does not square with my
> > understanding that the two sockets are operating on clones, with each
> > frag_list skb having skb->users == 1.
> >
> > Unless the packet socket patch previously also triggered an
> > skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> > calls skb_get on each frag_list skb.
>
> A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
> with the original shinfo. pskb_expand_head reallocates the shinfo of
> the skb and call skb_clone_fraglist. skb_release_data in
> pskb_expand_head could not reduce skb->users of the each frag_list skb
> if skb_shinfo(skb)->dataref == 2.
>
> After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
> skb could have skb->users == 2.

Yes, that makes sense. skb_clone_fraglist just increments the
frag_list skb's refcounts.

skb_segment_list must create an unshared struct sk_buff before it
changes skb data to insert the protocol headers.

> >
> >
> > > +                       tmp = skb_clone(nskb, GFP_ATOMIC);
> > > +                       if (tmp) {
> > > +                               kfree_skb(nskb);
> > > +                               nskb = tmp;
> > > +                               err = skb_unclone(nskb, GFP_ATOMIC);

Calling clone and unclone in quick succession looks odd.

But you need the first to create a private skb and to trigger the
second to create a private copy of the linear data (as well as frags,
if any, but these are not touched). So this looks okay.

> > > +                       } else {
> > > +                               err = -ENOMEM;
> > > +                       }
> > > +               }
> > > +
> > >                 if (!tail)
> > >                         skb->next = nskb;
> > >                 else
> > >                         tail->next = nskb;
> > >
> > > +               if (unlikely(err)) {
> > > +                       nskb->next = list_skb;

To avoid leaking these skbs when calling kfree_skb_list(skb->next). Is
that concern new with this patch, or also needed for the existing
error case?

> > > +                       goto err_linearize;
> > > +               }
> > > +
> > >                 tail = nskb;
> > >
> > >                 delta_len += nskb->len;
> > > --
> > > 2.7.4
> > >
>
