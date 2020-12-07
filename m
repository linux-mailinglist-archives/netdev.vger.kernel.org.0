Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AAD2D0E74
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgLGKwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:52:55 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:34337
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgLGKwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:52:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbtg1M22eAxLUqWWcFuaEL4IKtnqGc1LqKZx0yMhYCUXQRCyEeaBmNZ3EPP0i+p9YAin4Nj8Y6AyHlGZYS240+COCGHn4ATu8S29v3nQ/X2WG9gjjpMhJBpQmRjQvoZwf4VpS9Ck1fmexnvrrqQE1FNDyjF5ZlVD5AX8g3bE6QysRJV8RH+f6I/lYhQfcGoQD8uXZtZDdeX+ax8U2Kp2cTiEzesl7+BkIT1UZ5sxtIU2Fmunj4mSAXEUzQoLAhtRvHVqw6tEsvT973+hVVXyysLORzTWqWgocj6HCEFDfo1y/3H+in4/CZEXiqBHgEOkvm8cMF3WZ6LfH0vo7fPe9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzDPwhdyu71mVieaZyBRqDf9erJKSQi54+AsIZn48YI=;
 b=DzcBYvfsIab6v0rhrna+xI9D4lA65CW5GPqSf6W0opJL1SKlE9nGJqig6GZuMgxjBwXiEZjaDyq5T2HfF0yRr9E8LsOOcWDo0SYXjq7/zxtwmN9TABh/QKaQeESjA1eMdgbgy/KI1fIes1j9nElchr9XvSLb77HnDIw4pbBdSebfSXVoZm/Ut/hvZAf3OCk1+ZEABwWzyg+++czmerkcsvUi1idi4+w+DJI3abbPpOtYkI1MDW2NTDjH19xHNSvTH3fa8zGD4Y575TajnjIIlWuJRs5amrjJX6au73mC5VzBB7iwZw+zhU7OE8k1HwqVLaaCtyctRXf8jrugj5JfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzDPwhdyu71mVieaZyBRqDf9erJKSQi54+AsIZn48YI=;
 b=Us3xx48OljpxNOXM69ayfK3CMom7fNA9L6VHKQoHpvqIKbr6BkXhprfmkwh80wiu4xg0Wsz4uXIvyhdQ6vZzckHlk0rkNS47FTzZ/w8wS+Qm8TNsYKzy1pPoLoXF4rdwnao0sn7n8ex7YL4ScHKlMB6YFXXdnIKhlSmzWF12TWQ=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 4/5] net: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Mon,  7 Dec 2020 18:51:40 +0800
Message-Id: <20201207105141.12550-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a19804dd-64e7-4418-1b6b-08d89a9e1316
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23286E067A050FF9B4929D72E6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j50NmpUjRWAjTykg6c3Z6sp73G1RInpoEeuxWCGttks6X4dbstZ/se0wQL170GV9EufWjdslEYpfLhiAgVDfSgxMmjbjoqBwYObRGq7WUGXf6vVuSAjIUf3iJLPYv+b3wjqA9549m6ALJ98N4XjrU3a6CnvaVj3OnhnRGFACp8A9xO/z2yU37/EpbwOJcDPFb9bk+G7mE8XHfyYKAPn03g2N0jD/AhVa8kppcisFY1N8G4h19vsbhDSFFxap4+YLJbXRutuoUQQdZ/JfcmvSzGHS0jUxBwLCohHzBY2QVw8y81O5T62HCwb5MObMgk7zJ06ULiP9bqghjUIOQ+L2hyu858k/Dbe7F29gFaO/uA60S79XIBB4lGmicAXo3++4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5EsQp6jviOkQzVVV94fpbReSyR9oi4Pp+Lvx68kTRzd4Odtkw4IKvlW+IGSB?=
 =?us-ascii?Q?ANcphfOW5bL9YHCaCl2Ggu0XpKGg5Ar3pCHNzvdTbyFFEYSJzfE5uIBEjISa?=
 =?us-ascii?Q?mUu/MZvXQsiQ0yQbMjLcOxUGSu/PjpoazF+uybAn7/fYNC01lXO9sfKY50H8?=
 =?us-ascii?Q?dEV0WtfZbwXprm0P+M7NqsYNl4H5+WD+SkxSO/d/CP/5vrFNdFn5Z10v8wW0?=
 =?us-ascii?Q?y+4oDEkrAM+xuqLqYNmZnR1ZlhaRB1SvVZvc8W58pwQYlPG+6mOuZEykuHXo?=
 =?us-ascii?Q?LqDR07vruPlaXHQV6fnbJbSU7PprIXXdNMq+mX2VX2jSPwvJjUrsIv2dwo5M?=
 =?us-ascii?Q?v5JaTGyy23Xk2lbzy3n6P1gx66KZcebAq9IolLvB9NWsc1nxra+2xYcCRizD?=
 =?us-ascii?Q?B4bXshBIJ3uH8tjzzW0NahKBeCYmq+s5uSGpC2lqFtU2qjOk9Y/rZVsFqWUQ?=
 =?us-ascii?Q?jRwNrtRwVq4NdXlrSNgTZWP5UATyV5OoVWatBQoff1rS2OZEZoz2joCgPH5A?=
 =?us-ascii?Q?JRHXrTPfAKCe+mxmeK07ZVBE9LvNzOBwkXSEdq0w/KFuekWHdjEK3gQJo6rc?=
 =?us-ascii?Q?8kJ+y4rmbTPEtUDWgiJU97DBpW1dYEJU2SvIGxUCXhOcagqXCm6KxI72x1m6?=
 =?us-ascii?Q?+gy3zsl1OlKM55mYibx3/TPcuGid133eZHhl2B8ROOn2mvWGYbeq/DZLi1KG?=
 =?us-ascii?Q?3BdUqpYAXjRlBXXZPi2poN2Xmsh3oIHmxY4yadA7l8jDUoEIOFeua9BxzaNa?=
 =?us-ascii?Q?aa37FCEZevD6JcI5jIn51xyGY1UHujeaqfvB5uMUrcuNiHZGH3vbz5sW2sju?=
 =?us-ascii?Q?Pab3Gr1q48C3YwTz7Q59zyB9FXV/b5auUiX5OafT9xnf4A1DvQk0nYMCOuVT?=
 =?us-ascii?Q?ydighBeWPbwTmsnOwaSyF45h9M+Ou67+h3Xpavuk7icWgl4DSE2fxm7/GeuF?=
 =?us-ascii?Q?GD79PwyWjdhrl9abpNAKHornOszFlXnmGB5VpYo62ka6YNCn89qGFtY47Ya8?=
 =?us-ascii?Q?UyUm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19804dd-64e7-4418-1b6b-08d89a9e1316
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:39.1040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fARApCz95SwAFXF+aUTmZAlogGakq879syhWG2A90DZKFnKOKV416odEQ+/45ngnusJchSTWGWzWK2BJToKlhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

There have chance to re-enable the eee_ctrl_timer and fire the timer
in napi callback after delete the timer in .stmmac_release(), which
introduces to access eee registers in the timer function after clocks
are disabled then causes system hang. Found this issue when do
suspend/resume and reboot stress test.

It is safe to delete the timer after napi disabled and disable lpi mode.

Fixes: d765955d2ae0b ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7452f3c1cab9..d2521ebb8217 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2908,9 +2908,6 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -2929,6 +2926,11 @@ static int stmmac_release(struct net_device *dev)
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -5155,6 +5157,11 @@ int stmmac_suspend(struct device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		del_timer_sync(&priv->tx_queue[chan].txtimer);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
-- 
2.17.1

