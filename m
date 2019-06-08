Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51C239B78
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfFHHGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 03:06:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34445 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbfFHHGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 03:06:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so4218974wrn.1;
        Sat, 08 Jun 2019 00:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l71valUy73yS7d9m1Jw+T9vHYZRj8p2Ia1yYGkuIspg=;
        b=JOrrAOdbOMUSTeyZEohyio/Q/YFncs4bnQoWyCwwmlVbpvq8PaFODnHJ1FS5F+DjmA
         KGsMhbJBLAojIC17ysHF8+C6P6e01OCSUhBhxYW5HqKHhzxUday9RwS6s6NWY2Qx5brQ
         ecsmuTjg3ChLKCL4z4gvi+cbM75G0Ez7DWz0OFD8/5oaeDGMpfDdp0vmt+c4fGL7MsW6
         WZ+UAncQ1e9vy3Y9N2/o0ghQ3zK99EvELDegQoaytItEjymrG6yuKQ+AZLItCzVZXS94
         cgy4hCU4b9NUeJUYawQzM39j03Fx1AwEkuRfQISZV5c3GswHntWopd2suHl3PBEr9b/A
         SeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l71valUy73yS7d9m1Jw+T9vHYZRj8p2Ia1yYGkuIspg=;
        b=ItciFd+xuLZG+kcN3O/PfzTqCk6/ZH+8eGrFi1P/PetqAF7gTVbqV1ZNNptr5202Yu
         MzOq2B+n3nigkkTWCFDO7z7s7vHMddvkr0McD8cSoCUvd0QjL0eFs4/P+PVyOT34olZB
         /yKbNG1F39zUuYApXroxDbBREDUjxlk7tLdSZtnB1pDZaik2cllIH4Op7T61N8yXR+yV
         SrVuGXxO/nkqGyVynq6MmSnrBFlaeRpKPJAfw5WlOpuzoBijVMoEqMtEUNC0/wt9BFMz
         fbIoCgt3rl2s3KukdbNknJoYU+L1Q1u0dzQ8K1OchAcuwTE0uWw6x4RSN2rpc2RJYo/1
         IxYw==
X-Gm-Message-State: APjAAAUVuKqLgzWeLBRB3ICVLacdCG5T+1N5FcXboj6E90o87X22gbBL
        OCcKm29MVMlTd4XnWzvquMiQkHUZcI5sTCGcvDGBHw==
X-Google-Smtp-Source: APXvYqwEKapufhdQwrFVeANNHmzrb2fls8YW1EREMLTNMMS/lf/2EKjGZmPMDCarQdZZ5alvqWfan66l6tZ/v0macPM=
X-Received: by 2002:a5d:5189:: with SMTP id k9mr2353155wrv.329.1559977580122;
 Sat, 08 Jun 2019 00:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000097abb90589e804fd@google.com> <20190603203259.21508-1-nhorman@tuxdriver.com>
 <CADvbK_c6Ym2pbKqGQD8WUmUPX_PtAa6RGde7AQwhRZzUr_emiw@mail.gmail.com>
 <20190605112010.GA554@hmswarspite.think-freely.org> <20190606154754.GA3500@localhost.localdomain>
 <20190607105639.GB26017@hmswarspite.think-freely.org> <20190607124813.GA3436@localhost.localdomain>
In-Reply-To: <20190607124813.GA3436@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 8 Jun 2019 15:06:08 +0800
Message-ID: <CADvbK_eTqSJ27=0=yf7MXtKW796gvaByBMQ-2AKWr9BEoX_r+g@mail.gmail.com>
Subject: Re: [PATCH V2] Fix memory leak in sctp_process_init
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 8:48 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Jun 07, 2019 at 06:56:39AM -0400, Neil Horman wrote:
> > On Thu, Jun 06, 2019 at 12:47:55PM -0300, Marcelo Ricardo Leitner wrote:
> > > On Wed, Jun 05, 2019 at 07:20:10AM -0400, Neil Horman wrote:
> > > > On Wed, Jun 05, 2019 at 04:16:24AM +0800, Xin Long wrote:
> > > > > On Tue, Jun 4, 2019 at 4:34 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > >
> > > > > > syzbot found the following leak in sctp_process_init
> > > > > > BUG: memory leak
> > > > > > unreferenced object 0xffff88810ef68400 (size 1024):
> > > > > >   comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
> > > > > >   hex dump (first 32 bytes):
> > > > > >     1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
> > > > > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > > >   backtrace:
> > > > > >     [<00000000a02cebbd>] kmemleak_alloc_recursive include/linux/kmemleak.h:55
> > > > > > [inline]
> > > > > >     [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
> > > > > >     [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
> > > > > >     [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
> > > > > >     [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
> > > > > >     [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
> > > > > >     [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
> > > > > >     [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
> > > > > > net/sctp/sm_make_chunk.c:2437
> > > > > >     [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect.c:682
> > > > > > [inline]
> > > > > >     [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1384
> > > > > > [inline]
> > > > > >     [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1194
> > > > > > [inline]
> > > > > >     [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60 net/sctp/sm_sideeffect.c:1165
> > > > > >     [<0000000044e11f96>] sctp_assoc_bh_rcv+0x13c/0x200
> > > > > > net/sctp/associola.c:1074
> > > > > >     [<00000000ec43804d>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:95
> > > > > >     [<00000000726aa954>] sctp_backlog_rcv+0x5e/0x2a0 net/sctp/input.c:354
> > > > > >     [<00000000d9e249a8>] sk_backlog_rcv include/net/sock.h:950 [inline]
> > > > > >     [<00000000d9e249a8>] __release_sock+0xab/0x110 net/core/sock.c:2418
> > > > > >     [<00000000acae44fa>] release_sock+0x37/0xd0 net/core/sock.c:2934
> > > > > >     [<00000000963cc9ae>] sctp_sendmsg+0x2c0/0x990 net/sctp/socket.c:2122
> > > > > >     [<00000000a7fc7565>] inet_sendmsg+0x64/0x120 net/ipv4/af_inet.c:802
> > > > > >     [<00000000b732cbd3>] sock_sendmsg_nosec net/socket.c:652 [inline]
> > > > > >     [<00000000b732cbd3>] sock_sendmsg+0x54/0x70 net/socket.c:671
> > > > > >     [<00000000274c57ab>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2292
> > > > > >     [<000000008252aedb>] __sys_sendmsg+0x80/0xf0 net/socket.c:2330
> > > > > >     [<00000000f7bf23d1>] __do_sys_sendmsg net/socket.c:2339 [inline]
> > > > > >     [<00000000f7bf23d1>] __se_sys_sendmsg net/socket.c:2337 [inline]
> > > > > >     [<00000000f7bf23d1>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2337
> > > > > >     [<00000000a8b4131f>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:3
> > > > > >
> > > > > > The problem was that the peer.cookie value points to an skb allocated
> > > > > > area on the first pass through this function, at which point it is
> > > > > > overwritten with a heap allocated value, but in certain cases, where a
> > > > > > COOKIE_ECHO chunk is included in the packet, a second pass through
> > > > > > sctp_process_init is made, where the cookie value is re-allocated,
> > > > > > leaking the first allocation.
> > > > > This's not gonna happen, as after processing INIT, the temp asoc will be
> > > > > deleted on the server side. Besides, from the reproducer:
> > > > >
> > > > >   https://syzkaller.appspot.com/x/repro.syz?x=10e32f8ca00000
> > > > >
> > > > > Packet(INIT|COOKIE_ECHO) can't be made in here.
> > > > >
> > > > > The call trace says the leak happened when processing INIT_ACK on the
> > > > > client side, as Marcelo noticed.  Then it can be triggered by:
> > > > >
> > > > > 1. sctp_sf_do_5_1C_ack() -> SCTP_CMD_PEER_INIT -> sctp_process_init():
> > > > >    where it "goto clean_up" after sctp_process_param(), but in 'cleanup'
> > > > >    path, it doesn't do any freeup for the memdups of sctp_process_param().
> > > > >    then the client T1 retrans INIT, and later get INIT_ACK again from the
> > > > >    peer, and go to sctp_process_init() to memdup().
> > > > >
> > > > > 2. sctp_sf_cookie_echoed_err() -> sctp_sf_do_5_2_6_stale():
> > > > >    where the asoc state will go from COOKIE_ECHOED back to COOKIE_WAIT,
> > > > >    and T1 starts to retrans INIT, and later it will get INIT_ACK again
> > > > >    to sctp_process_init() and memdup().
> > > > >
> > > > ok, you may well be right as to the path that we take to get here, but the root
> > > > cause is the same, multiple passes through sctp_process_init without freeing the
> > > > previously memduped memory.  Thats why I would think my patch is fixing the
> > > > issue, because now we're always duping the cookie memory and always freeing it
> > > > when we transition to the ESTABLISHED state.
> > > >
> > > > As for the other variables (peer_[random|chunks|hmacs]), I'm not sure why we're
> > > > not seeing leak reports of those variables.
> > >
> > > This actually also works for peer.cookie as well, as now they are
> > > allocated and freed in the same places.
> > >
> > > I talked with Xin and I agree that this patch didn't really fix the
> > > leak. It moved the allocation from sctp_process_init() to
> > > sctp_process_param() which is called by sctp_process_init and there is
> > > nothing avoiding multiple allocations on these vars once INIT_ACK is
> > > retransmited.
> > >
> > > The reproducer works by having the client to re-request cookies by
> > > setting a short lifetime. So
> > > Client sends INIT
> > >                        Server replies INIT_ACK with cookie
> > > Client echoes the cookie
> > >                        Server rejects because the cookie expired
> > > Client sends INIT again, to ask for another cookie
> > >   (sctp_sf_do_5_2_6_stale)
> > >                        Server sends INIT_ACK again with a new cookie
> > > Client calls sctp_process_init again, from
> > >   -> sctp_sf_do_5_1C_ack()
> > >    -> sctp_cmd_process_init()
> > >     -> sctp_process_init()
> > >      -> sctp_process_param()
> > >         ^-- leak happens
> > >                    Server may or may not accept the new cookie,
> > >                    leading to further leaks if not
> > If this is the case, it seems like the most reasonable fix then is to just
> > check to see if peer.cookie is non-null prior to calling kmemdup, and freeing
> > the old cookie first, no?
>
> That probably would be clearer and easier to maintain later, yes.
> Xin?
Sure, looks good to me. :)

>
>   Marcelo
>
> >
> > Neil
> >
> > > (this is his 2nd case above)
> > >
> > > Yet somehow the patch changed the dynamics and made the test pass (4x
> > > 10mins each run) here. Uff.
> > >
> > >   Marcelo
> > >
> > > >
> > > > Neil
> > > >
> > > > > As on either above, asoc's never been to ESTABLISHED state,
> > > > > asoc->peer.cookie can be not freed, and this patch won't work.
> > > > > But yes, it's nice to have this patch, just not to fix this memleak.
> > >
> > > +1 (read: won't hurt -stable and no need to revert)
> > >
> > > > >
> > > > > I tracked the code, this memleak was triggered by case 2, so I think
> > > > > you also need to add something like:
> > > > >
> > > > > @@ -881,6 +893,18 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> > > > >                                                 asoc->rto_initial;
> > > > >                 asoc->timeouts[SCTP_EVENT_TIMEOUT_T1_COOKIE] =
> > > > >                                                 asoc->rto_initial;
> > > > > +
> > > > > +               if (asoc->peer.cookie) {
> > > > > +                       kfree(asoc->peer.cookie);
> > > > > +                       kfree(asoc->peer.peer_random);
> > > > > +                       kfree(asoc->peer.peer_chunks);
> > > > > +                       kfree(asoc->peer.peer_hmacs);
> > > > > +
> > > > > +                       asoc->peer.cookie = NULL;
> > > > > +                       asoc->peer.peer_random = NULL;
> > > > > +                       asoc->peer.peer_random = NULL;
> > > > > +                       asoc->peer.peer_hmacs = NULL;
> > > > > +               }
> > > > >         }
> > > > >
> > > > > and the same thing may also be needed in sctp_cmd_process_init() on the
> > > > > err path for case 1.
> > > > >
> > > > > >
> > > > > > Fix is to always allocate the cookie value, and free it when we are done
> > > > > > using it.
> > > > > >
> > > > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > > Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> > > > > > CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > > > > CC: "David S. Miller" <davem@davemloft.net>
> > > > > > CC: netdev@vger.kernel.org
> > > > > >
> > > > > > ---
> > > > > > Change notes
> > > > > >
> > > > > > V1->V2:
> > > > > >   * Removed an accidental double free I let slip in in
> > > > > > sctp_association_free
> > > > > >   * Removed now unused cookie variable
> > > > > > ---
> > > > > >  net/sctp/sm_make_chunk.c | 13 +++----------
> > > > > >  net/sctp/sm_sideeffect.c |  5 +++++
> > > > > >  2 files changed, 8 insertions(+), 10 deletions(-)
> > > > > >
> > > > > > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > > > > > index 72e74503f9fc..8e12e19fe42d 100644
> > > > > > --- a/net/sctp/sm_make_chunk.c
> > > > > > +++ b/net/sctp/sm_make_chunk.c
> > > > > > @@ -2327,7 +2327,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> > > > > >         union sctp_addr addr;
> > > > > >         struct sctp_af *af;
> > > > > >         int src_match = 0;
> > > > > > -       char *cookie;
> > > > > >
> > > > > >         /* We must include the address that the INIT packet came from.
> > > > > >          * This is the only address that matters for an INIT packet.
> > > > > > @@ -2431,14 +2430,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> > > > > >         /* Peer Rwnd   : Current calculated value of the peer's rwnd.  */
> > > > > >         asoc->peer.rwnd = asoc->peer.i.a_rwnd;
> > > > > >
> > > > > > -       /* Copy cookie in case we need to resend COOKIE-ECHO. */
> > > > > > -       cookie = asoc->peer.cookie;
> > > > > > -       if (cookie) {
> > > > > > -               asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
> > > > > > -               if (!asoc->peer.cookie)
> > > > > > -                       goto clean_up;
> > > > > > -       }
> > > > > > -
> > > > > >         /* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
> > > > > >          * high (for example, implementations MAY use the size of the receiver
> > > > > >          * advertised window).
> > > > > > @@ -2607,7 +2598,9 @@ static int sctp_process_param(struct sctp_association *asoc,
> > > > > >         case SCTP_PARAM_STATE_COOKIE:
> > > > > >                 asoc->peer.cookie_len =
> > > > > >                         ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> > > > > > -               asoc->peer.cookie = param.cookie->body;
> > > > > > +               asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
> > > > > > +               if (!asoc->peer.cookie)
> > > > > > +                       retval = 0;
> > > > > >                 break;
> > > > > >
> > > > > >         case SCTP_PARAM_HEARTBEAT_INFO:
> > > > > > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > > > > > index 4aa03588f87b..27ddf2d8f001 100644
> > > > > > --- a/net/sctp/sm_sideeffect.c
> > > > > > +++ b/net/sctp/sm_sideeffect.c
> > > > > > @@ -898,6 +898,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> > > > > >                                                 asoc->rto_initial;
> > > > > >         }
> > > > > >
> > > > > > +       if (sctp_state(asoc, ESTABLISHED)) {
> > > > > > +               kfree(asoc->peer.cookie);
> > > > > > +               asoc->peer.cookie = NULL;
> > > > > > +       }
> > > > > > +
> > > > > >         if (sctp_state(asoc, ESTABLISHED) ||
> > > > > >             sctp_state(asoc, CLOSED) ||
> > > > > >             sctp_state(asoc, SHUTDOWN_RECEIVED)) {
> > > > > > --
> > > > > > 2.20.1
> > > > > >
> > > > >
> > > >
> > >
