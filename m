Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD3A1E0C9C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 13:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390063AbgEYLOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 07:14:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389897AbgEYLOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 07:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590405261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DIBFUKTnV/sNAw24yAunbzsBW3j3CpAWlHvSRmXTYM=;
        b=AFW0bp3EVUo+TLeFDKQqXT/PvRVl7Zv7WAgxayqu6wld31WSyG8I4W+GZxIBsfj7ZE84o6
        ffihrMPcC5pJpsZXhaLGjB3jpgVp4wwIav/DbrWsx2VNQAUe3Ha5iMIyLaPSwMVthNE5FM
        DBxAjR9fsXpW8RaUpS1DhbaMBfG7vF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-XJsd2jnlPH-LDz5-rTlsVg-1; Mon, 25 May 2020 07:14:16 -0400
X-MC-Unique: XJsd2jnlPH-LDz5-rTlsVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 808CD835B44;
        Mon, 25 May 2020 11:14:14 +0000 (UTC)
Received: from ovpn-114-122.ams2.redhat.com (ovpn-114-122.ams2.redhat.com [10.36.114.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4009860F8A;
        Mon, 25 May 2020 11:14:10 +0000 (UTC)
Message-ID: <ec916f7b351589c9d86cbfff25ba86d748912d19.camel@redhat.com>
Subject: Re: general protection fault in sock_recvmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     syzbot <syzbot+d7cface3f90b13edf5b0@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Date:   Mon, 25 May 2020 13:14:09 +0200
In-Reply-To: <000000000000b5f39305a6705fd3@google.com>
References: <000000000000b5f39305a6705fd3@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-05-24 at 20:14 -0700, syzbot wrote:
> syzbot found the following crash on:
> 
> HEAD commit:    caffb99b Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a74441100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c33c7f7c5471fd39
> dashboard link: https://syzkaller.appspot.com/bug?extid=d7cface3f90b13edf5b0
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141034ba100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119cd016100000
> 
> The bug was bisected to:
> 
> commit 263e1201a2c324b60b15ecda5de9ebf1e7293e31
> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Thu Apr 30 13:01:51 2020 +0000
> 
>     mptcp: consolidate synack processing.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119d8626100000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=139d8626100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=159d8626100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d7cface3f90b13edf5b0@syzkaller.appspotmail.com
> Fixes: 263e1201a2c3 ("mptcp: consolidate synack processing.")
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 1 PID: 7226 Comm: syz-executor523 Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:sock_recvmsg_nosec net/socket.c:886 [inline]
> RIP: 0010:sock_recvmsg+0x92/0x110 net/socket.c:904
> Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 6c 24 04 e8 53 18 1d fb 4d 8d 6f 20 4c 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ef e8 20 12 5b fb bd a0 00 00 00 49 03 6d
> RSP: 0018:ffffc90001077b98 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: ffffc90001077dc0 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff86565e59 R09: ffffed10115afeaa
> R10: ffffed10115afeaa R11: 0000000000000000 R12: 1ffff9200020efbc
> R13: 0000000000000020 R14: ffffc90001077de0 R15: 0000000000000000
> FS:  00007fc6a3abe700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004d0050 CR3: 00000000969f0000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  mptcp_recvmsg+0x18d5/0x19b0 net/mptcp/protocol.c:891
>  inet_recvmsg+0xf6/0x1d0 net/ipv4/af_inet.c:838
>  sock_recvmsg_nosec net/socket.c:886 [inline]
>  sock_recvmsg net/socket.c:904 [inline]
>  __sys_recvfrom+0x2f3/0x470 net/socket.c:2057
>  __do_sys_recvfrom net/socket.c:2075 [inline]
>  __se_sys_recvfrom net/socket.c:2071 [inline]
>  __x64_sys_recvfrom+0xda/0xf0 net/socket.c:2071
>  do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x448ef9
> Code: e8 cc 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fc6a3abdda8 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
> RAX: ffffffffffffffda RBX: 00000000006dec28 RCX: 0000000000448ef9
> RDX: 0000000000001000 RSI: 00000000200004c0 RDI: 0000000000000003
> RBP: 00000000006dec20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000040000000 R11: 0000000000000246 R12: 00000000006dec2c
> R13: 00007ffe4730174f R14: 00007fc6a3abe9c0 R15: 00000000006dec2c
> Modules linked in:
> ---[ end trace 097bdf143c3a60db ]---
> RIP: 0010:sock_recvmsg_nosec net/socket.c:886 [inline]
> RIP: 0010:sock_recvmsg+0x92/0x110 net/socket.c:904
> Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 6c 24 04 e8 53 18 1d fb 4d 8d 6f 20 4c 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ef e8 20 12 5b fb bd a0 00 00 00 49 03 6d
> RSP: 0018:ffffc90001077b98 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: ffffc90001077dc0 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff86565e59 R09: ffffed10115afeaa
> R10: ffffed10115afeaa R11: 0000000000000000 R12: 1ffff9200020efbc
> R13: 0000000000000020 R14: ffffc90001077de0 R15: 0000000000000000
> FS:  00007fc6a3abe700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004d0050 CR3: 00000000969f0000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

#syz dup: general protection fault in selinux_socket_recvmsg



