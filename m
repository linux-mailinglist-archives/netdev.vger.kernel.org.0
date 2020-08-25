Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4CB251044
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgHYD4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:56:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:58503 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgHYD4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 23:56:41 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07P3uYWS017734;
        Mon, 24 Aug 2020 20:56:35 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, dt@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH net-next] cxgb4: add error handlers to LE intr_handler
Date:   Tue, 25 Aug 2020 09:25:46 +0530
Message-Id: <20200825035546.18330-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb4 does not look for HASHTBLMEMCRCERR and CMDTIDERR
bits in LE_DB_INT_CAUSE register, but these are enabled
in LE_DB_INT_ENABLE. So, add error handlers to LE
interrupt handler to emit a warning or alert message
for hash table mem crc and cmd tid errors

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c   | 2 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 8a56491bb034..e49370f9d59b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -4745,9 +4745,11 @@ static void le_intr_handler(struct adapter *adap)
 	static struct intr_info t6_le_intr_info[] = {
 		{ T6_LIPMISS_F, "LE LIP miss", -1, 0 },
 		{ T6_LIP0_F, "LE 0 LIP error", -1, 0 },
+		{ CMDTIDERR_F, "LE cmd tid error", -1, 1 },
 		{ TCAMINTPERR_F, "LE parity error", -1, 1 },
 		{ T6_UNKNOWNCMD_F, "LE unknown command", -1, 1 },
 		{ SSRAMINTPERR_F, "LE request queue parity error", -1, 1 },
+		{ HASHTBLMEMCRCERR_F, "LE hash table mem crc error", -1, 0 },
 		{ 0 }
 	};
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index 065c01c654ff..b11a172b5174 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -3017,6 +3017,14 @@
 #define REV_V(x) ((x) << REV_S)
 #define REV_G(x) (((x) >> REV_S) & REV_M)
 
+#define HASHTBLMEMCRCERR_S    27
+#define HASHTBLMEMCRCERR_V(x) ((x) << HASHTBLMEMCRCERR_S)
+#define HASHTBLMEMCRCERR_F    HASHTBLMEMCRCERR_V(1U)
+
+#define CMDTIDERR_S    22
+#define CMDTIDERR_V(x) ((x) << CMDTIDERR_S)
+#define CMDTIDERR_F    CMDTIDERR_V(1U)
+
 #define T6_UNKNOWNCMD_S    3
 #define T6_UNKNOWNCMD_V(x) ((x) << T6_UNKNOWNCMD_S)
 #define T6_UNKNOWNCMD_F    T6_UNKNOWNCMD_V(1U)
-- 
2.9.5

