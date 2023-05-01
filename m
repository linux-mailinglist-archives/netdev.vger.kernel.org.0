Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA716F3923
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEAU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 16:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjEAU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 16:29:35 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111E91FFD
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 13:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682972974; x=1714508974;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=322qd8IMEEvxaY6G+uLHDrb461NMmCtD5wX0szD7zug=;
  b=eRZ+trHY7CIxuj+/ZhrwEnU5NS/p3oJGHI9uKa5wc25vzZrFY0XhNW6x
   ZdzUAF+VH0ehpwm3t+N4XktfXGdWxJ3xzdY65nOkcXps9S17AxM6V0nzF
   TdBAI6QXyl2ZFMZpFSBjGyxBHCzaxXvv5tdD1cJnN2Se54IMl83/6shFB
   E=;
X-IronPort-AV: E=Sophos;i="5.99,242,1677542400"; 
   d="scan'208";a="210041263"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2023 20:29:31 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 0D789815B2;
        Mon,  1 May 2023 20:29:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 1 May 2023 20:29:27 +0000
Received: from 88665a182662.ant.amazon.com.com (10.119.90.236) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 1 May 2023 20:29:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Zhengchao Shao <shaozhengchao@huawei.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net] af_packet: Don't send zero-byte data in packet_sendmsg_spkt().
Date:   Mon, 1 May 2023 13:28:57 -0700
Message-ID: <20230501202856.98962-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.90.236]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reported a warning below [0].

We can reproduce it by sending 0-byte data from the (AF_PACKET,
SOCK_PACKET) socket via some devices whose dev->hard_header_len
is 0.

    struct sockaddr_pkt addr = {
        .spkt_family = AF_PACKET,
        .spkt_device = "tun0",
    };
    int fd;

    fd = socket(AF_PACKET, SOCK_PACKET, 0);
    sendto(fd, NULL, 0, 0, (struct sockaddr *)&addr, sizeof(addr));

We have a similar fix for the (AF_PACKET, SOCK_RAW) socket as
commit dc633700f00f ("net/af_packet: check len when min_header_len
equals to 0").

Let's add the same test for the SOCK_PACKET socket.

[0]:
skb_assert_len
WARNING: CPU: 1 PID: 19945 at include/linux/skbuff.h:2552 skb_assert_len include/linux/skbuff.h:2552 [inline]
WARNING: CPU: 1 PID: 19945 at include/linux/skbuff.h:2552 __dev_queue_xmit+0x1f26/0x31d0 net/core/dev.c:4159
Modules linked in:
CPU: 1 PID: 19945 Comm: syz-executor.0 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:skb_assert_len include/linux/skbuff.h:2552 [inline]
RIP: 0010:__dev_queue_xmit+0x1f26/0x31d0 net/core/dev.c:4159
Code: 89 de e8 1d a2 85 fd 84 db 75 21 e8 64 a9 85 fd 48 c7 c6 80 2a 1f 86 48 c7 c7 c0 06 1f 86 c6 05 23 cf 27 04 01 e8 fa ee 56 fd <0f> 0b e8 43 a9 85 fd 0f b6 1d 0f cf 27 04 31 ff 89 de e8 e3 a1 85
RSP: 0018:ffff8880217af6e0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90001133000
RDX: 0000000000040000 RSI: ffffffff81186922 RDI: 0000000000000001
RBP: ffff8880217af8b0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff888030045640
R13: ffff8880300456b0 R14: ffff888030045650 R15: ffff888030045718
FS:  00007fc5864da640(0000) GS:ffff88806cd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020005740 CR3: 000000003f856003 CR4: 0000000000770ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 dev_queue_xmit include/linux/netdevice.h:3085 [inline]
 packet_sendmsg_spkt+0xc4b/0x1230 net/packet/af_packet.c:2066
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0x1b4/0x200 net/socket.c:747
 ____sys_sendmsg+0x331/0x970 net/socket.c:2503
 ___sys_sendmsg+0x11d/0x1c0 net/socket.c:2557
 __sys_sendmmsg+0x18c/0x430 net/socket.c:2643
 __do_sys_sendmmsg net/socket.c:2672 [inline]
 __se_sys_sendmmsg net/socket.c:2669 [inline]
 __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2669
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3c/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7fc58791de5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007fc5864d9cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004bbf80 RCX: 00007fc58791de5d
RDX: 0000000000000001 RSI: 0000000020005740 RDI: 0000000000000004
RBP: 00000000004bbf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007fc58797e530 R15: 0000000000000000
 </TASK>
---[ end trace 0000000000000000 ]---
skb len=0 headroom=16 headlen=0 tailroom=304
mac=(16,0) net=(16,-1) trans=-1
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0
dev name=sit0 feat=0x00000006401d7869
sk family=17 type=10 proto=0

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v2:
  * Remove Fixes tag of fd1894224407

v1: https://lore.kernel.org/netdev/20230501192322.89544-1-kuniyu@amazon.com/
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6080c0db0814..640d94e34635 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2033,7 +2033,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 		goto retry;
 	}
 
-	if (!dev_validate_header(dev, skb->data, len)) {
+	if (!dev_validate_header(dev, skb->data, len) || !skb->len) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.30.2

