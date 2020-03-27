Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5F194F5E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgC0DC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:02:26 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:37456 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgC0DCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:02:25 -0400
Received: by mail-il1-f194.google.com with SMTP id a6so7472418ilr.4;
        Thu, 26 Mar 2020 20:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XvGh7t/U9TB56qg/e8cfeP1L5u/Gtl2g1y168+rAvRc=;
        b=NH/OePeuKXgc2QssZKkDL9IphW2MVfpMS3JshbaPYI23f2mYGSc1ZODdPESb5TrJ6/
         vjAq4Xqg1kmmxcIjuI3mt/CvvL72tpNgJa5+k+5bfxeR+DpSpV+mZVHB7HN3KbJf2yx7
         WtiQZ9C5RE5zIs9C6By71Nux7BWnXDnY30VriZpKp5t+jagWvqG0gF78uR703NZ/syqH
         +TxF0JO1Y6FMBrasOPDF0Zy0flOUB6EemGsVMJxlGD4BFzms8mUeqxQGO1mTSc2Lx7ul
         3pyB++kBYmU3YglULW8iz8c1JkKX3BmnAAk/6ykZ6615VpsUW6MlBPgBGie6iOysmV2c
         nO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XvGh7t/U9TB56qg/e8cfeP1L5u/Gtl2g1y168+rAvRc=;
        b=bsn4pLCo+1qR8QWao+Nn8535p7RSe+Z4ySMh5i0DjiWuwLXNuAhXyXW/fpkLL8bCkR
         USXYYP97LIZdSYjUMFWVeV8aoEF9bB5H+/+0P8RDkQ4SWOxwdydTJo/TJd9Mz68/NZkA
         eHcofd8cNHSMiGnRqt1RIQq6J2BaBpEuRDpl4m6ZX4rRDE3Es3/g6daZe03BZ383ruX7
         jYftAoTZyVMyWpgj39qD4yGdufjl+SMhHuO6VX3xmYc3kLKsLi0dwOG8O36YWttE9J/M
         k2lw/mDSqINWg1XzSC+u0faP2Zw+tE6+QYzfNzrU2ZF4oh1ftlKRDJOruC9RiTtVRzRy
         llEg==
X-Gm-Message-State: ANhLgQ3PSyyOkwVBxCV330eHtvIMr4VoLsYPLgs3BP40xm8u+oT/eIkI
        YlWATX121zBUqCWBcWRvwgdJyPsDSA1egRPQWd8=
X-Google-Smtp-Source: ADFU+vuTaLfd3e7xTa3AW37/PjMa023Kqtto9yeReMU5tfoR/3qFiiL8LMIhS94K1vGtwdQN6YU26qodYFD5uZDJGwc=
X-Received: by 2002:a92:83ca:: with SMTP id p71mr11019457ilk.278.1585278144784;
 Thu, 26 Mar 2020 20:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200327012832.19193-1-hqjagain@gmail.com> <20200327023534.GJ3756@localhost.localdomain>
In-Reply-To: <20200327023534.GJ3756@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Fri, 27 Mar 2020 11:02:12 +0800
Message-ID: <CAJRQjofFxvEP+vpWV7ChtEvtzBbfAEiGbj0YhaGP2RKUmQKc8Q@mail.gmail.com>
Subject: Re: [PATCH v5 RESEND] sctp: fix refcount bug in sctp_wfree
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

On Fri, Mar 27, 2020 at 10:35 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Mar 27, 2020 at 09:28:32AM +0800, Qiujun Huang wrote:
> > We should iterate over the datamsgs to modify
>
> Just two small things now.
> s/modify/move/  , it's more accurate.
Get it.

> But mainly because...
>
> ...
> >
> > Reported-and-tested-by:syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
>
> checkpatch.pl is warning that there should be an empty space after the
> ':' here.
forgot that.
>
> Otherwise, looks very good.
>
> Btw, I learned a lot about syzbot new features with your tests, thanks :-)

So do I, thanks.

>
> > Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> > ---
> >  net/sctp/socket.c | 31 +++++++++++++++++++++++--------
> >  1 file changed, 23 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 1b56fc440606..f68076713162 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -147,29 +147,44 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
> >       skb_orphan(chunk->skb);
> >  }
> >
> > +#define traverse_and_process()       \
> > +do {                         \
> > +     msg = chunk->msg;       \
> > +     if (msg == prev_msg)    \
> > +             continue;       \
> > +     list_for_each_entry(c, &msg->chunks, frag_list) {       \
> > +             if ((clear && asoc->base.sk == c->skb->sk) ||   \
> > +                 (!clear && asoc->base.sk != c->skb->sk))    \
> > +                 cb(c);      \
> > +     }                       \
> > +     prev_msg = msg;         \
> > +} while (0)
> > +
> >  static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> > +                                    bool clear,
> >                                      void (*cb)(struct sctp_chunk *))
> >
> >  {
> > +     struct sctp_datamsg *msg, *prev_msg = NULL;
> >       struct sctp_outq *q = &asoc->outqueue;
> > +     struct sctp_chunk *chunk, *c;
> >       struct sctp_transport *t;
> > -     struct sctp_chunk *chunk;
> >
> >       list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
> >               list_for_each_entry(chunk, &t->transmitted, transmitted_list)
> > -                     cb(chunk);
> > +                     traverse_and_process();
> >
> >       list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> > -             cb(chunk);
> > +             traverse_and_process();
> >
> >       list_for_each_entry(chunk, &q->sacked, transmitted_list)
> > -             cb(chunk);
> > +             traverse_and_process();
> >
> >       list_for_each_entry(chunk, &q->abandoned, transmitted_list)
> > -             cb(chunk);
> > +             traverse_and_process();
> >
> >       list_for_each_entry(chunk, &q->out_chunk_list, list)
> > -             cb(chunk);
> > +             traverse_and_process();
> >  }
> >
> >  static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
> > @@ -9574,9 +9589,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> >        * paths won't try to lock it and then oldsk.
> >        */
> >       lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> > -     sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
> > +     sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
> >       sctp_assoc_migrate(assoc, newsk);
> > -     sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
> > +     sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
> >
> >       /* If the association on the newsk is already closed before accept()
> >        * is called, set RCV_SHUTDOWN flag.
> > --
> > 2.17.1
> >
