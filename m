Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE146F784
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhLIXiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:55 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234459AbhLIXiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaHw3wLQmPRbjMdYOkyzeYHZDiEtL6/Zu985I8eUplBh9YW8LfWLUx8kY3AMc6pT9jfrb5Ma5B+JPSGO3JV+/qzaBjpFMM2UsxuqGtwAAf3cjwS6kxL+jUWywyyBUOxxC3OCOInoHrtqmgvvqPccC9EXo2eoN06yidfVTFB38rPlKvY+U8y9vqPvPSvV9YvUnoIzRri4YkFbzUzmVXcOmPfdkFRO40ZHF1iiAFdFDIonT2P93GPudPExAVGtq9XUy7ss2FcYz5R6s8lyKRlM1XEF66ZNch63XY368YbC4kOwSxfxRMWUufggAbRFsd3eLhDdYu1XoTWCehKzXxnHMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45XojtBvlfg7jcmqNiKqT3bBgoYoLrJ3u4vFJhJJ1Ks=;
 b=EaSVJ3n2niXTLWcmGBM3iC7o3/c5NiXoyQ60XGuWDYMLz5rkTHOO7QT8hCKoGjEX5oNqbnNaXfdKu24rxuF7dlflardKeOwLxoghrFhU06mj/nPbu871LAtQzGuO2q+yVHVI8TuLqWP8jOISxRM00o/wUKkF+9IZG2QHqMsM/y7sP74PMhBt5NXq/GxP9ujKp7Jl0OivUS7fOSzaArzL/W03haohfEEUO7JkwxZS194CX+4RCslFho1cDCJXC/rwhm+71X7QjxcEI7ujwV4IFaxotcfCSRqR2mF3J3nnK9whliRL19TGbHKtCSGlrIZN8VQYY0e4/l+2IbNkDLg3IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45XojtBvlfg7jcmqNiKqT3bBgoYoLrJ3u4vFJhJJ1Ks=;
 b=JVFNCtONLBIvWI793G5qPKlAnWBK3+MBMwKQIqWN9EBK6M0rGKiZ63fXIDtkc1xi/oiJR3BzS9BJDziGOK/S/NH68qrQaZ8c8LlmiateM4L+ofW/UuPj2+q2IcA3WvIucGQ3aXk1zRijo50K3xucmiQ1IZp1KNFIgvmEQlcCSTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:15 +0000
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
Subject: [PATCH v2 net-next 06/11] net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
Date:   Fri, 10 Dec 2021 01:34:42 +0200
Message-Id: <20211209233447.336331-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 345321ce-fed0-4d93-e5a3-08d9bb6c8d47
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408362940BF108427048F75E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIEqBM5FCKcku28gv7q9oarBPylsn8tyUrJdkbcqRHHN7cvSLE1ajgLmgE9VIctw50lNLw8rNWYoCJcZs5pt3WxagP43fpQA5aatvAlkjpTCOb4uVDuPS6YZpA4HdvRCwXlTJgecfN44wTNnZoSIOxJPpBMGVd5ImdZv+OZ2nMr2jHXeYdXdyzmbWMwSKLAnfWJuA9vT43yzeU8hJe5mwDkyNR4fwqj3Dn+zvoa4Hx6Msqk+bfp/QnFWMpYGsXgIj1tNxvdRw5pXveY1adS0k5/+tz/cSocFRsONmkVI1ie2+dVEaGZXueHRQa/rTSbZu9YEqZNyO1ZcKEuEeEBvDOGdE9YMPxqp8HiFV473JZYFsha66ElLXv/w7rBPdgFUGQDhba5wsJQbczFBWu+Yj1wzOmogLsEybIUneJ4fhpOQ8VbsbnoRpPY1dASuRqMCmQ4pZjesBty0K0y0hOmJUUrh/UqEfBvd5VBrZ6Yg6wVmGfsYZrco0DlXMjqc27OBpkBBxhDARXHlfIIvvgWeyybKNejR8A+P542ghD3hso3KzfJZSyvfK1zLz7rOnUAEFjmWk0Rdsn5ERzK+9Xf3P8v7dAHlriQWAE9jgTT00fI336hhgLvNWX+wY32eAsSeS7BNWv5sXVfPR1vs7+PN7qo1wnbCBSuczjUPdZU9h/h94Cb8N2PUCxFiEfKiXujqYGhAevKRiac1gHl8IOpEsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kq3WBsEpYLHy/0tAG7yXQ4xH/8nq0Gi94KWM6p3UgXNJ6QA7dKaWtCDwhovz?=
 =?us-ascii?Q?pGyAbQgCQJbWfaa0BCQBp7pTn4tNezjfacX1MB4I2TeMAsorOI1jboEnzitc?=
 =?us-ascii?Q?rPwMuRbk0SVWA3XrUHpE1qHVmsRab73skuBGLJfN1PmE+4VpM2BULW3xRyF1?=
 =?us-ascii?Q?/2dCpTcyMf3wT2SN2VuAnojYZPbVyI9pV19uS3ixWAhkdGJqy0CSL5qAsrDw?=
 =?us-ascii?Q?RHQ53SvYU/p2vs3+YEcaRb7neHsAixVUcCCgh4n6e42+UKcrIYd9n7DzpOGZ?=
 =?us-ascii?Q?4ukaKDPkdGCR2ocZdjl3rSUrAZDZYj37r4/Hz9IcN0WWQOoaX8k5r8F2vf18?=
 =?us-ascii?Q?LHbuh0cEPmJSvAiA/nGZTEAdxsK6poKlr2JACby30f9YV9bDd5BFP+du1D7i?=
 =?us-ascii?Q?atycjGXpmBKapYfWL86AtJ++SgFCQ4za313dbpgVMSvUkr+7n5tCEtzzVjMw?=
 =?us-ascii?Q?BS0/lYKMtzUxCAqwrala72g2icqvKRaKla5tDh0sgmY8SKoZxusmpNDRaKwD?=
 =?us-ascii?Q?3FBB3aqr+MpHHtMPi8Y08HyT7VIwVPTFbESf5q6RztPKpfObvC4N+Ajpsxsd?=
 =?us-ascii?Q?eNQrgOXvZtEEx9S+Hg/j1lncuZo9L4xdAWdTsDz3nIwAwmwJxV0WgZSWnIWe?=
 =?us-ascii?Q?nAwXf4mD6dILbOczwvt0KH+XviirTepk1u8nhXzd+C4MVdUnJm6NrO8N8j8c?=
 =?us-ascii?Q?9lrt+Icvwh8EDkOxol1+6ermhFfNFUfcDTa5zKzt1d/Sww4+pKidnW/Wqr25?=
 =?us-ascii?Q?12RDsyaU5OcDb5NyiChzLbwgVEkKMfUun3eyfb1OcDrFXN5ivmHg38tNZ9IL?=
 =?us-ascii?Q?APk4UB5HislCi3jCO57L9AcXBhcONT/nrVUwooz7fFAs3qlrBk8cZ2q4NVrH?=
 =?us-ascii?Q?M/IxyUhpGMmMRUExMyXkbtBsg4UjpvFWdJuCvfcYWv1x9Femw4xUzJg2gowU?=
 =?us-ascii?Q?WD0TQVpMtw3tLi+LGLCkFHfI4ne00rzhenVNVuQMBlI5Y9LKqTokn/1yP/Gq?=
 =?us-ascii?Q?hXO2JKwXjOI04Cep3ymxJFCUXgEm0NsiYZ7rjqdVZqdUq3OvXauimHOnhqsP?=
 =?us-ascii?Q?LiKNd/r6Z+imgHGGszAxKcBeh9d55DwoBzcYXf1TkFONseP3xKhMZE7FHrTm?=
 =?us-ascii?Q?qBBYQuIqht97QK26wdC6m8Nz8rJvGPSSiDQBIGR+RIarwYxG742JtA6vSti/?=
 =?us-ascii?Q?Aej+/ahVpRUATygSYyTMsz6u9icwwDAUD54uFx1pmmssZPtLzxr5xHb15LiO?=
 =?us-ascii?Q?G3YXXlO3SktSJdfRbZBFr7fujepGH8YAKeZoz6aFxtscyfmbTnroj5I0irl8?=
 =?us-ascii?Q?v79v8d8bwxzZgiw30ovQ4vAPLTMAnQB+hKNgsAiV23g9CmgcajB30la67Y5Z?=
 =?us-ascii?Q?vPD1j05xuDoaSjiFVRo0UljIxhyqic1aTfiNyVZf2HgHyYzKzOcowyFg4uA/?=
 =?us-ascii?Q?MtlivZQb+dq6Zijs+b2/gJZXypNb7f0XdL3g2NDdmCOuTxDgv80gvvy5G3Y0?=
 =?us-ascii?Q?qwEvpv+ZtOXRjzVO2GCQoDwhBktPwgZxSUzcg0qvw4Vimkx3OucLuQsqHz3K?=
 =?us-ascii?Q?GYsAmqgJsj2r8wVoX411c1R09vaUx+V/BiFOFl8asVNd1HwgmCF+Z2G8n39V?=
 =?us-ascii?Q?KiX+3v2EO314QooOejUY494=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345321ce-fed0-4d93-e5a3-08d9bb6c8d47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:15.2984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waPy1dckqjjzdiiLYM7BnEORKO7jwPB7xfw3JXtMN1y/YvyjMqq5QfdydYiVhTqJmnWLwj2aBH5MAJRy4H0xTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The design of the sja1105 tagger dp->priv is that each port has a
separate struct sja1105_port, and the sp->data pointer points to a
common struct sja1105_tagger_data.

We have removed all per-port members accessible by the tagger, and now
only struct sja1105_tagger_data remains. Make dp->priv point directly to
this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 15 ++------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 14 ++++----
 include/linux/dsa/sja1105.h            |  8 +----
 net/dsa/tag_sja1105.c                  | 48 ++++++++++++++------------
 5 files changed, 37 insertions(+), 49 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index b0612c763ec0..6ef6fb4f30e6 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -257,7 +257,6 @@ struct sja1105_private {
 	u16 bridge_pvid[SJA1105_MAX_NUM_PORTS];
 	u16 tag_8021q_pvid[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_flow_block flow_block;
-	struct sja1105_port ports[SJA1105_MAX_NUM_PORTS];
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c21822bb6834..e7a6cc7f681c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3017,7 +3017,7 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct dsa_switch *ds = priv->ds;
 	struct kthread_worker *worker;
-	int port;
+	struct dsa_port *dp;
 
 	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
 				       ds->index);
@@ -3031,17 +3031,8 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 	tagger_data->xmit_worker = worker;
 	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
 
-	/* Connections between dsa_port and sja1105_port */
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-		struct dsa_port *dp = dsa_to_port(ds, port);
-
-		if (!dsa_port_is_user(dp))
-			continue;
-
-		dp->priv = sp;
-		sp->data = tagger_data;
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		dp->priv = tagger_data;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index b97bd4d948f5..9077067328c2 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -461,22 +461,24 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
+	struct sja1105_tagger_data *tagger_data;
 	u8 ts_id;
 
+	tagger_data = &priv->tagger_data;
+
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-	spin_lock(&sp->data->meta_lock);
+	spin_lock(&tagger_data->meta_lock);
 
-	ts_id = sp->data->ts_id;
+	ts_id = tagger_data->ts_id;
 	/* Deal automatically with 8-bit wraparound */
-	sp->data->ts_id++;
+	tagger_data->ts_id++;
 
 	SJA1105_SKB_CB(clone)->ts_id = ts_id;
 
-	spin_unlock(&sp->data->meta_lock);
+	spin_unlock(&tagger_data->meta_lock);
 
-	skb_queue_tail(&sp->data->skb_txtstamp_queue, clone);
+	skb_queue_tail(&tagger_data->skb_txtstamp_queue, clone);
 }
 
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 32a8a1344cf6..1dda9cce85d9 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -43,9 +43,7 @@ struct sja1105_deferred_xmit_work {
 	struct kthread_work work;
 };
 
-/* Global tagger data: each struct sja1105_port has a reference to
- * the structure defined in struct sja1105_private.
- */
+/* Global tagger data */
 struct sja1105_tagger_data {
 	struct sk_buff *stampable_skb;
 	/* Protects concurrent access to the meta state machine
@@ -72,10 +70,6 @@ struct sja1105_skb_cb {
 #define SJA1105_SKB_CB(skb) \
 	((struct sja1105_skb_cb *)((skb)->cb))
 
-struct sja1105_port {
-	struct sja1105_tagger_data *data;
-};
-
 /* Timestamps are in units of 8 ns clock ticks (equivalent to
  * a fixed 125 MHz clock).
  */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 7008952b6c1d..fc2af71b965c 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -125,13 +125,13 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = dp->priv;
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
-	struct sja1105_port *sp = dp->priv;
 	struct kthread_worker *xmit_worker;
 
-	xmit_work_fn = sp->data->xmit_work_fn;
-	xmit_worker = sp->data->xmit_worker;
+	xmit_work_fn = tagger_data->xmit_work_fn;
+	xmit_worker = tagger_data->xmit_worker;
 
 	if (!xmit_work_fn || !xmit_worker)
 		return NULL;
@@ -368,32 +368,32 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_port *sp = dp->priv;
+		struct sja1105_tagger_data *tagger_data = dp->priv;
 
 		if (unlikely(!dsa_port_is_sja1105(dp)))
 			return skb;
 
-		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			/* Do normal processing. */
 			return skb;
 
-		spin_lock(&sp->data->meta_lock);
+		spin_lock(&tagger_data->meta_lock);
 		/* Was this a link-local frame instead of the meta
 		 * that we were expecting?
 		 */
-		if (sp->data->stampable_skb) {
+		if (tagger_data->stampable_skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
-			kfree_skb(sp->data->stampable_skb);
+			kfree_skb(tagger_data->stampable_skb);
 		}
 
 		/* Hold a reference to avoid dsa_switch_rcv
 		 * from freeing the skb.
 		 */
-		sp->data->stampable_skb = skb_get(skb);
-		spin_unlock(&sp->data->meta_lock);
+		tagger_data->stampable_skb = skb_get(skb);
+		spin_unlock(&tagger_data->meta_lock);
 
 		/* Tell DSA we got nothing */
 		return NULL;
@@ -406,7 +406,7 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_port *sp = dp->priv;
+		struct sja1105_tagger_data *tagger_data = dp->priv;
 		struct sk_buff *stampable_skb;
 
 		if (unlikely(!dsa_port_is_sja1105(dp)))
@@ -415,13 +415,13 @@ static struct sk_buff
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
 		 */
-		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
+		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			return NULL;
 
-		spin_lock(&sp->data->meta_lock);
+		spin_lock(&tagger_data->meta_lock);
 
-		stampable_skb = sp->data->stampable_skb;
-		sp->data->stampable_skb = NULL;
+		stampable_skb = tagger_data->stampable_skb;
+		tagger_data->stampable_skb = NULL;
 
 		/* Was this a meta frame instead of the link-local
 		 * that we were expecting?
@@ -429,14 +429,14 @@ static struct sk_buff
 		if (!stampable_skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Unexpected meta frame\n");
-			spin_unlock(&sp->data->meta_lock);
+			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Meta frame on wrong port\n");
-			spin_unlock(&sp->data->meta_lock);
+			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
@@ -447,7 +447,7 @@ static struct sk_buff
 		skb = stampable_skb;
 		sja1105_transfer_meta(skb, meta);
 
-		spin_unlock(&sp->data->meta_lock);
+		spin_unlock(&tagger_data->meta_lock);
 	}
 
 	return skb;
@@ -545,8 +545,8 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 {
 	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct sja1105_tagger_data *tagger_data;
 	struct skb_shared_hwtstamps shwt = {0};
-	struct sja1105_port *sp = dp->priv;
 
 	if (!dsa_port_is_sja1105(dp))
 		return;
@@ -555,19 +555,21 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 	if (dir == SJA1110_META_TSTAMP_RX)
 		return;
 
-	spin_lock(&sp->data->skb_txtstamp_queue.lock);
+	tagger_data = dp->priv;
 
-	skb_queue_walk_safe(&sp->data->skb_txtstamp_queue, skb, skb_tmp) {
+	spin_lock(&tagger_data->skb_txtstamp_queue.lock);
+
+	skb_queue_walk_safe(&tagger_data->skb_txtstamp_queue, skb, skb_tmp) {
 		if (SJA1105_SKB_CB(skb)->ts_id != ts_id)
 			continue;
 
-		__skb_unlink(skb, &sp->data->skb_txtstamp_queue);
+		__skb_unlink(skb, &tagger_data->skb_txtstamp_queue);
 		skb_match = skb;
 
 		break;
 	}
 
-	spin_unlock(&sp->data->skb_txtstamp_queue.lock);
+	spin_unlock(&tagger_data->skb_txtstamp_queue.lock);
 
 	if (WARN_ON(!skb_match))
 		return;
-- 
2.25.1

