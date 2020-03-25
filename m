Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B66B192793
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCYLxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:53:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:20526 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgCYLxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:53:13 -0400
Received: from r10.asicdesigners.com (r10.asicdesigners.com [10.192.194.10])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02PBrB1Z005183;
        Wed, 25 Mar 2020 04:53:11 -0700
From:   Rahul Kundu <rahul.kundu@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH net] cxgb4: Add support to catch bits set in INT_CAUSE5
Date:   Wed, 25 Mar 2020 04:53:09 -0700
Message-Id: <4908cdd761d1eec90abd7b6815e07be1d243e5cd.1585137120.git.rahul.kundu@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140027f4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support to catch any bits set in SGE_INT_CAUSE5 for Parity Errors.
F_ERR_T_RXCRC flag is used to ignore that particular bit as it is not considered as fatal.
So, we clear out the bit before looking for error.
This patch now read and report separately all three registers(Cause1, Cause2, Cause5).
Also, checks for errors if any.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c   | 32 +++++++++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h |  6 ++++
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 844fdcf55118..18379602a58d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -4480,7 +4480,7 @@ static void tp_intr_handler(struct adapter *adapter)
  */
 static void sge_intr_handler(struct adapter *adapter)
 {
-	u64 v;
+	u32 v = 0, perr;
 	u32 err;
 
 	static const struct intr_info sge_intr_info[] = {
@@ -4515,13 +4515,29 @@ static void sge_intr_handler(struct adapter *adapter)
 		{ 0 }
 	};
 
-	v = (u64)t4_read_reg(adapter, SGE_INT_CAUSE1_A) |
-		((u64)t4_read_reg(adapter, SGE_INT_CAUSE2_A) << 32);
-	if (v) {
-		dev_alert(adapter->pdev_dev, "SGE parity error (%#llx)\n",
-				(unsigned long long)v);
-		t4_write_reg(adapter, SGE_INT_CAUSE1_A, v);
-		t4_write_reg(adapter, SGE_INT_CAUSE2_A, v >> 32);
+	perr = t4_read_reg(adapter, SGE_INT_CAUSE1_A);
+	if (perr) {
+		v |= perr;
+		dev_alert(adapter->pdev_dev, "SGE Cause1 Parity Error %#x\n",
+			  perr);
+	}
+
+	perr = t4_read_reg(adapter, SGE_INT_CAUSE2_A);
+	if (perr) {
+		v |= perr;
+		dev_alert(adapter->pdev_dev, "SGE Cause2 Parity Error %#x\n",
+			  perr);
+	}
+
+	if (CHELSIO_CHIP_VERSION(adapter->params.chip) >= CHELSIO_T5) {
+		perr = t4_read_reg(adapter, SGE_INT_CAUSE5_A);
+		/* Parity error (CRC) for err_T_RxCRC is trivial, ignore it */
+		perr &= ~ERR_T_RXCRC_F;
+		if (perr) {
+			v |= perr;
+			dev_alert(adapter->pdev_dev,
+				  "SGE Cause5 Parity Error %#x\n", perr);
+		}
 	}
 
 	v |= t4_handle_intr_status(adapter, SGE_INT_CAUSE3_A, sge_intr_info);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index a957a6e4d4c4..bb20e50ddb84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -487,6 +487,12 @@
 #define ERROR_QID_M    0x1ffffU
 #define ERROR_QID_G(x) (((x) >> ERROR_QID_S) & ERROR_QID_M)
 
+#define SGE_INT_CAUSE5_A        0x110c
+
+#define ERR_T_RXCRC_S    31
+#define ERR_T_RXCRC_V(x) ((x) << ERR_T_RXCRC_S)
+#define ERR_T_RXCRC_F    ERR_T_RXCRC_V(1U)
+
 #define HP_INT_THRESH_S    28
 #define HP_INT_THRESH_M    0xfU
 #define HP_INT_THRESH_V(x) ((x) << HP_INT_THRESH_S)
-- 
2.23.0.256.g4c86140027f4

