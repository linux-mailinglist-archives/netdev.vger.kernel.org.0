Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7222C53D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfE1LQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:16:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36292 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfE1LQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:16:33 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hVa5a-0003j5-P3; Tue, 28 May 2019 07:16:26 -0400
Date:   Tue, 28 May 2019 07:15:50 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190528111550.GA4658@hmswarspite.think-freely.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528013600.GM5506@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 10:36:00PM -0300, Marcelo Ricardo Leitner wrote:
> On Mon, May 27, 2019 at 05:48:06PM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    9c7db500 Merge tag 'selinux-pr-20190521' of git://git.kern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10388530a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f7e9153b037eac9b1df8
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e32f8ca00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177fa530a00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> > 
> >  0 to HW filter on device batadv0
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff88810ef68400 (size 1024):
> >   comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
> >   hex dump (first 32 bytes):
> >     1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000a02cebbd>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >     [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >     [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
> >     [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
> >     [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
> >     [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
> >     [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
> >     [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
> > net/sctp/sm_make_chunk.c:2437
> >     [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect.c:682
> > [inline]
> >     [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1384
> > [inline]
> >     [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1194
> > [inline]
> >     [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60
> > net/sctp/sm_sideeffect.c:1165
> 
> Note that this is on the client side. It was handling the INIT_ACK
> chunk, from sctp_sf_do_5_1C_ack().
> 
> I'm not seeing anything else other than sctp_association_free()
> releasing this memory. This means 2 things:
> - Every time the cookie is retransmitted, it leaks. As shown by the
>   repetitive leaks here.
> - The cookie remains allocated throughout the association, which is
>   also not good as that's a 1k that we could have released back to the
>   system right after the handshake.
> 
>   Marcelo
> 
If we have an INIT chunk bundled with a COOKIE_ECHO chunk in the same packet,
this might occur.  Processing for each chunk (via sctp_cmd_process_init and
sctp_sf_do_5_1D_ce both call sctp_process_init, which would cause a second write
to asoc->peer.cookie, leaving the first write (set via kmemdup), to be orphaned
and leak.  Seems like we should set a flag to determine if we've already cloned
the cookie, and free the old one if its set.  If we wanted to do that on the
cheap, we might be able to get away with checking asoc->stream->[in|out]cnt for
being non-zero as an indicator if we've already cloned the cookie

Neil

