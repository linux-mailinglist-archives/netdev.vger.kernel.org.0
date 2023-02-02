Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD1687267
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjBBAha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBBAhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:17 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2044.outbound.protection.outlook.com [40.107.15.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2233D74A78
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tyyxut22TDu2UPX2kutrRGrCCkd7scOBR50hT7SAidniOs7wVrPV7ZxgtmYJVCl6OAYiBp6TjpgoWAm4t9n2uplN5ng0t9p0fl4aBzi+pkyXWTANYM+FlMr1ipIFF7MDxaYb9JRbNxEEbvJaKR3kDBMBc/GD8GA+4Zy476971iKWRX+Ow+TJp1hDYHAHNsyKfXUEc+eJxvX3f/+85rLbaEFcDCyaDuoiCTmcCOAh9pItlNzE9k9+Y2yRqCh96/Cz/qefS8sl3Yvtk3iBUmNwBb2Dlzl7Ph/h57fKNY+RXBN7/eQ/CZmV/7wYFNL71x410Y81i40Ka8ufX6OoKQK5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFVwGu0C9hzv3/ETbyfGNJUofY4pT/mrgrNetqntAAQ=;
 b=BG+ZyG4LJTdGU5EXjTtUPA5NwHahUS6/7zsIu/HZar9mDwuHvMMhI8MmHd0CfTJU8w+UeHT6mFRdtYL7qW4MehhL68O4oWITJDBpXbBpW4HIEtgws2NCNS8H8tsEpe+Y3DUcss7C/PGvrk/753a3BNvu0b28HlOpccqaYV9FdbyMxEsXwxfoCUgEwocnyKJ1CA3RvNYgmCQy1bk6nAaNVza9IeDbvRGCboscCk7EGipYgjkjaHGXt7vv9TJPo18HCg7oekmvwkz+wjzt/TfF8zyNUAe3kSg6bnkAWjtRhJR+8rbDyGd0KFm84dLFFidLQrVrQWvHdAsx5IVnFDUVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFVwGu0C9hzv3/ETbyfGNJUofY4pT/mrgrNetqntAAQ=;
 b=U6K2pxOoNteUdQyR7O/Q4vngJXAgR9bRQut1PAgANb3Mo/eAu9JMPgYjg3qBwymk+XukldyoxtgammLCk7nA0ZdyIgQZ09vI/+eFHI+/10hZSirNh8nq8ImzCULUUTXP+4EO4lFbABwP/m87ZhL19jtbUlbumGepsh155oiPeJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8362.eurprd04.prod.outlook.com (2603:10a6:10:241::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 00:37:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:37:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 17/17] net: enetc: act upon mqprio queue config in taprio offload
Date:   Thu,  2 Feb 2023 02:36:21 +0200
Message-Id: <20230202003621.2679603-18-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8362:EE_
X-MS-Office365-Filtering-Correlation-Id: ceff6723-4070-49ad-a150-08db04b59b67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdxPK9MqEBBGXsRNDBsVTf0QSRmWGUyazGWf6XSrD+5w/E1X4xdtIoM3RMq2ktHaCGKFRltlNWJ35Y/HEvO0WW5CcAv9ifknqDa4H/L85qu2Jchr4+oqNmW2pPXcj8D+XU5nMs+tWmIAncEJjFWXl9kcyEfhjfjjI+lN2bSa4oSA76B8PBMzk4+jsfP7Dp7+gOxpjQqtMG7cfkfibhgU7SM4PycsVHs3Bcox0qJHbmZLlqP9taNsAYsmNOhDhhwkqTY0TwPzxvGz8/lCwTRWnnMvT13j3oQ/82j1JLw0+uBRml/o3duHTzjuwIMWuC4txbz56W03ag80V988wRT1QxmICsQBmqQ4ZtoJ0ERCDYDPdZnwHoWz6OT5nO21u9qH3ZuZoSosUlBFhnZudweW4YgdAXxX7SwG5HgC5uskfwjwBOdtf2mshmzXZICW/fgo9YC+QsIDe5V9Z/Jw4TfAE1fu94hbpObq1Ho8D7vVL1D9j0fCTP5eE0W/1i69Cin7kwBNcP83LpCqdP0c1s31CbkHIDHwvqwEK5SkWgOdi7qJdc1hXn1JMU8qCFfRewSjJ1rrbbDiadGmLHcwrMAbEYcq9OXlQ4vmIoaYMbLNbA5qBNkdMvxr2aoaEYjVIpbSHsGLzV4VDBv44//tsFbRdQRneV+0VkdK8+gI8UQySIS4n8XU97CbbPVJSz01b/lKDSSFXF+bdIL/qslkfaJpkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(478600001)(44832011)(54906003)(38100700002)(38350700002)(316002)(6486002)(83380400001)(52116002)(7416002)(1076003)(6506007)(86362001)(5660300002)(2906002)(6666004)(186003)(8676002)(26005)(6512007)(36756003)(2616005)(4326008)(41300700001)(66556008)(66476007)(6916009)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C2qIdiomomRqM8A1aOQff7Qq8h1V9e4TtgoE7cdWmcgk1lOA5sVHgW17/n/z?=
 =?us-ascii?Q?wd386e1E51xukX2uUtf5J5qAv/XgVowf8ng9T41DANMgKRXOh/prV3RH1R79?=
 =?us-ascii?Q?sJhQVdHKNKBHzaw6Kpbzadhi4guo35aKAdg4b86ZnIhE72pI40Db7+qt2di9?=
 =?us-ascii?Q?n27FGmRC2YookErm2qnCv7sjQyrLFJG5TEdu3uHzUouEKiLKU7Xx9YnY2jMf?=
 =?us-ascii?Q?nFM0e2rAG87KcDtdovxcCiCX2Aj1hnzUOMXFc6D7Ws85eNpleVLKdBFH1pSr?=
 =?us-ascii?Q?ilip/5wtoJ0niR2d/+IW38n+BfCKl10Zwc36PrjpnkwCLVbNFju8eJoUK3gy?=
 =?us-ascii?Q?cMsDAa93nWLEx12D0/pI6Burz4ghDW6QXjNXreBk13Ul9LU1xrixsgXVV+Td?=
 =?us-ascii?Q?SirXS+B6Pz+K+hjDeCcE1m9etwRepGtmra/wpnC3YkhBqf0QjaanHqNW+CIJ?=
 =?us-ascii?Q?W3tYYBDGU7nvobCdothD8xs5c0n6YzLe4eXd/ov56BwPB6nbQI7N4uQtvNOX?=
 =?us-ascii?Q?IdI71MPqaAT4NBBNsH7zG6KgYzJTqP3egcjS/Gyv/QMtDI1oxk6HBHPClhA6?=
 =?us-ascii?Q?o223D9oRiaqUlT9NFN73inzRqXnIkBwgfjisi5FMQOwfgGQbI+eiDGCBGf5v?=
 =?us-ascii?Q?40lQopufxiHOecOjeIRhaslnsTth7BVcH/nA6ect7sfRp2MGHFODdvLW+5Hh?=
 =?us-ascii?Q?ZaG9Q4kZ2xMiVOGnRM4A/T/zOi7o1ZGPL18xWiRno22MnSvilCFizGCr1YSm?=
 =?us-ascii?Q?yqwSWTUHPOyJ7EN/F5wc8/Y6P/Taf2uHN5ZcqsqJj2y2Ofbv3Ugk5+Wd3tQ/?=
 =?us-ascii?Q?qQ2S6lXlj0/EAeYXgGmoVBOHhUS7cs8DNaab4XN6cCQj6lWahFYDvhd0xx5H?=
 =?us-ascii?Q?GaGJLPMynEkRypZR897Mg+nwrtuJQKgJWFPRI6nGc0LXz4lUfvVFEvb5X+We?=
 =?us-ascii?Q?KtVmxgYa0H3+ES6Xa4q+VcBSiKaTDekoFiLCWjWwIdBW/yo4B5AUjnyjWWOW?=
 =?us-ascii?Q?N8VIUHwrION5I/oCwSCK7c1JgGQM2E6zU8TTVy5cRno3gZkf+xOiX5GnXEG2?=
 =?us-ascii?Q?ygEimmrq8uS7CJ8CT1Y1AO9yfCy0W9Zxf483lApI9KBk9WXeBfwDzWSrcL7/?=
 =?us-ascii?Q?5DcRmkfYU0ToUoLVYYoBSeVEa0AwCs/dRfa9nrqCZPJVkow8ZjFVcMtm59M5?=
 =?us-ascii?Q?LIveV6owvKB1MXVYXwo/+HGUCnaeacQvAM9M3ljXyhIUVxT+Qjp5WJeI78XQ?=
 =?us-ascii?Q?gxPV847dpL2dLjBfy3r/tuhzseynqFnLPwn0GHtUcrsDZCtnVpwAl0ggopOV?=
 =?us-ascii?Q?sof7cz09xrB932K2pvv69RJrly4TRMxDerKCdaJHvFAN9oz55RasHjkAeWAv?=
 =?us-ascii?Q?KIBAJFEM6XD9SgHDzD3IZgk6WKxBZflr8DeUzJnvttBxWYSCEHR1F97sTaE+?=
 =?us-ascii?Q?oyOYwNmQCcXnU+CjzsbkrnmdVmhHLUmcyx+i7Kr/19KXfnzHEYBUT/cD/gRP?=
 =?us-ascii?Q?OB0gGeGZ53c4YdPEHxfKo9hOVKfYqeltS3XwUj25L+S57lf4ZhM0Y5C/xCqz?=
 =?us-ascii?Q?rgHPp/OdhFNBrC/JDhUOOly9POq8O7mlV9rDopvjR0cCmsGrjM3wpyGPuw+6?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceff6723-4070-49ad-a150-08db04b59b67
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:37:04.8252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3A2NKQVPbqTXJgwKQKfDcyiWoSXJuea7HIgs36jy3Jxa8PXXcUHdyniUg+SXTWPUHo1IKsyDe/LheHgF88xtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8362
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume that the mqprio queue configuration from taprio has a simple
1:1 mapping between prio and traffic class, and one TX queue per TC.
That might not be the case. Actually parse and act upon the mqprio
config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v5: none

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6e0b4dd91509..130ebf6853e6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -136,29 +136,21 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
-	struct enetc_bdr *tx_ring;
-	int err;
-	int i;
+	int err, i;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
 	for (i = 0; i < priv->num_tx_rings; i++)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = taprio->enable ? i : 0;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	err = enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
+	if (err)
+		return err;
 
 	err = enetc_setup_taprio(ndev, taprio);
 	if (err) {
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = taprio->enable ? 0 : i;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+		taprio->mqprio.qopt.num_tc = 0;
+		enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
 	}
 
 	return err;
-- 
2.34.1

