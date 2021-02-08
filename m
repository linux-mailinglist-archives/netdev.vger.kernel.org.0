Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD38631314A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhBHLrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:47:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12596 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbhBHLoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:44:00 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT1JFmz165Pl;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: remove the shaper param magic number
Date:   Mon, 8 Feb 2021 19:39:34 +0800
Message-ID: <1612784382-27262-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

To make the code more readable, this patch adds a definition for
the magic number 126 used for the default shaper param ir_b, and
rename macro DIVISOR_IR_B_126.

No functional change.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 906d98e..151afd1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -41,8 +41,9 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 				  struct hclge_shaper_ir_para *ir_para,
 				  u32 max_tm_rate)
 {
+#define DEFAULT_SHAPER_IR_B	126
 #define DIVISOR_CLK		(1000 * 8)
-#define DIVISOR_IR_B_126	(126 * DIVISOR_CLK)
+#define DEFAULT_DIVISOR_IR_B	(DEFAULT_SHAPER_IR_B * DIVISOR_CLK)
 
 	static const u16 tick_array[HCLGE_SHAPER_LVL_CNT] = {
 		6 * 256,        /* Prioriy level */
@@ -69,10 +70,10 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	 * ir_calc = ---------------- * 1000
 	 *		tick * 1
 	 */
-	ir_calc = (DIVISOR_IR_B_126 + (tick >> 1) - 1) / tick;
+	ir_calc = (DEFAULT_DIVISOR_IR_B + (tick >> 1) - 1) / tick;
 
 	if (ir_calc == ir) {
-		ir_para->ir_b = 126;
+		ir_para->ir_b = DEFAULT_SHAPER_IR_B;
 		ir_para->ir_u = 0;
 		ir_para->ir_s = 0;
 
@@ -81,7 +82,8 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 		/* Increasing the denominator to select ir_s value */
 		while (ir_calc >= ir && ir) {
 			ir_s_calc++;
-			ir_calc = DIVISOR_IR_B_126 / (tick * (1 << ir_s_calc));
+			ir_calc = DEFAULT_DIVISOR_IR_B /
+				  (tick * (1 << ir_s_calc));
 		}
 
 		ir_para->ir_b = (ir * tick * (1 << ir_s_calc) +
@@ -92,12 +94,12 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 
 		while (ir_calc < ir) {
 			ir_u_calc++;
-			numerator = DIVISOR_IR_B_126 * (1 << ir_u_calc);
+			numerator = DEFAULT_DIVISOR_IR_B * (1 << ir_u_calc);
 			ir_calc = (numerator + (tick >> 1)) / tick;
 		}
 
 		if (ir_calc == ir) {
-			ir_para->ir_b = 126;
+			ir_para->ir_b = DEFAULT_SHAPER_IR_B;
 		} else {
 			u32 denominator = DIVISOR_CLK * (1 << --ir_u_calc);
 			ir_para->ir_b = (ir * tick + (denominator >> 1)) /
-- 
2.7.4

