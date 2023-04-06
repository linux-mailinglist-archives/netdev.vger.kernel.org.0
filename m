Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF16D9369
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbjDFJ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbjDFJ5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:57:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289069003;
        Thu,  6 Apr 2023 02:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsXvZ7KdTfH90Mhe1DoNdr+OsAmVWLrOhawp0tMMNsHpZr4c2zf0ogMqaJ3IHXOqX9cWPcwmCTmi/qHuTrM4loVj+JpdTOmq/edOo13OkY80LhkzD9uGEYrkfyGdBpjkE7IEpClbPkWnY4IMBuHhPHgGKbPrpyIAPD36sFquLqSrEdaI8lQ+31oW5gf8bwVVBtNUkgo9uSZACN33UeWsQAVmbxTvuOm1xm9YD3s9zBXPET76Ld1O6XYRXssRBRD/+qcq3DLf1QdyL3ir1nc3pp3viJBtFs2xmFBLpGCEcTVoUbe0cm84lJ3ISULnmPSU2ZhtYfdkJry1Zkc2x8W4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RXX4TT2ASqdiKhE67DCvLDebqmlpmUdgAsc+MtqUmM=;
 b=kyaWGuqOCWbNO4wAXA/a0TS0A2Rfzar+KddhCyRG8E6VuX0FZ2DSGC0lAIwM4DLhhw7j/iozAHMhe606YUCYIjsn5y65UWd1YceRC1OstJTGuCTuQykhH8SjekSKus4JbqLp921elWZSJB/J+nRv7o/ric97DMUYN1h+Rf3gvxtNVYoLjtBKrJR5p44lR+CAJ5njATp5LfcS9UI9X5YzYWI5PbHBsL2S1Swf+aG7EeJ+SEN+6ntdJlmsvPcjJYURBGXgHIhuHNWEZvG/aqI25QXHECfDugGh8QUUqjfH38KsWVsPJR6MlMnPSe564f75xjiTwGhjTlKhMZBg3b8s4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RXX4TT2ASqdiKhE67DCvLDebqmlpmUdgAsc+MtqUmM=;
 b=SPwrgtPeGmRTsNBLQWKda5tjvwl3yOJDTpHbrea8CWgYbLGMc92gd54Q6KyIlKLQAVXjtm4n+1F4NTWoMEv0KoPwR22M59qa1QaWxmuUUaMf93fdr4JLMnoTlZgN6jIfmn2blPUcWcaIap3in+IElNFE7PluLjSky3nl9YUcttQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB7549.eurprd04.prod.outlook.com (2603:10a6:102:e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Thu, 6 Apr
 2023 09:56:01 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 09:56:00 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: phy: nxp-c45-tja11xx: disable port and global interrupts
Date:   Thu,  6 Apr 2023 12:55:46 +0300
Message-Id: <20230406095546.74351-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::33) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ce4c26-5d5f-42f2-cde3-08db3685206c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILiF9UppvdxcQG/8klbGKYTP4UWnM2FslvRt5mLiyqLbnof+l38vlpyXwLbHNIzv/QRMFC7JDRy68N3rnJpXfFRmQsG4WfZEzudGBg+7r+qM/qTfpD6fSpM9T/Z8oXyti8JkVlUN/UpOBaIp+nGDBmliuEG5gEcxlBvNgAmJZdoWJm1/zvfEavJX5H2LkPUQbIAIaRE/DeHj2/WXYfCioxmaoCd1fdx6ZGADj2L86vqDE9MLX5PGvM8XDUfGzJGF9tbbCrZNqYOVPt5eQJNsKRrZLXPn88tXx2kYGM1qof6U6UZYMdKXjDcqOrcpq+JXvcvpkrrPexB4lEwl1vw2v9GRJzVBuJRaquEYWnvRMISR9kURXlkwfCiXcIu6fQgwpqGqLf8ap6xQy/pujnVQy/z8GgI4daT9tPSOjFNh/u5Vi0GRh+z3+6dv0C6ObYbdKGeXeZZm7MdDJHMgROvj+cdu6uOwfcfF2E/pzRO3v998+ckScRgvrLMhlRqdtbPRa60AmHNWDSJ59TiBgAg2yjMsNNyRLL2xUMr5h1R6q6BlH6HGY4yXXSZlkbBHJkno+GF2cD/QPFqSGb7kDhWKP4YVBy794oMwyK3gF1Bv1Z/gH5eut1n9nG+pc36ZKtrR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(6666004)(41300700001)(86362001)(6486002)(4326008)(186003)(8676002)(52116002)(38100700002)(2906002)(66476007)(66946007)(66556008)(83380400001)(316002)(8936002)(38350700002)(478600001)(26005)(5660300002)(2616005)(6512007)(6506007)(1076003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rFp0zez7/JCxnZTX4yYss31LEnLmHNvvrB/UJO553/q7nZcQighA6K1WdgUZ?=
 =?us-ascii?Q?Rm8mJnMBDB1PJ/VeFvx9pXz1uIxQoppP/lcyDy5yA73zUJH+x55OL+S4hk3W?=
 =?us-ascii?Q?ymEB4LeqFoJAd7ZHqhLwBAjustud42JKH3rGDf9Zc3ow8rGFRug4zrqqXwxe?=
 =?us-ascii?Q?poU29Kkk/e9N7YdlJPp3We/FSQRuBKUSiZq08BmmiyjOE50DKIlV3yCNzRMn?=
 =?us-ascii?Q?kc2i0PwLxC94+GmMdZZwwY13gat8JmZjDWSfunoHFA0j6Rhf7r4ZPyr4xLSe?=
 =?us-ascii?Q?PfqxdEvfTZ1gaYSrTOle+/n4lWac7+uFmp3qBXTJE83zPuRzDnvFuJLB+0fr?=
 =?us-ascii?Q?s45wLXpoB7GSbMc889O9ZvKJ5RC6yNs3+zyfy+ebbSlqOYsEG+M9UGIGdR7i?=
 =?us-ascii?Q?4aLV5PbCCkQKcF5eY4GsBmSJE8Xy4W/bTwqItN9MHc5fBtYfn3/gezvnRqNU?=
 =?us-ascii?Q?3UxIxvRvpDu4J9x3zg7aqQm+gYwaim9TnaJF8Eksq4Z9Z7Y5w6KwVEvJfJuw?=
 =?us-ascii?Q?+KtptEZv/fDoa6uL1C6o+8AjnTkaCFnm5rTWhUG22YdXaOVNvM31CE4rK1py?=
 =?us-ascii?Q?R6zbEEylzQhHGCL459zahk8BybOHDUWW99wjXRwy7HNmuMtvGtJDGwamV6wX?=
 =?us-ascii?Q?oB6GUQyq/iTX46kdyLY9FhYE1lGApaQM8G57vPdF553WCV0EDTvbWgP/HqXI?=
 =?us-ascii?Q?1pRw4UKS/Tk0fuWYqmpCsJAXS/Wc2VHp//hbrUb06wCvEaePS5UefKuEIMSN?=
 =?us-ascii?Q?EaG+/l7y1wYojCI5URTnFtPpX0qxZ4/Li12dB5e3sOpvrMN6e/sQGTJ1UbIc?=
 =?us-ascii?Q?R6ZY+yguGQ6NYfpQG/WggXOE1mFq59U6Rv6qQES9+qLwMvjWdcqnJzQp6VHU?=
 =?us-ascii?Q?oLzOXFoS5om+7w2kp5u4d71y2F3MBX9c5OWmqu+uQoLHqp7rnXP4oZ8x5aa5?=
 =?us-ascii?Q?MqYkKx13sPyTWa3bSvyPJa+aNOwA4vf1PIKfuPxNBTL/hs1Kl5qhB6WG6uWk?=
 =?us-ascii?Q?2lFCeBSWBbROXAGmcfJiDbpMbi80Dtp9Fc3Q1bl6egEpKRQqth4yo2sTbpRm?=
 =?us-ascii?Q?Njk1aRR91sNDw8S1kcViZIMDL6dyd7qUhBM3MzjYpKwXxBTy8/QCvSdFA7qT?=
 =?us-ascii?Q?UkBeRnVcd4RtEgOUcX8mksX4cHz+ba/hpJ15tFY+nmvQJ1decUCIt0UVDflW?=
 =?us-ascii?Q?DqFjOop+DF/8fSxHRqssdETECuT8hIGgW+luSipDFz2be8KTymNhDMP+W8D6?=
 =?us-ascii?Q?P6i5Jdj1mU1jzZRgzGCWdIpAplrMYnVOdAKEyrGWmSkVtyahQbXuGhXYPVkn?=
 =?us-ascii?Q?MlQptOWbBjwWyyKdC5Di8+7TRettnylm3XZocJDhITJ5rykqssnbXi8R+VrB?=
 =?us-ascii?Q?8E8of439cyg4y9wr4PyeNEYBPs0f1lZ3hcS94G8//gRhnuf7C+8KwxPIIuXE?=
 =?us-ascii?Q?RcjWP79FgiexxsxSVSc1vIxu0dJiMh2il5dHHKfRjVqZvXVhPEZEajwaYClW?=
 =?us-ascii?Q?BPjCoo5BayCvtjWf6IorZK1IZFdHV+grDDMqLU3t35CiRaehvwtNiqn8C2B/?=
 =?us-ascii?Q?gM+UnjTUXDGnyxhjqd5mXP4kqvHn5JaPdA1mAu0CnkACmlB2tuCO23x75Q7A?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ce4c26-5d5f-42f2-cde3-08db3685206c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 09:56:00.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+QXD6h1oe7Xobb0hu087v9hZ7Nn+G2l06bCF/DMyvrhDRrkdNf+eZwHj80NCvehS/LIhPJXne6OMi/wxuCG0VudS4lAiUFYPw3uWU7lIzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7549
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling only the link event irq is not enough to disable the
interrupts. PTP will still be able to generate interrupts.

The interrupts are organised in a tree on the C45 TJA11XX PHYs. To
completely disable the interrupts, they are disable from the top of the
interrupt tree.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 029875a59ff8..ce718a5865a4 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -31,6 +31,10 @@
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
 #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
 
+#define VEND1_PORT_IRQ_ENABLES		0x0072
+#define PORT1_IRQ			BIT(1)
+#define GLOBAL_IRQ			BIT(0)
+
 #define VEND1_PHY_IRQ_ACK		0x80A0
 #define VEND1_PHY_IRQ_EN		0x80A1
 #define VEND1_PHY_IRQ_STATUS		0x80A2
@@ -235,7 +239,7 @@ struct nxp_c45_phy_stats {
 	u16		mask;
 };
 
-static bool nxp_c45_poll_txts(struct phy_device *phydev)
+static bool nxp_c45_poll(struct phy_device *phydev)
 {
 	return phydev->irq <= 0;
 }
@@ -448,7 +452,7 @@ static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
 static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 {
 	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
-	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
+	bool poll_txts = nxp_c45_poll(priv->phydev);
 	struct skb_shared_hwtstamps *shhwtstamps_rx;
 	struct ptp_clock_event event;
 	struct nxp_c45_hwts hwts;
@@ -699,7 +703,7 @@ static void nxp_c45_txtstamp(struct mii_timestamper *mii_ts,
 		NXP_C45_SKB_CB(skb)->header = ptp_parse_header(skb, type);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		skb_queue_tail(&priv->tx_queue, skb);
-		if (nxp_c45_poll_txts(priv->phydev))
+		if (nxp_c45_poll(priv->phydev))
 			ptp_schedule_worker(priv->ptp_clock, 0);
 		break;
 	case HWTSTAMP_TX_OFF:
@@ -772,7 +776,7 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
 				 PORT_PTP_CONTROL_BYPASS);
 	}
 
-	if (nxp_c45_poll_txts(priv->phydev))
+	if (nxp_c45_poll(priv->phydev))
 		goto nxp_c45_no_ptp_irq;
 
 	if (priv->hwts_tx)
@@ -892,10 +896,12 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
 {
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
-					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+					VEND1_PORT_IRQ_ENABLES,
+					PORT1_IRQ | GLOBAL_IRQ);
 	else
 		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
-					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+					  VEND1_PORT_IRQ_ENABLES,
+					  PORT1_IRQ | GLOBAL_IRQ);
 }
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
@@ -1290,6 +1296,10 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_FUNC_ENABLES,
 			 PTP_ENABLE);
 
+	if (!nxp_c45_poll(phydev))
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+
 	return nxp_c45_start_op(phydev);
 }
 
-- 
2.34.1

