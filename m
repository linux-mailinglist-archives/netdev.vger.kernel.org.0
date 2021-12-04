Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A844686F8
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385445AbhLDSZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:25:15 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6433
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1385427AbhLDSZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:25:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/H4TWcGNFRx28/XqFEeabZdD8GHn3jNhVi+8GgzM5C6qATxlwTB2j2Li/Ky0VOJz1jjG71qB55ziJElVAsTA1uQnAoxaVQWKUM3KyF1yvAvUwlHFe6YMlxnK/yN26grFNE7hAiW8y3unUoh6BdW3EYGa6kTDZxNikmioYepmmX2CqsWF2bkg2Gu2F3zhE5Qb2A8Vz6suaRFOI+IWOYt8gTYkY5HzlMoveD+GYSKu3FWWTImXk0OXz1L5IOGEGb8qzRWsGIhS8oI9EtcZ9cdbF5QBFLManGNzAhiw4nC+bCEtzzHReiAck/wAxfrNV9EwnZE2gmbU/1SkZPG2D4GkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=YDiqIoF6CPK/Sz9+s+gTYuBaxZz2FYejtuZK3MXTX6sofCkKNII+cmdORhBWJxFJ5VizjjPxnnQ+WABag5D53oiqOsfmsGG51zt/HMJnQJV2m/mTneemNt/l9P898Wv9P+pRh4uN6utdlr6EUCdkiFB7xZKhZ6VYQE6jGrfmbxPtQhQ9M5bpY4joLWJHFk9E59ndfkfvhaySF7Ic5U2tIAn3ibAoGO3pZCOINJkUSLX0WVIKN1pWbMFISiFMpz3aC8UXfGU6Y8+pcuev2dRS8sRUfFrpFaVWkAEpSv638v9W8i+ottxhAaMPPbsg9vTUzRF/906oZkQ1d3h318LVtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=P7OBSWrFa9R7CTMnHOJ1ubPXq7sD4OdXluNJaDS+ubuBOeB8zcx/BJtvndCNMRdBaVRCJqY/OAfMt3QjOf+LFMhHTX4ymm7yMKYzlBCFnmWlHrfWZGpf6u5e/mK01t7V8G5i97sQKkDq3oQ7CqRrdlcOgqElPzy4YakdN/RvJWo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:21:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:21:43 +0000
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
Subject: [PATCH v3 net-next 5/5] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat,  4 Dec 2021 10:21:29 -0800
Message-Id: <20211204182129.1044899-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182129.1044899-1-colin.foster@in-advantage.com>
References: <20211204182129.1044899-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:21:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 485bb768-985d-45e6-9f48-08d9b752ec9a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20617D9366628880E303FFFDA46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJ02rr/12Lhg9M3DPfJEzetYvDIaGlmQE75nV8C6yQCyKcSgYRVQn6GWdl0QUXv6Gb/DwstSNi0wKO67/3ss1K8bYChXH805LBAazzqjAtt+8QokpM6TKlBaSDBpgkl8jFiOZfz6hUR4HaPqoKXujstPbK7myTmwwzn/4S45IPCLxLS+Mlb01cEf2I6HNcjnFcAgcBCk34aFXAFtVAORCuRB3azV79THSGOuG/zAypOFYjIkVBSB7/K7rkxAcsWFAz9pMeHZnPI1ZW5WkSZR3luhbvCU+cOnKVWbUqpC2dSLfL5NXbgQSaxj+va0w239ibyJZgclloemsF7niQmMztOmjaHZXJErBVZgjbRwriF/2ZEbeIixpiVjvNtrCrrvphH8rZj2WLfOS9sqdScUpdAEIBsHzCTxke7uVrqmaNWd8VKCG7YGLbMqbIlhge+DoowIsz0eLjf/EojdA3YWQjaKYUTk1pYkAOjhMvuuGNauDp3s1vCqRM8WQrqZtNqzNlG8xSvFaVbZUGWE/bNCKb1F2I/PrvFLI2T87GtoA6P1ChlNZBJ7qFld0rS+cXpdfvoBacd1Se8o5GJ6pawUIpakAc/rO+suFDQlj/jr9gmkKcGUN+KwL1Qg6/gt4g5KT7aZFyzyRzV7Jm+2+DYxLp2xw/V4awd40yyddnEkUnYmy96IUTyzmijEmnNyUAnaqu6448F74hquqhSiYBdPgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(54906003)(52116002)(7416002)(6486002)(2906002)(6506007)(36756003)(66556008)(8676002)(26005)(186003)(66476007)(316002)(8936002)(83380400001)(2616005)(86362001)(6666004)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VqcAaO50F0xHkCN/rpK/lJ9iw6R9kzr7ah82WxlbqKm9zrMDHuNa8jq4uLRC?=
 =?us-ascii?Q?4mIxvRxuwBNA8Di8oEP+UIC2Gi5iTX6L1HRB20cQ/NDfffKG69sYqPl7alUA?=
 =?us-ascii?Q?YiUBNKV1CuVX0vlb5Oe5olBVmMOwMQyUlLQ+ZqfKT0XSoEYqEtzdlfWpSIHE?=
 =?us-ascii?Q?dbMMKleq15Gd6njlvFKuaIMJ+qO/uECFwbQKzzy4sIIUL4oI9U/j9bMkJQ66?=
 =?us-ascii?Q?jP4r+VcLaC6Z3xEQvXFe+0I0+nKK/LUBkZsDFgYAGpLAw4ns/WGQRWAFehH1?=
 =?us-ascii?Q?vuDkclMx0BROJIcTv56Tk/b32G8q3vzG1zArtKGgyPVHtPHKHWDZzL8Pn+KG?=
 =?us-ascii?Q?3xavLat4E/KFdCcm5S5YzYiTUnhHYwyvrJ8X5QFrLzk02DWAvwHpH/mBe29k?=
 =?us-ascii?Q?nH8uayMj6O4IN3w2L4nybmrCo/3znAw8UpAACSafODKW7HsPbav3Oe1OI31z?=
 =?us-ascii?Q?S77ShPf4pueSO9n60X2v+VFqNuJvQFtL8rQhDgw9kNjavFJGPfu/2s69y/Bq?=
 =?us-ascii?Q?BgU6/71aiBz7CVzXRJpcDovbN+ive4Gf0Z5QvsZJUpkuJTEV0MpdGQZT4ALj?=
 =?us-ascii?Q?8ZvZB05j5wW7OWwHs3+Os3RuaKp5kT3uFae0gOek59l3leSMLi3PDjt/Kfh6?=
 =?us-ascii?Q?5WRrKZS2mK5RIQpXOPaOOL+/zsvMeex/y1fWXjAjv8CpnE4U1khybY7hvOD4?=
 =?us-ascii?Q?zBzE9PFGsDqrUGuoxidj0s/vgCH4Hfyld3VtuR4QKF4PR21Efh1k3ndMKYQK?=
 =?us-ascii?Q?SI+bvlfUf3Y1WqTYUD9oHmzsOph4bwBLXOJEpfAHuU9mUN4EeB+QoGEALbGH?=
 =?us-ascii?Q?lOdUF0ypi31bxIE8NEjO0v/vwmhrWNadZIetWuPW9qViNSstgM+Ii7rfNpjS?=
 =?us-ascii?Q?exJ2aQezM92yC3Zz8gOX3Y3foOQHwqx3RHhR4lJFXbhLNCh9jqsin+vxyrzI?=
 =?us-ascii?Q?MyFQZWXX5ojUa7k3+lXINga8+TXEFKUV8A2moGGru7OXNTeyNrQVUu+thqZa?=
 =?us-ascii?Q?KD8iawih6NEzmPkvZ8e/NBBXa66E17aJ6S+jBbG84b8B+eQ1pwq5C6IHzBPy?=
 =?us-ascii?Q?gyOcB6VgdLhuyKHatNQk4XSmb+vQXZ0Mh22r1YxL7q4FX+vIPZJ97fjHMRMh?=
 =?us-ascii?Q?AbT0T1Jw1chZ+LNHwRiCgCTWI1vE4WoofeCeeQ/9LFxM1eEa8QBrsrjuP9zV?=
 =?us-ascii?Q?To/nnOUtOn8kw8cnzZtZZSp8kX5fA1ZNd466F6cYAKmU8mJj1me7Zpi7+Pma?=
 =?us-ascii?Q?2krZLo75hFBhfHusVeXs/x4susTiROwV/EddkWCF/N8D1IU1tQAMvPb9U5pd?=
 =?us-ascii?Q?4Fe1+0sLAzohOP21DfvZWY1cx6+ZG9oq/AaQ9IO4NZ13kq61NH9VBxa+D04I?=
 =?us-ascii?Q?apm6llM7KD43tBxF8JnQxp9gU9vXdY/Bbs2uMU/5/MvWRtOlK5Ghe3Av6Vzb?=
 =?us-ascii?Q?/ftxaYQr5CKQgbVUPUTWx3Fk/J6y4Hmro8sadDFhIvCjR5i52+FXkXPaVIm1?=
 =?us-ascii?Q?+1C2LR8A0gT+24//pQnUVreydhWx81SF3+txJPSrPQEXFNRssaP87Cxss7zZ?=
 =?us-ascii?Q?VqNpPhJqwac9cYSl++JGGlEifpyLiCk0WUBl+jE3v25IkUTClbMygeyhljtg?=
 =?us-ascii?Q?BVUIY0+Mq1rX9XUHwdTN9qgaf0F4wsvIfhF2RRvPUqxosQNjMr1JMVOsCrsh?=
 =?us-ascii?Q?oV2Yzwhrl8Z2U4PIjtK7iDZtI3Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485bb768-985d-45e6-9f48-08d9b752ec9a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:21:43.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzJW/W7fCx9fKHfFmBFVmOn2uIvHIgjAwQxTVAaLc1ZsjoxrW51/EsqrCwjcT7N50SPiQmMl311DrjclsVXHla8fXRKqMuQnI47C35NQFxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
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

