Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C24A3D7823
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhG0OHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:07:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16008 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbhG0OH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:07:27 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GYz6j4WYVzZtQW;
        Tue, 27 Jul 2021 22:03:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 22:07:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 27 Jul 2021 22:07:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <richardcochran@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net] net: hns3: change the method of obtaining default ptp cycle
Date:   Tue, 27 Jul 2021 22:03:50 +0800
Message-ID: <1627394630-33067-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The ptp cycle is related to the hardware, so it may cause compatibility
issues if a fixed value is used in driver. Therefore, the method of
obtaining this value is changed to read from the register rather than
use a fixed value in driver.

Fixes: 0bf5eb788512 ("net: hns3: add support for PTP")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 36 +++++++++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h | 10 ++++--
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index 3b1f84502e36..befa9bcc2f2f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -5,9 +5,27 @@
 #include "hclge_main.h"
 #include "hnae3.h"
 
+static int hclge_ptp_get_cycle(struct hclge_dev *hdev)
+{
+	struct hclge_ptp *ptp = hdev->ptp;
+
+	ptp->cycle.quo = readl(hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG) &
+			 HCLGE_PTP_CYCLE_QUO_MASK;
+	ptp->cycle.numer = readl(hdev->ptp->io_base + HCLGE_PTP_CYCLE_NUM_REG);
+	ptp->cycle.den = readl(hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
+
+	if (ptp->cycle.den == 0) {
+		dev_err(&hdev->pdev->dev, "invalid ptp cycle denominator!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 {
 	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
+	struct hclge_ptp_cycle *cycle = &hdev->ptp->cycle;
 	u64 adj_val, adj_base, diff;
 	unsigned long flags;
 	bool is_neg = false;
@@ -18,7 +36,7 @@ static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 		is_neg = true;
 	}
 
-	adj_base = HCLGE_PTP_CYCLE_ADJ_BASE * HCLGE_PTP_CYCLE_ADJ_UNIT;
+	adj_base = (u64)cycle->quo * (u64)cycle->den + (u64)cycle->numer;
 	adj_val = adj_base * ppb;
 	diff = div_u64(adj_val, 1000000000ULL);
 
@@ -29,16 +47,16 @@ static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 	/* This clock cycle is defined by three part: quotient, numerator
 	 * and denominator. For example, 2.5ns, the quotient is 2,
-	 * denominator is fixed to HCLGE_PTP_CYCLE_ADJ_UNIT, and numerator
-	 * is 0.5 * HCLGE_PTP_CYCLE_ADJ_UNIT.
+	 * denominator is fixed to ptp->cycle.den, and numerator
+	 * is 0.5 * ptp->cycle.den.
 	 */
-	quo = div_u64_rem(adj_val, HCLGE_PTP_CYCLE_ADJ_UNIT, &numerator);
+	quo = div_u64_rem(adj_val, cycle->den, &numerator);
 
 	spin_lock_irqsave(&hdev->ptp->lock, flags);
-	writel(quo, hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG);
+	writel(quo & HCLGE_PTP_CYCLE_QUO_MASK,
+	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG);
 	writel(numerator, hdev->ptp->io_base + HCLGE_PTP_CYCLE_NUM_REG);
-	writel(HCLGE_PTP_CYCLE_ADJ_UNIT,
-	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
+	writel(cycle->den, hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
 	writel(HCLGE_PTP_CYCLE_ADJ_EN,
 	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_CFG_REG);
 	spin_unlock_irqrestore(&hdev->ptp->lock, flags);
@@ -475,6 +493,10 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 		ret = hclge_ptp_create_clock(hdev);
 		if (ret)
 			return ret;
+
+		ret = hclge_ptp_get_cycle(hdev);
+		if (ret)
+			return ret;
 	}
 
 	ret = hclge_ptp_int_en(hdev, true);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
index 5a202b775471..dbf5f4c08019 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -29,6 +29,7 @@
 #define HCLGE_PTP_TIME_ADJ_REG		0x60
 #define HCLGE_PTP_TIME_ADJ_EN		BIT(0)
 #define HCLGE_PTP_CYCLE_QUO_REG		0x64
+#define HCLGE_PTP_CYCLE_QUO_MASK	GENMASK(7, 0)
 #define HCLGE_PTP_CYCLE_DEN_REG		0x68
 #define HCLGE_PTP_CYCLE_NUM_REG		0x6C
 #define HCLGE_PTP_CYCLE_CFG_REG		0x70
@@ -37,9 +38,7 @@
 #define HCLGE_PTP_CUR_TIME_SEC_L_REG	0x78
 #define HCLGE_PTP_CUR_TIME_NSEC_REG	0x7C
 
-#define HCLGE_PTP_CYCLE_ADJ_BASE	2
 #define HCLGE_PTP_CYCLE_ADJ_MAX		500000000
-#define HCLGE_PTP_CYCLE_ADJ_UNIT	100000000
 #define HCLGE_PTP_SEC_H_OFFSET		32u
 #define HCLGE_PTP_SEC_L_MASK		GENMASK(31, 0)
 
@@ -47,6 +46,12 @@
 #define HCLGE_PTP_FLAG_TX_EN		1
 #define HCLGE_PTP_FLAG_RX_EN		2
 
+struct hclge_ptp_cycle {
+	u32 quo;
+	u32 numer;
+	u32 den;
+};
+
 struct hclge_ptp {
 	struct hclge_dev *hdev;
 	struct ptp_clock *clock;
@@ -58,6 +63,7 @@ struct hclge_ptp {
 	spinlock_t lock;	/* protects ptp registers */
 	u32 ptp_cfg;
 	u32 last_tx_seqid;
+	struct hclge_ptp_cycle cycle;
 	unsigned long tx_start;
 	unsigned long tx_cnt;
 	unsigned long tx_skipped;
-- 
2.8.1

