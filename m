Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D8F46DCAD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbhLHUJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:44 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:55236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240000AbhLHUJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ffm7rrnjWoWoHNVqxuRZU21bRFqlSY0V683TkSpfGf492QDP/GnUuO5nl+EPp855o66k3Hw5QT//Nx2xJlIBzUNQLLUfjL5Ud2CITNAR8YOFlveKe2CvobDqQw/pSVLVxL7FU1h4cpxyIv5nIZsapfaZCEa4urRMgsYHg6wYuKVROc/YOpdYAp12JanOBaxS2Yj244ZcDir7Xg5EQDYpvhJoer2KBs88NDUIp/eGWJyPw0LCby6K4CU9Vp/0LLVyr7+43jbauZKvI9XvMg//bx0dUQjEUi9hhqTNASToxVxm+Vppe4pU9Fs5mLTmZzbtbUdOvIlFgTBBVNPTUoEM1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yuEahf/A+t0d8GZJgDXHa3l9yAe4s1JOGaqWAf4G/A=;
 b=EKubc0yFv7WPgA8qJIHqI37WuIdr5/TGe35oxeC/9Tnj0myzG6UF3DJpbyWra6uGZBtRaM8F+vGbjLGBMAu9oWROFasM0rf3EvBLrIbx4pDGYqHBoZxP3+GCqnpR3YSFV0Lr+vP5eZAAyqsJgoxjBaIbpoZlwpsMezI235jgLwh389BDFpxVBK/StLTCtuZFt3QQFpATsvF26ysgo+9JnBhl2vwDVHveQQspeIujYwQ3Azylx9VdSv8zUaqlae2nJ9P5/IMjRfFKoumyX652U4byLRZf0+QPTLbMEtU4cilyFR+P9r0S5mNg7XtsUrI9NDj53gKPKiQYELz8+IhjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yuEahf/A+t0d8GZJgDXHa3l9yAe4s1JOGaqWAf4G/A=;
 b=GX2myaMBVJUWq9k5pA1/40W4c/Wy5MXAYo/HkfDwwNOQN4MzTGbKAc0QnR5ZMZFJ5sWQeCJZ+dc8PWQ3tZ+FlRAt8L2ZKn/+cit25MKebM5GqVlLOddEslcIoWDHRTiQe8L6bPN1Ad57s0cvBBG+CxYy5En3vfIOKEZrooDlQdE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 20:05:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:58 +0000
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
Subject: [PATCH net-next 10/11] net: dsa: tag_sja1105: split sja1105_tagger_data into private and public sections
Date:   Wed,  8 Dec 2021 22:05:03 +0200
Message-Id: <20211208200504.3136642-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9585cc12-5279-4d97-0b3a-08d9ba86263e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4223:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB42232688FF4E255A3D159B63E06F9@VI1PR04MB4223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCxKBLHtSyk5+TT32n/urCSV7OJwzaWv9xg1g/Ar6mAbsA6P1eIZis+n41alvTJrfpp/Lyrv365UDC0lgBibDzuqMoN29s3BbFf1NgMRWIkwBgvOCxFQRWgFNBfiUX/lGtbf7K5N1FXkt31TNfTuc8gGkhT47+NULbaYoSzgtn0d5HqVfK9Hl0n0Ak/4cmCiW5oblGGQ+8Ogrb6FabA4Fgv5F/44DkA9zMj05WWCVKO7o608UWXQZx7cZI4ZV58XmDLpycKQPQ+QGl1M+kE+wwmnDA4BeDD7JEQEC9R0uhSlrG/EnxxhKCefpiC7V4VLf5i8eirMdqQrNuppU2VoqdYdOxivp5UgHAubbsvop/BBly9DqA3KB67opUyRV7wNpIH3Z62wwoBdSFdH1o1Abm4iHe6/YkWdGR+eqV05irIMLwq3ATsARCXRqrVlAcKcH9LRZkeZ5vq+pjqh0/thb5N1ineRoNpAXMSpZZs4tmHGM8vacIWZ438cEUz40K3XWQDDDngkFfkXLD9LPgyj7GQUaVZHT7B0R282WC3mKhe1IeZkjU7U1g4U1VqRI08SF7gEWvKkV6UzmuK1iZd5NIEoGSga+9AS7rcNpedazziYFItr+i88I6WWnPBeXg2Lk0WkkRc77MRzT5JvaFr4CGJRIl6glbKw2jygLabFmoZ3dc/DuwlZfx32JgJZ12b2Qn1+a+JoGXJBEJFdIbpY4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(6506007)(66946007)(86362001)(52116002)(66476007)(66556008)(26005)(186003)(6512007)(8676002)(4326008)(2616005)(44832011)(956004)(508600001)(8936002)(6916009)(316002)(54906003)(1076003)(5660300002)(30864003)(6666004)(83380400001)(7416002)(38350700002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dKMtPlFv+vvjar5ZVzeZ0QVEKB6w1HUUSwGa/0r703vz85kP1WK0dCtKsn1q?=
 =?us-ascii?Q?/goUXjYjZweoXKweLTggXOGrpZQgtK4iC/nLzkwICQrijD/7oDkQAxCZ6nyB?=
 =?us-ascii?Q?kq3Bp95j2iBiXCAhPv+kYu+SBQMMXoTEVxkdC6k0OqZHFj8uHqC582t9WPLt?=
 =?us-ascii?Q?UmQ43m9r7+AsjhJtewcXuYJj3oKBxKzuf0G3Wy/WvKjmhUI3TbLn85ftSEkG?=
 =?us-ascii?Q?vL3qca5gPnwGnJHXz/tWX+CJMOt3ZHlhsZafzEjwVkdq5R0WkO/7a5UR7XBX?=
 =?us-ascii?Q?q3IbILVDLFXCCRfO1tFWntJJ3ek0ZPJfd0l3RCfoowzYBY8KO2YFxKQqqUDW?=
 =?us-ascii?Q?3RCRzSjvOMTlO3QF1edc6fb9NjUfWGWZBReACp4LYKGQxXIKTm/HGJDMKv18?=
 =?us-ascii?Q?744NbkV+ofHs2sFcGkj4hY1zk9kkJCTj3w2DkzJOvIpOXN/G4V4SIV+HNzbj?=
 =?us-ascii?Q?KvxxBpqUdQkq/EpiRB/o6wjtEmLWNkkgjCTM+hyiccOlzpLYERg/r+/NGB1Y?=
 =?us-ascii?Q?H2oslQcTSx2eCbM5hf10nH+dwmmRtTcGTWF+jvWGjQDLnU8jGxsSjoQzr6vB?=
 =?us-ascii?Q?u2VSc8g4E4jfpZzNg6JHcgNfren0EZWIvq2xj59LNOh1zawgD2xf/69B6qsy?=
 =?us-ascii?Q?HRDig/xU7KcwJTlr4BD+5o6PjxwKYabpim+wceyEg3msjd9/2u49EQvshYGZ?=
 =?us-ascii?Q?MgYuz3RnhuzU8YLnXr69KWN+27xeEfNW4PeMPgDHVzOHurHZxXDlyOSpU47c?=
 =?us-ascii?Q?l/gd1qHy1aPVjrb7N0OIr3OXY3Q4qe97AL4koYk1FhKEomDY8RZheXuVEu49?=
 =?us-ascii?Q?cd3UTyqgD8KqEsAO2ZFOp/I8b1CcEfdB3bEy1KtXZEiN8BEnIXAOMGedyh9c?=
 =?us-ascii?Q?9ozgtou+OYBaZ0TrXWTW6PUkgutvodG0X926gwdKVxEU7vPW0zd0LhtlFbQx?=
 =?us-ascii?Q?IXtUwTO7KBr2tTVRlCRhlpoYF8dEtwD9V9t1TZ8vuifymT049rhN4rtZGWRz?=
 =?us-ascii?Q?rBtPZ13N1rlnRno1lFLsR9YXxDSxweTW8O7kzu+YHvrKP7gk4O4ft+GTO35Y?=
 =?us-ascii?Q?6SJSIdlFDzANWW0RVID7Z0mOIpYJpg9cyBYXUrPCt97l0iSBI+yxcTVpQLjP?=
 =?us-ascii?Q?6EzozNW4+/nxJd+YDO6aZHnQFxS9M0ZcSlYbBahmWY0FGRhzU9me0J2l/58h?=
 =?us-ascii?Q?eAmq4IFk0emGzbpoD6wpP3/b+aLw65y0JQFMI9JXNi94rLsyd9T+liTywH28?=
 =?us-ascii?Q?nvgE/Fw97L/OBNkvJuytOL9BIbzmEVaQdD/gjhOP1pTyWV3reHAvPx92nj+h?=
 =?us-ascii?Q?a8uKJniE3k1CCETy1CudHz1AvtCdzY5YbqE8Qn2XpChS8SCSw4jABUSqiyDy?=
 =?us-ascii?Q?/Zb0qsZkBnLUYYCfDVELbFqlRn7tpLsK7xnmZqmgxv28AJ0uufugI5VoR+wO?=
 =?us-ascii?Q?TnnjDo/R0AAO3WWbO8QhGhMtPwp4XDo1SwGAm5AostU3BIROJOExbNs8K39h?=
 =?us-ascii?Q?WAa056b87rE5DzUp58TKgcqo95GkFqKYBiyHyzQZvb9nX2mUag0rMQmQFPNO?=
 =?us-ascii?Q?msPjCcfkqd+6Qe8+rD+qfhXo1lur8oWvSAypl53I6IvJZy4BGX6+bhDjvAIK?=
 =?us-ascii?Q?8N15A8sCiwPiJ3fR4P+0zs8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9585cc12-5279-4d97-0b3a-08d9ba86263e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:58.0870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PmtfmtWoUgmk/qosR6h7wjO4d5tlcv7FSe6mj0nS77yfMndmvbwwQxKGWoGlegp8iKNiKBbWaliIqCns/flbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver messes with the tagging protocol's state when PTP RX
timestamping is enabled/disabled. This is fundamentally necessary
because the tagger needs to know what to do when it receives a PTP
packet. If RX timestamping is enabled, then a metadata follow-up frame
is expected, and this holds the (partial) timestamp. So the tagger plays
hide-and-seek with the network stack until it also gets the metadata
frame, and then presents a single packet, the timestamped PTP packet.
But when RX timestamping isn't enabled, there is no metadata frame
expected, so the hide-and-seek game must be turned off and the packet
must be delivered right away to the network stack.

Considering this, we create a pseudo isolation by devising two tagger
methods callable by the switch: one to get the RX timestamping state,
and one to set it. Since we can't export symbols between the tagger and
the switch driver, these methods are exposed through function pointers.

After this change, the public portion of the sja1105_tagger_data
contains only function pointers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c |  22 ++----
 include/linux/dsa/sja1105.h           |  13 +--
 net/dsa/tag_sja1105.c                 | 109 +++++++++++++++++++-------
 3 files changed, 91 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a9f7e4ae0bb2..be3068a935af 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -58,11 +58,10 @@ enum sja1105_ptp_clk_mode {
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-/* Must be called only with the tagger_data->state bit
- * SJA1105_HWTS_RX_EN cleared
+/* Must be called only while the RX timestamping state of the tagger
+ * is turned off
  */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
-				      struct sja1105_tagger_data *tagger_data,
 				      bool on)
 {
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
@@ -74,11 +73,6 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 	general_params->send_meta1 = on;
 	general_params->send_meta0 = on;
 
-	/* Initialize the meta state machine to a known state */
-	if (tagger_data->stampable_skb) {
-		kfree_skb(tagger_data->stampable_skb);
-		tagger_data->stampable_skb = NULL;
-	}
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&ptp_data->skb_txtstamp_queue);
 	skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
@@ -117,17 +111,17 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		break;
 	}
 
-	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state)) {
-		clear_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
+	if (rx_on != tagger_data->rxtstamp_get_state(ds)) {
+		tagger_data->rxtstamp_set_state(ds, false);
 
-		rc = sja1105_change_rxtstamping(priv, tagger_data, rx_on);
+		rc = sja1105_change_rxtstamping(priv, rx_on);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
 			return rc;
 		}
 		if (rx_on)
-			set_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
+			tagger_data->rxtstamp_set_state(ds, true);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -146,7 +140,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+	if (tagger_data->rxtstamp_get_state(ds))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -423,7 +417,7 @@ bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+	if (!tagger_data->rxtstamp_get_state(ds))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index d216211b64f8..e9cb1ae6d742 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -35,8 +35,6 @@
 #define SJA1105_META_SMAC			0x222222222222ull
 #define SJA1105_META_DMAC			0x0180C200000Eull
 
-#define SJA1105_HWTS_RX_EN			0
-
 enum sja1110_meta_tstamp {
 	SJA1110_META_TSTAMP_TX = 0,
 	SJA1110_META_TSTAMP_RX = 1,
@@ -50,16 +48,13 @@ struct sja1105_deferred_xmit_work {
 
 /* Global tagger data */
 struct sja1105_tagger_data {
-	struct sk_buff *stampable_skb;
-	/* Protects concurrent access to the meta state machine
-	 * from taggers running on multiple ports on SMP systems
-	 */
-	spinlock_t meta_lock;
-	unsigned long state;
-	struct kthread_worker *xmit_worker;
+	/* Tagger to switch */
 	void (*xmit_work_fn)(struct kthread_work *work);
 	void (*meta_tstamp_handler)(struct dsa_switch *ds, int port, u8 ts_id,
 				    enum sja1110_meta_tstamp dir, u64 tstamp);
+	/* Switch to tagger */
+	bool (*rxtstamp_get_state)(struct dsa_switch *ds);
+	void (*rxtstamp_set_state)(struct dsa_switch *ds, bool on);
 };
 
 struct sja1105_skb_cb {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index fe6a6d95bb26..93d2484b2480 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -53,6 +53,25 @@
 #define SJA1110_TX_TRAILER_LEN			4
 #define SJA1110_MAX_PADDING_LEN			15
 
+#define SJA1105_HWTS_RX_EN			0
+
+struct sja1105_tagger_private {
+	struct sja1105_tagger_data data; /* Must be first */
+	unsigned long state;
+	/* Protects concurrent access to the meta state machine
+	 * from taggers running on multiple ports on SMP systems
+	 */
+	spinlock_t meta_lock;
+	struct sk_buff *stampable_skb;
+	struct kthread_worker *xmit_worker;
+};
+
+static struct sja1105_tagger_private *
+sja1105_tagger_private(struct dsa_switch *ds)
+{
+	return ds->tagger_data;
+}
+
 /* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
 static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 {
@@ -120,12 +139,13 @@ static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
 	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(dp->ds);
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(dp->ds);
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
 	struct kthread_worker *xmit_worker;
 
 	xmit_work_fn = tagger_data->xmit_work_fn;
-	xmit_worker = tagger_data->xmit_worker;
+	xmit_worker = priv->xmit_worker;
 
 	if (!xmit_work_fn || !xmit_worker)
 		return NULL;
@@ -362,32 +382,32 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data;
+		struct sja1105_tagger_private *priv;
 		struct dsa_switch *ds = dp->ds;
 
-		tagger_data = sja1105_tagger_data(ds);
+		priv = sja1105_tagger_private(ds);
 
-		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &priv->state))
 			/* Do normal processing. */
 			return skb;
 
-		spin_lock(&tagger_data->meta_lock);
+		spin_lock(&priv->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
 		 */
-		if (tagger_data->stampable_skb) {
+		if (priv->stampable_skb) {
 			dev_err_ratelimited(ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
-			kfree_skb(tagger_data->stampable_skb);
+			kfree_skb(priv->stampable_skb);
 		}
 
 		/* Hold a reference to avoid dsa_switch_rcv
 		 * from freeing the skb.
 		 */
-		tagger_data->stampable_skb = skb_get(skb);
-		spin_unlock(&tagger_data->meta_lock);
+		priv->stampable_skb = skb_get(skb);
+		spin_unlock(&priv->meta_lock);
 
 		/* Tell DSA we got nothing */
 		return NULL;
@@ -400,22 +420,22 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data;
+		struct sja1105_tagger_private *priv;
 		struct dsa_switch *ds = dp->ds;
 		struct sk_buff *stampable_skb;
 
-		tagger_data = sja1105_tagger_data(ds);
+		priv = sja1105_tagger_private(ds);
 
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
 		 */
-		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &priv->state))
 			return NULL;
 
-		spin_lock(&tagger_data->meta_lock);
+		spin_lock(&priv->meta_lock);
 
-		stampable_skb = tagger_data->stampable_skb;
-		tagger_data->stampable_skb = NULL;
+		stampable_skb = priv->stampable_skb;
+		priv->stampable_skb = NULL;
 
 		/* Was this a meta frame instead of the link-local
 		 * that we were expecting?
@@ -423,14 +443,14 @@ static struct sk_buff
 		if (!stampable_skb) {
 			dev_err_ratelimited(ds->dev,
 					    "Unexpected meta frame\n");
-			spin_unlock(&tagger_data->meta_lock);
+			spin_unlock(&priv->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
 			dev_err_ratelimited(ds->dev,
 					    "Meta frame on wrong port\n");
-			spin_unlock(&tagger_data->meta_lock);
+			spin_unlock(&priv->meta_lock);
 			return NULL;
 		}
 
@@ -441,12 +461,36 @@ static struct sk_buff
 		skb = stampable_skb;
 		sja1105_transfer_meta(skb, meta);
 
-		spin_unlock(&tagger_data->meta_lock);
+		spin_unlock(&priv->meta_lock);
 	}
 
 	return skb;
 }
 
+static bool sja1105_rxtstamp_get_state(struct dsa_switch *ds)
+{
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(ds);
+
+	return test_bit(SJA1105_HWTS_RX_EN, &priv->state);
+}
+
+static void sja1105_rxtstamp_set_state(struct dsa_switch *ds, bool on)
+{
+	struct sja1105_tagger_private *priv = sja1105_tagger_private(ds);
+
+	if (on)
+		set_bit(SJA1105_HWTS_RX_EN, &priv->state);
+	else
+		clear_bit(SJA1105_HWTS_RX_EN, &priv->state);
+
+	/* Initialize the meta state machine to a known state */
+	if (!priv->stampable_skb)
+		return;
+
+	kfree_skb(priv->stampable_skb);
+	priv->stampable_skb = NULL;
+}
+
 static bool sja1105_skb_has_tag_8021q(const struct sk_buff *skb)
 {
 	u16 tpid = ntohs(eth_hdr(skb)->h_proto);
@@ -699,26 +743,27 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 
 static void sja1105_disconnect(struct dsa_switch_tree *dst)
 {
-	struct sja1105_tagger_data *tagger_data;
+	struct sja1105_tagger_private *priv;
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		tagger_data = dp->ds->tagger_data;
+		priv = dp->ds->tagger_data;
 
-		if (!tagger_data)
+		if (!priv)
 			continue;
 
-		if (tagger_data->xmit_worker)
-			kthread_destroy_worker(tagger_data->xmit_worker);
+		if (priv->xmit_worker)
+			kthread_destroy_worker(priv->xmit_worker);
 
-		kfree(tagger_data);
-		dp->ds->tagger_data = NULL;
+		kfree(priv);
+		dp->ds->priv = NULL;
 	}
 }
 
 static int sja1105_connect(struct dsa_switch_tree *dst)
 {
 	struct sja1105_tagger_data *tagger_data;
+	struct sja1105_tagger_private *priv;
 	struct kthread_worker *xmit_worker;
 	struct dsa_port *dp;
 	int err;
@@ -727,13 +772,13 @@ static int sja1105_connect(struct dsa_switch_tree *dst)
 		if (dp->ds->tagger_data)
 			continue;
 
-		tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
-		if (!tagger_data) {
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		spin_lock_init(&tagger_data->meta_lock);
+		spin_lock_init(&priv->meta_lock);
 
 		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
 						    dst->index, dp->ds->index);
@@ -742,8 +787,12 @@ static int sja1105_connect(struct dsa_switch_tree *dst)
 			goto out;
 		}
 
-		tagger_data->xmit_worker = xmit_worker;
-		dp->ds->tagger_data = tagger_data;
+		priv->xmit_worker = xmit_worker;
+		/* Export functions for switch driver use */
+		tagger_data = &priv->data;
+		tagger_data->rxtstamp_get_state = sja1105_rxtstamp_get_state;
+		tagger_data->rxtstamp_set_state = sja1105_rxtstamp_set_state;
+		dp->ds->tagger_data = priv;
 	}
 
 	return 0;
-- 
2.25.1

