Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A31402776
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343787AbhIGK62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 06:58:28 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:29537
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343769AbhIGK6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 06:58:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nr9o6kNNlOXt2nskRa+43duVl3qeGSzEhxr7yDnBOgN78oV2c2WdXyZu3VbHPnXRXuei8cjprIQU3KI7bJobs+OAA6ffwQENx37O+ur/rl7Y1Fdet/phoNkDPHWK1VSyMZWrg41x9AzGu4tr1jP4hA1BD7bgeXzoxkNvaIMQX6WNiI2vE+kwQ4c7poVVFwd/3/MMHDxGBQULMrxJgOlqv1rMBI1tgIYh4A6rEyVDRFyvEo6zg68TN2SRNIWAafVAG00AiFnd3ECXsl3AVpTL4P0TxIMlVCc9V7EAR5Y9DOh+xY2OMp6PK6zSGRpaeYNU2TDO+LCi/ykWzkIN+FEwmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JwVuoEa3QkcL6Y/Lz52Zn8xRhQklASppkKwvawYnDA4=;
 b=iL571YP4Y+Dknj78IofWFS4h2oWCbTMtVYmewCVSTKzGLYU/5Ag7tGbG12bjkJR73IYGidTHs1BrDrURGw2ZZrD2fq+/8NgNkkqrFI5u0GU727jQmmx4O7IZ2KZHZOK72P0gDx/LhbTIIEMrSqq2PASp3RiS/5SaIJ31PFhMmDWSyo8AENPkewpvR76q2FipVyqYfIDwQfwW45LkgiBfEGe7gA+iAB334WchQVUB4zAx6wOhEks4+DJUeZKGKS9rIvqrbTnCJiQGs96f61zUomRncZLH3l/WvnOmudhgDIEVI/fKUOwiRLzyGooMdaPqjdHUJ5ekQoyyaeVq/b3Bjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwVuoEa3QkcL6Y/Lz52Zn8xRhQklASppkKwvawYnDA4=;
 b=b7MCfkbWEL2tkMyjqH3Rsj/s7PqsVJNX1/Sbkfl125M6STa7ng5+P7gO6qezxjb91RTch6smAGiyzhiLpov5gsEYX6+1vbUCFHkTsVBbKstdOHsRI1tgDoGxpapX0GjtluOaxoRkZzwl6Oh5luCSVAZgRmRiYM9d25ruGQrhvk0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7382.eurprd04.prod.outlook.com (2603:10a6:10:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 10:57:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4500.014; Tue, 7 Sep 2021
 10:57:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 2/2] net: stmmac: fix MAC not working when system resume back with WoL active
Date:   Tue,  7 Sep 2021 18:56:47 +0800
Message-Id: <20210907105647.16068-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
References: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.1 via Frontend Transport; Tue, 7 Sep 2021 10:57:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8676a61-5373-418f-7689-08d971ee3f5a
X-MS-TrafficTypeDiagnostic: DBAPR04MB7382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7382F5FEAC769F77120C8EC0E6D39@DBAPR04MB7382.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sw19x29gMHmlN5hn/Cg98uZZRkPHQzzlUC3X9ygVRfrBrhjDpvMlkQyjcMWY0TPLxm8rOOcu+nih3UXFjkZOKK7cffZ81qJklqw7+FkTnojen9Cebtm6p+1Z2WScX8srB7jaFBur52jGGvIf+gMOyc6C/nNi4IGNWC4RuN1QKhWe6FQrqM/6FUYhVcC72ENsb8bQoyH1Ov/AGSRdZ3ZTP2cnyrPGidOE1Pq3HHSLwAIyOJRovDKZnz9uF1JohUFCROaSdXiIeblfFDAglK4hvG4sbtboQsJxo47iLwpWjupmAUY8ABCDsTwrr6DkGjdJ3KEfzqGuL6FWSsd7EQ4PwPArNpwydb9oLTe3WjzcnbDXRQZlYZ2hv8BqPnYQgNfMHzDkYX6QOMMrg/8+DCmCFzd5nHhgs1LxQ48EWzQhtAs8pc71Aq/xLb5wi65dkZLSLskQ3T7OeCBQdZmDE5jhoU73xZ3PLeLoiVSnfw4FAH5LFrmftWhmVZGRgNNNGHxjE71rmlMLvFHjH2I0I4JqOQfHv0IAv+pDJtwnC2DixqSBb4ofe39HFFcGmzen1F9H5p4Qt3puqw4wgNyg0eWWja2gUm8HhVKyqKblIazbVKrHu132/awmk+C7zP8TRbEaAQhfW0OUHfw1jg1RPkYiRP3yG/Rw+McdPH3JZUV1u8yKvDP7/BZF08sqWCY8xu+R0UMIr3pgyXDUEdsx/8rJ34hba9kdtWCsTEA30VQFLsdXWN/cO/6ihEho70zyHNq/o8TQ55VMUuKR2LVk8laHi/lMSYTZxEZuFQgFvcCf+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(316002)(966005)(186003)(52116002)(8936002)(38100700002)(5660300002)(36756003)(38350700002)(26005)(66946007)(86362001)(4326008)(2616005)(956004)(2906002)(6512007)(6486002)(7416002)(6666004)(83380400001)(6506007)(66476007)(478600001)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SiOBRrnhV8MaHQ6O0ITdd9Q+q+qsfosdF/jqeM7ng+xy9VlpdSf3TUjwXeDH?=
 =?us-ascii?Q?s3eYWwdaZI7RYPQIKtuDKuzn+A82e8X0vsybcK0uP/gCzOnmT7NinNZIU++E?=
 =?us-ascii?Q?hX2l75mijxT68yT+Ej+qjfcl4iqejswGXuL5QZIE4pm44ikqrIg+S7JaKwqh?=
 =?us-ascii?Q?724Ybbg4/2iEFYo+3ABJwGZ9uFHAcfaEQLdhke+ErQjNGh6DqCoSpmK+/Y87?=
 =?us-ascii?Q?u27glGLtnuRStiJVy/1LN8sXubN2GwzrNeC2vfk9j8Irw5lKh6DtFLmAvtx2?=
 =?us-ascii?Q?F8DPaEjQ8auqYt7n7vy1Bn5OsDKO1nYfd9fq5oVDmgmN5cwVEwNg+TEN9/PJ?=
 =?us-ascii?Q?5YnUP7w1JHUb6+dvuvOzNgItcY+sVQ0KA7UhiTnI4vCDTG5H+uP33lZia9A9?=
 =?us-ascii?Q?0UxRQOjZH3sCgswHlLZJd6j7JgLk5/XXKOBdhikkM5LDykJrmqVIT+fkDkaV?=
 =?us-ascii?Q?Nhds19b1A05583zcLfpt5N4vMFkD58caBk6oOhgD9YTg7JMgpBT8MlDF2g/8?=
 =?us-ascii?Q?zHHsOm65Nf0Jrx7YCzZ4Y5r04L4ATwga9nGEq3fARZ6xgl5zuEkxYq7xJ1Hc?=
 =?us-ascii?Q?/ZisoBsKzyV72jvpd+tDZvtKHM0tuAV7akhrJyqlzGHwPQperfopGE8yoq10?=
 =?us-ascii?Q?k4rupj6YEhAu6DM+BTjosrinZfft9FMRp7ZuPcNlYkZPbvhdeB3/dwKbuJaV?=
 =?us-ascii?Q?34BgcOp3yakx9qgjFo2uznef8MoWMh5gb25N/v7wx0vn/g6zf5T204e3aKp2?=
 =?us-ascii?Q?yiZ8jyxjoZIzy+ZSXtjupsRqrkJdXrzh2+8k27vYi+xo5zL7ymtvsIJ4S+sn?=
 =?us-ascii?Q?jVu/MX60pRAIQIuRJGupXWaEc2Xg8eRsXp1QtEEIS8dN0F5AyLEtRTo04Zqz?=
 =?us-ascii?Q?j/eXoJfvu6CK9zUcmUml9Fw+udm2W7XwLvR0PDOKZJMBoGJtC5W4W31l7KIN?=
 =?us-ascii?Q?ukfmltsueMEmeY7Q1WXo+NM1Olyb7toEygr+eNnPA3ANsRO9p1Avp13mM6uv?=
 =?us-ascii?Q?AayesKo81KFtmzzo42DGwBBvq8KVGixfyWif4klLnnprPTBnfHjxwEjRt6jz?=
 =?us-ascii?Q?6EgafX5EVSFZBkeGcx2yhSDr5as1WAk01X+YQRoI0mYbqF66uGJ2ODFUIuV9?=
 =?us-ascii?Q?VRhdo/eNAnhyGW2RPlAe0Lp8eHT1G1FLwslxj7eGBbBwO/EIqfl7wNs5mWIa?=
 =?us-ascii?Q?q7FTDApRzuXJKZ5I2chIVuzqFDHsyyGs346FGoN1GIwbX8ef/Oh0p2bgL6wy?=
 =?us-ascii?Q?+7fouOtjIWcHpwPoX34/HQGoNWkQYkji6vLQZBEe+qG9KjSnEq/Pc5m8Arkh?=
 =?us-ascii?Q?SCi5NkU2vL1ChCg0+MgH304S?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8676a61-5373-418f-7689-08d971ee3f5a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 10:57:13.0575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BMvTbTKOan9FrvJ/nhv9ZFBxU93+B3Wu8FvDDFn+EOfo0LDSp9jHWtQETb9xK1QB+9+8LjxH+kQ60rDbS/SCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can reproduce this issue with below steps:
1) enable WoL on the host
2) host system suspended
3) remote client send out wakeup packets
We can see that host system resume back, but can't work, such as ping failed.

After a bit digging, this issue is introduced by the commit 46f69ded988d
("net: stmmac: Use resolved link config in mac_link_up()"), which use
the finalised link parameters in mac_link_up() rather than the
parameters in mac_config().

There are two scenarios for MAC suspend/resume in STMMAC driver:

1) MAC suspend with WoL inactive, stmmac_suspend() call
phylink_mac_change() to notify phylink machine that a change in MAC
state, then .mac_link_down callback would be invoked. Further, it will
call phylink_stop() to stop the phylink instance. When MAC resume back,
firstly phylink_start() is called to start the phylink instance, then
call phylink_mac_change() which will finally trigger phylink machine to
invoke .mac_config and .mac_link_up callback. All is fine since
configuration in these two callbacks will be initialized, that means MAC
can restore the state.

2) MAC suspend with WoL active, phylink_mac_change() will put link
down, but there is no phylink_stop() to stop the phylink instance, so it
will link up again, that means .mac_config and .mac_link_up would be
invoked before system suspended. After system resume back, it will do
DMA initialization and SW reset which let MAC lost the hardware setting
(i.e MAC_Configuration register(offset 0x0) is reset). Since link is up
before system suspended, so .mac_link_up would not be invoked after
system resume back, lead to there is no chance to initialize the
configuration in .mac_link_up callback, as a result, MAC can't work any
longer.

After discussed with Russell King [1], we confirm that phylink framework
have not take WoL into consideration yet. This patch calls
phylink_suspend()/phylink_resume() functions which is newly introduced
by Russell King to fix this issue.

[1] https://lore.kernel.org/netdev/20210901090228.11308-1-qiangqing.zhang@nxp.com/

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 97238359e101..ece02b35a6ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7123,8 +7123,6 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	phylink_mac_change(priv->phylink, false);
-
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
@@ -7150,14 +7148,6 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
-		mutex_unlock(&priv->lock);
-		rtnl_lock();
-		if (device_may_wakeup(priv->device))
-			phylink_speed_down(priv->phylink, false);
-		phylink_stop(priv->phylink);
-		rtnl_unlock();
-		mutex_lock(&priv->lock);
-
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
@@ -7171,6 +7161,16 @@ int stmmac_suspend(struct device *dev)
 
 	mutex_unlock(&priv->lock);
 
+	rtnl_lock();
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
+		phylink_suspend(priv->phylink, true);
+	} else {
+		if (device_may_wakeup(priv->device))
+			phylink_speed_down(priv->phylink, false);
+		phylink_suspend(priv->phylink, false);
+	}
+	rtnl_unlock();
+
 	if (priv->dma_cap.fpesel) {
 		/* Disable FPE */
 		stmmac_fpe_configure(priv, priv->ioaddr,
@@ -7261,13 +7261,15 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
+	rtnl_lock();
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
+		phylink_resume(priv->phylink);
+	} else {
+		phylink_resume(priv->phylink);
+		if (device_may_wakeup(priv->device))
+			phylink_speed_up(priv->phylink);
 	}
+	rtnl_unlock();
 
 	rtnl_lock();
 	mutex_lock(&priv->lock);
@@ -7288,8 +7290,6 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
-	phylink_mac_change(priv->phylink, true);
-
 	netif_device_attach(ndev);
 
 	return 0;
-- 
2.17.1

