Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B8414C35
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbhIVOjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:39:24 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:12042
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236177AbhIVOjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:39:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8lCXOY2vmHHvskwcMB+KMEennugfErwPxYj1UplyjO1gS4WNHOct2GiR6lTgm1cOKzIXwBkHH7fwAUV7OJ3/ur7VASF0oQ1WFUnlGYac8yotav6mzXoR/5cUNx3Y0+mjG0dqaJFjo6f9mH66y2itUNM+GwRK2BOTEn56HDbqy+4CMOqahprxUmlS2pOVSrK1Dn4p7wVfHIl8G+67MHigyUJsKL7jpDWHJ2bvyJtyAzsn/XvwCxiaVC9cmf4W/r2ZGy/UUK5DzCgJa//luR0y1zC2WNvpgrc/D9NgqR2d8Ac3Y0UXtEr5obZxx4EVldNrRIXEwSQlG2Cuq50mcs8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mR8hTKXBNfBmMwa7+dveqrvyztdxYTaFY7HyVqHrsjU=;
 b=VPYKi1W7HtKsmeyrfgIyn4qheNc1bK5lW+HJ6SV8tIt6XeXqDhbIR8vi5KJmHX+cfVTgpTvZuohPfL2WsH49853YJGIe8ES/36SKlCzY4dHndnveTluqrndW2dtlGhHKyeBkoI+B0/lRATtrEc3jlC4B5SgAVLPsSjdSg9QHoMmu9h5r8AmOXsqw5XIs+go4fJiV29+m/V2i38kwE4M/lCaNjVmODkf8z/hanCvg9Hm0B2XtP7J+wu8O8qLtOQ3lB4nCwBVe2qwbSHUeKz7fJ3J/RbjQGrCPAy1Zg2tFTGzQ88GZLkHdHMDmocWOQ3DrC4OFMi44G9XLZQqCGh6rDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mR8hTKXBNfBmMwa7+dveqrvyztdxYTaFY7HyVqHrsjU=;
 b=bUtUPz1+YuQ5g5qCGNV1uM8ZBx+IH7RBqeICbKe2yyBWtVFEWEViisRiNBTdGLVxUsfoaxTt2XoqxQj6mE0P6WZfveD0poViDKhCZZPJyABNruScVe1fEQOUYtAkLsn9wk2q670nygr4FBgkJOK9GNEOU2y0CpVrqSPZQpvVY6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4431.eurprd04.prod.outlook.com (2603:10a6:803:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:37:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:37:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
Date:   Wed, 22 Sep 2021 17:37:25 +0300
Message-Id: <20210922143726.2431036-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
References: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 14:37:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9bdcc78-8a4c-4a45-9ee6-08d97dd68bc2
X-MS-TrafficTypeDiagnostic: VI1PR04MB4431:
X-Microsoft-Antispam-PRVS: <VI1PR04MB44319FF1CEB7CB6A483BA3E0E0A29@VI1PR04MB4431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uAla1UxZzyP6Qdp1UCz6obBmJgSJ0jH+TSl2uW5mqMcKv4RbCSgFxxkQVvcL+1echIbj0NHlp85baBfW3khdv2z7aud8bmqIjdHgjg5MiHkDZKS5JupiVaQnAWssgewkEEy0rRRXI7xQsNh6E/MPTBy3zRBX1muTAw0XtfF7cS+0ACeWcq2Az82TsCHxP1PEaVvY+Tb+GwcbsIcHBLiZQSr9qfnK01GlGLfCFslt/yv+VpAvDgIh2LPJazbF/Kyyodlf7CwEldES+P6S5q7XnsG1YsrlooV3fZNnujdRAcH7Twy/uUHiw0Phf8iO6JFqEFzhgH3PAo3At8SQ3zowQSsfHu5zGF04bmtwQ3IpB9F7mqdn5NC5mZ3cqnx8/SR1aloKMnCrLROZyQvVTnJ6mJeQfIfpShuPqqYFtnCg0dCvfrCgWLelCSpm8KxeuH1Idv4EHn4BDcopgYn+s2Pe9Z3vyeqnze5DE3xTCpP+/sHW+DaJgDt6Is74sXqh4gdv5myXEeiLyV5ye5ENFwRwy8hW3Mgan+bMJja/WDpFrm2Fx+fno7ea+WTCbqBV58cWtRQ/9Eom9FtfNsvoVY9ojMWmaVWrs1ldn8MIGBqVrVhYyQJWmjFAmKM5bLAkMhp29ay8VT531tkzdEpF6F6qEW7VW2LAZcyrRBmwbQ/DpIO33OsIrujUDW0FI2Gm+sERm4mb7FDVgA2A7uCth3ezmRcwnPKRnELf5wYi4BCOf13QnbS2OBurZoyWrqaf5JYiT0rNT3FjPKMzpbXt2gEbhvPP0fM8i6KwV8BMb8P+CuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(83380400001)(316002)(110136005)(44832011)(2616005)(508600001)(30864003)(52116002)(26005)(86362001)(4326008)(66556008)(186003)(36756003)(5660300002)(66476007)(1076003)(6486002)(2906002)(6506007)(6512007)(6666004)(966005)(8936002)(38100700002)(38350700002)(8676002)(66946007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBky9SSthdStX6OMjQv3cPBMjvcNHg9D+u+vlNOu8gDdtn5KU5tSi67UZezJ?=
 =?us-ascii?Q?GSOOL6M5IcbD/tYiQlGZH0qCEX+wFGQO+8IBP/KoocpIFEXGx+3sXH/YnHsm?=
 =?us-ascii?Q?KNcBexmccv0hLibcl05i5Cmj14CVJvW6D6qoLtBx+uZC62BbK/7BKTwNzi7y?=
 =?us-ascii?Q?z+aaC4MzZ3INJUgVYQ5IbtbwKVRTZc88USclzUtNo1xt5jeNLZk59wWtJDhM?=
 =?us-ascii?Q?hsngFkl6jwSmDc4b0qD149RLBfKram7TAgdgNzg5F6U5DZK7MjJ4/GD2XRHQ?=
 =?us-ascii?Q?7M+kT0ufnkn17G/u+Tnew5soZebNHLey+wB1YspTO1iIsr5ZhTQC8WJCeuyH?=
 =?us-ascii?Q?9DIDkJRhSqvGkwCp6i/K/8hQST5Eh9e3RZ3KjhmqLlsjVtY0xhmCZpC3Ccts?=
 =?us-ascii?Q?b5g18Gj2MlKq2/zVkQf98sLywyQcIGw/yE+kTKsnHgqTa6Srk2h5hsGk86qF?=
 =?us-ascii?Q?AlvYd1BIZQWAaHYJfuaO//rsdFnzp4DR/OfyMahjcKBVt6M9XdaXYaOM2Mys?=
 =?us-ascii?Q?EjZztKXfwQFWx9308vKlWSRIGihn9906ylNKieH1uovH9mHtt2aEB6FVIHjF?=
 =?us-ascii?Q?EiZpxgKwa1DncVg1i0plr1VihIxEoBqtsDCtFk8QwYF1tQRUFh4RtS8aVSz3?=
 =?us-ascii?Q?QARMOZ+utjqMEH7pZXRDV//j0vFIzBy8Xuc3U/bt6YhYBsYwOigJh1g4T1vC?=
 =?us-ascii?Q?lU2bsx7ZgwsRRBm0iop30sWiEOZAQkIVTcyPYe4SMVMXXdu71TKbX+vrKeCX?=
 =?us-ascii?Q?1Sur9IjeTPyZUQWMzQvzT5sEWGs6yvv+q9o3HU7AzUzPQ5jlxYEXnNHO3+/x?=
 =?us-ascii?Q?uLzCCpkJVy4YyYCyHYijuVPABL4dSdInKvGI0mXc423vZl9Zbq6aPsWfaiCm?=
 =?us-ascii?Q?wMi8KgiFanmJzSME+aFB/98Ukr64YD75VdM2MSI3y3Mqj15JqxT0Koj+msOS?=
 =?us-ascii?Q?x/b79zxtcaWcSXNKU1acpmhv3zOslCouvvfJBkZR9YgT03cFp7Wayp4uP/Xu?=
 =?us-ascii?Q?TrBSmxKFG9ie9vyiSuwG58CTjhZ1VMvpzi8soaTQ+EgqvWjb2s9CP9leJ0h5?=
 =?us-ascii?Q?WBO6h37f+fpLMRiYxdMWZXY8D79rTYxG+U/TblOQe63XAeerh6mutedgsC1g?=
 =?us-ascii?Q?dQ5F3/TiaGJXwYrGYH6lwnWNI4ppm1U2QEN3z9u+pvaTztWmUFmbcZPrJcl+?=
 =?us-ascii?Q?9JZGf2n4YXXJ/Zd4JIJ6L0cONE8833w9r7aBoUbW6T85221W/V4n6YGcKE3C?=
 =?us-ascii?Q?Wq5Oz4vRZDE9aZybkU5ZTtLNH8ytaKHYLzzTjMyy0gnBU+fOS0TpFJ36fNKj?=
 =?us-ascii?Q?yemqKsAb8bIUAwD88JVxwCDr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bdcc78-8a4c-4a45-9ee6-08d97dd68bc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:37:47.7593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1gefs3qz6m4GOHHpxUtPHXoTsm+tGMw83VzVVFgdTqduGZst8fFzjB0ePuhbzT18DI+xRt90Nw9fIoQuXr69Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem is that DSA tagging protocols really must not depend on the
switch driver, because this creates a circular dependency at insmod
time, and the switch driver will effectively not load when the tagging
protocol driver is missing.

The code was structured in the way it was for a reason, though. The DSA
driver-facing API for PTP timestamping relies on the assumption that
two-step TX timestamps are provided by the hardware in an out-of-band
manner, typically by raising an interrupt and making that timestamp
available inside some sort of FIFO which is to be accessed over
SPI/MDIO/etc.

So the API puts .port_txtstamp into dsa_switch_ops, because it is
expected that the switch driver needs to save some state (like put the
skb into a queue until its TX timestamp arrives).

On SJA1110, TX timestamps are provided by the switch as Ethernet
packets, so this makes them be received and processed by the tagging
protocol driver. This in itself is great, because the timestamps are
full 64-bit and do not require reconstruction, and since Ethernet is the
fastest I/O method available to/from the switch, PTP timestamps arrive
very quickly, no matter how bottlenecked the SPI connection is, because
SPI interaction is not needed at all.

DSA's code structure and strict isolation between the tagging protocol
driver and the switch driver break the natural code organization.

When the tagging protocol driver receives a packet which is classified
as a metadata packet containing timestamps, it passes those timestamps
one by one to the switch driver, which then proceeds to compare them
based on the recorded timestamp ID that was generated in .port_txtstamp.

The communication between the tagging protocol and the switch driver is
done through a method exported by the switch driver, sja1110_process_meta_tstamp.
To satisfy build requirements, we force a dependency to build the
tagging protocol driver as a module when the switch driver is a module.
However, as explained in the first paragraph, that causes the circular
dependency.

To solve this, move the skb queue from struct sja1105_private :: struct
sja1105_ptp_data to struct sja1105_private :: struct sja1105_tagger_data.
The latter is a data structure for which hacks have already been put
into place to be able to create persistent storage per switch that is
accessible from the tagging protocol driver (see sja1105_setup_ports).

With the skb queue directly accessible from the tagging protocol driver,
we can now move sja1110_process_meta_tstamp into the tagging driver
itself, and avoid exporting a symbol.

Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
Link: https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 45 ++++-----------------------
 drivers/net/dsa/sja1105/sja1105_ptp.h | 19 -----------
 include/linux/dsa/sja1105.h           | 29 +++++++++--------
 net/dsa/tag_sja1105.c                 | 43 +++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 73 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 691f6dd7e669..54396992a919 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -64,6 +64,7 @@ enum sja1105_ptp_clk_mode {
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 				      bool on)
 {
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
@@ -79,7 +80,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		priv->tagger_data.stampable_skb = NULL;
 	}
 	ptp_cancel_worker_sync(ptp_data->clock);
-	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
+	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 
 	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
@@ -452,40 +453,6 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	return priv->info->rxtstamp(ds, port, skb);
 }
 
-void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
-				 enum sja1110_meta_tstamp dir, u64 tstamp)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
-	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
-	struct skb_shared_hwtstamps shwt = {0};
-
-	/* We don't care about RX timestamps on the CPU port */
-	if (dir == SJA1110_META_TSTAMP_RX)
-		return;
-
-	spin_lock(&ptp_data->skb_txtstamp_queue.lock);
-
-	skb_queue_walk_safe(&ptp_data->skb_txtstamp_queue, skb, skb_tmp) {
-		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
-			continue;
-
-		__skb_unlink(skb, &ptp_data->skb_txtstamp_queue);
-		skb_match = skb;
-
-		break;
-	}
-
-	spin_unlock(&ptp_data->skb_txtstamp_queue.lock);
-
-	if (WARN_ON(!skb_match))
-		return;
-
-	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(tstamp));
-	skb_complete_tx_timestamp(skb_match, &shwt);
-}
-EXPORT_SYMBOL_GPL(sja1110_process_meta_tstamp);
-
 /* In addition to cloning the skb which is done by the common
  * sja1105_port_txtstamp, we need to generate a timestamp ID and save the
  * packet to the TX timestamping queue.
@@ -494,7 +461,6 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_port *sp = &priv->ports[port];
 	u8 ts_id;
 
@@ -510,7 +476,7 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 
 	spin_unlock(&sp->data->meta_lock);
 
-	skb_queue_tail(&ptp_data->skb_txtstamp_queue, clone);
+	skb_queue_tail(&sp->data->skb_txtstamp_queue, clone);
 }
 
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
@@ -953,7 +919,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	/* Only used on SJA1105 */
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
 	/* Only used on SJA1110 */
-	skb_queue_head_init(&ptp_data->skb_txtstamp_queue);
+	skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
 	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
@@ -971,6 +937,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	if (IS_ERR_OR_NULL(ptp_data->clock))
@@ -978,7 +945,7 @@ void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 
 	del_timer_sync(&ptp_data->extts_timer);
 	ptp_cancel_worker_sync(ptp_data->clock);
-	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
+	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
 	ptp_clock_unregister(ptp_data->clock);
 	ptp_data->clock = NULL;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 3c874bb4c17b..3ae6b9fdd492 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -8,21 +8,6 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
-/* Timestamps are in units of 8 ns clock ticks (equivalent to
- * a fixed 125 MHz clock).
- */
-#define SJA1105_TICK_NS			8
-
-static inline s64 ns_to_sja1105_ticks(s64 ns)
-{
-	return ns / SJA1105_TICK_NS;
-}
-
-static inline s64 sja1105_ticks_to_ns(s64 ticks)
-{
-	return ticks * SJA1105_TICK_NS;
-}
-
 /* Calculate the first base_time in the future that satisfies this
  * relationship:
  *
@@ -77,10 +62,6 @@ struct sja1105_ptp_data {
 	struct timer_list extts_timer;
 	/* Used only on SJA1105 to reconstruct partial timestamps */
 	struct sk_buff_head skb_rxtstamp_queue;
-	/* Used on SJA1110 where meta frames are generated only for
-	 * 2-step TX timestamps
-	 */
-	struct sk_buff_head skb_txtstamp_queue;
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
 	struct sja1105_ptp_cmd cmd;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 171106202fe5..0485ab2fcc46 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -48,6 +48,10 @@ struct sja1105_tagger_data {
 	spinlock_t meta_lock;
 	unsigned long state;
 	u8 ts_id;
+	/* Used on SJA1110 where meta frames are generated only for
+	 * 2-step TX timestamps
+	 */
+	struct sk_buff_head skb_txtstamp_queue;
 };
 
 struct sja1105_skb_cb {
@@ -69,25 +73,20 @@ struct sja1105_port {
 	bool hwts_tx_en;
 };
 
-enum sja1110_meta_tstamp {
-	SJA1110_META_TSTAMP_TX = 0,
-	SJA1110_META_TSTAMP_RX = 1,
-};
-
-#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
-
-void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port, u8 ts_id,
-				 enum sja1110_meta_tstamp dir, u64 tstamp);
-
-#else
+/* Timestamps are in units of 8 ns clock ticks (equivalent to
+ * a fixed 125 MHz clock).
+ */
+#define SJA1105_TICK_NS			8
 
-static inline void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
-					       u8 ts_id, enum sja1110_meta_tstamp dir,
-					       u64 tstamp)
+static inline s64 ns_to_sja1105_ticks(s64 ns)
 {
+	return ns / SJA1105_TICK_NS;
 }
 
-#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
+static inline s64 sja1105_ticks_to_ns(s64 ticks)
+{
+	return ticks * SJA1105_TICK_NS;
+}
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105)
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index c054f48541c8..2edede9ddac9 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -4,6 +4,7 @@
 #include <linux/if_vlan.h>
 #include <linux/dsa/sja1105.h>
 #include <linux/dsa/8021q.h>
+#include <linux/skbuff.h>
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
@@ -53,6 +54,11 @@
 #define SJA1110_TX_TRAILER_LEN			4
 #define SJA1110_MAX_PADDING_LEN			15
 
+enum sja1110_meta_tstamp {
+	SJA1110_META_TSTAMP_TX = 0,
+	SJA1110_META_TSTAMP_RX = 1,
+};
+
 /* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
 static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 {
@@ -520,6 +526,43 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
+					u8 ts_id, enum sja1110_meta_tstamp dir,
+					u64 tstamp)
+{
+	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct skb_shared_hwtstamps shwt = {0};
+	struct sja1105_port *sp = dp->priv;
+
+	if (!dsa_port_is_sja1105(dp))
+		return;
+
+	/* We don't care about RX timestamps on the CPU port */
+	if (dir == SJA1110_META_TSTAMP_RX)
+		return;
+
+	spin_lock(&sp->data->skb_txtstamp_queue.lock);
+
+	skb_queue_walk_safe(&sp->data->skb_txtstamp_queue, skb, skb_tmp) {
+		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
+			continue;
+
+		__skb_unlink(skb, &sp->data->skb_txtstamp_queue);
+		skb_match = skb;
+
+		break;
+	}
+
+	spin_unlock(&sp->data->skb_txtstamp_queue.lock);
+
+	if (WARN_ON(!skb_match))
+		return;
+
+	shwt.hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(tstamp));
+	skb_complete_tx_timestamp(skb_match, &shwt);
+}
+
 static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 {
 	u8 *buf = dsa_etype_header_pos_rx(skb) + SJA1110_HEADER_LEN;
-- 
2.25.1

