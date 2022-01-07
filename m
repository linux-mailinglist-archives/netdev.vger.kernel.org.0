Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D062487978
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbiAGPCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:02:13 -0500
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:43678
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348021AbiAGPB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTnrHNRSjjNjFlIFCsLJMdvRwCUQDP3YijQcNz9ryZxCoj6Dld9zMMWnzmbdHc3GuA9cSvOeMhRv7xHdrFEGnSx7hykG4TqDJcfzfxJeFw/i+EyY6ZXPk+WjoLEU8ZOKeJFusLpXQaOU0KK6mt64Sx61XgVRosRpdxoMm+fjvR612qxmO7qTGUofL4CuIfcBdAZ3nYItP+j5rqJhwiQgZufc6Sp5uBqjwzFtDgGsO1aVnpIOb81mSzKYnVIt2vI6RyT7gXiK3GqOOV2WJB1fzBmIAenEVq8fX+KkpC+vK16GW41Ud6ZOITUpyB/0dzXuFT94PpTWzK4Z8lP6EjRvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osC5uTLoJlKjDAabypoyTlJvbyFr/KpaVTUfirEn2xM=;
 b=bnYrI0c+Ca0RW24BvE1q+8Ghw/szE5Z+yuCKKdxLCr8a5m1nHfcLJV3CJy8SPeWSim1WFgbmlc325zSClqt5lmJ/L4lR/fDrEHmwcS2a82BZ7Vzz2arzd8YZOUEKQW+Kkz2HzRS2RUKQR/P1ALl7889PatyCWkvGwyK9SR1WnqgFbJswOO43NJzYpODHLprG4UO1IWutyGg5d52D/rrvkOD/kggWIY8K4nbFGKi84YGqarOEIk3COe+MmNxHONLBeqzMm6+ZRHYd7FjB4O2U/xJS3/3wJ6YcbPwxhjPNi+4BBPXvn27z1ON5th9JmzU1dmJdHYUjv5lZqdH++PRRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osC5uTLoJlKjDAabypoyTlJvbyFr/KpaVTUfirEn2xM=;
 b=HwEBsGWf23JyaCciUvYNoPDpShPSdVb5gu8+RUBIV1zg/TdS8IajajL56vDBUs9vlDFrRrbp+3YemXLw7tIr+y76lU2gAHNicZwHVrzuXbxXTTwgwMmK3jyk2WUFWyCIU5IfYdZxeJdw4KJfEjFVFiHcKXwS0hCsqHxlfF4nCT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 11/12] net: dsa: support FDB events on offloaded LAG interfaces
Date:   Fri,  7 Jan 2022 17:00:55 +0200
Message-Id: <20220107150056.250437-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38f52a2a-bfaf-4d37-dacd-08d9d1ee8ddb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408CE4B7874B30B4028327EE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gxey/t28nlnb4YIgQA08fnBhMCO7uKp7flHgT0IhpB/TyuludR6uP9v59T3yGIidM7kvC7OuZ73XRJfSJI0ATN3Mn/XQkkPSV8TT4PMtoNaRjy8S7BDzmqQ0KCplUNdoqflipsykctBBr9n4x8Q6OagqKIscWdy8oWtXDY3iMgIpXx4xkQ2WNRhvHs87P5jMFmnXFlOZyJOTNNl9kVCDhUsveOXa+nH9rqZTAE9rv4ckr2lvHi99RHDp46ZrTrs/51pDQQ0R+jXj+3wGZRsu2FoxXt01zT7+bEmVnwbY3haeYAbBTU4YFwsVd+fXlrBxXiSeGJ1txC/8OLhufBh/f4vhcf8BgSjjqKJlUi1fYOd7kf+P/35wXKTwYwrWZbQQxWyrgzxSZODB6i+n13fzfxYxvA757scYCjLWFXzOwVTchNUZdzP+xHJ41neY27mwxc9MD+uZrcLzGHBOI92V0KELrJfj1tTXCnscXN8CmMpDSRME4c/x3hE8IwWy1PilfOgCkFXmj2CQarFpFBjGsKDzj5U0DgDB+3avHBshKdGlTL7sZL1nOU3aemQ67sJCba3yHTLttrs/upwSrLXbZ0b4zkpp4umCys8VPRucZ348zqCpbyvjTkdEjIS4XcMH2NXI37bCSJOLktSf4yaYv3xH/qBSjU5jn+My02fKVhgaQzfycaYidSI5NU/MKSMWV9/xihlGB8ngjenI2fKwgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(30864003)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?88T/F450yZX+NEyRF+BqXXfWTOp6rYWwYzssnl/3PSHMD04iv+Zr9rRFCVbh?=
 =?us-ascii?Q?0hE5PCzVbB4DULUg4H4w/J3v5Sx7nKyZfNFEGHNdDbcU1Rp6YhUOmQOZXjUZ?=
 =?us-ascii?Q?Slrynsjs/Fwi7HwC5pLBZDV5SqguirW+Lat+r27mu/wzuyyxRfPkkbAcgMO4?=
 =?us-ascii?Q?+SSknW+hZ5TlRUEzC3V/gC+zy26xCqKb3o6B0zIvywKwCGQVyaRa4FOgsQc5?=
 =?us-ascii?Q?JDsl9LkNqfO66/w3J9YBUJqA3bN6XljXVLWoB3IDvwDhhgLAjBCjUkXpfN/x?=
 =?us-ascii?Q?NGdwfHkEZ7VvujXlG7QVC3fisWw0/V6Z0B/agrpdYHph4MpLNskqZzNd/w2A?=
 =?us-ascii?Q?C9LXw5WWyBIWpvXsUU0dx45sojbPARFTUDXQWOBIA8Mb40DbwFR7l47wN9jK?=
 =?us-ascii?Q?pQAn4xJ7WB9/EMRuA4LGU4NULSESndHDL9y9Cq27WuahXKTkngfEpZvmmZCP?=
 =?us-ascii?Q?SlcuHeOQeGQxC8zcmvU207dxF/uojE9GU1620Vw6ly0fvkTaZVhc6TXUMNiS?=
 =?us-ascii?Q?LEulkX/qJCQGfASus96kybQKkxBHfp6HMDkWp4Pt+rRFtsBtvizMEYnLeBBT?=
 =?us-ascii?Q?qVnkdL2RQ2JvUZAVOv3h6PiZg3aPxudb333vWtJa8/GZyjoOVikF1xpdhf2j?=
 =?us-ascii?Q?KzSC+anqOgNgkXE41fJHuIts7wJxLWgeXs+xZdTYyWU30/cSgthntmjAevB1?=
 =?us-ascii?Q?3GnADuzIJC88qNhUYcVrn1Dd/HYvQ8EI0L+y5kFfjAn4VEoB3XwBJEB1QyW0?=
 =?us-ascii?Q?f5coD4ffu9emNsTykvCrmnpS68m/xI3JAjawCKkpokkcinfq6cyzSUK8LbOp?=
 =?us-ascii?Q?wmprzaBT4hFJF9rpodfFJHRe7gbUw333dIj0N2UByNzmXiDGfmLpdgZKZnN1?=
 =?us-ascii?Q?Fl7VZM3+lgQjw5LvUmC27DzygqkwCIMusOeHk1E0n2F9u7lIORz2RCnawRAC?=
 =?us-ascii?Q?kiom5+9eTbCfM3wqRLp6EZN1tki4CwF2U1jVLrDvBaoTKjhB+DvWM/InNtQI?=
 =?us-ascii?Q?K1zDgImWdBQEm52qqxoaOYQ1r+98oE/Q6m2+3DMN810RWdLULVBIhmqQANxE?=
 =?us-ascii?Q?NTtHON4Sey4awNAuMn9P2xtjccjkg7ZOV6rSKRx6HejmS3ad7kZzcEGhuPl3?=
 =?us-ascii?Q?NiVYLaHXlnk4ionGVXO+jHAG+BQRLqHmnjla2Zq7IVP4FvjgmnmoEZnp6HDW?=
 =?us-ascii?Q?VJxM3PmgJYPxIv4FrIeTeILhjQbIi11n/nm0vZs6ea3JK/m2SsAEXKSMKUIB?=
 =?us-ascii?Q?08VOPDRdrAC5zs2VeHxtbOsNAsYWfkSWCFMsCnh15XURbqrH1pN1tIzlajI1?=
 =?us-ascii?Q?JjJfCQGP6Jtx3tMYGCpxM+EHSM9PKONywYfmzAj8aRcDypmBJ2Q4msnWwWka?=
 =?us-ascii?Q?bDmSdmvs/JDTccut9itt2jRuNycKm1W+fmagxTRs2Bv9/jhX+Lb8DsO7VMmr?=
 =?us-ascii?Q?zvleOT49b5WWnuLDAsKvyvpgeB7LdtqMj1TKf/XKQi/iKkMn7TC6v/kW7gzO?=
 =?us-ascii?Q?40Y2Wp7AuD7jEKxoq8i22UbgBpRG2vorY/PRHuEjTdwhIOw64Z1eXTHjbPXg?=
 =?us-ascii?Q?+y+vvh0hk5ZRGeIjoJnsqVMywanKlyAxivXsmjdZ/l1+a9Xy5mLT2OUT5tR4?=
 =?us-ascii?Q?ePRSwqd9wR7c95/9NLb0nR4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f52a2a-bfaf-4d37-dacd-08d9d1ee8ddb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:16.3459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJ/BJ741SITis5QpJzNM0bb/gXd0/ZHKF1lwuzj+iuipzXV7cvEjk/ro/HEwGKiyUtoeD2SX7z9xjRrvvbaQzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces support for installing static FDB entries towards
a bridge port that is a LAG of multiple DSA switch ports, as well as
support for filtering towards the CPU local FDB entries emitted for LAG
interfaces that are bridge ports.

Conceptually, host addresses on LAG ports are identical to what we do
for plain bridge ports. Whereas FDB entries _towards_ a LAG can't simply
be replicated towards all member ports like we do for multicast, or VLAN.
Instead we need new driver API. Hardware usually considers a LAG to be a
"logical port", and sets the entire LAG as the forwarding destination.
The physical egress port selection within the LAG is made by hashing
policy, as usual.

To represent the logical port corresponding to the LAG, we pass by value
a copy of the dsa_lag structure to all switches in the tree that have at
least one port in that LAG.

To illustrate why a refcounted list of FDB entries is needed in struct
dsa_lag, it is enough to say that:
- a LAG may be a bridge port and may therefore receive FDB events even
  while it isn't yet offloaded by any DSA interface
- DSA interfaces may be removed from a LAG while that is a bridge port;
  we don't want FDB entries lingering around, but we don't want to
  remove entries that are still in use, either

For all the cases below to work, the idea is to always keep an FDB entry
on a LAG with a reference count equal to the DSA member ports. So:
- if a port joins a LAG, it requests the bridge to replay the FDB, and
  the FDB entries get created, or their refcount gets bumped by one
- if a port leaves a LAG, the FDB replay deletes or decrements refcount
  by one
- if an FDB is installed towards a LAG with ports already present, that
  entry is created (if it doesn't exist) and its refcount is bumped by
  the amount of ports already present in the LAG

echo "Adding FDB entry to bond with existing ports"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond, then removing ports one by one"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link set swp1 nomaster
ip link set swp2 nomaster
ip link del br0
ip link del bond0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |   6 ++
 net/dsa/dsa_priv.h |  14 +++++
 net/dsa/port.c     |  27 ++++++++
 net/dsa/slave.c    | 152 ++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/switch.c   | 109 ++++++++++++++++++++++++++++++++
 5 files changed, 305 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9ddcdbf8e41c..cbc0ae4f2fd4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -119,6 +119,8 @@ struct dsa_netdevice_ops {
 struct dsa_lag {
 	struct net_device *dev;
 	unsigned int id;
+	struct mutex fdb_lock;
+	struct list_head fdbs;
 	refcount_t refcount;
 };
 
@@ -908,6 +910,10 @@ struct dsa_switch_ops {
 				const unsigned char *addr, u16 vid);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
+	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
+	int	(*lag_fdb_del)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
 
 	/*
 	 * Multicast database
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index efc692132b3a..e49e8b3342f7 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -25,6 +25,8 @@ enum {
 	DSA_NOTIFIER_FDB_DEL,
 	DSA_NOTIFIER_HOST_FDB_ADD,
 	DSA_NOTIFIER_HOST_FDB_DEL,
+	DSA_NOTIFIER_LAG_FDB_ADD,
+	DSA_NOTIFIER_LAG_FDB_DEL,
 	DSA_NOTIFIER_LAG_CHANGE,
 	DSA_NOTIFIER_LAG_JOIN,
 	DSA_NOTIFIER_LAG_LEAVE,
@@ -64,6 +66,13 @@ struct dsa_notifier_fdb_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_LAG_FDB_* */
+struct dsa_notifier_lag_fdb_info {
+	struct dsa_lag *lag;
+	const unsigned char *addr;
+	u16 vid;
+};
+
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
@@ -119,6 +128,7 @@ struct dsa_switchdev_event_work {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	bool host_addr;
+	const void *ctx;
 };
 
 struct dsa_slave_priv {
@@ -205,6 +215,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
+int dsa_port_lag_fdb_add(struct dsa_port *dp, struct dsa_lag *lag,
+			 const unsigned char *addr, u16 vid);
+int dsa_port_lag_fdb_del(struct dsa_port *dp, struct dsa_lag *lag,
+			 const unsigned char *addr, u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e3e5f6de11c8..b2782dd748f6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -461,6 +461,8 @@ static int dsa_port_lag_create(struct dsa_port *dp,
 	lag->dev = lag_dev;
 	dsa_lag_map(ds->dst, lag);
 	dp->lag = lag;
+	mutex_init(&lag->fdb_lock);
+	INIT_LIST_HEAD(&lag->fdbs);
 
 	return 0;
 }
@@ -475,6 +477,7 @@ static void dsa_port_lag_destroy(struct dsa_port *dp)
 	if (!refcount_dec_and_test(&lag->refcount))
 		return;
 
+	WARN_ON(!list_empty(&lag->fdbs));
 	dsa_lag_unmap(dp->ds->dst, lag);
 	kfree(lag);
 }
@@ -844,6 +847,30 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
+int dsa_port_lag_fdb_add(struct dsa_port *dp, struct dsa_lag *lag,
+			 const unsigned char *addr, u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
+}
+
+int dsa_port_lag_fdb_del(struct dsa_port *dp, struct dsa_lag *lag,
+			 const unsigned char *addr, u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
+}
+
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3f2bb6ecf512..eccd0288e572 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2443,7 +2443,80 @@ static void dsa_slave_fdb_event_work(struct net_device *dev,
 	}
 }
 
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
+static void dsa_lag_fdb_event_work(struct net_device *lag_dev,
+				   unsigned long event,
+				   const unsigned char *addr,
+				   u16 vid, bool host_addr,
+				   const void *ctx)
+{
+	struct dsa_switch_tree *dst;
+	struct net_device *slave;
+	struct dsa_port *dp;
+	struct dsa_lag *lag;
+	int err;
+
+	/* Get a handle to any DSA interface beneath the LAG.
+	 * We just need a reference to the switch tree.
+	 */
+	slave = switchdev_lower_dev_find(lag_dev, dsa_slave_dev_check,
+					 dsa_foreign_dev_check);
+	dp = dsa_slave_to_port(slave);
+	dst = dp->ds->dst;
+	lag = dp->lag;
+
+	dsa_lag_foreach_port(dp, dst, lag) {
+		if (ctx && ctx != dp) {
+			const struct dsa_port *other_dp = ctx;
+
+			dev_dbg(dp->ds->dev,
+				"port %d skipping LAG FDB %pM vid %d replayed for port %d\n",
+				dp->index, addr, vid, other_dp->index);
+			continue;
+		}
+
+		switch (event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			if (host_addr)
+				/* Host addresses notified on a LAG should be
+				 * kept for as long as we have at least an
+				 * interface beneath it. Therefore, fan out
+				 * these events as normal host FDB entries
+				 * towards all lower DSA ports.
+				 */
+				err = dsa_port_host_fdb_add(dp, addr, vid);
+			else
+				/* Similarly, FDB entries (replayed or not)
+				 * towards a LAG should be kept as long as we
+				 * have ports under it. Count replayed events
+				 * just once, but normal events will modify the
+				 * refcount by the number of ports currently in
+				 * that LAG.
+				 */
+				err = dsa_port_lag_fdb_add(dp, lag, addr, vid);
+			if (err) {
+				netdev_err(slave,
+					   "failed to add LAG %s FDB entry %pM vid %d: %pe\n",
+					   lag_dev->name, addr, vid, ERR_PTR(err));
+				break;
+			}
+			dsa_fdb_offload_notify(lag_dev, addr, vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			if (host_addr)
+				err = dsa_port_host_fdb_del(dp, addr, vid);
+			else
+				err = dsa_port_lag_fdb_del(dp, lag, addr, vid);
+			if (err) {
+				netdev_err(slave,
+					   "failed to delete LAG %s FDB entry %pM vid %d: %pe\n",
+					   lag_dev->name, addr, vid, ERR_PTR(err));
+			}
+			break;
+		}
+	}
+}
+
+static void dsa_fdb_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
@@ -2455,6 +2528,13 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 					 switchdev_work->vid,
 					 switchdev_work->host_addr);
 
+	if (netif_is_lag_master(dev))
+		dsa_lag_fdb_event_work(dev, switchdev_work->event,
+				       switchdev_work->addr,
+				       switchdev_work->vid,
+				       switchdev_work->host_addr,
+				       switchdev_work->ctx);
+
 	kfree(switchdev_work);
 }
 
@@ -2500,7 +2580,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   orig_dev->name, fdb_info->addr, fdb_info->vid,
 		   host_addr ? " as host address" : "");
 
-	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
+	INIT_WORK(&switchdev_work->work, dsa_fdb_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
@@ -2513,6 +2593,72 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	return 0;
 }
 
+static int
+dsa_lag_fdb_event(struct net_device *lag_dev, struct net_device *orig_dev,
+		  unsigned long event, const void *ctx,
+		  const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct dsa_switchdev_event_work *switchdev_work;
+	bool host_addr = fdb_info->is_local;
+	struct net_device *slave;
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+
+	/* Skip dynamic FDB entries, since the physical ports beneath the LAG
+	 * should have learned it too.
+	 */
+	if (netif_is_lag_master(orig_dev) &&
+	    switchdev_fdb_is_dynamically_learned(fdb_info))
+		return 0;
+
+	/* FDB entries learned by the software bridge should be installed as
+	 * host addresses only if the driver requests assisted learning.
+	 */
+	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
+	    !ds->assisted_learning_on_cpu_port)
+		return 0;
+
+	/* Get a handle to any DSA interface beneath the LAG */
+	slave = switchdev_lower_dev_find(lag_dev, dsa_slave_dev_check,
+					 dsa_foreign_dev_check);
+	dp = dsa_slave_to_port(slave);
+	ds = dp->ds;
+
+	/* Also treat FDB entries on foreign interfaces bridged with us as host
+	 * addresses.
+	 */
+	if (dsa_foreign_dev_check(slave, orig_dev))
+		host_addr = true;
+
+	if (host_addr && (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del))
+		return -EOPNOTSUPP;
+
+	if (!host_addr && (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del))
+		return -EOPNOTSUPP;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	netdev_dbg(lag_dev, "%s LAG FDB entry towards %s, addr %pM vid %d%s\n",
+		   event == SWITCHDEV_FDB_ADD_TO_DEVICE ? "Adding" : "Deleting",
+		   orig_dev->name, fdb_info->addr, fdb_info->vid,
+		   host_addr ? " as host address" : "");
+
+	INIT_WORK(&switchdev_work->work, dsa_fdb_event_work);
+	switchdev_work->event = event;
+	switchdev_work->dev = lag_dev;
+
+	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
+	switchdev_work->vid = fdb_info->vid;
+	switchdev_work->host_addr = host_addr;
+	switchdev_work->ctx = ctx;
+
+	dsa_schedule_work(&switchdev_work->work);
+
+	return 0;
+}
+
 /* Called under rcu_read_lock() */
 static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
@@ -2532,7 +2678,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 							   dsa_slave_dev_check,
 							   dsa_foreign_dev_check,
 							   dsa_slave_fdb_event,
-							   NULL);
+							   dsa_lag_fdb_event);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..f43ac6f1a4d7 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -371,6 +371,75 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return err;
 }
 
+static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		goto out;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid);
+	if (err) {
+		kfree(a);
+		goto out;
+	}
+
+	ether_addr_copy(a->addr, addr);
+	a->vid = vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &lag->fdbs);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
+static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (!refcount_dec_and_test(&a->refcount))
+		goto out;
+
+	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid);
+	if (err) {
+		refcount_set(&a->refcount, 1);
+		goto out;
+	}
+
+	list_del(&a->list);
+	kfree(a);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
@@ -437,6 +506,40 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_add)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_add(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
+static int dsa_switch_lag_fdb_del(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_del)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_del(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
@@ -711,6 +814,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_HOST_FDB_DEL:
 		err = dsa_switch_host_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_LAG_FDB_ADD:
+		err = dsa_switch_lag_fdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_LAG_FDB_DEL:
+		err = dsa_switch_lag_fdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_LAG_CHANGE:
 		err = dsa_switch_lag_change(ds, info);
 		break;
-- 
2.25.1

