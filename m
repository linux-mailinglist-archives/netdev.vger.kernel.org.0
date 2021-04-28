Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62F036D75B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhD1MbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:31:22 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:28549
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235833AbhD1MbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 08:31:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHI+qaCrdYe3CS8Ns+8TZk+0VgCF5GSomkAT9fXaqC5VFHi2w6DzRN+8Jy+y6zuh7B5PETge7FklfLnTC7AWG813vcwOgr86csqII8t/K/u/J7mrt2Tv4I1l30YlCjetcGBcebDxtDy33IXrwlDLkF7y8hHlorgpsLiLU2m7mBkBPfnBu2c1iuy+2jy3SOMGgeUrWQVmWi0aM3Md9RG6bFKSaE/+TMFRtqV2QqpgwY4pUEOJNudgtau6V58dzDNXsk03GOgumTuvQ4OL/x2b4ExTTwLNvMUoXIbuwmN7ynSAmzuB7NWLf74st1GlxvC/NbfStTWH28tbbTkETvsHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ew2AEJ82+8zTA9+n33tf1Wq2Iml2WprBlkLPa3H//fY=;
 b=W6GT5yljUJBbDa72QwaGCrHavSkxeE0ol2JXJuwOd9rih6flpe74CNF1mlpNIzgM9hfotXTUlcy9tSpnaqszu2iTidD95dYLQyD+EBGT1b1nJB8gyfYLUXyulWV6BmFoaflmbVBbkmoSPe4gtPG8mmbdr+l0TwNyk7H1l8uY3vaUzUvwG9EcbPS3Xae3jkZclQ9hwBbwoqNNnABMsrqqR6SCp4KMbrDsj0Pj2hmOpm/CAR+v2cU/vJbaXawzNbFlyancVeAu9Y9N0Gwtr7oGiBpoK0fNTzPNTw1JPWPStetpcGzogypE6VEbIMlXVkDFaz6/2F1l1nVWBORVrwatGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ew2AEJ82+8zTA9+n33tf1Wq2Iml2WprBlkLPa3H//fY=;
 b=kOGmnCwumOuJ8+KFvunZGOobpaYsdv1+UFqurCdctxrCxzW9waIQ8YG+ZiC1P6EE6qaqhSeDHseKD3vevLR6OD2lb3/KQLVOuEo0wa6zrJPdvFg9uQMWTBCa31oNnipYqRB6sZUW7wFHekFAldkn6AL45Ae4jn4vJtd7Csj6CB0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB4512.eurprd04.prod.outlook.com (2603:10a6:803:69::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 12:30:31 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 12:30:31 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v1 2/2] phy: nxp-c45-tja11xx: add timestamping support
Date:   Wed, 28 Apr 2021 15:30:13 +0300
Message-Id: <20210428123013.127571-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0302CA0023.eurprd03.prod.outlook.com
 (2603:10a6:205:2::36) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0302CA0023.eurprd03.prod.outlook.com (2603:10a6:205:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 12:30:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbee84cc-e3a9-4e0a-9708-08d90a4169f4
X-MS-TrafficTypeDiagnostic: VI1PR04MB4512:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB451237D6E9E5B24EDEE4B1CE9F409@VI1PR04MB4512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBwA4Af340vQPC5jZzs4V6LKifvhPNdyA8FY5DIIlAgOi8S7CFmZSVUcLDWRpSEIxbfEXXJQXuvuVu6s19z1O6zzluGSkcgdItz8gD4OynzBI2Mf0EFg91xbzU+vda9RWp/I+CPX/jI8lyLqw5mLvbSdYmxnuDcX0QBcR9WGotsmu4oYw3BO8UhRLec8759rMpDyoF7l868XQ91weHoithXyBO1TRtwk2EyYzIpP60M66X+ejQlhwrvp1rT6+5PgrWPjG7/h9Z8hVc/k9ruk8VwSpDhD3zZWu1ysiDOGwIHTWBTTPt4XQt/mBVvvqUqMt2xg/BC6JFjwkqDJe9xvtBwxOB0uoxwTfouLfGekPk/Nheo/UsQiDoaZWrKEQA5E1Axia9yoG+FhhvZj/iqTKWQk3vdVuhSVd6fR17+IKJvXXDfBHYrQRxaDU+b9IkZe3FNIi6L286xF5wujfM/YdJa7IRsdDKzFbmyJH19tqNbZwL7PIctC8udXYfDRGv8jCZ7CnG3dFZD+9ZFYzJdGZ84RPnE87G00R34UofR+MMtQNlR/64X4u+J36aMzNz68QVaW4I+4mol09i+JBIJ42bk2yfUHGUxzcFN/y3ibEFMsMyUYu/V11A1LxrjOGgW/O9SOuG5djoJXY83LlGuSRjn66Vrr3pn9BtG9wzDyZheT+yG9T9QmgO+0jwpb5SUrEpkjGkoo4ej5RXrzNgIRAKyFxj3aRiJNBDHekaGhw9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(316002)(6666004)(52116002)(956004)(6512007)(26005)(2906002)(186003)(4326008)(16526019)(8936002)(2616005)(1076003)(38100700002)(8676002)(66574015)(83380400001)(5660300002)(30864003)(6506007)(66556008)(86362001)(66476007)(66946007)(6486002)(38350700002)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pWWSf1J0rX3vXqG29hHpKDc5xJNMBJvYSgF7mR20qARtACv8WgVSBDbEN118?=
 =?us-ascii?Q?COy4APvJyvcMa+uAPGpzar/oiezWlOEPspt4JIMKwqs4owLf1dJkN7WLjd7V?=
 =?us-ascii?Q?lynraP3aSCg/sOZon5UeZ01OP/Q+hJvHNI6fdWkFrKjlohvVu4D3q2PJ+7d0?=
 =?us-ascii?Q?CL+e89m1A4ZM6sYMa1t3NgnA3gJBWmACAV+PkfEz6MJN2koxZbBLsLMiwfFP?=
 =?us-ascii?Q?nOAQCsG5bTMU7Yz6lXA/mtA3CBsug/uyImTaeZOmoEZ8Fpzi7LlVNzoV8hxV?=
 =?us-ascii?Q?TD0LH8/CxbQLjC6d9/kUiePVUKfWcHZmCqwXm30cboy9/fQlTGdTD4XPJHrc?=
 =?us-ascii?Q?CLYGTmkPTo06yFEoiyh24Hx82NQNeT0VYI4NnVLHW6eH92X2psSTEEL2HojV?=
 =?us-ascii?Q?Zk97+73fF0LwfbXymI42W9O/caNUfVMEA3rs330/cIbLEJhTNhMIAPsix1C0?=
 =?us-ascii?Q?M7JONq/D/9xeGzAHkR8Rn6jbS8J2vvy2e/zDlM9pXt9kx8ZH4cDQPAO68gf+?=
 =?us-ascii?Q?n0+d5hxD7uEILuVncXDxOXm4e6oSXl7zmJYkxUsn8yEqq7/VF4YG6s2s1OrZ?=
 =?us-ascii?Q?cWLcM0B5U0q7mMxcW8ShVZ2J5/CmzY1+JUSfNBCXzypPs9Bqwz7VE8KmcR9n?=
 =?us-ascii?Q?b+aRnmIqEk9TQhcJdJwqtVIkcSMVUYJEEO+iYSnKGb1GHLPHPNEE40k2QjIn?=
 =?us-ascii?Q?PiXAiaLG1/ehGKwDVnyIHdDoJKJC1mIK0BX4UsFFPGlheNl3vMMV37QB0XMB?=
 =?us-ascii?Q?157/Qb7vrpRHkq2cqnvDphrcNOo8o7E/JJGIsn6NcwL1G6sTSF+r8VsLLk+R?=
 =?us-ascii?Q?NE6G6dgl+2H54v88HKsuMyQw2nAX9XGS5dGH8gHMjoZCiqSp6pR1tMwonXqz?=
 =?us-ascii?Q?NRpOU48ysEiQ+AhAEdjgrOAHu13shLCA4mf10F+saLywB3tRItrL8LCIugNr?=
 =?us-ascii?Q?h9NpxrQGV4Ed3Ry/7HlxS7KBOdEqNH8xJ93EOksowqtPH7QDdMD6bFCJpl32?=
 =?us-ascii?Q?+7gnWYKWpysoeWF1jn/3ylyVXrNv//3ogYEShBkW5FlcPTiwCo3Y2yL1rMeE?=
 =?us-ascii?Q?QE++xlJo/a78yP8HOXI1TmoIjwRHjADB6AdVA7wBqcBmjBvTC8YNBqOHjQbr?=
 =?us-ascii?Q?hUMZ3L2D1l0KzGKZUm0TD61in6sBi+WUGEzLCmxDvtIrMEuwiG6VoYskNwL3?=
 =?us-ascii?Q?CLlZdzV4V5G7ewDw/ETpgJSj2ur1K5o+j7S0XuYTskx+RIn/IE/E9NvU662x?=
 =?us-ascii?Q?Ox4xXJoUd9V2gNn7YmcbtJi4sC3jlfPyBtz8S9N86qHvMwASDthzwWjLNcQV?=
 =?us-ascii?Q?6NA8jjkOnlcxLL09iZFO0xx6?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbee84cc-e3a9-4e0a-9708-08d90a4169f4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:30:31.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EbNJxSgzs9BGlgTCKnuyQnEM1W7AigkyjtYYj8igOvwUjCJrtchfkL/2782zftmAMO7prvUFE7uRk2fniB+6p6+raSqTQTa/QMk1a/qn8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mii_timestamper interface and register a ptp clock.
The package timestamping can work with or without interrupts.
RX timestamps are received in the reserved field of the PTP package.
TX timestamps are read via MDIO from a set of registers.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 505 +++++++++++++++++++++++++++++-
 1 file changed, 504 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 26b9c0d7cb9d..77f739d45240 100644
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
 
@@ -91,13 +97,108 @@
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
+	/* used to read the LTC counter atomic */
+	struct mutex ltc_read_lock;
+	/* used to write the LTC counter atomic */
+	struct mutex ltc_write_lock;
+	int hwts_tx;
+	int hwts_rx;
 	u32 tx_delay;
 	u32 rx_delay;
 };
@@ -110,6 +211,353 @@ struct nxp_c45_phy_stats {
 	u16		mask;
 };
 
+static bool nxp_c45_poll_txts(struct phy_device *phydev)
+{
+	return phydev->irq <= 0;
+}
+
+static int nxp_c45_ptp_gettimex64(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	mutex_lock(&priv->ltc_read_lock);
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
+	mutex_unlock(&priv->ltc_read_lock);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_settime64(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	mutex_lock(&priv->ltc_write_lock);
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
+	mutex_unlock(&priv->ltc_write_lock);
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
+	inc = ppb >= 0 ? true : false;
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
+
+	return 0;
+}
+
+static int nxp_c45_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct timespec64 now, then;
+
+	then = ns_to_timespec64(delta);
+	nxp_c45_ptp_gettimex64(ptp, &now, NULL);
+	now = timespec64_add(now, then);
+	nxp_c45_ptp_settime64(ptp, &now);
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
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
+		      RING_DONE);
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
+	valid = !!(reg & RING_DATA_0_TS_VALID);
+	if (!valid)
+		return valid;
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
+	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
+		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
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
@@ -205,7 +653,9 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 {
+	struct nxp_c45_phy *priv = phydev->priv;
 	irqreturn_t ret = IRQ_NONE;
+	struct nxp_c45_hwts hwts;
 	int irq;
 
 	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
@@ -216,6 +666,18 @@ static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
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
 
@@ -566,20 +1028,61 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 
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
+	mutex_init(&priv->ltc_read_lock);
+	mutex_init(&priv->ltc_write_lock);
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

