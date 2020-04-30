Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906981BFB83
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgD3OAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgD3NyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD81B20873;
        Thu, 30 Apr 2020 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254858;
        bh=wwgUGUeeVHyww4aUxt7KJKda/A1Wd7zIYeOuDIpcz5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA1IJpUaIgS3cBRl+A2NsPCtgFFWmZdwlR1zVGoKLqtL5s2igTxIuaWouTcKF1ahD
         7TwTofW3+ij3PPd2MSqWP2Yy4wcjVEM6+lxZPp6xXvxPhmptDfR0vnw2WwHqJy0Mj6
         VFn5sh8JK8nq+7O7HQu2IaKm0b7o3rS4tFd6lTlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/27] cxgb4: fix large delays in PTP synchronization
Date:   Thu, 30 Apr 2020 09:53:49 -0400
Message-Id: <20200430135402.20994-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135402.20994-1-sashal@kernel.org>
References: <20200430135402.20994-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit bd019427bf3623ee3c7d2845cf921bbf4c14846c ]

Fetching PTP sync information from mailbox is slow and can take
up to 10 milliseconds. Reduce this unnecessary delay by directly
reading the information from the corresponding registers.

Fixes: 9c33e4208bce ("cxgb4: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    | 27 +++++--------------
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  3 +++
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 758f2b8363282..ff7e58a8c90fb 100644
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
index dac90837842bf..d3df6962cf433 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -1810,6 +1810,9 @@
 
 #define MAC_PORT_CFG2_A 0x818
 
+#define MAC_PORT_PTP_SUM_LO_A 0x990
+#define MAC_PORT_PTP_SUM_HI_A 0x994
+
 #define MPS_CMN_CTL_A	0x9000
 
 #define COUNTPAUSEMCRX_S    5
-- 
2.20.1

