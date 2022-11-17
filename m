Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC9D62E9A9
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbiKQXef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiKQXeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:34:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A3D11C27
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668728009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNFyzNm8VQEUNLdXK4oozbVNFUhal17EFX9EzZy8ieM=;
        b=QoOEpT6oa5AMJnDjvPh9vO+oaGrU3l3YGSTwd1H3nkBMXg85OIHWthaq15/lQJRcQSJKAe
        w3hzPsQNFn71QdZZDP6/UbFUmq+Q12UWgFQv7YlfIE3dgkkPrd221IROYFpWvcGVZ36fgK
        rVToPcZQqKhATSh3ibN0IdTJvJH1KS4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-g1JAzu_PPPySN34Tz45q3Q-1; Thu, 17 Nov 2022 18:33:25 -0500
X-MC-Unique: g1JAzu_PPPySN34Tz45q3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5DCA383D0C5;
        Thu, 17 Nov 2022 23:33:24 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBDE4C158CF;
        Thu, 17 Nov 2022 23:33:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 1/2] veth: fix uninitialized napi disable
Date:   Fri, 18 Nov 2022 00:33:10 +0100
Message-Id: <c59f4adcdd1296ee37cc6bca4d927b8c79158909.1668727939.git.pabeni@redhat.com>
In-Reply-To: <cover.1668727939.git.pabeni@redhat.com>
References: <cover.1668727939.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reports a list corruption at veth close time:

kernel BUG at lib/list_debug.c:56!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 4247 Comm: syz-executor.4 Not tainted 6.1.0-rc4-syzkaller-01115-g68d268d08931 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__list_del_entry_valid.cold+0x37/0x72 lib/list_debug.c:56
Code: e8 d2 62 f0 ff 0f 0b 48 89 ee 48 c7 c7 80 10 a8 8a e8 c1 62 f0 ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 40 11 a8 8a e8 ad 62 f0 ff <0f> 0b 48 89 ee 48 c7 c7 20 10 a8 8a e8 9c 62 f0 ff 0f 0b 4c 89 ea
RSP: 0018:ffffc9000a116ed0 EFLAGS: 00010282
RAX: 000000000000004e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8165772c RDI: fffff52001422dcc
RBP: ffff88804eace160 R08: 000000000000004e R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: dead000000000122
R13: ffff88804eab6050 R14: ffff88804eace000 R15: ffff88804eace000
FS:  00007fa8ab74e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002040f030 CR3: 000000007efb8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry include/linux/list.h:134 [inline]
 list_del_rcu include/linux/rculist.h:157 [inline]
 __netif_napi_del.part.0+0x118/0x530 net/core/dev.c:6458
 __netif_napi_del+0x40/0x50 net/core/dev.c:6454
 veth_napi_del_range+0xcd/0x560 drivers/net/veth.c:1041
 veth_napi_del drivers/net/veth.c:1055 [inline]
 veth_close+0x164/0x500 drivers/net/veth.c:1385
 __dev_close_many+0x1b6/0x2e0 net/core/dev.c:1501
 __dev_close net/core/dev.c:1513 [inline]
 __dev_change_flags+0x2ce/0x750 net/core/dev.c:8528
 dev_change_flags+0x97/0x170 net/core/dev.c:8602
 do_setlink+0x9f1/0x3bb0 net/core/rtnetlink.c:2827
 rtnl_group_changelink net/core/rtnetlink.c:3344 [inline]
 __rtnl_newlink+0xb90/0x1840 net/core/rtnetlink.c:3600
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa8aaa8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa8ab74e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa8aababf80 RCX: 00007fa8aaa8b639
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007fa8aaae6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe720d839f R14: 00007fa8ab74e300 R15: 0000000000022000
 </TASK>

The issue can actually reproduced with:

ip link add type veth
ip link set dev veth0 up
ip link set dev veth1 up
ip link set dev veth0 xdp object <obj>
ip link set dev veth0 down
ip link set dev veth1 down

The veth1 napi instances are deleted first when veth0 goes down,
and when veth1 is shut down, veth_close() tries again to delete
them, causing the oops.

This patch addresses the issue explicitly checking that the napi
instances are enabled before deleting them.

Fixes: 2e0de6366ac1 ("veth: Avoid drop packets when xdp_redirect performs")
Reported-by: syzbot+0cffe54ffe58ab9c059b@syzkaller.appspotmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2a4592780141..1384134f7100 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1381,7 +1381,8 @@ static int veth_close(struct net_device *dev)
 			if (!veth_gro_requested(peer) && !peer_priv->_xdp_prog)
 				veth_napi_del(peer);
 		}
-	} else if (veth_gro_requested(dev) || (peer && peer_priv->_xdp_prog)) {
+	} else if ((veth_gro_requested(dev) || (peer && peer_priv->_xdp_prog)) &&
+		   rtnl_dereference(priv->rq[0].napi)) {
 		veth_napi_del(dev);
 	}
 
-- 
2.38.1

