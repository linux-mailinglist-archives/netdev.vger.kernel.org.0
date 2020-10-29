Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847FC29ED8A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgJ2NtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:49:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgJ2NtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603979359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GcmbRtYHMP/eeraxgBzWPfDsW1vsIQFNjlTuoH0NWcg=;
        b=ATHcVZ9xOvQr8qDZyAhPLjlTuSsTKA2RdWm5WBQ7S9rCVEu+yn5aaClmgBHzvZZxi6CigX
        cDVfLK2U01Qmia9SR6/M8sjcrNaWUQJ9HDOyMGqvlawnR3u/4qSL6DrkyfVjeN7TQYHxKj
        09hfkO0MvuHrCMu/RbRMEmebwePjQl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-g80r2fgZNtOrBZDqlPZibQ-1; Thu, 29 Oct 2020 09:49:15 -0400
X-MC-Unique: g80r2fgZNtOrBZDqlPZibQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 830E110E218F;
        Thu, 29 Oct 2020 13:49:13 +0000 (UTC)
Received: from [10.36.113.59] (ovpn-113-59.ams2.redhat.com [10.36.113.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0DB460C17;
        Thu, 29 Oct 2020 13:49:11 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     syzbot <syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: suspicious RCU usage in ovs_flow_tbl_masks_cache_resize
Date:   Thu, 29 Oct 2020 14:49:10 +0100
Message-ID: <1E724C9E-B6E4-4DC1-8A0F-4DD56A55D89C@redhat.com>
In-Reply-To: <000000000000f07eb205b2bce11b@google.com>
References: <000000000000f07eb205b2bce11b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI, I have a patch queued up for testing

//Eelco

On 28 Oct 2020, at 16:33, syzbot wrote:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    6daa1da4 chelsio/chtls: fix memory leaks in CPL 
> handlers
> git tree:       net
> console output: 
> https://syzkaller.appspot.com/x/log.txt?x=10defae4500000
> kernel config:  
> https://syzkaller.appspot.com/x/.config?x=46c6fea3eb827ae1
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=9a8f8bfcc56e8578016c
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      
> https://syzkaller.appspot.com/x/repro.syz?x=15fed5bc500000
> C reproducer:   
> https://syzkaller.appspot.com/x/repro.c?x=12afff40500000
>
> IMPORTANT: if you fix the issue, please add the following tag to the 
> commit:
> Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
>
> netlink: 44 bytes leftover after parsing attributes in process 
> `syz-executor522'.
> =============================
> WARNING: suspicious RCU usage
> 5.9.0-syzkaller #0 Not tainted
> -----------------------------
> net/openvswitch/flow_table.c:393 suspicious rcu_dereference_check() 
> usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syz-executor522/8493:
>  #0: ffffffff8c9af210 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 
> net/netlink/genetlink.c:810
>
> stack backtrace:
> CPU: 1 PID: 8493 Comm: syz-executor522 Not tainted 5.9.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, 
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  ovs_flow_tbl_masks_cache_resize+0x1bf/0x200 
> net/openvswitch/flow_table.c:393
>  ovs_dp_change+0x231/0x2b0 net/openvswitch/datapath.c:1616
>  ovs_dp_cmd_new+0x4c1/0xec0 net/openvswitch/datapath.c:1706
>  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440ad9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 
> 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffff6e416d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440ad9
> RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000003
> RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004022e0
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

