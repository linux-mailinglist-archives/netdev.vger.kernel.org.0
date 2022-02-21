Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5C4BEA24
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiBUSFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiBUSCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA03215A35
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9Th3TfbETdPaw3k+UG8VdKJ+ZG7AafIKV4yhJnm57TTbUKl0NwArOrgoXk5Gb56K6AzOVzQwP76gSGpXv0tMvL8j1fPuVEJwSM/cSdWJ13el0/oS1rC7SILiP0v2ecECyIsbntAvQs6ex6zbDRyAu2SjnBv+FZ10U/8s5FKVzatylqlE+PmY+Pfm+pAtEvBKvxTd16VauARYvDuxT4exkIlY4tfwtXNTdXRarsWkG/NdAoxvFBWYuLkYUYXwEm+U+trpPHTzH47TmFSKg8BD+W9vYm7Cgmp/5cAEcCoB0obEwGxLFFEBFCJ+RzdUaKcolUB0eD4y+E7SkpcKIlcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SswZFucdYMLD6wSaVIeXThrXKauYawUyky4zmydmT0U=;
 b=XpBZJ03Wf9Rg77P8QTsmS6p7tpWZODtkC92/JrBlSbmTDv4iOpLyQOKUr2tJxnpQEXEuhlLFx+q5T/b/TUP5R4yHqtP6BNL9SwCzyNoo6XQK030hS16ZWT2fj6FSxyUEoH/zaWAQjKc56D3GoOZK3ek9QxBEiFGYx2J/K7249Da7L/z7S7mrJsNp6wfpvMaP/9OPdL4RFc5AwO7hfPsehkTFnMZ7cFy/vmDo412en2dQt+qYAoijd7zlBJJrExLcEtLPnrHQgvpKu2JtAOptl3nDxGckFtL0gfADktk7Isq/NyZhqRToy1Gt1eDXKnt0sX0r+a8Xh7l8ENiglpuZBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SswZFucdYMLD6wSaVIeXThrXKauYawUyky4zmydmT0U=;
 b=TQ10IOi2wnLyhyjCyu9ZkelfZv/YJnAfSzJoH8s64AjtNbrV9ol63oo9JRzu8PnalCM5n5AHE2YgczaZ5Bd5gK76/UlTY9BXdui3atJ9ycCnohvkfr3+rOQH3OCsGlWayaPXFcz8II45Svce52KNjCplaZtOuV63y7w7QLzB4mc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 02/11] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
Date:   Mon, 21 Feb 2022 19:53:47 +0200
Message-Id: <20220221175356.1688982-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e12c830-8ad9-4a62-bfa1-08d9f56328f6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB36930AA994AA1C787EF4ED4BE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myApd9kqmGl+sdCj+mNX+8TTH5iEwmEvYW7sZxXHtAKnu8F033xUCVIc56AQPdpsdc9ijXlNS26sMX0TybbD+r7zlAvZCDQx6Y5y6Joiy2m/RLJhbh9whzLfmSDnu1LO1MVIn1xole9o6hsD8DA425qA5pl8op/dLOVS4ZucXYg3BJjkYDijSOBxwOUF0vtCxU8aGbkKqMMaCKpz4sWUzbNOU8Zh/Rw1BiAzH8uNcOreSKoH6a2mJO1vwNIvdu6XcWRR4dL5qd6755XsrV6rhaJqoV7QPFyx1b5fH+nWxqLXT0xZrPv1D82EFTowIzRW66MjpBLwaGjOMelKumZlFsn5IVGk8J5MsdQCoj1DAdDYIgAlbw+2S1Hzlbg8E9lsTv8K55wvT6UJFmVxIlL/yKfoUfHoVLFFCbYTstmpeLWIqngGAlq7ikkI9Jj2rbMNEcOUEZR+O5+xj65kwfj/ftIcOo+OgUSm7ECtM9Hesf4lESRJ+GIFNVOQrIkhSXQ6jVUthph8fohvM/8+hhmDIYdBQwzMaXrBpS5Q6UzkvLcge6T00e4e5K+A3SmXM05CnhSvOhJ/ap+BOpdFhc8YNsRs/dBW7Zhx/HEBWYamhSXNB47DDSXR1vjsL70418nBiwKx9cc1NDHiA3Zqak1dhE+IxIlGORNeoOtHt6RVV6/nVIvkutuqnWP4PJb2skoKerZWHHjh4/JHIvLBVtEiTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eQ7PbQ5lqx8LXOji9XR8bXEOoZgoXmWNbgYUQOeOjLQxzrDGhGV0HZt/al/N?=
 =?us-ascii?Q?SPlyuQa8rT0An+rmi3mXiILc1RIOFfrBSNiFtr97G3FPXyL3888qtj3mJHuB?=
 =?us-ascii?Q?e5hvdL+2MB+4vfGYzKFTQRf+PtRYj9rUGa18C1eB4rAInlcMIHQXR7T28Bcp?=
 =?us-ascii?Q?yjLLG9Qc+Kyo9UYtoR824yOTG67ZVYgAbf/+1JEOtBxAIXwzqZsVvsfad+uX?=
 =?us-ascii?Q?5iwpMYjBJ/ZIFeJMm/IIpwBhmTvlgAyiXLYUrOM5U81E5ljp8ueCgfN5R8Q3?=
 =?us-ascii?Q?IwVJtctNmha0nfKn9GeQwLyRCcJcYjf7omS0cuDJk6FWy6nmb6vjHeFXb6QE?=
 =?us-ascii?Q?Kkqm4L9F+BHFa1vsVwWATSNAdZM/K5H6WTU4apc5zb4QFMZCWdD1Cq64U36h?=
 =?us-ascii?Q?yhHkBnjOCRWgK2rrNKEgDyji5hkxxbjZlxrh4LKilzePByphk8fyy/QD1kaK?=
 =?us-ascii?Q?Spdf1E1vk6TXxsLCPzFEgzzlbpJ3CSHLOdD4CdRePRsIBp+SZocxEXnNyQt3?=
 =?us-ascii?Q?7HhXgiKLVXpJWhJWrW9F26kDzyjP6zItR4KaAOE41t1cLvJAmwiI171TkWp7?=
 =?us-ascii?Q?J75yCA1G/s9YqfkRHmAGxF6NTlcWeVho8XWhNFjbobq/aBPx/pg2lvMY7oN0?=
 =?us-ascii?Q?vQTZp/c8vGfBNsUYUJp8RpPSviAZM6IrtLxI9xuRnqP0lNKPyr+0IgGpj7Cr?=
 =?us-ascii?Q?w+/JM2abZYNfT+saQUImmjTNbjsemRQUMtL0Lq9WbyzM74O6aHrsBNcz4I7l?=
 =?us-ascii?Q?ALf40UzWrVcp1UI6uSIfIg2zxK21DlWq4PQzTOD106idwKYJ6vaxtoWtSbk1?=
 =?us-ascii?Q?zoozuGg9MlIeZHotiQSqTtqEOeBiTEdb4ZVD7XW1/o56TCkg7vU/ducN05eE?=
 =?us-ascii?Q?fK/HEhnG7OWzLxo6Tg8kbSnnREPTE1pgyvE9px/NnP/IMz380nwuyO1Tjd57?=
 =?us-ascii?Q?qcOwW1d/f4s2Wd5dUYk4Yc7ycnR3My8/Ebe4X6mBKSyRpwuETy09VbZFDUg9?=
 =?us-ascii?Q?ZE3VtX5uQki9y8efgASzGZAH764zj9aVZDn+VI+O0pEUy6fuS2hdguOjOA+i?=
 =?us-ascii?Q?kxmlWeKKs2gUhzN3s3PsP48GfdM1uCU5po8BQfa7dav1Rt6RcuWIy2XLi1Ca?=
 =?us-ascii?Q?emXhReuVQuk6bMQQkdTyDoKxPuv/wI17X8IOR/+ZfRNnTZKvAfQO1f5fbqzg?=
 =?us-ascii?Q?bg/LPNAw6yT7ClMXSl8slRXbciAQeSCcDiuWBvhyOiCGgx2ogQjB/hHkBidk?=
 =?us-ascii?Q?skzn1Ch70FSLbN0fvdS8Y0kNY4Zgu76yGmUKL+YRkOVX9XNUbaL4qeyeacQt?=
 =?us-ascii?Q?PxP/SA0AkaqNQ5JcE52MpDawk+WWINfeOSTVTBfXagsWt51Fd9SSl5QP65ES?=
 =?us-ascii?Q?nN7V8GOB5eCbwM6+rYOK1Rqz/ynTFNP8XWDxNVmpZ9zfSTCmkUjABmhaLegN?=
 =?us-ascii?Q?YYwzJuYWQ+Y0IDod0umE79aNW9IWOj42XSt7XkXNZj/zhmLa0CjbOErjqyS8?=
 =?us-ascii?Q?4YmWKEbWE7FzZACIdfydbNyKnOIMEhCtQEl0n7Fd7/rUbVYfFRtJ0kOJmPNw?=
 =?us-ascii?Q?TT6JzcqG344rL2CJZF5w8jRJ2gwoK8Mbd/WBtqUrVQqUflnKKnnAUl9duo5N?=
 =?us-ascii?Q?D12qmzc2dPt2TY+VOXQg0rs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e12c830-8ad9-4a62-bfa1-08d9f56328f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:08.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJPkFLj7XMTr96lKNxgmMwEQVS3Uj8/p7h3f1N5vkcxHPVgyLd/HE6yJpfueDALeLaZcmLXFRUs5rKYda+HQow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in mv88e6xxx to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: none

 drivers/net/dsa/mv88e6xxx/chip.c | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7d5e72cdc125..24da1aa56546 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6168,7 +6168,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag,
+				      struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -6178,11 +6178,11 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	if (!mv88e6xxx_has_lag(chip))
 		return false;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -6202,20 +6202,21 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct net_device *lag)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
+				  struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
 	 * port if the LAG port is on a remote chip.
 	 */
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
 
 	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
@@ -6259,8 +6260,8 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct net_device *lag_dev;
 	unsigned int id, num_tx;
-	struct net_device *lag;
 	struct dsa_port *dp;
 	int i, err, nth;
 	u16 mask[8];
@@ -6284,12 +6285,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	 * are in the Tx set.
 	 */
 	dsa_lags_foreach_id(id, ds->dst) {
-		lag = dsa_lag_dev(ds->dst, id);
-		if (!lag)
+		lag_dev = dsa_lag_dev(ds->dst, id);
+		if (!lag_dev)
 			continue;
 
 		num_tx = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (dp->lag_tx_enabled)
 				num_tx++;
 		}
@@ -6298,7 +6299,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6320,14 +6321,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 }
 
 static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
-					struct net_device *lag)
+					struct net_device *lag_dev)
 {
 	int err;
 
 	err = mv88e6xxx_lag_sync_masks(ds);
 
 	if (!err)
-		err = mv88e6xxx_lag_sync_map(ds, lag);
+		err = mv88e6xxx_lag_sync_map(ds, lag_dev);
 
 	return err;
 }
@@ -6344,16 +6345,16 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
-				   struct net_device *lag,
+				   struct net_device *lag_dev,
 				   struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -6361,7 +6362,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6376,13 +6377,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
-				    struct net_device *lag)
+				    struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_trunk;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_trunk;
@@ -6401,18 +6402,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
-					int port, struct net_device *lag,
+					int port, struct net_device *lag_dev,
 					struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto unlock;
 
@@ -6424,13 +6425,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *lag)
+					 int port, struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_pvt;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_pvt;
-- 
2.25.1

