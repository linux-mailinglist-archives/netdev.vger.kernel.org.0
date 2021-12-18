Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6B479DB2
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhLRVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:16 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234479AbhLRVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW2U9RYaK324VctffosFqWhu64K4ApKPz2wSJx8ELGgrwrgE+ss6BFZCvOqC3hp5g7rfTzXcrnOyK2Gr1Cn+gSXWZRN7iME+N/Xd6MU+XC/Zh3ULuq3AMOVO+gE010D3F9LorbCW+uuTZXTgaDw9XkQOr03YUciFn2ZA+7XVcIWyLHnKHuDBRidxj2gpnPtYx1FCaisbkIBg6h3K9PRAnzUCfalyu1rcgkG2r/A1b8b1JhbbnMF3gf7kQeEqmSWTzEtlWaDd9Y5JXsLkrZpfYDZBxr2zvR4j3AQORXRnO3EgyTig0l0jHCeDmCm/nT2kpubnnQv5TQCZvViB8arJnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMKqmCj/Dixm2MwPAU5k40NXtdtFq9m8iCvAqRZtU4U=;
 b=H7pUESj1I+6fO68mnVLp1F3HBJ2Pgd36vvKMczBfQeoauJnexvQoaLd919MvhYm06szANHI26Ot5WuaO3PiVnyjEt0gfyE8+at3+Bo1WtuCwQfWPCVhW+AU1x1lkpF/BeX8IqZ5uQFFv9cRIh2uZM7aOtijK50AO+a4fZ+FTy803y7l5w3ywbWWS4DGaPRRiHgzpEBpCKBJ9FpRddWm8P/S8Cr8Lmh/iXwsqzz21/EJoLda9bkDNHaSd/+oYOreNSkX1Oaf38OQWOCJDfmvuAzkTKsIpq+FP7cswero8eQNepEe45sbQ77zsGw4TIbsV8sKhjcaWKQq0o/igYU3jzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMKqmCj/Dixm2MwPAU5k40NXtdtFq9m8iCvAqRZtU4U=;
 b=fhjOOX5Gj77HrQU/6BamxX7bMByYz9WcFcXy5r7Q2mPsr1gIz1wqbQgQH61qifyT3f3vvnLfYUK3vZ1++vVnGmbLb14zd6NeN6h92NJIKbIf48EvjtaTcvmX4CIxNP5lLpP/x9MSZjHKINvKw7QJgt55qEkE7K6IGwDcbESLMyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 03/13] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat, 18 Dec 2021 13:49:44 -0800
Message-Id: <20211218214954.109755-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87fe480e-3039-4d0f-e28b-08d9c2705b63
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB563363E2E8AE2EDA715E6F9FA4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4T5HjLC9ZTes8pxQQI52OeRSxYAjauutj1joaUO5O9KKmzO0ESu/0ClfjOvVxqxbN/rgd8IXnvFsOUoXGIjPbmRxF4z4y2ua74AIzQRINtHDAHRbEoDzz9A+4krGenXZmcGZnIfDZxZAjs7ia/+GfSZz9aTgiaIUHZ3SofqkgUIXI1NhsqG08YBeW4FyPjiJKfK0OOiStg3cC40NyhtmV3Sak+r+YTW8v9IJPQW1hoNjJhP8Mbo8Y3noJ1wAmgiva1I7QvKTvMvA8t1a9YEp++y/TGJbHcw9ep2fB3dQi68tK5XjrlNl7YlPOepmLsYhT/D4IUMWp/697KyyeKk7jVohCZ+tl6x8Ha+pzCJTkIbPIUuYqFFbaUDrOKPJgS2OQtfUc3XTBb3qy7chsFuYRx0VY5ifdOaIuQg/qq+1Qpx74zDQijFWOAc2cFFztqjdvr4L2KA2wpF3KoJQ4+rBUT2bwYfshcsc8IXi8OH0GLroj5CS75D0S0JbytRwlds9BnQ9cjXpJrMZfYSICvNtDkPuwlYXhzUVDUrTI2OeXAAnES7zDyXN9htXx4iy4BiJd9p6pBwwieobvqMZGJZBHKzp9y3nplqLd/aEtrDSNuMQs/ipsyABiMAF6mQy/7g0Fk428Nae1knuUCx6tYw+kgxHgcUV1pxwG9hIz8yw3QgiE7LwqFt+eIXVJwa/2b+2JD5FLOFlic3b5Ud9UklQkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ff9IuBx0xjSi2U5kmCUlA0+57HgecFLJ0jPthUdWgZdwQXYVoWL7l0SI1Com?=
 =?us-ascii?Q?cTVDyE39cu68FvC2NF75zHbu7sH+LLhexh+5OjBYj8MNFkC4BXF81QDSdUAw?=
 =?us-ascii?Q?Bh9qYeaEy1KFmnu9KmAaVIXfVXCY1uI3I3YP4OR0+whUtC6HD6RfwiGzPLQo?=
 =?us-ascii?Q?D16X/TKFI/Dlp2oyVBc953k8OMFQEj+CRFRoBlfYh73YE70g+7peeGxCzj7N?=
 =?us-ascii?Q?WFpzjFGUitsa4eDibaU6PNn8uBMSKwfsnKLc1b3W/BTLnHb5uRN/uCHKlh/N?=
 =?us-ascii?Q?yKP4HBAd28jKEqoODCsq4AlLVYTSwSNHX/CL7hdRkNM+naJ8Z6NXkxzNzi/y?=
 =?us-ascii?Q?WgxKTSyT2zdoJqVo6/6L3JfgUxqCs6VVs/1B9KtV3F14mdHbgnSSBB0zhEm7?=
 =?us-ascii?Q?Ve+JlCx2rLVmKzOrX4VvVx6u4jjTp3vsLPC2lik8dZ9xYmXV5BoTkRzZoN3q?=
 =?us-ascii?Q?azATyQzQDNDaD5pGlAW8A7VXFeuT1zZ3fDg+nsW14DlAfEqb3MEpKDaOtOYF?=
 =?us-ascii?Q?/bZ5I4Po1rjjM9Ee/vfo54zUqYm7F+679fV7l9TdXFnDGzXL32Pv4EQsiPnF?=
 =?us-ascii?Q?NosLMQvYM1QlxktCfFjzkXME2RnrxoCXDOuyhkynvMkamd9b99FNm+1wf426?=
 =?us-ascii?Q?SEUGZjzqz+Qd3mtp1l5yWB4OrGsZhFIU/YP3cLZkMuUM2pzjbEeAFGevF8Ac?=
 =?us-ascii?Q?xzp5iBe2utFkjlWx7g67qSe4vWk09Z+Aw3FLg5jETzzep8q6fzRn8SJodOin?=
 =?us-ascii?Q?7OXjk/wG4uWBseUY8VSgZ7cFl8manHOZV+Plj6wPb2yy2p50VhpywzikC7ch?=
 =?us-ascii?Q?vJE6ZckhIPvQ+M64Ao2n11NT+OE8yUhIxCVAi8vBH+knAtT6FQLizN9jsrwx?=
 =?us-ascii?Q?Qtb5md4K4htTWesQNxX6lyIK9Zn1fUb5M2aOFk9wKPixOLs4m0ng+Z12XWak?=
 =?us-ascii?Q?L8mXD+BtN5OhPcXMRl8zMZGBt8MWAoyHKO0HgEzyoH6Pv1RtJYPLBLq2nsmU?=
 =?us-ascii?Q?isAzT1zrjR82qIC9geXl4zxU4X7tZrw7KqTkQO7ukutAOVtTVnuHL2BXFjMv?=
 =?us-ascii?Q?kXWPJ4nMbh2f6W/ghloo/djOPQkpfea3/xWoVFprVw9TwWiL7HBy6hSxduFE?=
 =?us-ascii?Q?cfQ8YS1hZJjImWi7b0WIbtW/OlYOM8ZO2TjhCSvCKdZkITwA6z4ago8atc2G?=
 =?us-ascii?Q?oPzzpX7u9Mf0PKMYLQIcwsGo1ksA2JDPTb1gBdIbodh8D5cjA2O8Kj0Epzh7?=
 =?us-ascii?Q?a0cjfCotjermICA3qQeQddvQMfSiiljjnEhO3aDSDW6KSELw55SJv2gtJNwi?=
 =?us-ascii?Q?QGH7K1QrvbmPBy9OOhWdPBP96FdvIFl/jI6o0pm7k4Uw2bD9f9y7ZnUsX/kS?=
 =?us-ascii?Q?sZ/WcvvD/0cIPopsAvjZOkLHbHMySiWAFSw7Wl1mx2tL4IIGuXM94DF/IwdT?=
 =?us-ascii?Q?+miFwTfX02IUV0xfwsGJd2f1w/3e60x9ZHWht7cQpQ5M3SQ458Y1EbRCLgWl?=
 =?us-ascii?Q?2wFtC8kIDVKFOLF3aOadC715I7W8VGoBYfTYFYf2wA22rxvOhF4WUHzK/pdu?=
 =?us-ascii?Q?ktUHLxopoJiLcH6eFr1CmLaaGIm2YZkVsj5wtq3ojtgQuMSht+7CVxkazUui?=
 =?us-ascii?Q?NLEO8BDUqJ4j1aeFJafYAYgKBcmcW+qZN4AxDq/G69gR7hWSNIglzQG5bXM2?=
 =?us-ascii?Q?XuAKGg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fe480e-3039-4d0f-e28b-08d9c2705b63
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:07.7690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spVaGF8tmTSzzLpxKTWumXd961pg+fzReTzo5McUBUHs0GPdhNDsvbj0YQ0erJgpyWm5eXlWt6cFQlMZ6Jt9AGlofW/m24OEZnUT0r2GJHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
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
index 4f4a495a60ad..5e526545ef67 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -307,34 +307,6 @@ static int ocelot_reset(struct ocelot *ocelot)
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
index a641c9cc6f3f..37bc9d647bc2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -812,6 +812,11 @@ void ocelot_deinit(struct ocelot *ocelot);
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

