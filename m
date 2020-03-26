Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854611937EF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCZFhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:37:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41186 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZFhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:37:21 -0400
Received: by mail-io1-f66.google.com with SMTP id y24so4816218ioa.8;
        Wed, 25 Mar 2020 22:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yjzInxM0pIYbsUCVZCe5a0aF1UXSDBe5qOylaXntsgg=;
        b=sEfodghILrA7zg5Jpmc1g+tluz4aIELMRWGcR2UqEhod3PmdZVWMUQnBVbRHJkLnd4
         35haqHOVMue4TQr6C7CSFDgOSnUkifMrjl+OMh3/KQo9WvIKrnZ/Qt5r3oNMUoubYVkw
         6GZeQugdPAECiXC+CzeMEOVS4LoqHO87d8fgLYPbVQJl5hLkqPc/sRn/mBNsxIjLwaYu
         D/7pqDUMpeIMX43LS9Dn+376mxr+VqHs60CaDlrmkBdM3R80bNo0V9FdbcFwLp0qRGk2
         RbcA9qijL/YL2XXchsMYI0izFOf/XZbEvAdd2mhQxT+T/do2MNrLN1TNoa7Y5vcgXRFs
         r73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yjzInxM0pIYbsUCVZCe5a0aF1UXSDBe5qOylaXntsgg=;
        b=rQFksGKGGgAmco/Q7O6ookDJ7f9jS9EhIovH2j/Yjcw+EA1u7bH0Hd1Ml4kC79/wKJ
         YCbfdm6RhgU2VGLtZSfVlzvoB4CJuUdEMMIcgdgDHpL6juj+ENSGXWxPfWii5JJcDqYO
         n9Ukc46XJ6/Wme7o4pRo14GnF8D3c2yonDQLeCVjzSTlhT7/AKkAGpVvGLdO1mbkQi51
         rgmgJ7skvsry1YNMWGlV/Mg1klk0kD2xYwCQwxX3zzQTFEGGJ41YISjU/Lt1zEBmQCnb
         uw6ApCHpDXRNH+51ZG93rRme9kEAbxgPx281DOvarV6fniLQUCFWWujRH9CjCZHvwDf4
         LPcQ==
X-Gm-Message-State: ANhLgQ2PKU8rfpEqd4fC/HyV4NQLL1Nb863dNe8Qb/KOD0ZzZMvse0fB
        jGsYVVt4MEKsrh71lIg2l0zQ6Ww0yLg0R/YR4lwkwSMx+QEMRw==
X-Google-Smtp-Source: ADFU+vvkoZa+7GNGNGrLJtZyF5EQgA4y/IMboSp8zlk8PLJTzaNQgSYzDsAHHSuu7AvsFD2Anhn/FqJS0Sh89fhGkLs=
X-Received: by 2002:a6b:c813:: with SMTP id y19mr6237617iof.125.1585201039849;
 Wed, 25 Mar 2020 22:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200322090425.6253-1-hqjagain@gmail.com> <20200326001416.GH3756@localhost.localdomain>
 <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com> <20200326032252.GI3756@localhost.localdomain>
In-Reply-To: <20200326032252.GI3756@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Thu, 26 Mar 2020 13:37:08 +0800
Message-ID: <CAJRQjoecj9Dwbs_bDhiFT_rbhSFh_PwPNW9dHUvaNcd+2RreJg@mail.gmail.com>
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 11:22 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Mar 26, 2020 at 09:30:08AM +0800, Qiujun Huang wrote:
> > On Thu, Mar 26, 2020 at 8:14 AM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> > > > sctp_sock_migrate should iterate over the datamsgs to modify
> > > > all trunks(skbs) to newsk. For this, out_msg_list is added to
> > >
> > > s/trunks/chunks/
> >
> > My :p.
> >
> > >
> > > > sctp_outq to maintain datamsgs list.
> > >
> > > It is an interesting approach. It speeds up the migration, yes, but it
> > > will also use more memory per datamsg, for an operation that, when
> > > performed, the socket is usually calm.
> > >
> > > It's also another list to be handled, and I'm not seeing the patch
> > > here move the datamsg itself now to the new outq. It would need
> > > something along these lines:
> >
> > Are all the rx chunks in the rx queues?
>
> Yes, even with GSO.
>
> >
> > > sctp_sock_migrate()
> > > {
> > > ...
> > >         /* Move any messages in the old socket's receive queue that are for the
> > >          * peeled off association to the new socket's receive queue.
> > >          */
> > >         sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
> > >                 event = sctp_skb2event(skb);
> > > ...
> > >                 /* Walk through the pd_lobby, looking for skbs that
> > >                  * need moved to the new socket.
> > >                  */
> > >                 sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
> > >                         event = sctp_skb2event(skb);
> > >
> > > That said, I don't think it's worth this new list.
> >
> > About this case:
> > datamsg
> >                    ->chunk0                       chunk1
> >        chunk2
> >  queue          ->transmitted                 ->retransmit
> >  ->not in any queue
>
> We always can find it through the other chunks, otherwise it's freed.

Yes.

datamsg   (chunk0, chunk1, chunk2)
chunk1 in transmiited queue
chunk2 in retransmit queue
chunk0 not in any queue

 We also need to check chunk2->msg processed or not, when we iterate
retransmit queue.

>
> >
> > Also need to maintain a datamsg list to record which datamsg is
> > processed avoiding repetitive
> > processing.
>
> Right, but for that we can add a simple check on
> sctp_for_each_tx_datamsg() based on a parameter.
>
> > So, list it to outq. Maybe it will be used sometime.
>
> We can change it when the time comes. For now, if we can avoid growing
> sctp_datamsg, it's better. With this patch, it grows from 40 to 56
> bytes, leaving just 8 left before it starts using a slab of 128 bytes
> for it.

I get that, thanks.

>
>
> The patched list_for_each_entry() can/should be factored out into
> __sctp_for_each_tx_datachunk, whose first parameter then is the queue
> instead the asoc.
>
> ---8<---
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index fed26a1e9518..62f401799709 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -148,19 +148,30 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
>  }
>
>  static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> +                                      bool clear,
>                                        void (*cb)(struct sctp_chunk *))
>
>  {
> +       struct sctp_datamsg *msg, *prev_msg = NULL;
>         struct sctp_outq *q = &asoc->outqueue;
> +       struct sctp_chunk *chunk, *c;
>         struct sctp_transport *t;
> -       struct sctp_chunk *chunk;
>
>         list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
>                 list_for_each_entry(chunk, &t->transmitted, transmitted_list)
>                         cb(chunk);
>
> -       list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> -               cb(chunk);
> +       list_for_each_entry(chunk, &q->sacked, transmitted_list) {
> +               msg = chunk->msg;
> +               if (msg == prev_msg)
> +                       continue;
> +               list_for_each_entry(c, &msg->chunks, frag_list) {
> +                       if ((clear && asoc->base.sk == c->skb->sk) ||
> +                           (!clear && asoc->base.sk != c->skb->sk))
> +                               cb(c);
> +               }
> +               prev_msg = msg;
> +       }

The case exists?
datamsg   (chunk0, chunk1, chunk2)
chunk1 chunk2 in &q->retransmit
chunk0 not in any queue (deleted in sctp_outq_sack)

>         list_for_each_entry(chunk, &q->sacked, transmitted_list)
>                 cb(chunk);
> @@ -9574,9 +9585,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>          * paths won't try to lock it and then oldsk.
>          */
>         lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> -       sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
> +       sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
>         sctp_assoc_migrate(assoc, newsk);
> -       sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
> +       sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
>
>         /* If the association on the newsk is already closed before accept()
>          * is called, set RCV_SHUTDOWN flag.
