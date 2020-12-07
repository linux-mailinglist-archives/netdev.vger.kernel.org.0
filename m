Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B02D0F93
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgLGLj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:39:59 -0500
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:45537
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbgLGLj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 06:39:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cseHrj2vgDX8peVeYI+WWbopgExEBNvnNYDXUvtAO2h3e/Xoeig2dxF0gLVHIWjrm8EsUaPt33Tv58lcbPsqOmJqau2SISw0xHZem/7S+wVF/+PwUOw6XGX2IvCs/fXBbxu0kPUpZ4m5w8sRg6pkDLwSEaOtW5zFQydqojLGINYLaz2NDKcegh29Xg8fJvR2e2Q5rnPk7q6Hb6qBgi1201SWgbsxNQBICZ28XdHuPkyw8M0rChQj598OVbvVpK28kIYO59/yrAwv8r1yYK+Xinfz/8JoyhdcHqPqjogFSX5/+ZrOUspgQBiZGBzQmyLNLMRoiQiNxYoU/IxPjhQ4zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRBjIalOKCCfBiYnSfC6BXVFwUj00KQWKDH3fgiXL1o=;
 b=c+vGgu6xaJ3hS1n5NXt3HTxPXs3x8w4mL6PgXy4lkaA9oyjePbnTdu7n1C6S0IXT3qQUV/s8DNEzlMJINoadVeYE7SL8GlA3wjVsAmhC9GpCuW1PS7MjPyQCTJa7SoKCTZdjcJQwimxUDJhFDCIbRyc3wGHCq4ApjNlwAC6Mcaqo87QzYGLQQlnFYCcsTmPWhmdzPbOoZ15jCi319fABk4RiFziqvReP+6Ky0yE7qds05sbctMi+H0/G1HRJ+gS7WL52fUScJ/d+6gAAiJQ2RzpFjCs/EEnuXGnedD+AhzRVrAgJ+zppEUaA83ZZQjuyEI5QlmfkewkZG/O45hyVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRBjIalOKCCfBiYnSfC6BXVFwUj00KQWKDH3fgiXL1o=;
 b=cb5V8jpMBGntdkHMnnTYmH7jlAJlXlhEX208AywXnTMcpxqCyvBdg7wkrX2eA3/zoBm5IXdina4gCaQDzoqnlcUVH5WyZDzIAr5hgONKL53MhGk3y7KO1zzjuHy+M3lp4rqIFSGl7SZAij+B5SSZ57XhGhwhzJ52hbiIauMY+Q0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4106.eurprd04.prod.outlook.com (2603:10a6:5:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 7 Dec
 2020 11:39:08 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 11:39:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com,
        Jisheng.Zhang@synaptics.com
Subject: [PATCH RFC] ethernet: stmmac: clean up the code for release/suspend/resume function
Date:   Mon,  7 Dec 2020 19:38:49 +0800
Message-Id: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0401CA0006.apcprd04.prod.outlook.com
 (2603:1096:3:1::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0006.apcprd04.prod.outlook.com (2603:1096:3:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19 via Frontend Transport; Mon, 7 Dec 2020 11:39:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b435668-e630-4b5a-5af0-08d89aa4b544
X-MS-TrafficTypeDiagnostic: DB7PR04MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4106761D321EBC2BD848197CE6CE0@DB7PR04MB4106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:313;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wk1gYyR9ldt7+rsvmRxj3X/zchEfDGXW/LstfcuFl67qzPI/nJikKXNb2Fj8s3ZWQI0PJtTodsYZTjDoyeaQANtZ2y79n14WvR0hP7anygqLfJKaE8y4FJNDsVpDiGd24ggVi1MdMTrFNBaaO0h+RocEQ2BwWqqwzxg3Pd29qExGqxQGgg2DAVkKz0GPfvcBsE82pHk7yyxU1fvj36uhn6hMAlvEwKfyySWymF+emWb2ymyXMY856WH9LjtHc6uJ3c5V9BxScTXiXgdMUzTR1dnfYWv85cb7k41cZj2HO1MCUppC5UW58tP6xTDkExjoKPn9PB80/8Ccpu41oF1MUI7LNWsmdbfwkNhW2V9s87VlHUhnmaqeZomJr2/MN3Ow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(66946007)(86362001)(66556008)(956004)(5660300002)(2616005)(26005)(36756003)(316002)(478600001)(2906002)(69590400008)(6512007)(6486002)(8936002)(4326008)(6666004)(66476007)(6506007)(15650500001)(52116002)(83380400001)(16526019)(8676002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yByDxgtqj1GjsSOJXuNy20NPg8jkeLUmjnaRBvrMkCJbR9FeTVaZokFJdBMF?=
 =?us-ascii?Q?Q9Uz/S3TRiekqG7+l6uJBMet07zLiwRcSr4NWoATk2FFs/u+X+qiI0ZPBXky?=
 =?us-ascii?Q?V4UuOM70gjVC27Dbpo524n3FUa0tAXVGVORJmyrZpBNH0K3FUrG3eB/C88g/?=
 =?us-ascii?Q?44L5cwbQZhpKrtUnAjCc7+LPyKnIMaze5qHd6l4evNvN6o4xcnWLcRFvH49k?=
 =?us-ascii?Q?0vz8wP0RFx1jjn2MsgdyONUaBSCGn7lsH+fxZK0dbkNiISvps0OpjzJB6M8t?=
 =?us-ascii?Q?1KuKRk7BEFEPLmQMNNmbPj0LCX/YLwi2w+Zl5UsqJdlFh57lCJMGjnXIvEoW?=
 =?us-ascii?Q?Wv8n/hK6RcFnq4v9AWt27W0DW1c91dQKJL+0s5DmpaQ/wfdIxzW12Crc3vKZ?=
 =?us-ascii?Q?NWog7FGPWmFIwuWen/X5D3ah6velPn1lQKftKzvdn5BCQM2lNFssEDJ14QTw?=
 =?us-ascii?Q?xut/+RPajp4KnC+Fl/AGx8jk7hKx9ogaG8kXviExwi3qkqwnNQPv2br00vpX?=
 =?us-ascii?Q?U96u5H/L8SdAPhFERWh7+qmOrsq29lE26s/IL3dkeTPqZuRheaf0JFASY/Xt?=
 =?us-ascii?Q?8+buq+9AQf4632G7OuhYWfqQHw3aAT1rdrnyRiMpojk/nf9p9X0N9MpM5P4n?=
 =?us-ascii?Q?9AIdKEqwz5ZUeO1AqZkW25GQ1khexxLB6ubCKRY7c3Xf3vPOpIW5bIfeuzn4?=
 =?us-ascii?Q?qHd2d1zfSXZA8DnSAFFh4qxqAkk+ZXKyDKqA+4P4fg7izPyqlkXCM/lY/z1V?=
 =?us-ascii?Q?ASrtuH2+2k8bx+4C1h3mpc7b3iSjaCJzGlYX1TJReSCYAExrrbj6C6CBlkMk?=
 =?us-ascii?Q?7ctA+aTAW2AJX+/iZHsSXV9k8bGhnaYMnGQV/PsoHjqy5LZgOpPohLHmtayt?=
 =?us-ascii?Q?BgMVTQ/mUbsAlq90KinlMfXz0JXNKr84UyesmmcwTAvhuFbYSUezMAA7R9At?=
 =?us-ascii?Q?mxfiDvDv3vbDsPLQr6ROh6oJOUy65884lF9BJROPUBOnyaoxL5nJ2CxgCeFW?=
 =?us-ascii?Q?V3ph?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b435668-e630-4b5a-5af0-08d89aa4b544
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 11:39:08.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cSJA2DCK0pXV/3/kwR9mxES+plag1JETdcs8eztBNZHDvVVAIDGHWjpg7rOSzdYvKzkSdQAEDaCcIJp8anwbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()"),
have not clean up check NULL clock parameter completely, this patch did it.

commit e8377e7a29efb ("net: stmmac: only call pmt() during suspend/resume if HW enables PMT"),
after this patch, we use
if (device_may_wakeup(priv->device) && priv->plat->pmt) check MAC wakeup
if (device_may_wakeup(priv->device)) check PHY wakeup
Add oneline comment for readability.

commit 77b2898394e3b ("net: stmmac: Speed down the PHY if WoL to save energy"),
slow down phy speed when release net device under any condition.

Slightly adjust the order of the codes so that suspend/resume look more
symmetrical, generally speaking they should appear symmetrically.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 +++++++++----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c33db79cdd0a..a46e865c4acc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2908,8 +2908,7 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	if (device_may_wakeup(priv->device))
-		phylink_speed_down(priv->phylink, false);
+	phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
 	phylink_stop(priv->phylink);
 	phylink_disconnect_phy(priv->phylink);
@@ -5183,6 +5182,7 @@ int stmmac_suspend(struct device *dev)
 	} else {
 		mutex_unlock(&priv->lock);
 		rtnl_lock();
+		/* For PHY wakeup case */
 		if (device_may_wakeup(priv->device))
 			phylink_speed_down(priv->phylink, false);
 		phylink_stop(priv->phylink);
@@ -5260,11 +5260,17 @@ int stmmac_resume(struct device *dev)
 		/* enable the clk previously disabled */
 		clk_prepare_enable(priv->plat->stmmac_clk);
 		clk_prepare_enable(priv->plat->pclk);
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
+
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		/* We may have called phylink_speed_down before */
+		if (device_may_wakeup(priv->device))
+			phylink_speed_up(priv->phylink);
+		rtnl_unlock();
 	}
 
 	if (priv->plat->serdes_powerup) {
@@ -5275,14 +5281,6 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
-	}
-
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
-- 
2.17.1

