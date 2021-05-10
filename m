Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6143792D2
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhEJPgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:36:12 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:37541
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234289AbhEJPgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 11:36:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uk7OrONFtVDxWN5q+RGs73nKgA4M4TKVBagjoWHv4I0NV7Tpz/6Z/i0swfel91K7j4QxbFoTY1GwYctOhHyxKXBZ5kayk5n2qcB2ONMdD0pEJgvH5tjbbM5xB9atz3vyi2F2mQJlJisTeZrRFE8XKt0mUix7//mwnXJc9umEKEY1yFRQZ67V+xQbjMfu8DuYinxSi1495zVLJQybTxzX6q9RshrDY7GKxeZd3Aaf0gd6mtmQs/0liiVygLOc0VJBlqf4NSAZciKZKquLhI7WlptFWPP29WhPcg2JjxOssAzsxii42+WjsPNxHhDZ6U95eQPdjGNgICv6TCW5bN5QQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaFEKHMha3EghgNQ2CPbO/KAOmnEIUpTK6oYb9quK1o=;
 b=ObuNZYihupaUpQzaHp8vJQSUXLNCwO4Bg7TU8Z8YVCeJYGz73TTpplBnZfa3zLjg/g3nJBQkjzYN5550GBhmrWSNUsR47JuVBHMHr4MuPaIV5fomL2GCawOWyHyFIEiW48lMtoE8kt9auBu+Buk9Wb4FoAivAyMCTeropHEkZw1sEfHFCkdcus7S1gUjkDuSEVKZZCw0DcL0je10YILUSg4H599duhjizBirrM2lnsjh8gTDJDG5B4Ckqk1CfJQO5dPYB7bEdYh+CRhXedNWn3s0VIk8mUI32QBrA+F+IVG6X1Kh/LK01fYIyc6y1bA2DUymD+L4o/oL8D8/aRE7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaFEKHMha3EghgNQ2CPbO/KAOmnEIUpTK6oYb9quK1o=;
 b=eMujM9oOiqGS0cVD4A+ISJY2bKBydpcbOOHbtWhHf+3RJO+R8zEYx/Dy436ndELRGaXDzG4b3bymfTdJSq58oQt0tNhRnMGWxVOz0rD0zWmzLqJgNBLwniEU9hRgpA5NnA5WKbQVcx4cUJ+9prACmeP+gOci9/FeZG/TJYXDyxs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0402MB3470.eurprd04.prod.outlook.com (2603:10a6:803:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Mon, 10 May
 2021 15:34:47 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68%5]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 15:34:47 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 2/2] phy: nxp-c45-tja11xx: add timestamping support
Date:   Mon, 10 May 2021 18:34:33 +0300
Message-Id: <20210510153433.224723-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:200:89::21) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0202CA0011.eurprd02.prod.outlook.com (2603:10a6:200:89::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 15:34:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9863a6c4-4e7c-4abd-d061-08d913c924cb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3470:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34701CDFDDD4AC2947C3A3769F549@VI1PR0402MB3470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBnn9ugl/Mj7tuARhuAGB2G/KVqWZRvdFpYRr+eop34OGLXBzY2vXhQnxXzF6+Js32mNV1lQzjf0bXwnKjqUAi2cC+I4xX/k43K8CEmX6oQ3ALO1Sou/KDKn9iwtDmk/Q4LvJcR4tysyAtnIosbKWDj8e3k3tejSs40u23YmyE2Xpxm3J77GM9qKB4desBQCovvvAdAJAkODToutBXQN0QbB7Qb/KglFA6zPuFg7s5Z+Ch1zd9gK1OeJurU3J+PiEBrzWukMNGHiHZjyIfhw8EdDIL+IaPtzKKpJRTinjnNtp8TBnxzluX3JoSAYpwMsB3CcfitIHFjEuLIAo0ItSnRYdxBgRq6G96twIVsoA+tS2RBLHUbEaOV9B5k6NRhpsZinFv8UEVloUfH+f2SQtaucHWg8fPfneGtu29rvFQl2tprr406vcE5VwrC6r0n28+2+0t1PP95m4mWAnwDhjzd87GWyPCTtS4aFOunh/6+p5m9XT/dJ6tl91JRuanG60IeTSzJoqkPHW3B5SqAG/NuP2MjOW8USyrS/KnQfLuCgpDHY4jqlpEs7uN30I5Ibr8nxbHDx0a5FUodF7ZAqgoK/C81KETj/0bMDXSxj4ub5EfGsjgl1O8WA4S4Ug0xTgNirqMw2COKnFrbrayVcK0wEgwdDEWyy47v2AoxOLvAgNe4RRiodWALyt3EezfUwNwLoOAx1hjJGmQIyR7gwsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(478600001)(66556008)(66946007)(86362001)(66476007)(8936002)(5660300002)(4326008)(30864003)(66574015)(6666004)(38350700002)(8676002)(1076003)(52116002)(16526019)(186003)(6512007)(6486002)(316002)(956004)(38100700002)(2906002)(6506007)(83380400001)(26005)(2616005)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Au2nfTwziO5THi8beiV36s9HcZUsDdVkARS5nwJepjiH4D2vBo0t5qRCLM3T?=
 =?us-ascii?Q?dqxXPtRrXCPjvdwlq3MvOOa3I/E2UDKLYBHLcdrXy5bpWn2XGb4GRqaoKlmn?=
 =?us-ascii?Q?PrjtYxfrsJfwqbqGAwAblJElQcvptgwP1Ip9U0xqCnVvQNS3JqPFQVff8Qt+?=
 =?us-ascii?Q?Wz8Czp1X6lAp+mZq6dCmRHgAXPeQhJZXkOBxhoW9YFf2Jj7wm0fM9wmX8FVf?=
 =?us-ascii?Q?mbAwTPj4KmC0jjP1zP/9zarMM/oeCZptVKvBLKd5EXDDLth9t/5Aon5c5rBL?=
 =?us-ascii?Q?iDjh8PIYefSPRPlgy/7vwa//TIKnjFgcvkBKFRALHW5uBeosDRGU29vX3/9f?=
 =?us-ascii?Q?F1u/5skf01qyvH2z2GPVIPyekjxnL4tYBYVrb5UmNotfE3SEYdjD9nyF2Bsm?=
 =?us-ascii?Q?3DTN/ULVBuTrzQssBcpRxA3muQZwf+wbq2/lrs6lE7UGkVyTEJotIrqI4IX3?=
 =?us-ascii?Q?PFaIM1diUwwUpvAV/cXepHGXY7j5U2NOcejTzGiqKcJ+i4UJYAAHpp2HS4oZ?=
 =?us-ascii?Q?Ls9lY4/gsPlKtEYD9/OJjMdTLuLi0He78hC/Qo4B/lAv7qjvtVto982x55W9?=
 =?us-ascii?Q?NSXQERaKs5ZckMikRpJC3ue7BIDrhkp9YSKId2x40at+L2P3ggqiSFm+ejO2?=
 =?us-ascii?Q?bb0j3/as+HNdmfGb9RehCIYsVhbSSUMauLHEkxMVkqhLrXplPPyE6Ya8tonL?=
 =?us-ascii?Q?KqPld8DprX0TLvPDjvnG6dOCrawefx8Jj34TYzo/XB+QZ1rTaoNZoL9K9QqA?=
 =?us-ascii?Q?jZhfb2tVQacyaRUYuVBjJ1D4TwJnAiSpMlFt3LinuqTt5YWlWg5C5O++kwET?=
 =?us-ascii?Q?uy8jLXd1zHiKulYeBSe//NgeRLBLxBrR0dx2QdmB/vZsIfll1rBbw1UfvHqX?=
 =?us-ascii?Q?8IGRipzXwXZSDsArkTC9z/YSQOrd2kxz3Y7uLapFLnfNAnTOLdkQrU3gTZhg?=
 =?us-ascii?Q?gTbqRbhVS/eHsieSFCTtl2FTthMPQtXi30zw5IWodnwzS+oNkp1sq88GNYyq?=
 =?us-ascii?Q?oMDuyb4KYtjV+NSn3AYeDs/N2v3iNsyJzXvF8WYXZpFMeVgrDlIcd7Jxs8s0?=
 =?us-ascii?Q?zzG6GVU53xfD78aqbe+XBBMmn0EOJlKagGXGC7RorSTZel4KtQU5sTtxU1Pw?=
 =?us-ascii?Q?C9tJSzdgVDdfE5p2FFY0a8ctVRJFsnTEBDJttb2wxTEi9AkPXZcrJdw8dshx?=
 =?us-ascii?Q?nXdCtgpgVSMLgbCb19Ay+cP3XJKgByUo1m1Shj2brc74BkFlnDJqOU0SvPZf?=
 =?us-ascii?Q?n3XDT2SEhJ/DhGAFiqMAoBLpXr8yYDEyPNMgNSHWRhBneF55tqDOlJglnyKH?=
 =?us-ascii?Q?o9Jt35QtJrbuc0MDeWlGmTyj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9863a6c4-4e7c-4abd-d061-08d913c924cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 15:34:47.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ia/fjmKgmA2hkGcI1PM3CRHp9nkbvQe0MDuhqaV0v5bkTrao9kxMhNklYrX1JJHXKAXarK/Nzp30FATZlr5VvOum9eYdkF89/pMe2IGyuDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mii_timestamper interface and register a ptp clock.
The package timestamping can work with or without interrupts.
RX timestamps are received in the reserved field of the PTP package.
TX timestamps are read via MDIO from a set of registers.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 531 +++++++++++++++++++++++++++++-
 1 file changed, 530 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 26b9c0d7cb9d..512e4cb5d2c2 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -13,6 +13,9 @@
 #include <linux/phy.h>
 #include <linux/processor.h>
 #include <linux/property.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/net_tstamp.h>
 
 #define PHY_ID_TJA_1103			0x001BB010
 
@@ -57,6 +60,9 @@
 #define VEND1_PORT_CONTROL		0x8040
 #define PORT_CONTROL_EN			BIT(14)
 
+#define VEND1_PORT_ABILITIES		0x8046
+#define PTP_ABILITY			BIT(3)
+
 #define VEND1_PORT_INFRA_CONTROL	0xAC00
 #define PORT_INFRA_CONTROL_EN		BIT(14)
 
@@ -91,13 +97,106 @@
 #define VEND1_TX_IPG_LENGTH		0xAFD1
 #define COUNTER_EN			BIT(15)
 
+#define VEND1_LTC_LOAD_CTRL		0x1105
+#define READ_LTC			BIT(2)
+#define LOAD_LTC			BIT(0)
+
+#define VEND1_LTC_WR_NSEC_0		0x1106
+#define VEND1_LTC_WR_NSEC_1		0x1107
+#define VEND1_LTC_WR_SEC_0		0x1108
+#define VEND1_LTC_WR_SEC_1		0x1109
+
+#define VEND1_LTC_RD_NSEC_0		0x110A
+#define VEND1_LTC_RD_NSEC_1		0x110B
+#define VEND1_LTC_RD_SEC_0		0x110C
+#define VEND1_LTC_RD_SEC_1		0x110D
+
+#define VEND1_RATE_ADJ_SUBNS_0		0x110F
+#define VEND1_RATE_ADJ_SUBNS_1		0x1110
+#define CLK_RATE_ADJ_LD			BIT(15)
+#define CLK_RATE_ADJ_DIR		BIT(14)
+
+#define VEND1_HW_LTC_LOCK_CTRL		0x1115
+#define HW_LTC_LOCK_EN			BIT(0)
+
+#define VEND1_PTP_IRQ_EN		0x1131
+#define VEND1_PTP_IRQ_STATUS		0x1132
+#define PTP_IRQ_EGR_TS			BIT(0)
+
+#define VEND1_RX_TS_INSRT_CTRL		0x114D
+#define RX_TS_INSRT_MODE2		0x02
+
+#define VEND1_EGR_RING_DATA_0		0x114E
+#define VEND1_EGR_RING_DATA_1_SEQ_ID	0x114F
+#define VEND1_EGR_RING_DATA_2_NSEC_15_0	0x1150
+#define VEND1_EGR_RING_DATA_3		0x1151
+#define VEND1_EGR_RING_CTRL		0x1154
+
+#define RING_DATA_0_DOMAIN_NUMBER	GENMASK(7, 0)
+#define RING_DATA_0_MSG_TYPE		GENMASK(11, 8)
+#define RING_DATA_0_SEC_4_2		GENMASK(14, 2)
+#define RING_DATA_0_TS_VALID		BIT(15)
+
+#define RING_DATA_3_NSEC_29_16		GENMASK(13, 0)
+#define RING_DATA_3_SEC_1_0		GENMASK(15, 14)
+#define RING_DATA_5_SEC_16_5		GENMASK(15, 4)
+#define RING_DONE			BIT(0)
+
+#define TS_SEC_MASK			GENMASK(1, 0)
+
+#define VEND1_PORT_FUNC_ENABLES		0x8048
+#define PTP_ENABLE			BIT(3)
+
+#define VEND1_PORT_PTP_CONTROL		0x9000
+#define PORT_PTP_CONTROL_BYPASS		BIT(11)
+
+#define VEND1_PTP_CLK_PERIOD		0x1104
+#define PTP_CLK_PERIOD_100BT1		15ULL
+
+#define VEND1_EVENT_MSG_FILT		0x1148
+#define EVENT_MSG_FILT_ALL		0x0F
+#define EVENT_MSG_FILT_NONE		0x00
+
+#define VEND1_TX_PIPE_DLY_NS		0x1149
+#define VEND1_TX_PIPEDLY_SUBNS		0x114A
+#define VEND1_RX_PIPE_DLY_NS		0x114B
+#define VEND1_RX_PIPEDLY_SUBNS		0x114C
+
 #define RGMII_PERIOD_PS			8000U
 #define PS_PER_DEGREE			div_u64(RGMII_PERIOD_PS, 360)
 #define MIN_ID_PS			1644U
 #define MAX_ID_PS			2260U
 #define DEFAULT_ID_PS			2000U
 
+#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK(31, 0) * (ppb) * \
+					PTP_CLK_PERIOD_100BT1, NSEC_PER_SEC)
+
+#define NXP_C45_SKB_CB(skb)	((struct nxp_c45_skb_cb *)(skb)->cb)
+
+struct nxp_c45_skb_cb {
+	struct ptp_header *header;
+	unsigned int type;
+};
+
+struct nxp_c45_hwts {
+	u32	nsec;
+	u32	sec;
+	u8	domain_number;
+	u16	sequence_id;
+	u8	msg_type;
+};
+
 struct nxp_c45_phy {
+	struct phy_device *phydev;
+	struct mii_timestamper mii_ts;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info caps;
+	struct sk_buff_head tx_queue;
+	struct sk_buff_head rx_queue;
+	/* used to access the PTP registers atomic */
+	struct mutex ptp_lock;
+	int hwts_tx;
+	int hwts_rx;
 	u32 tx_delay;
 	u32 rx_delay;
 };
@@ -110,6 +209,382 @@ struct nxp_c45_phy_stats {
 	u16		mask;
 };
 
+static bool nxp_c45_poll_txts(struct phy_device *phydev)
+{
+	return phydev->irq <= 0;
+}
+
+static int _nxp_c45_ptp_gettimex64(struct ptp_clock_info *ptp,
+				   struct timespec64 *ts,
+				   struct ptp_system_timestamp *sts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_LOAD_CTRL,
+		      READ_LTC);
+	ts->tv_nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_LTC_RD_NSEC_0);
+	ts->tv_nsec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				    VEND1_LTC_RD_NSEC_1) << 16;
+	ts->tv_sec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				  VEND1_LTC_RD_SEC_0);
+	ts->tv_sec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_LTC_RD_SEC_1) << 16;
+
+	return 0;
+}
+
+static int nxp_c45_ptp_gettimex64(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	mutex_lock(&priv->ptp_lock);
+	_nxp_c45_ptp_gettimex64(ptp, ts, sts);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static int _nxp_c45_ptp_settime64(struct ptp_clock_info *ptp,
+				  const struct timespec64 *ts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_NSEC_0,
+		      ts->tv_nsec);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_NSEC_1,
+		      ts->tv_nsec >> 16);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_SEC_0,
+		      ts->tv_sec);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_SEC_1,
+		      ts->tv_sec >> 16);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_LOAD_CTRL,
+		      LOAD_LTC);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_settime64(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	mutex_lock(&priv->ptp_lock);
+	_nxp_c45_ptp_settime64(ptp, ts);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+	u64 subns_inc_val;
+	bool inc;
+
+	mutex_lock(&priv->ptp_lock);
+	inc = ppb >= 0;
+	ppb = abs(ppb);
+
+	subns_inc_val = PPM_TO_SUBNS_INC(ppb);
+
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_RATE_ADJ_SUBNS_0,
+		      subns_inc_val);
+	subns_inc_val >>= 16;
+	subns_inc_val |= CLK_RATE_ADJ_LD;
+	if (inc)
+		subns_inc_val |= CLK_RATE_ADJ_DIR;
+
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_RATE_ADJ_SUBNS_1,
+		      subns_inc_val);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+	struct timespec64 now, then;
+
+	mutex_lock(&priv->ptp_lock);
+	then = ns_to_timespec64(delta);
+	_nxp_c45_ptp_gettimex64(ptp, &now, NULL);
+	now = timespec64_add(now, then);
+	_nxp_c45_ptp_settime64(ptp, &now);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static void nxp_c45_reconstruct_ts(struct timespec64 *ts,
+				   struct nxp_c45_hwts *hwts)
+{
+	ts->tv_nsec = hwts->nsec;
+	if ((ts->tv_sec & TS_SEC_MASK) < (hwts->sec & TS_SEC_MASK))
+		ts->tv_sec -= BIT(2);
+	ts->tv_sec &= ~TS_SEC_MASK;
+	ts->tv_sec |= hwts->sec & TS_SEC_MASK;
+}
+
+static bool nxp_c45_match_ts(struct ptp_header *header,
+			     struct nxp_c45_hwts *hwts,
+			     unsigned int type)
+{
+	return ntohs(header->sequence_id) == hwts->sequence_id &&
+	       ptp_get_msgtype(header, type) == hwts->msg_type &&
+	       header->domain_number  == hwts->domain_number;
+}
+
+static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
+			       struct nxp_c45_hwts *hwts)
+{
+	bool valid;
+	u16 reg;
+
+	mutex_lock(&priv->ptp_lock);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
+		      RING_DONE);
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
+	valid = !!(reg & RING_DATA_0_TS_VALID);
+	if (!valid)
+		goto nxp_c45_get_hwtxts_out;
+
+	hwts->domain_number = reg;
+	hwts->msg_type = (reg & RING_DATA_0_MSG_TYPE) >> 8;
+	hwts->sec = (reg & RING_DATA_0_SEC_4_2) >> 10;
+	hwts->sequence_id = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+					 VEND1_EGR_RING_DATA_1_SEQ_ID);
+	hwts->nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				  VEND1_EGR_RING_DATA_2_NSEC_15_0);
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_3);
+	hwts->nsec |= (reg & RING_DATA_3_NSEC_29_16) << 16;
+	hwts->sec |= (reg & RING_DATA_3_SEC_1_0) >> 14;
+
+nxp_c45_get_hwtxts_out:
+	mutex_unlock(&priv->ptp_lock);
+	return valid;
+}
+
+static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
+				 struct nxp_c45_hwts *txts)
+{
+	struct sk_buff *skb, *tmp, *skb_match = NULL;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct timespec64 ts;
+	unsigned long flags;
+	bool ts_match;
+	s64 ts_ns;
+
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	skb_queue_walk_safe(&priv->tx_queue, skb, tmp) {
+		ts_match = nxp_c45_match_ts(NXP_C45_SKB_CB(skb)->header, txts,
+					    NXP_C45_SKB_CB(skb)->type);
+		if (!ts_match)
+			continue;
+		skb_match = skb;
+		__skb_unlink(skb, &priv->tx_queue);
+		break;
+	}
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
+	if (skb_match) {
+		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
+		nxp_c45_reconstruct_ts(&ts, txts);
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		ts_ns = timespec64_to_ns(&ts);
+		shhwtstamps.hwtstamp = ns_to_ktime(ts_ns);
+		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
+	} else {
+		phydev_warn(priv->phydev,
+			    "the tx timestamp doesn't match with any skb\n");
+	}
+}
+
+static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
+	struct skb_shared_hwtstamps *shhwtstamps_rx;
+	struct nxp_c45_hwts hwts;
+	bool reschedule = false;
+	struct timespec64 ts;
+	struct sk_buff *skb;
+	bool txts_valid;
+	u32 ts_raw;
+
+	while (!skb_queue_empty_lockless(&priv->tx_queue) && poll_txts) {
+		txts_valid = nxp_c45_get_hwtxts(priv, &hwts);
+		if (unlikely(!txts_valid)) {
+			/* Still more skbs in the queue */
+			reschedule = true;
+			break;
+		}
+
+		nxp_c45_process_txts(priv, &hwts);
+	}
+
+	nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
+	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
+		ts_raw = __be32_to_cpu(NXP_C45_SKB_CB(skb)->header->reserved2);
+		hwts.sec = ts_raw >> 30;
+		hwts.nsec = ts_raw & GENMASK(29, 0);
+		nxp_c45_reconstruct_ts(&ts, &hwts);
+		shhwtstamps_rx = skb_hwtstamps(skb);
+		shhwtstamps_rx->hwtstamp = ns_to_ktime(timespec64_to_ns(&ts));
+		NXP_C45_SKB_CB(skb)->header->reserved2 = 0;
+		netif_rx_ni(skb);
+	}
+
+	return reschedule ? 1 : -1;
+}
+
+static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
+{
+	priv->caps = (struct ptp_clock_info) {
+		.owner		= THIS_MODULE,
+		.name		= "NXP C45 PHC",
+		.max_adj	= 16666666,
+		.adjfine	= nxp_c45_ptp_adjfine,
+		.adjtime	= nxp_c45_ptp_adjtime,
+		.gettimex64	= nxp_c45_ptp_gettimex64,
+		.settime64	= nxp_c45_ptp_settime64,
+		.do_aux_work	= nxp_c45_do_aux_work,
+	};
+
+	priv->ptp_clock = ptp_clock_register(&priv->caps,
+					     &priv->phydev->mdio.dev);
+
+	if (IS_ERR(priv->ptp_clock))
+		return PTR_ERR(priv->ptp_clock);
+
+	if (!priv->ptp_clock)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void nxp_c45_txtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct nxp_c45_phy *priv = container_of(mii_ts, struct nxp_c45_phy,
+						mii_ts);
+
+	switch (priv->hwts_tx) {
+	case HWTSTAMP_TX_ON:
+		NXP_C45_SKB_CB(skb)->type = type;
+		NXP_C45_SKB_CB(skb)->header = ptp_parse_header(skb, type);
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		skb_queue_tail(&priv->tx_queue, skb);
+		if (nxp_c45_poll_txts(priv->phydev))
+			ptp_schedule_worker(priv->ptp_clock, 0);
+		break;
+	case HWTSTAMP_TX_OFF:
+	default:
+		kfree_skb(skb);
+		break;
+	}
+}
+
+static bool nxp_c45_rxtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct nxp_c45_phy *priv = container_of(mii_ts, struct nxp_c45_phy,
+						mii_ts);
+	struct ptp_header *header = ptp_parse_header(skb, type);
+
+	if (!header)
+		return false;
+
+	if (!priv->hwts_rx)
+		return false;
+
+	NXP_C45_SKB_CB(skb)->header = header;
+	skb_queue_tail(&priv->rx_queue, skb);
+	ptp_schedule_worker(priv->ptp_clock, 0);
+
+	return true;
+}
+
+static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
+			    struct ifreq *ifreq)
+{
+	struct nxp_c45_phy *priv = container_of(mii_ts, struct nxp_c45_phy,
+						mii_ts);
+	struct phy_device *phydev = priv->phydev;
+	struct hwtstamp_config cfg;
+
+	if (copy_from_user(&cfg, ifreq->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.tx_type < 0 || cfg.tx_type > HWTSTAMP_TX_ON)
+		return -ERANGE;
+
+	priv->hwts_tx = cfg.tx_type;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		priv->hwts_rx = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		priv->hwts_rx = 1;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (priv->hwts_rx || priv->hwts_tx) {
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
+			      EVENT_MSG_FILT_ALL);
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PORT_PTP_CONTROL,
+				   PORT_PTP_CONTROL_BYPASS);
+	} else {
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
+			      EVENT_MSG_FILT_NONE);
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_PTP_CONTROL,
+				 PORT_PTP_CONTROL_BYPASS);
+	}
+
+	if (nxp_c45_poll_txts(priv->phydev))
+		goto nxp_c45_no_ptp_irq;
+
+	if (priv->hwts_tx)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
+	else
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
+
+nxp_c45_no_ptp_irq:
+	return copy_to_user(ifreq->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int nxp_c45_ts_info(struct mii_timestamper *mii_ts,
+			   struct ethtool_ts_info *ts_info)
+{
+	struct nxp_c45_phy *priv = container_of(mii_ts, struct nxp_c45_phy,
+						mii_ts);
+
+	ts_info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_RX_HARDWARE |
+			SOF_TIMESTAMPING_RAW_HARDWARE;
+	ts_info->phc_index = ptp_clock_index(priv->ptp_clock);
+	ts_info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
+	ts_info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+			(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
+			(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
+
+	return 0;
+}
+
 static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
 	{ "phy_symbol_error_cnt", MDIO_MMD_VEND1,
 		VEND1_SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
@@ -205,7 +680,9 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 {
+	struct nxp_c45_phy *priv = phydev->priv;
 	irqreturn_t ret = IRQ_NONE;
+	struct nxp_c45_hwts hwts;
 	int irq;
 
 	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
@@ -216,6 +693,18 @@ static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 		ret = IRQ_HANDLED;
 	}
 
+	/* There is no need for ACK.
+	 * The irq signal will be asserted until the EGR TS FIFO will be
+	 * emptied.
+	 */
+	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_IRQ_STATUS);
+	if (irq & PTP_IRQ_EGR_TS) {
+		while (nxp_c45_get_hwtxts(priv, &hwts))
+			nxp_c45_process_txts(priv, &hwts);
+
+		ret = IRQ_HANDLED;
+	}
+
 	return ret;
 }
 
@@ -566,20 +1055,60 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 
 	phydev->autoneg = AUTONEG_DISABLE;
 
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CLK_PERIOD,
+		      PTP_CLK_PERIOD_100BT1);
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_HW_LTC_LOCK_CTRL,
+			   HW_LTC_LOCK_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_RX_TS_INSRT_CTRL,
+		      RX_TS_INSRT_MODE2);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_FUNC_ENABLES,
+			 PTP_ENABLE);
+
 	return nxp_c45_start_op(phydev);
 }
 
 static int nxp_c45_probe(struct phy_device *phydev)
 {
 	struct nxp_c45_phy *priv;
+	int ptp_ability;
+	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	skb_queue_head_init(&priv->tx_queue);
+	skb_queue_head_init(&priv->rx_queue);
+
+	priv->phydev = phydev;
+
 	phydev->priv = priv;
 
-	return 0;
+	mutex_init(&priv->ptp_lock);
+
+	ptp_ability = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PORT_ABILITIES);
+	ptp_ability = !!(ptp_ability & PTP_ABILITY);
+	if (!ptp_ability) {
+		phydev_info(phydev, "the phy does not support PTP");
+		goto no_ptp_support;
+	}
+
+	if (IS_ENABLED(CONFIG_PTP_1588_CLOCK) &&
+	    IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING)) {
+		priv->mii_ts.rxtstamp = nxp_c45_rxtstamp;
+		priv->mii_ts.txtstamp = nxp_c45_txtstamp;
+		priv->mii_ts.hwtstamp = nxp_c45_hwtstamp;
+		priv->mii_ts.ts_info = nxp_c45_ts_info;
+		phydev->mii_ts = &priv->mii_ts;
+		ret = nxp_c45_init_ptp_clock(priv);
+	} else {
+		phydev_dbg(phydev, "PTP support not enabled even if the phy supports it");
+	}
+
+no_ptp_support:
+
+	return ret;
 }
 
 static struct phy_driver nxp_c45_driver[] = {
-- 
2.31.1

