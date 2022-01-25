Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B7049AD87
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443330AbiAYHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:21:16 -0500
Received: from mail-dm6nam10on2091.outbound.protection.outlook.com ([40.107.93.91]:19424
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443734AbiAYHQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 02:16:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH9vpVOzOGrQdZ6I9wYZxSCITvtdBRRUAClLWZCOqlX2+1+VImIw+q6pNh3HgkRM2sm2mihUs8o9r4QdPCsta+De8bEU+oYglOT9kZ67XJ2AHZ9kgN66nNReikLmkAi8wdDupLRcfGKBwcalQ41zV3B4Q/yL4TsaRS5kixUw4LRQoTEEdLdP//sDf3KEeBAU+XZCRtloSIu4FIu14f42m8gu4ijTdcBkqShy0cXwWSqFKlLzVLUAA6U+ItsMkYixYxCNsEJc3jw/feOy7vcljBduYuqV4OwOt7fSelCoxLPn5Nr+CnkumOGuzztCatjX/Xz9neF2/RUvMMdltyRcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/xZGfgHv8igdzdDkVnlH6iolqtPYJqmenLJ+1BBxsA=;
 b=SHV+X8Gb2Ud3PChSu0R6X4sU7qXNuZ6pPoX0UEP/0JDTCgJYDNoCJ3MPRNCwyUOL5UJAOHeYKt9PxZ+ao+JTrpqLvjpGSuT7Mud3zI2tz0/ATkShmZsvII60K7/sDVlznKcq9g349kKn+p+Nv7J4hML5+N2vO0nHKyhPxX4tYZmWj9mGOgPW0KK5U4IVnhPnRJ8YysiSGzo8fkXA0oyQx5fqx9EKpPSH8dw68CghMfLoRfeX9l+ED758/U7BUiznkIpWHLQy8SKTqCk70cGm2h5wr0SOIeCVtDeXN9F8mOqIhwCugSKeL1AhI/RLBdG3zS0ssK98guMz5rbBJ+rooQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/xZGfgHv8igdzdDkVnlH6iolqtPYJqmenLJ+1BBxsA=;
 b=KoegP99OXiWHjcaPAkbkaAIuM0CvKwjoTxVBcKMlO4k5euwqzuYQk5oW1/UYc16NsunnShO/fkg0HCbToWgJuAfgaR/fFPME+bWrkSdiW/+/I01fnMjyFf6xsJmQnSbV5A+7H/ekyQl4Z+yfk2MTvyF52CB8vhhIPCBHJ/1gFPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2538.namprd10.prod.outlook.com
 (2603:10b6:5:b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 07:15:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 07:15:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for stats
Date:   Mon, 24 Jan 2022 23:15:31 -0800
Message-Id: <20220125071531.1181948-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125071531.1181948-1-colin.foster@in-advantage.com>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:300:ed::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c142948b-3569-4d72-740d-08d9dfd27fcc
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB253884E1D0BB30B273DF77BEA45F9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EyNN3k3ajn2OPs1P0Ty+aGDyjn+dVpcuuPOGoyNL+YFu45ak5uxfcI/C3GKmnJ5T3mLkn9RYRzllJVxaoEGHfrBEgg2bIXTACVv5LExQVL84puL/eynnnAh0t92/aNtrbCseb3oMgMrPH+wcNCgkaSOirwyl9VxN4CTtSBILmAcMeJ7jpWwMQhVaDI5mJyxfH7/C/MWxN5LWNVVE4zd0r6HkRbMi1wJzqnGnRgjadoIEXJkoTZy3rMeRcRjGaREZQDXaZPYU1jGe6iQyuD7QJcmfaTLC7ApS+PdXPwaPXCCOCL8YE6uM8GPnWolKPLyCQYu6NRoUcmw08DmKOlW8/nHjA7dNM30Oh4836BQ0QC5+7CYowAsxW0AybYZdA8sR1itHkxJYgmVUsPJGqxDEZ7iEpd3XsFpafl9TFE5gntK2E3x/Cm9+pzfslHn/1qvQXil8sOKq2v4Hjno5pnaoMOqV+oxDOF/gesTNUL8S7Ymf8j6AgR/RJghHYWt7xKoix7KSU5oC2hFmXKzY4PJA2k5TH5Muke1o3975gdTjNZnRFcaNm/To0e52e9pK/ap2AQbpuLNOPfhIPdseABOp4Ce+bCd37ypnHGnpeFBAqaVfughDfhD53Aj0rrWrsikNroJB2v7DTVqnC4jv5/S3n4T3sVDGZt2iHnXUDVIbxXxrENDlHd1kmeMcc4sc5OF3Iqx6bTVSqwvDK8WyjmMRJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(42606007)(366004)(39830400003)(66946007)(38350700002)(6666004)(2906002)(8936002)(36756003)(38100700002)(508600001)(6512007)(2616005)(8676002)(5660300002)(316002)(4326008)(44832011)(6506007)(52116002)(54906003)(86362001)(83380400001)(26005)(66556008)(186003)(66476007)(1076003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NquaZrdkgb7sWgCWk2D+PfPOl4Hv5WlzzxH1Oq0i39PIO2Kz/7QHveT4bVaT?=
 =?us-ascii?Q?ltqO7N6SnMXIdbh/z/SBO3Q9TZ6NbwV7S4lDhBSl/zFFNZBs1fNEHTLw4vem?=
 =?us-ascii?Q?Mosoio0sfIomDWc4aRUP78Y0FAPZl8JZYjsIr15czbD7j1NQJ8xlQUjPeHfd?=
 =?us-ascii?Q?IUYS64mxfMaiJMAbiCQF3xHQ23TziAf3XWYoP4kX6WKXRL6ID+ayiy1BfgdJ?=
 =?us-ascii?Q?OTmLmc7JRfhjZ91L8NPijE6bbQzoWeSw7UD+wsVhTfbOfVFm4VL1bL3Er4W3?=
 =?us-ascii?Q?YcmEI0DXSzNd9IT67LCdo9Xn58cjQodZwR17eatIZZIxaOujjPhMZMTvH37U?=
 =?us-ascii?Q?XLbqfSCAJajwl6x7I8ZqGeuMr09e0ErXFL4i7X80vlV+cM+hUUU29NXIuNYN?=
 =?us-ascii?Q?VQtbbQC2yJ/RO9TJihNm+VbzczjBnYZn2BJtEylRliptUTA7TtT/xB/GXyKM?=
 =?us-ascii?Q?NNVpbGfT4xqoTjsC0dro610YzoGh2BsrCIBaPBk2napcE9EIQJdwnpXUVi/n?=
 =?us-ascii?Q?zlFE9eUqBHBS0hPa1BkjJMdRFUGIqSNUlD/qsvB9QSVynn7EZplLPwxM2j8f?=
 =?us-ascii?Q?iVUpU/hvItlsfffyp/qEpRDhdpJwinO8R1r4k7Dr7QDK8YtSGtGY1sn3iBmk?=
 =?us-ascii?Q?tIoCMysGfUsoSfwEyoqQkuXufsuxjphHBBCamOqnL+Hhsh8uPVKgyvO9dqj4?=
 =?us-ascii?Q?o6NoTzgmsM/Ze10G1/ZixwWGmT1o7w1Ix8uPx+SVxrBiSw2mYuO+ey/KbY2B?=
 =?us-ascii?Q?lPvpWOJVyHfc7lLLejcx0OMc+eGdUeqXsjpd0YVZJXTeefw3BXkTQnd5Ud97?=
 =?us-ascii?Q?GOzyzJN26I+WQoYRk6SqnJLWbwwBhF1jj0GUqrgiSMv1N10TuQbXMoQzMpC3?=
 =?us-ascii?Q?cs0pZ7JdfXqb+7vLTFkK8k3x+Q/cODR0Wx6WVKi12t71B4OVD2jW1cZf2+uJ?=
 =?us-ascii?Q?JzFjNQRaudaQ/zgOKvnhVHAI4PbaUn70MfqaB18vM+GUvgRpiAGk4eHww7aS?=
 =?us-ascii?Q?pHrnZekwE8KDsyj7pm8GBicEzBaxQ7xfFhDnvEi2hNRaHGjI+Ry7o21EFazu?=
 =?us-ascii?Q?+vizXTYdhi6+xhJ5G/lY/XIVQ40etlMftj+GxbRB+JKHAwIiwrJ05ZkkJE9F?=
 =?us-ascii?Q?XJoFvrRbQwD2yCBlNOwssTDv5p2lZuniLz+PLi3OJEzdc8wF8gGhNU4gl6Gd?=
 =?us-ascii?Q?G4n9gEUKNCUueLAvnt7PoVQG6sO0rLD/cxY7+PmUu5qNocsNwZ0O4MBAjyTx?=
 =?us-ascii?Q?3pCKaZXj9jLDJpN0PeezogkerB0KVN2IuBpqwx4AUFSZNlawf+03jaUoNU65?=
 =?us-ascii?Q?d/ELwufiWfvFv0pZ1Anc4km7wAbOwfBUk+d1XrdqkkYjJlhRh1RK6hfBkxQF?=
 =?us-ascii?Q?c+cItVuf3mPebdrUguhQJzdfv/iSUXDCxGAhcDRua95VjOfgidkV3SnlBrlU?=
 =?us-ascii?Q?wsrSJu8gCUaqgyJZiVfJEWumLanSH2Zw0lGMTEPXiqksV6QMhjaDYtuV/oNj?=
 =?us-ascii?Q?HKpvbzuup0p+j4R2joBTpvNi1AJalB0Bo2Ay0lWJb13crzeU2D568eg90qqz?=
 =?us-ascii?Q?9R71NqU590wM8xF7kJUn52SOy6UiLptHE7DNv1D5oLUxgoWbZvMZLpKJ06Ee?=
 =?us-ascii?Q?Ee5qMQ8rbmDesDnAN0nmR+sd5Nh9cxUfz5gz5f8w9Tti7uF+CJE/BO+krOCd?=
 =?us-ascii?Q?CgfU16isMktRlXdyoTiZ3chJVOE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c142948b-3569-4d72-740d-08d9dfd27fcc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 07:15:43.1742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMIqjqQUHOWcWukOyy9teNB8ON/1Xt8VP2XeFB0ILHLo5bHCy1yAYmyfOtsVqD7ss6LAb0VMWbSF9MfZIhCKVIK6kaInqO3gzZvxzpWRBpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
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

