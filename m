Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFA042569B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbhJGPd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:33:29 -0400
Received: from mail-eopbgr10059.outbound.protection.outlook.com ([40.107.1.59]:24805
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240882AbhJGPdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:33:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDtoFfTUUtOp1N5PjkMmSdi1lYv+1YnGWotRV4ahNilxpHwY7smCH2SkWs1mpY9hqqXHdT/sWfS8b9kSsCfGj5xAv/F1hBYQ/9jnt0mMV4hIZ+rIEfI23K+IGKdEYQZJw8zJMH71ZUBxoO9wwS+anHLGFKrCd9TN7yE1P2LBbtba5oWU4gndhlmzVr1Xk116iryr4NNE0tO31cbtEPU4SpaHdNGsd7Tqwp/jNDaaQ/iB/3Rz5fkrUBVdV3jpwy4vIcOqnQya17+MGXb5sGhGQvRjNamP8/q9DLJ7pS2uWC0GWK6epvJ6dYQ7K8YEDKbM8H0zq+WuY4pHkoDg8GHNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJr0CDqM7GHw5tmp+KaXJqRqLtM+apXwjUsSszr6cko=;
 b=bvRtW9OhjOlR9GeTXCA1Aq0rIxAU5ImMiKyjSgZbOT7tFuBw84/OL0e5eNZdxpfXUYU7kLKL6mOijqG5/mB5AfLpE+mtzhp4OvhWgNC5+3IBirUC1c6PLmud59iXlkKsi08quLAmQeVoFuokf9zXcQAk5vb4Lpq/8PDa2pPkT7sXAqk6NiXBOxNEJmb62FV5H24HGTslCUiGqZNSST8KZWyK5EDQU+4rcvJoqRh2rO8GRjtMktYtn6bEWWdGNPQASa5QwHUTkYenfmi419IvtnoQo5RJNZ1Z/iyC3VHSb43oohLvNVJiRIFMUN3C/f+/wsl0NBEsH1NMQHkmHkXW+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJr0CDqM7GHw5tmp+KaXJqRqLtM+apXwjUsSszr6cko=;
 b=f6k2023JplpB7i6vdMrN87SRa/kaSKuxg5MWKv2yTPcTegGBp04c7aHxgHVYH4cL98Vhu5GKtWgoPvAjP8ODKdZ6887V7D4BRFI2gon8SkxI0ag6uLDbr9BtAm7vG796PoN3Lf5ONFdqQDL85tjlHF45Zp1RWQHcp/2qE+2qEKg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7410.eurprd04.prod.outlook.com
 (2603:10a6:20b:1d5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 15:31:29 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 15:31:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/2] net: enetc: declare NETIF_F_HW_CSUM and do it in software
Date:   Thu,  7 Oct 2021 18:30:42 +0300
Message-Id: <20211007153043.2675008-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::30) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM0PR02CA0017.eurprd02.prod.outlook.com (2603:10a6:208:3e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 15:31:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d9d33a6-7c41-4495-4de3-08d989a78885
X-MS-TrafficTypeDiagnostic: AM8PR04MB7410:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB74101050E37DEA23E8E280BDE0B19@AM8PR04MB7410.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFP+xvOVxBIYtkwMbbR19bU5zv5SYTIAj2NST16cGSoCgKfeLpeFpZ9d/3WmiaplzEfcNQiPlyzkc3OEZInSDVSTTB41K2mhc9s/8Qb5g63pPZb1W5EuoejwEQBLx06Ycz9MAZusICaoSxfCoXMwiT+VGg+PdX8yPUCE5tCUPkj3xPBWFmQYhrYicdDXvUBJEKmRwtCviLCW3ScGLk40Ztmdfb3DFQt/tnC7tXhHBKaSfcZh4/TKVevIlqQT5IiMV8V2xFNBpuqjKTk+6Hz1nFHnHu8L+9Ec6cZjnd0Ub0db6ih3H+L5nhuPLt2+YNT5oOReFVDe27JRJeAQGqR+gDYV4/DxgzohKf92NbXQNY2I8auvlaFHIM0Oq7+yw0bxs37yqX1UwM/pmIKoqhLtBwMt301mmCgbcmbBbJVUhucnlQW8sGsnb5jhZ0qTfwcjU9BefWaGncbKXDgFN1e8LQkUviI3IFdr0uR2xt/CQDaGKTpNlkux78FlzsA+zwMgNP5ta+TaHOAIRISUPZ9klmQmYaG3Cuo4z1aBRfM1TCKY95IuvW5LY2hJueVmeXQrTGW56S30fuUWrmWroyJH4rZaj4pjeBUr4ZeXV5/iNYlhcJ33pCj5bE0N31iipyUos1CZX3BoYL+oNRhMSs8D/kkdu6bYFgN5xEjjv0vcy0QOFrWypoZPGu9BxrF5p8bM4D6Y5aLMq/gGFrAO8CG5Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(6506007)(6666004)(1076003)(26005)(316002)(66946007)(66476007)(66556008)(36756003)(508600001)(5660300002)(38100700002)(38350700002)(8676002)(4326008)(83380400001)(8936002)(6486002)(956004)(44832011)(186003)(86362001)(2906002)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBFp0mkQZIZTXB8VeROqfpou9auFSqXwnw7lU5F+rSyH04wPKJsfm2QMXZpD?=
 =?us-ascii?Q?FIHrSB/O1DZLcv/ayfUot+MT97wddcnycnG1BROwxuVkK6LfqV5253zfnde4?=
 =?us-ascii?Q?YPDShBxo/GbX9jZKNJxpuhLfvzb24QmngSE0uTH2ti7fv/NbXE0v6Alg9pUj?=
 =?us-ascii?Q?0rzdVtTrRewmk6JYbL9mnbXocgZupJiyZT7GWW/H1fwIYnMXFhcO7D5qQvYb?=
 =?us-ascii?Q?GwQ7qWBh22FFZ12kDYeSrMOFIqLfr6SJVHCs9Y7e3uDVsr/g24UTIfdaSd0d?=
 =?us-ascii?Q?QswhO5So0AcbVcq6d59HVATlWOZWIn8IH8vYxYUtZ7oT1AZRTUUizYyqA3kC?=
 =?us-ascii?Q?U10SQ32U1tS0DKRLnYhyLTxiVFm0yo2TDTx64hepjEk+DY+cKq/efNaZYUdz?=
 =?us-ascii?Q?5YkooKSMaxCw6+g6QpuYKrO/4GP/99h2P834e2wor7tano9f3VlfK1u+o96G?=
 =?us-ascii?Q?B1b96hhpkUCUtghAMs5ugZQnVCzHccOvW5Wut0mA8BceB95nmi5Tv2qpUq4W?=
 =?us-ascii?Q?t7Rhoigz40eYoljIDnjVS5HaVgQElN8/XU00hV+pV6NwQ4LoxKyQ+U3muAgD?=
 =?us-ascii?Q?0aS8MFm8BQyQ4fdInEfbi93ZzBfiIUocA+9a4Ti81t83gZvNjNdS3DuMnINj?=
 =?us-ascii?Q?M66bMXbH31/Ceozg52lpMHlfEY0S0mPTXUCZuW5cPDiFllft1x05AzuKgyY4?=
 =?us-ascii?Q?lI8Vu9zPZsLIt67Iyt/s63mnamo5xfTYHtJss1nqf3G6JDMqsY9G5XtK4+Od?=
 =?us-ascii?Q?yKfuAkGnWnlHvEV6GxwRszkITbgVmcvNvHN+f017TBsW1UnXdRJ7pNPJi43e?=
 =?us-ascii?Q?fjLZkwCGf8osHSSr3rx82Z4CQFHkq9x94PN0/IK2qQt8fpACdlMwfit4B27X?=
 =?us-ascii?Q?I1mcsPTDMuMUsXmJZ+AJt17ebjV55JhzksdmwrulRMDEivjK/fKKipJBrdwe?=
 =?us-ascii?Q?nJi8osWgrVWDX3K6CLEdYSAqgQryM0RfKV+VBE5vf8Bq6w7Yg9wZ08jMDCnR?=
 =?us-ascii?Q?Zk5jbNSjJPuGDBv8YPwHGJZDFEFpvpwt2ETApTnb9Nh7yp+vWWl6Pd6ifuis?=
 =?us-ascii?Q?LCrCR7Rl3+EODH63HLrmfv3Yb4Z1nyaYV4DREG1wTVlZiv2ETo2WjVvKJDc7?=
 =?us-ascii?Q?B5vtWY5D+c2wcfZEzDzOtog9L/3IIFEn5AeBEvvS+rs9V7e+A6QyHIi2xUqT?=
 =?us-ascii?Q?3KMnx3lOQlU6h8OSPR68/gNLVHui/EyVeETC4kc+9cHyiinCriaoo614hXha?=
 =?us-ascii?Q?aHh1fYeXKC7d9bwIz9gwpJjv6XPY5AiXCdO119okS8Rwmxa8nTzoYiOOeExk?=
 =?us-ascii?Q?NkOPUm9k96Xs6opW+0NNOYjN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9d33a6-7c41-4495-4de3-08d989a78885
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 15:31:29.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Px/2P8Bn29qJq5ESi5wzihlZ/ZdLIE2g2O2GPxb8QqQ4feGzLWwChQAsUtONH4obQY7Ud9v/0RM2g83jXdHF2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7410
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a preparation patch for software TSO in the enetc driver.
Unfortunately, ENETC does not support Tx checksum offload which would
normally render TSO, even software, impossible.

Declare NETIF_F_HW_CSUM as part of the feature set and do it at driver
level using skb_csum_hwoffload_help() so that we can move forward and
also add support for TSO in the next patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - declare NETIF_F_HW_CSUM instead of NETIF_F_IP_CSUM

 drivers/net/ethernet/freescale/enetc/enetc.c    | 8 +++++++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 6 ++++--
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 6 ++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3cbfa8b4e265..17d8e04c10a8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -319,7 +319,7 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr *tx_ring;
-	int count;
+	int count, err;
 
 	/* Queue one-step Sync packet if already locked */
 	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
@@ -342,6 +342,12 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = skb_checksum_help(skb);
+		if (err)
+			goto drop_packet_err;
+	}
+
 	enetc_lock_mdio();
 	count = enetc_map_tx_buffs(tx_ring, skb);
 	enetc_unlock_mdio();
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 628a74ba630c..1e3b2e191562 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -759,10 +759,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK;
+			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK |
+			    NETIF_F_HW_CSUM;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+			 NETIF_F_HW_VLAN_CTAG_RX |
+			 NETIF_F_HW_CSUM;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 0704f6bf12fd..f2a0c0f9fe1d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -122,10 +122,12 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_CTAG_RX;
+			    NETIF_F_HW_VLAN_CTAG_RX |
+			    NETIF_F_HW_CSUM;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+			 NETIF_F_HW_VLAN_CTAG_RX |
+			 NETIF_F_HW_CSUM;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
-- 
2.31.1

