Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD15B510A
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiIKUDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIKUDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68E722BE7;
        Sun, 11 Sep 2022 13:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJNgUEmNXrUyxygg2WM2bakSHnPMgQF5dnqwO/u46njp/hiPT4U11zZ72nGmg9UnSi6Qb1k11xK2u5ncS3nPGC2eyCgi+4ZkIWP7vZDKPGUe6hPXofBN4Znv7sv6wmKiRbMbJ4pa2X/qJi75kvDXJ04Lo5i4/Z4FiC/xaLtouMMp3KhZUjloLiEophBUjSzRzf40W34eupIh8Y2cBHQMrAkfXTbKT1W2CVZ5tEjV/63vbGlmXMBJsOELSC7g/ZKP7AEdmQFvxWQUqH+7fappnufgTjPWq4PbkZM/Gum5y/0bx2uDRoOT2GKQLIJwdr7mWabbRV6qOzR529MTGQdQZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDJ2asZMCdzcj2h86rioZCydCbuKZdsmG0yk8E6bA6g=;
 b=OLVlQvw/Gu89Q0IGobC/74eSMiAMQSo4Vi1zugg35UjM/3lzBZsNOFUxM6KsXSCHfTzygIjVmf0Ixpr0ydRzyUAAiIwEyDhhBlpUfbh2eYk8Cup6Q34tSg4MAihnnpY9PFi5gLvPgsSaDb+OYh1qB2w32wezoVUCwwhVTLg6QpjCT9P4ZZEhTPwiHpW0eHs1lGQIuxsxQ+TKqvI97qsb7SjAADbGqnbrE8xpAyWApoT6vAv/PomPrHoq83ROIFoGHU34/sqhW0pTrx8cY8V/drSIqw2lHYhDsw9M/NjLHM9JWam/mq8zA+pL70LpPU/lx3lxlC5TeHsuBDex5s7Xzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDJ2asZMCdzcj2h86rioZCydCbuKZdsmG0yk8E6bA6g=;
 b=eFesBvecSsj6fVOd5bLkKytMyOszvlSn9egngoFZ7aoltorp6sFXMG7stGX9/cLu3O3uvPL5o17Fz21ohZ0ZZdrN+IVUbJHxwRuFung0vJrdG38ovwQinr+USzRjxexCwMkoYpPSEx+/9zY9XCPEBZvK89mla7t7A1s+O3tc0c8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 1/8] net: mscc: ocelot: expose ocelot wm functions
Date:   Sun, 11 Sep 2022 13:02:37 -0700
Message-Id: <20220911200244.549029-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ec766c8-008b-4cc5-cbf0-08da94309d8b
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICA9ww3eJ8tHZbENyAlqmth1FFDRm+V5LZRt0E8M1gnFAgLLq0BrPT57nI0jht79a6lPs2YbHL2SggnDwbE+G7zOZ+0PlLnrF0Mg8yXABx+hgnOkE6AM4xsUGU47YHrzIk21K41cdqiitZcthdfcZBnQ2mZAyGV3CfclmIra1jmU+aTndqQB2FZ9n70GoeTP6wjXSUQnBMTC0AKUrE9Lf67g70oX+jSOZ0ntdqR41VbOKGhwbsVz4nQgFqpq/NTE2pmbG6G0Km4z+R2TSoItcMvkwJfyqRjMsCVhq4dp9IeZczlE4vILy0kKwilC4NKVkXO6uKORLHswzHkRWuZQdTyQtyVeZjVNVd7o9RArzKx/vB7wrSdlPaA7SvTZNGT0Ju86r94pFmPltEOeM8j+R2oVRaHovxyR4b7BdSmd8Nm1eLdoDytkg9jQ9GY68Xm/e0qd9HDTz13H5vgRad9IubjfNpuAgCi/NGK1b/PDLufic8dlWBP6+YeuhM/Wt53k+G9F4VmF+HaQrCHrlx0dDrbMb8yC0llg24ZUM4+KfE4ecQrCotVXgaAu8Rj89Nzf1iYRzOJ064YnRrlGtM8hxQwPDHOwkc6D6XjKWWiNe214JUJkSHSNx4524t+3gXtlpIsbXuKdmxYe4AHy4iH8Det/KFNmk/v8v0gIH4S6Bp80wR8kiKmd9V+ac9Ib+cGpb9XU6VOx9Rd5paY6v7bUbss/QGSPDBO48pdWRLngMNkXlSy8dYq3lw5jjeZPikjzJ9umugfA9QrjV4b2KdaquA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KW4Znoj6WvtNKZSFNFEzs84LfXtxg7JPuSMFi6gpSibVW55gVq88/PU+lEeJ?=
 =?us-ascii?Q?is+qiAYTJ51YXA5f8nymujCUGVnv6wF4v5pnxDAvEx57m49C2zMoX/rNZ0QV?=
 =?us-ascii?Q?mosltOjfgrkCVftNn2MKOUGsT4hgzc8Gd+NnKPZI/qXHmh8YSvE9ePwytRqB?=
 =?us-ascii?Q?I+jMEiVp3hhcCdiTGYMBlj0TrRHHbxyKtNP7/QcEtsBO4VEUwU6O94FpZBm+?=
 =?us-ascii?Q?nkdmZmrZJsXsj4cz8auK3iXJzRG+hda4dMmzhTAGUJ9q5q3Yd5+Nbs/JVxAI?=
 =?us-ascii?Q?5CvrckhYNNalKPheKwTQvdN02TZDmO0Ag1mkHYVgyzgVq5J/6+iFZSZuQ5w5?=
 =?us-ascii?Q?dyVVMPX3M5Iq6vbEz8rXGNXdVKYhKDG42MD/QdyDuOTWYP9rqXR1KV02w0dU?=
 =?us-ascii?Q?vywwNa6zlG1/yj1enJ01pPcw/NBME92TtvdC4ERTYn8gXg5r+e28fXPjP1js?=
 =?us-ascii?Q?s4+boNXh2JXCiIA8Az+pt5ZzuMcGu9DSCBW+5EHF45uwgSphZQei+df+GsUF?=
 =?us-ascii?Q?bGWIfzbqphdsNKJJ1X6LnkOHNLJDQAgOPkE15YDh73doh/uphVNF8b/LwrSI?=
 =?us-ascii?Q?mw8u4oDpVbQGeAEg4YkkzlD/juK2fPM+kD+/+QKrB22kNeBC0pqZn8P+x1GE?=
 =?us-ascii?Q?FjhHiuWPw/G5Y3HFger+vLZmvTb4D7dzZszSR50kxQOS03OlIQTVlZ2kMkJo?=
 =?us-ascii?Q?2GwrojbUN9aPYYRzXmykH2HZ5RywWPpdgKBLnv0zND00VKyD4QRVlNAeV8z3?=
 =?us-ascii?Q?f08vldgS3IKdvuhl5l9xnA9uPQHRr/Okst4tM6/xym5FQYsYTIBarYQGd/X5?=
 =?us-ascii?Q?jftuiEd12rCClZQsFK3MVudnVsHqZxgdqsLycXwOR9Ym3KrsdCmP3iaahqN7?=
 =?us-ascii?Q?+QBfbRBVZHHVDkvRojlID7QcP6Bk6jnwx6jpF7vHTtivdtmnIHCuienxUi0T?=
 =?us-ascii?Q?9rYNm2q7RvgjyULW5McqIFq+qTgCQ4giKbqP6eDEkGs5n6PCwk6ydlXz6gay?=
 =?us-ascii?Q?IV+a64EGTNL0v7VOOhVjeA0x/eKP/m90JNbkOtNCsV+V7NEe0SUIuJqRU5VU?=
 =?us-ascii?Q?jBi6U1fmI/rB53U2tdl8QshpaOemfBdZoOf+iXa5OCDyrVk//Yp6mtil8tww?=
 =?us-ascii?Q?Hiuly8Lhzq4jH1TPNlsqTMm7FYhOhm6zv2FCTuy7AvlwAwOg6vvR6ZG2E1mj?=
 =?us-ascii?Q?X+u4L0LFYt1paLxVuIjmXOWPhukL2c52THzws+XLrGBSU/l0y/nIYS9eVF6v?=
 =?us-ascii?Q?UwCx1dbE/sQVwXzG0GkrPoCqyaZ26gvDxHecusAHoH8x6xPdqYrsPYG5l5jn?=
 =?us-ascii?Q?VmeaxSGWvZLAhEHTHEY48RARycO/yelLi646YU2Egkh482pxp0eG2qgRcXZR?=
 =?us-ascii?Q?vrVm8trZJpSVPpxFR7ZGVW0UuG1DrKTZkJ8lQlwvJaZ6IhDp/h4P2gBKMTcv?=
 =?us-ascii?Q?A+6iK5vrub/sEA67q+g9bDSArMZcx4kB43N6cN9Aa8C84umazc6mUyVHH+mS?=
 =?us-ascii?Q?Hbcm6aVsh1oT3tJN5ViWbNkMdaHeUoES59E9jwDMtWzXGvGvbnVG6DZDA38P?=
 =?us-ascii?Q?42qyu6wvCuXrIaLhXZL19eAIWnFw2UoHXWHCkVZEVwDnNT5DtzWmKqC3CYAd?=
 =?us-ascii?Q?yESUegQ419sNrpoEvHKxfqc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec766c8-008b-4cc5-cbf0-08da94309d8b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:55.1059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulclVo0JyinfMFATda+2yFdtq5VGIt1lH2W/iw8azRPsjmeDgGGsQyfvD56YwQTLcRhHOilxruWqbLQh8hTHcN4aff+I13S0HgBgzWRpY/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1:
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
index ae42bbba5747..80e88bfd38ad 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -214,34 +214,6 @@ static int ocelot_reset(struct ocelot *ocelot)
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
index 355cfdedc43b..17dd61f36563 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1145,6 +1145,11 @@ void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
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

