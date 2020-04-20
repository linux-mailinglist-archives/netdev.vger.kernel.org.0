Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416DE1B063D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgDTKI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:08:27 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:3122 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDTKI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 06:08:26 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 03KA8Mlr025642;
        Mon, 20 Apr 2020 03:08:23 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, manojmalviya@chelsio.com,
        nirranjan@chelsio.com, vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net] cxgb4: fix large delays in PTP synchronization
Date:   Mon, 20 Apr 2020 15:26:54 +0530
Message-Id: <1587376614-21111-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fetching PTP sync information from mailbox is slow and can take
up to 10 milliseconds. Reduce this unnecessary delay by directly
reading the information from the corresponding registers.

Fixes: 9c33e4208bce ("cxgb4: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    | 27 +++++--------------
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  3 +++
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index af1f40cbccc8..f5bc996ac77d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -311,32 +311,17 @@ static int cxgb4_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int cxgb4_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct adapter *adapter = (struct adapter *)container_of(ptp,
-				   struct adapter, ptp_clock_info);
-	struct fw_ptp_cmd c;
+	struct adapter *adapter = container_of(ptp, struct adapter,
+					       ptp_clock_info);
 	u64 ns;
-	int err;
-
-	memset(&c, 0, sizeof(c));
-	c.op_to_portid = cpu_to_be32(FW_CMD_OP_V(FW_PTP_CMD) |
-				     FW_CMD_REQUEST_F |
-				     FW_CMD_READ_F |
-				     FW_PTP_CMD_PORTID_V(0));
-	c.retval_len16 = cpu_to_be32(FW_CMD_LEN16_V(sizeof(c) / 16));
-	c.u.ts.sc = FW_PTP_SC_GET_TIME;
 
-	err = t4_wr_mbox(adapter, adapter->mbox, &c, sizeof(c), &c);
-	if (err < 0) {
-		dev_err(adapter->pdev_dev,
-			"PTP: %s error %d\n", __func__, -err);
-		return err;
-	}
+	ns = t4_read_reg(adapter, T5_PORT_REG(0, MAC_PORT_PTP_SUM_LO_A));
+	ns |= (u64)t4_read_reg(adapter,
+			       T5_PORT_REG(0, MAC_PORT_PTP_SUM_HI_A)) << 32;
 
 	/* convert to timespec*/
-	ns = be64_to_cpu(c.u.ts.tm);
 	*ts = ns_to_timespec64(ns);
-
-	return err;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index bb20e50ddb84..4a9fcd6c226c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -1906,6 +1906,9 @@
 
 #define MAC_PORT_CFG2_A 0x818
 
+#define MAC_PORT_PTP_SUM_LO_A 0x990
+#define MAC_PORT_PTP_SUM_HI_A 0x994
+
 #define MPS_CMN_CTL_A	0x9000
 
 #define COUNTPAUSEMCRX_S    5
-- 
2.24.0

