Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FCE9CA29
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfHZHX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:23:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56282 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729832AbfHZHX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 03:23:58 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7BE717735DF38CEF0012;
        Mon, 26 Aug 2019 15:23:54 +0800 (CST)
Received: from szxyal004123181.china.huawei.com (10.65.65.77) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Mon, 26 Aug 2019 15:23:51 +0800
From:   Dongxu Liu <liudongxu3@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: Adding parameter detection in __ethtool_get_link_ksettings.
Date:   Mon, 26 Aug 2019 15:23:32 +0800
Message-ID: <20190826072332.14736-1-liudongxu3@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.65.77]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __ethtool_get_link_ksettings symbol will be exported,
and external users may use an illegal address.
We should check the parameters before using them,
otherwise the system will crash.

[ 8980.991134] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 8980.993049] IP: [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
[ 8980.994285] PGD 0
[ 8980.995013] Oops: 0000 [#1] SMP
[ 8980.995896] Modules linked in: sch_ingress ...
[ 8981.013220] CPU: 3 PID: 25174 Comm: kworker/3:3 Tainted: G           O   ----V-------   3.10.0-327.36.58.4.x86_64 #1
[ 8981.017667] Workqueue: events linkwatch_event
[ 8981.018652] task: ffff8800a8348000 ti: ffff8800b045c000 task.ti: ffff8800b045c000
[ 8981.020418] RIP: 0010:[<ffffffff8155aca7>]  [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
[ 8981.022383] RSP: 0018:ffff8800b045fc88  EFLAGS: 00010202
[ 8981.023453] RAX: 0000000000000000 RBX: ffff8800b045fcac RCX: 0000000000000000
[ 8981.024726] RDX: ffff8800b658f600 RSI: ffff8800b045fcac RDI: ffff8802296e0000
[ 8981.026000] RBP: ffff8800b045fc98 R08: 0000000000000000 R09: 0000000000000001
[ 8981.027273] R10: 00000000000073e0 R11: 0000082b0cc8adea R12: ffff8802296e0000
[ 8981.028561] R13: ffff8800b566e8c0 R14: ffff8800b658f600 R15: ffff8800b566e000
[ 8981.029841] FS:  0000000000000000(0000) GS:ffff88023ed80000(0000) knlGS:0000000000000000
[ 8981.031715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8981.032845] CR2: 0000000000000000 CR3: 00000000b39a9000 CR4: 00000000003407e0
[ 8981.034137] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8981.035427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 8981.036702] Stack:
[ 8981.037406]  ffff8800b658f600 0000000000009c40 ffff8800b045fce8 ffffffffa047a71d
[ 8981.039238]  000000000000004d ffff8800b045fcc8 ffff8800b045fd28 ffffffff815cb198
[ 8981.041070]  ffff8800b045fcd8 ffffffff810807e6 00000000e8212951 0000000000000001
[ 8981.042910] Call Trace:
[ 8981.043660]  [<ffffffffa047a71d>] bond_update_speed_duplex+0x3d/0x90 [bonding]
[ 8981.045424]  [<ffffffff815cb198>] ? inetdev_event+0x38/0x530
[ 8981.046554]  [<ffffffff810807e6>] ? put_online_cpus+0x56/0x80
[ 8981.047688]  [<ffffffffa0480d67>] bond_netdev_event+0x137/0x360 [bonding]
...

Signed-off-by: Dongxu Liu <liudongxu3@huawei.com>
---
 net/core/ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69..9a50b64 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -545,6 +545,8 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 {
 	ASSERT_RTNL();
 
+	if (!dev || !dev->ethtool_ops)
+		return -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
 
-- 
2.12.3


