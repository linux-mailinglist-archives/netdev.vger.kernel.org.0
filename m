Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0FB4578EB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhKSWqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:40 -0500
Received: from mail-co1nam11on2131.outbound.protection.outlook.com ([40.107.220.131]:57696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234547AbhKSWqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxT/lFA77pzy9OOEorNombNyBHNYfQ/y9IaYrbnYypEUN3Ydztm8V8eCGBNPKpgptzlmjC6E09sRodaDOt1goRBK8RZK2RZHRqle6Ie2hiHe08y6gPPtlXkpV5rBv9MZi+K1X6n8bwMfYmrgK9sM75VHZjirPGedshgHb04AmwFd4yNR/O6HW0bOmfZ3CzdVhlM6WiF4wdXVgXOkv++ob2/ohkpJZ2Pam/SHm2B5/F04sLWsiQXEbbkKIneneHSPgUHAt/7mUJaYoUfcjL4+PVKxOJ8fsqvT910pdaFJqNl5HhmQotQxdt6B7Nc4t3uGwccdXaxmFHH+WkfArHTYUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wc3Pftj2m5JDF34IXf8wyGPjfzg+HPCVHIxuG4mCnXE=;
 b=l4AL1Yallc1en3LtPfTAk4TKrG05MoiiLwS0VpwkcXCaILJRRhxFOFERU23lY7l4dQwl4oulMZq2eG36L3zmEarIfjb2DyO3RbsEKhuaqRa1dfUOmL4egtonxxV/jdzlI5WZx14+S67XlxVwPD1sL/OatrsyeaCVFxODmbzSXMdmkzJV1NdGZHjm6EQx4gD3V8l1bIvSml+oq2muDf2avOFhY6RiRlkIP2SVnzgRmSVUmOt7/U8qaYvOtFRjiphv+ujk4kDD+tKU+7/lQVfjmMNDogOowGZvXoNX/dq3kNKBp1ZHv8aUU/LxLU73oehy/VU399UUx8B7RpBxm9szMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wc3Pftj2m5JDF34IXf8wyGPjfzg+HPCVHIxuG4mCnXE=;
 b=xvvpd4LcvPGjoHsqLC6tWuwRnup9wWnvoaOYYtiDFsNJM3AEqhPuCHy/XxI2uMTfOH198aCZFiLwNtMU4OSLSR0pZBeu5oOU8c6EiJf1OJO3sZralhGD6LkFPXbSSFgu6A0MmAw2qrUBqO0drH1ilegNHi2yyC0Vwj4teKFeLwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2238.namprd10.prod.outlook.com
 (2603:10b6:301:2d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 22:43:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:28 +0000
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
Subject: [PATCH v1 net-next 6/6] net: mscc: ocelot: expose ocelot wm functions
Date:   Fri, 19 Nov 2021 14:43:13 -0800
Message-Id: <20211119224313.2803941-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119224313.2803941-1-colin.foster@in-advantage.com>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6063545-73d4-4563-b026-08d9abae00f6
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2238:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB223810BA9023668BF6DD1EE2A49C9@MWHPR1001MB2238.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0e5F4hMDDD0j+ocMkBgmOOU6izUsf7SGwNAcmDW/nkqSiLtrtwpo79yUM9ce2Jd8rSs8JhZhWfQs3BTD9BjvRbKp8yHJ82AIRf23+akaM5dLUpkQwscqNKakk70QdDk6ZAZ3cuDZOaMzQ0Bgtx+6OqMztYZgVVEgA/+I67o6sQ8+ltiIIpG9fSLoIpZ4BL1icp4kz3ZMyonrIGBAtREgk8wieuMaxZWV2VDbbeJ07TwwlJhbk+voZ884qZ8Cqeq1i0JL5MTq5a8OaGnfk/zK+38EC2WorlhDUueSUhnPqjSy4lQAThetPQR1AUQ+SrUDkn189eiqLxB8f9S6lJw7mrrhhogyVsR7YLpibQIovXBqf4NBLpTEZUGkRG844CYwvwpyptJCo4jqU3Eo3W4a3ha2iRw8CKjU4MfXfOPOcB1Sapg1JgOQy9HT3mlqS0N9QGYNbIRM076lti8ygSeYKnJuY8gptCBZcwtBV8EIdudRZ+8WaSoUQ0mEg8lVgUqV2xO1vPvuRtFfdtafEiGFINnVRJtMeRhgefgxK7tL/2v5rslAvOcHIW3h88mx8ke+0Jd/fD9GWxOnJlJjDyVTI/uDfGl5eCqHwxMUUJ/arS3YRW3IKCmtJtxN4Bwf41kr42zV90CUHuTnV1rT6aXTIrpAWMkQc4mq9cJTc/2pXYYLBbxrSXC6AoVI6ALAZ3m3JLhr/cyevT+IbZZjS1SAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39840400004)(1076003)(86362001)(6506007)(26005)(36756003)(5660300002)(6512007)(316002)(186003)(8936002)(52116002)(6486002)(44832011)(2906002)(54906003)(7416002)(66946007)(66556008)(66476007)(4326008)(8676002)(508600001)(956004)(6666004)(2616005)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5gSbWUoTfdBrYr/IBJYTotrNPAWJWvQ499MOjJ5mD5jWk22IRvnnOI5XPw4G?=
 =?us-ascii?Q?pZOgpKIsR/RKwRPfFT/puSDIHcB4VMnXeAvv2xOaKe814J7fYe3187dwPztU?=
 =?us-ascii?Q?vYqvGhi/N2Y6RtGnJ3hPSp4UWdauLUxqrhfH8a2htjfHu0V+3g2Hx5uHaQGm?=
 =?us-ascii?Q?+sCG+EHIui21CFsIwv7JdXu5FW2U9+Ge2l4LDbqqO15MLmH2sUnuQyJMsRFQ?=
 =?us-ascii?Q?1gwxpfV0OS5aQlkQ9DFZcvY5K4zswbESGHTj9iJFFjrDaltGkqrLyx0XVpr/?=
 =?us-ascii?Q?IHdf3ifWe+96VZ2gzokfEO4hJ5UW7d/SqdTjBGs70mA19y9U6nGK0fFEt/xd?=
 =?us-ascii?Q?vJWNyi+IVfXAhkvJn1Xo2ksMErQIZ1wK7sM+cGuqkWg+8Dsq21qnnGkuDiZZ?=
 =?us-ascii?Q?tERxRDBXhyMmRG9SRpz9gyBRkGvvXCckLsVyFfYftZN7b1zmD957qOzlTszF?=
 =?us-ascii?Q?k2r/cNdyXLhL+0MVgwO6eNeffbNFFVYucewEJqZV5RhAyBqTzWtti1RrtzN9?=
 =?us-ascii?Q?HBCi7P5gwcloMCCVU6Q5XfeGJ2TkSpEkcYI16OI9zoliDNzo6ArTnBmJxmmn?=
 =?us-ascii?Q?w54qAH62lBAiCljqrnaGlJTGCDX2cqRxnpwN6JMa1vAPx5uucyu5JKTD3q9Z?=
 =?us-ascii?Q?3fc4gItK4Rg9Wpp5QW4Rrnadh8+TS5jWSNNGtlbOQcQFsbD38Fj2G0tRQ/8R?=
 =?us-ascii?Q?oV5k17aKzpylak1jBNfO9fRNG9aq7V3WzxMtTW4gDT8yXGh633cEtg8W0G4W?=
 =?us-ascii?Q?sukSsMvLTlw9+32M+ygHaqU3jzXQWlB8E1WAl2yTfnwjHrHhWcDmflT0iUtL?=
 =?us-ascii?Q?XG7N+O5TZu7bv0UBuh9TxNicuaFxkS3MMpFwvqXG8TAINC0QivtFB5ePGC2u?=
 =?us-ascii?Q?sa/8C5Qf/teA060fHHe/WjuVPINomWbv0zah5gqRttQI865LKagJ2itWXJf+?=
 =?us-ascii?Q?ze+szzfL3COhFAwOpSQ55au01zlTYV3jyA/cLhhP7s/fWh5jdpDdw2obvP46?=
 =?us-ascii?Q?AkbxX06V3ZGkIsRq7MQMeQSqBo6p+ZU60gnpBZgBnbHxDCvBnhzhf7ZGWPkQ?=
 =?us-ascii?Q?LqoIbxe564LOFJcw72/1fQU/Pb2DPelYmTXirqq0atC5O4B4173EwTt3PQ4N?=
 =?us-ascii?Q?Xzsjmi7xv1tcCbBz0spo3RWPnGPPYy9G482djLsvPOQzj8mFyo5IKdXNAIoN?=
 =?us-ascii?Q?aqRlqWbyoAuWB7kQIJvj3GBjyzevG3dGY+KWwfaIfJ9hXGknKfec7qmDnJuk?=
 =?us-ascii?Q?3tTwAA5sOf6i1N0RrkLvubSz/24MH5B4LwvuKCWJE9ak+e+beel22pRO33Mu?=
 =?us-ascii?Q?x+5z8HEU0BgBSZbQP+5/zxUSLknTl9CzMx5Pcwt4cyogRWBK+TVBgoMtF9Re?=
 =?us-ascii?Q?2VfEHB5/w0raeRqreU5zQLhTSdSXy3bIOTwR4y44XOGZdIhgVLO1F3m6ronc?=
 =?us-ascii?Q?CAYSyVqiBsGLWchq3+OWHC85OOEIE9eJMWSk/dw9PQsobeLsIoYSf1iC871u?=
 =?us-ascii?Q?2i9yoRUEzjv0x9NLSq0jP6zG/RWNnYHoD7e0AVsTSW/2vO2xuPg+R3oGfbLF?=
 =?us-ascii?Q?hJeybDVSfm1hLYOROvV8zwxtocFBB1jP7RTRzsYEGUHGb3SDZLEAiEsBoI07?=
 =?us-ascii?Q?5OcP6PFc2P2pOzp2dOo2hq57Yuk5a5ZSgHvKQTEXQclwFk/dHUcHu2ACI5XH?=
 =?us-ascii?Q?aZAVvIr/OW5mifCQTbaLmPL4vyE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6063545-73d4-4563-b026-08d9abae00f6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:28.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNO/xo3Ov1DwNVydF+CB9uYbp/y63spWiSAPeGXGT+ldwGpNaIkRK1OrRoVgtnuOD/0ouYTJXm/dKoFTprzk0wkA2zCJXfHJT26PTDrGSIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
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
index 89d17629efe5..e7eb1486b63f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -801,6 +801,11 @@ void ocelot_deinit(struct ocelot *ocelot);
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

