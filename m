Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AC73B6EA5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhF2HV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 03:21:58 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9317 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhF2HV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 03:21:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GDbN40btHz7094;
        Tue, 29 Jun 2021 15:15:16 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 15:19:28 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 29 Jun
 2021 15:19:28 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net] net/802/mrp: fix memleak in mrp_request_join()
Date:   Tue, 29 Jun 2021 15:22:37 +0800
Message-ID: <20210629072237.991461-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got kmemleak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff88810c239500 (size 64):
comm "syz-executor940", pid 882, jiffies 4294712870 (age 14.631s)
hex dump (first 32 bytes):
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 01 00 00 00 01 02 00 04 ................
backtrace:
[<00000000a323afa4>] slab_alloc_node mm/slub.c:2972 [inline]
[<00000000a323afa4>] slab_alloc mm/slub.c:2980 [inline]
[<00000000a323afa4>] __kmalloc+0x167/0x340 mm/slub.c:4130
[<000000005034ca11>] kmalloc include/linux/slab.h:595 [inline]
[<000000005034ca11>] mrp_attr_create net/802/mrp.c:276 [inline]
[<000000005034ca11>] mrp_request_join+0x265/0x550 net/802/mrp.c:530
[<00000000fcfd81f3>] vlan_mvrp_request_join+0x145/0x170 net/8021q/vlan_mvrp.c:40
[<000000009258546e>] vlan_dev_open+0x477/0x890 net/8021q/vlan_dev.c:292
[<0000000059acd82b>] __dev_open+0x281/0x410 net/core/dev.c:1609
[<000000004e6dc695>] __dev_change_flags+0x424/0x560 net/core/dev.c:8767
[<00000000471a09af>] rtnl_configure_link+0xd9/0x210 net/core/rtnetlink.c:3122
[<0000000037a4672b>] __rtnl_newlink+0xe08/0x13e0 net/core/rtnetlink.c:3448
[<000000008d5d0fda>] rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3488
[<000000004882fe39>] rtnetlink_rcv_msg+0x369/0xa10 net/core/rtnetlink.c:5552
[<00000000907e6c54>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
[<00000000e7d7a8c4>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
[<00000000e7d7a8c4>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
[<00000000e0645d50>] netlink_sendmsg+0x78e/0xc90 net/netlink/af_netlink.c:1929
[<00000000c24559b7>] sock_sendmsg_nosec net/socket.c:654 [inline]
[<00000000c24559b7>] sock_sendmsg+0x139/0x170 net/socket.c:674
[<00000000fc210bc2>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
[<00000000be4577b5>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404

Calling mrp_request_leave() after mrp_request_join(), the attr->state
is set to MRP_APPLICANT_VO, mrp_attr_destroy() won't be called in last
TX event in mrp_uninit_applicant(), the attr of applicant will be leaked.
To fix this leak, iterate and free each attr of applicant before rerturning
from mrp_uninit_applicant().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/802/mrp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/802/mrp.c b/net/802/mrp.c
index bea6e43d45a0..35e04cc5390c 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -292,6 +292,19 @@ static void mrp_attr_destroy(struct mrp_applicant *app, struct mrp_attr *attr)
 	kfree(attr);
 }
 
+static void mrp_attr_destroy_all(struct mrp_applicant *app)
+{
+	struct rb_node *node, *next;
+	struct mrp_attr *attr;
+
+	for (node = rb_first(&app->mad);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		attr = rb_entry(node, struct mrp_attr, node);
+		mrp_attr_destroy(app, attr);
+	}
+}
+
 static int mrp_pdu_init(struct mrp_applicant *app)
 {
 	struct sk_buff *skb;
@@ -895,6 +908,7 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 
 	spin_lock_bh(&app->lock);
 	mrp_mad_event(app, MRP_EVENT_TX);
+	mrp_attr_destroy_all(app);
 	mrp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.25.1

