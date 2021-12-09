Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B810546F782
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhLIXix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:53 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234462AbhLIXiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ml+RznUflhMC5420t68c24q+XgpfpH9WZEgXogpyq1RGZkaB0uY2OypqEQZW1IZspdYme+EvTiyiPeao/QChLD4gLRb27a2GAQcbtrbp40OfUDwJgmPmRoo3wziWHTJDkxrr8DdBETGq78QdWAF+N787R9udSqYHTcSJp4qb2SLiGUXoHO1+pRxI4FEYb/PHgM4gzV+mLgDIpcwI/JelNNd4ZOtOA+ACIjsaN4Im/h2pVTcOUwH4Jx7KzQkjsxS227Ac1mEmIZmLOvLXaM2VkpATwnDF1X9oilWRgGw6LdwtN6wgi5D2Eec+R9wDorq7U2aTA7yc/1zBhjuswX6eVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGbxio12ZlLdwtqN796Huivx9ZlSTNAZjFViORNQTuw=;
 b=NXSYTnpT11U7vASCaUtkWZewfDAvU3M63P9NIxh8Z5AEagIfIcK5OyK/o6qrh1SgOV9oZfT0PV/8HSJHsfknv8jVvuRXL9tgzO4aayOT2Zw2u5+D46UY6EyDAlrhBAvgBvzR1McBu0KGUswFnsYBg+gIrjLsDU2TrMp7I562beTxl1skgKGMYNyuIsSAJ/1iP5fogtM0+5BbBE/AJozSuSMoPWy0k+f5tBCa2eunMyHARpQwcOWGLu0eUboS2yMQOmmKWyrskAmTKCQ0akximrAlRRG09vOMs0MoqbXMJTdysYxZbOXxY0nQMBEfhZQJ6I/V138Sazv6TANXJUTKFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGbxio12ZlLdwtqN796Huivx9ZlSTNAZjFViORNQTuw=;
 b=Sns2gXg/ufkY47c5qVB6eArlb4Gz3d4dq9fNFY7Y7qi/hB5LfdMBS9vawpbEEVoCem0T/0NktgBG/y1QU108sVj+6vQT/SkW09YuiRB4KGd7XWZG/rttf0ZacF5YkKPCK9RrQcOcVvIwrWB65D3uTYeNCk3BYSC1/NIlHWkYeJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:12 +0000
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
Subject: [PATCH v2 net-next 04/11] net: dsa: sja1105: bring deferred xmit implementation in line with ocelot-8021q
Date:   Fri, 10 Dec 2021 01:34:40 +0200
Message-Id: <20211209233447.336331-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b926b552-2bb1-4d35-9b22-08d9bb6c8bd1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408248B894583B419517BEAE0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rOXaWuGE8KZC3r3aAamww9mgH6vTTU1vYwQ7WSgup6GjF63yII1LwgjXCrwTr3XXnZcbrvfzOLwVHCKSCJaQ4yScfV2iDHxQ0V3maiQ3+NUkTZM8OPLBGpL9yFj9k63EhMYMHWrMwBd06c4IKiaEfUmv4YpPyFe9K1OPgWEbGZuIgWCuOx5y4Iofc8kgtDPi5DAie4vjlOylRMhYy5Ja+7UQHdoG/PzHAiOrIfzW3SDCRS65jDc9BB+NQqpJy4U6FKfuxyBYUnSTPRaPmL5ikwD5RZgluLaXh4DRX+mM82ZVOtZlY4AxQcEjBxPpd+R8IniCn4H6j5HZdU745WOqXD5jLVblZeXcWv3t7HCvjK/JMgkIRSqxIimd60CYMxQ36qQyNEbCYMj5pkdV8nTBwzQNtOcyhV61a3eryq8ZrV4md/hFyXMguEZe/hrYKZneCjSA0e1CtpHTx/P+DVjdmyQ8C11Zhj2F2IfRHg9ZwpwxMt7mEjG4lmsP4lbQtN9K1V9C2JX5rSPPyVl/AvYgAnN+hjgOQGy6LiY6eqIYzOxQi6VILGTtBcU8c/RVwRQB83wA8XHzwVBbWY68djHX9PU34hjRLUrdaoqp2ELaGSO1b9z+R4KeqygG0guwZWYTAmdpsHtlDFNHEhF83VIEv4LgR94oDCIfWE02ktGl4bV/WyMlrAF34k4+D5GNlpH7/SVJoOmhYmykLJnwx06A/K5bfeTMNHf12AVmKqhtyk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2vmrQMN7zekgYJs3X13u0Gq2IdtyXnptN8BueEW9sTdnDGsLRQzLGjulRLj?=
 =?us-ascii?Q?M3+EZUHNAqsYUQzR5jtPtlQhH3WJt9SuzYcIrqLjCD8QKfgSZ7HfVPDoHI3c?=
 =?us-ascii?Q?09pYpvVUj5et0DAcLWwXJBaRTYnHvCX9bsd40RhX4Rx+ObPZQBJewT/Jchtv?=
 =?us-ascii?Q?4m8rSv+JRq9Wy5V0JKaQBhpkOwDZqhuR40amYgMFmvDxPqSqR4T0FczM/6k9?=
 =?us-ascii?Q?cC4O5P4d65I8g5vdketkst6h2VM1bKtkV0qU5KlbSkSmZmpwoy5aKw2CQxfR?=
 =?us-ascii?Q?gpZys5iCSKMItvJMGt5OA0mWSVzdubbBAIrowBS/fb/lp2XsIT8RtSxvEgIx?=
 =?us-ascii?Q?lI/UbDhEGXx4HD+iXIi9WkyckCYWRhKIQle0HVJWL3RKl5hCuLsFXEY8ymJH?=
 =?us-ascii?Q?o5uIvXKz0zjaF1HRJJ2HWAwJAOydO3C9YMEfyS2OB1RZPBVUIFgWNxIbo1YU?=
 =?us-ascii?Q?OwZTo6v7KdIMuTiE8rhcw8glUor9QtFYmSVQIW2YMxJxuCCGuss/tPSlyNUV?=
 =?us-ascii?Q?YoqKpOzGKdHZas4H/s/7siycbOoQfLy/VpYMFc1R1r/7nq+ve6kPdgZ4QUn0?=
 =?us-ascii?Q?oK0I2r7EocOh32QB6pNp7kG9k35knBvu8fex9V60hcVeCLwIZwhYF6iRWiYl?=
 =?us-ascii?Q?BmbH3836v/kSeJzNSNw0INf0zeBbI8WF3NdjUcSgTy7YXz3YCa3hj8At9ILU?=
 =?us-ascii?Q?oQ5bqYNVBAaYIaG1knzxtnfQxsE2MXMndpmycB1AB3Jpi6JCcxDru702P2Wt?=
 =?us-ascii?Q?d24Xpffjt0AIRFUudtIxJ3MI+1hqUnqKHpolSHHQkmyuDBzwq52A8Q9AMOqT?=
 =?us-ascii?Q?xvZdjQHklf9lSEK/xxYyCx9q4FLFAhB58JsQi3lkeRCg1v/t4jwIBqFY4q9n?=
 =?us-ascii?Q?fDe9gUsO6Pk0aDjUj0B+7/ujqd+DusYQafbrpajfDu3/g23FeMFRF7+zxGh7?=
 =?us-ascii?Q?roHksnAF1whVfyYra1KBrmurTn+O/Mgm+HugIzyIXceHdqebWuSmF6TxYRw6?=
 =?us-ascii?Q?FfA7oE4b7EsX2/+WOGQweWDVwst52LmnI/y9iclpryrQRPciaOuu22kDWuj+?=
 =?us-ascii?Q?GExlOM5qI7B48PnOFlWDO9FbWSbvaCWEtCGG6P3Wb7as0aAZ5lsE8LOeoy7q?=
 =?us-ascii?Q?rbbt/GcLb7CPFOTs7PwsYW3MM5qJsG8+gdIEWXWsQbTYtWpWJm+2FLeIc41T?=
 =?us-ascii?Q?PXCTsC74iZihcG6WRCQ3hZwIqVkdsPclVipT+thxob51OsgTl1RYsYoxUfRR?=
 =?us-ascii?Q?FpY6aJVsdMpSzT//5cO84Cp82OQGw/FW2SlcSfwkD2pXDxswx4MVWBCn6s2W?=
 =?us-ascii?Q?lgNiy8tguz7+ucADyLKOO5gst49AYPoHk6XzUoroXlBil43N3oVyt/IFLgRg?=
 =?us-ascii?Q?PyppHhE0ZeyyEgK/N2VwP2HA8KdgcGFB/CHY3N+sDs2OIvIqKZhcP9ENNjap?=
 =?us-ascii?Q?Q9OfhvAvQKXyafyiLvJEDRCVF4AABtY84PhkSsYdpPwWyg0yH8ylio6NytTv?=
 =?us-ascii?Q?4tIv6856An7rVgQ54irkvMaFnqzZHLtrA7Szx8QVdcEP1sBbtz/3ggcRGqTK?=
 =?us-ascii?Q?yDAgZ5LfXp7t3xfJzP+a+JRHEiAqBcW73JBBtLxNG4Giupy6eUOhyiB6bRLk?=
 =?us-ascii?Q?HNVQzPv81aVIL4uO2tUAUM0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b926b552-2bb1-4d35-9b22-08d9bb6c8bd1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:12.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgiNbTnwaY1nBRlrpRUJVyJ8xEEmbkeANPV+5D2aHqwDcBj/3LHIDRKSiWbEaGHkvMeIEv9WPW6c3n2fSC1Lww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ocelot-8021q driver was converted to deferred xmit as part of
commit 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during
init and teardown"), the deferred implementation was deliberately made
subtly different from what sja1105 has.

The implementation differences lied on the following observations:

- There might be a race between these two lines in tag_sja1105.c:

       skb_queue_tail(&sp->xmit_queue, skb_get(skb));
       kthread_queue_work(sp->xmit_worker, &sp->xmit_work);

  and the skb dequeue logic in sja1105_port_deferred_xmit(). For
  example, the xmit_work might be already queued, however the work item
  has just finished walking through the skb queue. Because we don't
  check the return code from kthread_queue_work, we don't do anything if
  the work item is already queued.

  However, nobody will take that skb and send it, at least until the
  next timestampable skb is sent. This creates additional (and
  avoidable) TX timestamping latency.

  To close that race, what the ocelot-8021q driver does is it doesn't
  keep a single work item per port, and a skb timestamping queue, but
  rather dynamically allocates a work item per packet.

- It is also unnecessary to have more than one kthread that does the
  work. So delete the per-port kthread allocations and replace them with
  a single kthread which is global to the switch.

This change brings the two implementations in line by applying those
observations to the sja1105 driver as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 77 +++++++++++---------------
 include/linux/dsa/sja1105.h            | 11 +++-
 net/dsa/tag_sja1105.c                  | 21 +++++--
 3 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f7c88da377e4..c21822bb6834 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2675,10 +2675,8 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	return NETDEV_TX_OK;
 }
 
-#define work_to_port(work) \
-		container_of((work), struct sja1105_port, xmit_work)
-#define tagger_to_sja1105(t) \
-		container_of((t), struct sja1105_private, tagger_data)
+#define work_to_xmit_work(w) \
+		container_of((w), struct sja1105_deferred_xmit_work, work)
 
 /* Deferred work is unfortunately necessary because setting up the management
  * route cannot be done from atomit context (SPI transfer takes a sleepable
@@ -2686,25 +2684,25 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
  */
 static void sja1105_port_deferred_xmit(struct kthread_work *work)
 {
-	struct sja1105_port *sp = work_to_port(work);
-	struct sja1105_tagger_data *tagger_data = sp->data;
-	struct sja1105_private *priv = tagger_to_sja1105(tagger_data);
-	int port = sp - priv->ports;
-	struct sk_buff *skb;
+	struct sja1105_deferred_xmit_work *xmit_work = work_to_xmit_work(work);
+	struct sk_buff *clone, *skb = xmit_work->skb;
+	struct dsa_switch *ds = xmit_work->dp->ds;
+	struct sja1105_private *priv = ds->priv;
+	int port = xmit_work->dp->index;
 
-	while ((skb = skb_dequeue(&sp->xmit_queue)) != NULL) {
-		struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
+	clone = SJA1105_SKB_CB(skb)->clone;
 
-		mutex_lock(&priv->mgmt_lock);
+	mutex_lock(&priv->mgmt_lock);
 
-		sja1105_mgmt_xmit(priv->ds, port, 0, skb, !!clone);
+	sja1105_mgmt_xmit(ds, port, 0, skb, !!clone);
 
-		/* The clone, if there, was made by dsa_skb_tx_timestamp */
-		if (clone)
-			sja1105_ptp_txtstamp_skb(priv->ds, port, clone);
+	/* The clone, if there, was made by dsa_skb_tx_timestamp */
+	if (clone)
+		sja1105_ptp_txtstamp_skb(ds, port, clone);
 
-		mutex_unlock(&priv->mgmt_lock);
-	}
+	mutex_unlock(&priv->mgmt_lock);
+
+	kfree(xmit_work);
 }
 
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
@@ -3009,54 +3007,43 @@ static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static void sja1105_teardown_ports(struct sja1105_private *priv)
 {
-	struct dsa_switch *ds = priv->ds;
-	int port;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
+	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 
-		if (sp->xmit_worker)
-			kthread_destroy_worker(sp->xmit_worker);
-	}
+	kthread_destroy_worker(tagger_data->xmit_worker);
 }
 
 static int sja1105_setup_ports(struct sja1105_private *priv)
 {
 	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct dsa_switch *ds = priv->ds;
-	int port, rc;
+	struct kthread_worker *worker;
+	int port;
+
+	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
+				       ds->index);
+	if (IS_ERR(worker)) {
+		dev_err(ds->dev,
+			"failed to create deferred xmit thread: %pe\n",
+			worker);
+		return PTR_ERR(worker);
+	}
+
+	tagger_data->xmit_worker = worker;
+	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
 
 	/* Connections between dsa_port and sja1105_port */
 	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
-		struct kthread_worker *worker;
-		struct net_device *slave;
 
 		if (!dsa_port_is_user(dp))
 			continue;
 
 		dp->priv = sp;
 		sp->data = tagger_data;
-		slave = dp->slave;
-		kthread_init_work(&sp->xmit_work, sja1105_port_deferred_xmit);
-		worker = kthread_create_worker(0, "%s_xmit", slave->name);
-		if (IS_ERR(worker)) {
-			rc = PTR_ERR(worker);
-			dev_err(ds->dev,
-				"failed to create deferred xmit thread: %d\n",
-				rc);
-			goto out_destroy_workers;
-		}
-		sp->xmit_worker = worker;
-		skb_queue_head_init(&sp->xmit_queue);
 	}
 
 	return 0;
-
-out_destroy_workers:
-	sja1105_teardown_ports(priv);
-	return rc;
 }
 
 /* The programming model for the SJA1105 switch is "all-at-once" via static
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e6c78be40bde..acd9d2afccab 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -37,6 +37,12 @@
 
 #define SJA1105_HWTS_RX_EN			0
 
+struct sja1105_deferred_xmit_work {
+	struct dsa_port *dp;
+	struct sk_buff *skb;
+	struct kthread_work work;
+};
+
 /* Global tagger data: each struct sja1105_port has a reference to
  * the structure defined in struct sja1105_private.
  */
@@ -52,6 +58,8 @@ struct sja1105_tagger_data {
 	 * 2-step TX timestamps
 	 */
 	struct sk_buff_head skb_txtstamp_queue;
+	struct kthread_worker *xmit_worker;
+	void (*xmit_work_fn)(struct kthread_work *work);
 };
 
 struct sja1105_skb_cb {
@@ -65,9 +73,6 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)((skb)->cb))
 
 struct sja1105_port {
-	struct kthread_worker *xmit_worker;
-	struct kthread_work xmit_work;
-	struct sk_buff_head xmit_queue;
 	struct sja1105_tagger_data *data;
 	bool hwts_tx_en;
 };
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 6c293c2a3008..7008952b6c1d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -125,16 +125,29 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
+	void (*xmit_work_fn)(struct kthread_work *work);
+	struct sja1105_deferred_xmit_work *xmit_work;
 	struct sja1105_port *sp = dp->priv;
+	struct kthread_worker *xmit_worker;
 
-	if (!dsa_port_is_sja1105(dp))
-		return skb;
+	xmit_work_fn = sp->data->xmit_work_fn;
+	xmit_worker = sp->data->xmit_worker;
+
+	if (!xmit_work_fn || !xmit_worker)
+		return NULL;
 
+	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
+	if (!xmit_work)
+		return NULL;
+
+	kthread_init_work(&xmit_work->work, xmit_work_fn);
 	/* Increase refcount so the kfree_skb in dsa_slave_xmit
 	 * won't really free the packet.
 	 */
-	skb_queue_tail(&sp->xmit_queue, skb_get(skb));
-	kthread_queue_work(sp->xmit_worker, &sp->xmit_work);
+	xmit_work->dp = dp;
+	xmit_work->skb = skb_get(skb);
+
+	kthread_queue_work(xmit_worker, &xmit_work->work);
 
 	return NULL;
 }
-- 
2.25.1

