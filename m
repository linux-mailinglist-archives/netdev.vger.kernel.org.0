Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1993E46DCAE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbhLHUJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:46 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239986AbhLHUJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ci9H151x8bcYgkTTtoCyDh0tpkDRH6XyCDK9Nsmeg4OQMAp+5z7hDu7DjgUc0mAN6AyGemTPNHl1H904PmmSo8Qh/trCJeI5I7X4apd1M702Gt+T6pBD4yIadG/VmbmCY+80S4H3bCqgFB9rAOF78u5ij4HNoR4m/0PSquqHUzgOIu4wi0iBNBOAUGGD9sQ98NQKmdqtZm4CAC6ekbTcjH4i92VFjSnnt//YbNgBntREKpqIcFIvHsqaiRL2KJYv5P5ED8RuWagRBOrTvdYmVhaxoXGrI8sTQfXZTbsG5CEm2ePziEJQ0K4OZb402BSwUds7TBK434gu729+DY3Ixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qd2QQ4nVs6GFax79f3AK1zsVl+LvRm7TVydMSKR02Rs=;
 b=TwD1rm0Em7gcs6kYuEc1gqCyncYAVGqe/O4Dg3ZYXrUsmJJ9WRCz0m72K6WgNmRJDEC4Co5oZaV9T3M0b+43/MGTNM+cL2d2KfYuYZLa35ereblRjd/dOrNTAXKdiM81alU0Cqp/Uc/gMsfboWYXWBc6LBtQxXSeyde/1edxdpJpb0JruQ5FHO9q8c67/jiGnKkq7C/br99+sQ8icyz2Jjy2Ea9Eh4Eu9AIW1ziMiKg809IxovGxgFl+hjIE59zd/sx5bgFQFC/DzCcmaaHbwSnhtVJpzYef8n27N4IcJHHpq8cihWCOyDO36CRK6n9IlxuctDtrWpxTKNh97g2tig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd2QQ4nVs6GFax79f3AK1zsVl+LvRm7TVydMSKR02Rs=;
 b=B7/zerCEZ9x0eXFD8MfqPEL+QWD15m3VM74+KU5lkiZncQY50x1wB9H8Qr6Pw+5WBvD6VulMW0VQgr42jiLiTGZjiKxRfdWIDm2OptMxAuLnrZa8YzKfR4vaigibf5a6w4mJzOJvEmNAItqGC64mQpzAme2Y5jmQBmGG72WP0VU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 07/11] net: dsa: sja1105: move ts_id from sja1105_tagger_data
Date:   Wed,  8 Dec 2021 22:05:00 +0200
Message-Id: <20211208200504.3136642-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 707436df-b8ff-4ff5-a9c9-08d9ba8623c8
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638FD864C36A867D8DDA99DE06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMyCcWaiBi9CgKJvvRIFbNbA41+FuXKsHY4axF6lJP9YhAaNsG3J5X/h16TwE/UeNope6GmIWUKNyADTcstuZ/fy2PvRBSj/Xu+0wBz8licOMQqBOLJ/hiKC29TjiKumKSFQnNxeKinpJcJwvDpRvtyYAgA9B0c/vFew0gFOkFFdhifTnQtJzYiDPwhyse1wQSXIXyu9rrhiLR44gA5k40Lub+KoJoEmpi6w0rmX+eUxuJCgRRODY8T6K3GNxQ4mdfdPALliD9zjYNcMM7Rw4ClLUgaqeiXWBp8T89/Tgjil08CF5oBqsLanL//E8iNp1dSINcvkI1Ghpwpg0E5Dgb6dOd1enag8u/M5i2lgClYHGAD2RuEZAdGfzFdAIXrjJL19O+RP7lLjq1wZ9ccibjP5cHP35QmsvHDjBOZj2coJcykvlUEELINsENekVWQFZQGll+uzJbbF+VQ9OTZMc0yjmknVLirsikwvVQ5j4GgB20zLcXOqf4rQznbj4rkYgdnfGRAO/dYaJGr0WmerHE8DpLkJlDTqAYevOIhBZtWMCnK9g+qsnjFhpAPWJKwbCbSlSOWeX7OsKoQNvzdymidLi4izXgwAX2NDvNEmJsSJZyNDgt/lrVtlIjyOR2xSOZLE8M9sNzki00sjFDrbhfjom4VOfqHm+XJejI8m7/xsQITuRAJsnImPR+NbBCSY4VJmamJWl0AlI0KrUEg3lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DGdpEftDGHfAioCxl7gPDXIrjV+misLROq1ZZoXHiYEWMZN6ny17KUqMsYCu?=
 =?us-ascii?Q?/8kuOHppauC7xdHnujGC860NtIYxDGxUCC/NYHyr4tENv4PlYc1KsnsiNWEG?=
 =?us-ascii?Q?n9WZeQbfcHc+FlcCjW/9yNT1l4CUsO8RruAY17UoLwuHA3jzRQH6g9zZrB7Q?=
 =?us-ascii?Q?2Yrcz8cZhuAPMdVdLrj9TFSuWYcAHxTPI8U7AB5Sz163Uk4oFNOnDiDPC1XP?=
 =?us-ascii?Q?vNi1z4F+QvAqVpA5KDo7kRMpDnk0kSmQ2/S9ucYYgVFckvkBclx8jX+BnZ8b?=
 =?us-ascii?Q?S4MDy4vXs1VUQDAMShjtQb8bLoQa/UG1GhVJv0Lyjm1iAmaGDzeJbXlPutVV?=
 =?us-ascii?Q?k65YSe+6s4Jk9kYMQvEzY9ySa0qrcuVBVU1VwEW4pQhTunmpuZoLf3ogTA8D?=
 =?us-ascii?Q?OLl2M8mcGhP75/RYhYvQDkA6a02yb3UIVXcGwX2DIM9EK+HkjQgW9+dvhqBh?=
 =?us-ascii?Q?NtgyJ23IcjRAV71PeL/JrbaKMAcssb6YPQK8En08WWh60G3uyloBBQBOmHjU?=
 =?us-ascii?Q?nB5oUKgSbM5I6+Mi+Osn78vQahSmfrI5zUzwJ3+AoH6Re09ZTzhKu0E31vBk?=
 =?us-ascii?Q?hXHf47V+5STLymZqga4snZvl/t9hwBBw4IbzQKfJmxGDfKrY+mf/CM1e8rOv?=
 =?us-ascii?Q?a6txRsg9vLn/Q6e5UniIGvM0JLPSVpdkLqVW3b4IQqTMXVEatwEHrKdgXOOk?=
 =?us-ascii?Q?Fnj6LkQT5SsZdLlKubu+fB78lu1UlMuRzzCRwnTJ2cEDgbJgNrFiAwcso2fr?=
 =?us-ascii?Q?zhEzQki8GXM9aDSOPPAswzCwZp5i5OTWgLOqCXQ9bWZ9Y5fOYiV5YxhTCVsb?=
 =?us-ascii?Q?UBMDGtOoA6dor3s59HdlB7uY1KF+5rFMhMCbFBgf27whoXXRZLpkbgNvsPfZ?=
 =?us-ascii?Q?H9SuqHw1rwEPriXBRRcKNxJYGCtq7bgryq/hT3Ck9gwZLpCcY5UJbl70i8qB?=
 =?us-ascii?Q?0VbIVhj3Q/jVqYUyzZ+qv6qmmFksHdqMm5Ty1Y2TRi0v89wWKYF30+4uTAVp?=
 =?us-ascii?Q?LnA8gmC8ytW7VD3GwMvEH3AR+9fnS7en4FSQnHzsxOFc+cJJnOo58LcM4DkS?=
 =?us-ascii?Q?4xSJT2J9XXgntRIj48SZkhZu3FhoNbGPeM5vgVECGm7pnzIZdbQlVzcUYNV9?=
 =?us-ascii?Q?533YqSKQLKd8htmrf/Dij8OkCSQi13b/a1r09IUk6CeW1onzsm3xj0Ve8Wd3?=
 =?us-ascii?Q?IgYTdI/6i896K9rXcLgk+LqC2pic9h819nBY9WCC2PMr8O72Nkisk+1gUquj?=
 =?us-ascii?Q?3dShRjSdcGInL5xLfeRWWMBV5l/3p3j6POtH6AJF+N3AJ2KrmjEHtQ7B6f5f?=
 =?us-ascii?Q?nEvBrwtCogPJy90ZTZZhr0T8FR/qTAcERSkhzeX29zw+NXBFo61OKkBguZ6C?=
 =?us-ascii?Q?8nesUahGYXRJQ5IFw7UcUoIpnZvVHARqCZrMmQSJaS4ByPKVZssAmlemF0+K?=
 =?us-ascii?Q?CTR8CiPSuZzYG91N9bS5aCy/gMxFUv9BzCWtBSMbZnA5j0npY+XXEh6IR1sB?=
 =?us-ascii?Q?yN6bQZVa/+7c/q+qJzYwWYXBSAAuTamdDhmhEYBfg3YlqUjKygvQJYfdDkF0?=
 =?us-ascii?Q?xXTN4lMwfipmb7crsuuLmfs6Gn+kzk07JvzwQws1RvyVNk/fXJvuqG1xgEPo?=
 =?us-ascii?Q?L/NvTbkrfh8lM3/1PKEx664=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 707436df-b8ff-4ff5-a9c9-08d9ba8623c8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:53.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mQFlHfbJDgvzQqd2sg5GiR+A4whiNvd+bEwO+hTemlapl7dJ8P9FRR/jfEK7FwF7+LBgTdCpqXDUSjMGajvtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX timestamp ID is incremented by the SJA1110 PTP timestamping
callback (->port_tx_timestamp) for every packet, when cloning it.
It isn't used by the tagger at all, even though it sits inside the
struct sja1105_tagger_data.

Also, serialization to this structure is currently done through
tagger_data->meta_lock, which is a cheap hack because the meta_lock
isn't used for anything else on SJA1110 (sja1105_rcv_meta_state_machine
isn't called).

This change moves ts_id from sja1105_tagger_data to sja1105_private and
introduces a dedicated spinlock for it, also in sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      | 3 +++
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 8 ++++----
 include/linux/dsa/sja1105.h            | 1 -
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 6ef6fb4f30e6..850a7d3e69bb 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -261,6 +261,9 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* PTP two-step TX timestamp ID, and its serialization lock */
+	spinlock_t ts_id_lock;
+	u8 ts_id;
 	/* Serializes access to the dynamic config interface */
 	struct mutex dynamic_config_lock;
 	struct devlink_region **regions;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4f3350df7f4d..6468a8e963e8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3349,6 +3349,7 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
+	spin_lock_init(&priv->ts_id_lock);
 
 	rc = sja1105_parse_dt(priv);
 	if (rc < 0) {
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 9077067328c2..0904ab10bd2f 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -468,15 +468,15 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	spin_lock(&tagger_data->meta_lock);
+	spin_lock(&priv->ts_id_lock);
 
-	ts_id = tagger_data->ts_id;
+	ts_id = priv->ts_id;
 	/* Deal automatically with 8-bit wraparound */
-	tagger_data->ts_id++;
+	priv->ts_id++;
 
 	SJA1105_SKB_CB(clone)->ts_id = ts_id;
 
-	spin_unlock(&tagger_data->meta_lock);
+	spin_unlock(&priv->ts_id_lock);
 
 	skb_queue_tail(&tagger_data->skb_txtstamp_queue, clone);
 }
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 1dda9cce85d9..d8ee53085c09 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -51,7 +51,6 @@ struct sja1105_tagger_data {
 	 */
 	spinlock_t meta_lock;
 	unsigned long state;
-	u8 ts_id;
 	/* Used on SJA1110 where meta frames are generated only for
 	 * 2-step TX timestamps
 	 */
-- 
2.25.1

