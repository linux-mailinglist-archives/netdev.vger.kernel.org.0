Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF636D354
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 09:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbhD1Hk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 03:40:59 -0400
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:9185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229643AbhD1Hk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 03:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIdRlkHP/4ZJ6eydb0InchF1x+RtWJOyySV2BwlXZOykKVwgQENXFHe41uXeYBvS8pugM+7G73KSe3xT59/SMalVdmNf96BdkTgiRa0BbDz0L2uanHmbdXWtheQCL/OELggOmmQK2h3FZ38ssIQNfAXH/uCbbKIaMdaZsEZO5K+ea9ZgcbiSGZZ0i11xgcqJniJsCWu6uQqKZ4XIs/fzzAii/Z6PI5mloeLNJsNoO6ObXkzAJ6ulk6TeNuu5WAlwgJ0STsATXpHrXj5TR0Ff9mezHpTTPwrr0K1MTjQaXjiQAsJ4aPptYHosLLhH5ScmMmoP1lxlfHQA8SOmKJzaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HShAn68i0G0TRc94kH1DYWm0JIGZytgBlKlETA4SJVY=;
 b=D5r2cHHtJNVKhu5QVuF0jRszk4lC4v6Nsru3s0QsjOW6dC1KobdwVCl6+843OLu8RbTVBslfB9PMgIY4I8fxNO6lT4rHoI9kJyKmeOrBFwnDJBniWh5JYULyfuUnkJOs0NRZwTiU33d6cjAMT59d5HfjaAHxo9t2RSAflgghoBFjddK8EZsBadVFWJ76BBgyKwnj4V3ZbqlTKzIwx0qA2jTGH89YsJNMgXsTfKCR2OqZ20ue8oM0Lp1z+4jzk0t3vf+ogGX5qOd5ILc6rqWcWNxnRCoUWRZUcin0xsMlLqFWUFNl0H2qcncmj+iUiOf5EJbMZ+SzzgfUK12k4cJ0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HShAn68i0G0TRc94kH1DYWm0JIGZytgBlKlETA4SJVY=;
 b=Rp72JTKJLJo6McPaKu9AkRPx1uKiM4JMIzRxBYik75K7jxoTVxbaeUrH5VgeZwGGFA/Z7uRT4AGwxEtM7fqr/WPpT0hpJSGRbM34KGSdLXwyMmAyZesEjgdv4o0EZcQN41u4MlILfabe4mJ0nVMOFa5AZ/hSQzLLVlmFOUpPJoM=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6345.eurprd04.prod.outlook.com (2603:10a6:10:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 28 Apr
 2021 07:40:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 07:40:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     Jisheng.Zhang@synaptics.com, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't support WoL
Date:   Wed, 28 Apr 2021 15:41:07 +0800
Message-Id: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0185.apcprd02.prod.outlook.com
 (2603:1096:201:21::21) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0185.apcprd02.prod.outlook.com (2603:1096:201:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 07:40:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f903ebff-6dc0-4ba1-dced-08d90a18da65
X-MS-TrafficTypeDiagnostic: DB8PR04MB6345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB63454DAF527765EC88580C8AE6409@DB8PR04MB6345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NS09fvDNbtaM/x2m1iJXvIrmEE5eGs+gdvCzJMtBUj+2/T6AalvOWLLby9ym9mAfpAge1LM6oadsYTLn3DGlMsYw0GY/EN16YXmECDWrlTOP7+4XkAZVXSiRVklDbgVSl80Bii4/gb5VrTqn98lVPW0QgWFSOPICXN7U4OuZwr/BYuOgkZZfiRsgd3omVhKYWIJ06kdxX8Ya9d8dEBnuCnkZtwtQtkiqm5shuo+3IMYaXBvL2ilyVUD8VZY4yUKC1xZVoPwF72TwI7BTRPqRmyngOKYpxYjGxxXXlf6f2whiOf1XcF0n0i8Q343+6ZJX/OR100p1rrS3PY7uarUapgEX+tO3knTrTmZuHHVSzr3u0eSpEj+mU/VkGVLveNeKiTa/mDpN/DmOFGEHZNR5R4ljMOxXvewvL+j1v/Rr6k51ILhd4m5wlxAsSVVRfrg6m/ov7YrMCjyEbMcGUQNbhXL0BNJvLkP9RMJM28xnSEfYzTG8pfRZP0IpC7BG1JoQlECKigR/kXCjA1cY7oBmjDnAoGVj/CY7KdzHDdXeqNxt5ZcLdGv3ixMVrmrxsymSjFG+iZB7N6+bGP6LcGlUPzdsIdX1WCPFVSJPhO6pz7KXc2W3j9e4Yjjt18ctfa0GvUQ/gFAGLPT3eDLYFA31IoCrwxdXe0hwLcqVOp1gozL0eHHKWKnKyVdTkpFsV8UGJFfdwvZSYgqyG8vLGrDfGKy0T+c7o9VJTSpm53LBYz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(186003)(86362001)(8936002)(6506007)(5660300002)(956004)(66946007)(316002)(16526019)(52116002)(66556008)(66476007)(26005)(1076003)(478600001)(36756003)(38350700002)(8676002)(6486002)(2906002)(83380400001)(2616005)(38100700002)(4326008)(6512007)(69590400013)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?G8htX/HnCfvIwf/2mGifrxrZwJj5k/GsE2Otu4q/9iaHIgYuXk6wV7bvXk5T?=
 =?us-ascii?Q?eEa+0jU3FPDATl1EoJqI+Nj+dsj+g+/Y3ErvFsGwcRlQOmg84RVMrLql0/h/?=
 =?us-ascii?Q?io7G/tBDPVz8XI+ZJ5EP4uYBkiw3DrnaLK6Yu54wnQY0GTb8U1TIrn05m+Q5?=
 =?us-ascii?Q?GQYdDm8IoldhuQWDxx3/5o5SxS61Isq4vRclG5UukuFhY6USGlTJRW9hpsuk?=
 =?us-ascii?Q?QWI/7vBozt6DchilgfrXMf+UheqRqh+1bfgkXmWYtphLhWmShS+HnWL8aVN0?=
 =?us-ascii?Q?qIus4mun4KP2hVq0ERo7mz7QQeYHH1uVCzquSzi08YCM0UUE3iWUCOlxqspa?=
 =?us-ascii?Q?6nkZBJBtWverqQKREljTvLzEcWkNOZGOEHfTaaHBp/di1tSM0HHagDvz7EPb?=
 =?us-ascii?Q?9xb2+4tcVc1to35UDQ1UqSjNYQHEnWEyHC1rMeBz9BNq2/IG8/LyHhfRI1Nt?=
 =?us-ascii?Q?QFJ9PL3+PHX3sx1KAWTyqJAx5x1dgg2laerK3q5IadE1DOLpzFNYP+Uk4VsX?=
 =?us-ascii?Q?aMIoaACEPw5C9AaRIsSjIWAVMVJ8uMEmo6G4GNxUn8qmYVGyCMsHldGMNusV?=
 =?us-ascii?Q?eZTXstoAeHuVIAKiIE+Sbg3ZHXl7b5bgpQuouwpDoF0Y234c+N/ZsAePDI+C?=
 =?us-ascii?Q?7xI2ZJz96dzeH50a6yV21GQrmCMV6g+HPFThQa3tm5OT663RxveBcIqDquec?=
 =?us-ascii?Q?PI32CyNqNykUUovtQpV1sTaXk4xt2QtnuOs84d2tKbsrFNFPpxpEvgbHtXKT?=
 =?us-ascii?Q?LMTNWwLcIWJo4dB1PFL6m3TYHO9sUyZuOfuqoPVDZNpL8w5mGX4Rh+jBQQMx?=
 =?us-ascii?Q?1637Q1jRuzh/KBSsByBhSZAYQ9U6wQm/y5Aw9T5M/zECOV7FhRWrMtViqTw3?=
 =?us-ascii?Q?BZEywmQux4LOcCGwHgs1qpmWJseMAa5Sv9neX0r+ko2qGCZwpZAcgQMfqIan?=
 =?us-ascii?Q?mGKEjk7fMtajdxieAhWVl8st6rsfOiJll/1c6qLIAdgoFYPHZ0elfDObJnAH?=
 =?us-ascii?Q?So3neS7dtO24x7f+9pEq0qprC+F0jh5yK3Djp4/0PmcP69Wn0QjVIsSYzZ83?=
 =?us-ascii?Q?k52vyzwgYNeQI5Xy9CB9cib8bc+xciNxxxNrJzxoQbc0wyI+O+44zxkDqxKR?=
 =?us-ascii?Q?R1yk3EF+txGZLzkVHmcZKUE9g8DEev1DY/LFVTLH6mF22Oc00sHcPK+LP4Z2?=
 =?us-ascii?Q?/dBiNrF1+ITYEktjwjWK/D9hXjrQyybAg6Ra0EN6UAzjXVw3LmI/lzRDri28?=
 =?us-ascii?Q?LeqxyNMIMoU8Z8c2mV7OPOdb5EyG6tEKpDneDRYLFQUZwES5HruugxisXCkV?=
 =?us-ascii?Q?ikbDCENOmtSAki+z3OwZdOGg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f903ebff-6dc0-4ba1-dced-08d90a18da65
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 07:40:11.0870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yc+IvOc8Jhpvf/2CrDEwemO+m2h3nJS+Ip0eu75r6P5j8PVEXo6K4fY625V70NJMRue5VmUsD2Hg8yzmjLKrrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and set WoL will check device_can_wakeup(), if MAC supports PMT,
it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
stmmac: Support WOL with phy"), device wakeup capability will be overwrite
in stmmac_init_phy() according to phy's Wol feature. If phy doesn't support
WoL, then MAC will lose wakeup capability.

This patch combines WoL capabilities both MAC and PHY from stmmac_get_wol(),
set wakeup capability and give WoL priority to the PHY in stmmac_set_wol()
when enable WoL. What PHYs do implement is WAKE_MAGIC, WAKE_UCAST, WAKE_MAGICSECURE
and WAKE_BCAST.

Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* combine WoL capabilities both MAC and PHY
V2->V3:
	* give WoL priority to the PHY.
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 51 ++++++++++++-------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +--
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index c5642985ef95..30358c1892f1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -630,34 +630,46 @@ static void stmmac_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-
-	if (!priv->plat->pmt)
-		return phylink_ethtool_get_wol(priv->phylink, wol);
+	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
 
 	mutex_lock(&priv->lock);
-	if (device_can_wakeup(priv->device)) {
+	if (priv->plat->pmt) {
 		wol->supported = WAKE_MAGIC | WAKE_UCAST;
 		if (priv->hw_cap_support && !priv->dma_cap.pmt_magic_frame)
 			wol->supported &= ~WAKE_MAGIC;
-		wol->wolopts = priv->wolopts;
 	}
+
+	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
+
+	/* Combine WoL capabilities both PHY and MAC */
+	wol->supported |= wol_phy.supported;
+	wol->wolopts = priv->wolopts;
+
 	mutex_unlock(&priv->lock);
 }
 
 static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 support = WAKE_MAGIC | WAKE_UCAST;
+	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
+	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE | WAKE_BCAST;
 
-	if (!device_can_wakeup(priv->device))
-		return -EOPNOTSUPP;
+	if (wol->wolopts & ~support)
+		return -EINVAL;
 
-	if (!priv->plat->pmt) {
+	/* First check if can WoL from PHY */
+	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
+	if (wol->wolopts & wol_phy.supported) {
 		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
 
-		if (!ret)
-			device_set_wakeup_enable(priv->device, !!wol->wolopts);
-		return ret;
+		if (!ret) {
+			pr_info("stmmac: phy wakeup enable\n");
+			device_set_wakeup_capable(priv->device, 1);
+			device_set_wakeup_enable(priv->device, 1);
+			goto wolopts_update;
+		} else {
+			return ret;
+		}
 	}
 
 	/* By default almost all GMAC devices support the WoL via
@@ -666,18 +678,21 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if ((priv->hw_cap_support) && (!priv->dma_cap.pmt_magic_frame))
 		wol->wolopts &= ~WAKE_MAGIC;
 
-	if (wol->wolopts & ~support)
-		return -EINVAL;
-
-	if (wol->wolopts) {
-		pr_info("stmmac: wakeup enable\n");
+	if (priv->plat->pmt && wol->wolopts) {
+		pr_info("stmmac: mac wakeup enable\n");
+		device_set_wakeup_capable(priv->device, 1);
 		device_set_wakeup_enable(priv->device, 1);
 		enable_irq_wake(priv->wol_irq);
-	} else {
+		goto wolopts_update;
+	}
+
+	if (!wol->wolopts) {
+		device_set_wakeup_capable(priv->device, 0);
 		device_set_wakeup_enable(priv->device, 0);
 		disable_irq_wake(priv->wol_irq);
 	}
 
+wolopts_update:
 	mutex_lock(&priv->lock);
 	priv->wolopts = wol->wolopts;
 	mutex_unlock(&priv->lock);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6f24abf6432..d62d8c28463d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1076,7 +1076,6 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1102,9 +1101,6 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
-
 	return ret;
 }
 
@@ -4787,10 +4783,8 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->plat->tx_coe)
 		dev_info(priv->device, "TX Checksum insertion supported\n");
 
-	if (priv->plat->pmt) {
+	if (priv->plat->pmt)
 		dev_info(priv->device, "Wake-Up On Lan supported\n");
-		device_set_wakeup_capable(priv->device, 1);
-	}
 
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
-- 
2.17.1

