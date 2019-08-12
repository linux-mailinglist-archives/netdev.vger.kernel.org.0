Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5B8A17B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfHLOrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:47:55 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:52167 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfHLOrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 10:47:52 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 49A8CFF80D;
        Mon, 12 Aug 2019 14:47:50 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, andrew@lunn.ch
Subject: [PATCH net-next v6 3/6] net: mscc: describe the PTP register range
Date:   Mon, 12 Aug 2019 16:45:34 +0200
Message-Id: <20190812144537.14497-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812144537.14497-1-antoine.tenart@bootlin.com>
References: <20190812144537.14497-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for using the PTP register range, and adds a
description of its registers. This bank is used when configuring PTP.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/mscc/ocelot.h       |  9 ++++++
 drivers/net/ethernet/mscc/ocelot_board.c | 10 +++++-
 drivers/net/ethernet/mscc/ocelot_ptp.h   | 41 ++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_regs.c  | 11 +++++++
 4 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_ptp.h

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index f7eeb4806897..e0da8b4eddf2 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -23,6 +23,7 @@
 #include "ocelot_sys.h"
 #include "ocelot_qs.h"
 #include "ocelot_tc.h"
+#include "ocelot_ptp.h"
 
 #define PGID_AGGR    64
 #define PGID_SRC     80
@@ -71,6 +72,7 @@ enum ocelot_target {
 	SYS,
 	S2,
 	HSIO,
+	PTP,
 	TARGET_MAX,
 };
 
@@ -343,6 +345,13 @@ enum ocelot_reg {
 	S2_CACHE_ACTION_DAT,
 	S2_CACHE_CNT_DAT,
 	S2_CACHE_TG_DAT,
+	PTP_PIN_CFG = PTP << TARGET_OFFSET,
+	PTP_PIN_TOD_SEC_MSB,
+	PTP_PIN_TOD_SEC_LSB,
+	PTP_PIN_TOD_NSEC,
+	PTP_CFG_MISC,
+	PTP_CLK_CFG_ADJ_CFG,
+	PTP_CLK_CFG_ADJ_FREQ,
 };
 
 enum ocelot_regfield {
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2451d4a96490..990027f04d1b 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -182,6 +182,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	struct {
 		enum ocelot_target id;
 		char *name;
+		u8 optional:1;
 	} res[] = {
 		{ SYS, "sys" },
 		{ REW, "rew" },
@@ -189,6 +190,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ ANA, "ana" },
 		{ QS, "qs" },
 		{ S2, "s2" },
+		{ PTP, "ptp", 1 },
 	};
 
 	if (!np && !pdev->dev.platform_data)
@@ -205,8 +207,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		struct regmap *target;
 
 		target = ocelot_io_platform_init(ocelot, pdev, res[i].name);
-		if (IS_ERR(target))
+		if (IS_ERR(target)) {
+			if (res[i].optional) {
+				ocelot->targets[res[i].id] = NULL;
+				continue;
+			}
+
 			return PTR_ERR(target);
+		}
 
 		ocelot->targets[res[i].id] = target;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/drivers/net/ethernet/mscc/ocelot_ptp.h
new file mode 100644
index 000000000000..9ede14a12573
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * License: Dual MIT/GPL
+ * Copyright (c) 2017 Microsemi Corporation
+ */
+
+#ifndef _MSCC_OCELOT_PTP_H_
+#define _MSCC_OCELOT_PTP_H_
+
+#define PTP_PIN_CFG_RSZ			0x20
+#define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
+#define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
+#define PTP_PIN_TOD_NSEC_RSZ		PTP_PIN_CFG_RSZ
+
+#define PTP_PIN_CFG_DOM			BIT(0)
+#define PTP_PIN_CFG_SYNC		BIT(2)
+#define PTP_PIN_CFG_ACTION(x)		((x) << 3)
+#define PTP_PIN_CFG_ACTION_MASK		PTP_PIN_CFG_ACTION(0x7)
+
+enum {
+	PTP_PIN_ACTION_IDLE = 0,
+	PTP_PIN_ACTION_LOAD,
+	PTP_PIN_ACTION_SAVE,
+	PTP_PIN_ACTION_CLOCK,
+	PTP_PIN_ACTION_DELTA,
+	PTP_PIN_ACTION_NOSYNC,
+	PTP_PIN_ACTION_SYNC,
+};
+
+#define PTP_CFG_MISC_PTP_EN		BIT(2)
+
+#define PSEC_PER_SEC			1000000000000LL
+
+#define PTP_CFG_CLK_ADJ_CFG_ENA		BIT(0)
+#define PTP_CFG_CLK_ADJ_CFG_DIR		BIT(1)
+
+#define PTP_CFG_CLK_ADJ_FREQ_NS		BIT(30)
+
+#endif
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 6c387f994ec5..e59977d20400 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -234,6 +234,16 @@ static const u32 ocelot_s2_regmap[] = {
 	REG(S2_CACHE_TG_DAT,               0x000388),
 };
 
+static const u32 ocelot_ptp_regmap[] = {
+	REG(PTP_PIN_CFG,                   0x000000),
+	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
+	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
+	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_CFG_MISC,                  0x0000a0),
+	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
+	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
+};
+
 static const u32 *ocelot_regmap[] = {
 	[ANA] = ocelot_ana_regmap,
 	[QS] = ocelot_qs_regmap,
@@ -241,6 +251,7 @@ static const u32 *ocelot_regmap[] = {
 	[REW] = ocelot_rew_regmap,
 	[SYS] = ocelot_sys_regmap,
 	[S2] = ocelot_s2_regmap,
+	[PTP] = ocelot_ptp_regmap,
 };
 
 static const struct reg_field ocelot_regfields[] = {
-- 
2.21.0

