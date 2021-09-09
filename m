Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5D2404233
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348463AbhIIATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:19:06 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:42468
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348431AbhIIATE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 20:19:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hw5KwlgiSUXVcYBIflcF4zU/A6frh4M+xIaV3axsknah9F/g5lc6+wQlwLbDlu7gaIFVxRsl3eWYl/mO3uKb93VZ43Ov+tJBV94nr4vfQXPBCBPZSMNlvyKPwtLnzi4SvR4VSAAb5Pq4z+6ctzW4KxSuoEmT+j0+JjYhZ5mLUZrKvUVms1XQLkTtrAdk6MdsM8mqqYOz5ClxWTJCxzogvETAdWSyqLL0jOEquQQ/D4T0aF2Ft9JSElSzk4Ze12Jh5FMlCB6M6y7abUsbs1+h3ChWBHuJ4xuoIBy4vcSFx9ua9W8cDjxENG+8owFO0khtMxXENu4LuVz+ZrrJPwYLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ssr7Xgr0lkbvdSo0zfYDc6el3rZjWW6R4Vf2tZ7mQSQ=;
 b=gWkF+gELBbSF28Prw5jnNsUXndio29ApkMfPqsGsHvTSbwx7UsDEn4HIS7fdzJ1S9yVcPItw8rWuyAL9ZhHrza/92QF9euUS+7ay7a4NNom75KemNl6b2a1c6fFzAkcIFd4e8QWoqQu/RKV3IMyzlP2sNHrhL1Xex0k0QADLjt/bV7mHUkJNSPlr2DUZtzQxGe8SYSaN/rld8VOcbW4OT9pOZLy9G9syDAJAzeL0weny/zkybg8NIBQg1JllYNg0r6yH9H0Z92Qvr/ttmesDShTVJNKsdeQ4zsIdP/P14tcORaOGu6/kjstgOUAfWBdc3ffMJGdailvAfJDzi+gAQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssr7Xgr0lkbvdSo0zfYDc6el3rZjWW6R4Vf2tZ7mQSQ=;
 b=jmot30/xyhF+h1dSjEncJGXBOiW7drictpHDXWOhcPizKZQC0l865g+ijhSONqIoLvWYZvhb6tdVy/6Ukr7fy0vAmOXNeApVor4Qms3IQfg80RmS9XULUqGm9BRAywrHfL+gWu1P/GjO05Zhf3XpE2/F9XAgMn8pW6Zz2xgqWA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:17:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4478.026; Thu, 9 Sep 2021
 00:17:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net 2/2] net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
Date:   Thu,  9 Sep 2021 03:17:36 +0300
Message-Id: <20210909001736.3769910-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
References: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:802:2::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR04CA0058.eurprd04.prod.outlook.com (2603:10a6:802:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 00:17:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e142508a-3b3b-4c1f-cb46-08d9732742e5
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65114A6DA4FDB7EE8E8439BEE0D59@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJNKz6gwGRPNDdjgyONm15Q9wD5yjn/53gZQ1betJ/ueZRm1E6Kzy8Ddf4zoyZG3AaVWm7VAdIBfuF5Zhp8Ij4J/RJ12SNbflflR7aDpwR/HfpPuiZRt+wO7PuSGOUbeSXYN6rwZIABCm0yi24WfubwEUictAcC/TyfT4/3UgxJLIY0dZjAwp5DqBwRyor3IhrcJ5WnU02E9k5vknWileFvBfMwqtmpDz+0dja756nuOnaD0epXIEoIs9KVL1gO2zRcCSFAuJ8+onHGrwF0HrQCspjmqbbrVjAiOMn6kRoep+u8GI6fn9HJN7h2fYcSg4ZX0tzbs9oxcJyXG8XLvrb1qKBGPklMU7SM1W3ODD6dQQnfqDQazM+E7QtPSEA7eqVW7b42dZBopejWK4PbLMGEd0hBeyMmZdZOFvgtDLwbUzIVWEGxX7QG1nwuvtvV7Ju1kWX5E1yBCoz7tp6Te7bgXpGZSJc2E/G+mrTbLwl0ElFrpGgZ1YYKzB9tLQrhMYuatOUKYXLoMeDNXGUQrTjR8qJ6J5AKYgNGjwe2xH0c1X/DG8hVi3MRGU6SVcXULQtx3CSra6cfz4AgylaVFg0RikCaaAuRK0YE0mFHKipnad1JL5mq2AJH7xEsRZmKsd/LvJFIvfurttC02WzA29sjOzB91K2wMgykKQpf2fwH0lTs+L3cjsaliLtkKi880F/UmAZSQUqolyHcpChcPgYkzEHGxIEV1PAVRbPIhQEcYL3M1YYL4ysiEp9KPdaDPAOIAMzg71kO/MOnLsOhv4Zc4h6Hs7kcbCYsIX0OPeiU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(1076003)(4326008)(8676002)(2906002)(6506007)(66946007)(83380400001)(2616005)(956004)(66556008)(966005)(6486002)(26005)(6512007)(8936002)(66476007)(5660300002)(6666004)(36756003)(6916009)(52116002)(86362001)(44832011)(316002)(508600001)(186003)(30864003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CorfYVT1XHvtc5BsHXple1ia5hBQqbdbN2miZWsS96QlMk9LKYWXNnS22jmn?=
 =?us-ascii?Q?p7t7v70Zf5U9zZKndyNeCHbtRyORxOuWaeAgCLPiFcGLlGqU44pnKyjHj6AE?=
 =?us-ascii?Q?HCwcNwzy/ZIMcxl30YcV3lPahTUcuDoEseVbSZAG7py7d/DUAhMlgDZUkSm+?=
 =?us-ascii?Q?Gg9gI5hgkNnxLqDHDuQz9/3CuZPbDhEOh/X+VuhMxTaPeQzus9jiXyhCwNaj?=
 =?us-ascii?Q?5ZCYL6RtXz2n033VK8fBCzKeAI68o9CIjZrrCc8QbkGJVOIzyXtmJ4C2ACmK?=
 =?us-ascii?Q?LRCAMPdIb/h2NEk6FH01n7t7oKp0hFOFqhIYXaF5jN5UvdGWGv2tMrr2DXib?=
 =?us-ascii?Q?WKLRM0NSAtZrVxEoGWhhn3FpvaltGgR8HZ5DtUxOmR2f0gVZGObXpMVoB9gF?=
 =?us-ascii?Q?ThQCNTjHGC/StYYSU5ZxLKQ7bp+WPhwE7hwglHjNx3mzI0HCI8oOt5v3A9zg?=
 =?us-ascii?Q?QoGHw+80pxCtwsfm+UnGCQJ3gif/Ip1taivTfewUI4g0ctyF1MQJ0SsMBqwc?=
 =?us-ascii?Q?sBy4jfFxecWaySe3/x21oqc+IagIO5BNkVvzV9K6wB/HdBbgb9sOX27qvXc7?=
 =?us-ascii?Q?G4plT6Gwwt7d1wZQQMHSQnXS3txvB3Z1fQEcHjna0MhEDJcgx1nbvTDR4hIu?=
 =?us-ascii?Q?IMOy2AKw4bHbnSxoQYEIF1AEH0O44ao6QqRMedGlEiMtUF6vIiMGqatoh0i2?=
 =?us-ascii?Q?CVeq1rNZi6PtKIPcLUgpywyr7HC/lOn0GkEdx43APuBv6k55nVrCII6ibhQS?=
 =?us-ascii?Q?vz4f2s/Grr7oh7A/DUCsbaGcE/Zh1knptJmk4Om0Wad2N3pqOLYTM54R4wBD?=
 =?us-ascii?Q?g15au/5bCJXB0lrZAU1KSMP9TvHs5UMiWrFPrUBKqdgjTOBF3+VvQbtrURGo?=
 =?us-ascii?Q?V5efhXtt3IPAk/5XjvuN8q97tY3+B78+Lj93go7E6+cO30VxyG3jR4GXR/QV?=
 =?us-ascii?Q?lI8DAnP8QX+Ss0PtGmmJoTLahWG1Mv472ldhqchuG7RQ7yMpiJt2PdNb5LXH?=
 =?us-ascii?Q?MckWDL/TDDtZ7/SSpFm8p869hoGYenjSqo1BkEkcTdPRNcpfj4stmpcteEed?=
 =?us-ascii?Q?ZFKZ7a6HJeXlQYFnPOEguIrnSwOePySaTmkamU+Ko6/KaahBRfxl8QnDcb38?=
 =?us-ascii?Q?DyLz3EL/NyiUk49r82ipSBK6hAxT+sJpzSBT+oMqyquftjiDrHpqo6e9Uuae?=
 =?us-ascii?Q?iOSCrW1aBlTStIe2Pb4EeWL8uBhfPCrV37XwJxfUYmqV1iN+SSlz5oIlFxhR?=
 =?us-ascii?Q?fqNsNQADJf78N+NQlDMcZvgKOdrmHzykFb1+h4g0oDpA07HaHRqt0nWyd84y?=
 =?us-ascii?Q?FqdW2cBoPAX2T/K6DcY1MQlu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e142508a-3b3b-4c1f-cb46-08d9732742e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 00:17:51.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56k4SjjVunV/ay3ZT1wA3VCfWtXr3m1CUlB+IBIQFGQLTO0QXpdTtHPHvvlAbkMMIqeqRB58WYiEohSWi1TTbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA driver-facing API for PTP timestamping relies on the assumption
that two-step TX timestamps are provided by the hardware in an
out-of-band manner, typically by raising an interrupt and making that
timestamp available inside some sort of FIFO which is to be accessed
over SPI/MDIO/etc.

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

The problem is that DSA's code structure and strict isolation between
the tagging protocol driver and the switch driver breaks the natural
code organization.

When the tagging protocol driver receives a packet which is classified
as a metadata packet containing timestamps, it passes those timestamps
one by one to the switch driver, which then proceeds to compare them
based on the recorded timestamp ID that was generated in .port_txtstamp.

The communication between the tagging protocol and the switch driver is
done through a method exported by the switch driver, sja1110_process_meta_tstamp.
To satisfy build requirements, we force a dependency to build the
tagging protocol driver as a module when the switch driver is a module.

The problem is that it turns out DSA tagging protocols really must not
depend on the switch driver, because this creates a circular dependency
at insmod time, and the switch driver will effectively not load when the
tagging protocol driver is missing.

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

