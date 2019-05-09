Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A1A18C61
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEIOw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 10:52:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7185 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbfEIOw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 10:52:58 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F1AF7F6CEB7313DD1FC2;
        Thu,  9 May 2019 22:52:55 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 May 2019
 22:52:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <willemb@google.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <maximmi@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] packet: Fix error path in packet_init
Date:   Thu, 9 May 2019 22:52:20 +0800
Message-ID: <20190509145220.37432-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190508153241.30776-1-yuehaibing@huawei.com>
References: <20190508153241.30776-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel BUG at lib/list_debug.c:47!
invalid opcode: 0000 [#1
CPU: 0 PID: 12914 Comm: rmmod Tainted: G        W         5.1.0+ #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:__list_del_entry_valid+0x53/0x90
Code: 48 8b 32 48 39 fe 75 35 48 8b 50 08 48 39 f2 75 40 b8 01 00 00 00 5d c3 48
89 fe 48 89 c2 48 c7 c7 18 75 fe 82 e8 cb 34 78 ff <0f> 0b 48 89 fe 48 c7 c7 50 75 fe 82 e8 ba 34 78 ff 0f 0b 48 89 f2
RSP: 0018:ffffc90001c2fe40 EFLAGS: 00010286
RAX: 000000000000004e RBX: ffffffffa0184000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888237a17788 RDI: 00000000ffffffff
RBP: ffffc90001c2fe40 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc90001c2fe10 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90001c2fe50 R14: ffffffffa0184000 R15: 0000000000000000
FS:  00007f3d83634540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555c350ea818 CR3: 0000000231677000 CR4: 00000000000006f0
Call Trace:
 unregister_pernet_operations+0x34/0x120
 unregister_pernet_subsys+0x1c/0x30
 packet_exit+0x1c/0x369 [af_packet
 __x64_sys_delete_module+0x156/0x260
 ? lockdep_hardirqs_on+0x133/0x1b0
 ? do_syscall_64+0x12/0x1f0
 do_syscall_64+0x6e/0x1f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

When modprobe af_packet, register_pernet_subsys
fails and does a cleanup, ops->list is set to LIST_POISON1,
but the module init is considered to success, then while rmmod it,
BUG() is triggered in __list_del_entry_valid which is called from
unregister_pernet_subsys. This patch fix error handing path in
packet_init to avoid possilbe issue if some error occur.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: rework commit log
---
 net/packet/af_packet.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 90d4e3c..fbc775fb 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4598,14 +4598,29 @@ static void __exit packet_exit(void)
 
 static int __init packet_init(void)
 {
-	int rc = proto_register(&packet_proto, 0);
+	int rc;
 
-	if (rc != 0)
+	rc = proto_register(&packet_proto, 0);
+	if (rc)
 		goto out;
+	rc = sock_register(&packet_family_ops);
+	if (rc)
+		goto out_proto;
+	rc = register_pernet_subsys(&packet_net_ops);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&packet_netdev_notifier);
+	if (rc)
+		goto out_pernet;
 
-	sock_register(&packet_family_ops);
-	register_pernet_subsys(&packet_net_ops);
-	register_netdevice_notifier(&packet_netdev_notifier);
+	return 0;
+
+out_pernet:
+	unregister_pernet_subsys(&packet_net_ops);
+out_sock:
+	sock_unregister(PF_PACKET);
+out_proto:
+	proto_unregister(&packet_proto);
 out:
 	return rc;
 }
-- 
1.8.3.1


