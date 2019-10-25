Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504BFE4CA2
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504908AbfJYNsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:48:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502085AbfJYNsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:48:46 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DD827330F78C1E52A52B;
        Fri, 25 Oct 2019 21:48:41 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 21:48:34 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <zhanghan23@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH] net: hisilicon: Fix "Trying to free already-free IRQ"
Date:   Fri, 25 Oct 2019 21:48:22 +0800
Message-ID: <1572011302-48605-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rmmod hip04_eth.ko, we can get the following warning:

Task track: rmmod(1623)>bash(1591)>login(1581)>init(1)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1623 at kernel/irq/manage.c:1557 __free_irq+0xa4/0x2ac()
Trying to free already-free IRQ 200
Modules linked in: ping(O) pramdisk(O) cpuinfo(O) rtos_snapshot(O) interrupt_ctrl(O) mtdblock mtd_blkdevrtfs nfs_acl nfs lockd grace sunrpc xt_tcpudp ipt_REJECT iptable_filter ip_tables x_tables nf_reject_ipv
CPU: 0 PID: 1623 Comm: rmmod Tainted: G           O    4.4.193 #1
Hardware name: Hisilicon A15
[<c020b408>] (rtos_unwind_backtrace) from [<c0206624>] (show_stack+0x10/0x14)
[<c0206624>] (show_stack) from [<c03f2be4>] (dump_stack+0xa0/0xd8)
[<c03f2be4>] (dump_stack) from [<c021a780>] (warn_slowpath_common+0x84/0xb0)
[<c021a780>] (warn_slowpath_common) from [<c021a7e8>] (warn_slowpath_fmt+0x3c/0x68)
[<c021a7e8>] (warn_slowpath_fmt) from [<c026876c>] (__free_irq+0xa4/0x2ac)
[<c026876c>] (__free_irq) from [<c0268a14>] (free_irq+0x60/0x7c)
[<c0268a14>] (free_irq) from [<c0469e80>] (release_nodes+0x1c4/0x1ec)
[<c0469e80>] (release_nodes) from [<c0466924>] (__device_release_driver+0xa8/0x104)
[<c0466924>] (__device_release_driver) from [<c0466a80>] (driver_detach+0xd0/0xf8)
[<c0466a80>] (driver_detach) from [<c0465e18>] (bus_remove_driver+0x64/0x8c)
[<c0465e18>] (bus_remove_driver) from [<c02935b0>] (SyS_delete_module+0x198/0x1e0)
[<c02935b0>] (SyS_delete_module) from [<c0202ed0>] (__sys_trace_return+0x0/0x10)
---[ end trace bb25d6123d849b44 ]---

Currently "rmmod hip04_eth.ko" call free_irq more than once
as devres_release_all and hip04_remove both call free_irq.
This results in a 'Trying to free already-free IRQ' warning.
To solve the problem free_irq has been moved out of hip04_remove.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index c841674..ad6d912 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -1038,7 +1038,6 @@ static int hip04_remove(struct platform_device *pdev)
 
 	hip04_free_ring(ndev, d);
 	unregister_netdev(ndev);
-	free_irq(ndev->irq, ndev);
 	of_node_put(priv->phy_node);
 	cancel_work_sync(&priv->tx_timeout_task);
 	free_netdev(ndev);
-- 
1.8.5.6

