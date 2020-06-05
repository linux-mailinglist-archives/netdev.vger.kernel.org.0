Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9171EF08B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgFEE0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFEE0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 00:26:51 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D92EC206E6;
        Fri,  5 Jun 2020 04:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591331210;
        bh=xGbrbzv9hPwjqcy73km558vyrkxcWK3YVwClCXHm1lU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNX5OC0vSSannJRbSrOwiKzyIcinK9DVwkj9LbOitwi8+1YxpLND7Kq1ij15Ar4n7
         FVQG/kiH40wGeS0jqnOfB1L/06Ugu3UtWfXus+yY5NuE11wFsmnWDMCzio1IjeI0LV
         8y4MmP/cfgU9GAGXPhTKmXEMjZHqyYJls4Texdys=
Date:   Thu, 4 Jun 2020 21:26:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     syzbot <syzbot+407fd358a932bbf639c6@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: general protection fault in kobject_get (2)
Message-ID: <20200605042648.GP2667@sol.localdomain>
References: <0000000000009a6d4305a60d2c6b@google.com>
 <20200520055641.GA2242221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520055641.GA2242221@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 07:56:41AM +0200, Greg KH wrote:
> On Tue, May 19, 2020 at 09:53:16PM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    d00f26b6 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1316343c100000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=26d0bd769afe1a2c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=407fd358a932bbf639c6
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+407fd358a932bbf639c6@syzkaller.appspotmail.com
> > 
> > general protection fault, probably for non-canonical address 0xdffffc0000000013: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
> > CPU: 1 PID: 16682 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:kobject_get+0x30/0x150 lib/kobject.c:640
> > Code: 53 e8 d4 7e c6 fd 4d 85 e4 0f 84 a2 00 00 00 e8 c6 7e c6 fd 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e7 00 00 00
> > RSP: 0018:ffffc9000772f240 EFLAGS: 00010203
> > RAX: dffffc0000000000 RBX: ffffffff85acfca0 RCX: ffffc9000fc67000
> > RDX: 0000000000000013 RSI: ffffffff83acadfa RDI: 000000000000009c
> > RBP: 0000000000000060 R08: ffff8880a8dfa4c0 R09: ffffed100a03f403
> > R10: ffff8880501fa017 R11: ffffed100a03f402 R12: 0000000000000060
> > R13: ffffc9000772f3c0 R14: ffff88805d1ec4e8 R15: ffff88805d1ec580
> > FS:  00007f1ebed26700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000004d88f0 CR3: 00000000a86c4000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  get_device+0x20/0x30 drivers/base/core.c:2620
> >  __ib_get_client_nl_info+0x1d4/0x2a0 drivers/infiniband/core/device.c:1863
> >  ib_get_client_nl_info+0x30/0x180 drivers/infiniband/core/device.c:1883
> >  nldev_get_chardev+0x52b/0xa40 drivers/infiniband/core/nldev.c:1625
> >  rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
> >  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
> >  rdma_nl_rcv+0x586/0x900 drivers/infiniband/core/netlink.c:259
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> >  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
> >  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >  ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2406
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > RIP: 0033:0x45c829
> > Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007f1ebed25c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00000000004ff720 RCX: 000000000045c829
> > RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
> > RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> > R13: 00000000000009ad R14: 00000000004d5f10 R15: 00007f1ebed266d4
> > Modules linked in:
> > ---[ end trace 239938a6c4c3c99f ]---
> > RIP: 0010:kobject_get+0x30/0x150 lib/kobject.c:640
> > Code: 53 e8 d4 7e c6 fd 4d 85 e4 0f 84 a2 00 00 00 e8 c6 7e c6 fd 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e7 00 00 00
> > RSP: 0018:ffffc9000772f240 EFLAGS: 00010203
> > RAX: dffffc0000000000 RBX: ffffffff85acfca0 RCX: ffffc9000fc67000
> > RDX: 0000000000000013 RSI: ffffffff83acadfa RDI: 000000000000009c
> > RBP: 0000000000000060 R08: ffff8880a8dfa4c0 R09: ffffed100a03f403
> > R10: ffff8880501fa017 R11: ffffed100a03f402 R12: 0000000000000060
> > R13: ffffc9000772f3c0 R14: ffff88805d1ec4e8 R15: ffff88805d1ec580
> > FS:  00007f1ebed26700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000073fad4 CR3: 00000000a86c4000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> Looks like an IB/rdma issue, poke those developers please :)
> 

If you want people to receive your email, you need to send it to them.

+Cc linux-rdma and maintainers of drivers/infiniband/.

- Eric
