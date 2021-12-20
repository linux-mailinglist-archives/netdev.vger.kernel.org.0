Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1247A937
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhLTMJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:09:15 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:43712
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231147AbhLTMJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 07:09:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbdpV1RIvgjYAM3iDev5O342lK3BG82aKDbwVTT97S/WT4TGoZrdFVk88tQ+dzgWoo1RTAIGFChZMfOChDw0G8u8quKmAVhT8L2Tg2GcYbFknkcwggunmgmt/9W2ZzJR79TtDxP5XH9UtcT3GV3hJD4a/FMukWx+AJM7zWbyNUVBAuYYQzWsX8O9v2Mlbiu2d/KIjPSnSX2r3KiHXVVa4NvaC2SVDxUqESMOXRcnryzizTfhR+I5k9zY18G54WbMpc4rJN8RMpT1hJdLUvJ3rpkE2xGT+InPo4fQVXeBYurgTi8WtybolpUc7gMVT39G6XqH2QhGL28wgk6nSDUm4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ot2gaRjZmnkVPsq30NzAzy29WaBGf8Z8A/GwMKhXOcs=;
 b=fOO+8NDOXwByam3WQEZIDAIfW1eTAZEaHXaF0sITcx7wyiBucq56PDYBG+xjUokVF7+0rtX+EN8OebIFv1+uNNCkds9gyiIs9R6gasmg4JmG8UWjXWc6g3OjgpOukefVFKqWllybxxFKpv9v8HCQaBi8ketWPZQEey9GFuhQEqmUyZjBVmFROkQMgDFOL7HfHfHy0IoePQ8DeC47fvNiUvQ84b2zjZtA+xyZWKQy4GeOYNEXnmKYB0U+DUE5CXE85KiuFzXwEX9bVGu4cash6WrTrXRseYSPRfPIXOc3bXutNWXEexKxJqEmyCiF3k/0JqM5A3OqvlZuqxYRan6kCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ot2gaRjZmnkVPsq30NzAzy29WaBGf8Z8A/GwMKhXOcs=;
 b=Y5rDxDPnrAsV5RB1SP5/hFddHO+zvZ9D9AfwPMqzwVCltzA/Itn8/Dhmh8wTJK+AtRXPdcJBE3Un73RrTlMO9Zf5BXmy1K7Nuk+9VWaTo1fg2aJCUgbzLutqvICur9w2fM+7jxjnwWHAF7YrKyzzP0JZZTO1x16W438luPbImqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8825.eurprd04.prod.outlook.com (2603:10a6:20b:408::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 12:09:09 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 12:09:09 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH 2/3] phy: nxp-c45-tja11xx: add extts and perout support
Date:   Mon, 20 Dec 2021 14:08:58 +0200
Message-Id: <20211220120859.140453-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
References: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::37) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1a66a97-b55a-4f24-1573-08d9c3b18715
X-MS-TrafficTypeDiagnostic: AM9PR04MB8825:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB88253FAC5BDCB863DAC82D3C9F7B9@AM9PR04MB8825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8Ezw7dO+tzXb6tZ2FgvT4jcP/Xzx/c64KTsj8x1oQxcCDZh+5xt1SDcwWjPl6WFyZOv5+Pfw4bdRDxlQ6m1w9JpmNY0YCmW4onVRzxjMZDvwXec6w54XXjk9mebHEBCtZhU96xaN3Q0hv2kBKr6aafCcf8PQuy5ZU5Ta0Iiv1OcV5CAsCE+FcUjiy6yXZ82DMGp7qxwL+fteEDvjma6GZ75kMRyrc2U9Z3F1HCPiUgl/x1U5oD+4UU7QYWtCheSfazCDBFDL1o9+VcoJs2ZxHdFe6uZqyWd2tTmtvWSglXg+UaGKLXjy7oE+F6HbrenB3jJHaoBJWYNPvciNxURxwPDYPmGDj4C9o5f/GCOKe8CCpHLoQBFzjPZmjpEj6n6OWZ3nZce2xRKLjFr2zfphWVYbRc+PYx8rr27r3CZtUMTxJJgSYNEb7DvNrUbht4MmQtYetmqFwS8h02+knkKxTREIpt7B2M142hOAMZZKxMYUKgahCaRcbhqzoGgUE2Jx6yAtnD+S7cgjlQg70FlJP63Mv3jwL9mN79ViIAfxMsLm5jBpXD2OPpkzycaHVUyGei8LduFV2v075lbOM+jZgKVa9a5LocxzeZsVDNXL//qMn7Zlpy5SP2/tq0ZPbrMgk2Mu3d7958txJmM32AYV0GR0AYnO0U6xYH+BeHpAAdqyRQoQh++YI3XNSHykIhJdlyLaA+BtT5S4AeCG2YRiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6666004)(26005)(5660300002)(52116002)(186003)(2616005)(8676002)(6512007)(2906002)(8936002)(86362001)(316002)(38100700002)(38350700002)(4326008)(6486002)(66946007)(508600001)(83380400001)(66476007)(66556008)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?btE6/cuce9v+QMhTpaDD5OUayTXQSAw316W021zv0ru1ZfJmI1bnN0lFf0Lv?=
 =?us-ascii?Q?ChmXHVtFDE8sb8MHZhsXXUQv9/rMHufviEqh6VgYaWAZZ4zgf0+etkEmuXkt?=
 =?us-ascii?Q?zzlTGrRLHYPFjDNIDPpUbFYhTPr+Tt9VDt2xExFTcFMpyW3EtXQpRMLOPYdI?=
 =?us-ascii?Q?qiAmhkFN7Oxi8OtwHkR9ZuU5dhX9sMbw/QA/3AG6O1rbKbVi1LufgfBWSj1Z?=
 =?us-ascii?Q?o00vP+yaUnqUo410wpfo2NS4OygKfPIypatfQWKmhswbpV8yOmv2ueVYWGdJ?=
 =?us-ascii?Q?dwGpeY86asEsgFoxTVJsPO2sOPI8/ZvX9iY5AUUFNhSnrO2AZ2NRsXPf0qQn?=
 =?us-ascii?Q?Pw/2m38KQ8P3aFe0byVVKVwdEzrdvCG5B5x3UYgay1iliWixd3Hc8a4G0Vt3?=
 =?us-ascii?Q?QTYlFs2gQfiuIBnVwYOCh9996Shva+N2Loj7vOE3v2nDt6wgQXnxCXlADxw9?=
 =?us-ascii?Q?Rn+075vscWz+Xv87mKnIjmJkcKmbfs2OiRVX2P+nAc17rcNXSqUOCAIBwUDV?=
 =?us-ascii?Q?XpijhaueV+SI6wrFScPZ1ekulP/ht0sxJdanIUtTp+IU98gLo3yvX0qc4hyU?=
 =?us-ascii?Q?N/3+VRUhL97fjZn8QsWTfwXI6LI2DT112kVgKV5K+Ve3mNv2kiAmY8DdRPYz?=
 =?us-ascii?Q?V2wnI6iAyJsHokPZavpxtJKAH0Hlz925JdpMzOAxXdOswZbZ30yZmSrjv6iZ?=
 =?us-ascii?Q?fMDSmnB5OgrH+AEKX7ml3FhrzyIZs3qO40Q1xG4OgatmxDXlUgt3p2HiyTx0?=
 =?us-ascii?Q?t3QnAWgfFaI28QNNBWIUB139kxOCqWJkJ7AS8qh9fuFHAFl9rz+q2AXTi4WH?=
 =?us-ascii?Q?f1zAo9m6AuceZ8yzQWMr4Jdgj2JM95bOvAJzNwQQPq/pLM5of1xY8iy/cxrH?=
 =?us-ascii?Q?UHHi5Buzh+YVtEfW7f38/W6s4oWH+QS/VdPjpqmzWf7fOjPaNblXuVMTpJj+?=
 =?us-ascii?Q?+IcSXCMmAM2tu5ZmzJlJ0PNYEYvfowLZMselgcTNAoTiTXcz28tdYSWb9AYv?=
 =?us-ascii?Q?ChlOEDeyu4CsP1ooeNAdsw9VOUMp09SChdqW1SQO0F29p1GKc8plRVrLZko5?=
 =?us-ascii?Q?n4ObB6tIYC8dHsz5QEIPQYkAJfvE7QWu39zZ2NCL/ZDLjkG5LdhFU1QFtgTX?=
 =?us-ascii?Q?rEgDujIp6O6Ulu/8fHKiAfk9yyru2/HOc5dXDyVo88ARe1XKFfmhu+VJkDKE?=
 =?us-ascii?Q?33C2JkT2StSaoCVfr1KSCRJjR3g9AwaR20KYItsC79uTDugmvwW1TLiQqiVf?=
 =?us-ascii?Q?tqfsrzI5zsDyrzlRIKZljRXuNHYFjfwHyjFnFApBm6zGhj7/zpOlJcKQGWM6?=
 =?us-ascii?Q?KxR5Kxo5Yol6v54cB0U9NzqCHf7+cYBwbMAvBdXlfS02upTT9OKY0X4aqwj1?=
 =?us-ascii?Q?9pqZkoW+aNKCk7jh7jbt0IevJcVWD6wAAYK5Bosneqh4HvZ2AJNqlg9GQZra?=
 =?us-ascii?Q?2L8N+rd1Dz1QBR5NmjLOe2c+LFDtcpUWtXyyijRcvBy7iLbP5U5FKjm681Ja?=
 =?us-ascii?Q?8TL/KHPvY97Ob74zQblCq7NZ1wnBJ1/far4tFxakoiTazqLaEcmPz5rqxfCt?=
 =?us-ascii?Q?sjChSMtWTezu2VRIOrwwNOSG0haQVCoincJpA5cRH436DskMStxsQBkaszs4?=
 =?us-ascii?Q?qCsArQHFBJmE5Vu3gzVurFUFJfC4PMAxDoV42K8FcJF9yy3nJH77M96chRV8?=
 =?us-ascii?Q?FGoUfw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a66a97-b55a-4f24-1573-08d9c3b18715
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 12:09:09.3744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kw5zjBI6vj2y0k9NBAnONLuDk2CQN7WVxadiuB+n0jM/HHZsSFWJ52Zc09LY4UIRQSEmLtLIYXdkC3WdYSV4Bv3HVNpGOFckCsXdfmjA+uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for external timestamp and periodic signal output.
TJA1103 have one periodic signal and one external time stamp signal that
can be multiplexed on all 11 gpio pins.

The periodic signal can be only enabled or disabled. Have no start time
and if is enabled will be generated with a period of one second in sync
with the LTC seconds counter.

The external timestamp signal has no interrupt and no valid bit and
that's why the timestamps are handled by polling in .do_aux_work.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 202 ++++++++++++++++++++++++++++++
 1 file changed, 202 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 91a327f67a42..74de66c90f24 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -97,6 +97,11 @@
 #define VEND1_TX_IPG_LENGTH		0xAFD1
 #define COUNTER_EN			BIT(15)
 
+#define VEND1_PTP_CONFIG		0x1102
+#define EXT_TRG_EDGE			BIT(1)
+#define PPS_OUT_POL			BIT(2)
+#define PPS_OUT_EN			BIT(3)
+
 #define VEND1_LTC_LOAD_CTRL		0x1105
 #define READ_LTC			BIT(2)
 #define LOAD_LTC			BIT(0)
@@ -132,6 +137,13 @@
 #define VEND1_EGR_RING_DATA_3		0x1151
 #define VEND1_EGR_RING_CTRL		0x1154
 
+#define VEND1_EXT_TRG_TS_DATA_0		0x1121
+#define VEND1_EXT_TRG_TS_DATA_1		0x1122
+#define VEND1_EXT_TRG_TS_DATA_2		0x1123
+#define VEND1_EXT_TRG_TS_DATA_3		0x1124
+#define VEND1_EXT_TRG_TS_DATA_4		0x1125
+#define VEND1_EXT_TRG_TS_CTRL		0x1126
+
 #define RING_DATA_0_DOMAIN_NUMBER	GENMASK(7, 0)
 #define RING_DATA_0_MSG_TYPE		GENMASK(11, 8)
 #define RING_DATA_0_SEC_4_2		GENMASK(14, 2)
@@ -162,6 +174,17 @@
 #define VEND1_RX_PIPE_DLY_NS		0x114B
 #define VEND1_RX_PIPEDLY_SUBNS		0x114C
 
+#define VEND1_GPIO_FUNC_CONFIG_BASE	0x2C40
+#define GPIO_FUNC_EN			BIT(15)
+#define GPIO_FUNC_PTP			BIT(6)
+#define GPIO_SIGNAL_PTP_TRIGGER		0x01
+#define GPIO_SIGNAL_PPS_OUT		0x12
+#define GPIO_DISABLE			0
+#define GPIO_PPS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PPS_OUT)
+#define GPIO_EXTTS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PTP_TRIGGER)
+
 #define RGMII_PERIOD_PS			8000U
 #define PS_PER_DEGREE			div_u64(RGMII_PERIOD_PS, 360)
 #define MIN_ID_PS			1644U
@@ -199,6 +222,9 @@ struct nxp_c45_phy {
 	int hwts_rx;
 	u32 tx_delay;
 	u32 rx_delay;
+	struct timespec64 extts_ts;
+	int extts_index;
+	bool extts;
 };
 
 struct nxp_c45_phy_stats {
@@ -339,6 +365,16 @@ static bool nxp_c45_match_ts(struct ptp_header *header,
 	       header->domain_number  == hwts->domain_number;
 }
 
+static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
+			      struct timespec64 *extts)
+{
+	extts->tv_nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_DATA_0);
+	extts->tv_nsec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_DATA_1) << 16;
+	extts->tv_sec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_DATA_2);
+	extts->tv_sec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_DATA_3) << 16;
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_CTRL, RING_DONE);
+}
+
 static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 			       struct nxp_c45_hwts *hwts)
 {
@@ -366,6 +402,7 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 
 nxp_c45_get_hwtxts_out:
 	mutex_unlock(&priv->ptp_lock);
+
 	return valid;
 }
 
@@ -409,6 +446,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
 	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
 	struct skb_shared_hwtstamps *shhwtstamps_rx;
+	struct ptp_clock_event event;
 	struct nxp_c45_hwts hwts;
 	bool reschedule = false;
 	struct timespec64 ts;
@@ -439,9 +477,167 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		netif_rx_ni(skb);
 	}
 
+	if (priv->extts) {
+		nxp_c45_get_extts(priv, &ts);
+		if (timespec64_compare(&ts, &priv->extts_ts) > 0) {
+			priv->extts_ts = ts;
+			event.index = priv->extts_index;
+			event.type = PTP_CLOCK_EXTTS;
+			event.timestamp = ns_to_ktime(timespec64_to_ns(&ts));
+			ptp_clock_event(priv->ptp_clock, &event);
+		}
+		reschedule = true;
+	}
+
 	return reschedule ? 1 : -1;
 }
 
+static void nxp_c45_gpio_config(struct nxp_c45_phy *priv,
+				int pin, u16 pin_cfg)
+{
+	struct phy_device *phydev = priv->phydev;
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1,
+		      VEND1_GPIO_FUNC_CONFIG_BASE + pin, pin_cfg);
+}
+
+static int nxp_c45_perout_enable(struct nxp_c45_phy *priv,
+				 struct ptp_perout_request *perout, int on)
+{
+	bool rev_pol = false;
+	int pin;
+
+	if (perout->flags & ~PTP_PEROUT_REVERSE_POLARITY)
+		return -EOPNOTSUPP;
+
+	if (perout->flags & PTP_PEROUT_REVERSE_POLARITY)
+		rev_pol = true;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_PEROUT, perout->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, PPS_OUT_EN);
+
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+
+		return 0;
+	}
+
+	if (perout->start.sec != 0 || perout->start.nsec != 0)
+		return -EINVAL;
+
+	if (perout->period.sec != 1 || perout->period.nsec != 0)
+		return -EINVAL;
+
+	nxp_c45_gpio_config(priv, pin, GPIO_PPS_OUT_CFG);
+
+	if (rev_pol)
+		phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_CONFIG, PPS_OUT_POL);
+	else
+		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, PPS_OUT_POL);
+
+	phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG,
+			 PPS_OUT_EN);
+
+	return 0;
+}
+
+static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
+				struct ptp_extts_request *extts, int on)
+{
+	int pin;
+
+	if (extts->flags & ~(PTP_ENABLE_FEATURE |
+			      PTP_RISING_EDGE |
+			      PTP_FALLING_EDGE |
+			      PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Sampling on both edges is not supported */
+	if ((extts->flags & PTP_RISING_EDGE) &&
+	    (extts->flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_EXTTS, extts->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+		priv->extts = false;
+
+		return 0;
+	}
+
+	if (extts->flags & PTP_RISING_EDGE)
+		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	if (extts->flags & PTP_FALLING_EDGE)
+		phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	nxp_c45_gpio_config(priv, pin, GPIO_EXTTS_OUT_CFG);
+	priv->extts = true;
+	priv->extts_index = extts->index;
+	ptp_schedule_worker(priv->ptp_clock, 0);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *req, int on)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	switch (req->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return nxp_c45_extts_enable(priv, &req->extts, on);
+	case PTP_CLK_REQ_PEROUT:
+		return nxp_c45_perout_enable(priv, &req->perout, on);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct ptp_pin_desc nxp_c45_ptp_pins[] = {
+	{ "nxp_c45_gpio0", 0, PTP_PF_NONE},
+	{ "nxp_c45_gpio1", 1, PTP_PF_NONE},
+	{ "nxp_c45_gpio2", 2, PTP_PF_NONE},
+	{ "nxp_c45_gpio3", 3, PTP_PF_NONE},
+	{ "nxp_c45_gpio4", 4, PTP_PF_NONE},
+	{ "nxp_c45_gpio5", 5, PTP_PF_NONE},
+	{ "nxp_c45_gpio6", 6, PTP_PF_NONE},
+	{ "nxp_c45_gpio7", 7, PTP_PF_NONE},
+	{ "nxp_c45_gpio8", 8, PTP_PF_NONE},
+	{ "nxp_c45_gpio9", 9, PTP_PF_NONE},
+	{ "nxp_c45_gpio10", 10, PTP_PF_NONE},
+	{ "nxp_c45_gpio11", 11, PTP_PF_NONE},
+};
+
+static int nxp_c45_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+				  enum ptp_pin_function func, unsigned int chan)
+{
+	if (pin >= ARRAY_SIZE(nxp_c45_ptp_pins))
+		return -EINVAL;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+	case PTP_PF_EXTTS:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 {
 	priv->caps = (struct ptp_clock_info) {
@@ -452,7 +648,13 @@ static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 		.adjtime	= nxp_c45_ptp_adjtime,
 		.gettimex64	= nxp_c45_ptp_gettimex64,
 		.settime64	= nxp_c45_ptp_settime64,
+		.enable		= nxp_c45_ptp_enable,
+		.verify		= nxp_c45_ptp_verify_pin,
 		.do_aux_work	= nxp_c45_do_aux_work,
+		.pin_config	= nxp_c45_ptp_pins,
+		.n_pins		= ARRAY_SIZE(nxp_c45_ptp_pins),
+		.n_ext_ts	= 1,
+		.n_per_out	= 1,
 	};
 
 	priv->ptp_clock = ptp_clock_register(&priv->caps,
-- 
2.34.1

