Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D41E1EB5F2
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgFBGq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:46:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbgFBGq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 02:46:27 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 507018198B69DF27ABE0;
        Tue,  2 Jun 2020 14:46:25 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 2 Jun 2020
 14:46:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: genetlink: Fix memleak in genl_family_rcv_msg_dumpit()
Date:   Tue, 2 Jun 2020 14:45:45 +0800
Message-ID: <20200602064545.50288-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dumpit info is freed by cb->done now (genl_lock_done()/
genl_parallel_done()), however if any error occurs before
cb->done is called, info and attrs will leak.

unreferenced object 0xffff888119904840 (size 32):
comm "syz-executor.0", pid 857, jiffies 4295306979 (age 18.692s)
hex dump (first 32 bytes):
60 2d 5a af ff ff ff ff c0 d6 a5 ae ff ff ff ff `-Z.............
00 00 00 00 00 00 00 00 60 b4 25 ac ff ff ff ff ........`.%.....
backtrace:
[<0000000048573ee1>] kmalloc include/linux/slab.h:555 [inline]
[<0000000048573ee1>] genl_dumpit_info_alloc net/netlink/genetlink.c:463 [inline]
[<0000000048573ee1>] genl_family_rcv_msg_dumpit net/netlink/genetlink.c:598 [inline]
[<0000000048573ee1>] genl_family_rcv_msg net/netlink/genetlink.c:715 [inline]
[<0000000048573ee1>] genl_rcv_msg+0x7b7/0xce0 net/netlink/genetlink.c:735
[<000000006d27610a>] netlink_rcv_skb+0x139/0x390 net/netlink/af_netlink.c:2469
[<00000000d643c808>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
[<00000000fdec3fc5>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
[<00000000fdec3fc5>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1329
[<0000000027eb500d>] netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1918
[<000000006e6952a8>] sock_sendmsg_nosec net/socket.c:652 [inline]
[<000000006e6952a8>] sock_sendmsg+0x139/0x170 net/socket.c:672

Fixes: 1927f41a22a0 ("net: genetlink: introduce dump info struct to be available during dumpit op")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netlink/genetlink.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9f357aa22b94..cd719aecb0e2 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -548,8 +548,6 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
-	genl_dumpit_info_free(info);
 	return rc;
 }
 
@@ -561,8 +559,6 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
-	genl_dumpit_info_free(info);
 	return rc;
 }
 
@@ -594,7 +590,6 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 		return PTR_ERR(attrs);
 
 no_attrs:
-	/* Allocate dumpit info. It is going to be freed by done() callback. */
 	info = genl_dumpit_info_alloc();
 	if (!info) {
 		genl_family_rcv_msg_attrs_free(family, attrs, true);
@@ -630,6 +625,9 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
 	}
 
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
+	genl_dumpit_info_free(info);
+
 	return err;
 }
 
-- 
2.20.1


