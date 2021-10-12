Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8828B42A374
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhJLLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:07 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232665AbhJLLnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tord5SSzxFzsynFnBOdNetESeBSQ+ivexnpETAzHyyt8mLOpqNwfSBib/M5RjYGfHA0u+gPhGRJaDxmY48EHgMe+d2icly/vEUKnQ9k9iUDVad2FiRfdRxEoNDOz9ANsOogZDdL/+2XJ1lREFrDIbnWgnF84S9hfCju//kS+2Kl+oayddz8pxl2Fjue387jlDkVSYrJGSjPiquYy8reUqq2VpuK26haD0cayUpcQwdyn8JpmNPQDP1J3zuHhrxGtD3hsRiVVuRfsBkU4+Lz+ol8OZKLmD2BuGRGfrW+xNNgknALiYMSPzaMaKN+Ny9+zG76YiMn4bq+cYHl91aIuCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=355mXyMt74F9tc1tiAXN0iK2IZy/ITiAeFKTuTb5Wxc=;
 b=eUYGPLfADRNB+8YdENUCFlBZ6xlhkZ5EIifU6X9FC6pfQ7dMmGHspUjIB/hGltLth2plcSRph0fdfySJMoD4XMds6BtTMh4X9lucY/mjx4hF4YJk5m6F36E3hzvSMALWQicA5WQfq8MIpAxU8rW0NLyv62sxGv6AnqYO+fj8NK8D0HDEIRjWssPUErO0q3SUJAUp9HUfh4IVNIg1zw6zAE6frbVzml0SB81N0F4n8E/mAUxCzLAwG26HkkPPjoERe8sEgn72ztNi4I204Q1JzHKNagMrER+NaqANniWVC16H3K3n/HtXGSL4i7P+BZVCVtLlY/D9zsOFwozahyw4lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=355mXyMt74F9tc1tiAXN0iK2IZy/ITiAeFKTuTb5Wxc=;
 b=BXYucOoSp8plSQSEqGZXq6jL25UdRLP1uugZkAA4cTa4q+xGsXDW8JaLq5uWQ/dYGLrEImL5mafQWkAyNpOWLlxq0xcrV7ok8RoSH0XhLzUBZ3GcGrK9h0kTgNM8ZGaWMEVyguuYMdn6sFkXRzVK3kQgw98ZldHYZNug60BegOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:40:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:40:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 02/10] net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
Date:   Tue, 12 Oct 2021 14:40:36 +0300
Message-Id: <20211012114044.2526146-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10292f23-1f02-4f90-004a-08d98d7527c0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37099A92EDE22DDC255A3874E0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5xOUuHXTTDBcO825hFOlA5Z+thAxeSon2tdLR0D+EMvwhVmCyAQunF7z9+Wc/4ekv6YQjuxY1gkF1BRMNnZOX4oRosqvM2tsOFWkHRCDnApCpTvWiieNUfNDo4nnVWyAwtaYtUC0yk8WwMj/6fV0inXtFxGszzwtHmJ3CEMjQ/eRopTi56g5WGoYkacgTVG9ltzri1AccsCcE/PZU9fk2IDv78c0jSL8EGI/uBTwaQhMOy1KONK7hXZZdf4ZyJWIuYiWxod7B9d/c16We2teWGFPLONX1Wa7zcKsVf4X1Z8ydblCMVthWkpIhoJ56N6QqIDPOirInnyd/qWdYQEtPwK6j4ziTpTwT3O6sttUXx+Dbpco+0SCTAowdsKKdsXe88r0HNa6QXY/nlbHVf4sottC6hkTFm7pkvu14fkK6wECzlcuuUIFjwduRM3QNaqG+jXldyU3KMcVqnOPeBpbQ+/leLrm1RZOmVTxygcM4PdHaJ6VEpYBZiwIlFtDV0UTAKutjkstF3nUEB8VEPRlRAWoN8ayMhKyYGW3klUlECNKHFiTxthHrsQxeLAgJvEWU5F6vfbr23UfnTdcJi2bre0MRsk73bm2l51snzGiCE/AWglXFJoa9FzjOvvufHg8unHoUChiaPCht/rs0WM5AMFe3NFTwUj26ED2BdbjhhyLDN1It2+JPIc0skmqPXW/xYZgwC75UntF2UWJwt6LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sc6CvjE84h2I6vT/1GnBdqMZK5uhq7wFlBcQSQYpSYoauvZ9N8FX8/MrM4uA?=
 =?us-ascii?Q?y8j4GhN0tisW4Gt0welgGrHNnW7WzBX3ItAR+flYgoQd5xu4Ejmcq1I8699J?=
 =?us-ascii?Q?eDI+3q+vs9ey5G/vPACc5Mo1N2o/kNwjJOWl+x1FEEEi6RqIMqhJEk/FlcZZ?=
 =?us-ascii?Q?DFXc3OCXLFBgvcIGtNVPOgzQfHl9kPb+faBehaTEJeNuzostzze0B4zxS3W6?=
 =?us-ascii?Q?Dztekyi/rz3QWF4TaGvJVuaLwprQ3Nn9yw4fYx7/SnalvmDOXlJiigNRlWXL?=
 =?us-ascii?Q?jSDw476eM5JT4FRcXa5jpCRzXWa/SR4eQd720G1qrj8XKRdmTZF/6NXb3tJ3?=
 =?us-ascii?Q?q0Yprtgj350dLeuAZG2TREYbYhGvuxPEP9CFwbBf7bHK8zR/H2fxxBUE+4aF?=
 =?us-ascii?Q?SMuZxMYCnjk4PJmNTkBHrN0/0+rGm5ZvIP5okRl0wEqfx0whnTAX3k2eBdsP?=
 =?us-ascii?Q?b+4PIStwstKmjX8R1c/FbvrwlwmnerXALITNTB8dveQQsjY4lbdfW5cE/WY8?=
 =?us-ascii?Q?0fmKnYydawXr/g4t5NsCmIU3oDA+39umPGw0r7gA0mdEGQ+ao0Evr5GJXScT?=
 =?us-ascii?Q?UgtvI2h5KzBszEguWZqdSDrZWHH3g5QXKK4lZIGIGQjka9wbmndOLJe1kv7d?=
 =?us-ascii?Q?bs3OChMmoNur9QG79u8+MU07x+jlQa87SOTDq7gHUcIFUygqNtVyWdg63M40?=
 =?us-ascii?Q?QJ41IjNHY9ABDhFJ2fLW1Hicnc9YMTnk3ThzZ+t5cHTwrUz7rytIaMs2Fc4h?=
 =?us-ascii?Q?+86Z2lboUH4Bch6rPx6b+/9jzpmtmYWN7G8MgdlB3gy23SiBMnkLA32ZEYXc?=
 =?us-ascii?Q?MaZc/ocfdH/NNI3x1aofYCs/4wjsKnHuBeGrqb/mxOsvGlCem/4QovRGWSA4?=
 =?us-ascii?Q?653p5TxjM6i/brx7bVP1pcMdOzxQACNcb95qbOUZttH3oSQceE5+h2mTM6T3?=
 =?us-ascii?Q?simXB6XnPB2TtaegCEyIcoZhMV8t0eBQNCjbvEarsbg67HwmqbULFJIzMM5o?=
 =?us-ascii?Q?twf5VZExm0fcsppydgHv8axGzbIwSUfR3luZWfJm7ct3W1FvrXANdfmCxGfq?=
 =?us-ascii?Q?VP/ywBzFHvHZ6y3MOCM6+lOQziPV5Nv75hcJGI36ZGxovSHefD8GOkfbRVXf?=
 =?us-ascii?Q?ZvI0hBNQNJimfu575psUvgAlbnK1xYnbeD1FTv3jw+4czR/sCSUbCBPk2KZj?=
 =?us-ascii?Q?CBCZ5XfNZzOOnq5TAwEcfxa7f+ctoT/qK1pB1nl2ocojDl+8GXg4T7qBJ85z?=
 =?us-ascii?Q?EVwr2q9ETtJR7mOkkg0a8fbkYuICdQ5j+XrB8CcGsa3IlYtrtf6gQ0MLqECI?=
 =?us-ascii?Q?yYDEuiYKh8c0vsNln4oWlmMd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10292f23-1f02-4f90-004a-08d98d7527c0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:56.8529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbNVCELcjsjtqVPELr9ko4t+OLrK0O9Ke/4Tb8lWLyx8arsKdHM2D2irQdbrIq+Jj3vfPb8eXewN007bVvlmYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP packets with 2-step TX timestamp requests are matched to packets
based on the egress port number and a 6-bit timestamp identifier.
All PTP timestamps are held in a common FIFO that is 128 entry deep.

This patch ensures that back-to-back timestamping requests cannot exceed
the hardware FIFO capacity. If that happens, simply send the packets
without requesting a TX timestamp to be taken (in the case of felix,
since the DSA API has a void return code in ds->ops->port_txtstamp) or
drop them (in the case of ocelot).

I've moved the ts_id_lock from a per-port basis to a per-switch basis,
because we need separate accounting for both numbers of PTP frames in
flight. And since we need locking to inc/dec the per-switch counter,
that also offers protection for the per-port counter and hence there is
no reason to have a per-port counter anymore.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c     |  6 ++++-
 drivers/net/ethernet/mscc/ocelot.c | 37 ++++++++++++++++++++++++------
 include/soc/mscc/ocelot.h          |  5 +++-
 include/soc/mscc/ocelot_ptp.h      |  1 +
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a3a9636430d6..50ef20724958 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1291,8 +1291,12 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 	if (!ocelot->ptp)
 		return;
 
-	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone))
+	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone)) {
+		dev_err_ratelimited(ds->dev,
+				    "port %d delivering skb without TX timestamp\n",
+				    port);
 		return;
+	}
 
 	if (clone)
 		OCELOT_SKB_CB(skb)->clone = clone;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a65e80827a09..82149d8242ba 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -569,22 +569,36 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
-static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-					 struct sk_buff *clone)
+static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+					struct sk_buff *clone)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	unsigned long flags;
+
+	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
 
-	spin_lock(&ocelot_port->ts_id_lock);
+	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
+	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
+		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+		return -EBUSY;
+	}
 
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
+
 	ocelot_port->ts_id++;
 	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
 		ocelot_port->ts_id = 0;
+
+	ocelot_port->ptp_skbs_in_flight++;
+	ocelot->ptp_skbs_in_flight++;
+
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
-	spin_unlock(&ocelot_port->ts_id_lock);
+	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+
+	return 0;
 }
 
 u32 ocelot_ptp_rew_op(struct sk_buff *skb)
@@ -633,6 +647,7 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	int err;
 
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
@@ -650,7 +665,10 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 		if (!(*clone))
 			return -ENOMEM;
 
-		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		if (err)
+			return err;
+
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 	}
 
@@ -709,9 +727,14 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
 
-		/* Retrieve its associated skb */
 		port = ocelot->ports[txport];
 
+		spin_lock(&ocelot->ts_id_lock);
+		port->ptp_skbs_in_flight--;
+		ocelot->ptp_skbs_in_flight--;
+		spin_unlock(&ocelot->ts_id_lock);
+
+		/* Retrieve its associated skb */
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -1950,7 +1973,6 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	skb_queue_head_init(&ocelot_port->tx_skbs);
-	spin_lock_init(&ocelot_port->ts_id_lock);
 
 	/* Basic L2 initialization */
 
@@ -2083,6 +2105,7 @@ int ocelot_init(struct ocelot *ocelot)
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
+	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(ocelot->dev));
 	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 06706a9fd5b1..b0ece85d9a76 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -603,10 +603,10 @@ struct ocelot_port {
 	/* The VLAN ID that will be transmitted as untagged, on egress */
 	struct ocelot_vlan		native_vlan;
 
+	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
-	spinlock_t			ts_id_lock;
 
 	phy_interface_t			phy_mode;
 
@@ -680,6 +680,9 @@ struct ocelot {
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
 	struct hwtstamp_config		hwtstamp_config;
+	unsigned int			ptp_skbs_in_flight;
+	/* Protects the 2-step TX timestamp ID logic */
+	spinlock_t			ts_id_lock;
 	/* Protects the PTP interface state */
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index 6e54442b49ad..f085884b1fa2 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -14,6 +14,7 @@
 #include <soc/mscc/ocelot.h>
 
 #define OCELOT_MAX_PTP_ID		63
+#define OCELOT_PTP_FIFO_SIZE		128
 
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
-- 
2.25.1

