Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B068C32367
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFBNg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 09:36:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53398 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 09:36:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so1084201wmb.3;
        Sun, 02 Jun 2019 06:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6M+Tu/nPOq4TtFuBA80HcvzEsuQO0Tl5aFrElztCMrw=;
        b=PQo7xN0Oukp50y+DAxPrKPXCoT6F1W8UzYOEiFP1sBWvUQ6Y+jUTMbuvPAH+hTlSkB
         b9ZYAOyMuX6NCS0/T4JOrBm02wFk1DLKhOLK54hZeKx/MjbgCNq8vpKyIPtvEUFngpze
         830IMpw4ki5wmz9v8MrdCFtqPT1Krkyxmef8AOXGf+gOC4lTCZAwiNeL9zcLeJ+mHFWx
         OT1q3bKy6/zfxQf0o+fhqUx3TY2BuNWD9lKk1HbvZgaapWOklMDVVOBkAMS4bdTpAZK1
         Oi0ZGkbUdk9e/6Iifv4o1rxVZ4yonc+LSoqKxqLCmaB05x7IZ/iu4vuRfqyRqaFDOekP
         ZFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6M+Tu/nPOq4TtFuBA80HcvzEsuQO0Tl5aFrElztCMrw=;
        b=PDB6TNabyiStz+dcO1xvBJ4hD/F8wsi1owHF/O0gLwRRACxLRTNL4dqyfxfp+nNGYf
         RWh4K0/JPGiPkJLtiH5PSh3PFUlinLpa34rHb8REbucHkcueWAHl/4Jee4sweAH5N0Kr
         F1iMk2E+cgMqYc4AJUokd1ViS21NbiTU6+7a+pEy1N/y6Xmv5imwtz6oNxEil3SuCMT2
         IZn7kBBgTYrD4Fx5LPPw3jCDJWRohIcciO7T6UvlBsQrUmSEwr7E7UcgkXurU1Ly8Egj
         LbZoWAOuMDGErbpRUimQvNNz7Le66j1n3NzEfogmdQ3SZrkq7CoMMTM4S8zf+9nZ8FvR
         PFTw==
X-Gm-Message-State: APjAAAVqHKD68DwHuvdyoG+Eo7skJ4FuP2b2iL3fJLkd9Sykq7slDx5J
        PdBYDJfqgmaCfmsTWXVUv73sv5jXYGVPZYG15bQ=
X-Google-Smtp-Source: APXvYqzt1ZbLKW9U5eB8+6RqQSBFnR+6o+ysXXtrVS2I+UmBZtyKV36+w17n2wl/cp+R9xcpPt3dVvcyJao9ze8gphw=
X-Received: by 2002:a1c:eb16:: with SMTP id j22mr7203910wmh.56.1559482613930;
 Sun, 02 Jun 2019 06:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190602034429.6888-1-hdanton@sina.com> <20190602105133.GA16948@hmswarspite.think-freely.org>
In-Reply-To: <20190602105133.GA16948@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 2 Jun 2019 21:36:42 +0800
Message-ID: <CADvbK_dUDjK3UAF49uo+DZv+QiuEsaMmZeqDwBJ0suRwu4yXJw@mail.gmail.com>
Subject: Re: [PATCH] net: sctp: fix memory leak in sctp_send_reset_streams
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Hillf Danton <hdanton@sina.com>, linux-sctp@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 2, 2019 at 6:52 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Sun, Jun 02, 2019 at 11:44:29AM +0800, Hillf Danton wrote:
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    036e3431 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=153cff12a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8f0f63a62bb5b13c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6ad9c3bd0a218a2ab41d
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12561c86a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b76fd8a00000
> >
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff888123894820 (size 32):
> >   comm "syz-executor045", pid 7267, jiffies 4294943559 (age 13.660s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000c7e71c69>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >     [<00000000c7e71c69>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >     [<00000000c7e71c69>] slab_alloc mm/slab.c:3326 [inline]
> >     [<00000000c7e71c69>] __do_kmalloc mm/slab.c:3658 [inline]
> >     [<00000000c7e71c69>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
> >     [<000000003250ed8e>] kmalloc_array include/linux/slab.h:670 [inline]
> >     [<000000003250ed8e>] kcalloc include/linux/slab.h:681 [inline]
> >     [<000000003250ed8e>] sctp_send_reset_streams+0x1ab/0x5a0 net/sctp/stream.c:302
> >     [<00000000cd899c6e>] sctp_setsockopt_reset_streams net/sctp/socket.c:4314 [inline]
> >     [<00000000cd899c6e>] sctp_setsockopt net/sctp/socket.c:4765 [inline]
> >     [<00000000cd899c6e>] sctp_setsockopt+0xc23/0x2bf0 net/sctp/socket.c:4608
> >     [<00000000ff3a21a2>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
> >     [<000000009eb87ae7>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
> >     [<00000000e0ede6ca>] __do_sys_setsockopt net/socket.c:2089 [inline]
> >     [<00000000e0ede6ca>] __se_sys_setsockopt net/socket.c:2086 [inline]
> >     [<00000000e0ede6ca>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
> >     [<00000000c61155f5>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> >     [<00000000e540958c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> >
> > It was introduced in commit d570a59c5b5f ("sctp: only allow the out stream
> > reset when the stream outq is empty"), in orde to check stream outqs before
> > sending SCTP_STRRESET_IN_PROGRESS back to the peer of the stream. EAGAIN is
> > returned, however, without the nstr_list slab released, if any outq is found
> > to be non empty.
> >
> > Freeing the slab in question before bailing out fixes it.
> >
> > Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> > Reported-by: syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>
> > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Tested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Cc: Xin Long <lucien.xin@gmail.com>
> > Cc: Neil Horman <nhorman@tuxdriver.com>
> > Cc: Vlad Yasevich <vyasevich@gmail.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Hillf Danton <hdanton@sina.com>
> > ---
> > net/sctp/stream.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 93ed078..d3e2f03 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -310,6 +310,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
> >
> >       if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> >               retval = -EAGAIN;
> > +             kfree(nstr_list);
> >               goto out;
> >       }
> >
> > --
> >
> >
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
