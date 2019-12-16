Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469A712045A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfLPLsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:48:41 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34048 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfLPLsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:48:40 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1igorW-0000nC-FD; Mon, 16 Dec 2019 06:48:33 -0500
Date:   Mon, 16 Dec 2019 06:48:28 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Subject: Re: memory leak in sctp_stream_init
Message-ID: <20191216114828.GA20281@hmswarspite.think-freely.org>
References: <000000000000f531080599c4073c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f531080599c4073c@google.com>
X-Spam-Score: -0.4 (/)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 12:35:09PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=126a177ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf3a35184a3ed64
> dashboard link: https://syzkaller.appspot.com/bug?extid=772d9e36c490b18d51d1
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15602ddee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12798251e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff8881080a3000 (size 4096):
>   comm "syz-executor474", pid 7155, jiffies 4294942658 (age 15.870s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000df094087>] genradix_alloc_node lib/generic-radix-tree.c:90
> [inline]
>     [<00000000df094087>] __genradix_ptr_alloc+0xf5/0x250
> lib/generic-radix-tree.c:122
>     [<0000000057cfa7bb>] __genradix_prealloc+0x46/0x70
> lib/generic-radix-tree.c:223
>     [<0000000029d02dac>] sctp_stream_alloc_out.part.0+0x57/0x80
> net/sctp/stream.c:86
>     [<00000000bb930a04>] sctp_stream_alloc_out net/sctp/stream.c:151
> [inline]
>     [<00000000bb930a04>] sctp_stream_init+0x129/0x180 net/sctp/stream.c:129
>     [<00000000ba13c246>] sctp_association_init net/sctp/associola.c:229
> [inline]
>     [<00000000ba13c246>] sctp_association_new+0x46e/0x700
> net/sctp/associola.c:295
>     [<000000008eb57b4d>] sctp_connect_new_asoc+0x90/0x220
> net/sctp/socket.c:1070
>     [<00000000ea24e048>] __sctp_connect+0x182/0x3b0 net/sctp/socket.c:1176
>     [<00000000aa2c530a>] __sctp_setsockopt_connectx+0xa9/0xf0
> net/sctp/socket.c:1322
>     [<0000000018934bfd>] sctp_getsockopt_connectx3 net/sctp/socket.c:1407
> [inline]
>     [<0000000018934bfd>] sctp_getsockopt net/sctp/socket.c:8079 [inline]
>     [<0000000018934bfd>] sctp_getsockopt+0x1394/0x32f6
> net/sctp/socket.c:8010
>     [<000000005fd7e3c8>] sock_common_getsockopt+0x38/0x50
> net/core/sock.c:3108
>     [<00000000333baf72>] __sys_getsockopt+0xa8/0x180 net/socket.c:2162
>     [<00000000de0f98e4>] __do_sys_getsockopt net/socket.c:2177 [inline]
>     [<00000000de0f98e4>] __se_sys_getsockopt net/socket.c:2174 [inline]
>     [<00000000de0f98e4>] __x64_sys_getsockopt+0x26/0x30 net/socket.c:2174
>     [<00000000cf1dfee9>] do_syscall_64+0x73/0x220
> arch/x86/entry/common.c:294
>     [<000000000f416860>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

Almost looks like we're processing a connectx socket option while the handling
of a cookie echo chunk is in flight through the state machine (i.e.
sctp_stream_update is getting called on the association while we're setting it
up in parallel), though I'm not sure how that can happen

Neil

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
> 
