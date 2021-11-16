Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C7E452AA9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhKPG1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:27:52 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:60901
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230268AbhKPG0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUN2pxdQ3wJIDY78esgCV6/3wsUly+aFIYRLJGcNJ+fCSJSyl7tnLuqL2uFN6UoahdEqUL/A6Dm04YAjYVDu6qQdno6cAl1d6EVlR1OqNcx7GdBxo65+HqY/7Cz4jLymJA/n1yVbI7qZdjOoqHLvs//ZhaTQgelt/ECdzEfuXL84fDImU/0AbiIEZyO1wXT0xLcPmPmFXthr7kr0Y4/Z2QtZ7/VtArLcFaczgzCXMtBzhy4ViPGifPy43VLSHZ7UhpBcG8Hxq2cxPLjAlJLG6MZjROZUSzbzh6A7h5+b+QxlwTPvmMEctp7Evda+gSrAQ+3NRSCUFyuBkrOA1PSsBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRiTZQApgLwGpbYsKquz8UoXqJIsGDEjysbhkVGmnt0=;
 b=VEmaSXJN8GrHakcWWXd8BMGfs2V0cIAKupGF6r1agC690Ofo87/PTVGe9qkFgvKJi88PlGcPZ4MdSZdo9wuRt2B+u0M9MRNzxSEuO8qhzwe7o+YCrhji4aoEbo68cLCnltrftvZuWPyvhOheI5cA7moOyqbRSKGPQx4X2TJghDz7DmVKcEKJZ0CQay8zzceOKWUxXHc3B8WUyFnDPwubmVN6ZiTu12rJjgM5WJLjhJzz9N6fTBtbz0XVSA6QOepuNtLGsPzBvpX+l3md2sfWegN9uE6bVFl9DxHeylB7588eC6h8AE0CulAU+6BXs81nSN9efr1I8M5PAIYe0kMxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRiTZQApgLwGpbYsKquz8UoXqJIsGDEjysbhkVGmnt0=;
 b=FbFRA1ILG/vciVRwxupEcO+9riXELPbZAjwqQDOwjjIYsPXAAtFa05/VOpX89l+QgPVbYnP/wceny1pNLkecTziteN83TA4f4CLyNCfxnD99LDEMxejjSuVsGt5dX9ChzZ274QAEGJspLqtYKB5G1vM4VXZuDLakVnRxWNZ+uDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:49 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 09/23] net: mscc: ocelot: expose ocelot wm functions
Date:   Mon, 15 Nov 2021 22:23:14 -0800
Message-Id: <20211116062328.1949151-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 991fe34a-7c62-401a-9a62-08d9a8c9a6dc
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB47222B4C511B4063EB35764CA4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdDL7xhlHH3i0Q4eEcjSSjunVdQgmEBfpSWymb6gMtedqJV5yN6pUKp/T7gLXGyyB/c53nC4mDv1fJTeZEwsXwTLKv1kwJYHP91PanJ1g6njtAieVrITycaGWOjXzTQMGIsc2TPrnTLMkOzPCfGrSifNWfBALtlo+Rp4a2Gohc0unafLFbUhXI2eT9lNREcAcFhgRwlyI5ajV3yBqhQCLDV1I1xyLY876GRO9829iykSH+qdt48fln+hUE4PG8xoGpIhCe7Ox8j73/VZFa0MR0EFnkBspCzW5tl8z1GjwkjeI9HsAFDfiUsaYaSW3QygKt+uDB8f7etozemWWifsfdMDjdIhJY3k3UKA0T8wwwNzNtCCjahu1n03pBRAArDuQ+55oqpj7LOBoU9exKhux9YS0EEHnn3LXGp4an/vLt6a2fCjBi+xApkdGnjAIzxZX6/RtaHNaPtm2mCn00DmUmcW4x6CVnSd5SzVpoS/bctu8KK3Y7X0IjfKUZTLMOpONlvyxHH3a3xCnyhs0iAfZDHC1E2dSCCtRUou7CFbGrGb/QqGPyatUcanod23Gx+n3Z9hsjjT4ZBP1BQWDo/sKBNN9xTckXVNvmzND8dpyqWP3jPjaMzw4PouZjKVAJd1LHMQLgk2ANwikjxVRLA9X8iq3B8v5mr+PZEssubIaboc5GJT/vyzy2Z7AY6QVy/6dwFzbOPCFLQcw/JBcvqB+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39830400003)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVHaa7bPmyQW/M9Yg4JkkuYKRLyDM1CGWwoBzBi9CDlVgBXcYQH5ELJU/PNu?=
 =?us-ascii?Q?MbopF99D3TDgJF2SkffnAcQkfNgOmnOywk2mdaGuTvqtdgW5RpCFhMp0OXoz?=
 =?us-ascii?Q?P0B16YGZ07l+I3zvMaJGf0rCuO/9RvYpEt2UpjYel2p6bVtrM1SeuwqKGfr5?=
 =?us-ascii?Q?0ByYwchqMAXr8zYFpYQWjCu2An/DghCZ2LUDN3dXpH7E+h/bcSBebaBYPjtG?=
 =?us-ascii?Q?TUs878NSfYRfEhd2/8+Ij6MSmthGYkxZZ9sRYqlMwjfvrHfEK2WLsKzVhOB6?=
 =?us-ascii?Q?XPxVxhtnDimhVWexV65u9glRXgzdja7u8juzbZPTFw7PCIyZSZoUS9aHs8/d?=
 =?us-ascii?Q?yW+aGdthp+XYZRvcUvM2sPtzl9KEcxkz9qEPLLHwfp2gezgVWXmNfAF2LIKm?=
 =?us-ascii?Q?O7Y0BxsF1qMBoQOcWx4uz7xWrA0lwBneOwCW1sATMQusb2tFO8KSpR91l/SR?=
 =?us-ascii?Q?IEvt2F4enoPn1hrCxbaBpeuDaEbPbJCnyzIq/UyUpuGInu75FNPJ7fQQL43B?=
 =?us-ascii?Q?k961KN+O35C9o4nKwsoQsOUSACT4GrowospcUoxuSUJO2qk/O0M9aAyRj0UN?=
 =?us-ascii?Q?SiYO0geye4XVScUxnSUOACcj+AcyDNWaLivcML3EXP2uTIeJL6bfvsS5tk5W?=
 =?us-ascii?Q?8H1ubGqC1G55buTYkkANtxLRorwJx4B528j7rJlE+d8TIB7hYGc4fecDeRBG?=
 =?us-ascii?Q?+f3xjN9YWz1MczgtfexO6qwEq91OaK69FfgtTjzHL2b2VJJjEArkmGwbhHqj?=
 =?us-ascii?Q?nd5RWiUPmCTs7JFMIypsGYX9fpAr+JzUmAz2Cu4hqZkonhXUs3k0KABMFzUM?=
 =?us-ascii?Q?DJq64oBGxGUjM2MajgvD5mTwrVIRSK23p8OKSq7XfzWhnoP+rhRWykq7562m?=
 =?us-ascii?Q?OKWVZkXG5z1plABBqKgHQ4aLNj64q8NXLKW2soZM3dELvgcX503UeZJaAytC?=
 =?us-ascii?Q?Eq6tCMK8p6Rr0qFIqag428oxGYRJI64ESx9oPL4BbGrn0U997AyxUkNiO740?=
 =?us-ascii?Q?fKUgpMRdC1BYKkcg57/vN3By0qYZguEEa2L26hwoyWBpQ2u1R6qivA2l1cB0?=
 =?us-ascii?Q?gSqDh+i924CDoQCDC0pU2JK9zgMrQlAwgrN1spOjAXSbwxkGNrWlxZeuKotl?=
 =?us-ascii?Q?bKd9bpzvOwX00yCs79ixREdeSJ7RzlIOSKQRX394ehqLSnZ0j0AiWtDhXFTT?=
 =?us-ascii?Q?im9qxKwtlLoruC+92IIPVEiGCmjBkgnmh08RAdfQdIhTHT6EBzd+c8WFOkbm?=
 =?us-ascii?Q?3Mey0izLuxfyaYDosAOtcvYXrAaoRHtqmUi3uSNE/s1ZvCg4g+4nYdsOG4j1?=
 =?us-ascii?Q?GB1cY3C8stQ24iE9jn0ZM9eIdOmhNKW8Hh7+FUEKemf1d1sBf1mdBteOD5eK?=
 =?us-ascii?Q?HZ34aJi1bslWl3x8tbwZWoLUnSTZudkgsR2W3YychvdZZT6oz3wyzROdKpJ0?=
 =?us-ascii?Q?bLVatRVb8mRPtwDiKex6jKxqp7OkfgoqUNVReESgR5v8+zHwSfI6WLbq21wW?=
 =?us-ascii?Q?tDJRyWL3KPKtfpayuENTmGSRFT78HjLDpaebkrV7zoLQMlndT0ft376UijNn?=
 =?us-ascii?Q?fYGNTvfuDnWWwtZCmZQQCoheSfxDeDdbtp44mXY4GqgOZ12p3VXHGGLwfht3?=
 =?us-ascii?Q?RpQkOCjoHBQ5nTnGNceH9+/50hSUG/SvDDtjacXgxvPdBgNu4BGV1WsOZp7X?=
 =?us-ascii?Q?kWQWo++btv/llyJ5U41zmZ8wohk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991fe34a-7c62-401a-9a62-08d9a8c9a6dc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:49.2892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p09jW98yixqpSsCI2+NrFyHn9MXOQ9g+6wGLqJq3xtOanF/USPk+exFjV+qljUrAnQq5cfK7lWPjeOIkMed+e9veSoMH8w1YP2o/C8BvK0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
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
index 2c763784f69b..3715d89f5d4c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -303,34 +303,6 @@ static int ocelot_reset(struct ocelot *ocelot)
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
index fef3a36b0210..9a4ded4bff04 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -766,6 +766,11 @@ void ocelot_deinit(struct ocelot *ocelot);
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

