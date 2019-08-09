Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428E486FAB
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405388AbfHICdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58994 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405026AbfHICdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:36 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0D919907BA47D655C575;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: fix GFP flag error in hclge_mac_update_stats()
Date:   Fri, 9 Aug 2019 10:31:07 +0800
Message-ID: <1565317878-31806-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongzhu Liu <liuzhongzhu@huawei.com>

When CONFIG_DEBUG_ATOMIC_SLEEP on, calling kzalloc with
GFP_KERNEL in hclge_mac_update_stats() will get below warning:

[   52.514677] BUG: sleeping function called from invalid context at mm/slab.h:501
[   52.522051] in_atomic(): 0, irqs_disabled(): 0, pid: 1015, name: ifconfig
[   52.528827] 2 locks held by ifconfig/1015:
[   52.532921]  #0: (____ptrval____) (&p->lock){....}, at: seq_read+0x54/0x748
[   52.539878]  #1: (____ptrval____) (rcu_read_lock){....}, at: dev_seq_start+0x0/0x140
[   52.547610] CPU: 16 PID: 1015 Comm: ifconfig Not tainted 5.3.0-rc3-00697-g20b80be #98
[   52.555408] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS V3.B050.01 08/08/2019
[   52.564242] Call trace:
[   52.566687]  dump_backtrace+0x0/0x1f8
[   52.570338]  show_stack+0x14/0x20
[   52.573646]  dump_stack+0xb4/0xec
[   52.576950]  ___might_sleep+0x178/0x198
[   52.580773]  __might_sleep+0x74/0xe0
[   52.584338]  __kmalloc+0x244/0x2d8
[   52.587744]  hclge_mac_update_stats+0xc8/0x1f8 [hclge]
[   52.592870]  hclge_update_stats+0xe0/0x170 [hclge]
[   52.597651]  hns3_nic_get_stats64+0xa0/0x458 [hns3]
[   52.602514]  dev_get_stats+0x58/0x138
[   52.606165]  dev_seq_printf_stats+0x8c/0x280
[   52.610420]  dev_seq_show+0x14/0x40
[   52.613898]  seq_read+0x574/0x748
[   52.617205]  proc_reg_read+0xb4/0x108
[   52.620857]  __vfs_read+0x54/0xa8
[   52.624162]  vfs_read+0xa0/0x190
[   52.627380]  ksys_read+0xc8/0x178
[   52.630685]  __arm64_sys_read+0x40/0x50
[   52.634509]  el0_svc_common.constprop.0+0x120/0x1e0
[   52.639369]  el0_svc_handler+0x50/0x90
[   52.643106]  el0_svc+0x8/0xc

So this patch uses GFP_ATOMIC instead of GFP_KERNEL to fix it.

Fixes: d174ea75c96a ("net: hns3: add statistics for PFC frames and MAC control frames")
Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b7399f5..c0feae3a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -364,9 +364,13 @@ static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 desc_num)
 	u16 i, k, n;
 	int ret;
 
-	desc = kcalloc(desc_num, sizeof(struct hclge_desc), GFP_KERNEL);
+	/* This may be called inside atomic sections,
+	 * so GFP_ATOMIC is more suitalbe here
+	 */
+	desc = kcalloc(desc_num, sizeof(struct hclge_desc), GFP_ATOMIC);
 	if (!desc)
 		return -ENOMEM;
+
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_STATS_MAC_ALL, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, desc_num);
 	if (ret) {
-- 
2.7.4

