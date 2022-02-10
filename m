Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029C34B0DDE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbiBJMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241813AbiBJMwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:20 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC52640
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDlUKqfopq9FGpIiJHEv7ni3gJE8nXgUeEko/wLlQ1+t6XwjL4WAXKBRx9OGNfqfxL1FwoQ1fUHR/5JN3MExNcxC9TdvbJ9jPR7oHBHlThPpuQJXADfFeodoFUTvQTRjNF6tz8kNBKKM1q4QnaSYX9ngq5G08o1thHnX88NSHip/e/MKmGsOMD8LwAmlFTZbZ6/HeYIfroFrItr+9kJTXBlIKFcNPIGU50XxMzC0F5yd1Yf44tzP9CFRFgC5I3JVBtazHsVXv3lmw0qXTfia7bXWLNzy6nsnx/aJDesO08ruIrgghhg9/yais5MAwgLG26nfY9eWxUZXallOoKm9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfa464V7AvGreMhb90fvzIj28owRSXZc+IFHwyN6DGo=;
 b=chY7zO6wOgD2PI6d4cI3Lxnb+iSkqab/EAYxPWeXVfOvB/V8pl7Di9N7l+FIGN78c4Jmj+0EulX6D7nxtEEgEc32XlOAfP5G4umjA+o5XICks07W1kx+yhkE78X8u8tQsmdfRIaJal4XiVFfA4kpEeeGjjtHR0GtPXPMb42Jdn94dhKU0fDu1O1W9Uo7o9/GQVr0o61I992QeA8VFafTP28TIc6aGE1jRyn3g8t8ff7W6Y41NuoDWAbtLsRAjrJH2r7pOlfPC7MS+qkyUGKkOQzkfbEvsrgvotES4LahKSaDaV9zjo8JTUZ6O5aFgPuMtFT7fqEXQuMbru5kDtKP1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfa464V7AvGreMhb90fvzIj28owRSXZc+IFHwyN6DGo=;
 b=ZkPNRCQPd6rYGn0IioecYkz1k2/0mIAGCGAMEvzXIMsNhjKswBVg333tvBt4BojSb0aAgIOFJ7oK7iDPvUKQzsMNcGCzp42EJ+N4bqezbFJpSvUv0pKa9my9NuUaaiNPtWikpDAVnUnCeTKvtF8/f7t1cCdfcKVzkkRiBu39D1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 02/12] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
Date:   Thu, 10 Feb 2022 14:51:51 +0200
Message-Id: <20220210125201.2859463-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d50e49b-b122-44b0-acca-08d9ec942a97
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB88063C36ECF31AC466F2A75EE02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PJz1p/BmQ66dn1ULJgbM/5bp7u2XFZhlV0yZTc5zIy8ckto/bdexbA+lmhMIpBHFPN9PRWHLpMVmyL36og9EKIlyUdRnThnEqyFsGJqPJwDzUTSpPCuVMRj3u5LSu25ng74/bbZmqjBt40/I+wWm+EK3rgdwn4lVm2HzizZaLJ1GIglRDeM0xoMZ0VrIvDhsbcSXf7/KijKK7S0ax2yGinQ5HyT9uiV4G1aHbyfIVv0wU7rTIZGtSMnah7tYXn2sWLwrdTj1a/6MFwJgezo/nikdbxf5rUH82xdoUiiIjJvtCYOH9vD8dg4gUUH4S/GhYmDxTQVy8G+FsutkFJMxCGBmePkhuN58g5GEKxZVXihwjzracj1gjfSC4CKoOTcoxtspR5heCiv6MYA5wUNc+HX6E2+ke45VWrsy9wq7qymholQnU9j8PZStk0D4DCYaj3wID5oAGNecjssOzUO+Qv0gy7YaCfsA+w2BelFLLkKjg3Dxl3jHVgJ37rJQr9dlxC5yGUcXN8l2jAJ6AstAdfakwHalI7oTt/4Ioqm2HM7GJL0HsSivqepJuNx8tfM96UVZ50Rd5llh6I64jPFgLeSvyJfT9ecvcPu/stumArxkxSSdY/8vEioFEP2fY8Rx4Omk6xPSFawpSm3TQM7VOripFSsUk9knOmtiTB8GpyNEhlu9v4QB8CSC8yHljXaDtt4GktX6clRiWkpRSP/GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xw6eUGYaj3xdiWR0uEk9+cVcl6Qo4Fz7NlMAfp/wJLvxXvjwy+dT1nT49iCB?=
 =?us-ascii?Q?jBZpZarwKYpHxer672kZhlUbJF7yJuZNcqR1O7hPXGQ4oima/CoND5kYhAzk?=
 =?us-ascii?Q?60wXl8Q8J7a/5I7L/49A5ye3Tgzq6egTI70GeqcaQwxUdiqjESa62GoqpnRe?=
 =?us-ascii?Q?5puvtZOMVQ3eO3utdZC73nfQu7rhQnP3sPFyvQtbVeTABgi3JPh8Wxb70wRI?=
 =?us-ascii?Q?QBmgnB41kfWpeQf8ysrPzV1y062V+K+hZb1OXSL5H8qlgVaoblBI57aSTf/N?=
 =?us-ascii?Q?977zbd1Mh0LgENScnVyubD/ncNWkE5r4HaHdV2L0F7ZRXkEoIrUbpXXErxG+?=
 =?us-ascii?Q?hm35GgNBu1Z6J7O8dedv8F6FIDCXM7AUqFQqtlMwAJ6wzn4WzPXexVay5/+4?=
 =?us-ascii?Q?z8SeLojtNnCNn5suMMIpcTSTH8lLbe6yG2D1q5NT1N90Cs5geF9dO/f1T5bD?=
 =?us-ascii?Q?IahCvZ3gfj/tfPycXclCjHjK0AZ/fEXmTilW8+qDt7PrhFftgNibV3RMUHgf?=
 =?us-ascii?Q?VNQuHWxmoa8E7YV5Rb4AkxVqcZcSBKxUPnKHSr0tMxeOHia/iq/JCTUGrUXI?=
 =?us-ascii?Q?GZ5TNauf/c4r1/s5JwJXDvL/fNIQFrI3uR0g6NLJht8Rqe6zRmRb6gv7PADq?=
 =?us-ascii?Q?x0SQc9EkfNJh3lfjspkqCH55i75cTeSonxYSrAG3xUDb/aGRX3kdHdaVs5xB?=
 =?us-ascii?Q?IFIT36wQHEHN0LAWB63EiOO39gQZuPXTEsN8ffJHHiQrAtk/0KXH1LZrKdat?=
 =?us-ascii?Q?zw8DRpUuuIJuDESAM7qYGqo6uqzUrEy+R1aSCTKu28FDbTxb4ix6v7WPf4ct?=
 =?us-ascii?Q?BCs4iTSPvULMZkB0smEmWB6OLHpXMuZKF4v6c13p9ykqCq4VwlTIJCMo55N1?=
 =?us-ascii?Q?pbFw1ZXlzl+UZxhe5FJHSo7HXjYcDgc5k+gsXMfjLUo9Z+pIR1NeDRgsjQ52?=
 =?us-ascii?Q?bwyvYvJsZ+joaVJqZPkKIC53RsvNjVcVtqh1YbTtpRuQAE2R8SzEAYF51qVT?=
 =?us-ascii?Q?Ip0LP6aML1P87QkyrAW/IC+26ZtV2bHtVfgsVTxGyNXEux5OCfMnX/3IbFPq?=
 =?us-ascii?Q?IbkYz+7L/F0UvGaS3M5B+O1UWqp9ZYR5Aofe4GKKMAKHB+orp2QGjN2IYoQ9?=
 =?us-ascii?Q?/hLcx5Uy5jXXWcF7R8QUtnszwbCkVOZFaa9MzqehJSU1hf1g24Bfi9ce0qf+?=
 =?us-ascii?Q?qM/9Q6Nb71OEYlt/oD5j+hw9SFocWfX9jFUlikKjXsQihQpCtHmG3dC0hmJ2?=
 =?us-ascii?Q?I32GochXslssA9gyUurpvFH38Jo7jfDEC+gXOaYUM01TX0mK8S5KkLPj/biO?=
 =?us-ascii?Q?UFclpDuNnEzHNF3V0XBkQIeNCPW1gUFuQvW6vWbTBTxQ0VvLkKX/Drwv1BLH?=
 =?us-ascii?Q?0Ujmd3CkhucIw3nONZJ6elk6rPI30sxZ+HJfd72W3Mdn9IBV1Die0I2KkxyG?=
 =?us-ascii?Q?3IKJWJDkUfG10OzhsWtKwdQoMp/Wk/XyqOvYaP4qQeed6td3KTwt5oio8T3f?=
 =?us-ascii?Q?T333obnQzbX6SnSEuN979UEjnAVNZNdDcK0SkCFAVVc3uHT95Exrw1wrq7ul?=
 =?us-ascii?Q?phcNH5zsP3/38J1bi97OJxm+aDd0Igm7A7sA288BwkBiB4y8V4uQgl9GAwvW?=
 =?us-ascii?Q?N1tqUHquFLNuJqR+8L0bESg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d50e49b-b122-44b0-acca-08d9ec942a97
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:16.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zR3tkOmUq/zsC5iHepTtZLzwPidpJXqbNdXi17bv04FKUq8EwsIHc94aDRfcYWx3TVcRJjBMAIk18KEgOnYtnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
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
 drivers/net/dsa/mv88e6xxx/chip.c | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c54649c4c3a0..454e3ee20155 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6114,7 +6114,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag,
+				      struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -6124,11 +6124,11 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
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
 
@@ -6148,20 +6148,21 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
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
@@ -6205,8 +6206,8 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct net_device *lag_dev;
 	unsigned int id, num_tx;
-	struct net_device *lag;
 	struct dsa_port *dp;
 	int i, err, nth;
 	u16 mask[8];
@@ -6230,12 +6231,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6244,7 +6245,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6266,14 +6267,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
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
@@ -6290,16 +6291,16 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
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
 
@@ -6307,7 +6308,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6322,13 +6323,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
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
@@ -6347,18 +6348,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
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
 
@@ -6370,13 +6371,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
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

