Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94049AC7F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354854AbiAYGjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:39:48 -0500
Received: from mail-mw2nam12on2106.outbound.protection.outlook.com ([40.107.244.106]:26465
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353336AbiAYGf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 01:35:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpxjLvniQ8nIEkLxwu7N78SQK0+kAhfBTwfTwbPlK4K3S7K/QU4OdTiSnX8G4X/1JXtlHngc/6pNZrGTJhhsAIT0O2g48x92Zr4arz06lWiPJf/g5k0JUEi9qNzhri+HiHBv13j0LcdtRRaKpgqZoEHy6WJVK1mtoEmpr395opFhck3hEs5gOkiu8kvpkmGmHyYpKccXjRgxlpEEBBycczI5dbKGYkR+CyzXG9hS+mo17yte9qK3iQffnRuloDKUJIKkVoG/mfo3jhXRljftsN09dlI2TtKxGCDo5KqvcS4bDDFZmCkOMI2YsxFFVCK42bnx/Iq9WdewcBZBAyaqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/xZGfgHv8igdzdDkVnlH6iolqtPYJqmenLJ+1BBxsA=;
 b=j6VREaav/KKFRAjiizK100MisXFaB0rHfWp9M6c/i28YCFWhIZQwQr2rbKgNuDm+r/0PLwa9RbqWoiE2qwwd1N1AQWxVw3/GrKamt0VA9GL8zhAkDLilVHsXUaqQs56ahIBSuaR/03rh9wMtN1bks2D1MtPU1Lz/kOiPnRLy1OttG9zXRFad/S/xJyysbHsi300o2ulOmZcBbj/b4+u3imbRoV4H+0Z1YufL5EF7Xo8G2Fmv39HVZ8vV6nPtfYnfKc9yHAti4BTJVeBZT72PB6B2fcGBLfMmPDak8UxoPaBRQ/bTJV0jweazVlD3f1Ezs1vczP3y7gqAFXFyEghaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/xZGfgHv8igdzdDkVnlH6iolqtPYJqmenLJ+1BBxsA=;
 b=PCa4lrmfP0aJCEom+Kc4utKBnSNjSOOXpNEDRgPJzoXw6kuWPvR5gS2sBFQ548y2Lr/5+vHGueyV4syRNj5ptQwARn5W7KlAVlrRcIokV22coFlkdV5t0stWYUTfXJaJwFeYbJh/qzRIqeTlT2SObVksrH6HhaCaLlIBpoEkO5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5265.namprd10.prod.outlook.com
 (2603:10b6:208:325::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 06:35:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 06:35:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 2/2] net: mscc: ocelot: use bulk reads for stats
Date:   Mon, 24 Jan 2022 22:35:40 -0800
Message-Id: <20220125063540.1178932-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125063540.1178932-1-colin.foster@in-advantage.com>
References: <20220125063540.1178932-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0309.namprd03.prod.outlook.com
 (2603:10b6:303:dd::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 921875fa-b312-4ada-1d52-08d9dfcced7c
X-MS-TrafficTypeDiagnostic: BLAPR10MB5265:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5265819D0C62E77DD0147AE6A45F9@BLAPR10MB5265.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2SbB5kDxHmSh0kUaGnIkgetdZJLi0ml2Iz5ddFmkfXqTSWo4MGaWckNB2FMowb3qrBfyjdqK81eC0LoDrJyAAIWxMRiWUgeic/Y5hPc0jQrWOu3l45x8VPYjMUoV1J0DgM5HRtATZSaxNkcDKShU/HIoNtS18Hvxt10vd8axNnE3WgDz6HiebsxeHADmPXj5bNEuv38dqRcORO3ptrz/r3iRcgXaAy6wnhyJDfYaKNGONkMOcWQ8UHWaZRrKSfMgHhzQ2+DL7LP9TG0NUJjgs/skSaRXJehKv6qB6orUPWjPupdin3YGdiQd5N8T7S2YfVeI8V/e8Mrcm/hEbUK+X1G3/l6QRc7oXiTk1/+5ccF0X3eYo7RHSIKllxBRb3ex7cElIMDKDXYiwVdfWmRsJ0Mnqg24IUpDrHt9Lh6Np12NpEefDCxgCP50pemoGelKnlERDpP4rseMcv9rI6t7g+tRPcK1ggNGcGEJwk/L0LbuXtKxvQMPU0scL4iEQvaQJQCS/LAxqudB75GngY3do1yt4TSW7NVrAOWG3pbWoCFvXw9HaK4IqLjV9YptgIlwuUwQL9Lyf6SJgYxbO/FNh0xa7buGGgV6BFmGeuH6IdzKW0KGfIDyk8upwKRAv+V8vNsHmRnCEP10gCU4yAaE4sG23iqTXLJwFvapZRj9HfkQfcHeTinbVdwhXZNrTI+Imd3jDG1PRrVFGwuilZg3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(42606007)(366004)(376002)(346002)(396003)(136003)(316002)(66946007)(52116002)(6512007)(26005)(6506007)(186003)(1076003)(6666004)(2616005)(54906003)(83380400001)(508600001)(6486002)(44832011)(5660300002)(86362001)(2906002)(38100700002)(38350700002)(8676002)(8936002)(66476007)(36756003)(66556008)(4326008)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FsrTa0pvN6qQ01L4xl0Rlnlh7CMx96KPf8YZVsWj7uLA29vZZ7g4ODMFo0wn?=
 =?us-ascii?Q?moOFM0BmhBNNUcNe2i3ytinso/1iIBXDHZbm7O4hjwcFt80hy3+aedf8zVdN?=
 =?us-ascii?Q?lr2sp9lK3kCv3pS4WIKBefuvA+r1xY1OwL4xOa+9n0Xg2I1zV5RPznpw3xtR?=
 =?us-ascii?Q?IwfxtxIqKOMVNjsWbVWrH23rJB7TWoYomd0JuWCI41y/sNflS3ICsJK4Wua9?=
 =?us-ascii?Q?5DQoQuqXI1tx30+baLcme8UeBxOJcGdtzZOLpFgoMeLcxB1oou7j/TDNPwsS?=
 =?us-ascii?Q?aCBBweIxdzuTNl5mUrEPNanavwZyI2Zp1Zq5EDPxtQY0/dHlhIxfQ0IROe9Q?=
 =?us-ascii?Q?Mu7WHETZKiLK4mrtwuzwitFDVIWz/+VLhRPplH+im2nMOk6Oc2EIn+fsA5YN?=
 =?us-ascii?Q?yFQzdomuh8JM6LSEplNgAKJg8tjpY6ggRreRzojYdqd7ImqO1P4AC1417q2s?=
 =?us-ascii?Q?4bSHbOX/37dbzkQBVc1IJ24jFse2VJDrKpZuJ7+ooQVmyrAgfX8O0U7PUutA?=
 =?us-ascii?Q?4yCrJ0NtHj6OACkxV222tA696i1NJjRkzrs2yV3wsM/4GpE9X02wAE2KwVJL?=
 =?us-ascii?Q?zWiZxKM5bTLYCREvtnOS4u8e+p4RxMXvUQC5TfZdloM8HtaTaGTNLAL1KVDG?=
 =?us-ascii?Q?QEW8Vg5Jm9j+hDlgKFl9jku6WrMEhcr69w6rfiJRVzJYnLcAbMNuqdqqGP/A?=
 =?us-ascii?Q?zh4ZgP83RT5XfO00AXv7a+Y8Vrbf2fUUi490MVpxZW4MI/nUmSm9rPj4krSf?=
 =?us-ascii?Q?3EPkk0AjqIIRKF6qfdQj1d554MVq/3R20frz8B6ySmj7Wn/oGoY33r/L31w7?=
 =?us-ascii?Q?nsTZLUr4LO9iiYii2t283ZFRlp2VIWTEc8SxGVv1XdF4hhnQ3xp8Luxc+KLM?=
 =?us-ascii?Q?gRh9qWOMTROZscdizIGMFOEOTkqwykMs+ixHpsgw7vC+cYXae0FnNTPdV5/n?=
 =?us-ascii?Q?A7lDY38d4Umv1hNceQz2OWBgBKu3O23dpho6ev8l0fNPIuOf5lqlMUBZDppP?=
 =?us-ascii?Q?feEsMLWcN1LN2t4J6a+5qt88U5EafW+OM0sskjmeyWYqS44+DCKDkKk/mAAh?=
 =?us-ascii?Q?G5y4f3iy+JaAs41+bpzjnED1P7niPX9Zh9TRJ89JqIct5RZX8Tas9fCrou4+?=
 =?us-ascii?Q?SwQIBvsa3IBZsOKmTrWwr3SB5MGthwftS7XREOgrLdUly0GRH90wUJzQsFsT?=
 =?us-ascii?Q?h/L9lx0RiXvnv0ws2HPEsWAGMBa3Z9eYzy2/duuZTZiKhAh0VRYHIyujwmTy?=
 =?us-ascii?Q?zkO4uVr/v9+Orpm1rSyLa4AsXFLr0JmpKL7HTiyXGtD5J5UkYmFEnqyuKQQF?=
 =?us-ascii?Q?3lX6E/sjV72iXgdICpUOh9S5gZz42duwD3uKEWs0xy0BC5PjIh/nMNGeU+qS?=
 =?us-ascii?Q?l8I6u2B0NfXLT4Jbg1Qw0yE8eRwWZtFVC1XHu8Vn3nH2tOjc6AyJ+meZ72rD?=
 =?us-ascii?Q?av3aF3CXXnZAcj5fepsbLEF3CDgKTRKq0V0e8WtU1UYwU+Ma8BVKIB/G/cuu?=
 =?us-ascii?Q?l7FWv2xrl+QxtVykCkE6aQTh6clRtrv7aIgX/hJY8XSrJ5hha1Bqhq6QGIoq?=
 =?us-ascii?Q?jMjJ4q9RWxmDU9In6VY8IXGmiA3ythEA64cZfJnJoG+rGuesur5U1l1WjS2X?=
 =?us-ascii?Q?Df7YDQQABN9per6/s4uSP8D6rIYoarGjv7HjHnNt1ZDoG+wsz9ELWVHVf0/B?=
 =?us-ascii?Q?UgiaK7rUrrmWek/7ICTnw+Wbly0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921875fa-b312-4ada-1d52-08d9dfcced7c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 06:35:50.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sc15oiyrySMy5KJ8u0JOq/h2i8hHGRZZ9JJvi3iNW4gWK30LAN1kr0E8PDO1AOMoLO+5d9llDVFtkJRNRizJlzjLPXAKd4fF6aE0fz1Xtzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5265
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and utilize bulk regmap reads instead of single access for gathering
stats. The background reading of statistics happens frequently, and over
a few contiguous memory regions.

High speed PCIe buses and MMIO access will probably see negligible
performance increase. Lower speed buses like SPI and I2C could see
significant performance increase, since the bus configuration and register
access times account for a large percentage of data transfer time.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 76 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  8 ++++
 2 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..bf466eaeba3d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1737,32 +1737,40 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
-static void ocelot_update_stats(struct ocelot *ocelot)
+static int ocelot_update_stats(struct ocelot *ocelot)
 {
-	int i, j;
+	struct ocelot_stats_region *region;
+	int i, j, err = 0;
 
 	mutex_lock(&ocelot->stats_lock);
 
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
+		unsigned int idx = 0;
 		/* Configure the port to read the stats from */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
 
-		for (j = 0; j < ocelot->num_stats; j++) {
-			u32 val;
-			unsigned int idx = i * ocelot->num_stats + j;
+		list_for_each_entry(region, &ocelot->stats_regions, node) {
+			err = ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
+						   region->offset, region->buf,
+						   region->count);
+			if (err)
+				goto out;
 
-			val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
-					      ocelot->stats_layout[j].offset);
+			for (j = 0; j < region->count; j++) {
+				if (region->buf[j] < (ocelot->stats[idx + j] & U32_MAX))
+					ocelot->stats[idx + j] += (u64)1 << 32;
 
-			if (val < (ocelot->stats[idx] & U32_MAX))
-				ocelot->stats[idx] += (u64)1 << 32;
+				ocelot->stats[idx + j] = (ocelot->stats[idx + j] &
+							~(u64)U32_MAX) + region->buf[j];
+			}
 
-			ocelot->stats[idx] = (ocelot->stats[idx] &
-					      ~(u64)U32_MAX) + val;
+			idx += region->count;
 		}
 	}
 
+out:
 	mutex_unlock(&ocelot->stats_lock);
+	return err;
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1779,10 +1787,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
 
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
-	int i;
+	int i, err;
 
 	/* check and update now */
-	ocelot_update_stats(ocelot);
+	err = ocelot_update_stats(ocelot);
+	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
@@ -1799,6 +1808,43 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
+static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
+{
+	struct ocelot_stats_region *region = NULL;
+	unsigned int last;
+	int i;
+
+	INIT_LIST_HEAD(&ocelot->stats_regions);
+
+	for (i = 0; i < ocelot->num_stats; i++) {
+		if (region && ocelot->stats_layout[i].offset == last + 1) {
+			region->count++;
+		} else {
+			region = devm_kzalloc(ocelot->dev, sizeof(*region),
+					      GFP_KERNEL);
+			if (!region)
+				return -ENOMEM;
+
+			region->offset = ocelot->stats_layout[i].offset;
+			region->count = 1;
+			list_add_tail(&region->node, &ocelot->stats_regions);
+		}
+
+		last = ocelot->stats_layout[i].offset;
+	}
+
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		region->buf = devm_kzalloc(ocelot->dev,
+					   region->count * sizeof(*region->buf),
+					   GFP_KERNEL);
+
+		if (!region->buf)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info)
 {
@@ -2799,6 +2845,10 @@ int ocelot_init(struct ocelot *ocelot)
 				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
 				 ANA_CPUQ_8021_CFG, i);
 
+	ret = ocelot_prepare_stats_regions(ocelot);
+	if (ret)
+		return ret;
+
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b66e5abe04a7..837450fdea57 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -542,6 +542,13 @@ struct ocelot_stat_layout {
 	char name[ETH_GSTRING_LEN];
 };
 
+struct ocelot_stats_region {
+	struct list_head node;
+	u32 offset;
+	int count;
+	u32 *buf;
+};
+
 enum ocelot_tag_prefix {
 	OCELOT_TAG_PREFIX_DISABLED	= 0,
 	OCELOT_TAG_PREFIX_NONE,
@@ -673,6 +680,7 @@ struct ocelot {
 	struct regmap_field		*regfields[REGFIELD_MAX];
 	const u32 *const		*map;
 	const struct ocelot_stat_layout	*stats_layout;
+	struct list_head		stats_regions;
 	unsigned int			num_stats;
 
 	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
-- 
2.25.1

