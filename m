Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4AA4378E9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhJVOUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:14 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232974AbhJVOUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJZQVa3tAYrgw1PA9ZiUz6dbg8dirIZf1p1J7tq8f/w63GLhN65jIIgCFrmiK9cVCfPiHjUZkY/QquxAOLZBx7NMMf2NCjIKEuO0qeUMD/x2ROQCRQjhA2NGs2/AGgyQN7E0QhQLfoHX4zMZGEZnfDz04goa1v1PD+SDxjDEIpNSqxhrscnxtfWVcgvsCUlQukCaEI2ozrS+WmJ7VcZJ8rFekgTkZw6q8vfJFeSV7ICiN4Ix7f7rEOjT9JKra8xfOLYIkiW5UnABMvBkCv35vktcsK8wakqEmCw3w/ri6ntLpW27M+4xt/A8YsxHYfYVXdhSKL5ehNagK8qvP2hvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITOiY2f0G4/Q5EwGadBA2Pphs/9an4p9N8Qvna5SQdM=;
 b=THTDJK5zDz/u5WYHd/lUfQGxIcnQjKEHRWpRFEFxgP42XyzLuMpvR+kSMy7cyc0p7EgTe+EOB5NZkUgnqOuNnAk6wKGPzUU/OvZLxo7voJcIughgsSexmwIuxLFK6OIGo9BsAE5GsN+OW1955qPa4w0Wk4uTO6KlIZl9Yfl5HeauNs6+hqL4SpjQG3+Kj/Q/uibCG7SvJcSSPlmKiX5i1xUEIe7+i3QbDMDrd7+ufpcaklUYhliSJ2EQzDVmgefGJuQn59hwuX/FceF2N60331zO9NFLf9V7TS64U0T4zc7e8izgwBlIa+MKVDqs9kAQf+tXcJHlhqew4H0Jwt9RmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITOiY2f0G4/Q5EwGadBA2Pphs/9an4p9N8Qvna5SQdM=;
 b=eucEwo6xdXOduHjBXfSHXgBL3h8X1eGNvtFRObVeTJ3FiXirHdns+uHMxvsfDuRqGMuqvxSBG3D9bvmm9DiMfFM6tzoJXUDS2GeoBxi9e1+0QGd5v68Hr0Uz+MZRf5a1hmknHFYj/s1MEoCSjXxAxRQudOKiTdFf7X/C9v4LrM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 3/9] net: mscc: ocelot: serialize access to the MAC table
Date:   Fri, 22 Oct 2021 17:16:10 +0300
Message-Id: <20211022141616.2088304-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2546f02e-1e2f-4545-1883-08d99566bc03
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3406F13CC79CF72F87482147E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qi4QRouiIO73a2fTmjh1zUbNt6cdoVRnt04bhZoy0pe4TQqZChsOmxA0/kgTrddRWs6F8t73wvgPs2Q+5xqKBAuGoj69tGAaTzaZmiIgfAQI1GufDj3Tg+WaqpFzxwHKl/5PI8Xs9st/BMGZ3ch8D5EDrupDzNLjUOaWhmfIldDQMVztA0v5fn5Cs5YUKyKQK8+OF/hGU+nTJFu7R3VJYEmqusz6g/XZIPFjxSJrzxEDpWOekV/813ilCHYTJYT1JiatakqgoCdXLgj9lhlvddsL5szxm804erdRDnHq8R4Ycbhsd6FpxteNZ0A9wXqRRFopmiKl7t2jDOhjC53xhNQRM5kfCYvleL/zaEXefJfMOrl87MVXL27KAjSxQ250D219UYFSwE1D1bPXI2zPyNvhDPpdkdttNOpu+MGbeyB+cOS9fjjtZpL5BsSl9enl9LzC6fmFTYoXxBQx2AdaXrrApT+yqQDIZEk3+DJKTCyCnmvG26lqdIMtHKl6P5BGBCCQpy9gCkZJCAPuzTTUHV8E4DaNpByipPmwcZyT5cKjqBuzqrFqt3vuoWe3leIyKrBkjNu2CDIPCXP0TvG/ZqKskbDF5Bm7SNGizQnwJTy7qrbxASdq8S3HKaV/ixyk4UmTFs0+bQsRPXi/nbZxE0RfB8aJvvnwC2lqXvkV2qnDX4JLPVLvdYtm2Ebqo7kmDmGcS5eTqp593dJO8zBdeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y+1a1pOvKyBzeorXgehK+jvOtZq9OomwzUGG+fyo504BhFk7jy0f7yZUZ8S6?=
 =?us-ascii?Q?mNOJhKnNJ4j450V2zf5U+y2OcPb1mVTjb87zemUuu2XPEzmOEs+0q3SbRL4a?=
 =?us-ascii?Q?1nRhsnGcC7V8Li9UV8kEy8X+kbu1SW5hyK460629SW4MA7k4qHirc/y5/2K3?=
 =?us-ascii?Q?iYXxKtC9Px/bmI2ZGll4/didwi7ujo0oqQs2I3H8WC7WR/kFmVf2acJRmVDZ?=
 =?us-ascii?Q?nPc2oZAkfMEO/hMnPFxp5le2DYtZCxV3dP539uzYugliE5GEL3M2BMITTD3x?=
 =?us-ascii?Q?A3i+aM0Gq91txawlIF6cN6jtQZIvFQKqdGSheG48TsvmeKF93tN/XXnHTzbb?=
 =?us-ascii?Q?W6g6wWH6kjcGmJ0n49drKufJx4uItJu+vcFBTRqe9uArgJJS5TMkLS3OMZzF?=
 =?us-ascii?Q?oRBvjqah7D9ojo25XCgDHUuTZIhgk02hha2cZ2f9hvfFHf/QyfheInmb5PHr?=
 =?us-ascii?Q?+Hw7oN8DyRLchD5ECV87McWRY/pAA2y1R3X/v+N3alN9vXBg6xIqrKlKjD9A?=
 =?us-ascii?Q?/YuktJnM3CIXMsf18WAfo8stuON3kgbsrOJYwrSyd4xGmgXbID23Qaa27+Zj?=
 =?us-ascii?Q?tdh6EKPQHUIow653agei1FV3ve1D7OeROfomGYy5kEf5oVffLAeNPOGhO5OE?=
 =?us-ascii?Q?HO9peh73rw8hBxUw5WlDvLsinzZf9/o37fQ1oomISvyoxL9xkqmhbQJdOqXa?=
 =?us-ascii?Q?s1CvEXJT9LLRqzOevjvK8w0RZYNZ1FiB15CDMoHl/XRf5y2LDjT4KrWzmG2V?=
 =?us-ascii?Q?GHFaUPaKmc8ZbjRTzGLld9kC5oDW/ajkOW/8J0e9coTApITDATzboVpreVCJ?=
 =?us-ascii?Q?Uanhq9VQXEcBAKrksT/ncpdgsgdKzuVfmZ1z6sFXuv+mAwffmeH+ejbiGcs7?=
 =?us-ascii?Q?76VrxuloZ+A97gDD7IU6hEiC+4aj9yRcSotBXg8KWU5S95iepF/CQpv1qYdy?=
 =?us-ascii?Q?NO2bqPIFsUpiuHdebNGvsBqVlPOF966XplLbX0finQQ9rJd4C9xocOEQbUs9?=
 =?us-ascii?Q?zicFTYpB4MRjdojBW1c+2LMaEZ2aB1iidJpLZmxFcljfnXi1QJvgjG4DlaVx?=
 =?us-ascii?Q?sHmdfAQIHOc6F8vEOIgLlcPAvtRa0a6Jo9Z4SVKpOP8cNlUGk7rwWg2/ve96?=
 =?us-ascii?Q?r2HSnzED5Dx6Wi9gepjHgEdC171BwClojGVm6v30tMF8GCulBN7UXJh2MX/t?=
 =?us-ascii?Q?O8eJT/L5unHVqfFzbRq3qSpOl9MvRLFuQYLOXikv508GUYchw/oCN63Iqa/6?=
 =?us-ascii?Q?8k9rZGr1dlNbgAxNIKxKr/BDDl9bGJ7oEe6RsrkKpwghpUHpXxFg5k6hSwju?=
 =?us-ascii?Q?I2cLAzy134K+z8kWQMlO7PHgMOOcyFr3NrUGTtAlKJYVpwsYXsvwVlYrm2nD?=
 =?us-ascii?Q?ey22Gp5idPbkPamMFih814GdZxTgOywkGIagcbsMcO9cFgakaazQ0MJp4wTw?=
 =?us-ascii?Q?dPQFuVm2BDRd3xqkNWh9mzw4U4MilwXn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2546f02e-1e2f-4545-1883-08d99566bc03
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:52.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA would like to remove the rtnl_lock from its
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
the same MAC table functions as ocelot.

This means that the MAC table functions will no longer be implicitly
serialized with respect to each other by the rtnl_mutex, we need to add
a dedicated lock in ocelot for the non-atomic operations of selecting a
MAC table row, reading/writing what we want and polling for completion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  3 ++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4e5ae687d2e2..72925529b27c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -20,11 +20,13 @@ struct ocelot_mact_entry {
 	enum macaccess_entry_type type;
 };
 
+/* Must be called with &ocelot->mact_lock held */
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
 }
 
+/* Must be called with &ocelot->mact_lock held */
 static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 {
 	u32 val;
@@ -36,6 +38,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
 }
 
+/* Must be called with &ocelot->mact_lock held */
 static void ocelot_mact_select(struct ocelot *ocelot,
 			       const unsigned char mac[ETH_ALEN],
 			       unsigned int vid)
@@ -67,6 +70,7 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
 		ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN);
 	unsigned int mc_ports;
+	int err;
 
 	/* Set MAC_CPU_COPY if the CPU port is used by a multicast entry */
 	if (type == ENTRYTYPE_MACv4)
@@ -79,18 +83,28 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 	if (mc_ports & BIT(ocelot->num_phys_ports))
 		cmd |= ANA_TABLES_MACACCESS_MAC_CPU_COPY;
 
+	mutex_lock(&ocelot->mact_lock);
+
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a write command */
 	ocelot_write(ocelot, cmd, ANA_TABLES_MACACCESS);
 
-	return ocelot_mact_wait_for_completion(ocelot);
+	err = ocelot_mact_wait_for_completion(ocelot);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_mact_learn);
 
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid)
 {
+	int err;
+
+	mutex_lock(&ocelot->mact_lock);
+
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a forget command */
@@ -98,7 +112,11 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_FORGET),
 		     ANA_TABLES_MACACCESS);
 
-	return ocelot_mact_wait_for_completion(ocelot);
+	err = ocelot_mact_wait_for_completion(ocelot);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_mact_forget);
 
@@ -114,7 +132,9 @@ static void ocelot_mact_init(struct ocelot *ocelot)
 		   | ANA_AGENCTRL_LEARN_IGNORE_VLAN,
 		   ANA_AGENCTRL);
 
-	/* Clear the MAC table */
+	/* Clear the MAC table. We are not concurrent with anyone, so
+	 * holding &ocelot->mact_lock is pointless.
+	 */
 	ocelot_write(ocelot, MACACCESS_CMD_INIT, ANA_TABLES_MACACCESS);
 }
 
@@ -1170,6 +1190,7 @@ int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 }
 EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
 
+/* Must be called with &ocelot->mact_lock held */
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
 {
@@ -1220,33 +1241,40 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data)
 {
+	int err = 0;
 	int i, j;
 
+	/* We could take the lock just around ocelot_mact_read, but doing so
+	 * thousands of times in a row seems rather pointless and inefficient.
+	 */
+	mutex_lock(&ocelot->mact_lock);
+
 	/* Loop through all the mac tables entries. */
 	for (i = 0; i < ocelot->num_mact_rows; i++) {
 		for (j = 0; j < 4; j++) {
 			struct ocelot_mact_entry entry;
 			bool is_static;
-			int ret;
 
-			ret = ocelot_mact_read(ocelot, port, i, j, &entry);
+			err = ocelot_mact_read(ocelot, port, i, j, &entry);
 			/* If the entry is invalid (wrong port, invalid...),
 			 * skip it.
 			 */
-			if (ret == -EINVAL)
+			if (err == -EINVAL)
 				continue;
-			else if (ret)
-				return ret;
+			else if (err)
+				break;
 
 			is_static = (entry.type == ENTRYTYPE_LOCKED);
 
-			ret = cb(entry.mac, entry.vid, is_static, data);
-			if (ret)
-				return ret;
+			err = cb(entry.mac, entry.vid, is_static, data);
+			if (err)
+				break;
 		}
 	}
 
-	return 0;
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
@@ -2231,6 +2259,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
+	mutex_init(&ocelot->mact_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b872da0c246..fef3a36b0210 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -675,6 +675,9 @@ struct ocelot {
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
 
+	/* Lock for serializing access to the MAC table */
+	struct mutex			mact_lock;
+
 	struct workqueue_struct		*owq;
 
 	u8				ptp:1;
-- 
2.25.1

