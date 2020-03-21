Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA96718DD76
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 02:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgCUBdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 21:33:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35943 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCUBdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 21:33:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id d11so9226632qko.3;
        Fri, 20 Mar 2020 18:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nWwxA1w2Gatv80CNv5vvgq55JU/X2LGJD7QRCwC8gwI=;
        b=ODKjjbxzI8SNz+b/0IuuUCfMJejDoMhqo4S5/Se9pve6CE5nc6PSWIOf9dQVKhaG5O
         qwBek0oPpvBkEMzaZYKP06cc7rd3PvUcrYxARQ8Ovh/z8r8ATxtSajk+oF1hXIp0ukLy
         NKWUx/63Eosw1W7ALEWbzc2PduE1Zoj9WFHkHezKtpOzMoy2xBa5TtC1pufFlid+ubpd
         Sxyij2fCCqosZLM/h7wWF1Gk7nApgxhj1cuJyikRW1wpGm3tjveG5Coj8kKlRUcroPqy
         DYmwdBstNr3tGmk9n32wNhMIVSpxEytCJufe9BfsmS0XuC6J6Hkj5nx01QaTEoeZNtFO
         tlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nWwxA1w2Gatv80CNv5vvgq55JU/X2LGJD7QRCwC8gwI=;
        b=ZZG98/lghIqfS6X9Eg+WLekmwMfGcjclc5VjF0iqpc6iCyclm45hnZfqOINn2aCSUh
         Qve2RYDuEMrQpLbqi9r/QnvEspBKWzGGFf4AlstwIgGlFtWVU65dYIi6fkFWWkH6Z4Kg
         dC0gMCPOwDmF2u4i28JzLmJYQu0t9Ej75EPpZrRPgJMyfTtOyxMoGWQq23PYmU7+4J+9
         2d8siqDNCcQkv6z+IQFLCGWPcz+ZPVbbCBPSQuwR5BFtCc0kdTOqbOh5pdOjyYwIUGVW
         M+X9GFyyZEHvACzuqxZ+PXWRDvTX+WNKop7BiIVjCiezw0SL7EDra+POK0CJM4qdE6ge
         p/GQ==
X-Gm-Message-State: ANhLgQ3XJuv/uf7WKmk0zanVLEd6mXX7GoxmnwghLil6HB/aTp9EElDy
        /3gy2tcmYrDhqcxs5lJZ1O6gQiPEsA8=
X-Google-Smtp-Source: ADFU+vvqQolRXIQc2exeSbFG1CBzPB/poNUc/fxuZJ8RBP83GZQ6ro++PzlJfM04BVJ8Xo6SBI+nlQ==
X-Received: by 2002:a37:e47:: with SMTP id 68mr10646046qko.17.1584754400994;
        Fri, 20 Mar 2020 18:33:20 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.176])
        by smtp.gmail.com with ESMTPSA id w18sm5582324qkw.130.2020.03.20.18.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 18:33:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DFC88C3145; Fri, 20 Mar 2020 22:33:17 -0300 (-03)
Date:   Fri, 20 Mar 2020 22:33:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200321013317.GF3756@localhost.localdomain>
References: <20200320110959.2114-1-hqjagain@gmail.com>
 <20200320185204.GB3828@localhost.localdomain>
 <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
 <20200321010246.GC3828@localhost.localdomain>
 <CAJRQjofnZ5Oz-0PNMY6ojddg3MZc4v5UC5AJwi2CxLByDGaZhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRQjofnZ5Oz-0PNMY6ojddg3MZc4v5UC5AJwi2CxLByDGaZhQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 09:23:54AM +0800, Qiujun Huang wrote:
> On Sat, Mar 21, 2020 at 9:02 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Sat, Mar 21, 2020 at 07:53:29AM +0800, Qiujun Huang wrote:
> > ...
> > > > > So, sctp_wfree was not called to destroy SKB)
> > > > >
> > > > > then migrate happened
> > > > >
> > > > >       sctp_for_each_tx_datachunk(
> > > > >       sctp_clear_owner_w);
> > > > >       sctp_assoc_migrate();
> > > > >       sctp_for_each_tx_datachunk(
> > > > >       sctp_set_owner_w);
> > > > > SKB was not in the outq, and was not changed to newsk
> > > >
> > > > The real fix is to fix the migration to the new socket, though the
> > > > situation on which it is happening is still not clear.
> > > >
> > > > The 2nd sendto() call on the reproducer is sending 212992 bytes on a
> > > > single call. That's usually the whole sndbuf size, and will cause
> > > > fragmentation to happen. That means the datamsg will contain several
> > > > skbs. But still, the sacked chunks should be freed if needed while the
> > > > remaining ones will be left on the queues that they are.
> > >
> > > in sctp_sendmsg_to_asoc
> > > datamsg holds his chunk result in that the sacked chunks can't be freed
> >
> > Right! Now I see it, thanks.
> > In the end, it's not a locking race condition. It's just not iterating
> > on the lists properly.
> >
> > >
> > > list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
> > > sctp_chunk_hold(chunk);
> > > sctp_set_owner_w(chunk);
> > > chunk->transport = transport;
> > > }
> > >
> > > any ideas to handle it?
> >
> > sctp_for_each_tx_datachunk() needs to be aware of this situation.
> > Instead of iterating directly/only over the chunk list, it should
> > iterate over the datamsgs instead. Something like the below (just
> > compile tested).
> >
> > Then, the old socket will be free to die regardless of the new one.
> > Otherwise, if this association gets stuck on retransmissions or so,
> > the old socket would not be freed till then.
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index fed26a1e9518..85c742310d26 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -151,9 +151,10 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> >                                        void (*cb)(struct sctp_chunk *))
> >
> >  {
> > +       struct sctp_datamsg *msg, *prev_msg = NULL;
> >         struct sctp_outq *q = &asoc->outqueue;
> >         struct sctp_transport *t;
> > -       struct sctp_chunk *chunk;
> > +       struct sctp_chunk *chunk, *c;

I missed to swap some lines here, for reverse christmass-tree style,
btw.

> >
> >         list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
> >                 list_for_each_entry(chunk, &t->transmitted, transmitted_list)
> > @@ -162,8 +163,14 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> >         list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> >                 cb(chunk);
> >
> > -       list_for_each_entry(chunk, &q->sacked, transmitted_list)
> > -               cb(chunk);
> > +       list_for_each_entry(chunk, &q->sacked, transmitted_list) {
> > +               msg = chunk->msg;
> > +               if (msg == prev_msg)
> > +                       continue;
> > +               list_for_each_entry(c, &msg->chunks, frag_list)
> > +                       cb(c);
> > +               prev_msg = msg;
> > +       }
> 
> great. I'll trigger a syzbot test. Thanks.

Mind that it may need to handled on the other lists as well. I didn't
check them :]

> 
> >
> >         list_for_each_entry(chunk, &q->abandoned, transmitted_list)
> >                 cb(chunk);
