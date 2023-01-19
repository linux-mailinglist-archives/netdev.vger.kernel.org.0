Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C04673E29
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjASQFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjASQEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:51 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368296B99B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGiB6OC/mcQyG/PxokUN8Mt1WahaP6CYxkXCvl3LW7k7HmLMTrmx4KVKdmLlLTw1HKAs7RGqthe64wxm/IeGqVJhyaGJILTjBpDv357mattYXQk5yPzOU6fwyxiVam4V/pMcTxVe4+cjBtNEVh1P3304dwtf4S+bZAm+4G9ae79woT2NL1kR2mFd8EuwLdPNM6Y4sFGwHkr7JIO01hWVMIAEr6pA16Z4McGiqJlzKQsQ9asgnQGGbUfR94hOsDrUNn3JoXQuWARwIA9J035r2V6ncdfkzE70uUGW2BYGD1zZKy13Q54FNXMLzimv6g7jdoxrw5N2pLbP9GQTEchj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwwJnn6YIIEoVPgCa2P9mJpSa8pMIcVAQpLAEBNCO5Y=;
 b=UDt1oRBDm1s75Jxxb0VRwE3vad/p21FFuG+5TMPSn7JqLR/fe4FANbosIwQmd1AxZnmgUPphutFM6ZyIFSNVO9kKz+HqmY3rC6mVb4MXI3aokVO1VPcByQxm1+vGyiyBJkRghc9oPJO53t6EDtpwZ6y5oNlMvcdrN5vHMwlNBMxxciSw7WcSI5261SDr5ysqbvKlwm/zS5NelWDxuJDLx2nrER0GN+Qwf5y9I2fRL3epb6MgpdA78v29PcrJWWulWVJNTyxcSdpAhBM+NHFu/D8NvI/6aLVyrn2FZEaIiSdKpyNFpeLrTepndcoj41fu0XE6Y4Rq3g8awguQQw8l/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwwJnn6YIIEoVPgCa2P9mJpSa8pMIcVAQpLAEBNCO5Y=;
 b=lAayQW5muBu3e2OdYMUGqCYgC2cO10LPU3Dht3f2Ltkq2JuxLY5TRbqlGehrpxVcS4pOxVYbO8taPnNqCouZQXGvyaxxAADylJsrB4Pnsk1mqUjFLPcNa7nWlGdropgDVNRxHwCdptu2o0JlpwnnBj1odCQTo52aVr/g9cZiMjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 1/6] net: enetc: build common object files into a separate module
Date:   Thu, 19 Jan 2023 18:04:26 +0200
Message-Id: <20230119160431.295833-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 68caceab-b662-4418-b6a0-08dafa36e064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ar4yTQCC1PTvykrKqx74I+/bDAkNE0VbqS8a5qI43YjK3GPUgY4vDL1E66GJYlI0/q/Lm0TUy2h89dAbHShMQxP0yRecwmN+OHK2Abquku4sFS+VbeoGnJAG0NyyxsVgMZ+FdQqlbDsL2xRyln1mVSFFXKcG2+4FYtmr7+mQQ0YcA6X1QqqcJg8vylgg6TPX/NCahkgMMDwG8yNbDgupz7Gpr8mJftCPpg/PODTwKgZr90+nGJfADzPSNQhTtFsZqyIvjiBXN24BflE5buvAwejCKPJyDXb3ZVyuWy6BbKKOH944OOo/Jv65MjMNUmVJ1IndxJ8nnZvVeuWadGMBe8wZTO1ca6bYZsxkpeqNF/okNjUrs/f76oVawpGrczhnSaBiot8yKzLw+XCMyv7KePR7J+Pao8f6niotmzIPxx5/9+p4/D3q9XhgYzvUAuWipovIK91ZbPRYRWDrJiCh1tU+tvF/3IlPnklXLckydsaH13w4GDivgpO+8HPbbWDcYJefTaTURa6C1xmf3fZA7cN75SJ0e1Cj3s9svUkS2BXL8u+RD5x2nfoz34vc/8XcKuIqdCBHZwxtBEN9Yk91kLrS/MjQUtAcspTXpiy3oQTR7JQoUlR77dhhKol/vPBxYMADCw95nfoV6lDTufFM808Wa/XVkNmFtYA87d79XlByFnb9/yL3MICWoLmFK7MPYNRKcTz165rTBNvrI6RVsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?inxaxtYVdOUZNgzGrlIII7mWAFrgMY2RuLaQpE2Pi+L13dFB2l/BHYlxsv1+?=
 =?us-ascii?Q?q3lhTkXAb5ACImfDLsGgpSCVG0AP+MdScGJoDSVrR4jMXwXg0AjAneTbY3qz?=
 =?us-ascii?Q?+uRqyYaMvUufVAZoYj6sSddA6Gu2NFHqTBYI8ym7gMr2YEj66z1dh1oevnwy?=
 =?us-ascii?Q?x8jWFuxWPS/B0vs8gI7/fl/THZ9rpio5g6+uU7uTZWXrroBay7s1LeD/7Hs6?=
 =?us-ascii?Q?cyk6kQEA+xA1oDU2R6+dnYogkX+3vjQzWI4K8PCiWa8aYSp48lEZ95613u87?=
 =?us-ascii?Q?Hz8HyxmqD6RC/1sdyjkOT25i85oa/CetBnxSArJchZU6ItFhaq+BbZvua7AW?=
 =?us-ascii?Q?7ONs/efQ5fQ/+9uWtyEg558MzH05QYgiFRq59nIH0B05RhgmY51GT7iQjNtG?=
 =?us-ascii?Q?2EnUOBgfgzDpLRqn2dqEuuA+6gbyavYKgc8nALmzI8o+/4EqCgmqOPxHpPAB?=
 =?us-ascii?Q?YVZx3zjy8KvwTtjM9rW+fAFgVzU5nT5NQJDcIXTmJX1NiPuyl+NBflUUYrsS?=
 =?us-ascii?Q?K8ikcNB9rnwJuj8LTzRJXydl/SMeJc9Kt8S1p8BVjbi7pmEI/eXOQUArppUB?=
 =?us-ascii?Q?XuHEtONcjdizL+IDFgO34gAcYoRQjigr/PJwMxi3+brWFop+M05H0M4ntkuY?=
 =?us-ascii?Q?nJukvjdUTLmVkz9kwQTXC0salC80Cs9ltCJZkBhaGQCWxhREMO5iN4ptBy5n?=
 =?us-ascii?Q?SkmtFWnra1Wnd0RHCF08v+h6t7CGTQfXw+anoGlXkNzsznGfJ9x+lg3ekTbb?=
 =?us-ascii?Q?YP3nwUAV5rz46Tt6Hsr8G8K0CFzT8Mdl6Ps1Vd9XhaR/LpspSnl4NcBGyde8?=
 =?us-ascii?Q?8zx8Xt3dhw9XEFtojevv9EyexKeVQtVg/FHA/VKqs9aU96y9ApUuiJz2kgcf?=
 =?us-ascii?Q?FcxGCqJeU0aliHDrMlJKbUtelE4G75ad3XnJFo7OmwDnaih0RQKvuEL7uimW?=
 =?us-ascii?Q?5O2N/cLl3VDZuygdTjlQkuHnLM+gl4Gt7B80mp/GSjMEhbEYxQ2oB5x6wLEV?=
 =?us-ascii?Q?nWucwLQVxyr5o7AFGII/jLr06YNS0lO0RTRzo+z02otImWkCMzwC9M01f4sV?=
 =?us-ascii?Q?Fhe7Ph0FAxC6L7F/da2N34Y82xxHGdkKnyYIMqm3636toF7kTVAUS+ZfQMvU?=
 =?us-ascii?Q?kG7F+QC9tzw1Q7K6T30nYHQH04YbVbPwMiDm1N5Xi4KoPdldARIOi4xZIUQc?=
 =?us-ascii?Q?6KojMmRi3YtxL0EXCKbPLFeBrYlWr0Ok4hH4sySczx44/OfUqr+c5a8D3jP6?=
 =?us-ascii?Q?71ii3UV2I4YXiBJJCuWQF6ShM5jgO6x3GZAhST2gwa0hRKnV0JoYSH57nicb?=
 =?us-ascii?Q?GxqWBoZmI9l3u8KagvMDkZY80AEW2en5fQA09tzgAmJT/TmdYsWr96MFeEHw?=
 =?us-ascii?Q?eKnETf13yqDai1H7+NpWaEdErtoGOWHk7LrM0ieg+20Kxl/Vjdo4F3mAqElE?=
 =?us-ascii?Q?80D8JkMSgmkf0PoEvAN0PRHSU5Utun63rcWW+7OTJRf7gXRSDY9ekICPV6A2?=
 =?us-ascii?Q?Gm7MFwm/1d3JZ07nA/2/E/vMCUS8T71sAE8D76jmVj1CmlZ/bEdJxBluGSKC?=
 =?us-ascii?Q?guCueuqpDWzVJwpEpePurqle3Yv3KChTwemHWIIIdbNqKHeEQEcEGzlGb/UG?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68caceab-b662-4418-b6a0-08dafa36e064
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:42.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJIKu8rJSvrh7fRMxUUIUW1bTJ8OX/q8jz3Abd4qiSQzNXQ/gLfo+AVMRBepTo6vCC+6X7FeAWefaX3PVX4HCw==
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

The build system is complaining about the following:

enetc.o is added to multiple modules: fsl-enetc fsl-enetc-vf
enetc_cbdr.o is added to multiple modules: fsl-enetc fsl-enetc-vf
enetc_ethtool.o is added to multiple modules: fsl-enetc fsl-enetc-vf

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  | 10 +++++++++
 drivers/net/ethernet/freescale/enetc/Makefile |  7 +++---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 22 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |  8 +++++++
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 ++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 6f6d07324d3b..9bc099cf3cb1 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -1,7 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0
+config FSL_ENETC_CORE
+	tristate
+	help
+	  This module supports common functionality between the PF and VF
+	  drivers for the NXP ENETC controller.
+
+	  If compiled as module (M), the module name is fsl-enetc-core.
+
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI_MSI
+	select FSL_ENETC_CORE
 	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
 	select PHYLINK
@@ -17,6 +26,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI_MSI
+	select FSL_ENETC_CORE
 	select FSL_ENETC_MDIO
 	select PHYLINK
 	select DIMLIB
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index e0e8dfd13793..b13cbbabb2ea 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -1,14 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0
 
-common-objs := enetc.o enetc_cbdr.o enetc_ethtool.o
+obj-$(CONFIG_FSL_ENETC_CORE) += fsl-enetc-core.o
+fsl-enetc-core-y := enetc.o enetc_cbdr.o enetc_ethtool.o
 
 obj-$(CONFIG_FSL_ENETC) += fsl-enetc.o
-fsl-enetc-y := enetc_pf.o $(common-objs)
+fsl-enetc-y := enetc_pf.o
 fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
 fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
-fsl-enetc-vf-y := enetc_vf.o $(common-objs)
+fsl-enetc-vf-y := enetc_vf.o
 
 obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
 fsl-enetc-ierb-y := enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 6e54d49176ad..91f61249451a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -651,6 +651,7 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	return enetc_start_xmit(skb, ndev);
 }
+EXPORT_SYMBOL_GPL(enetc_xmit);
 
 static irqreturn_t enetc_msix(int irq, void *data)
 {
@@ -1388,6 +1389,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 
 	return xdp_tx_frm_cnt;
 }
+EXPORT_SYMBOL_GPL(enetc_xdp_xmit);
 
 static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 				     struct xdp_buff *xdp_buff, u16 size)
@@ -1714,6 +1716,7 @@ void enetc_get_si_caps(struct enetc_si *si)
 	if (val & ENETC_SIPCAPR0_PSFP)
 		si->hw_features |= ENETC_SI_F_PSFP;
 }
+EXPORT_SYMBOL_GPL(enetc_get_si_caps);
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr_resource *res)
 {
@@ -2029,6 +2032,7 @@ int enetc_configure_si(struct enetc_ndev_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_configure_si);
 
 void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 {
@@ -2048,6 +2052,7 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 	priv->ic_mode = ENETC_IC_RX_ADAPTIVE | ENETC_IC_TX_MANUAL;
 	priv->tx_ictt = ENETC_TXIC_TIMETHR;
 }
+EXPORT_SYMBOL_GPL(enetc_init_si_rings_params);
 
 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 {
@@ -2060,11 +2065,13 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_alloc_si_resources);
 
 void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 {
 	kfree(priv->cls_rules);
 }
+EXPORT_SYMBOL_GPL(enetc_free_si_resources);
 
 static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 {
@@ -2426,6 +2433,7 @@ void enetc_start(struct net_device *ndev)
 
 	netif_tx_start_all_queues(ndev);
 }
+EXPORT_SYMBOL_GPL(enetc_start);
 
 int enetc_open(struct net_device *ndev)
 {
@@ -2487,6 +2495,7 @@ int enetc_open(struct net_device *ndev)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(enetc_open);
 
 void enetc_stop(struct net_device *ndev)
 {
@@ -2510,6 +2519,7 @@ void enetc_stop(struct net_device *ndev)
 
 	enetc_clear_interrupts(priv);
 }
+EXPORT_SYMBOL_GPL(enetc_stop);
 
 int enetc_close(struct net_device *ndev)
 {
@@ -2534,6 +2544,7 @@ int enetc_close(struct net_device *ndev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_close);
 
 static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 			     int (*cb)(struct enetc_ndev_priv *priv, void *ctx),
@@ -2642,6 +2653,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 
 static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
@@ -2691,6 +2703,7 @@ int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_setup_bpf);
 
 struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 {
@@ -2722,6 +2735,7 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 
 	return stats;
 }
+EXPORT_SYMBOL_GPL(enetc_get_stats);
 
 static int enetc_set_rss(struct net_device *ndev, int en)
 {
@@ -2774,6 +2788,7 @@ void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 		enetc_enable_txvlan(ndev,
 				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
 }
+EXPORT_SYMBOL_GPL(enetc_set_features);
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
@@ -2861,6 +2876,7 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 
 	return phylink_mii_ioctl(priv->phylink, rq, cmd);
 }
+EXPORT_SYMBOL_GPL(enetc_ioctl);
 
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
@@ -2962,6 +2978,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(enetc_alloc_msix);
 
 void enetc_free_msix(struct enetc_ndev_priv *priv)
 {
@@ -2991,6 +3008,7 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 	/* disable all MSIX for this device */
 	pci_free_irq_vectors(priv->si->pdev);
 }
+EXPORT_SYMBOL_GPL(enetc_free_msix);
 
 static void enetc_kfree_si(struct enetc_si *si)
 {
@@ -3080,6 +3098,7 @@ int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(enetc_pci_probe);
 
 void enetc_pci_remove(struct pci_dev *pdev)
 {
@@ -3091,3 +3110,6 @@ void enetc_pci_remove(struct pci_dev *pdev)
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
 }
+EXPORT_SYMBOL_GPL(enetc_pci_remove);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index af68dc46a795..20bfdf7fb4b4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -44,6 +44,7 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_setup_cbdr);
 
 void enetc_teardown_cbdr(struct enetc_cbdr *cbdr)
 {
@@ -57,6 +58,7 @@ void enetc_teardown_cbdr(struct enetc_cbdr *cbdr)
 	cbdr->bd_base = NULL;
 	cbdr->dma_dev = NULL;
 }
+EXPORT_SYMBOL_GPL(enetc_teardown_cbdr);
 
 static void enetc_clean_cbdr(struct enetc_cbdr *ring)
 {
@@ -127,6 +129,7 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_send_cmd);
 
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index)
 {
@@ -140,6 +143,7 @@ int enetc_clear_mac_flt_entry(struct enetc_si *si, int index)
 
 	return enetc_send_cmd(si, &cbd);
 }
+EXPORT_SYMBOL_GPL(enetc_clear_mac_flt_entry);
 
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map)
@@ -165,6 +169,7 @@ int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 
 	return enetc_send_cmd(si, &cbd);
 }
+EXPORT_SYMBOL_GPL(enetc_set_mac_flt_entry);
 
 /* Set entry in RFS table */
 int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
@@ -197,6 +202,7 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(enetc_set_fs_entry);
 
 static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 			       bool read)
@@ -242,9 +248,11 @@ int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count)
 {
 	return enetc_cmd_rss_table(si, table, count, true);
 }
+EXPORT_SYMBOL_GPL(enetc_get_rss_table);
 
 /* Set RSS table */
 int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count)
 {
 	return enetc_cmd_rss_table(si, (u32 *)table, count, false);
 }
+EXPORT_SYMBOL_GPL(enetc_set_rss_table);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index d45f305eb03c..05e2bad609c6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -649,6 +649,7 @@ void enetc_set_rss_key(struct enetc_hw *hw, const u8 *bytes)
 	for (i = 0; i < ENETC_RSSHASH_KEY_SIZE / 4; i++)
 		enetc_port_wr(hw, ENETC_PRSSK(i), ((u32 *)bytes)[i]);
 }
+EXPORT_SYMBOL_GPL(enetc_set_rss_key);
 
 static int enetc_set_rxfh(struct net_device *ndev, const u32 *indir,
 			  const u8 *key, const u8 hfunc)
@@ -924,3 +925,4 @@ void enetc_set_ethtool_ops(struct net_device *ndev)
 	else
 		ndev->ethtool_ops = &enetc_vf_ethtool_ops;
 }
+EXPORT_SYMBOL_GPL(enetc_set_ethtool_ops);
-- 
2.34.1

