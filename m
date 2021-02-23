Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8513A322906
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBWKto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:49:44 -0500
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:30189
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232107AbhBWKtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 05:49:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgEjU7+UJHF1TtLAdmn4wwNwBtVzt23iur8dHN9fKBLiatGEj5f5j1Qx4TfOBzJxCD2DvZ3QGFB4apTteYgWbEAdlCVk7KRyEg3zqpT4lMcgcC9K7FFCvgSwyDZJ+lZarblRFlNtLubS7d6kndzIwx0qzFHbZaVjU9WlfMP0a5uXByTKTQVjI1/U3jSYfj6FFm+Nihes9oyNJu2infBa0XQJAmlhmO1uGvV5+Sg+gt9HgzaHKo8uJOXirmj8cYvenNxV8f9H6TvfciUN8913lhzbHdpV1nqG/mTGP+4rxQbqrSB6yu07N0VUui4cHZ/1qBZ3mwuAZ4joqevLFy0NJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoZFlDG5nKuJsnBfl+skVl23IuL9N2te2B4ZAeyGJno=;
 b=NZAOzpMtyzPlD5oLCG1MLei2SH/U0e9KgsR9ulL97sfhAOrYNIBZ0JCRz34sQbBBOtJCuvhrif3CqUEPv/yE9JAlWLa81t2QQkVwKre8T7y8sCqZH1D95loVpnFBcu2YVaH4p4SLfS7BVri/sPCJN1YlMm97sUXcKAkYsW6fAVj6/mETvgk62mfPwiaTBjAizSz1TujcVKAH2x0CRazTvtB+B37IQJEBz3rmYXw0JrsapJfyAY2UfMbviRtM0Mw+XjFtxTwUqjHVXXMIVpKT4t6c3lZEoLxJOZo0HBHF1XfbO6M6A1rUkpwoWk+ht+vsd724G2nPAwQymP/mLomvBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoZFlDG5nKuJsnBfl+skVl23IuL9N2te2B4ZAeyGJno=;
 b=mGDJyV6xHaJVbCMbNJX1hB3vMwujrfeINSs8EB7NT/E+Q7Us5F6Brv7X81kinfUmMyzrS1fbF4WynmfGf9jDvZ7kSwbgX7pojWOP8nSSHOwUIHhnlQVcflrUHO7VpEed68db7BSRq3iUNl4u5KgBYcaEdh5fx3ckkAdOLp5L1aI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7705.eurprd04.prod.outlook.com (2603:10a6:10:209::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 10:48:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 10:48:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 2/3] net: stmmac: add platform level clocks management
Date:   Tue, 23 Feb 2021 18:48:17 +0800
Message-Id: <20210223104818.1933-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 10:48:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7958386a-8e17-43b4-8acf-08d8d7e8846b
X-MS-TrafficTypeDiagnostic: DBBPR04MB7705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7705BE955087A838846D393BE6809@DBBPR04MB7705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEZb+Dw7avz8c70+ZquoFzfrha7DXwOA7CGC7s8JlMoCEQp2ILAt2EZJqI5PVNKpF7SqZtmDvLm9mD2zY0ctQo5yr8FsIfHwwFvR4jLlPKg7rqMOo94+imIaFOYctOB34a0/p1ZCTANARPSS3AbOsFAraAhAz5RCtKvMEUC/RppsreKwviyzlSUhKzSOd1AXDAQAJEdNIqcQmvpl8B75ka/l+nZyhaXfEO4r/jKHw7TFyQw4MllTiQ/Vdx0+Nts6fqaqQGRxzKaLeJT0xoMdEayj5PS2zw06yPE3yTrF02urVYhjbH6WhcdXfZa/u3s1lBTKCYt0XQaJh7xwcx/aKmxxKJftPwZI9ZzpQtXqR3bvzFVkjOq3lWVUWHBKtMl93ubiMY1M7qqk/7ehKHaI+IDSTY9/22oQr3sXAT1Wpxu92DoEENopNLvn5o2orFW4fMw6vt2esV7piFuuHZqYPWmwe4mdVUAeT8o6ellqjvjUuB/d8CE8gN8cqMfq9WoOvD4D7PbOG5dPuwPtFAXrxQknuo6E6Y3XbJdtBv2dxJyRldq7/zHCM6/e82iRt3SR95Bwv2+ujx8BIEOk2p3Z8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(186003)(956004)(66556008)(1076003)(2616005)(5660300002)(83380400001)(36756003)(6506007)(26005)(16526019)(8676002)(478600001)(66476007)(4326008)(6512007)(69590400012)(2906002)(6486002)(8936002)(316002)(52116002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VYyUHvo26r30HMLCjBQQQiL3vR18CzbrlRYdI47uN89mMr1POFn3DQPFSDip9T4C9zsNWkpRDf5KxI/1ruwdLXpj5ArWTaUvXePxvCZTnNd8PMQWq0tlJPrce5N1Jz+44eANYfYBAfIlRmlA5BTjABc/Pq0JECOmAFYBP5nfjOySGWcTRZSMyLKSaNOSF0CN3IhTkgz5+nKp5UGKz1NzcmW4ZMyw5Lnh2S+rUigaHQpC3d77X24OiTxOxs4Z7SsxONRoWtrrrQH/fN4+pfHcpQbrtP4q+wR6arRuvLsw+cP7Kb1q2ziPjAnZpkLVquXgysIKHzX0DT05B8xmpjNMsVIy8ca0zNyA0Kyrr1BOmYU54B5sB9CBonlz1naksV3zwx58Rthn01jJEWwLyFSA6bYz9thDazxsn4q+GVeMM7dcj/REOxfNlO9IjLmVFXHVvpc5xCLpEja4d+OPx/jS7JgQv0DRqXk4HCVlheNKYUv/FP4xSelazOesh0tKVLnvGeZPPJ0uDQiShRmCYuHdG9Y+6cW6+i6FdzuaMVt5c4v7XftnXmKEG6E4LXiqGWGjJNa3ZxJt274+go2inpT40iF5h0H0K7XB+18UBfveSk1VlhG6HSX+6NLp3EqDmx2UHsEgTWXV1ikxbZ5I/EDuaDPa+QhorjT3hTm/Ti/u0mXGw7Px/6hN4O7XEc8mpc/E0vgdJsfInwdfAIrr5fuj7LAiQNXOrQYNwQn06tDgGNnQHjQvYxYxup0UHmEGIimb
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7958386a-8e17-43b4-8acf-08d8d7e8846b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 10:48:12.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXG6q2gWjN/+gKyRci1wsQpVnDk7TsbIqXhi8vMNFrTOLkb41ToFTn2k8rTEyW8Scaj1P+nRnlquRJlRLLAQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add platform level clocks management. Some
platforms may have their own special clocks, they also need to be
managed dynamically. If you want to manage such clocks, please implement
clks_enable callback.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 include/linux/stmmac.h                            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 35a79c00a477..3f12faa224aa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -126,9 +126,19 @@ static int stmmac_bus_clks_enable(struct stmmac_priv *priv, bool enabled)
 			clk_disable_unprepare(priv->plat->stmmac_clk);
 			return ret;
 		}
+		if (priv->plat->clks_enable) {
+			ret = priv->plat->clks_enable(priv->plat->bsp_priv, enabled);
+			if (ret) {
+				clk_disable_unprepare(priv->plat->stmmac_clk);
+				clk_disable_unprepare(priv->plat->pclk);
+				return ret;
+			}
+		}
 	} else {
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 		clk_disable_unprepare(priv->plat->pclk);
+		if (priv->plat->clks_enable)
+			priv->plat->clks_enable(priv->plat->bsp_priv, enabled);
 	}
 
 	return ret;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a302982de2d7..f2486a0ab5f1 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -183,6 +183,7 @@ struct plat_stmmacenet_data {
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
+	int (*clks_enable)(void *priv, bool enabled);
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
-- 
2.17.1

