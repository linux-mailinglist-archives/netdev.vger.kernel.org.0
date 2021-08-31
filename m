Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1A3FC8AD
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbhHaNtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239133AbhHaNtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 09:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65C96056B;
        Tue, 31 Aug 2021 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630417726;
        bh=Oouc9A4uNZj96CyIQ8qjGv2+WlOXL4lK4PcLQ4g4pIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jF0ceW1YuwolhOzsOLURKnrlG+v5SmmgMscEo78jcaLgn3du0DAb0zC1FuS1H6jAg
         hzaIvbCcCjFVzFwuGLK4N43hRGhz0cAlg1vNYkEcggzHdIB84kRmzpDV501W50m6cV
         +iBGBlXnWQ/r40WN69QDgw6zoncpVyragqk89y62sctGLfAlOaK1tJNQQw2hv5we+3
         vX35wjVsZd532IU7L39JvQj+c5l422JrcX+RGmu6NWLWiglvwpJe0gwsHl77bYRC3k
         oksyn3Yi8uXvJW9AqYmAVeKZqnSnc1IkOBI3/1MjSBeS/Pr/B9ScoAx+AIhGsocxJB
         /J82VQN2vAMSA==
Date:   Tue, 31 Aug 2021 06:48:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in phy_disconnect
Message-ID: <20210831064845.1a8f5c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0000000000006a17f905cad88525@google.com>
References: <0000000000006a17f905cad88525@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 03:36:23 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c1587d99f93 usb: isp1760: otg control register access
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=16907291300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=24756feea212a6b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=6a916267d9bc5fa2d9a6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166de449300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c5ddce300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com
> 
> asix 1-1:0.0 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
> usb 1-1: USB disconnect, device number 2
> asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet
> general protection fault, probably for non-canonical address 0xdffffc00000000c3: 0000 [#1] SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000618-0x000000000000061f]
> CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:phy_is_started include/linux/phy.h:947 [inline]
> RIP: 0010:phy_disconnect+0x22/0x110 drivers/net/phy/phy_device.c:1097
> Code: 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 46 33 68 fe 48 8d bd 18 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e c5 00 00 00 8b 9d 18 06 00 00
> RSP: 0018:ffffc900001a7780 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffff88811a410bc0 RCX: 0000000000000000
> RDX: 00000000000000c3 RSI: ffffffff82d9305a RDI: 0000000000000618
> RBP: 0000000000000000 R08: 0000000000000055 R09: 0000000000000000
> R10: ffffffff814c05fb R11: 0000000000000000 R12: ffff8881063cc300
> R13: ffffffff83870d90 R14: ffffffff86805a20 R15: ffffffff868059e0
> FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb4c30b3008 CR3: 00000001021e1000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ax88772_unbind+0x51/0x90 drivers/net/usb/asix_devices.c:816
>  usbnet_disconnect+0x103/0x270 drivers/net/usb/usbnet.c:1618
>  usb_unbind_interface+0x1d8/0x8d0 drivers/usb/core/driver.c:458
>  __device_release_driver+0x3bd/0x6f0 drivers/base/dd.c:1201
>  device_release_driver_internal drivers/base/dd.c:1232 [inline]
>  device_release_driver+0x26/0x40 drivers/base/dd.c:1255
>  bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
>  device_del+0x502/0xd40 drivers/base/core.c:3543
>  usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
>  usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2225
>  hub_port_connect drivers/usb/core/hub.c:5199 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5488 [inline]
>  port_event drivers/usb/core/hub.c:5634 [inline]
>  hub_event+0x1c9c/0x4330 drivers/usb/core/hub.c:5716
>  process_one_work+0x98d/0x15b0 kernel/workqueue.c:2276
>  process_scheduled_works kernel/workqueue.c:2338 [inline]
>  worker_thread+0x85c/0x11f0 kernel/workqueue.c:2424
>  kthread+0x3c0/0x4a0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Modules linked in:
> ---[ end trace d08c08ba92f8f06f ]---
> RIP: 0010:phy_is_started include/linux/phy.h:947 [inline]
> RIP: 0010:phy_disconnect+0x22/0x110 drivers/net/phy/phy_device.c:1097
> Code: 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 46 33 68 fe 48 8d bd 18 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e c5 00 00 00 8b 9d 18 06 00 00
> RSP: 0018:ffffc900001a7780 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffff88811a410bc0 RCX: 0000000000000000
> RDX: 00000000000000c3 RSI: ffffffff82d9305a RDI: 0000000000000618
> RBP: 0000000000000000 R08: 0000000000000055 R09: 0000000000000000
> R10: ffffffff814c05fb R11: 0000000000000000 R12: ffff8881063cc300
> R13: ffffffff83870d90 R14: ffffffff86805a20 R15: ffffffff868059e0
> FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb4c30b3008 CR3: 00000001021e1000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
>    7:	00
>    8:	55                   	push   %rbp
>    9:	48 89 fd             	mov    %rdi,%rbp
>    c:	53                   	push   %rbx
>    d:	e8 46 33 68 fe       	callq  0xfe683358
>   12:	48 8d bd 18 06 00 00 	lea    0x618(%rbp),%rdi
>   19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   20:	fc ff df
>   23:	48 89 fa             	mov    %rdi,%rdx
>   26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
>   2e:	84 c0                	test   %al,%al
>   30:	74 08                	je     0x3a
>   32:	3c 03                	cmp    $0x3,%al
>   34:	0f 8e c5 00 00 00    	jle    0xff
>   3a:	8b 9d 18 06 00 00    	mov    0x618(%rbp),%ebx
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

Oleksij may know.
