Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707C03B7197
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhF2Lwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 07:52:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9427 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhF2Lwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 07:52:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GDjPd1y53zZndd;
        Tue, 29 Jun 2021 19:47:01 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 19:50:07 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 29 Jun
 2021 19:50:06 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net] net/802/garp: fix memleak in garp_request_join()
Date:   Tue, 29 Jun 2021 19:53:28 +0800
Message-ID: <20210629115328.1328947-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got kmemleak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff88810c909b80 (size 64):
  comm "syz", pid 957, jiffies 4295220394 (age 399.090s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 08 00 00 00 01 02 00 04  ................
  backtrace:
    [<00000000ca1f2e2e>] garp_request_join+0x285/0x3d0
    [<00000000bf153351>] vlan_gvrp_request_join+0x15b/0x190
    [<0000000024005e72>] vlan_dev_open+0x706/0x980
    [<00000000dc20c4d4>] __dev_open+0x2bb/0x460
    [<0000000066573004>] __dev_change_flags+0x501/0x650
    [<0000000035b42f83>] rtnl_configure_link+0xee/0x280
    [<00000000a5e69de0>] __rtnl_newlink+0xed5/0x1550
    [<00000000a5258f4a>] rtnl_newlink+0x66/0x90
    [<00000000506568ee>] rtnetlink_rcv_msg+0x439/0xbd0
    [<00000000b7eaeae1>] netlink_rcv_skb+0x14d/0x420
    [<00000000c373ce66>] netlink_unicast+0x550/0x750
    [<00000000ec74ce74>] netlink_sendmsg+0x88b/0xda0
    [<00000000381ff246>] sock_sendmsg+0xc9/0x120
    [<000000008f6a2db3>] ____sys_sendmsg+0x6e8/0x820
    [<000000008d9c1735>] ___sys_sendmsg+0x145/0x1c0
    [<00000000aa39dd8b>] __sys_sendmsg+0xfe/0x1d0

Calling garp_request_leave() after garp_request_join(), the attr->state
is set to GARP_APPLICANT_VO, garp_attr_destroy() won't be called in last
transmit event in garp_uninit_applicant(), the attr of applicant will be
leaked. To fix this leak, iterate and free each attr of applicant before
rerturning from garp_uninit_applicant().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/802/garp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/802/garp.c b/net/802/garp.c
index 400bd857e5f5..95f3f91f1be4 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -203,6 +203,19 @@ static void garp_attr_destroy(struct garp_applicant *app, struct garp_attr *attr
 	kfree(attr);
 }
 
+static void garp_attr_destroy_all(struct garp_applicant *app)
+{
+	struct rb_node *node, *next;
+	struct garp_attr *attr;
+
+	for (node = rb_first(&app->gid);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		attr = rb_entry(node, struct garp_attr, node);
+		garp_attr_destroy(app, attr);
+	}
+}
+
 static int garp_pdu_init(struct garp_applicant *app)
 {
 	struct sk_buff *skb;
@@ -609,6 +622,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
+	garp_attr_destroy_all(app);
 	garp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.25.1

