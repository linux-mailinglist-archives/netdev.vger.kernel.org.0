Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7590D46DCA9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbhLHUJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:40 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239986AbhLHUJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6965I/lWcvsIKvwfVkCKjYF6HrE9FrrGuekyWkKh6BXIAxNeWF7H2ive3nGyDHERCo2+83wNZSuqiTBgwblXnRLhERgS2bUpJyRaAt19+WvfU4Zzy6qAmVKDqj+N8UDZnr78u1vEjTL9v9ky0YWDkUqvxPUyqsBJVN61nxxIXHkZA/jMNID8J/CyPOF3PtnV/8ZYx0Mbfh93djY19Qwdb83YBzy4cJSD94EBILDogq99acbU+6ih+27ZnFII1vP36orXrFMm8cvWxLWbc8rNRSE3Ci7CCFVwrti+lksR6B/M9L0o37Dho14Q0RfeJbiJYhniCuCxl9WayMfb6wm8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tn8ar9DkveiGJVE8ZRMIH6ECd6ylDIQFSa0UZcwEAOg=;
 b=VZwdG43vnPXFDx75dA1MixPZs/q3B8sokrl7b1FaDb2mrkRkDsq3+EtX6uExEjyRIzCQUtURYoSV2mH9iyRjpgQiZbEG2NsZMlj7CpNjHwWz3Q/PUiEkHHNunW11hD4exTgZAn1PMGa4bthMPxqq9cG78CIOyUNDr1WFpbD8I1rP4rWDuN8Etr++0Jc0thBsNqFnoTon9dqtHXaPo/7IQnKQ6/XvDGN4JB9HTX44djD8Srbp50lU/dP72Dbtkptaqx7vu2+8JBgvGtgSGeH2pjFYT4MG59mTO/BONMSKshbS0m1QYwTDZzO+u5bXgO/p5VhjqrlYeZM/FOn05Kh3DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tn8ar9DkveiGJVE8ZRMIH6ECd6ylDIQFSa0UZcwEAOg=;
 b=MAaCeT0lqTKT+zwGT9YagKP2KowLC4zD5XTfFu0LbKr56nu5PmcB37Y1Jiaenhyn/OGyoH67Bflf/yKWhK41XMJr0OZztimTyUG0eJ+qes0OMKBD8sHNN9PA+wZm+zdtIc9h9Arr70HYduTe/8Owm9HfCc5nAjCOWw/d9fJihno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:50 +0000
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
Subject: [PATCH net-next 04/11] net: dsa: sja1105: bring in line deferred xmit implementation with ocelot-8021q
Date:   Wed,  8 Dec 2021 22:04:57 +0200
Message-Id: <20211208200504.3136642-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97d3f1e2-77f4-4fe0-924a-08d9ba86219f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638CAFFE877F6928AA93434E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmfd/PhqOhdoTc0FvlzPLg698v93hBTY9+dYRO55jGRzRdSg9iASc/8QpnRpi1eRRjH6AyykQT4Ihw66qyUa3V4vr3XkJH7b8jT1tKuSxy2F8PlzISQX+c60ubcrGJsr2LlHFfONx6+P1qwI1je2P8Fdssq2TBlG4qloY8FIgIKHoxcA2SEMPfTOW+H52uKpBYY7WW/rkxVcBhov0p2XDiSv02k4GB1eTuJxTqqz5vpH/KYyrpzQ/48ln++hvhnfUepwblBJKTmciABzWOa4r2tYrc0fZZyKeXqRaOsNzglSF56aasbXd/pU9ckXDmIt7PumlfKM/NuMd5po4+bSQ02CiMdWIjkJ7UhRRLFMsEnbGDm7yoTckd2RTraqOTzT0ZTbCFoDdBeK+fexSav1InBoQOzdZY9qYYFCCPCy9+JSnKo0Zhj6RswXQsurPAb9fybXQGZkrXG/2gL6LmzMMN0QmYO8KKT5ZqGur4aMxP/C1mFEKaEoAITJ1S1q0ePrG13mwoH3kWMTNNZYOLvvtguNXbdSoscscUtxjwbZcfukGFuEyH4eKsmUXORSZbrZAVIAZEFqCsbwEad8BQgMLX+XKajstIk+PfG5rXKy7so6TohrQRtoV3EfHuNAJDntxvGDxA9tCfc880CrRbS1QQmxFK+Gj8iP2lxNTEB/otLN8MKU536sArzqzHltmtqwutd58AiPZacpssGvnFjdgqtTXpue2Pmp5kqxiXldGQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?36zMTkBZ8rdMdTlYyf8iDyAUwH29yW0w8ivjv2TnaH0J+bg7HJCU503aqoTh?=
 =?us-ascii?Q?0o/Ao5JrPHdeTIEh8u8ZYl8yegoyY9mLQUbpHWDMX6VXjAQ0hacNLx9TouAC?=
 =?us-ascii?Q?so2+mD+Pk4TuInNxvcLz577pv/AZ434Ur+2BjdAbSXWWMy9+JEjjsi9ClQmI?=
 =?us-ascii?Q?kpt66qk/dHSzdd1jH0kj3/O3/Hbj6rNGmQoiptx9bn49TiYKLzMeLFxA11Iv?=
 =?us-ascii?Q?zxQnI0FQjsehGP7uOGAL/HWUlszAoOc32O1Cxb+LSHpWX1h+Do3g+zRGo55M?=
 =?us-ascii?Q?jzVfiMg8i2eEgIz7Yjw5tTBe2pOiLV/CU00JWKvW1/SZlDrAtbvVZFqn5cFw?=
 =?us-ascii?Q?kTgInRa4ttiudH93vVs7wIcxVag8JLlxsKcYqOtSyH6AdaghMmSFf2No6oCU?=
 =?us-ascii?Q?QN6FO1CufhN09c2om4Ry0seqW54RdyTQ6UlHOZN6t6GHEM/rY5/J5d6CtJFM?=
 =?us-ascii?Q?lCe6sCiRsOAaZ72Ppi4DOUJ4NKlWEbv4TeZSr0YR5vJBsH6WV1/7NW8TLK79?=
 =?us-ascii?Q?+lPJdQM4o3Rqm3ZQMCGMj1BCUkz/c7DAdeNIYNpS3kXd8LwJnkYVYVjqoqC0?=
 =?us-ascii?Q?58mGllVd6xQAxh7EoqMWiGHkxSE0yMr/lSpknUNy0jPKuPQ8VC1GYk8CCzDN?=
 =?us-ascii?Q?+kF7euPPPvSoGpo3oiTX5qDfqSRYmay5mCrH0cTlX/GfvgZiuECPGZeXtQmv?=
 =?us-ascii?Q?lzCsvoamxf8wqr+0sZhQRAKkf6cVotvS1tk4DnuWMpt/t0DmJczGHFahPhGC?=
 =?us-ascii?Q?/ljZf6F0iaj1/pCpIPi9jGyeQASXT+AfZZdBPFY5UuHmhEY2fvU7lZeBqn34?=
 =?us-ascii?Q?5iiGWQVi+PCuDua5miXt49BrCUV/vFjOuZZ2fiUzhTZJuAA3zMnzn52++Z3g?=
 =?us-ascii?Q?v0o19/gPbTmZ1kO94UDFlXHakjkxtRI4lsOOp/AD0aT3Ed1IoWcD7oJHPoiy?=
 =?us-ascii?Q?XjiHJwxgp009aE/qWr7Kw1dUey35nT1B7M/dBfFahoj1rHyg7DDboHHL4HzB?=
 =?us-ascii?Q?FjF1ooUa8geAfStGQ1S6bla4RW/oOIacIqhtHLW9Gn7ajhowssRLdAkGy5YH?=
 =?us-ascii?Q?IIvyPka44YjWi/91NdMEk79U5GmAK/gmzg/O0vOxLbC7MCrvW9rjIoBX0cKp?=
 =?us-ascii?Q?GqXfbTSS0pmJ6cor6TPXLwdnyEIIdBgZWzuYY4GoUgAdwU+P8qMQoiFXy7b0?=
 =?us-ascii?Q?+LWTKfDHtlIxgVyT7LKGRBEWDKedg/OupwAcogRZlwBtbsxuXF6UHSS5BaCP?=
 =?us-ascii?Q?UjEDQAKMNCqehyyoqBEVb5WyK0YEdBICoXLZuxQXTqOtNlOwF8TpLLtoih/z?=
 =?us-ascii?Q?LPMwls2cYExomjMyDTYC9D9PvtmAz2RTw9xBBXeYsuyhLpOk0ytK5Xwg49aA?=
 =?us-ascii?Q?nJMG11Xm1pqVcQCKSr26CGRmChVOVsj+D9ieqz5fwH7fH95ohEOONHYu1Lq+?=
 =?us-ascii?Q?mM9P+YvDOGnOMBlMIE31gN33vmNXtrq3vYTLpKNJULUiSjRIv4+V9OwahT6A?=
 =?us-ascii?Q?igJGMzShgdygOER2lvAx0fuYddIW0HZS8lkJmoohWzd3f3QFUwZBFrdRQBKK?=
 =?us-ascii?Q?i4yCkwI2XPqvTyhwEqP0m/QX19t4c7zi+o+p0XOtj81Si9t9W6e3/QjsbsY+?=
 =?us-ascii?Q?B8vd17yDOmWeLoWtqz0Auq8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d3f1e2-77f4-4fe0-924a-08d9ba86219f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:50.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgwPq3YUj3fmMfgHk44nUTKWPUDPG2bdXRSYHXGMau9JYpUKqB1dPVj3XvBdieEZ1m8Vzminlh962kpNCedR5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
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
 drivers/net/dsa/sja1105/sja1105_main.c | 75 +++++++++++---------------
 include/linux/dsa/sja1105.h            | 11 ++--
 net/dsa/tag_sja1105.c                  | 21 ++++++--
 3 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f7c88da377e4..5c486bd2bc61 100644
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
+	struct kthread_worker *worker;
 	int port, rc;
 
+	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
+				       ds->index);
+	if (IS_ERR(worker)) {
+		dev_err(ds->dev,
+			"failed to create deferred xmit thread: %d\n",
+			rc);
+		return PTR_ERR(worker);
+	}
+
+	tagger_data->xmit_worker = worker;
+	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
+
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

