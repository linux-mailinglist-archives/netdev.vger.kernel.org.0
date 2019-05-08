Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1827417D59
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 17:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfEHPdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 11:33:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbfEHPdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 11:33:15 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ED8C04C8B852AB280886;
        Wed,  8 May 2019 23:33:10 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 23:32:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <willemb@google.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <maximmi@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] packet: Fix error path in packet_init
Date:   Wed, 8 May 2019 23:32:41 +0800
Message-ID: <20190508153241.30776-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
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
 CPU: 0 PID: 11195 Comm: rmmod Tainted: G        W         5.1.0+ #33
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
 RIP: 0010:__list_del_entry_valid+0x55/0x90
 Code: 12 48 39 d7 75 39 48 8b 50 08 48 39 d7 75 1d b8 01 00 00 00 5d c3 48 89 c2 48 89 fe 
 31 c0 48 c7 c7 40 3a fe 82 e8 74 c1 78 ff <0f> 0b 48 89 fe 31 c0 48 c7 c7 f0 3a fe 82 e8 61 c1 78 ff 0f 0b 48
 RSP: 0018:ffffc90001b8be48 EFLAGS: 00010246
 RAX: 000000000000004e RBX: ffffffffa0210000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff888237a16808 RDI: 00000000ffffffff
 RBP: ffffc90001b8be48 R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000000 R11: ffffffff842c1640 R12: 0000000000000800
 R13: 0000000000000000 R14: ffffc90001b8be58 R15: ffffffffa0210000
 FS:  00007f58963c7540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000056064c7af818 CR3: 00000001e9895000 CR4: 00000000000006f0
 Call Trace:
  unregister_pernet_operations+0x34/0x110
  unregister_pernet_subsys+0x1c/0x30
  packet_exit+0x1c/0x1dd [af_packet
  __x64_sys_delete_module+0x16b/0x290
  ? trace_hardirqs_off_thunk+0x1a/0x1c
  do_syscall_64+0x6b/0x1d0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix error handing path in packet_init to
avoid possilbe issue if some error occur.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/packet/af_packet.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 90d4e3c..3917c75 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4598,14 +4598,30 @@ static void __exit packet_exit(void)
 
 static int __init packet_init(void)
 {
-	int rc = proto_register(&packet_proto, 0);
+	int rc;
 
-	if (rc != 0)
+	rc = proto_register(&packet_proto, 0);
+	if (rc)
 		goto out;
 
-	sock_register(&packet_family_ops);
-	register_pernet_subsys(&packet_net_ops);
-	register_netdevice_notifier(&packet_netdev_notifier);
+	rc = sock_register(&packet_family_ops);
+	if (rc)
+		goto out_proto;
+	rc = register_pernet_subsys(&packet_net_ops);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&packet_netdev_notifier);
+	if (rc)
+		goto out_pernet;
+
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


