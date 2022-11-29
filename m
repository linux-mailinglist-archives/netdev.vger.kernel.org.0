Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F21463C22F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbiK2OOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiK2ONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:37 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0673863166;
        Tue, 29 Nov 2022 06:13:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNeE1lDN+ujcBuTwjnX8uV9ouOmoXSK1yMcKeSUYQ5U40f7MhcAr5sXvYyRIFtEAxhrB92EWZ6WiBaHe+4T142NJuFn5I9DyYnsKW8Ogig6/iEFk26PCV51FAq+uZkqwucpniozuLTT/DM1etGGIvD0q80KF0qB7+js5taAr01+3Fo0BvsdgBA9JGOCjnyinlvSP5jFnhfuvfgFTzksQX7Azvp8Vin6HlGrj5dwRkJLet5sz+a7HpTRYXUWVpGOO0+HJ6mGZ1uZSemxjQDAi6o1QjERe8IViTZqVwY6DOKM1wjVK5OyvCoE2bWoOnDTgJCIeHJIKo0mOufLn5JZ1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QAtaRV0C+Z3+aEriBMS7k9n4LGnA0VNWc3a8OR/BNo=;
 b=RleKIcGveG+woq4EaXTNFleOfBai11YSEEsJtjWuxMPLchVak/hD22kd7YV/pk/oNLmzX8pbzT8ym549OrKnSnrz1QaZwMtHUiDn/+SuvRTIPj2wxbj2L3p4RoF/JbfaZX0gZDSiWw7jGCFMV5kOiT5fyndpGfjqCPHSwR08ISLdMz29Ssm9Xr8GcVl5hRr31T0oGT+8Q2bDCWNV44Cw8yPdvCKE8sqDXie/1ZJq9uFyNXQsyo6JmDeMu2Lvgap9N+WJx08ewLDWjmjSXpaRNq+DUdk4JPqSBYNBbdQ5B/RzYfPVW1aN7Jk7ImySVjahsce2tgL7pRmrCsn9fC+p6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QAtaRV0C+Z3+aEriBMS7k9n4LGnA0VNWc3a8OR/BNo=;
 b=m1SX1UhxhxwYGgW4CutXkW6KHHHEBotpsMwCvx9PLPE59BITmbp1uBaOeFI8NRgBB5muXvap0EpS6F2nmzpz8EBUj154ZSDzFBUe3gsHgDwVgLMjbir+Q8IRa2TLzkMAdNaj4DxyWckuOBcQryaQiQyWq+NhfaM2r88O01b25qM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/12] net: dpaa2-mac: move rtnl_lock() only around phylink_{,dis}connect_phy()
Date:   Tue, 29 Nov 2022 16:12:21 +0200
Message-Id: <20221129141221.872653-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 3762d2f0-176a-47b2-85de-08dad213c7b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXh4mIFOEXeoU+ygXlicYdRPM07iVowEf4r13pJu2GVKCirvgRqJDbJZ+ePKmpojXDm8zOZcNyMNicF0RMSMksEloziAsgRa2dSIYfUK5+Jjl2IVRRGyaTZ+LUvpMVdQBiuL0cp9u7pYuoZ5bJdLFy7l1V6FAq8mqJFCJoXR3EUdWYlz1rsyDWMyYW/J4jOl+SwGJYojMrUGr5sSpy8V3aMWTQqM/SZtO6VE34pKYnjFpiczDgmr8o6wQ1vGw5j73PBS4oAVH5rNZ9hWZHSAbAyddbTzZ6cgOx8aoUnTl3SbfjGhppO6mpJIKHX1uLtH4CitmK12qCpCSdhLzaFNzQe/zRLH3wbZtPp7lMjFiGZ7rL9oma1OPoMUJPIDoAU5KCtTp+UcgE20jAMUAQ8dUPyNhPLxcLboz4D/p5YLUuv/vGJ25ZGcTidnyZyRdPhoVzn0/+0iApx+m9Id0xyI8uCajjshtYtOBjUx+v9DbHTwO0BWyCwqnjMC31LyIhsFTcYdq2Ey7IEIhcQmFY6ydEhqRz9VpZ6Qp+imOpCuedX7yUjD+nTKYCbpymqLfCkVeYTr5+qowfiUhOAE3A09Cg/rdlXnKMt2deHyBsIdk7RalvCg34VaPVkI1ZEEYkbwpgPWLhzPaIifjBolqJTfPgLD6Vn118oPI20MnkZ/q85vyFh/BX1XhHTduoMxJwSo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vbxhVYULV77L4r60XjkbGh3rCpI6QA1awIehrYYHy2gtbHboH0z1p1jO38KE?=
 =?us-ascii?Q?Z0J45dI6BhOi25Jn9PUvK0l4koJqVoc433QQR4eoEqGkT0tAQg9QTGvIKThW?=
 =?us-ascii?Q?0yjidHM6NYlW7LW0dLrbGVXn43spOQRaKHv0fgP+yUPrUX3TxlgEzWXfszZr?=
 =?us-ascii?Q?HwL2NFrTm80FfaOFRhmgy49YNnwa/Q9cXJk+BwAUiRVS/krmyGNvM/+fR6NY?=
 =?us-ascii?Q?wwo6IcWGc5nohDz3mHS8uTYzjcxSC0IZpiTjNhh4SiOhxjjNCgPe+Laka8LG?=
 =?us-ascii?Q?8Alo8Vveeq8sPI//7sBeX31Jmq/+M/PUd1JMtcNqatYa7OsA7St3Q9akrwBJ?=
 =?us-ascii?Q?4rqxObTztjk90HZkSHabp8Bhx7sEMglfVA2El0rcDEZR9WRpo3dJAOj0nqB6?=
 =?us-ascii?Q?8n55O8c6EEphtVEMDcM4G8eYaut32zm45qD7WmMnPnv/8EfYxdHfnSmc/awg?=
 =?us-ascii?Q?YvwP97jb/ssi48FBUEJRQU4upO1rgP7hsBaO9jD+xbPDUSW1rGns9y69obFz?=
 =?us-ascii?Q?ewdfkpD2PhXp1TH30kGdFjzQeNxz3YFx8C+s5azs/OnYIMl+XPq2BHXbeyW7?=
 =?us-ascii?Q?1EAfaEdIJoE+HjV0aK8vZuBsrl4YZp5SWuL5ntt9XyEIhRCtjeQSGmPbVuxM?=
 =?us-ascii?Q?twxXujOvkkO5+541ynPl2RU17qiE656ku5NppalYGxTbD6i1YI8+REqmkg2B?=
 =?us-ascii?Q?j5p5LNYjojv07lKjO1dlpLLyDThuwsY4Jx5g7KK2zwBH2qIHGT1rZKagCQlh?=
 =?us-ascii?Q?DP040q2/31A7CsfcsA6k0s1c3Yrw8ONqIf6/8zHSSX2N+Qc22ug5M+7z8Q1o?=
 =?us-ascii?Q?3sdUPr4Ajfdx7aVo60XB9wGguwRZsUdcKBDx2RArcPTNhnjfnTVoFR1UVZWy?=
 =?us-ascii?Q?LlTDj//oowdqIYJrvBS/d42jidQBbtZ0aSxy7SFw5+VeqJBC/8fedYkFhC2W?=
 =?us-ascii?Q?VzH5XrUWjSP1fDTvVQuPc98pLpiSyMVbG1KYjbIkShNz6jejCQZrzHNMqaAi?=
 =?us-ascii?Q?mBHDy5ayPhgD+POPjQ1hggxnC5EvVBXiF8OsWfDzbLyC/e230nTfawoeDtpL?=
 =?us-ascii?Q?1e2A2g/wXHQiByela+iVSc8fXP1hzDtTuC9WbGyxDmM3WzpuTXRTTFlaTtDJ?=
 =?us-ascii?Q?nX38Xvm6HCCe9EOh43tJGtVX37vvqHyzMMyuSGVPch92nLZE1eYhSdsg24Je?=
 =?us-ascii?Q?Dgg5MYEQMyeB1PXz15241gTGFuaVWZLKpOE1JCWkjhX4aeOBAy2OfB1qiMAb?=
 =?us-ascii?Q?YNyIZGOY69Kw0AEAQRRiiQ0DUu+egwURBzO3ViHsXGaacBZwgmCrK+oG9f9F?=
 =?us-ascii?Q?8Jckfto8s4w3qL3V31t7pOMsuyJVGs9t/UTJcBJtFk8K3fpRJf+Vbn4KCe2B?=
 =?us-ascii?Q?Lx/o3mYU36QzJ78F8dS05nqo4w20b8zEA8nknv0zc+nKeBcxpwU81JBmIKPs?=
 =?us-ascii?Q?u1t4khLrcY/Tt9iIai7yhLN2tUpuLtySoNUwrfvkrznJ3xR6UmMLmoUjiIjg?=
 =?us-ascii?Q?W0Ux23cHho3og2kDAm5FcVZg7DqY4Jo285JIpfdiXzKBESi8Te7S7uayrUSn?=
 =?us-ascii?Q?TAhX8O0XTUDi73qDpOX6WwvNwuBonrZTlAiIaRimthtBxqLE5fd70iM9NWww?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3762d2f0-176a-47b2-85de-08dad213c7b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:42.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPPblA+dXjlJyljNaBEpk7Qjg85Vtp+PwvaW6s+Hpxj2ZpctQZijTRW1mzxQGpALlu8rtsCGRSAbgXXE5P1KZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the introduction of a private mac_lock that serializes access to
priv->mac (and port_priv->mac in the switch), the only remaining purpose
of rtnl_lock() is to satisfy the locking requirements of
phylink_fwnode_phy_connect() and phylink_disconnect_phy().

But the functions these live in, dpaa2_mac_connect() and
dpaa2_mac_disconnect(), have contradictory locking requirements.
While phylink_fwnode_phy_connect() wants rtnl_lock() to be held,
phylink_create() wants it to not be held.

Move the rtnl_lock() from top-level (in the dpaa2-eth and dpaa2-switch
drivers) to only surround the phylink calls that require it, in the
dpaa2-mac library code.

This is possible because dpaa2_mac_connect() and dpaa2_mac_disconnect()
run unlocked, and there isn't any danger of an AB/BA deadlock between
the rtnl_mutex and other private locks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 4 ----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c    | 5 +++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 3ed54c147e98..0c35abb7d065 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4715,7 +4715,6 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 		dpaa2_eth_set_mac_addr(netdev_priv(net_dev));
 		dpaa2_eth_update_tx_fqids(priv);
 
-		rtnl_lock();
 		/* We can avoid locking because the "endpoint changed" IRQ
 		 * handler is the only one who changes priv->mac at runtime,
 		 * so we are not racing with anyone.
@@ -4725,7 +4724,6 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 			dpaa2_eth_disconnect_mac(priv);
 		else
 			dpaa2_eth_connect_mac(priv);
-		rtnl_unlock();
 	}
 
 	return IRQ_HANDLED;
@@ -5045,9 +5043,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	else
 		fsl_mc_free_irqs(ls_dev);
 
-	rtnl_lock();
 	dpaa2_eth_disconnect_mac(priv);
-	rtnl_unlock();
 	dpaa2_eth_free_rings(priv);
 	free_percpu(priv->fd);
 	free_percpu(priv->sgt_cache);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 9d1e7026eaef..8ba4ea4adeb3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -431,7 +431,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
+	rtnl_lock();
 	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
+	rtnl_unlock();
 	if (err) {
 		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
 		goto err_phylink_destroy;
@@ -449,7 +451,10 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 {
+	rtnl_lock();
 	phylink_disconnect_phy(mac->phylink);
+	rtnl_unlock();
+
 	phylink_destroy(mac->phylink);
 	dpaa2_pcs_destroy(mac);
 	of_phy_put(mac->serdes_phy);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 0472e24191ad..f4ae4289c41a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1529,7 +1529,6 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if (status & DPSW_IRQ_EVENT_ENDPOINT_CHANGED) {
-		rtnl_lock();
 		/* We can avoid locking because the "endpoint changed" IRQ
 		 * handler is the only one who changes priv->mac at runtime,
 		 * so we are not racing with anyone.
@@ -1539,7 +1538,6 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 			dpaa2_switch_port_disconnect_mac(port_priv);
 		else
 			dpaa2_switch_port_connect_mac(port_priv);
-		rtnl_unlock();
 	}
 
 out:
@@ -2957,9 +2955,7 @@ static void dpaa2_switch_remove_port(struct ethsw_core *ethsw,
 {
 	struct ethsw_port_priv *port_priv = ethsw->ports[port_idx];
 
-	rtnl_lock();
 	dpaa2_switch_port_disconnect_mac(port_priv);
-	rtnl_unlock();
 	free_netdev(port_priv->netdev);
 	ethsw->ports[port_idx] = NULL;
 }
-- 
2.34.1

