Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEF530B7C9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhBBGZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:25:34 -0500
Received: from mail-eopbgr130072.outbound.protection.outlook.com ([40.107.13.72]:25344
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231605AbhBBGZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:25:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnGSR+UF3rOEw1Lnal8Air6724ed5whpybXcW1xD6tCB+F+w0ju4fZXHbEEpgniJn9WSdzfJsYmkZdWifOlGl5tcUtWs+ajj5UW2qm88wk0Ki1mutMZ/NsN9AY68+mKE3x4KX5+IYwQb75RHFxBDg3xgigkAp/H9HGcX5Be3zPooXo4GiZTpvS7EBmi48tfroko5u12hB1U4Ql+lO0YhQDnNOuQPnlO1xGKKJ7CTe8tNVRhapP4V9LEOTfWDe/l6CAz+h74zHUPhCoCukG2wHYxWxt+XF4NGpvWO0KTSsFrkAQtdXWHD8SBQLPuwI5RqdXW1hDiZ4+jiStgrmY9dHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVmsgc4cuhK3MV3tcIx8i39LgFgrCfmFXMzTafyf5OA=;
 b=Z0ff6Sr6GaqHHu75oeHu8+FLJGLkkG91Ri1xbh576sGuF4Hzy8/6lTX7ROc80tcgybscVliC7/cGJPdcooy9eQ5MmQ+8jtcHTndjq6qRk9co0a74MsysgyMmwGgeXUhku5jtOGYCgn1uS0EpNOcRcWe23LNwFIxAwURK92yONklbzxmMxhXMD3E/sYw1zBIfZIS0isxEId8S+BGnRZ+dVZbsABqCFvbLdTCP7ay4YiIklzMf5ts/OuTi1f83oHltvGXqXQzxA2sC8LVD3ggOGUrtiDDHAuo3AY7Gl5AZqOlLaA3ujeoHGyUiqTXw04MhZZk2sRPM2F8YP669HCKHKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVmsgc4cuhK3MV3tcIx8i39LgFgrCfmFXMzTafyf5OA=;
 b=CWc6EjR765WgcDDCme1mxXkM+XeWfXu1NP+/xUivT5iYj57wHlnPR/DvTXUBhoRCQCTYkDOfVItpHIl8DyXZR8j7/AFX+iuF2roZRRxQOC2uHQqptjy7C6VTX1hWDV6wdApWatKKFIlkOSd2F41Eb7z1dRXZglrwxUb2FjLyaKY=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5307.eurprd04.prod.outlook.com (2603:10a6:10:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Tue, 2 Feb
 2021 06:24:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 06:24:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH linux-can] can: flexcan: enable RX FIFO after FRZ/HALT valid
Date:   Tue,  2 Feb 2021 14:23:50 +0800
Message-Id: <20210202062350.7258-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0108.apcprd03.prod.outlook.com (2603:1096:4:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.12 via Frontend Transport; Tue, 2 Feb 2021 06:24:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08d49ced-8ee9-4b69-076e-08d8c7433aa3
X-MS-TrafficTypeDiagnostic: DB7PR04MB5307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB530766C4BF13E298A24F74AAE6B59@DB7PR04MB5307.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uyCXqlnF/hBj4Sm8GN64/b6FUdBiEmfBzoA3LDmpP5ukeqmEmTdwqTzRX8dXY/PBepQtf83N0guij2GjkiOWTYfpH8dNza1mNHqUA+YXr6WpUunfIP6e2Dl2OSA0asKDa3WGEuAdZUOXdKHvhIsEBNR7l4F5abiKLVfpjgBHzdkXPj+RCxnrRvQGq69OM990e0W2armvAOgy1+aYNLnngP+lAaMjkEtHtElIQ4Zx2Hv49ZIQTrdwwV7YwOuMKA7S1SkU5zvw+nO+OnT7dTQf2Zi/g/k6CJU05hpP+JiG0FdU7uFQusq+5MyB4nPeOsU7QxFC2uDvnIOX4Uw8NvNcv+wslBUZPEFqBhhg4UP2wtmjkzTecMmPKAbCMqijw8xxVtuEFTbMp8Ab6nfr2wdNIgAbCnmbNJtWPrysq/UPAGDkO9kRJ0Ua9kEU1XoA7VQOU5Vm6Bh1JwUMX0z+snsuJr13oNFjuzH9crOVe6daIGC4RUA7lkYY5+rgkUqg2AxQkv61Kbd/05CU3o8Fn5xmVEoRpYF8JUBV6WJkGAmYp5RX+AAIjiXHOiXYeLpO6BkOzHGsm9LTsJ7qe+EIcklVAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(6666004)(26005)(1076003)(186003)(69590400011)(6506007)(6512007)(86362001)(16526019)(6486002)(316002)(52116002)(2906002)(4326008)(478600001)(2616005)(83380400001)(5660300002)(36756003)(66946007)(8676002)(956004)(66556008)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oPT+03Dl4FhbsIURWaNDZstBHUNDmT2diDvkzko7k8yJHHKvcAUpKIHC2ddi?=
 =?us-ascii?Q?uTgGOB21nGrHKfy07ICBEgQFDIQd5RIToPK9TxwLQniN21bxPwjrG18K/bZ3?=
 =?us-ascii?Q?9wsC9K11YRjyfqy5VtAIbt2jKkKQc4ZwBnhj8GzVApgO8D9/asRc/XYGCVt3?=
 =?us-ascii?Q?hXOjhq0HSVIf1PsoqlXUkzG9e5+6KwNFt3XO9B/iszkVqojOxWRpgqfnXqrQ?=
 =?us-ascii?Q?bqdQSoKl66t9YLh83C3PlPZPTzePEP/RGzBlXD78AziUucgQEVzIUH5XNEQA?=
 =?us-ascii?Q?X1qH36aFwzbK5090MDUO0UutPr5hC44CWXUumA1gbKO+Gudm3G+wmVmYAHkI?=
 =?us-ascii?Q?j7wA6yAgGnbiVbBq8s6jijz5/pPETpTIc7UzVfmuTzaziRqvoH8ahiPoEj2Q?=
 =?us-ascii?Q?DxNzLq4Zw8FvifzLyCjKDwh25N/M48H+id8OkYk+7PFOLKh3STeeT1XB3595?=
 =?us-ascii?Q?BBdnP+1akt+VxBEeLfjKVBrR/ImKGp0E9/96FS/ksWtcke8U+wug3MYuLfC7?=
 =?us-ascii?Q?QfE774cjqUSJlw3/cRuDbgSbrwEW4kjWn/atrAnamSny853ZVmdPomKS9kub?=
 =?us-ascii?Q?pVKR1MNHGzgrbNx10B39mSPNWxmZC3cmEGJvNDad1m9oBFNu4VM0i204TjH9?=
 =?us-ascii?Q?uhCsIprWRVceGo6KAd3uV8bWjzLFlhfs8TY2XbG/4ALx3NRG8YXjFz0olojn?=
 =?us-ascii?Q?eMSggT5jW1GCfSDcfgs/lT3YyynjSUVEHJIplEN656tH6n9otWWbq0VZq+Ov?=
 =?us-ascii?Q?W0QeHsY4iod9tGGaXtQAtcTPm4KeJy2OjuK4A/5hnkMe5BDdnelNWztOixYM?=
 =?us-ascii?Q?0/kOav1OdSmGlFMN6suHHA56U019om0YaAbd1bDtacsD+c+zXCN72avXoRpJ?=
 =?us-ascii?Q?p7Gf58fEmd3YnVKHqn661g0JMD+X3UlThTB6VZwPgj0uoGEzVAbK0YG09ys5?=
 =?us-ascii?Q?Y1odBNcJ6pKINjUp//J5g0R8CWq/YDHvphE9rR1KH0IlZ9JJ6fSZ4FLcWHkK?=
 =?us-ascii?Q?eXO6llqo4J0krrQEwrlVg8OnwoDfhNTGuh12Yp5ZpR2i2ec6FGzbVk9q1L0N?=
 =?us-ascii?Q?W6TRmdU1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d49ced-8ee9-4b69-076e-08d8c7433aa3
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 06:24:43.6391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6l/VMBll3o5d2PRCi8kHvO2SBYQ81//z9RSt7x2ZIJ16z9Y9s2BF36GoldMddwcF8xIHdb20D9P1/EcPcULBcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX FIFO enable failed could happen when do system reboot stress test,
one customer reports failure rate is about 50%.

[    0.303958] flexcan 5a8d0000.can: 5a8d0000.can supply xceiver not found, using dummy regulator
[    0.304281] flexcan 5a8d0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.314640] flexcan 5a8d0000.can: registering netdev failed
[    0.320728] flexcan 5a8e0000.can: 5a8e0000.can supply xceiver not found, using dummy regulator
[    0.320991] flexcan 5a8e0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.331360] flexcan 5a8e0000.can: registering netdev failed
[    0.337444] flexcan 5a8f0000.can: 5a8f0000.can supply xceiver not found, using dummy regulator
[    0.337716] flexcan 5a8f0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.348117] flexcan 5a8f0000.can: registering netdev failed

RX FIFO should be enabled after the FRZ/HALT are valid. But the current
code set RX FIFO enable and FRZ/HALT at the same time.

Fixes: e955cead03117 ("CAN: Add Flexcan CAN controller driver")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 038fe1036df2..8ee9fa2f4161 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1803,6 +1803,7 @@ static int register_flexcandev(struct net_device *dev)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg, err;
 
 	err = flexcan_clks_enable(priv);
@@ -1825,10 +1826,19 @@ static int register_flexcandev(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
-	/* set freeze, halt and activate FIFO, restrict register access */
+	/* set freeze, halt and polling the freeze ack */
 	reg = priv->read(&regs->mcr);
-	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT |
-		FLEXCAN_MCR_FEN | FLEXCAN_MCR_SUPV;
+	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
+	priv->write(reg, &regs->mcr);
+
+	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))
+		udelay(100);
+
+	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))
+		return -ETIMEDOUT;
+
+	/* Activate FIFO, restrict register access */
+	reg |=  FLEXCAN_MCR_FEN | FLEXCAN_MCR_SUPV;
 	priv->write(reg, &regs->mcr);
 
 	/* Currently we only support newer versions of this core
-- 
2.17.1

