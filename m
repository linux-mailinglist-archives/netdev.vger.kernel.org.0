Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6010CCAD65
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389976AbfJCRk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:40:57 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37545 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731338AbfJCP7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:59:30 -0400
Received: by mail-pl1-f201.google.com with SMTP id p15so2026036plq.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 08:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yhyVhYskhPWbCHGPCTfMn8ZN5jtGEjOfpveHWoTCZq4=;
        b=DvV2srjw630dkyTgOkwxffOASQqFC08laTSQZVAD9I5gnN2tffLObAHO0CdLmguGrE
         Li0MuLNT93F3WQ2l0uPzbKLSDcDKGr5KvTEg1F8VMNL7Dx+aJSCMQq2vVbyA9aFKNQrd
         SSmA8eDQg5HcIbRxy6Qcih2zq48ZPEpr0mtkEIUPuRmuxrBuhDQs+qTQ+I19SPmvnJPY
         KYF1mPn8pOv9+pPF2+T6lrKtKCPHP8Gs3sA4SbN4EFEslNu/V0U3kLWffbMCahCcrAn7
         Hxd9xSbZH+QKHL9dVVKX7Y9ajef2ib08+avaikf3mSz0pUFEmzjSgzzMQCd5Mq04TQDK
         bnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yhyVhYskhPWbCHGPCTfMn8ZN5jtGEjOfpveHWoTCZq4=;
        b=OfAtLM0qYgYF53ZbL57a++rrEaNip6Glz3qE+gSAJDeg/EjS53MjHW1vEBzJeHUH5g
         tIG8eIghLxJ+Tpsv18GHyS0lC/o8xjeoCMXodPw5sQanpE8XNYFEutyAYxOtnKCg2LJ1
         WjxSNuKJq5KaMxtdrnmXPfP9nqxS3kXkcyF8u0D+nYqgoNjBHk0TkiSAEg3+JcU41Dcd
         SIQGNiVZ/rOxo/KGUTRb9s6BS8KDhSdxOjIIJyFhs1brMaixb+zu+0znHJApaCXtc7VM
         W0DyuulyJcn9y4AA/KaakTLUBQhErNYN71dw1mKC04f2dB0Umv7qPez2BDKivIlkTBwU
         tLiw==
X-Gm-Message-State: APjAAAXqaOhJLnjLEhaI9YkDohaKnmtx52Ku+J0D+/JPjbnM1/1rPOw3
        oc7rfVpLWpZknOcBU3q6zhhSi90cFIhJ9Q==
X-Google-Smtp-Source: APXvYqxeAfRmyyyS63uFYt1xqdvSmfrjc4RhMIubr/4m0J6skQ6gTmpKrKQz4awOdWmFSs3lwLGUg8mrSVb63g==
X-Received: by 2002:a63:8943:: with SMTP id v64mr10154661pgd.209.1570118367873;
 Thu, 03 Oct 2019 08:59:27 -0700 (PDT)
Date:   Thu,  3 Oct 2019 08:59:24 -0700
Message-Id: <20191003155924.71666-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net-next] net: propagate errors correctly in register_netdevice()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If netdev_name_node_head_alloc() fails to allocate
memory, we absolutely want register_netdevice() to return
-ENOMEM instead of zero :/

One of the syzbot report looked like :

general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8760 Comm: syz-executor839 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ovs_vport_add+0x185/0x500 net/openvswitch/vport.c:205
Code: 89 c6 e8 3e b6 3a fa 49 81 fc 00 f0 ff ff 0f 87 6d 02 00 00 e8 8c b4 3a fa 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 02 00 00 49 8d 7c 24 08 49 8b 34 24 48 b8 00
RSP: 0018:ffff88808fe5f4e0 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffffffff89be8820 RCX: ffffffff87385162
RDX: 0000000000000000 RSI: ffffffff87385174 RDI: 0000000000000007
RBP: ffff88808fe5f510 R08: ffff8880933c6600 R09: fffffbfff14ee13c
R10: fffffbfff14ee13b R11: ffffffff8a7709df R12: 0000000000000004
R13: ffffffff89be8850 R14: ffff88808fe5f5e0 R15: 0000000000000002
FS:  0000000001d71880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 0000000096e4c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 new_vport+0x1b/0x1d0 net/openvswitch/datapath.c:194
 ovs_dp_cmd_new+0x5e5/0xe30 net/openvswitch/datapath.c:1644
 genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
 genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x803/0x920 net/socket.c:2311
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
 __do_sys_sendmsg net/socket.c:2365 [inline]
 __se_sys_sendmsg net/socket.c:2363 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363

Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c680225e0da844bbbd66c9044851880fa7885117..944de67ee95d621a1cde98d3fadfdab392b5aa98 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8935,6 +8935,7 @@ int register_netdevice(struct net_device *dev)
 	if (ret < 0)
 		goto out;
 
+	ret = -ENOMEM;
 	dev->name_node = netdev_name_node_head_alloc(dev);
 	if (!dev->name_node)
 		goto out;
-- 
2.23.0.581.g78d2f28ef7-goog

