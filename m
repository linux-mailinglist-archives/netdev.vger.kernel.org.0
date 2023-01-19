Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97F1673E30
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjASQFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjASQE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:56 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8440E6FF9B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq8xlvHnP18VTjGc7/0OowurmkUtbwusJUCwIRWmIB9bavzgMdZN5RIvfutMl5BWDO+G7Va+AmmSxaWTOor0q5d84mZbKWVGDHkzFeDh2PaSbH27l02AnWA1YNNuImH2yEVMbpgZaxOkOZtNhodFFPIUYHX+kskctok2AvwHIXBoygJr6Unud4o2moqVqp0mQFFjvl7fkCcnM2W0iJLbIDzVecezuQEoWm4LA8TpW0ydNp5ou16vsGVaQNPIBdOsiS1EdvBCYoUzlAEQeYXBtVT1FDztjjJ4Y9FXwebDb2qiemNCOKdvgoLXFktRFy6Z5VGV1wxlOE3JlBrlrxumSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=So2D3jSd66oQjyxQhS3A98l2KwWIc6aKvXOKeJvvGrA=;
 b=GTrUygff56MiXMv6n61YJmKAH2P3N1/fIJZNhkiqxKM4072BRRII5vVhw1GgPcpe0Y0CVFoAgTVJL6Eax1Y4V/tjN8tNySbuqwvcVszeoa9k6HX9/b3BUMRzcWrUw4r7CCbxw5CUFqSl0TweUpZTOyHHPgm6eP+yjtSwmZogrTyOZzgha8ekncswW39siZcLYIs7qEZtlQgKrZmE3uO83/q8AtDGLUoXgaVrKJ/Uhr2xDnp5MfSRGnSwYkmEWl66gk8tQ3pBswoWJe+ckxfzcOuibZuldVkP0GkWCvTF2+vHCVFZC3d+vOGy+AeSbyo8BRESkYrXurOMnRBEKRQujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=So2D3jSd66oQjyxQhS3A98l2KwWIc6aKvXOKeJvvGrA=;
 b=izRCM0hQel1VUhUV/3vx3Qr/QLWalb9oYSHASYuba0qtyhtjUaQKAB5p55sKdlvMFfHy94tGt8FkfU+ixMJkWk5X7hswr/ehdRHqvNMHVIlr7UgfooUeMYs5vVsEAcnsOsJng3xt1PtilDSdydirR1qOWojwmDStGWwH8at9JMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 5/6] net: enetc: implement software lockstep for port MAC registers
Date:   Thu, 19 Jan 2023 18:04:30 +0200
Message-Id: <20230119160431.295833-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e37889-1374-4c8d-b3db-08dafa36e2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HxOG82RE7nFDzrzcyANFnon3uHQGRJYvnwhWcEakmJf7hhuaz5f6HLmK5wtinQotf4jITdmMdqf5EodscRNr9TMaU16JOlUUcWebB7AmXOlam0u10U+AMf2/JDbFCST+uJf5MSDeobxAf+L9S4ny/voN0+vDGKBp6bWintQFwcYg/YHzjTBGdoQbGDRTGpjESbRT2GoyXNIJjqQnb7WIOOIH94b7QAI73rrk+ke1kqTczX7mUQIQyZW0w+AvGasurIIRJXkhmn+WvIo05kyom6hNNN4fqperFBa6dM3xAGp5+LI3uqcoTclQxrCueQz0ePayTJ8UAAoC5Vf18debLq4l4hWQgzws9aa/HhNluVvLy8atDdppwDsX2VRE6wKD41ehb9RPvqXlm0UTsU75wA3msalDqzaEvU+q9BQDIGWi7wRjschwx5JWyrxFLgyqnIBR0QzWrO0NsVCVxyhUs/0MFsw/rUmNd6q2zeMpUwyXpkgFSAaLWhjPpcb61TF5aYou8oWl2ndTYzHFM5K6g62+B9yzmCZh8qjyzqC7+lRYp+JTlZQuhgdDyzk8mjjUA4mmyBP08xKjGDuhYzHBjW+Kx72rfOViJ+Z3h0S+ug2bUedLd3F6rNmQPO7F4VKutJOMfd35eBlLKMYod86DTLCl6iQxXbZ3E5F7mVlSy2E331x/k89PN+ptkH1B1okg6EwgU7D10W7pDmRR55OU9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(30864003)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gB/IXyA8eu+ICF8HRrkjfjUZGOzjAvV5SUnwFXABI+LdDxolHHd8LCgP6poa?=
 =?us-ascii?Q?Mc1Fw4GYyI+4cWU76GxiLebTMFdzR0AhgrGO3dkzMV6KuqzGs4fLA5XuwuZ/?=
 =?us-ascii?Q?pFQEBZ8lY4YubwYlazzbbHOy5jYJsdun9BIjBLJtx8/Qz0JrHQcZfkmmx3dA?=
 =?us-ascii?Q?moLUOYs1rgs9cFA07wkJ7o456QmNp8C/B/L8sXD8sqC6uNvBJhU4J1SqCPwY?=
 =?us-ascii?Q?fbK3rDetXvQZB2kRJOXAvvcZ9YZ4JpGp3E00USfAUxtud7MudPgCvJXVFfB9?=
 =?us-ascii?Q?6SfD3xRQzqXhwWVKM7pKe/cFPVV/N7CZccxEMHv5rlyW4vuGLjYpcL5TOyp8?=
 =?us-ascii?Q?H10bCuMB9/1bVbz6qP3UmYkP+cMzw2d8GcK9pXriT3IKNW+m59MT6OWRJiNU?=
 =?us-ascii?Q?laAH6bC5ru+/Kvupc3gFOi/+OoU6CsfAdBZTcBTv4FiRyq9Uvv7X6ktmPMdF?=
 =?us-ascii?Q?xJAZB1VTZUvmSi0bzG1oo2hvbI/bkHiROfSP9dT54Nm0kgK0b+SFgLcD4Ai4?=
 =?us-ascii?Q?vUVTysxQd0Zo/0olvPhd1EG2WrGG1FUXm1zC86jGdalmvAOOgxscrIMirI2g?=
 =?us-ascii?Q?RSKi3kAg9ib0FAlwS7E/z/tXgp51h+/SilJ75TEqrHu2f92toZ/xzI5jX+7L?=
 =?us-ascii?Q?lH3qFPOfSVCXLHTT+N29Jt1Z0Ca0jn9wryQypFJRx1V6eopAlHLziUzXmldR?=
 =?us-ascii?Q?6p+FNz+OPmmm1GYsm/sr1aN212sn9obiobL3joAMCe6bwrydS4oE1Z6R4d+D?=
 =?us-ascii?Q?ZClXg2zaKze4XAkRyJ/Dv4cly9iPi1lv0pD9LTLhtNlrmom7hPHvKDywMAiH?=
 =?us-ascii?Q?UwhtpqOd7mWAbf2oxA8mQ+iiq+qaOymGzi7fJzxv02atx4C5Id89pG8OH3pH?=
 =?us-ascii?Q?i3L9JIT2ZJJ7tDOagDmjD09t52Dmkl2dNJ0vHhVXTvS2TRczVPJIPz+112xT?=
 =?us-ascii?Q?kw+0BLac8Rbf0555N7+nvp85Xn74XKJGGL7RPqair4FcPWzz3VSDDbP5EY/H?=
 =?us-ascii?Q?5U1RPTxja74i+pvlR/C9/xXEhS9UOWhHrrMc1cfdZJMlMekBNziGMtLRvQHn?=
 =?us-ascii?Q?riCwmXF1aWEgv9zJOQsg25cjtZPAuyrqhQuA04wicpQC6IUcFnBMOGRxrNX5?=
 =?us-ascii?Q?+X0wFpinZByd952YvCPQvYAEv728G1479qINoog7Xp4Jvzyh40oish5leDbE?=
 =?us-ascii?Q?Q7qHOtS6waTGwoBYkdG1yM++qyN+YLf+dpCzTSRrr8+UuScVoqo6SJ626IvU?=
 =?us-ascii?Q?p+CgI9U7wWDOZZxXG0NnLSFMmkHSgt0vwx9zYR1teI82lUFkbOIAa22OBOoN?=
 =?us-ascii?Q?qwIjYE1raI/mGjGuVYkWBCPQpGgnUgLHXYyAbQp2jSprXR4z9AMOD2ZIR2VI?=
 =?us-ascii?Q?SGwhQlEt1M/QQ1xCHN7R1uA9zT5TBWzgRwGRaZZXoRVwYLRVTN7NxlnFSgaA?=
 =?us-ascii?Q?tTmtRfju50XaSBqf2GaWpu/xQgUnfdxIrbGqCrGkN748y8dRHrTzg7w6gAPZ?=
 =?us-ascii?Q?nTPapbKgPJzDxVw0Y8BgW/Di/gfHxeOCtH+RQ/KOabRVuU4fIV9F9m+YcWcm?=
 =?us-ascii?Q?L4RnWhBgY6OJjyeZtfySF/94FglZSvjWr+PK4Q9HudEnCtc/725g1VqMPME0?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e37889-1374-4c8d-b3db-08dafa36e2f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:47.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04oFt0db8QcNVmd2j73qHBdk2ugKeKqe0OH24PQU7lEWr3WI2LFsMmnVpS0jfTeCLTVYoWMECe4zSneF6pLD0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the enetc driver duplicates its writes to the PM0 registers
also to PM1, but it doesn't do this consistently - for example we write
to ENETC_PM0_MAXFRM but not to ENETC_PM1_MAXFRM.

Create enetc_port_mac_wr() which writes both the PM0 and PM1 register
with the same value (if frame preemption is supported on this port).
Also create enetc_port_mac_rd() which reads from PM0 - the assumption
being that PM1 contains just the same value.

This will be necessary when we enable the MAC Merge layer properly, and
the pMAC becomes operational.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 18 ++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |  2 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  4 --
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 71 +++++++++----------
 4 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c4b8d35f6cf2..ef21d6baed24 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -11,6 +11,20 @@
 #include <net/pkt_sched.h>
 #include <net/tso.h>
 
+u32 enetc_port_mac_rd(struct enetc_si *si, u32 reg)
+{
+	return enetc_port_rd(&si->hw, reg);
+}
+EXPORT_SYMBOL_GPL(enetc_port_mac_rd);
+
+void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val)
+{
+	enetc_port_wr(&si->hw, reg, val);
+	if (si->hw_features & ENETC_SI_F_QBU)
+		enetc_port_wr(&si->hw, reg + ENETC_PMAC_OFFSET, val);
+}
+EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
+
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
@@ -243,8 +257,8 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 			if (udp)
 				val |= ENETC_PM0_SINGLE_STEP_CH;
 
-			enetc_port_wr(hw, ENETC_PM0_SINGLE_STEP, val);
-			enetc_port_wr(hw, ENETC_PM1_SINGLE_STEP, val);
+			enetc_port_mac_wr(priv->si, ENETC_PM0_SINGLE_STEP,
+					  val);
 		} else if (do_twostep_tstamp) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			e_flags |= ENETC_TXBD_E_FLAGS_TWO_STEP_PTP;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index cb227c93a07b..1fe8dfd6b6d4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -397,6 +397,8 @@ struct enetc_msg_cmd_set_primary_mac {
 extern int enetc_phc_index;
 
 /* SI common */
+u32 enetc_port_mac_rd(struct enetc_si *si, u32 reg);
+void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val);
 int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv);
 void enetc_pci_remove(struct pci_dev *pdev);
 int enetc_alloc_msix(struct enetc_ndev_priv *priv);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 98e1dd3fbe42..041df7d0ae81 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -228,7 +228,6 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PMAC_OFFSET	0x1000
 
 #define ENETC_PM0_CMD_CFG	0x8008
-#define ENETC_PM1_CMD_CFG	0x9008
 #define ENETC_PM0_TX_EN		BIT(0)
 #define ENETC_PM0_RX_EN		BIT(1)
 #define ENETC_PM0_PROMISC	BIT(4)
@@ -247,11 +246,8 @@ enum enetc_bdr_type {TX, RX};
 
 #define ENETC_PM0_PAUSE_QUANTA	0x8054
 #define ENETC_PM0_PAUSE_THRESH	0x8064
-#define ENETC_PM1_PAUSE_QUANTA	0x9054
-#define ENETC_PM1_PAUSE_THRESH	0x9064
 
 #define ENETC_PM0_SINGLE_STEP		0x80c0
-#define ENETC_PM1_SINGLE_STEP		0x90c0
 #define ENETC_PM0_SINGLE_STEP_CH	BIT(7)
 #define ENETC_PM0_SINGLE_STEP_EN	BIT(31)
 #define ENETC_SET_SINGLE_STEP_OFFSET(v)	(((v) & 0xff) << 8)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 1662e3f96285..70d6b13b3299 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -319,24 +319,23 @@ static int enetc_vlan_rx_del_vid(struct net_device *ndev, __be16 prot, u16 vid)
 static void enetc_set_loopback(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
 	u32 reg;
 
-	reg = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+	reg = enetc_port_mac_rd(si, ENETC_PM0_IF_MODE);
 	if (reg & ENETC_PM0_IFM_RG) {
 		/* RGMII mode */
 		reg = (reg & ~ENETC_PM0_IFM_RLP) |
 		      (en ? ENETC_PM0_IFM_RLP : 0);
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, reg);
+		enetc_port_mac_wr(si, ENETC_PM0_IF_MODE, reg);
 	} else {
 		/* assume SGMII mode */
-		reg = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
+		reg = enetc_port_mac_rd(si, ENETC_PM0_CMD_CFG);
 		reg = (reg & ~ENETC_PM0_CMD_XGLP) |
 		      (en ? ENETC_PM0_CMD_XGLP : 0);
 		reg = (reg & ~ENETC_PM0_CMD_PHY_TX_EN) |
 		      (en ? ENETC_PM0_CMD_PHY_TX_EN : 0);
-		enetc_port_wr(hw, ENETC_PM0_CMD_CFG, reg);
-		enetc_port_wr(hw, ENETC_PM1_CMD_CFG, reg);
+		enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, reg);
 	}
 }
 
@@ -538,52 +537,50 @@ void enetc_reset_ptcmsdur(struct enetc_hw *hw)
 		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), ENETC_MAC_MAXFRM_SIZE);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw)
+static void enetc_configure_port_mac(struct enetc_si *si)
 {
-	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
-		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
+	struct enetc_hw *hw = &si->hw;
 
-	enetc_reset_ptcmsdur(hw);
+	enetc_port_mac_wr(si, ENETC_PM0_MAXFRM,
+			  ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
 
-	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
-		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+	enetc_reset_ptcmsdur(hw);
 
-	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
-		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+	enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
+			  ENETC_PM0_CMD_TXP | ENETC_PM0_PROMISC);
 
 	/* On LS1028A, the MAC RX FIFO defaults to 2, which is too high
 	 * and may lead to RX lock-up under traffic. Set it to 1 instead,
 	 * as recommended by the hardware team.
 	 */
-	enetc_port_wr(hw, ENETC_PM0_RX_FIFO, ENETC_PM0_RX_FIFO_VAL);
+	enetc_port_mac_wr(si, ENETC_PM0_RX_FIFO, ENETC_PM0_RX_FIFO_VAL);
 }
 
-static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
+static void enetc_mac_config(struct enetc_si *si, phy_interface_t phy_mode)
 {
 	u32 val;
 
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
-		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+		val = enetc_port_mac_rd(si, ENETC_PM0_IF_MODE);
 		val &= ~(ENETC_PM0_IFM_EN_AUTO | ENETC_PM0_IFM_IFMODE_MASK);
 		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+		enetc_port_mac_wr(si, ENETC_PM0_IF_MODE, val);
 	}
 
 	if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
 		val = ENETC_PM0_IFM_FULL_DPX | ENETC_PM0_IFM_IFMODE_XGMII;
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+		enetc_port_mac_wr(si, ENETC_PM0_IF_MODE, val);
 	}
 }
 
-static void enetc_mac_enable(struct enetc_hw *hw, bool en)
+static void enetc_mac_enable(struct enetc_si *si, bool en)
 {
-	u32 val = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
+	u32 val = enetc_port_mac_rd(si, ENETC_PM0_CMD_CFG);
 
 	val &= ~(ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
 	val |= en ? (ENETC_PM0_TX_EN | ENETC_PM0_RX_EN) : 0;
 
-	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, val);
-	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, val);
+	enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, val);
 }
 
 static void enetc_configure_port_pmac(struct enetc_hw *hw)
@@ -604,7 +601,7 @@ static void enetc_configure_port(struct enetc_pf *pf)
 
 	enetc_configure_port_pmac(hw);
 
-	enetc_configure_port_mac(hw);
+	enetc_configure_port_mac(pf->si);
 
 	enetc_port_si_configure(pf->si);
 
@@ -996,14 +993,14 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
 
-	enetc_mac_config(&pf->si->hw, state->interface);
+	enetc_mac_config(pf->si, state->interface);
 }
 
-static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
+static void enetc_force_rgmii_mac(struct enetc_si *si, int speed, int duplex)
 {
 	u32 old_val, val;
 
-	old_val = val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+	old_val = val = enetc_port_mac_rd(si, ENETC_PM0_IF_MODE);
 
 	if (speed == SPEED_1000) {
 		val &= ~ENETC_PM0_IFM_SSP_MASK;
@@ -1024,7 +1021,7 @@ static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
 	if (val == old_val)
 		return;
 
-	enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+	enetc_port_mac_wr(si, ENETC_PM0_IF_MODE, val);
 }
 
 static void enetc_pl_mac_link_up(struct phylink_config *config,
@@ -1036,6 +1033,7 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	u32 pause_off_thresh = 0, pause_on_thresh = 0;
 	u32 init_quanta = 0, refresh_quanta = 0;
 	struct enetc_hw *hw = &pf->si->hw;
+	struct enetc_si *si = pf->si;
 	struct enetc_ndev_priv *priv;
 	u32 rbmr, cmd_cfg;
 	int idx;
@@ -1047,7 +1045,7 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 
 	if (!phylink_autoneg_inband(mode) &&
 	    phy_interface_mode_is_rgmii(interface))
-		enetc_force_rgmii_mac(hw, speed, duplex);
+		enetc_force_rgmii_mac(si, speed, duplex);
 
 	/* Flow control */
 	for (idx = 0; idx < priv->num_rx_rings; idx++) {
@@ -1083,24 +1081,21 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 		pause_off_thresh = 1 * ENETC_MAC_MAXFRM_SIZE;
 	}
 
-	enetc_port_wr(hw, ENETC_PM0_PAUSE_QUANTA, init_quanta);
-	enetc_port_wr(hw, ENETC_PM1_PAUSE_QUANTA, init_quanta);
-	enetc_port_wr(hw, ENETC_PM0_PAUSE_THRESH, refresh_quanta);
-	enetc_port_wr(hw, ENETC_PM1_PAUSE_THRESH, refresh_quanta);
+	enetc_port_mac_wr(si, ENETC_PM0_PAUSE_QUANTA, init_quanta);
+	enetc_port_mac_wr(si, ENETC_PM0_PAUSE_THRESH, refresh_quanta);
 	enetc_port_wr(hw, ENETC_PPAUONTR, pause_on_thresh);
 	enetc_port_wr(hw, ENETC_PPAUOFFTR, pause_off_thresh);
 
-	cmd_cfg = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
+	cmd_cfg = enetc_port_mac_rd(si, ENETC_PM0_CMD_CFG);
 
 	if (rx_pause)
 		cmd_cfg &= ~ENETC_PM0_PAUSE_IGN;
 	else
 		cmd_cfg |= ENETC_PM0_PAUSE_IGN;
 
-	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, cmd_cfg);
-	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, cmd_cfg);
+	enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, cmd_cfg);
 
-	enetc_mac_enable(hw, true);
+	enetc_mac_enable(si, true);
 }
 
 static void enetc_pl_mac_link_down(struct phylink_config *config,
@@ -1109,7 +1104,7 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
 
-	enetc_mac_enable(&pf->si->hw, false);
+	enetc_mac_enable(pf->si, false);
 }
 
 static const struct phylink_mac_ops enetc_mac_phylink_ops = {
-- 
2.34.1

