Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA06C8855
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfJBMY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:24:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50300 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBMY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 08:24:58 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iFdgU-00087H-6w; Wed, 02 Oct 2019 08:24:53 -0400
Date:   Wed, 2 Oct 2019 08:24:40 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
Message-ID: <20191002122440.GA24970@hmswarspite.think-freely.org>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain>
 <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 04:23:52PM +0800, Xin Long wrote:
> On Wed, Oct 2, 2019 at 9:04 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> > > This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> > >
> > >   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
> > >   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
> > >   [...] Call Trace:
> > >   [...]  security_sctp_bind_connect+0x58/0x90
> > >   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
> > >   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
> > >   [...]  sctp_do_sm+0x139/0x520 [sctp]
> > >   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
> > >   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
> > >   [...]  __release_sock+0x120/0x370
> > >   [...]  release_sock+0x4f/0x180
> > >   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
> > >   [...]  inet_accept+0xe7/0x6f0
> > >
> > > It was caused by that the 'newsk' sk_socket was not set before going to
> > > security sctp hook when doing accept() on a tcp-type socket:
> > >
> > >   inet_accept()->
> > >     sctp_accept():
> > >       lock_sock():
> > >           lock listening 'sk'
> > >                                           do_softirq():
> > >                                             sctp_rcv():  <-- [1]
> > >                                                 asconf chunk arrived and
> > >                                                 enqueued in 'sk' backlog
> > >       sctp_sock_migrate():
> > >           set asoc's sk to 'newsk'
> > >       release_sock():
> > >           sctp_backlog_rcv():
> > >             lock 'newsk'
> > >             sctp_process_asconf()  <-- [2]
> > >             unlock 'newsk'
> > >     sock_graft():
> > >         set sk_socket  <-- [3]
> > >
> > > As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> > > backlog, as accept() was holding its sock lock. Then at [2] asconf would
> > > get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> > > 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> > > would deref it, then kernel crashed.
> >
> > Note that sctp will migrate such incoming chunks from sk to newsk in
> > sctp_rcv() if they arrived after the mass-migration performed at
> > sctp_sock_migrate().
> >
> > That said, did you explore changing inet_accept() so that
> > sk1->sk_prot->accept() would return sk2 still/already locked?
> > That would be enough to block [2] from happening as then it would be
> > queued on newsk backlog this time and avoid nearly duplicating
> > inet_accept(). (too bad for this chunk, hit 2 backlogs..)
> We don't have to bother inet_accept() for it. I had this one below,
> and I was just thinking the locks order doesn't look nice. Do you
> think this is more acceptable?
> 
> @@ -4963,15 +4963,19 @@ static struct sock *sctp_accept(struct sock
> *sk, int flags, int *err, bool kern)
>          * asoc to the newsk.
>          */
>         error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> -       if (error) {
> -               sk_common_release(newsk);
> -               newsk = NULL;
> +       if (!error) {
> +               lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> +               release_sock(sk);
> +               release_sock(newsk);
> +               *err = error;
> +
> +               return newsk;
>         }
> 
>  out:
>         release_sock(sk);
>         *err = error;
> -       return newsk;
> +       return NULL;
>  }
> 
I think this is far more concise, and I don't see a particular issue
with the locking order (though I think you could reverse the order there
if you needed to.  In fact if you did that, you could change the if
(!error) to an if/else statement where the if set newsk = NULL, and the
else clause just released newsk and set err *, then you would be able to
maintain a common return point.

Neil

> >
> > AFAICT TCP code would be fine with such change. Didn't check other
> > protocols.
> >
> 
