Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A540A4327AF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhJRTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:33:17 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:13540
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233936AbhJRTdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:33:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+2j/ZjcNVaYvemBEYC6DoCkQBZPj9pMDdAN5aDSUtnfe6EzMMGny1EOfYjxHrIcZ0W1bwkbqYp39dxcF83yqz0XFkhlI5SURfCifhgMhyfLWmcQWFpnPfiPLXfimj3gWPcyjituwWqneLG+PdddFvxS5MXGTKpaAaOMf9rFDZeTKhNa/ifaRBHsgrAkgvIFhZsPoqDzeIZl0y3CYzw40qpDbfSziozgmuUNcm7dpwGcOvHfcavEN9IzPdehCAkYAzizsunQLL6H1n7jgigyrjWvC5yKtMsSOUUyZ2nULAcC4/oHnZ85srWju1RLmT00yjjcbA7G6iAJrRPh4cdg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jddruNpPloT8fhDSuLucZWNbUb3U+a4QL3JqTn1P44U=;
 b=UWX2sQS3TgIJarwz45KhYNJG5+8gJqg4aWcn0RlkekDXjV/RQlkd00V6rAMxQBIa0nx6EOCZqDk4FpfwwxfnWzh8oL8npWJagSKsY8xpsqhsNMOUm+2k2vuRoDX29IpquGJmvud4l8MRRLD1BAl0JPk89IP4Nzg2Ntx4dtE544JqBnMXLEunJblPOt8nqQbSwy4OvWx/r421vHwk5TYIUT0NUNY514OgUlN+i8AsnlqBbC1k0QB+D5CqNqq+PmuE92rPVvgkzrXdup0qfYeR5nRNEln+ayxJkpO0u7X1bgntWRRc4SOmQjSNSyO+/fVXakG0z/CW8TkEah33GuHhGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jddruNpPloT8fhDSuLucZWNbUb3U+a4QL3JqTn1P44U=;
 b=pTBxcDLLIFGNsg4fhqxv8qSq4ub697z+/4pk7iPm5XuckkffM54c4Loay8Y/rVS8f8wWOZU/Et19ZnakxKUbJxf9ak0rDXzvMGjMiuZXPXvuI6AibF9tCCsVtrVbzjgJoAquETBIsGcy30fF2z14UjtceaZRyq7fRy4aGm49tMo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 19:30:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 19:30:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 4/4] net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for RGMII delays
Date:   Mon, 18 Oct 2021 22:29:52 +0300
Message-Id: <20211018192952.2736913-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0160.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AS8PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:20b:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 19:30:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e01d2b-63d7-4513-f33f-08d9926dc07c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3711:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB371147E5DC9B8F33FDA4F30FE0BC9@VI1PR0402MB3711.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vja0qJOpruLLiVdWn6/Z0gyNBedEBT/I6RXmCCvQZ+SWAQ/Fx898SXupDEBTudmXskHrZ7cIXfckxoDyBwAtFH96WK29hkayYc12OfTOs7gerQQGvcVnnLvaX2NSKOhNsSumCnFO/7iP3f/eYdx6Mklh9uD8Y2lkQzcFEhLl9+MfToq85YYLj2/ed/nVRe1d6ae0k9NbCsf/2TYkDXONRvvfpf9B0OxVyiv+0X7kq3xzsxJPo2pgAwZGw6cEp+yKjJ2qF9enHQEXpDcIc6WuDme0tYr+wcWQlYygNUf5L2+Sv4ErycySg8GnosqFRjpmyL4L0d6/lnrxlGfCIwcgrzx5v9TTJl0lry/u41jL5gZI4bTH+w7iXONQT8hmBTQ6OpdNognlNuKOOq75zlRAeeINyjjzCrctIz6Rp9WkymJ4pCxI1JmpzZBT+CylK65vCI1PMR70O/8Hry3CNT0ICSTa+7cGqCSVU9utU9QPsZZZRgCPomLO7xYHOMTT/R4Ci8PVMBvI7Ev8ojIuDYInFO+uKLukS2O8qJa4mLZV9rhja4ZBVI4wV9OVgIET7T+eXkjTy0IrYZ2uymC2aRuEzdU8XryDYUuOx2q2fD0KFK0jFQybRZlfSLMVrfOL6M5/tV0J41dakLQijJTq2PTXzaw14HU03P1aobgbV5tjQnRGPYvrMhJieDV1EC30hHQakV5RbsaFduWjCsbcMNb7zZws+F9ep2jRHK4mwFmtVt6K9qhADIZwHk+BMUSu75Gw++rpaoTHVUwo2Om5TCG9RUWG5eh8R+5m14YkdjHz6etg1/PjjMkJ87gofEOvD51SjSQrwd247zckNt1+o/Zj4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(6506007)(26005)(66476007)(44832011)(2906002)(83380400001)(66946007)(956004)(1076003)(6512007)(8936002)(66556008)(54906003)(86362001)(30864003)(6486002)(508600001)(4326008)(2616005)(7416002)(8676002)(316002)(36756003)(6666004)(38350700002)(110136005)(38100700002)(52116002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5j6wnJajomDKXCdQ7HWzaJGYRtpSx/Pl9iQAHb6Rff+JQGEBDgbNU8XqQVV7?=
 =?us-ascii?Q?XU2B+7k6iXBUdqMEdh0Z+LtSVPXzcyHVSSq7Gdae+CK2C9w7+jGtBKQ0P6JA?=
 =?us-ascii?Q?ybGNTlIfljz/JMgOspV6T3kaNNgWgv/aZAOPkER/gQo4BavlLiu1BRT/agUP?=
 =?us-ascii?Q?kEJnMnSvu3TobOEpjdDVY8k+Pzp8tuXSaO6nVNo0QzUYXyKK6YCDJuPMvwY+?=
 =?us-ascii?Q?qkx+mHHQ+Hy64YuOKpQeGYTPu0qP05OGaVmKz0iLCyDWPsQZachdpdVV92HO?=
 =?us-ascii?Q?gMIGk0HQMsWQVPfp2Xks47NC1Jr/DmIue35DkFaDerRnxunahOxvRAZ/YeuV?=
 =?us-ascii?Q?VQcvZorQ+fdxmmkORJ1GdsicenQiiidTRTznppmS5co7Oh7Jeau53Dyu1goL?=
 =?us-ascii?Q?1uPTRYzSAgFRl4EXsK0NFo3Y3r6Qz7cIcQA6OLsqO0FhZQtalnN+9IR/hvWh?=
 =?us-ascii?Q?gNyXfd2e4/xf9qv8011qnCxBK6Veq+icPuM4RhZHftmwKr+WxzCzrsbP/NoZ?=
 =?us-ascii?Q?nJbOpxlKBXaOPc8gd07BCa0Gf1ZpDbJAh++3AEk+687tBtphhRPOOwxh5Cfe?=
 =?us-ascii?Q?V7kr04caEzDYtO2NAtjLdh1tgmq16vlISshFoGCS/GgZdL1IuWD/XTL99dPQ?=
 =?us-ascii?Q?o2gLDI7sVJ0g/KfcjcoayIWVfluhxVMEgY4gSGIB/9oSPNmu36aDlRTlQ2Yl?=
 =?us-ascii?Q?T8OnzlZRX5H7o6qJsgzOM+Tmcn0dRyXNI42jc95cp8ei8N6H/+ac4O5aOOF4?=
 =?us-ascii?Q?i0HscJv4koq/bmTEeGjjHF6Mhpqjgiq3l1sTYHPs++OWMDQmvPWlvePzKAX+?=
 =?us-ascii?Q?er1F3LGGw24/OppILT3JL4EjnhSb7gxv/CdKk9SrYpOao0ySwNn291LPpqRu?=
 =?us-ascii?Q?prdYaWWB44aNFfuZSCvSpx0PqgTkGlETcIis6bkdhkwRHe9f9hNnHCs02+Do?=
 =?us-ascii?Q?tZSSxbN0/DqiqMsoXS9OzDiQTAHO6N9HwAJ9AKVnRefKJk7pbcgkmxDG9wZY?=
 =?us-ascii?Q?UjQY39a+ipxPAtuUbUJP1AVGF74wqqIU4eFVge7GUls0cNzAlSHKPDVlCLkA?=
 =?us-ascii?Q?7KW7brByNnrK297YO+FobZ+ks/EGB9mDcnbolcn1cSjk6OLuARLPIuFwF/ru?=
 =?us-ascii?Q?NnOWJN6LcU6QayOhSEoA2OOw+PgwgGGhHXYfw2miPXos6+rQdzr+1XwI1V31?=
 =?us-ascii?Q?89gQXhO3t6qC3rLeCtjYRVfIxLrVX5FVY6wYy8mpFk/jkJdtJR/YBGx9P0P3?=
 =?us-ascii?Q?c4cT9XYIiVBaOhNRh3/yADUr8cP9sSkKPOiPaCnnVsfW9mAH5dPRhAvkWrtx?=
 =?us-ascii?Q?H08tSJsqlR6KiTVy1I2hSYyk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e01d2b-63d7-4513-f33f-08d9926dc07c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 19:30:33.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFkBQRLFg1pR1CUfyphsRxZaV5ERHq4QcJyfQyf7SYblS0S4wWo2CPNBgS6MqeeckqSkS+6cqUiaaciHDH8aYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change does not fix any functional issue or address any real life
use case that wasn't possible before. It is just a small step in the
process of standardizing the way in which Ethernet MAC drivers may apply
RGMII delays (traditionally these have been applied by PHYs, with no
clear definition of what to do in the case of a fixed-link).

The sja1105 driver used to apply MAC-level RGMII delays on the RX data
lines when in fixed-link mode and using a phy-mode of "rgmii-rxid" or
"rgmii-id" and on the TX data lines when using "rgmii-txid" or "rgmii-id".
But the standard definitions don't say anything about behaving
differently when the port is in fixed-link vs when it isn't, and the new
device tree bindings are about having a way of applying the delays in a
way that is independent of the phy-mode and of the fixed-link property.

When the {rx,tx}-internal-delay-ps properties are present, use them,
otherwise fall back to the old behavior and warn.

One other thing to note is that the SJA1105 hardware applies a delay
value in degrees rather than in picoseconds (the delay in ps changes
depending on the frequency of the RGMII clock - 125 MHz at 1G, 25 MHz at
100M, 2.5MHz at 10M). I assume that is fine, we calculate the phase
shift of the internal delay lines assuming that the device tree meant
gigabit, and we let the hardware scale those according to the link speed.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210723173108.459770-6-prasanna.vengateshan@microchip.com/
Link: https://patchwork.ozlabs.org/project/netdev/patch/20200616074955.GA9092@laureti-dev/#2461123
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h          | 25 +++++-
 drivers/net/dsa/sja1105/sja1105_clocking.c | 35 ++++----
 drivers/net/dsa/sja1105/sja1105_main.c     | 94 ++++++++++++++++------
 3 files changed, 107 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 618c8d6a8be1..808419f3b808 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -20,6 +20,27 @@
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 #define SJA1105_NUM_L2_POLICERS		SJA1110_MAX_L2_POLICING_COUNT
 
+/* Calculated assuming 1Gbps, where the clock has 125 MHz (8 ns period)
+ * To avoid floating point operations, we'll multiply the degrees by 10
+ * to get a "phase" and get 1 decimal point precision.
+ */
+#define SJA1105_RGMII_DELAY_PS_TO_PHASE(ps) \
+	(((ps) * 360) / 800)
+#define SJA1105_RGMII_DELAY_PHASE_TO_PS(phase) \
+	((800 * (phase)) / 360)
+#define SJA1105_RGMII_DELAY_PHASE_TO_HW(phase) \
+	(((phase) - 738) / 9)
+#define SJA1105_RGMII_DELAY_PS_TO_HW(ps) \
+	SJA1105_RGMII_DELAY_PHASE_TO_HW(SJA1105_RGMII_DELAY_PS_TO_PHASE(ps))
+
+/* Valid range in degrees is a value between 73.8 and 101.7
+ * in 0.9 degree increments
+ */
+#define SJA1105_RGMII_DELAY_MIN_PS \
+	SJA1105_RGMII_DELAY_PHASE_TO_PS(738)
+#define SJA1105_RGMII_DELAY_MAX_PS \
+	SJA1105_RGMII_DELAY_PHASE_TO_PS(1017)
+
 typedef enum {
 	SPI_READ = 0,
 	SPI_WRITE = 1,
@@ -222,8 +243,8 @@ struct sja1105_flow_block {
 
 struct sja1105_private {
 	struct sja1105_static_config static_config;
-	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
-	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
+	int rgmii_rx_delay_ps[SJA1105_MAX_NUM_PORTS];
+	int rgmii_tx_delay_ps[SJA1105_MAX_NUM_PORTS];
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
 	unsigned long ucast_egress_floods;
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 5bbf1707f2af..e3699f76f6d7 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -498,17 +498,6 @@ sja1110_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
 	sja1105_packing(buf, &cmd->txc_pd,          0,  0, size, op);
 }
 
-/* Valid range in degrees is an integer between 73.8 and 101.7 */
-static u64 sja1105_rgmii_delay(u64 phase)
-{
-	/* UM11040.pdf: The delay in degree phase is 73.8 + delay_tune * 0.9.
-	 * To avoid floating point operations we'll multiply by 10
-	 * and get 1 decimal point precision.
-	 */
-	phase *= 10;
-	return (phase - 738) / 9;
-}
-
 /* The RGMII delay setup procedure is 2-step and gets called upon each
  * .phylink_mac_config. Both are strategic.
  * The reason is that the RX Tunable Delay Line of the SJA1105 MAC has issues
@@ -521,13 +510,15 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
 	const struct sja1105_private *priv = ctx;
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct sja1105_cfg_pad_mii_id pad_mii_id = {0};
+	int rx_delay = priv->rgmii_rx_delay_ps[port];
+	int tx_delay = priv->rgmii_tx_delay_ps[port];
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 	int rc;
 
-	if (priv->rgmii_rx_delay[port])
-		pad_mii_id.rxc_delay = sja1105_rgmii_delay(90);
-	if (priv->rgmii_tx_delay[port])
-		pad_mii_id.txc_delay = sja1105_rgmii_delay(90);
+	if (rx_delay)
+		pad_mii_id.rxc_delay = SJA1105_RGMII_DELAY_PS_TO_HW(rx_delay);
+	if (tx_delay)
+		pad_mii_id.txc_delay = SJA1105_RGMII_DELAY_PS_TO_HW(tx_delay);
 
 	/* Stage 1: Turn the RGMII delay lines off. */
 	pad_mii_id.rxc_bypass = 1;
@@ -542,11 +533,11 @@ int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
 		return rc;
 
 	/* Stage 2: Turn the RGMII delay lines on. */
-	if (priv->rgmii_rx_delay[port]) {
+	if (rx_delay) {
 		pad_mii_id.rxc_bypass = 0;
 		pad_mii_id.rxc_pd = 0;
 	}
-	if (priv->rgmii_tx_delay[port]) {
+	if (tx_delay) {
 		pad_mii_id.txc_bypass = 0;
 		pad_mii_id.txc_pd = 0;
 	}
@@ -561,20 +552,22 @@ int sja1110_setup_rgmii_delay(const void *ctx, int port)
 	const struct sja1105_private *priv = ctx;
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct sja1105_cfg_pad_mii_id pad_mii_id = {0};
+	int rx_delay = priv->rgmii_rx_delay_ps[port];
+	int tx_delay = priv->rgmii_tx_delay_ps[port];
 	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
 
 	pad_mii_id.rxc_pd = 1;
 	pad_mii_id.txc_pd = 1;
 
-	if (priv->rgmii_rx_delay[port]) {
-		pad_mii_id.rxc_delay = sja1105_rgmii_delay(90);
+	if (rx_delay) {
+		pad_mii_id.rxc_delay = SJA1105_RGMII_DELAY_PS_TO_HW(rx_delay);
 		/* The "BYPASS" bit in SJA1110 is actually a "don't bypass" */
 		pad_mii_id.rxc_bypass = 1;
 		pad_mii_id.rxc_pd = 0;
 	}
 
-	if (priv->rgmii_tx_delay[port]) {
-		pad_mii_id.txc_delay = sja1105_rgmii_delay(90);
+	if (tx_delay) {
+		pad_mii_id.txc_delay = SJA1105_RGMII_DELAY_PS_TO_HW(tx_delay);
 		pad_mii_id.txc_bypass = 1;
 		pad_mii_id.txc_pd = 0;
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0f1bba0076a8..1832d4bd3440 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1109,27 +1109,78 @@ static int sja1105_static_config_load(struct sja1105_private *priv)
 	return sja1105_static_config_upload(priv);
 }
 
-static int sja1105_parse_rgmii_delays(struct sja1105_private *priv)
+/* This is the "new way" for a MAC driver to configure its RGMII delay lines,
+ * based on the explicit "rx-internal-delay-ps" and "tx-internal-delay-ps"
+ * properties. It has the advantage of working with fixed links and with PHYs
+ * that apply RGMII delays too, and the MAC driver needs not perform any
+ * special checks.
+ *
+ * Previously we were acting upon the "phy-mode" property when we were
+ * operating in fixed-link, basically acting as a PHY, but with a reversed
+ * interpretation: PHY_INTERFACE_MODE_RGMII_TXID means that the MAC should
+ * behave as if it is connected to a PHY which has applied RGMII delays in the
+ * TX direction. So if anything, RX delays should have been added by the MAC,
+ * but we were adding TX delays.
+ *
+ * If the "{rx,tx}-internal-delay-ps" properties are not specified, we fall
+ * back to the legacy behavior and apply delays on fixed-link ports based on
+ * the reverse interpretation of the phy-mode. This is a deviation from the
+ * expected default behavior which is to simply apply no delays. To achieve
+ * that behavior with the new bindings, it is mandatory to specify
+ * "{rx,tx}-internal-delay-ps" with a value of 0.
+ */
+static int sja1105_parse_rgmii_delays(struct sja1105_private *priv, int port,
+				      struct device_node *port_dn)
 {
-	struct dsa_switch *ds = priv->ds;
-	int port;
+	phy_interface_t phy_mode = priv->phy_mode[port];
+	struct device *dev = &priv->spidev->dev;
+	int rx_delay = -1, tx_delay = -1;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!priv->fixed_link[port])
-			continue;
+	if (!phy_interface_mode_is_rgmii(phy_mode))
+		return 0;
 
-		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_rx_delay[port] = true;
+	of_property_read_u32(port_dn, "rx-internal-delay-ps", &rx_delay);
+	of_property_read_u32(port_dn, "tx-internal-delay-ps", &tx_delay);
 
-		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_tx_delay[port] = true;
+	if (rx_delay == -1 && tx_delay == -1 && priv->fixed_link[port]) {
+		dev_warn(dev,
+			 "Port %d interpreting RGMII delay settings based on \"phy-mode\" property, "
+			 "please update device tree to specify \"rx-internal-delay-ps\" and "
+			 "\"tx-internal-delay-ps\"",
+			 port);
 
-		if ((priv->rgmii_rx_delay[port] || priv->rgmii_tx_delay[port]) &&
-		    !priv->info->setup_rgmii_delay)
-			return -EINVAL;
+		if (phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			rx_delay = 2000;
+
+		if (phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			tx_delay = 2000;
 	}
+
+	if (rx_delay < 0)
+		rx_delay = 0;
+	if (tx_delay < 0)
+		tx_delay = 0;
+
+	if ((rx_delay || tx_delay) && !priv->info->setup_rgmii_delay) {
+		dev_err(dev, "Chip cannot apply RGMII delays\n");
+		return -EINVAL;
+	}
+
+	if ((rx_delay && rx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
+	    (tx_delay && tx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
+	    (rx_delay > SJA1105_RGMII_DELAY_MAX_PS) ||
+	    (tx_delay > SJA1105_RGMII_DELAY_MAX_PS)) {
+		dev_err(dev,
+			"port %d RGMII delay values out of range, must be between %d and %d ps\n",
+			port, SJA1105_RGMII_DELAY_MIN_PS, SJA1105_RGMII_DELAY_MAX_PS);
+		return -ERANGE;
+	}
+
+	priv->rgmii_rx_delay_ps[port] = rx_delay;
+	priv->rgmii_tx_delay_ps[port] = tx_delay;
+
 	return 0;
 }
 
@@ -1180,6 +1231,10 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 		}
 
 		priv->phy_mode[index] = phy_mode;
+
+		err = sja1105_parse_rgmii_delays(priv, index, child);
+		if (err)
+			return err;
 	}
 
 	return 0;
@@ -3317,15 +3372,6 @@ static int sja1105_probe(struct spi_device *spi)
 		return rc;
 	}
 
-	/* Error out early if internal delays are required through DT
-	 * and we can't apply them.
-	 */
-	rc = sja1105_parse_rgmii_delays(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "RGMII delay not supported\n");
-		return rc;
-	}
-
 	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
 					 sizeof(struct sja1105_cbs_entry),
-- 
2.25.1

