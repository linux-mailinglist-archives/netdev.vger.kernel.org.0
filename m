Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187E712AB79
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 11:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLZKAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 05:00:07 -0500
Received: from inva021.nxp.com ([92.121.34.21]:37262 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbfLZKAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 05:00:06 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E0A222014D7;
        Thu, 26 Dec 2019 11:00:03 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 089A120056C;
        Thu, 26 Dec 2019 11:00:00 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3A0DD402B3;
        Thu, 26 Dec 2019 17:59:55 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH] net: mscc: ocelot: support PPS signal generation
Date:   Thu, 26 Dec 2019 17:58:51 +0800
Message-Id: <20191226095851.24325-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to support PPS signal generation for Ocelot family
switches, including VSC9959 switch.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c  |  2 ++
 drivers/net/ethernet/mscc/ocelot.c      | 25 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_ptp.h  |  2 ++
 drivers/net/ethernet/mscc/ocelot_regs.c |  2 ++
 include/soc/mscc/ocelot.h               |  2 ++
 5 files changed, 33 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b9758b0..ee0ce7c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -287,6 +287,8 @@ static const u32 vsc9959_ptp_regmap[] = {
 	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
 	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
 	REG(PTP_CFG_MISC,                  0x0000a0),
 	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 985b46d..c0f8a9e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2147,6 +2147,29 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.adjfine	= ocelot_ptp_adjfine,
 };
 
+static void ocelot_ptp_init_pps(struct ocelot *ocelot)
+{
+	u32 val;
+
+	/* PPS signal generation uses CLOCK action. Together with SYNC option,
+	 * a single pulse will be generated after <WAFEFORM_LOW> nanoseconds
+	 * after the time of day has increased the seconds. The pulse will
+	 * get a width of <WAFEFORM_HIGH> nanoseconds.
+	 *
+	 * In default,
+	 * WAFEFORM_LOW = 0
+	 * WAFEFORM_HIGH = 1us
+	 */
+	ocelot_write_rix(ocelot, 0, PTP_PIN_WF_LOW_PERIOD, ALT_PPS_PIN);
+	ocelot_write_rix(ocelot, 1000, PTP_PIN_WF_HIGH_PERIOD, ALT_PPS_PIN);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, ALT_PPS_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= (PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK));
+
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ALT_PPS_PIN);
+}
+
 static int ocelot_init_timestamp(struct ocelot *ocelot)
 {
 	struct ptp_clock *ptp_clock;
@@ -2478,6 +2501,8 @@ int ocelot_init(struct ocelot *ocelot)
 				"Timestamp initialization failed\n");
 			return ret;
 		}
+
+		ocelot_ptp_init_pps(ocelot);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/drivers/net/ethernet/mscc/ocelot_ptp.h
index 9ede14a..21bc744 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.h
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.h
@@ -13,6 +13,8 @@
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_NSEC_RSZ		PTP_PIN_CFG_RSZ
+#define PTP_PIN_WF_HIGH_PERIOD_RSZ	PTP_PIN_CFG_RSZ
+#define PTP_PIN_WF_LOW_PERIOD_RSZ	PTP_PIN_CFG_RSZ
 
 #define PTP_PIN_CFG_DOM			BIT(0)
 #define PTP_PIN_CFG_SYNC		BIT(2)
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index b88b589..ed4dd01 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -239,6 +239,8 @@ static const u32 ocelot_ptp_regmap[] = {
 	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
 	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
 	REG(PTP_CFG_MISC,                  0x0000a0),
 	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 64cbbbe..c2ab20d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -325,6 +325,8 @@ enum ocelot_reg {
 	PTP_PIN_TOD_SEC_MSB,
 	PTP_PIN_TOD_SEC_LSB,
 	PTP_PIN_TOD_NSEC,
+	PTP_PIN_WF_HIGH_PERIOD,
+	PTP_PIN_WF_LOW_PERIOD,
 	PTP_CFG_MISC,
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
-- 
2.7.4

