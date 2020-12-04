Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E402CF1EC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgLDQa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDQa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:30:27 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6274C0613D1;
        Fri,  4 Dec 2020 08:29:46 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1klDxl-002Wpq-6O; Fri, 04 Dec 2020 17:29:41 +0100
Message-ID: <03b6e1ab6d4d51f2a3dde7439fbc24c8a9a930c6.camel@sipsolutions.net>
Subject: Re: [PATCH net] mac80211: mesh: fix mesh_pathtbl_init() error path
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org
Date:   Fri, 04 Dec 2020 17:29:39 +0100
In-Reply-To: <20201204162428.2583119-1-eric.dumazet@gmail.com> (sfid-20201204_172435_837291_23D69393)
References: <20201204162428.2583119-1-eric.dumazet@gmail.com>
         (sfid-20201204_172435_837291_23D69393)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 08:24 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
> while tbl_path rhashtable has not yet been initialized, which causes
> panics.
> 
> Simply factorize the rhashtable_init() call into mesh_table_alloc()
> 
> WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __flush_work kernel/workqueue.c:3040 [inline]
> WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
> Modules linked in:
> CPU: 1 PID: 8474 Comm: syz-executor663 Not tainted 5.10.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__flush_work kernel/workqueue.c:3040 [inline]
> RIP: 0010:__cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
> Code: 5d c3 e8 bf ae 29 00 0f 0b e9 f0 fd ff ff e8 b3 ae 29 00 0f 0b 43 80 3c 3e 00 0f 85 31 ff ff ff e9 34 ff ff ff e8 9c ae 29 00 <0f> 0b e9 dc fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 7d fd ff
> RSP: 0018:ffffc9000165f5a0 EFLAGS: 00010293
> RAX: ffffffff814b7064 RBX: 0000000000000001 RCX: ffff888021c80000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888024039ca0 R08: dffffc0000000000 R09: fffffbfff1dd3e64
> R10: fffffbfff1dd3e64 R11: 0000000000000000 R12: 1ffff920002cbebd
> R13: ffff888024039c88 R14: 1ffff11004807391 R15: dffffc0000000000
> FS:  0000000001347880(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 000000002cc0a000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  rhashtable_free_and_destroy+0x25/0x9c0 lib/rhashtable.c:1137
>  mesh_table_free net/mac80211/mesh_pathtbl.c:69 [inline]
>  mesh_pathtbl_init+0x287/0x2e0 net/mac80211/mesh_pathtbl.c:785
>  ieee80211_mesh_init_sdata+0x2ee/0x530 net/mac80211/mesh.c:1591
>  ieee80211_setup_sdata+0x733/0xc40 net/mac80211/iface.c:1569
>  ieee80211_if_add+0xd5c/0x1cd0 net/mac80211/iface.c:1987
>  ieee80211_add_iface+0x59/0x130 net/mac80211/cfg.c:125
>  rdev_add_virtual_intf net/wireless/rdev-ops.h:45 [inline]
>  nl80211_new_interface+0x563/0xb40 net/wireless/nl80211.c:3855
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x780/0x930 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x9a8/0xd40 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  ____sys_sendmsg+0x519/0x800 net/socket.c:2353
>  ___sys_sendmsg net/socket.c:2407 [inline]
>  __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Jakub, if you want to take it to the net tree I wouldn't mind at all,
since I _just_ sent a pull request a little while ago.

Thanks,
johannes

