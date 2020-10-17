Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5C2914C0
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439617AbgJQVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:45 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439570AbgJQVgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZinosnaQ5DII3WC0LGMuwToSoVkftAuY5xat4CTOdVaK7joRxCJbcnL8cFfgxkD4OgA7qn7P+wb4+KKjtV9ZBLYkTVL3keP+O9iKup4BeAS2dHIcLR4QJdCvdF6x4XB7VmT+xATcAMOzmpIAylp+GZ1PtFrfvx1MIfq7VB/ZaccOIPOb8lvquj7F6N2WesYzNesKXThh/xuK7ZXknOm0z1BAsErn5X9zwHOzy0Nzn3djesAtcUQbKywlMZnF/2/wvLWGMSPdge1N0GslD7NHOhReQ3ReRQF7jfwjhBwsswBqjoFU0hQ9JpyWMmwpBprgjmY/cFRxbNFQedrhGQlOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn+AMpeqLL7h1jjZwb9H1Oz1RLwzeXOFI/JcCCPYTbs=;
 b=mplEdkozjEqFHqGAzuBYKqpzMPwWAn1Tfy2zRJFcZd6gZa49xiTp3OizjrOBB3LftD5p7WjTvlGUzvhPKNs9ipEBhgjhLclfRcikHRFFWuDqFWDODlAE+Yja81sr6vZs3yCRyLjImpQWo52Pe97IB/1qu8x3LsNaPHyrQYWqJp/SXn1SovMlw53dmMnNZChy+T0K/ksWiQqw6IqxgNmpZk4309H7K/xAacYm+ELnVydUoTwWP6mPEF/JSRJwc/rVgUUWY6wjTAG0TTi/rs2SLXgvbfA80ov3qFv5NNZ0f7pYDUrotCl6u/VYpCRtNRRdPDY2gJAcfd7NkyTh8DI6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn+AMpeqLL7h1jjZwb9H1Oz1RLwzeXOFI/JcCCPYTbs=;
 b=Z3DKLPMDkVyrdQ6sXXfAI7RenT2vMigFaDb593VmPs2ZrFsCIZndztfp5Fh//RxTBzxZaScvYZQx+rpljymmGj5DiRW1TGopnQ7CE4k6VBrGCd9fAwm8LhYmydl/27fvznnOCNnAY9x9d/S/1f8MeTlrZBsGngyl6AJHhqPGmeg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev statistics
Date:   Sun, 18 Oct 2020 00:35:59 +0300
Message-Id: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80841aa5-d0a5-4676-2880-08d872e4b84a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854CC30B5B3A0CB52C96591E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: br5cmrUbBVrVH/xpKHmis2SSwSdYPOZO7eUlZ1Dhw5WX44Jws44pn7nDVLkjJUV1Ei1tRyVddYEZOaYkttt0EOF9nbRcwxEFVRlQVjK1OtpCOMeoDcjBvfCdpTvnpIABSARmwkxgWGLN8/aKo09zxip1LlsX2oEf33ZXnt1UJo3fKQvPm26UYnS7NVjdWyRu+CkFOMyx7nQFL211BQMcaHD3ktMq+d+fLsQ81SzpsrvkZwf/4Ol1M6/e/KFIblDoj4A5KauuAn9TBdZOPlpkdyZe0PClBvbcgMPBuVRkFuufRWMYqC+qAw1qSbSC/N8mTTgWWF6RgOHyAncmDWk6005LZXgtcon8/Rgiur/psz3N5v1zY1byprp0g3GT+Jj/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FjEoALM5w+ePq4+7fwnG+6eeX5WzJg49I1w3jf428gOVlHwFSOsWuycnmxVFAALxETsQBmwEufcA85KXhHqZX1TFhak7GXp45RzS+WCqyLb+m8h55np2BGQRIibuCooK4K8XA0L8puR96qKoVuNX0UAAct4hMIpvXTX7PmCEbCAT0kFML+Afw7XZzml5LFuj8RWdXWAnJNzDPypJlTKzexmOAcMRNhXr/Bx1KMvjOnPEbrouhs3+fp/lC9VdGAEQT/t+8uUqHweAbJOb7qeDdniYyqCfCYhehpcOXYfLXgNnOM9O+dMmnW6h0kd5KWms4mGXe0kKyakJYY4FdL+h3mx/Adn+9jthMyMu+IMKPRPlFwp7YuNcVK5DrocDZR2JTF2oYL7FA8QTILmDVrMo2MrP+xMqtY2/MVDxvdVcdbQTm8KcKN7Y2xooWxdj3FClWG8HZQYX3dtXpaXkZP4GjdEL+xoyfn+JXFmtcOg3Otha/TXUc7gNF2SWmGorXHB9kFw7NgHGNku05+s6Mk06VYR0rKELMX53E0B3q0oNFmt+LUxCYA/8pbylBf+h3V9WzWQuFSdYU9wNtPbBLyzwzeD4nEqTNwpWud1hX+y9NxwVydNTsb4ELNuqyGhLLKEsLfe7yjXXs0MortOnb/RMUQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80841aa5-d0a5-4676-2880-08d872e4b84a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:34.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCdYACekQdrj3APnBUI2ZOCXQssU7nff9jDKfnh26pv1BWTYcPkhq8ogZaluSbO+NbRzXmbyUf+7QoUTU1RgYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA needs to push a header onto every packet on TX, and this might cause
reallocation under certain scenarios, which might affect, for example,
performance.

But reallocated packets are not standardized in struct pcpu_sw_netstats,
struct net_device_stats or anywhere else, it seems, so we need to roll
our own extra netdevice statistics and expose them to ethtool.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  9 +++++++++
 net/dsa/slave.c    | 25 ++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12998bf04e55..d39db7500cdd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -73,12 +73,21 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+/* Driver statistics, other than those in struct rtnl_link_stats64.
+ * These are collected per-CPU and aggregated by ethtool.
+ */
+struct dsa_slave_stats {
+	__u64			tx_reallocs;
+	struct u64_stats_sync	syncp;
+} __aligned(1 * sizeof(u64));
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
 					struct net_device *dev);
 
 	struct pcpu_sw_netstats	__percpu *stats64;
+	struct dsa_slave_stats	__percpu *extra_stats;
 
 	struct gro_cells	gcells;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..d4326940233c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -668,9 +668,10 @@ static void dsa_slave_get_strings(struct net_device *dev,
 		strncpy(data + len, "tx_bytes", len);
 		strncpy(data + 2 * len, "rx_packets", len);
 		strncpy(data + 3 * len, "rx_bytes", len);
+		strncpy(data + 4 * len, "tx_reallocs", len);
 		if (ds->ops->get_strings)
 			ds->ops->get_strings(ds, dp->index, stringset,
-					     data + 4 * len);
+					     data + 5 * len);
 	}
 }
 
@@ -682,11 +683,13 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_switch *ds = dp->ds;
 	struct pcpu_sw_netstats *s;
+	struct dsa_slave_stats *e;
 	unsigned int start;
 	int i;
 
 	for_each_possible_cpu(i) {
 		u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
+		u64 tx_reallocs;
 
 		s = per_cpu_ptr(p->stats64, i);
 		do {
@@ -696,13 +699,21 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 			rx_packets = s->rx_packets;
 			rx_bytes = s->rx_bytes;
 		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+
+		e = per_cpu_ptr(p->extra_stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&e->syncp);
+			tx_reallocs	= e->tx_reallocs;
+		} while (u64_stats_fetch_retry_irq(&e->syncp, start));
+
 		data[0] += tx_packets;
 		data[1] += tx_bytes;
 		data[2] += rx_packets;
 		data[3] += rx_bytes;
+		data[4] += tx_reallocs;
 	}
 	if (ds->ops->get_ethtool_stats)
-		ds->ops->get_ethtool_stats(ds, dp->index, data + 4);
+		ds->ops->get_ethtool_stats(ds, dp->index, data + 5);
 }
 
 static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
@@ -713,7 +724,7 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 	if (sset == ETH_SS_STATS) {
 		int count;
 
-		count = 4;
+		count = 5;
 		if (ds->ops->get_sset_count)
 			count += ds->ops->get_sset_count(ds, dp->index, sset);
 
@@ -1806,6 +1817,12 @@ int dsa_slave_create(struct dsa_port *port)
 		free_netdev(slave_dev);
 		return -ENOMEM;
 	}
+	p->extra_stats = netdev_alloc_pcpu_stats(struct dsa_slave_stats);
+	if (!p->extra_stats) {
+		free_percpu(p->stats64);
+		free_netdev(slave_dev);
+		return -ENOMEM;
+	}
 
 	ret = gro_cells_init(&p->gcells, slave_dev);
 	if (ret)
@@ -1864,6 +1881,7 @@ int dsa_slave_create(struct dsa_port *port)
 out_gcells:
 	gro_cells_destroy(&p->gcells);
 out_free:
+	free_percpu(p->extra_stats);
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
 	port->slave = NULL;
@@ -1886,6 +1904,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
+	free_percpu(p->extra_stats);
 	free_percpu(p->stats64);
 	free_netdev(slave_dev);
 }
-- 
2.25.1

