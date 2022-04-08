Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827A64F9DF3
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbiDHUH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbiDHUHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:10 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8EA129868
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:05:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdt9OHTf5pgP2if4E06Ei8Nqr/PiYshbrQ3R2IEi0WObTMIlLxNCC5lgfkJEYi5JQB0vt9KVJSGCdH628CF2FcBwbQ1j+lfYAjitRsZjDHeAhkoMZhQud1nHSeVXlQUOOVDO1QhJazNGXOr3X+H+ZBBBgT9pyskwUdCPNmJMi7KEMpqsgxghvFHtzEg5U21EVvSdDJEL26C/2Lz7O9l+A48uHLFdP5wDyKWbVJI6CXh6qZOYdx3haHK27n4P/QlkIACpHMF1yr+1JiC7EcCNDK8xjS963WnJ6Phfb+7WOXM3xisg6E76LYRjOdatFtV1XrhZC5jTWflOwNdsLovE4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7lYNWAkeknQjwj26js86i5DgvDpTAeGC4j9jEHsL+E=;
 b=l01zRyuLMs6hN9k3FR7AaXTsaRq1lllvjnlqKfo0hgVmPjhZ5/iDLKyvMapmWc0Chf6hIOlb4623cSf1ImpDehL0LkRziZkjALhYbH4H5h8jYETcPumFWb1HnC80W+BN+kJBJuLzFHC3zqtuK7h7SBBFEGt4IYtsc0suqeJHYi2sFOo7VhHKZNZGJfySQeczuPnOAIwIWO431O2Z8PhWeHgGx51C+Dp6wj1t8ldadPys4WqlG+kvQIVT4nUlags2FpmCC4OsV0T5GiTiMyHNSkXjgD/UW6K5lr6w/YF55pIKjQz4gLCU/yub6q+H3QP9z6P7+N1eMzrLCpgiYcLKvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7lYNWAkeknQjwj26js86i5DgvDpTAeGC4j9jEHsL+E=;
 b=W2hj+kfi/SomhYhRt6GHbxDDCxr/tus2Tos/zLnG5k0iiVMonFQPB8ZDM/czsokyxHo+JMB3zGuQ8o3zfvmbTVOnarta7tIQGz6PIUZb1LdvTZPnht7tKWEPDhOQ4RkAobIhQC3okmvZSMYI/OgKW8ijb0ByC1e4ZN89XJAQPTU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:05:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:05:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: monitor changes to bridge promiscuity
Date:   Fri,  8 Apr 2022 23:03:36 +0300
Message-Id: <20220408200337.718067-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeafd9f4-e9ba-42df-503c-08da199b1124
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4275EC5139F97EEEFF2AB3CBE0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtpsrDKcyhYbb1THbbDQ8lOMjvR+0erLabjs7PBoCeoS3dWTz7DCcJTD3KaniI/3s6U4QtU+nF/q7GebOIaQj94QCbUhlbTCtPj3tlVSmHYiZyQmqyDEcDhkwosHKgKO49RaZEcurUz+gQtB+lpeEsoXJ747r1HopyfedurkdfeE3P87QtUjZwwFfuiLDb8Qv5PF1/Djqnty3LlSIeBCH0rK0QH5mb0Yohxwx++xKOrU9lxICaN9VgQ2qiewIGMU9ZuDZ40yDz3yUzjiIqDOb9sD4UPVm01EADmmPJxHZHjfhNdrxwlsKAk+bCBf6KY1x7GsHQRK09xm2j8n/yQHGjPiNlfseOz57dazrwywhnFlPzXEVTlMMgFApw2U5dSGv+UkeTAEAO+8/RgCt1dc1Qc2MxC7dlkN3NhCtMnsMPq1NqtA+5AGjYpTDT1XpohFjElbNP7Ku+H151Zi/1Q3aeyiICIc2zG3q+vURL8BElSXK/FID5pJVVSfAsgQDpRVCcnn09U6w/D1f1HRXMDU0qDx2JQlVmDThzSt3FsJ7u+vvEieoxfjyRFuqd9rZ06fO1WLTVL7AXubt24aguIMo1A1w6YrMUIzOUVH/3anS3hs1ovXc6eUzr912QDwgxotNTS/QKsu+Hs+KMHtqs+3RxDXio9E0igO9QRjX2fZ5s+diILAfZAlmLpk4vXLiWBynVrZUGPZYUsFIUu3gCpLXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrGm8dDESvf4eeImGYx2P+kFRisdaQ3YI7P9qrcjew/mO2csnl8jfmPkjUm+?=
 =?us-ascii?Q?7zqCqeEVvj/+iApdqF771dHOSX1nK2/LJGxq077X2NJWnYAqiHBJ4814kbYd?=
 =?us-ascii?Q?1+OfBIjkRUf6zsxrQdy5XlUTNQkD2xSDYQ1wiOwhojhNQxpwPBA1TvgJRaVf?=
 =?us-ascii?Q?ipm9iZhif2Jr77agF+DhZXyjKlqD/P36ZJnSsoHBzmDU6QBHUqL1mMIF+ZLd?=
 =?us-ascii?Q?3pmfGcxuyIo+0/etCtYd1hICMJ2ozEdTVmjPGkPjm2z7UiwfeG4HbtvYJ9Dr?=
 =?us-ascii?Q?MHRmKEdmkwg6EVBlvT/Tb31sUnPD9Bd0ZigmfBBcgdxvrlw9DbLuehvhYItk?=
 =?us-ascii?Q?dOus/nHa1NRTs7naF+ZFfJ5iJuujqYDJSPAznHbhJSZDtDg0ktYI1/UIPl4y?=
 =?us-ascii?Q?KJyuzZjNwzKjx3zbrtnXHQAfYVG/DGESWg9vli2l60A+Zrq15hsQkiBkhu0l?=
 =?us-ascii?Q?8UUssnpuZHhqhiNCyX5KbdPlHTjPvre/Wlv+kq25GGp6MeAgEiowYAQcW4XW?=
 =?us-ascii?Q?xKgS3tHZa3D7O52BJKYDVadx7QWXzZUWEL39F7fLO9jgRJHd0ZCo5D+UUHYe?=
 =?us-ascii?Q?s4cksOkqXQWvT+I47XQDhuI9mw8sGdxx9NGxDz6xUGOMf5R39RJUN+ZZnHL1?=
 =?us-ascii?Q?nvBZNDyI+vtqpJc5sBBdnVb+vQCCpnOk3mEbz7v8Ssil4p1/Rlor65qwadhU?=
 =?us-ascii?Q?QyW8wbfZXXAFcwVf9AqufVh5YKSb7YMakimerWAztpR0laPLjsRKZ3M3J/Fl?=
 =?us-ascii?Q?jtXa7gEEl+Dlkewb8880OZ6UAU0dAfophmx4LIWYpbiL4iYCk+gH7haS9Bzx?=
 =?us-ascii?Q?p2evhv8iQvcxBmBc0xDkItIMVgQRES2AyMSK+rvO+HzMK6+US3W1FY9UKQwD?=
 =?us-ascii?Q?ja9aQ7jJlRxsvgK64MGExuJ1tLUu+KiCZfZf9pwp2fWWUj4/mEw+4ie82je5?=
 =?us-ascii?Q?/D2md5sJyeKEmCcQNZZO+4bInMIaStqjKwIuayCmuvGZ+sknNpexdfo13KUs?=
 =?us-ascii?Q?imIn6eWknsAZ41OZopcDv5/VJfFvcirsExddyqXLwTtEeIiAuw44Pr0DL8NY?=
 =?us-ascii?Q?v4YwA3uIMNtQzi6yr5/LKMnRFuujhqUXbyw8H7ErxqWUezE0vdknRdKQdCQ4?=
 =?us-ascii?Q?C+lLdgXd6AKRaslnCDcDjIbfoXVLnCQ9bYRddJ+wPFFdOMz0cw++5E3u4ydW?=
 =?us-ascii?Q?V/cHYzxY3C7MgdYepNNy7ToaWY7LSD+7OcZI2qU7tNqGZlnPmoT/Sw31iDjs?=
 =?us-ascii?Q?lGufcnrXlC5X1vjYX6Er9SBKieAPjLVCEx3rmTPP4gd2cWSJDb5cLPhECAT5?=
 =?us-ascii?Q?5TCMwCk/B0zr/XPu8SuqltH1ekFfctJF2R34WSaA9jzD+Tqehd5oQga09TPR?=
 =?us-ascii?Q?Ws4avqfYnS1yBJocxbYbm2oNcYpVNetXTGjRlXEuM1LG4zdUmdPVDWGYNIFW?=
 =?us-ascii?Q?31Bql0h676P4nFI4HQMWD9tuH/L9oFO8AOhNYlVCYJZcRr+O2SQB9mXVENzC?=
 =?us-ascii?Q?og6P+rna0NS+jUPGvl5uk1iyog8IMYsXTwATCUahlpGMpSngCaVMF3BiM2NI?=
 =?us-ascii?Q?2yVHuPD4z1Jc8h5rcbUzGhTgRaSSPr3vTIT3S1AW+4FzyZrKDwV8LWA11aw9?=
 =?us-ascii?Q?ngBNnKfHi23WXrEMkHBJDHysiTI/SHiNuiiUM+uBwsvkoGqzst1oLox0cAWP?=
 =?us-ascii?Q?6+PDBAXDD3Au7eY655UDGNsoDHsEU39o+2Q33ayP05hNuOGEUUJJl5Nh8sCh?=
 =?us-ascii?Q?4Xw7o+UhxL8SuCSjfVVNrqqnzVkdevc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeafd9f4-e9ba-42df-503c-08da199b1124
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:05:02.7532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klmwg0hnnRfqXqksnkCguEUxQ6Wq5Ho0qG08BPSJY3oKuj5P2dInigCoIxMCpnBeqioHKde4FzsOWJ5d3UmB/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of changing the bridge such that it stops managing the
IFF_PROMISC flag on offloaded bridge ports, we need to ensure that DSA
preserves behavior in the circumstances that matter.

The bridge software data path implementation (br_handle_frame_finish)
passes a unicast frame up if a BR_FDB_LOCAL entry exists, or if the MAC
DA is unknown, if local_rcv is true. In turn, local_rcv is true when
the bridge device itself is promiscuous.

The analogous behavior in the offloaded plane is to enable flooding of
packets with unknown destination towards the CPU when the bridge device
itself is promiscuous. This change achieves that by monitoring
IFF_PROMISC changes on bridge devices, and calling
dsa_bridge_host_flood_change -> dsa_port_manage_cpu_flood on such changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  1 +
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     |  5 +++++
 net/dsa/slave.c    | 43 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0ea45a4acc80..e8e30be4cde8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -243,6 +243,7 @@ struct dsa_bridge {
 	refcount_t refcount;
 	u8 tx_fwd_offload:1;
 	u8 have_foreign:1;
+	u8 promisc:1;
 };
 
 struct dsa_port {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d610776ecd76..9b868a7c3459 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -321,6 +321,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
 int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
+int dsa_bridge_promisc_update(struct net_device *bridge_dev);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index cbee564e1c22..bbcc9c92af5f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -660,8 +660,13 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	if (err)
 		goto err_foreign_update;
 
+	err = dsa_bridge_promisc_update(bridge_dev);
+	if (err)
+		goto err_promisc_update;
+
 	return 0;
 
+err_promisc_update:
 err_foreign_update:
 	dsa_port_pre_bridge_leave(dp, bridge_dev);
 	dsa_port_bridge_leave(dp, bridge_dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1bc8d830fb46..59ebc4a520e7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2753,6 +2753,13 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	}
 	case NETDEV_CHANGE:
 	case NETDEV_UP: {
+		int err;
+
+		if (netif_is_bridge_master(dev)) {
+			err = dsa_bridge_promisc_update(dev);
+			return notifier_from_errno(err);
+		}
+
 		/* Track state of master port.
 		 * DSA driver may require the master port (and indirectly
 		 * the tagger) to be available for some special operation.
@@ -2891,13 +2898,13 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 }
 
 /* We need to keep flooding towards the CPU enabled as long as software
- * forwarding is required.
+ * forwarding is required, or the bridge device is promiscuous.
  */
 static void dsa_bridge_host_flood_change(struct dsa_bridge *bridge,
-					 bool have_foreign)
+					 bool have_foreign, bool promisc)
 {
-	bool host_flood_was_enabled = bridge->have_foreign;
-	bool host_flood_enabled = have_foreign;
+	bool host_flood_was_enabled = bridge->have_foreign || bridge->promisc;
+	bool host_flood_enabled = have_foreign || promisc;
 	int inc = host_flood_enabled ? 1 : -1;
 	struct net_device *brport_dev;
 	struct dsa_switch_tree *dst;
@@ -2917,6 +2924,7 @@ static void dsa_bridge_host_flood_change(struct dsa_bridge *bridge,
 
 out:
 	bridge->have_foreign = have_foreign;
+	bridge->promisc = promisc;
 }
 
 int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
@@ -2949,7 +2957,32 @@ int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
 		}
 	}
 
-	dsa_bridge_host_flood_change(bridge, have_foreign);
+	dsa_bridge_host_flood_change(bridge, have_foreign, bridge->promisc);
+
+	return 0;
+}
+
+int dsa_bridge_promisc_update(struct net_device *bridge_dev)
+{
+	struct dsa_bridge *bridge = NULL;
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
+				bridge = dp->bridge;
+				break;
+			}
+		}
+	}
+
+	/* Bridge with no DSA interface in it */
+	if (!bridge)
+		return 0;
+
+	dsa_bridge_host_flood_change(bridge, bridge->have_foreign,
+				     bridge_dev->flags & IFF_PROMISC);
 
 	return 0;
 }
-- 
2.25.1

