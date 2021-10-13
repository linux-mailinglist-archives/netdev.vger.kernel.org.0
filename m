Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBEE42CDD5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhJMW0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:40 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:48423
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231309AbhJMW0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6bgP+x59s11Rjx++fcf4yTWTpkF772jMWzqSwSpKWehl4xl16YVFdE9nYJeYEREdd1iE2BuePYJN35W2pER+eMCRIu/fvmjCDJxh7/LCw37oQeFJfNayYLsKNTmge4iUPrOIkQqGaRqd1oqLI/6D1O1zJgk1suS7q2OHkdW1XCZmD1gVGyCpiCGacxEAlr4jDc/UbhsbhAP+Xcg/pW+1jQ9+1xG7n5k5BpAcjOlkBV7ceMGAI+fPMUDo8OWX6V6XCtYPB9mrePNgvgOr/2VLEYtLtGPsx2WlLjDCAgP1V5n1V1BpAIUKAHmgJZLadFJ2aG+Lt6UBCbr8Ykb66wNyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+ua+ROmFSdcH2R0zRmdfLGawsLv4uFJQXLHaojFAOM=;
 b=HoiQW6lRNTl9/q5slz4hpu4Xn4F6kqiFPo5ryn1sW0F9Je0YRoM/9f/P+3nWqpQi2GD5WfZ0gPJvUfKN2svRJUdjPNwgaYTY2XlMg5nNvsAK3eK0iBmawAl/+uj2oIR/4Qyx9gD9Tq1R2NaAoZoOKLhyzdUJEO1IAd1d8j+fknid5zVmpy0SOvv0yriiTWjNgHMGlZsf1wg6v0eRvmLVYVr6iwQnU2JGnXySIU8N7U/V1RwGtcyqMj2xjSHc6f/cz4Llb7f6tCFbzt3YLeQsNTjYMnlizfRZr3daPqBh+z4n2UIriQ2E/ekpLPT64JagAIHrjEG0MGS0EYZX4Jq+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+ua+ROmFSdcH2R0zRmdfLGawsLv4uFJQXLHaojFAOM=;
 b=XR0EumTerXmwbaFC2RtGRpoLrA3fElLpRhE9bPfslp2/BcvkDO7dFTQcdKcrDhYVMvpxPbMLB0yAj9HXq7zDda6d9PqcqPEwefonwMk9n0ke1/pUJOe/wv6qDsYmjfSRKSGBcsJUZUQyUE060jZRxM2aaUiS96ciPHgsn2lbRMU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6512.eurprd04.prod.outlook.com (2603:10a6:803:120::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 22:24:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 6/6] net: dsa: sja1105: parse {rx,tx}-internal-delay-ps properties for RGMII delays
Date:   Thu, 14 Oct 2021 01:23:13 +0300
Message-Id: <20211013222313.3767605-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50e0c9c2-3955-49b0-bde1-08d98e983759
X-MS-TrafficTypeDiagnostic: VE1PR04MB6512:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6512C4AF47FF2A872F817DDEE0B79@VE1PR04MB6512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5eej9RzUs7YAp5dZCcMLq3y7Us2C6EM/XwrnxgZnv31Obe1UTMLb5eEhgAh3lZesouQWJUGph0fn61YiyzgG6vnZ2wsHGSFdyzAFyWy9y3u78S7sjx2vrMD2ToOiTTTj9Gk1uCrzS4QWArnEa5XUBfVz0A6fvNT5EFpwRrdlw95y7hb9SEpXf52lOBhqifn437CisR30F6kFpnRVMsMErYm2kmrYIgEBLaOM3mVbsDe67FCvc4iutqFtME7s7SgGs++s9WoROBR7kJx+qvWk6TrnBIcZ4F3Q7Btbp4IDN03Pz2kbInoSv2ScaKFCHuTP7mV/M9/ILKassA09Fl274cCTH14D67xbRhn3ipWuuGF00+lD8EVpbJMzhEYHxUEzZ0Ep23DW7WY5JwUmicKptd+v8lATz83vg/dwbpzTYF4XrosnCYcynL4msDE1RHuqkRHDZR27rmJYBlsBWwoXwxNG1IyB0k3Wbkn7NEtkrsWbVVYj1PQ5SCZL0R55J+R6YOUg780BYLtIaIwo75/Zk1KgSWnpEW3xgfM5wRDF5FeyfK1MmTb0FSXw2totpV0+CwEnuAB0D/fGsfiM1qQQep0Qh6RohgrMBbSiAc1q6ZLdQu5Pkn/Yb/JWdLTxqxLtF2s8blyzA89xqj5GZBTVdP8UJm+NTWhhbH9oYSI4ojfQD0xNZThYb0FqUWKR4DlbFrUyXkyBnt1iKBrBWHc1ETY405zU1algtG9ymI2q8FdbGq9Tsda43JoC3budZ86RKxGMqS/4snA10Hb+YjJLwgnohRnfQNO9nH7ylrrdJAxgBi+IFkeen9dRJszDhcBcI8ueq0DzjcEDU1moOnSs3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(6512007)(5660300002)(6486002)(38100700002)(966005)(36756003)(66476007)(66556008)(508600001)(6666004)(2906002)(66946007)(316002)(44832011)(2616005)(186003)(26005)(4326008)(30864003)(7416002)(956004)(1076003)(8676002)(83380400001)(54906003)(8936002)(86362001)(110136005)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ci/NySSJgNus81XfNuGKKm474iMkfvChL5Le2v0S1H8qZlaqyfhS8qxwA777?=
 =?us-ascii?Q?5syKObie1y9uEZ+urxXib3KrEu0gfLga54+3r6NtY92xRWSb8v5Q2SgVcYV6?=
 =?us-ascii?Q?NvSmKaruXu9kqjN0VSHkrJoe41uqeeT3hEbDA5V4iPqrDOkyBRMGSt5KDrqc?=
 =?us-ascii?Q?NoLbVZV/m0ioY2O7TdX6eCXgc7B1tAgDdngnJyJJLNkIKSevorHvLxizzruI?=
 =?us-ascii?Q?f7/rUTqOb5DBk0qVcMn8kO9ie4rbYMMIB4ODPagX/WuL1n8mbORMc6yd0mFY?=
 =?us-ascii?Q?7Bn8e1IcZ9IwrQt6UDeppl2vj4hpbzYbovCQZvBMOa7U4g2wCpnQyO8hCRoG?=
 =?us-ascii?Q?h/Y9Wb82Vq+VreoDnVD0OY7aWdou3alIJNrIJQJA2y3JfOsszAUgZEILuo/+?=
 =?us-ascii?Q?JWar7YtAt6OXDkjrQsuWDCAzdhyRwbpyiChyBDhCwoR5qbYoFBe4R0YUS2z9?=
 =?us-ascii?Q?c3FwwtdDCXwoT2PQQ7Y0qNzE3J87B15e0Ryr0Bl22xmhge+Q+JD0pm/ykHfG?=
 =?us-ascii?Q?c0LNLx07UXTex0HXChZeXqxU91pamrkW/dpzl++4cSpefoN02+LxmFPMAOb8?=
 =?us-ascii?Q?aNHTmpbSom1k1RxHSX1zbhHv+EdYr148lbcuTK4rDiv6c2nA1NX5zdZUZo/v?=
 =?us-ascii?Q?rhsohXEqRYJnjbalg3ZfpnbFLDPap4En6XJ5s6UblPUtg/Kzu4etV/cZ4ahy?=
 =?us-ascii?Q?Gjzwae61oiJi9KotNd5kptx0IS7AAZM+1TXgXu9vVtMZwE7OrOX8GxKNNB7J?=
 =?us-ascii?Q?dJgO89qM5djjzA3fwebOAQFI5JJi6EhLKXZoiz425pTqDSbkEVPivJfN9I79?=
 =?us-ascii?Q?NESXrEriUt1XJtCN1zuYwCC3gidNo54LLTGlyS1xQfJJZUzNcuquAblSmlbM?=
 =?us-ascii?Q?Bh5x52O+A9zQlsQCveqNVxyc2beOW1thStZRLbD0EQl8t4U56TQOd91ey9OT?=
 =?us-ascii?Q?A5xSSj9wDkG6bzlmP3CQpbXA7emrx8KJznA9LEss/iJ/dCHzkfqTlVMp52mp?=
 =?us-ascii?Q?l8WQs1cAsV0HwBv0Z9gRXK+fLTkYpZLIOjomuR4hQN/NGp8Vq17pDZZ4Uv8T?=
 =?us-ascii?Q?Su0aGoR8CFEvODydOr1O43rPjii7ZRM86adiWRQgwcK5yhM7rE2KemnoJdnf?=
 =?us-ascii?Q?93qdTL7FyVeI8bQW/hbpfpgB9HQgIeCGYFSy7LE/Pp30N0zgO8zNum9EnNSz?=
 =?us-ascii?Q?9pcMs7VALCy1k3PHbl3zWlS1SgTot82XRYekahY0aM0S/GTnmCtZhMRh5gKB?=
 =?us-ascii?Q?jJJJRP/T2BQdr6t9IeUrwDrGz31u4EVkrmBzUzhMOcvfELAbWVxiw7VJRVPR?=
 =?us-ascii?Q?rcRUTvvNd1WeuidxlVElR66V?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e0c9c2-3955-49b0-bde1-08d98e983759
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:26.7125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYJGOEIHzkOizDtzL+bediruql6VgXJw/xZDUpx23iLG04Bw+N/nvDfVaKFEzoIr6gaqKW/Bf0fbpJCJHop3cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6512
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

