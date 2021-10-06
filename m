Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56824247C7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbhJFUQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:16:07 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:61090
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231749AbhJFUQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjeyFOl3+VAQyTEQsCtxRR1vXKOf1NMiOQf4YUV3l1ZKkqdHis9b/N0Ro4lRp9TKct1w6hgJbLwIspl1gta41RAAZXwhFHwSGCuhVG/D9U+lEQ1ipsnIP5J6hMVzNroAYjtX4P4bTWyOW/2LqxMx+1g/lgpHcJICxCYIUqNJFp3auzmcfRy+gYoSjyZscor8RWJ1HCG6dJAwxX3pJWs9BwC4Wct3553Z7hGlvfAFyCqamefY3FdFKBWJVerEwL7V/CDNAurss0xVA6Wr6Sk8IA4xusoDD28AkHArg3t4QGH2DxKWI5KSXTjdstpSz+w+uqBuHRCJIAK/+10RxQ35VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaUMC5hwvI+JRLDPPieQsvFlHa3KKqcWKV4zvTaO9Xo=;
 b=E9mYJv9CGdKBMI2Zmj927pD9RwIj5qqTwArYMEywo8K81RPMgZtpaLJxW3ywACNbP4HxvzfoQGkX1wNeEOn1NtICF7NvZMm6xUTbFQyGxbqTxp1ho4bEE5FmlCf5mvtcf/wQdc/HfZ0IN2vOSja6mr8GSF5Wr0+WAf/HGuvvFpFw5TSVgMynwibNuD9EhZPlCxN7f3owejmY0yheYzq0iFThP23NFY3oM+4P9Ft7YdisqIkyLEt1LORb+12wmSwXfRCXl80sQZ7t45bz7NPbDjhapYsJ11bBBsSaemUrD2xzAfEURdGhUCaspeHX1e6diDXRqOkqhxRuezXGi+uHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaUMC5hwvI+JRLDPPieQsvFlHa3KKqcWKV4zvTaO9Xo=;
 b=hBF8dgRdyh1hQ+VMItBJkl+h99uhuCdvEM8TAjHoz+1agJzYPiipDoSbSx1pncEAHKY88jK11QGcmVkpZURiyDIjVEdy8O40SEsr0r+Xe0B2lYWEHp4FqcqCdLKbH1SSjxlxuVKPzZsSJyfEUbhnxGF1KfMetaUh+TKldA+oS1w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7297.eurprd04.prod.outlook.com
 (2603:10a6:20b:1c5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 20:14:11 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 20:14:11 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do it in software
Date:   Wed,  6 Oct 2021 23:13:07 +0300
Message-Id: <20211006201308.2492890-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::20) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM9P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Wed, 6 Oct 2021 20:14:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec75ba1c-ddef-431d-6032-08d98905dc63
X-MS-TrafficTypeDiagnostic: AM8PR04MB7297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7297C87E8D232F25F5BA1207E0B09@AM8PR04MB7297.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b93UMF3oRVenrTgd9VDgKSeJrSeIPB5Kx0utf946w/5FQAE5lkDOeK5ujg42h1qsZGn1NNOMKr+JmK3vFXLfy2V6wr32jerK3bVstubk9YmBdHoN4kXxDHeprJNOfXh5Houo2ov6S7UwZIgvprOmLqBDIspx9bi9SfMmQLWxFft4yCB2K0uMKGFbMC7OBZ8kEd1vHvOHkhb7+3RSQVheOAezkMGdDBGQe0GPnsLv7hS41zAwfx6GxeHEwYX0qzqHsE0GpEO+7VO4tSLuimKUYS7yhRo1J8vR76QrIFNfrCtgt8ZkyV+Tzvm+VAi25J/kbwtWBaXUtczksCquIFFld8AVf8FH/A8H7vJJitPlaoqHDQnqN3j+/FIgqh23miJKpFL17Gy2MLe7dScPRWZF94qH83zBomwzu5GjHvDN7Qu3vyLgPcmrjxrGFa68N7e+D1bK3WUmYyF9txuVPiQqq92SdRnUQU2xfYnbiF9q4ZhOkiI7SeIXpUYsmdd8OGGJGP3Jt1TtCtLzNYUgfQ9z40pDXGAFuLChHWxJSGeMsJYAqzhZneUG8QPlt5vIlYlcLccakkonsC5k3AZ+HsIBS6Z1Y8H5QhEgsgKU8G2ERkect6muw/r3Rp4OjCT1RVSzknMdsTbFTXtxUwhnkNcmMIMzeRxNRE8TlyEtTUdGY41jmfeXygTNJ8HzyKJRMni0vJ2nHRuOdrN/8v7VnhYKeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(66946007)(2616005)(52116002)(83380400001)(4326008)(66476007)(66556008)(316002)(508600001)(186003)(6512007)(26005)(6506007)(2906002)(38350700002)(86362001)(38100700002)(6666004)(44832011)(8676002)(36756003)(5660300002)(8936002)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ytAOQSlq9hoEbKiA24sokgi8KOj0Uq0eZK6LwMBfkenXSSVy5VOYAOf3jgDZ?=
 =?us-ascii?Q?tv7Nvlb74YSzCAnsehXSpB/Th3kIj9tCEx4HTIJj35W3dX/D8cNkyFAhUhxV?=
 =?us-ascii?Q?DKEEsGIGYF9WjfooFDJfEA+6GNzkXUG03EMXo3FInUFns67aFM6m1lEVcpNe?=
 =?us-ascii?Q?bpQASGSOv6Fls3a2DoBKu2LHfn3ncx7B46+y+pLy6U9pIa0resAxo6BBmT82?=
 =?us-ascii?Q?Yhta4GqFFuDXMKePnZ8/X3VzoWUxPr08DPzCcU3EhFWEIunxfJJKucPaRPir?=
 =?us-ascii?Q?r/QeLb/qXRRHJWcuNwmWsPUa9QG2zwNDvzAy6whg1CLrZbz2/O2tnQqDXfBa?=
 =?us-ascii?Q?MLfqptWw9WnpOLqWPlX6PX8W06+casAHTATgQXk3KYJcv2kgv/2cM9joWCZj?=
 =?us-ascii?Q?10Tzkax4tRIEm1KoZJy0hn5uBWn+Sad8wV/kG9L4MzTrffEJd3Bb2930Mj99?=
 =?us-ascii?Q?36U7yDDqlNfwS5jPzi+plorM8HEvVK77OsT09ZSQCzS3nUp6MeoMi+H/vFaM?=
 =?us-ascii?Q?nrJ0GyxmJ4zSDb6jZ5bGYYetntQbsPg3QHe/XGvfLR0ndb2pZ4J+d237wTOG?=
 =?us-ascii?Q?0zyFF0SAk3obg+jsju8YiXfVjN7osYp7TN7qSoVtSyWdht9iP8NeSAGl05eN?=
 =?us-ascii?Q?BRylJjwkgvhnGuNUviaWlaZHo1umtoUTBJbiUdvuuOH1RzF28vDOZwKNvLfm?=
 =?us-ascii?Q?M63+hLJi0WhMUqdb8pIzVcrbF8LX0ff+1GLjdj3wYjsgTOox4yTApgJT0iPO?=
 =?us-ascii?Q?W+wGT/XRJCgF7idK3gnJ0UVN3cr4P+GanOzZLPERiX4HsSEVkidi/WlnHAi4?=
 =?us-ascii?Q?qAq3d7lxg8VijzrpB6yuSBWka4XRKnUZz1rzV8qoVhy0YTT6K5NV9ZepaxSm?=
 =?us-ascii?Q?KOD8pciEzFFjWsY2YgdpvZSLnI/Q7ypqwIfoBefAD2QdtYdi9ImsSeX+Vn1q?=
 =?us-ascii?Q?wSNLMDJphHjwoieuv6C5Hx98xUqPaYchQTm8t85fhGpEIErfNZBF+q22NvG0?=
 =?us-ascii?Q?ZoqJYfa/ZL8h4P3WwK51anOWN7B4awHFF3RmjdrioCrUxSm96LP/GmzSX+Sz?=
 =?us-ascii?Q?nqYq0RDuD3PDwoBSXwZevRxvKPFi8AHnPmoZz27Y0rsyje+y7cV0RQCKF3Rb?=
 =?us-ascii?Q?+63ZC2u7guROi8udDAdgocR0yWYejv7LkXdpuP4WkduvfeB5vdSItaOocdu2?=
 =?us-ascii?Q?LC5wBDkdfhSx3Wfj3C79CgeADwJKgpgShrSu/+Q9Vg4Zdth9fqdMX8+4TMmZ?=
 =?us-ascii?Q?4l/OZRZ++rYfPPMVi6uECfhunXXZ//n7v/6fRChIhnweVeIGZ6Bf83LImZh+?=
 =?us-ascii?Q?1kfhOW7fUMmc7jJpv6228tas?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec75ba1c-ddef-431d-6032-08d98905dc63
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 20:14:11.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHpbpyxRb34Q53t5YgDj6gRBeIr04mfDDV2mpDNhGahir/sUk78O4AMLP2G60EhKpxS9tGd+Hxk2jscgbnPSPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7297
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a preparation patch for software TSO in the enetc driver.
Unfortunately, ENETC does not support Tx checksum offload which would
normally render TSO, even software, impossible.

Declare NETIF_F_IP_CSUM as part of the feature set and do it at driver
level using skb_csum_hwoffload_help() so that we can move forward and
also add support for TSO in the next patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    | 8 +++++++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 6 ++++--
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 6 ++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3cbfa8b4e265..a92bfd660f22 100644
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
+		err = skb_csum_hwoffload_help(skb, 0);
+		if (err)
+			goto drop_packet_err;
+	}
+
 	enetc_lock_mdio();
 	count = enetc_map_tx_buffs(tx_ring, skb);
 	enetc_unlock_mdio();
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 628a74ba630c..7ac276f8ee4f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -759,10 +759,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK;
+			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK |
+			    NETIF_F_IP_CSUM;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+			 NETIF_F_HW_VLAN_CTAG_RX |
+			 NETIF_F_IP_CSUM;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 0704f6bf12fd..2166a436f818 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -122,10 +122,12 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_CTAG_RX;
+			    NETIF_F_HW_VLAN_CTAG_RX |
+			    NETIF_F_IP_CSUM;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+			 NETIF_F_HW_VLAN_CTAG_RX |
+			 NETIF_F_IP_CSUM;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
-- 
2.31.1

