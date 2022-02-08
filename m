Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908B84AD0D8
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347104AbiBHFcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347016AbiBHErB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:47:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E7FC0401E9;
        Mon,  7 Feb 2022 20:47:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4fKnY7hkjy6186++n+Nn/VKlf4aGW+VFfgXFDF4bqvAlfdTCZA2Q+I7373NkuTlMGDXMHsv+ynDKVcv4rksB5soPAjiTNR/f5rRUiSMInK4yX4g1gOGMwjZQRFDdnoMIm7dAbYqKUmP9qg8ShSOA8nMHRPxKdnH9/HFN9E+BoTrBokbzcLjEHQuKBtBfqBUs6VGuzQS60Ptd3ThzlRmvJX/1pqvn/pIXOO67Pn5gnD754Jba3bFV2Sam3bOMFjqgAqabGtnT+EBBgyn9Fv3HI1Aj+f+1ghlmBpx+lznLZDkMyP5N864GlwRgc/OiU6Xk9HiAjs597jQfmNNJWPYNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gc3k37fgcH4Cy6R5yFs/SVQZ8AteMJL/IRFkIAGwOj0=;
 b=mooxyRQ1+PCA1Aul1rQlDYv/SH7OXqqFEtoyRtulvCpfs/DM2x3TuN1jE/VyLJFPVLxN9Ufo2gfPGHJfDHuAhxCooJ/dfjDv4q9lKEknE7kLPBkRSytm2EI7qxGCla0Mm3SJWVC6kRgqunWXG5b2aIQC70jJ1sMTvN8vHT20I5nY+8Eo8DLH+Bn+3MoMPh26Fp+ikmB40y/4/5WSSX61K9rVy7ZQskFk4u8p9set8Tm0PKELO1yYD+b/bXE3IYkrymzuWq3LMHIjtbM7SSYWSgSM/oUI5URNuxgtU5S2NJPBnMVqWhWM4mIYEz2ng8ZpO6oPiwYvfeX9CM0mdDI9FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gc3k37fgcH4Cy6R5yFs/SVQZ8AteMJL/IRFkIAGwOj0=;
 b=okSU1O77DiB0T7xeMvx2VCBzYM7FhqZPOsxD7HjV7DOH6rOA/GOgi0p5FD0BGiQi2Z9bBZ3hpPsTCMbgSr6EdPhjiqLpslASHDBnf9e9I+Ap2FKv6DTWnpqk/T0xH+CIYzU7/hVIC3Cz8/Tb5ojl9qPiDA8fUdhHLma8gt9yQ10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2176.namprd10.prod.outlook.com
 (2603:10b6:301:30::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 04:46:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 04:46:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for stats
Date:   Mon,  7 Feb 2022 20:46:44 -0800
Message-Id: <20220208044644.359951-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220208044644.359951-1-colin.foster@in-advantage.com>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0090.namprd17.prod.outlook.com
 (2603:10b6:300:c2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f63ab5a8-2bde-47d9-f6f1-08d9eabe0888
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2176:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2176D9DF1CC9B2BAB98FAFBEA42D9@MWHPR1001MB2176.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kglMlFDvd8WapdwImEJouIXaEQIi0SArH7etynnSs6/xHYJ74wTImr3MrmwCzCfeaEYHLXBiQpM7AEBBeECol2YSn+PZBZNXp88Wnqh1gsAwqC5XDjeQRHtbmOU3IDVi8s7s2f3Ddw9wi+zhd7/Oqd78O0r/MVESkz5osNhfkCdAg0z4or3bAl54xdTuKtI37O2v1zkYXpcBE9kIXgVcz09744I55KibJcSHnpuvun8OGjLiSuRuAvi2bIE1eTFDxp+YTiu19ENozNPllxaY4RKJICJvQaeccAcQ6s1cVhCdV62BSOKPsMV5cSZcIF/tYXNqybcfnW0C64fjORJhm7JWj8/MBwoAkkpwsowfKtJloZd5g1o15VZSmRJWwsTGcBC4bZaDY7XxeVw1b3yyeoy7I2bGT2GEEeT123O+aN0da5+7Sb9FSougkgRFn9y7Uq2II/nGRlisSntjHy3l/r9CGttD6klQqG5loHLs3KZ3bABYxNL92MeH0ID25n+JLiqQxo5JoB5B4ZrvPe8ZLuw6vIaEF74o7KD8LdrazWNukNETLm0XNTIv2iuy0LTyigT8pBp0Ty/h8TubNJjG446tAzPKxL6mI6FxGtK9W6oKN2wD0jlXAlMgxxY3TcCGTT0b5j39aTxG9aN2m2prK55jQ1n3BASHAVBW39UCbrUmbhKU+hnlFY1v33eCBBj7ZxV2U0ohskYvGo2rTYS5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(39830400003)(136003)(346002)(42606007)(396003)(54906003)(86362001)(508600001)(6506007)(44832011)(6512007)(52116002)(36756003)(8676002)(8936002)(66556008)(4326008)(66946007)(6486002)(66476007)(83380400001)(316002)(1076003)(186003)(38100700002)(2616005)(38350700002)(26005)(2906002)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9L6MmNNXLO72kpSU3vs3Vs+1/brKx8JyMJYm2ukdDxk2PYpLKcSiVGeQUp6B?=
 =?us-ascii?Q?F4erSsUD9txGdnsXuGTNR0zn/TeRrRQob26d0KRIHmWXjKm9iRdhCjNitAX7?=
 =?us-ascii?Q?5JUKfNd8Zktqzovc98lCgWzuz5tETpufXcA9usvL+Z9HcetxwxXr594YcS/5?=
 =?us-ascii?Q?sUtEQHzWcdh9iOLQOccgdv9mAu7r1YsB9mpEZcjHZ5cwxAv3dyi3gnY0o2FK?=
 =?us-ascii?Q?8mJRfrJWQrsUGtZFWGTNwDX+4Xr01iUXZjfiVKiQ++TKgko1CQRDHa2y8wLx?=
 =?us-ascii?Q?CxGnm5GmsTmb4iGrC6Lhg1PbclPe4nVW6l1G5yDA9YAN2RldL0n8Xi5x9qhN?=
 =?us-ascii?Q?iEIIvvk1ThKgZFPC6bjCSsjn8AY8eeWUw7KeTFTsUGyoeQdN/+2SE0895pn3?=
 =?us-ascii?Q?/gYuU2s9781iMaYt8LVleA7RVdGg/sp6Sbhe0rVebt6q5YVSuTyXt/n3Vcev?=
 =?us-ascii?Q?kI8yREfQjWHW5L3u5WQTiQLnUoBoZbb3W6xf4ev2QTRrpP2GUhkTKs6E7Phw?=
 =?us-ascii?Q?PXpwpjpAoCeXGs4lAcj1IemACKdsxm8kc8PrHa80kDH8LGjTOtb/juTTW0//?=
 =?us-ascii?Q?don0YZANQcnApB6/EtTbsOivGYABuaVH5GIMnxnCozaHwU6iFTmOsSBGcLxg?=
 =?us-ascii?Q?fCqey6AIBrhtYtziJpgiUBZawx22y1wOQSnzJsa7yXN98k4hBCggecklPao+?=
 =?us-ascii?Q?oJ5tWmW5P1M6ccmrPuj7m4uRFEVDaZ+1xKt657BR3PvNRRod6eAhc/yUJPGf?=
 =?us-ascii?Q?ABXCvB5b9+zo7xSSno9Gp2X6fiXM5PyZJian5IJ0ixliTz8I0su+G0oECnzG?=
 =?us-ascii?Q?c9amhFUVIfI/DXyFI5cqLogS+AOpyduzdRBwDv5kaQJtx7xgieuenTbwsql/?=
 =?us-ascii?Q?6Cp7qAqgP33lT/3f3Fbm+LcVOXRyzo7LzBWFpj0gOomBghhpB4TeDHnMUNcv?=
 =?us-ascii?Q?0KmY6qgjtcisy3fyQDZs5AZHJDF2DVQv25pJOKYf6hTT3m1nytWs6i12rWfH?=
 =?us-ascii?Q?YrvJc/B5ygNahG2plh+KsdTEbrSwAFU65OCuZKkvVZXEYoxAOOwNVgL9rc5Y?=
 =?us-ascii?Q?l7qDCVWjVUHzhrIauj0wNkUQmxEum3+3TwqFIxugIeWnusEEdAs8w6TsHjBx?=
 =?us-ascii?Q?s1HHfviLaG68jgIuH7n3PcM/9NbBJzdvWVEzUT852HdPGdQNUEwzkTGeNGu2?=
 =?us-ascii?Q?CV+NCWX+Ix9x8kNj09ohwuBhAPMWXUyWX9hbaUPplYRWhnU8DPByd8IkVZKP?=
 =?us-ascii?Q?eQA6g+YlxqG1bbtPXfvYSLuybQ2XhQa2PeGH3XuFk6zqCXw3G+Nm+5chiMpf?=
 =?us-ascii?Q?BAu1pNqIIER01507hIjji/MJkxXB6WZQgC30pCpo/l4rDbxMl5b0/Xbds439?=
 =?us-ascii?Q?RRwTmSo3io909A0YXfWF5Msf7RvNHPLeO89uyZMvAV7G7PCNBSuE0eyHi41K?=
 =?us-ascii?Q?SmY73bAj7IeLEsBO4+SGN7NHXFrzbl3+6syFK+LdoXAKGGAnL88xCg0gDVq/?=
 =?us-ascii?Q?i+ZUk1DEPByBmKllR/cXdd52rmIjuahbGnORmRi0DLu3RzWe2aI+3eah2cUF?=
 =?us-ascii?Q?cZS5g/slDk/6HeALHYlHD99oy/HlH65Au0cs2EvGikH6c8fL5oKKxRlxnBhT?=
 =?us-ascii?Q?9pdTw2iIflH0ZQtsBFioPEf+eivFxtY/XqXlUK+/GZKvikcbKGbL8hIwoXco?=
 =?us-ascii?Q?1z0ILA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63ab5a8-2bde-47d9-f6f1-08d9eabe0888
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:46:55.8609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDaV868a27ALZXwIUx+lbZpXVlAUWklc0R/w6crbkewB3/aJrcVT3Iokj2tWFBwGTTazI7meUJDkPbf0FjdMUUknRJDvvUa61iTAWYzAD7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2176
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/net/ethernet/mscc/ocelot.c | 78 +++++++++++++++++++++++++-----
 include/soc/mscc/ocelot.h          |  8 +++
 2 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..5efb1f3a1410 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1737,32 +1737,41 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
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
+
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
@@ -1779,10 +1788,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
 
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
@@ -1799,6 +1809,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
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
@@ -2799,6 +2844,13 @@ int ocelot_init(struct ocelot *ocelot)
 				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
 				 ANA_CPUQ_8021_CFG, i);
 
+	ret = ocelot_prepare_stats_regions(ocelot);
+	if (ret) {
+		destroy_workqueue(ocelot->stats_queue);
+		destroy_workqueue(ocelot->owq);
+		return ret;
+	}
+
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 312b72558659..d3291a5f7e88 100644
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

