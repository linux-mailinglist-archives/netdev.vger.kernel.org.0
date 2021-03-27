Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6334B8DA
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhC0ST7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 14:19:59 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33679 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhC0ST4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 14:19:56 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 12RIJoHp029189;
        Sat, 27 Mar 2021 11:19:51 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: avoid collecting SGE_QBASE regs during traffic
Date:   Sat, 27 Mar 2021 23:49:08 +0530
Message-Id: <1616869148-6858-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accessing SGE_QBASE_MAP[0-3] and SGE_QBASE_INDEX registers can lead
to SGE missing doorbells under heavy traffic. So, only collect them
when adapter is idle. Also update the regdump range to skip collecting
these registers.

Fixes: 80a95a80d358 ("cxgb4: collect SGE PF/VF queue map")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 23 +++++++++++++++----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  3 ++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 6c85a10f465c..23a2ebdfd503 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1794,11 +1794,25 @@ int cudbg_collect_sge_indirect(struct cudbg_init *pdbg_init,
 	struct cudbg_buffer temp_buff = { 0 };
 	struct sge_qbase_reg_field *sge_qbase;
 	struct ireg_buf *ch_sge_dbg;
+	u8 padap_running = 0;
 	int i, rc;
+	u32 size;
 
-	rc = cudbg_get_buff(pdbg_init, dbg_buff,
-			    sizeof(*ch_sge_dbg) * 2 + sizeof(*sge_qbase),
-			    &temp_buff);
+	/* Accessing SGE_QBASE_MAP[0-3] and SGE_QBASE_INDEX regs can
+	 * lead to SGE missing doorbells under heavy traffic. So, only
+	 * collect them when adapter is idle.
+	 */
+	for_each_port(padap, i) {
+		padap_running = netif_running(padap->port[i]);
+		if (padap_running)
+			break;
+	}
+
+	size = sizeof(*ch_sge_dbg) * 2;
+	if (!padap_running)
+		size += sizeof(*sge_qbase);
+
+	rc = cudbg_get_buff(pdbg_init, dbg_buff, size, &temp_buff);
 	if (rc)
 		return rc;
 
@@ -1820,7 +1834,8 @@ int cudbg_collect_sge_indirect(struct cudbg_init *pdbg_init,
 		ch_sge_dbg++;
 	}
 
-	if (CHELSIO_CHIP_VERSION(padap->params.chip) > CHELSIO_T5) {
+	if (CHELSIO_CHIP_VERSION(padap->params.chip) > CHELSIO_T5 &&
+	    !padap_running) {
 		sge_qbase = (struct sge_qbase_reg_field *)ch_sge_dbg;
 		/* 1 addr reg SGE_QBASE_INDEX and 4 data reg
 		 * SGE_QBASE_MAP[0-3]
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 98829e482bfa..80882cfc370f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2090,7 +2090,8 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x1190, 0x1194,
 		0x11a0, 0x11a4,
 		0x11b0, 0x11b4,
-		0x11fc, 0x1274,
+		0x11fc, 0x123c,
+		0x1254, 0x1274,
 		0x1280, 0x133c,
 		0x1800, 0x18fc,
 		0x3000, 0x302c,
-- 
2.27.0

