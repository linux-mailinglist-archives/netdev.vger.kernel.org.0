Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC83D680D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfJNRMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:12:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53273 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbfJNRMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:12:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so18059206wmd.3;
        Mon, 14 Oct 2019 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjPpfe0lrndXWhOCFmYf2W6HrSQtzboPEPFW1b5LREg=;
        b=itzJC3de2En2EeFufvj1TyZAJ8eyvesQUNiibWxyqksGkDYnHFj//i/YwNblwNwAJ6
         y/h3t2nBbPAUgdVHAj+hK3uCzfOD3Vfk88xdXJZ/+Qedzyvg6lF9etmocR8W142Jpyu6
         dvmVouc9v2RnQH+pJm0pTbk9CBOAlbtUf6jKLqHsTRQowFAqQiUUCOM0qA8mRq5pjajs
         PGOfDl0RQPI2C4cMOenaNOaQ7GoNKzYdlpAXm53ayu9CAdvtS5pGQd/KtbYxi3m32LbC
         2aGP/BzUjquBeLDL6a2TLEuqN7trsl162O6svYdbXrOXiGvrz4ztpHEiEN8gortGUVr1
         7H2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjPpfe0lrndXWhOCFmYf2W6HrSQtzboPEPFW1b5LREg=;
        b=JI4P7I1ioPQA8Pi9a7pOKwM7khR2PYv5WFFtKwIYlddYSpIl/x/ZjDng4cNReupak3
         eZVW9L3jKbr4tb0FvTeV67igZmRXKaxKwAX/Z000X9wAMjG+27EuSjWohbKP+ae4RdiQ
         XbupdGxestDGicnzdaZ1ATN2qs8VKI7QN8ITbvO91tNlDX1eXt/njM38tbHzBkijCJGY
         U9kFTc3Rtw5OdTNPA/ut9E0SAe4DTdBvUHqJT8G/Pl5iLTGXiaRp3IRIOYU2qGjqkA+k
         aRN9HLiiy8OxVcgmvRi+z1fNkukNwxTH7FXMaaq4OWGnPWslDJ8/Qy9znuAkOxqwOGmt
         Sm2g==
X-Gm-Message-State: APjAAAW92IOuzWifoD2VJj2mGdf/wvzNKVnRWZ79X/jNWFEYvg+c6O8z
        +WYR6oc417ZGmCPx6aBazBRD/BXtdFH8OHEc/3HOu4mu
X-Google-Smtp-Source: APXvYqyduxFHsTBernmb65Sr66YPGB4gh2Rp8a0B4JBEKA3l2KJIIAU8kUsWIW/+shuLsX4Pto7pYpGvwC0TfyQ0HT0=
X-Received: by 2002:a1c:8157:: with SMTP id c84mr15477556wmd.56.1571073131661;
 Mon, 14 Oct 2019 10:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007193390594d5e959@google.com>
In-Reply-To: <0000000000007193390594d5e959@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 15 Oct 2019 01:12:19 +0800
Message-ID: <CADvbK_e5yjk3LBGUdYw9L-5zOibDZJtHJKOSkw8ConqZGgv6CQ@mail.gmail.com>
Subject: Re: memory leak in sctp_get_port_local (3)
To:     syzbot <syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:50 AM syzbot
<syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    da940012 Merge tag 'char-misc-5.4-rc3' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c87fc7600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e76c708f07645488
> dashboard link: https://syzkaller.appspot.com/bug?extid=d44f7bbebdea49dbc84a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128d3f8b600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ead04b600000
We probably need to add ".no_autobind = true" in sctp_prot to prevent
sendmsg() from going the path: inet_sendmsg()->inet_send_prepare()->
inet_autobind(), and leave sctp_sendmsg() to handle sctp_autobind().

will have a try tomorrow.

>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
>
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff888120b3d380 (size 64):
>    comm "syz-executor517", pid 6949, jiffies 4294941316 (age 13.400s)
>    hex dump (first 32 bytes):
>      23 4e 00 00 00 00 00 00 00 00 00 00 00 00 00 00  #N..............
>      88 16 ef 24 81 88 ff ff 00 00 00 00 00 00 00 00  ...$............
>    backtrace:
>      [<000000006e6207b2>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<000000006e6207b2>] slab_post_alloc_hook mm/slab.h:586 [inline]
>      [<000000006e6207b2>] slab_alloc mm/slab.c:3319 [inline]
>      [<000000006e6207b2>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>      [<00000000d0d058e2>] sctp_bucket_create net/sctp/socket.c:8523 [inline]
>      [<00000000d0d058e2>] sctp_get_port_local+0x189/0x5a0
> net/sctp/socket.c:8270
>      [<0000000082735c7f>] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
>      [<0000000080c8d55e>] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
>      [<00000000eb10f474>] sctp_setsockopt_bindx+0x156/0x1b0
> net/sctp/socket.c:1022
>      [<000000004e959dd5>] sctp_setsockopt net/sctp/socket.c:4641 [inline]
>      [<000000004e959dd5>] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
>      [<000000000e9e767a>] sock_common_setsockopt+0x38/0x50
> net/core/sock.c:3147
>      [<00000000a549638a>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
>      [<000000003c15b96c>] __do_sys_setsockopt net/socket.c:2100 [inline]
>      [<000000003c15b96c>] __se_sys_setsockopt net/socket.c:2097 [inline]
>      [<000000003c15b96c>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
>      [<00000000ee3ea8a3>] do_syscall_64+0x73/0x1f0
> arch/x86/entry/common.c:290
>      [<000000006bf005e9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
