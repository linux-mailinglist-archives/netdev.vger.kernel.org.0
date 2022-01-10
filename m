Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D617488DE8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiAJBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:06:43 -0500
Received: from mail-mw2nam12on2111.outbound.protection.outlook.com ([40.107.244.111]:13017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229538AbiAJBGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jan 2022 20:06:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFF3Z3Vry7B44dAlcRgAePjOGeKeE6R8uMR/wqpy710VPvSvXwmlNS7Dbnz99xaZ4SUTOhi1jU10MYsodSGexosTEWd+9aPbHNWShzV2dZHB0U9lt1ZlXDo/bbmtzasf4wFS8AUt5kTT7l+J+ng4kGT1Z0D6FmWzBfOrjRqaAxX783+aTvs7HQIu5kKQUZS72RAtVXOjpwkspyDqBJp/nhpePtHXCtpoJXoxcUaRfg25/l3UdZLyyn6BIdEdN8KLMlzRABA3WDm+fAhmqzOnk7e5D7cQ4jBmcYHD9WQ4mavi/pxhporSAf0aKW7YxWgHwNJMe6rwHTC/dUyNeOcrkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQ3OoHqtWe6O46KtoVcfz/tYuSzsdpFF5+jIqOuNcdk=;
 b=VxdqahPzWB6UyHFqtdQMDoU6p1KHgrR8txzL/XlJQ8yQEq3J/2sI1Z7Pd+lntlenXvTsLGYSerMuVbeSZGelhCW1LeXTQuRSKB5TncaBszJmE8MmOLmsmWkjNUyGbfvwbMJuccPcTmbx8XFbr6WCpcmb14e1GUPNCh1pjHXqbmKYVLVooYAFDoRXK18jozqHKRsJEjn9P+g+sMKlaq+7IPXVNCu+BctPDPh8VklPp5EVSjmWKs3EYcSeKfvWWLbZOJBn8Z7OWiTEBpBGKFKLuWfpqDk9AxJr4H+r5nLu2dR3EgCPci2cRCv3k92rX9zZsLH2U31t1mL+/Ip53If9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ3OoHqtWe6O46KtoVcfz/tYuSzsdpFF5+jIqOuNcdk=;
 b=KKqJQUjPTJpIdxiwghDv6EM2DEwEeCpkV/H/NPuiVQ2qomSw6AafmxmGvxoZ+aUBiYeEH77gqrJlrhE8gHNTORW3KyRXQ6c5HEf4+enSUfNfVJ7PC4s59q317N1++FCiEZa7VObp+dDfbL3cqqJV1I/jopK82B59/wQ8KkC84Ns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5810.namprd10.prod.outlook.com
 (2603:10b6:303:186::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Mon, 10 Jan
 2022 01:06:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 01:06:33 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net-next 2/2] net: mscc: ocelot: use bulk reads for stats
Date:   Sun,  9 Jan 2022 17:06:18 -0800
Message-Id: <20220110010618.428927-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110010618.428927-1-colin.foster@in-advantage.com>
References: <20220110010618.428927-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa46bf4a-6459-4bb0-55fc-08d9d3d570ac
X-MS-TrafficTypeDiagnostic: MW4PR10MB5810:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5810150ACF443E54C9015D75A4509@MW4PR10MB5810.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FjN0DqcXEYNOp1+oHFGjHFuBIYmtE4WNOE7TytkkpV4EEg72gfalaKJ6hY58fmBnBaNSr2Cx+6nLzFRjj1SEC3YiqbUMSnYfVSWI5VKqLIg9ZD/xIl29XU2+aKb4GwNCJtN/xanBMw8+rlSEVwHnLuRmQdu9mh8A8eCoMPSpWCmpJ+8fkkNG9UGhKlYi4K7YhlQ+I7xB7+Ckz3VMbaP+wWewqsUJunX7ff58avD4vxi+8fMD6N0Dr33wbYFk6HnJDtX4GTLCIvfdhzrYAO0K7+t958WlkHAVDmKhyMDyVm/r05IusStyfOPLqTctyyQwYU/B6t3igqnFmvE+WPDzFw95ZIvpuJI17rdpOeghpI6CYki5zdaX3bXgbmqR8CJdDVQExzOFWCvrU6XjLcuUnx3rRRjzCJjyZrxBymiiaraqnnIsTwsDx83p18PwdolxwTf9NZaK7dA4OKFln7RgrJeLRlFmj/0UBaOnJc/p3/hVQSQVKXOuo2t55EGb8/GcVuLmokS3O/ItmCAbuU9JXZ9TcCC8+66Ao7ZeC1ciIhjH6iWoqu1wevRDZ5rZ9kfwdVJtVlotWAWAX5ca09N4oD0yo4/32PdJZFS3XWxTtgaijBqRmLA7MgJQN7y3yfwkwfMTOWieGmRq5zYpAsMNjFl2RqkZDPICZqkGSdYs40JXzbbh9cYprxIy43ZP3XGVOjP3j7zGJ5uObHfSvk/0vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39830400003)(42606007)(376002)(83380400001)(52116002)(54906003)(8936002)(6506007)(5660300002)(316002)(2616005)(6486002)(66476007)(6666004)(44832011)(2906002)(508600001)(26005)(4326008)(66556008)(66946007)(1076003)(186003)(38350700002)(86362001)(6512007)(38100700002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8scODctQZJCfNabggLV4NNQFuiWuRXOKGcfiZUCEzVK90uxUYSFO9Wza9Kpg?=
 =?us-ascii?Q?L/ytiTalf08lxZhhouWXRz3LZrnwhnzWb+BgZp5OBtA4SvNDsMAa8bDVnM5+?=
 =?us-ascii?Q?wyxG1ZmZDhgDqoFQ8hGNHoTiM7i/hs5LFYg09WL1nNwlQSEns9fZ+KDYR1Qa?=
 =?us-ascii?Q?28f/FbWpb6NZM5whVdgjers7WIPEGgQC8eb9eD5B2BSsSAbSTnNwKZAvgelF?=
 =?us-ascii?Q?PDYTS6KInQRf03ZPAlAv8KCLEmwmiLSwRP0ryHxqKzrMdXwKCTTAHxrDDiV9?=
 =?us-ascii?Q?4j0Hx9KUZ69DYUww4JfY+w6ph0JsESR15x0ln3vrvl/v4W1+mL3bj25fInPq?=
 =?us-ascii?Q?75W7pfPmM2LcyYIf7aPc/pX0k0HxVQ/utOpk74Go2FokartJM++BqVmwUWku?=
 =?us-ascii?Q?T+SC/ckqHYanoZYg8Qc8SOKYC3f9R0mHKwAcxel2ZxJywhTWhb4iqpq3QXUb?=
 =?us-ascii?Q?1MP69Ci63Yb1nsJk4eaPn5Uh63Dd+zcKNn46FJ0rNxnCQoyD8BZdwjF795Xn?=
 =?us-ascii?Q?GOhzmZpXEbF/qAfpP3GVnyBkHO/GTWgsZzs3z0DkQdrhXaZy/nqGXcXCT1PP?=
 =?us-ascii?Q?kv9ftL3zopiEBcXE4QxVKEv8Q95+lPt2NUujop41PagEgWCZvRHgnlhdNp1d?=
 =?us-ascii?Q?/yp0m3oi1PxWBQ/0I61DSdRtiQNHR66iuRezANmkZjnqa7JUk7Jag7gQvVWD?=
 =?us-ascii?Q?DtJeTsSDaR+cw8Sx7YnnbCV1EKph4OhI3o0w0HlFNmHCMbstV/E1gxb7aYgj?=
 =?us-ascii?Q?17M3J1YbcL3vJjzdDEMoIUaHQcWWlryMjschEvT5J1ETPupQT+NnCoUvwbH1?=
 =?us-ascii?Q?mIyTQ4p5nqjAwO8yITH3HOKZE1FQjj1G1sRVRWnG9SrPWyB658S9uHqknzKu?=
 =?us-ascii?Q?MkwN3EtIl8giQPAoZi84YYC7u1zZbNbZz1FV3nBJp95dhNEgpzM6G6mFvQ5C?=
 =?us-ascii?Q?qA7m5hxSoP4g4aJxAFxfrJd53DBHFZin6r0Sg99obimH8tGj5lv4gWPEtWWU?=
 =?us-ascii?Q?QBKIYiHNJulEECkSlGaEDtRugwrGaXOYHWH5DO8F19ipKMIzXiMHAU4dfR22?=
 =?us-ascii?Q?4SJHbrUHTHw+w0efiC9KDPcSp7E4Se4IefpqLD9rY8Z6Ut4kjtzYZO7VfpWV?=
 =?us-ascii?Q?f3ULRRC4xic/Ow0anhMF+wcD/LZ4CJ4Pd2P33kxVnMcMtnSCUVeMR3W8UtIJ?=
 =?us-ascii?Q?FOztQcM3smdXSdGSYJjY6NIb7Ot65RljfRYCiMWcQ8LwAj7iJRta5p2322WC?=
 =?us-ascii?Q?SB6K9kXgRWnNI2qSNP79T20pVRAlofKU2fuW1yd8JWRtvT0CjuDMSA0CuicM?=
 =?us-ascii?Q?h+kMh6jpd19mdd87/G5xSUHCT4WKJAwPYXQTJQeHehM05u8+ES39cuLBLGnZ?=
 =?us-ascii?Q?3rHMYraKa91cU14pdqIlMQE2BDieVV9tDF7qtKHlGnRNJFdXdqtocfq7tYdR?=
 =?us-ascii?Q?oPNbgdLfayF01yZw4DPC7XSOlfkKTNoz0g855/T4jKl2TtgtS6q09s1tu/sb?=
 =?us-ascii?Q?qx2vqfr5LmARCxa0zlbkX2jxAJUBlFzomlkEifLOYdP/eBjw6Gb5OJSN4C7X?=
 =?us-ascii?Q?VtwTGivjrqrJ8+eMfbEGGsOd+UbNy/WFkkbzNCghFk4or6SgeICZJP/Dyj0N?=
 =?us-ascii?Q?eNatqCq4Gc0Z6KRgtj53sqzIhYgM9/LsB41JnWWByYuedF/UO9kZzEp8iSU4?=
 =?us-ascii?Q?Z1ICnQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa46bf4a-6459-4bb0-55fc-08d9d3d570ac
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 01:06:32.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 655vbQJTtE0QyAG0YxRyWNGUQmVetF1Jhb/bMepOKTInSU6twqukA+AUzGdXVrfYnpQe3rS9ybyKMlh4LRevWL9gwjf+nsA7uJTyYFveo5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and utilize bulk regmap reads instead of single access for gathering
stats. This will allow slower buses (SPI) the ability to drop significant
overhead performing new transactions that could instead be sequential
access.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 76 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  8 ++++
 2 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b42187a026a..57b40de9fcdc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1697,32 +1697,40 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
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
@@ -1739,10 +1747,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
 
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
@@ -1759,6 +1768,43 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
@@ -2763,6 +2809,10 @@ int ocelot_init(struct ocelot *ocelot)
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
index 6f74015032fc..1f11c27bf29f 100644
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

