Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F108C468714
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378211AbhLDScv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:51 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348343AbhLDScq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW0teagRQTQFiEQrklUDKHicHqAmWGHGcvV3TFLDfYhAkkOHkNgHlthRsakXKiBDV4k3P6epf8XgQon76aPxkZ5DW6bRcpGm0Wj7D6UKNrPxkcX/YD4nIrAz6GW354UxMRz6nRd7QvVtRDUf++tvaihBCqOXmuGKYh/5MvIjBLUR2gN9KfvHKoTKnc7CATcRvVRL6DlRJJ3PfcOunTufD91hlRRvjvOyao5Qg+Q6P+DP24DDOsCa9xd1k1TD6X3rg+G6XUPbotsCw22KBGxjJYY3gKq9WyPok0AbBzr5ag6SYDPxZVgdnAITOTVUFeYn8Sd9Y/SZcwC6u0e51yzNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=FdDCTO3k7Q8ZwDAcIAicsOF1kssxGc2kNWkBIqePjo+AP8H+gSv/zdF2svdWtEFXvQk/KPuWuuiq2TQK2M82Xt1bGVEg/wbJvcy33kuslhHbwU7+o85CVT2zs1TRSEMfKPPffMYCnfOEhXqYTYqbKA9W7zHnhNMAIUAxAXjTS9l5az14f5Fa4LXcb0IIziblthOYjNHaUq/K2UVZQQw2Eeh5ju3GwwAuPtSZ2mR9NLtVy79z37UlEzhES9oNU0JH3QGHuPWzqZooEs/LBaI+IWDqpTBM0Bv3RtlVfG8CR5UpxZznaq1vp+dgqKBJMqumUV1Z5YhGjyytSYJxcNL4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=yONKo6NCKFb9QkhFk93CMFG+MNtkUgcqYizrjIO6f0R2/zIu8c59UU92wTT29KUOD4N4NWdTEIigkERwlEAlTSslykk4bGVH053D1vGfPtbAnapcPTy5KEKJVCtkt3NmYka5QTi2vC0drOilzqSfK17OhF05RX5N5OIuUhrD4No=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat,  4 Dec 2021 10:28:58 -0800
Message-Id: <20211204182858.1052710-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182858.1052710-1-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d431c742-29e0-472e-6969-08d9b753f768
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2063A84F8B64252C8B6BED98A46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ5R6eioJ8znRDNKSJXCoMh/LR7Ih/u8mdyq31G4YaYTW4arn8GrJiIpTOXWlhC+GDNBkjfT4HOLCMHEI6C4kl1gHVPgMaolPaBcqFiNN7GT90cXxKry4nLWFsAUdbmjViLoUvFwA5i941iB6NUwAxOno7K9obVgGEecIG/1CrF+azo+isQn6gglq5eOG8JZ2FjbgM6y6NgYk29mE3PqiUCoXqwQk0XBK7tnT90NiwotJdwPbIE20aRKLD8Lc/Fm8yoBWxzpYDISwsKhQF7r2crlis1D3ksxwBkYBv4p/qE0zlSPEYRkyvgqDaWFm3WPBemKLwH/7GsPlawzEVSqeXFXrwXr2cXZ+fzarlz6eOQdAZ2QE2tkUkA3JWxuhKyiE6kyj7civamrFcdHkcgLnm4kOnlq+4XArjGV/4eG+TWit1fRte/zflLeYDNqta8VcdVnG/Ur+Pn0+WxrW3YFuJs6eDlWhgY0mOpd1xUxIuIaV3/I546x5wqdVPvdhsc1boIHQ4GgXHNuYFJfmzmnjMU5vM8H4OM6fOMlq6fhmEW+8Upt7pVqTkERxUyFMf7cG+W6R6ky+ysFoJGG6ZG4vYXN5asm9b0576MX/L/4RnA1MQYE8Ij9o6SuRhcgcOFp9eJ7OE+4+NF6ooI9Afhmk022gqTXZirfEs1ZSAq8/GBQetTE9xJx1JJ1oPp1H4BmlEuJ6XcpVFziIK510vK/jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(6486002)(66946007)(6506007)(52116002)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jvdEDDAf3PiXEuiORBmR3PsZFaYnO6MZBIRFvwypCfpFrdcm6k+f7cG8gmC/?=
 =?us-ascii?Q?voivVbKq9/thXYnIFZZeAXBxIjD49Qzj1rqJZACaXJZ4C2Kdsj1MtHWoHDET?=
 =?us-ascii?Q?6y52PCwY9rzyKHsqkxZBs+yB0UmWNn+N9mVLyMCebFc5M6++NVClyeMZGv0k?=
 =?us-ascii?Q?FX10B1ILy2QjWZR/iX9O+wTPQ5lzYPFdzbf1hdHnmTWIwumvTkagXw6aMX2U?=
 =?us-ascii?Q?mEAfXtEieqjdM9hyjjCnkmO4lnrjfeBSrGWotR98CXOLG90f4Esl5WEGHU7Q?=
 =?us-ascii?Q?yUHfJ11RyuomnyiGT6d/8iwznph/LPcxw9t1FgOLuMPXPouiG63KEbD+mQHu?=
 =?us-ascii?Q?pdWlur4l3ml9mzt3gGBRVxnA6SBXIsUjHfK3djivFxZVnn+Ac4SfTBeOUD/S?=
 =?us-ascii?Q?XUPx1AuT18qMPvV/oOUdo8h1ynCf8n0MVIJsqVwVnT2tckdcul4EGeqAlbSg?=
 =?us-ascii?Q?5PXHn8AxwDFfFNjODI4F2DLQFQLbejVV2VRYlDyN7iCtNJLrUApCsruhvgUw?=
 =?us-ascii?Q?ReP1gJ3g8hMSpsjbiZfmOcphQpAmFazSNobmiGFi5Jj0ZxHqhJiQFTSz7AoU?=
 =?us-ascii?Q?0Nfrx3o05HHyDnBO5YjeWZ0ZLeefr0kttu62AqlaKXXu2BzpqNyR3mKVdnDJ?=
 =?us-ascii?Q?jL5OlcNrsC5xP9tmQbgWncX6rgi9GcG4rQSv9fVglYug1cLqG8Q5TqiNoxpn?=
 =?us-ascii?Q?yPLAUqeMyjj9VxZ+l4rFoyAw/AzaraSVJmBh4r8zC3zD0FZDROsNZYSYjqSL?=
 =?us-ascii?Q?5RS/gfL6sbNgmnHycQ9t82qnRsNfkl5qr0/d2iS9hlGneb/dBHBYf+4enk7A?=
 =?us-ascii?Q?h2VBJcC9sXHLT2er6Tw6lJqLpFcmdSFPy+v0trpIsWSSkdqBHVqJs0mmEuku?=
 =?us-ascii?Q?SSDVP23bRF4kyhhFCFkOYgIUDYMtMlj+7vka6BR3k6tOQOrcpXdRmWHQkupD?=
 =?us-ascii?Q?fmIefdINTyARt/7Ge5o8WIL6n4poSAic4eGFrMTTak0GbuzWkhbMWiRM05mA?=
 =?us-ascii?Q?+TFNWYMB870lqEqmQcbxD/1JcdwUfo/4ldaAHhmpRNGrTZ9m1Rm+eqU9xNKm?=
 =?us-ascii?Q?ANCjaFISGj7fpR7FNrbPNH5KTG7bGk7AVunLLItTUBWSyvpYqcXld+Toacsi?=
 =?us-ascii?Q?xKq/K1mT+hmj+nfoEdWb2MwkbhePoSAEusan4Gfntu+qzHWVNKgYVWNd0eQy?=
 =?us-ascii?Q?AjYAVRz/MfUOlMmS+INSg4GOjgd6fAP2ISbpl+pv5/xFvI91xsjOMe+M/BS/?=
 =?us-ascii?Q?qpMpniuS1pPOEVw/9y6e2CMQIM1aRyUgNzKynh8QWuY/nmEK3Xi3ZrEmMeS5?=
 =?us-ascii?Q?kOR5UcdcqJ0bFQR+3+7iIBBvgcf9uALc/2MKMjvoYIcBJx9ZSjMlIUj9o6Ba?=
 =?us-ascii?Q?bf39L/fLOmuhpy5h+Fz9iQiARKtXdLebTw23bhZ6PQetqKyl098MDK04zqO3?=
 =?us-ascii?Q?go+JLK75w2qhZm8OB1nuFdlZnZI6vdnyrOlB+2A7CPvvigQ7jcytv301H+qy?=
 =?us-ascii?Q?pptQPbdJqQlUP8ebRZoAzvxWcCiQebwPHeWMMLV+TmEwhLT0AkuJZ5BRW9Pn?=
 =?us-ascii?Q?GVmBUj2qKRr2TI4eiCrwwCB182b43JCpUjYKxtmR5oZzqIpixOe7iR1RqrJ4?=
 =?us-ascii?Q?xWdY2cHl5KGVM3qZK3jfZzBQudRj6sTp5nt3uF+paKZiWnS0KiWrC3pG8GtJ?=
 =?us-ascii?Q?fFf3+tUkABpejLbdHOdYknsX/wU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d431c742-29e0-472e-6969-08d9b753f768
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:11.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2DIj1Bxtgd9ymLbYDVisItJDTGktLGchqw81grD/27WgmKmjVdaS6z2zgZkZ+zDTANm+VXXcdfAk8aiLhmQPmQjkA95+oESpGLz6f4c8VnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 2db59060f5ab..6f2d1d58a1ed 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -306,34 +306,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 33f2e8c9e88b..0ac0ef116032 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -806,6 +806,11 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

