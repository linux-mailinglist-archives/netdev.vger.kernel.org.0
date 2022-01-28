Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C94A0161
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351066AbiA1UGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:06:08 -0500
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:24992
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344411AbiA1UGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 15:06:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hncQKqw/x658xGcu7DlEcH9JEHroqHt+SlUpnSlrB8yxqYPn+RudgCBw95r7OGX0xYE/z4ZYO+1POGDdiqR9+03+Jjd+nExv3RXBXSKLrFghfNUrhShM+XjBWtB8+EG7TtO2k32mWQ4wX7+5HuKMABhno0vADhUdDMyinfKgRyFiWEbzrzU/3Rz2zYWnQBkmDmYUnp25uahH7IcZzM0zv9g4GmDjwIfWSSMZEFYgEPL2EBuSjvqBB8pLUx/BOcRSeQ+kKR922BVaxt93KIUUGcU/oeMCPOwwo2ZvoKOAYY1L2tX0u0XdzheH8e4x6S5gNgk+yaQ5KRWUHhuVMRX9uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm6CQ/5266dNxuW6NURjdLGbFJ+cvZxjOkKhXWcw9ao=;
 b=WhBoxkz+1am/JTeK7cmEZ0CHVRc/CaLN69cBNG+/F/7TDP8kWhiFfgtPvqyEPMgmdPqta4ogAGpklKPNHQqiFMNsQj16O8jJdO17xoT1CrOrRLOJR1tJFlkjjIFlTCxiQDkd31R0Qnbu+2wmvwNGtgjB7JtVULSMrV/xqsGgVnBMDhopCmf/P6TtXwjNvafQlqkBbct0Pd+Q89iHeNGfSOcrvPmQ1dUFxo5V8sYsy8BSUHXY29fkN1rXbexAunY/bhCxZbVDu+SzcnB3ry/n+3yD+7R2ouoVfpnuAxZMU8o1Aq67yL6ljoDxG8QEqWwjdG1lj1z7Kb2+l4+8jU1NXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm6CQ/5266dNxuW6NURjdLGbFJ+cvZxjOkKhXWcw9ao=;
 b=yrFnpTOplKpN/dx0mFfduuhkR1TH/iABokCMfra7Uvzx/u1cvB3FrFU7DknVOAcR+DwAs/q84zekHQhunmDIHIdC69KpbmbFXbkso67YN++86uQ0cZM3CL622DPdiUcUeqRY0dtoXh/bzgyzL98MihvFhAdYy+7PCgQ6W8Oam5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4969.namprd10.prod.outlook.com
 (2603:10b6:610:c8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Fri, 28 Jan
 2022 20:06:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Fri, 28 Jan 2022
 20:06:03 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 2/2] net: mscc: ocelot: use bulk reads for stats
Date:   Fri, 28 Jan 2022 12:05:49 -0800
Message-Id: <20220128200549.1634446-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128200549.1634446-1-colin.foster@in-advantage.com>
References: <20220128200549.1634446-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:303:8d::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae39cc8e-0f47-4d53-bc74-08d9e2999c46
X-MS-TrafficTypeDiagnostic: CH0PR10MB4969:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4969D28ABBAD05EEF71D6FC1A4229@CH0PR10MB4969.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTVQVinD22ZJoMUAcNRAnsIzsFCfDN8BI4Y6A75/8ni8/Qrxi/Y8m1fPXSBLFRop6tKVdgyIQHhmRIL5+ulXRTwXFDCBE0oF0xp1ECEGIPdnQjqGCigdnluzgHWj3qBjCZczOvokUipPZOUUw57IHQ2EgcjXWvYIrrNo5eVUHmByAFSkrHd1peh0/XBz8euTZzp1bg+2dgkTqcw0Kmhzf6sbxFyZqNdcD96wRSiTBEGB3uHOVWNlZvpp30rjZA8Pm4Ab2hP7bq6VSpo5q2TxaKIjV4S9WHbKQMgZLb9/94UWBt6aU9LB+xptyzW9RgmZEf3dIew87qE6TKoPLVPBoJa5/J8bw3fM52Xgz0JzdQg+0Ya6d45/uFchTCURQWriuovLfvhaC3M4FXvlVLNnlqvA+9yTltDbuF/jioyTfPHG4KjgN1qQze7rVTdUgfSsABQlEb6A+lX7xXnm+drJuT5rPoLvxiDwgzR9j+CsaX2quwETGDiDiOdl0NvDYlXeU/JRal7pZnYioZRZUeMPxH/4TGgRwOV6bmERncYDmu5aL4TpV3+qSlxzaD98Z796eydDqEKQR7/XWeFv3Gw0sCQelXNvBW9rg76MuheiW+KtKPxkRUZYAObOkv4XM6heyn2+rKj1LBAPsbcWzAptCYNicRtU2ru8ZW8HZWwQ/mvY8ioWShlKqInrIVs4LlypZzq/5WYmrzY2D2yNRAAZpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(136003)(42606007)(346002)(366004)(83380400001)(2616005)(66556008)(66946007)(66476007)(36756003)(6506007)(6512007)(8676002)(6666004)(4326008)(8936002)(52116002)(38100700002)(38350700002)(26005)(44832011)(54906003)(5660300002)(316002)(508600001)(86362001)(6486002)(2906002)(186003)(1076003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MkWbCUofd0vCxP5cE3UwH+s2G6zmbrnY2Jqh0E6lJi2ckWeRt7HSyw2YosmF?=
 =?us-ascii?Q?wgFqq0STpTOB35ZlCh5jcLH+AMXFndvxUj+MawkvI0W3K1SBCQxU9LxLNaZ/?=
 =?us-ascii?Q?cgwLwChdrUyMW5wUsyYXwMCQlE1FvDinqPVwr4/3wJfJ77ljVgXAz5aLD5R9?=
 =?us-ascii?Q?JHFxzUnHtO6XmVKtccoqLHuePabqNs/s7ak9sqKi9KZS0jl+TCwrA8h6Cw5j?=
 =?us-ascii?Q?CVvO4kSuGGugj7TqehKMpOmskDcBpKhGw50aB2SHt+D3aHAUvylkpGD1rdWn?=
 =?us-ascii?Q?Xzsmeu03DzwmjZYBjNZu7kzra45/YdS81clUNQQ/2f7MhvmgVygdl5kpyo4g?=
 =?us-ascii?Q?2NenQat0iuYFzPZyLCg4/cqSXyUxmDqaj3dDzAZ19e9DjxKsOzzbEVXczMy1?=
 =?us-ascii?Q?JpNslIOxdCHHLdYjUIvSCXqdfDd7XErr1ZL3v+LuJzD0k1KHFCz9yOyw9aCP?=
 =?us-ascii?Q?J/Zuwrpa2J1r11k+XLBkSRapGEOJlOML8zz0chdo4sMtScx7ez1swy3nja2J?=
 =?us-ascii?Q?a4EspEJORIOf1CVWAQHwua4mf297V4Xha3BPH8LbtO6qTRYLeGS9G1UjBPGM?=
 =?us-ascii?Q?LVwMLX38q2xXYC5bQWWJXo14PNWV9EjbsSFh4ucKeIdUuUzT8jvqRbWdpVd+?=
 =?us-ascii?Q?93h+fM1UDaKDEsBf/8+FdpAsw9nZjIFklIQwZSfUpH64aqRlx2czvd01zAPP?=
 =?us-ascii?Q?2DwKBVZErlFiO/5UvyaQxM0Rg5TI2fd4qLROEcCGjb+hH+G4OEfa4cKoC+DO?=
 =?us-ascii?Q?kyYhFdqcmd1i7GRo+2FJbR4+aHfyqawB2jQYCQMAXZ+6g+l0YVBSJupTr9U4?=
 =?us-ascii?Q?IxtBqeh+B24tboQa3XApiYRoC9D+GZS3NrcipEIe871IH9mxwuDSXPF8LKBi?=
 =?us-ascii?Q?RgJm8JfmdpZJINRcMf0S3xA5PqIYIFl64lSXONCEUf8CV7AdrA1+8fhdVLAX?=
 =?us-ascii?Q?TPoIUwy8T/+OyCGf58wBTLikjv2u4WOiFQrOGcNmU7/sLS/H5bIgl7qfdyl5?=
 =?us-ascii?Q?wE1yEShLjrr08M6vKYlTbWL4IHCdSA6wtx+w8dij4SkKaYJecuVX+UgiLGKh?=
 =?us-ascii?Q?vT8ksG/jGka4X8l7zDriK5gVoRgONCdeUU6cGYcAcKNVJTqEAOeAFuembxfp?=
 =?us-ascii?Q?Gq0aFpoKt9mWGyDlgsnDUPhEly39ShNI4J9zw19K3ZuGcyWqe7J6YSUbQIRN?=
 =?us-ascii?Q?/6tmNhyHoU6Ul1bTF627AKi01uDnAAOFQwLRVHtQ8pPrIBTJDo0sR31RDZZ4?=
 =?us-ascii?Q?7RfWSHQlutT/MyiO2rzvqglSXvsgjrbHZhMCmZUKWWMhTlvV74G7KxbOoFSs?=
 =?us-ascii?Q?nd54HnZJwF7S4EWP6JYni6EdXf9a9MBWokYvdTOI/nN2/guWcOAg2pYP9QZP?=
 =?us-ascii?Q?JRicN21KUatCz7mwEDhMRgTxl5qUucsGAgLKZ9GAjm0FGMhhLYYbV3kesoxY?=
 =?us-ascii?Q?cKmPk4KslPiWJoE38GpoUyue4BaFv1AqUsWagLAuZR3ac7YnRQJmtpFRsOx3?=
 =?us-ascii?Q?tAOIzy5dGtR/kBVk+3T3ZFrf8CdJcS2p8dRl3q57JuqeH9hIh5XSs7m9Cmh8?=
 =?us-ascii?Q?KdLc+WBjRy6JEcfOIFzEMD2QepP4DKq4QPiPzawZEYz19/VqtZqYN8eyiezn?=
 =?us-ascii?Q?GfYwdWumkJBvBReToHtlpx285teg1IfS8ousKdFeC1+AC8X+ZLGP22xJaLZl?=
 =?us-ascii?Q?r93hlA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae39cc8e-0f47-4d53-bc74-08d9e2999c46
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 20:06:03.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VK863kLS16GW8KiVAvZe0BsBBMr1/+6M4T4W6MYW/aYVdnMkaCm+AsnpXm6axsmq+raLT/bXoqelWEs0nXVHmoiniykzlyKH04ZmnVeBWmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4969
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
 drivers/net/ethernet/mscc/ocelot.c | 74 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  8 ++++
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..d37b84b20200 100644
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
@@ -1799,6 +1808,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
+		region->buf = devm_kcalloc(ocelot->dev, region->count,
+					   sizeof(*region->buf), GFP_KERNEL);
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
@@ -2799,6 +2843,10 @@ int ocelot_init(struct ocelot *ocelot)
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

