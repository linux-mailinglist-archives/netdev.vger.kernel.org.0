Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3961A275716
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIWLYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 07:24:46 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:23932
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgIWLYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 07:24:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgMJK7/K7ni+/aaKzJ0UH+8JSHuSSGTqQBcnK1UU3zoXykNGnXzcPfbjDaNJbSP5IzAYlqKImOZisAsP8dRRXcTEo8z5ffl9B18CHRVGeemBPcishe0wG5HrQmvpnohAav1V9VHvTg6DnW+JiyhJ/ntPH7iOyzOaLNJEnAohNXdHFdcdAut9pO/qx1C6lRoXkj74rnJHxe9/BHzS4lYTbcOzl9Zz8OLmw4JGbuPuEYyYz7cPjAPIYMXkt91lih7BtacCx7q8mSizHce4FEeOq3kmWAF+a65JfXXcaxYmjEjV6RXASS0yi4MX0qhyIabwUdRC+aO9L4hlB5H9ajTvGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VmjchkMAj7z0dNgUHIkv+jCjhgp4DuRxhFJL8KqXrw=;
 b=R/YhMqC84wYijsj87q10IQOM8dOFcsL6Vm0+1XsExfoTypW9w5HXvYY8eKh9UuieVoQatPCHPGUaM+Tge4U1NH8nCoQIQDHpZG6qk2ivVOPFCcxkhW6+1wsu/65dPrdORPohr1fS48zD2zxrEOYhnr7Aku68jS4kQ6eOiqXQiWyuAwpRAVipkJnMpkEekUuky3TWCQhZvQBgUE0ujy/W48v+KWLqz9gVMvH3A0zo5aGCo0pEpQG3O3uNo4hH9bNx18i48I3iO1rNYqdIW1gLzhzaqV2FhRcfGWLsjXYe5xTRSTKattjQuIIirDaBtdr71PZTfg7EUIKfBsGF2jUbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VmjchkMAj7z0dNgUHIkv+jCjhgp4DuRxhFJL8KqXrw=;
 b=D+xZBijsIWi5evNfVSsI9VtxrYUB9JOsgb/djYT5zPbxvfZs6R4B3Rx0BSQSqgtM2RTMcg1xXpM4aXkphDMM2YRnN0v0nGQLLileUFU2zMhhIXichCqH4pwf2E6z97kAVyxsafm0yTj+B8sdZmqoxPJokkEgwAi/CvGUZkdoUtk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 23 Sep
 2020 11:24:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 11:24:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net-next] net: mscc: ocelot: always pass skb clone to ocelot_port_add_txtstamp_skb
Date:   Wed, 23 Sep 2020 14:24:20 +0300
Message-Id: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR05CA0074.eurprd05.prod.outlook.com (2603:10a6:208:136::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.26 via Frontend Transport; Wed, 23 Sep 2020 11:24:38 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf12058f-dabb-481c-cc6b-08d85fb342bb
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941867D891147A7F25596DFE0380@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIBF6tlDJ1843+ICdP9BVRmJ+x2sm7ndV84tglMcAo3EJfMVnjXJ4UcqYripOnFZWLTLh0ZIgmEhrkEV84Vg+83Bp1HDa67LmSLywNFrLVgcmzwk15IAXA13wd58oZZ1fhiGRVKBqSiqJzNziT+g90nyvKEs/wocEj5W/koPivF5ICSOB/cfNh5iZSqP50mMB1ReHEnhn5ZXzgIAqFwHOXzFU5/csdtHoVVMLZVm+ZPsYgEs9Lguym+cIvW7vnBHp4CFFcn18Sjnc5HRMOb5V4JliwGUofmJF+8pzCE4IoIxxLGvaFZPmbhuSwNXmvbhtgn57mDgby0sWkJjJbU8gY9Zccw3FwFkEQMMokjA/rlctAx1McZs/GfxZIA2V8/J95W6zfrIjRt8l8sClEtwLFjB3TtekoNyVONpX8/tqy+Lnen4hi25l5Sxf7F7oUQu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39850400004)(136003)(376002)(366004)(6486002)(36756003)(83380400001)(6512007)(52116002)(8936002)(2906002)(5660300002)(1076003)(8676002)(66556008)(66476007)(478600001)(6666004)(186003)(6506007)(956004)(2616005)(69590400008)(44832011)(86362001)(16526019)(316002)(4326008)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KtSe4gB7u8CojQZkzGDwW1KEesoRjoGwV5OrqGbFXD5+5RgNu9vGAZoPzBI9QExnY/whK3NlRh64MyCnxtdAu10vX36THnw4DZdqURkAXd8h95cE/mCGJ4LJRL694IVKhQ42JAZYgPtuCPDJY1uEbABCqpryLkXYPbl+OXlvW2Ue0VtCPjQh+ZUHwQCB1bhKqSuWJ2R4npw1bM7aD9zkN3cmL6SgtijawkF9+bd96MKv5C3smC0GZlIHzw5eM/aMBvTlGQpsnhyNjNqcG68GPUtHOIPk4eQcCiQfJgztI7PwzlbkWEpB97xAW3umMYDrmlY3WeCP3QHahua135iO1CpmT+bDTXTsk5qKw5lGpiSgGouZxjOqgyLcKaHKRu8v0Z5cbf+YMiIGcaFaMwgdI4hqe4g/Mbv4/yg7yg8AmxrA1In4GF6ha7GJJIx6s+WWxZnCDpQ/IdLmRHcAtH+USkNmw3/hBO/S+azM0/y2L8wHZJG8GYm35+qYxKWlPTxGBy9H8Gsqw3D7cluqCnW0AQhNfAGkEZ2+kawICDFUpARrk2RPhCOOMVbzLGh/3MKIPM+1CqRrjkf8gUTf+OzRp8gNfAldQ7QKGJivIu797s9zUM3HEl2pk5b1yNiqXGH8lzsmTwAZWBaPkUyXtRyYEg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf12058f-dabb-481c-cc6b-08d85fb342bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 11:24:39.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ritDRR42YHWz5zj4oq0owFoOJctv7K4yCrH3YlrzqGevdIKaDardU519HpvHaLa7f9otPg3KPWvvaAHyokbkaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ocelot switchdev passes the skb directly to the function that
enqueues it to the list of skb's awaiting a TX timestamp. Whereas the
felix DSA driver first clones the skb, then passes the clone to this
queue.

This matters because in the case of felix, the common IRQ handler, which
is ocelot_get_txtstamp(), currently clones the clone, and frees the
original clone. This is useless and can be simplified by using
skb_complete_tx_timestamp() instead of skb_tstamp_tx().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  5 ++++-
 drivers/net/ethernet/mscc/ocelot.c     | 30 ++++++++++----------------
 drivers/net/ethernet/mscc/ocelot_net.c | 22 +++++++++++++++----
 include/soc/mscc/ocelot.h              |  4 ++--
 net/dsa/tag_ocelot.c                   |  6 +++---
 5 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0b2bb8d7325c..1ec4fea5a546 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -668,8 +668,11 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	if (!ocelot_port_add_txtstamp_skb(ocelot_port, clone))
+	if (ocelot->ptp && (skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
 		return true;
+	}
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 977d2263cbe1..58b969b85643 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -413,26 +413,20 @@ void ocelot_port_disable(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_port_disable);
 
-int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
-				 struct sk_buff *skb)
+void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+				  struct sk_buff *clone)
 {
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
-	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		spin_lock(&ocelot_port->ts_id_lock);
+	spin_lock(&ocelot_port->ts_id_lock);
 
-		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
-		/* Store timestamp ID in cb[0] of sk_buff */
-		skb->cb[0] = ocelot_port->ts_id;
-		ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
-		skb_queue_tail(&ocelot_port->tx_skbs, skb);
+	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
+	/* Store timestamp ID in cb[0] of sk_buff */
+	clone->cb[0] = ocelot_port->ts_id;
+	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
+	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
-		spin_unlock(&ocelot_port->ts_id_lock);
-		return 0;
-	}
-	return -ENODATA;
+	spin_unlock(&ocelot_port->ts_id_lock);
 }
 EXPORT_SYMBOL(ocelot_port_add_txtstamp_skb);
 
@@ -511,9 +505,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-		skb_tstamp_tx(skb_match, &shhwtstamps);
-
-		dev_kfree_skb_any(skb_match);
+		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
 
 		/* Next ts */
 		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 8490e42e9e2d..028a0150f97d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -330,7 +330,6 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	u8 grp = 0; /* Send everything on CPU group 0 */
 	unsigned int i, count, last;
 	int port = priv->chip_port;
-	bool do_tstamp;
 
 	val = ocelot_read(ocelot, QS_INJ_STATUS);
 	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
@@ -345,7 +344,23 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	info.vid = skb_vlan_tag_get(skb);
 
 	/* Check if timestamping is needed */
-	do_tstamp = (ocelot_port_add_txtstamp_skb(ocelot_port, skb) == 0);
+	if (ocelot->ptp && (shinfo->tx_flags & SKBTX_HW_TSTAMP)) {
+		info.rew_op = ocelot_port->ptp_cmd;
+
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+			struct sk_buff *clone;
+
+			clone = skb_clone_sk(skb);
+			if (!clone) {
+				kfree_skb(skb);
+				return NETDEV_TX_OK;
+			}
+
+			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
+
+			info.rew_op |= clone->cb[0] << 3;
+		}
+	}
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
 		info.rew_op = ocelot_port->ptp_cmd;
@@ -383,8 +398,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
-	if (!do_tstamp)
-		dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 
 	return NETDEV_TX_OK;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index df252c22f985..2ca7ba829c76 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -711,8 +711,8 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
-int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
-				 struct sk_buff *skb);
+void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+				  struct sk_buff *clone);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
 void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
 int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index b4fc05cafaa6..d1a7e224adff 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -137,6 +137,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
 	struct dsa_switch *ds = dp->ds;
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port;
@@ -159,9 +160,8 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	qos_class = skb->priority;
 	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
 
-	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
-
+	/* TX timestamping was requested */
+	if (clone) {
 		rew_op = ocelot_port->ptp_cmd;
 		/* Retrieve timestamp ID populated inside skb->cb[0] of the
 		 * clone by ocelot_port_add_txtstamp_skb
-- 
2.25.1

