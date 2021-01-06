Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5442EC1DE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbhAFROv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbhAFROu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:14:50 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6EBC06134D;
        Wed,  6 Jan 2021 09:14:10 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so5006380edu.11;
        Wed, 06 Jan 2021 09:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjdy3LSwb/LBfqLrKmUZfH/sdZsTFfQCddG/+mZNi4k=;
        b=IAJL+4tVOUuFWrxidklnnmun8q2GPQH5dmcCLtTT6TabYVCqYVady9pV1kMGOrRPZG
         xbKuRyZ4qgmE4xFCVpUrm28B3743gKh4BT6udZCvkIdZTkS/gFm/6JxZJwPjZ28laHir
         iu1hrRchGnQQF7V7T91RJSbETUUYMT77vJdBkWUK3GR4uwk29GBf+loCApxo89mGKFxq
         LK/FxxjWdlqBypMN9a69qfj4UuwuOnv/y/5xLIoXh6kwYb7EASYL+u7tMzuauHQlSNhG
         NIcG31/Qecd07ZLdVurBiJ1IVyWEKxsf1wc8T3TdqyiRhjqH/htNh7DxubEDUu/eKmKs
         i/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjdy3LSwb/LBfqLrKmUZfH/sdZsTFfQCddG/+mZNi4k=;
        b=MyjVFcYlIIY2juK0VZWKcN2ZNsFRjgrrMEu3hgCy+l9mB/uV2kM2J2NY1MhvBvXDeH
         jK04I8prfyukfH1OI9poGZHgveOYGuJSfpKvVvUqIJpRpUAnIHcWrfkCs7fnetn6AbOS
         KtWt1jC7W4/1OOIx9yk8ktmdYQDn0kuUtYD9giTP9vaL4DyMh8dGGyhRRhFelwGp+Pon
         g8bbYz2cuQgU4zcB84taBph4MXjZCkCDNSDvhLvl4qQH3lqzJGC2C76/E/jsa4NoxoTx
         vzQYQ3kmpyxFflaBpljA27+VErNcGx4s/Z9SLBT2OwaOcmgcBQWhNnYMApd5j2ueIs5N
         2peA==
X-Gm-Message-State: AOAM531rTpvLeXmw5V6q5X7341Z0pNN2T93D+i8ml4mRAR5xDPF1Z9nB
        8Tf0rdkVTOweo6TJxQ6zH9TtLBTH64TsXnLRUGM=
X-Google-Smtp-Source: ABdhPJyt70emFsZtycX+Ivkkh+Ze/wujYVUQihhieax+ht6Bm3DG8Kibi4NwcKRq7krczvUKB+QgS+wIjJWm6m0xa78=
X-Received: by 2002:a50:ec18:: with SMTP id g24mr4599966edr.6.1609953248684;
 Wed, 06 Jan 2021 09:14:08 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
 <1609750005-115609-1-git-send-email-dseok.yi@samsung.com> <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
 <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com> <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
 <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
In-Reply-To: <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Jan 2021 12:13:33 -0500
Message-ID: <CAF=yD-+w489MoSKfpaH23dYXhVCL2qh4f0x4COd2nsT5DT8Aiw@mail.gmail.com>
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

On Tue, Jan 5, 2021 at 10:32 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On 2021-01-06 12:07, Willem de Bruijn wrote:
> >
> > On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > >
> > > On 2021-01-05 06:03, Willem de Bruijn wrote:
> > > >
> > > > On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > > > >
> > > > > skbs in frag_list could be shared by pskb_expand_head() from BPF.
> > > >
> > > > Can you elaborate on the BPF connection?
> > >
> > > With the following registered ptypes,
> > >
> > > /proc/net # cat ptype
> > > Type Device      Function
> > > ALL           tpacket_rcv
> > > 0800          ip_rcv.cfi_jt
> > > 0011          llc_rcv.cfi_jt
> > > 0004          llc_rcv.cfi_jt
> > > 0806          arp_rcv
> > > 86dd          ipv6_rcv.cfi_jt
> > >
> > > BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
> > > (or ipv6_rcv). And it calls pskb_expand_head.
> > >
> > > [  132.051228] pskb_expand_head+0x360/0x378
> > > [  132.051237] skb_ensure_writable+0xa0/0xc4
> > > [  132.051249] bpf_skb_pull_data+0x28/0x60
> > > [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
> > > [  132.051273] cls_bpf_classify+0x254/0x348
> > > [  132.051284] tcf_classify+0xa4/0x180
> >
> > Ah, you have a BPF program loaded at TC. That was not entirely obvious.
> >
> > This program gets called after packet sockets with ptype_all, before
> > those with a specific protocol.
> >
> > Tcpdump will have inserted a program with ptype_all, which cloned the
> > skb. This triggers skb_ensure_writable -> pskb_expand_head ->
> > skb_clone_fraglist -> skb_get.
> >
> > > [  132.051294] __netif_receive_skb_core+0x590/0xd28
> > > [  132.051303] __netif_receive_skb+0x50/0x17c
> > > [  132.051312] process_backlog+0x15c/0x1b8
> > >
> > > >
> > > > > While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> > > > > But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> > > > > chain made by skb_segment_list().
> > > > >
> > > > > If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> > > > > multiple ptypes can see this. The skb could be released by ptypes and
> > > > > it causes use-after-free.
> > > >
> > > > If I understand correctly, a udp-gro-list skb makes it up the receive
> > > > path with one or more active packet sockets.
> > > >
> > > > The packet socket will call skb_clone after accepting the filter. This
> > > > replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> > > >
> > > > udp_rcv_segment later converts the udp-gro-list skb to a list of
> > > > regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> > > > Now all the frags are fully fledged packets, with headers pushed
> > > > before the payload. This does not change their refcount anymore than
> > > > the skb_clone in pf_packet did. This should be 1.
> > > >
> > > > Eventually udp_recvmsg will call skb_consume_udp on each packet.
> > > >
> > > > The packet socket eventually also frees its cloned head_skb, which triggers
> > > >
> > > >   kfree_skb_list(shinfo->frag_list)
> > > >     kfree_skb
> > > >       skb_unref
> > > >         refcount_dec_and_test(&skb->users)
> > >
> > > Every your understanding is right, but
> > >
> > > >
> > > > >
> > > > > [ 4443.426215] ------------[ cut here ]------------
> > > > > [ 4443.426222] refcount_t: underflow; use-after-free.
> > > > > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > > > > refcount_dec_and_test_checked+0xa4/0xc8
> > > > > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > > > > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > > > > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > > > > [ 4443.426808] Call trace:
> > > > > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > > > > [ 4443.426823]  skb_release_data+0x144/0x264
> > > > > [ 4443.426828]  kfree_skb+0x58/0xc4
> > > > > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > > > > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > > > > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > > > > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > > > > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > > > > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > > > > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > > > > [ 4443.426880]  el0_svc+0x8/0xc
> > > > >
> > > > > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > > ---
> > > > >  net/core/skbuff.c | 20 +++++++++++++++++++-
> > > > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > index f62cae3..1dcbda8 100644
> > > > > --- a/net/core/skbuff.c
> > > > > +++ b/net/core/skbuff.c
> > > > > @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > > >         unsigned int delta_truesize = 0;
> > > > >         unsigned int delta_len = 0;
> > > > >         struct sk_buff *tail = NULL;
> > > > > -       struct sk_buff *nskb;
> > > > > +       struct sk_buff *nskb, *tmp;
> > > > > +       int err;
> > > > >
> > > > >         skb_push(skb, -skb_network_offset(skb) + offset);
> > > > >
> > > > > @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > > >                 nskb = list_skb;
> > > > >                 list_skb = list_skb->next;
> > > > >
> > > > > +               err = 0;
> > > > > +               if (skb_shared(nskb)) {
> > > >
> > > > I must be missing something still. This does not square with my
> > > > understanding that the two sockets are operating on clones, with each
> > > > frag_list skb having skb->users == 1.
> > > >
> > > > Unless the packet socket patch previously also triggered an
> > > > skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> > > > calls skb_get on each frag_list skb.
> > >
> > > A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
> > > with the original shinfo. pskb_expand_head reallocates the shinfo of
> > > the skb and call skb_clone_fraglist. skb_release_data in
> > > pskb_expand_head could not reduce skb->users of the each frag_list skb
> > > if skb_shinfo(skb)->dataref == 2.
> > >
> > > After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
> > > skb could have skb->users == 2.
> >
> > Yes, that makes sense. skb_clone_fraglist just increments the
> > frag_list skb's refcounts.
> >
> > skb_segment_list must create an unshared struct sk_buff before it
> > changes skb data to insert the protocol headers.
> >
> > > >
> > > >
> > > > > +                       tmp = skb_clone(nskb, GFP_ATOMIC);
> > > > > +                       if (tmp) {
> > > > > +                               kfree_skb(nskb);
> > > > > +                               nskb = tmp;
> > > > > +                               err = skb_unclone(nskb, GFP_ATOMIC);
> >
> > Calling clone and unclone in quick succession looks odd.
> >
> > But you need the first to create a private skb and to trigger the
> > second to create a private copy of the linear data (as well as frags,
> > if any, but these are not touched). So this looks okay.
> >
> > > > > +                       } else {
> > > > > +                               err = -ENOMEM;
> > > > > +                       }
> > > > > +               }
> > > > > +
> > > > >                 if (!tail)
> > > > >                         skb->next = nskb;
> > > > >                 else
> > > > >                         tail->next = nskb;
> > > > >
> > > > > +               if (unlikely(err)) {
> > > > > +                       nskb->next = list_skb;
> >
> > To avoid leaking these skbs when calling kfree_skb_list(skb->next). Is
> > that concern new with this patch, or also needed for the existing
> > error case?
>
> It's new for this patch. nskb can lose next skb due to
> tmp = skb_clone(nskb, GFP_ATOMIC); on the prior. I believe it is not
> needed for the existing errors.

Ah, skb_clone clears the next pointer, indeed. Thanks.

Yes, then this looks correct to me. Thanks for fixing, not an obvious
code path or bug at all.

Acked-by: Willem de Bruijn <willemb@google.com>

The patch is already marked as changes requested in
https://patchwork.kernel.org/project/netdevbpf , so you might have to
resubmit it.

If so, please expand a little bit in the commit message on the fact
that a bpf filter is loaded at TC, which triggers skb_ensure_writable
-> pskb_expand_head -> skb_clone_fraglist -> skb_get on each skb in
the fraglist.
