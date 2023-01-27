Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2F67EE32
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjA0TgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjA0TgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E283A783EF;
        Fri, 27 Jan 2023 11:36:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luNlUY2tEc1dQCye2YuO2OcxTG5sOL3KubFMruHN+GAuknxL//HnHWpZa4/6pL3QjGfp21Sa3JFp7KlhuwNLXd84OdRTANZ6c0xRFGxjKKTxpssN8vOer/iB+aO1bgLFs4kN13M5u2jRShhNbmWop3A2duR28nFlX0r6pttTVRILrjGmHOVBM3S48xkiCwf9p5ivleN0ULIwzizjqwpe4BYVvI2fHSWhch7JnIuDfOdLo9zXMTVzxo7L50oKvC2HKt023n2TtUvkdmhXCkUqq3AfC8pVm/0kwAyXACMsX1vjXNQeJElVbq9wKeRSVsal8iG6PyIay/0XXApcHtczvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4hbz4kp7kOrFhm91zD/Uo8d0jqjUUhJppxV1VMXjy0=;
 b=YI4B0FwgORDSTjSZ8750GT6xhLqDjeBZ0ihvfsGJMACjCr/cXJ7eokzfo4Mptdt9PoQWEHsWMb8MdewS2UGVuOTGkHPi+U1mEzfH5SpCS59vGo0MVhFZwTZoMLQP1A3X9QFwbQ09RnGakDRbhdL4mCZYlDWc27VooWPPd3h4VXmnoP0h2xXTYfONVkNk6vME6BuSxuyLZNg7z+sr1ascQaTH6JmkVM1LuNxKlsyPwzy/nTgppzDiDy9lGxOi8vn138/w0VP7zuVcPKNW4wRLA6pwLtRVkKdFckDMbbAFJzwCbaO7DQRqCkoUz/Pl9xelOuc+fgS5GqQsnMxv+WFlcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4hbz4kp7kOrFhm91zD/Uo8d0jqjUUhJppxV1VMXjy0=;
 b=XXZgFg9NkwDi8OcMaf0qIzOGS1Nhy/VKKu+UAgV8uE7ommlgV6jdYfzfK+f9CxYJOmxaOVqXbNU93OE+Md39NihXwRSF7WgYAZZRpmeF8vG8aaeUf9GZqWuSQ5d2UMzHQ/7cWki0ZNxRPyFEYRIAxKv2mKEZgfVo7a7S6dH+3J8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:13 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:13 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 01/13] net: mscc: ocelot: expose ocelot wm functions
Date:   Fri, 27 Jan 2023 11:35:47 -0800
Message-Id: <20230127193559.1001051-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b025a91-e30a-433b-a009-08db009dbf74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItGWCxZZxFw7Lc6I0DCC/pm/RBaXCsxFKdZPGLvDNUOps3xGyaSepb1l6aZqaz/T6QlTi3Uis8+mPVlLaRBYYDsX76fR8ydnwD9LkuesmJxrn2tePWrDGez/ZEBwHpuVJz9TEf/fmZnduLedZzeRhISzwMrSN0By2lByFrsE975vUkUgNNtX2Ed1GXC6vICxsoY1MVnldsgHWb03AXeFcRfa6tJYr7DnNLEeZG283UPfOrweoyl77IAjlQ56qWIkYsgMANJ477fqH7ClxXZckvs+Oi+d5bNBXGJojNL694Uxo1dwLYRrEqgZnZRKpE8AS5UAlHD3N+DvKOqf5k0AEZDk2kDGnwAfVcnzN18Y89WH/XWt3jRZk7PL1Ik04O+WnfZ4ebrf0Xb1KzUh3b3JrWO74BnWaVZnEjdtIZBWhssJItHaahekuk9sOizJlv543Tb+v+NLU6o7Mo/jJLN3RVG5sRLCJaAqx1YMyo5TDc8+3M1UjoLYLc0j1Fg/pjbWLbWo8kOjjlljkjVa0DcUQ86OvEQmMZvYDMV2TvMzNAzJzBid1avQODHolQQMj8ATkd/QRFs9dyItBlxbqSnkAs3bfZJx5rhNb4K+EpnjYCJ4T4pH4wEiuQmu85CFHArSHVVBo5RncSSxKxqFwsHwRR/3+aWySywfEhe07XtRpkdZ4VyEbGkWfg4krMomgcGMPxh8PLMJ7qrstsCaHx/m9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WtB1Hy9w75+JeLPElhMPHhYR7MuY88IU3FmJQDWBGh9t00uqD3Q4svmIe9mU?=
 =?us-ascii?Q?IPYxVKAULpewAJlBa/bP/r2IGgp6q2x2lYFbR6en2C2vrj+7B/CFFAs1U7BU?=
 =?us-ascii?Q?g3pgKaNPbmJQeMTI6s+U5nt7F8ciU6vYXO41Vs/uo2O6AroohGLCCEkWEWqi?=
 =?us-ascii?Q?1a1r21fiHKGlvH8y2WaiFn5dSkWrKwMI2jymQXhiTc68+OO3xinfccIZ/Ypn?=
 =?us-ascii?Q?b5tTX2NKrF8nLTZnLYKuCZsPfmFzKUnrysnBacwVted8PnogSJktxCwVtk89?=
 =?us-ascii?Q?BPnYX0IXxQsfQ/9DZ5ZwfyQnWpXmiW8rC8cH8FbAo43JgB3fZNrYy7w+Fqvs?=
 =?us-ascii?Q?3CAQMLccxuBjswcDw0d7A7iBuwz8hlvs3JpBCahVjC4INB/2q9Jy29cxbDQB?=
 =?us-ascii?Q?41VSVpkxCWazeBfkLC4Eb34ceE3Ce4HxCK+CC2YhFx48eBQoln0KrvpcsPdU?=
 =?us-ascii?Q?OgjwO5/Ferb8YrAnJeBc8vvcx2ep7oR1oPtgdmKDfwVXc8tyOOrfTfTExrSo?=
 =?us-ascii?Q?vKmpjAc0QZCNTDThtl5sY7gPdapPR3y3keH/OnjDfByuQOiF1319ufHEFRXm?=
 =?us-ascii?Q?6XPrXoxh9nCVHpdcjFTRprSaBzsVP+VDvXn/sXqVv3gm4tb0MVPTrMXBU6Bi?=
 =?us-ascii?Q?c8tiTn7SZ15jncDWRC9F6sUHvkIkWb7+WUJ1zj9YEwC9VcSnDsj9erW0sCZT?=
 =?us-ascii?Q?ltms+DqhJ0lNqHgsubEdnN23vAl090cmuALSdCi/Z6pgt2WYvADCsD2feFgb?=
 =?us-ascii?Q?3nNyJkA+zG0UpFHh0LCUcH5bvBpW/sgoD59xfqDukAkbrOIVSvVVtqJOoSww?=
 =?us-ascii?Q?bmZQ373jaNspVSjCQhEUebNmlWMP/zdYGGcOEqNNZjw9lYF8XO5ELbv/ZgQS?=
 =?us-ascii?Q?9QSARKfyfIhgACj4EXjN8XIl0pVtFtTJZFubbrJARalVYaDjYZNBo31wWgR4?=
 =?us-ascii?Q?r54iNc182LUsnOSoTrlK8OuCJa5o2C/jQ8JB46nZ1XUI1OJjL/6o41vtFpQo?=
 =?us-ascii?Q?TJwAGBq2/+gs1qzfi36MqulntovR6MziupzxUSEfgvUdwCCrTDKT7YvT/vVO?=
 =?us-ascii?Q?jDWKu094V1zGP2KEaSbQZMMIjPKuji6U7kTWVgKX3Ro1jZEvctKqEa05bJEn?=
 =?us-ascii?Q?YstgAqIazL6eBFI5vJB37jXxSfWnndrwDDzhOJdt3ZtVpqrjwKTXzlXCBrud?=
 =?us-ascii?Q?ZsfkKomxFyrcxn9KhrQquNrSI/O86T/kfijp7AocivR0mjdizcFoIfoonPjH?=
 =?us-ascii?Q?MiOeTIaQ0MjOhM7D84CEBSbQv0H9DzNM6NMeNV9CeJq+ozJsAT955UlFlLBZ?=
 =?us-ascii?Q?4b3BdrGotmYjTU3EcQkRHZ/+zQTREnrDsZG41S3jKd1V3iIpuveYT3dGupVn?=
 =?us-ascii?Q?KeCwBCknY/hY/BFsgc4Zn3naEJzmHSdxF7jh8Chs1DbyGAxV5V4ySCE7mKzb?=
 =?us-ascii?Q?BpLfIyjFCMj3KhWzWjyPkZ8pfa6Wz8HhhYqrraW+iWADrGvUIDPOXDhvKBsk?=
 =?us-ascii?Q?CtdDgUFGrLJ7CyIcmLxK1ZuokMOcaK6s1h7Jlg/qppUHLhYgmtelFUKq5hmn?=
 =?us-ascii?Q?1b0F56GbCP7L0vCnqDuvZPamXTTs1CBYQKe8lCl8PmJrBEbou0ywez+4in/U?=
 =?us-ascii?Q?rlPH1ES4KouazwpAqnh/2Fc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b025a91-e30a-433b-a009-08db009dbf74
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:12.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1h1UH5Nrl4w61PftJQYjVZUnOpNO3QeIeRPFQNi8a0Ku6XyROw70OF1BxRHJpMFFosSNEhnnoDMI81h04X4tIyQDsCN1U/vMw0fnZn3/0u8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 - v5:
    * No changes since previous RFC

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
index b097fd4a4061..a3a36de063e5 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -229,34 +229,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
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
index afb11680a793..0edb16b6087f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -978,6 +978,11 @@ void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 
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

