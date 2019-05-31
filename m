Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A410630ADF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfEaI5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:57:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfEaI4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:40 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EC83452D0450DE7395E;
        Fri, 31 May 2019 16:56:37 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: add handling of two bits in MAC tunnel interrupts
Date:   Fri, 31 May 2019 16:54:53 +0800
Message-ID: <1559292898-64090-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

LINK_UP and LINK_DOWN are two bits of MAC tunnel interrupts, but previous
HNS3 driver didn't handle them. If they were enabled, value of these two
bits will change during link down and link up, which will cause HNS3
driver keep receiving IRQ but can't handle them.

This patch adds handling of these two bits of interrupts, we will record
and clear them as what we do to other MAC tunnel interrupts.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index ed1f533..e1007d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1053,7 +1053,7 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 
 	while (kfifo_get(&hdev->mac_tnl_log, &stats)) {
 		rem_nsec = do_div(stats.time, HCLGE_BILLION_NANO_SECONDS);
-		dev_info(&hdev->pdev->dev, "[%07lu.%03lu]status = 0x%x\n",
+		dev_info(&hdev->pdev->dev, "[%07lu.%03lu] status = 0x%x\n",
 			 (unsigned long)stats.time, rem_nsec / 1000,
 			 stats.status);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 9645590..c56b11e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -47,9 +47,9 @@
 #define HCLGE_NCSI_ERR_INT_TYPE	0x9
 #define HCLGE_MAC_COMMON_ERR_INT_EN		0x107FF
 #define HCLGE_MAC_COMMON_ERR_INT_EN_MASK	0x107FF
-#define HCLGE_MAC_TNL_INT_EN			GENMASK(7, 0)
-#define HCLGE_MAC_TNL_INT_EN_MASK		GENMASK(7, 0)
-#define HCLGE_MAC_TNL_INT_CLR			GENMASK(7, 0)
+#define HCLGE_MAC_TNL_INT_EN			GENMASK(9, 0)
+#define HCLGE_MAC_TNL_INT_EN_MASK		GENMASK(9, 0)
+#define HCLGE_MAC_TNL_INT_CLR			GENMASK(9, 0)
 #define HCLGE_PPU_MPF_ABNORMAL_INT0_EN		GENMASK(31, 0)
 #define HCLGE_PPU_MPF_ABNORMAL_INT0_EN_MASK	GENMASK(31, 0)
 #define HCLGE_PPU_MPF_ABNORMAL_INT1_EN		GENMASK(31, 0)
-- 
2.7.4

