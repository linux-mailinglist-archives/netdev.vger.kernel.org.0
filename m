Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D894C14FC
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbiBWOCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241344AbiBWOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:02:00 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30086.outbound.protection.outlook.com [40.107.3.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D6EB1084
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VySn4e3axC1WnfMnZu9/fZP1Uq82o91raJmg4+kfGomLaIhzI5uf9s9Zhd0w2ZUojBmAvghfb26WF1Lc1dExbrU+ZSOI+mWh1vY3bdB581KyjN7TpY20JNVg1bg9JNUl+gpNANkz/WYcBFqrttCZ4x/Az22O4dM1Rs8N+ZjWl7HIv5SfXPR4szQ17E19erqUd5yl/iYPd33aumXap3lNVbSufmzhPCbNa1J9GjTaUmJPUgHGIgDsr6hUkz/HUMVYo5reAVOxfOLUahYNkchFPteo7Nte3jrRlXM/FGXzx0qwtqYbaAKkc/3nUcpppnfiknwqfVHv5by39sp5t0/Jog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXnLsb9EKn7tscOVSrsuBMbz4YMTREIgSU8VnQ77L1k=;
 b=WIqY5QCgx5zgHftGL28viOHX88o8cgnSLWySIysj3n+YtB+Jkoe+oXg++nNZ8Dp4TxuzH8y9+fkIwYRnuGat4+6TW2ID6c1VVIi17ncpwcpWkc9tj48oDIzpfrW+xfUKQQnI0VJDjiu3PKVoSS5dHWDC+AZKsjLwnN3tHs6c/ve41WEzjwgCBuqdgOu10n/k+OD+6+q12dOzyisAhBO/mLA2rSG77jSQZN7gYCYNbFDzxgWXBDHSFZchErTZCmyzYn2wYND4sbsNMc4qLUL/a8h0UjBa5LbpuWV+K6eD1L9okstnbQC2qkPz7LWZSifD4qT1fq05+FBEAKzK6Hs4ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXnLsb9EKn7tscOVSrsuBMbz4YMTREIgSU8VnQ77L1k=;
 b=Wbaww53aqpuYsiESp0TEePdeHM+nZ3RbZIrysFoRslHFz5mqjOM7tLpdXCrvzpv+sEGZ7ueoctNpY4mkrpe/AFESbToRrg9+qf6D7evn5NEk274pqFqyG9GHqZQfF9PcN/qDJj7tDsgLtJ5G6TNnamvkAhVXglDmKOEodcfUhtc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5164.eurprd04.prod.outlook.com (2603:10a6:10:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 10/11] net: dsa: support FDB events on offloaded LAG interfaces
Date:   Wed, 23 Feb 2022 16:00:53 +0200
Message-Id: <20220223140054.3379617-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92095b0e-3f1f-491e-c9cb-08d9f6d4f755
X-MS-TrafficTypeDiagnostic: DB7PR04MB5164:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5164BF31E91BC7668B68F88DE03C9@DB7PR04MB5164.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1yhi72nMEOHs4BYWZN3MuJmMXwalkCQJN/4RodlhFczgiJ7MFEO0Kl1HKKKDyyo+xVLI/rYK59dHQnWqraEVSOTvI+NtJJ0uty0VUlRsJ7FsRxXLkbUKfbsAcz9Q/oS5ikueOaYztG7PtztXYNzxqwYx7/tC5Y3zR/Y12MeVJ77Z0cU1V6yvxozmrZDkgt6hQDCYciteQ+4kEITk3Jtab55OXAJ+E78dCcuZBGe1AYBumLz2+ohBOfgOQCPEFFZ4QzSHVvWV7d5fYgIQ2L1jVJgQk9Rj9wvi4MaWFFDSn3SprB8pE7Nwq2knr1sx6bLMr2Z5ZMu8dbcU+J3m5iVCdhdbvc71NrGPL197ODfA6rcPJY5/3p20uWaltPFmSeR83Ljk+u0fDMtqT7a10E+FxYkBicoTO3Wf5zKePMTzFIoVsGVwltt5RoxJdYfeEOrrgJNfv/ZQm+c0xPjCnkM0faXhcgs09oE9HvTmn1HsDo1NK9jodyl9M2T+lSbjin6s+phFzumw56xhE9HQZMO5K0diWUrmo4Ixj+CK7yvZCRkevKOPxg5kWhIUsPbomWk5+AFnP+S7UwoUkCGNoHgfGbCOBuSgHwxxJKL0mNrASuXlaf7lo44rsUzZr5dqD90xFJMP/0sfMinzkeyLzr+OliuYn3hoR8meawQAgMNGL3HTTN366491fBejM22te7TODlbgaYNxnmZuPK+ep9Tehw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(66556008)(316002)(6916009)(66946007)(66476007)(508600001)(54906003)(6486002)(36756003)(86362001)(38350700002)(4326008)(1076003)(186003)(26005)(83380400001)(6666004)(7416002)(6512007)(6506007)(2616005)(44832011)(5660300002)(30864003)(8936002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fu+oLk791wt4276K6ikYgZAbUC5OJtco3QbGZWm2Bhh6OlrwsNOgvX1v2DFo?=
 =?us-ascii?Q?JRvg5joA+wNGNqCMQmFfGZuO8hsG3Uwn+oPp+Q935m444FKWC9kzLNojEbz/?=
 =?us-ascii?Q?Gz3x8Z0kF7VhrY0BvBrPxLZf0578/68HR8WDLV9IKtv+7snIxB0bCxEtlij9?=
 =?us-ascii?Q?YEx9LMzTuDc6CMkZbrFF3GcyaSZDJBRBYUHvSag/CHRwuODG6VWBrEI3LHNz?=
 =?us-ascii?Q?bSDMP/Ifr6+FYyX9xTNX4gpCpFFrfIWZTAAZ5VWtnjkYYspi/kVQbOi7bZK2?=
 =?us-ascii?Q?Uy3FErAnvOkhrC+f9t8bIDT5HwjFsbRCOI2ozRYT2+YHFNdLkiSKxUxckxb1?=
 =?us-ascii?Q?RxqcYbYaKK4OZcSFV40JjfBFToAw+wKL01dtZ58C44kyeLovmrBYQmaWZwo9?=
 =?us-ascii?Q?gNdRngVTROhMnt1azpMzR0giB5f/Dypw8yYHaGV5VcxjNb2xuWAl7AreOz0f?=
 =?us-ascii?Q?VDKWzJuRVnemYuML/b/fJ9quBJSqjJVopnxVhV5cxdF0k/nQD+qApKQ5tlKA?=
 =?us-ascii?Q?iuIBAlfpI+EgrpWa8XAbM7aR+RpKK2Esf6kcgZJ2kaShCYBE8OuA7kIqnrL0?=
 =?us-ascii?Q?iYzb6YTeDqLcOoTGyItT6ZdH8d/XGg+6ZFyLpPAlDX1Lbp0YMfOPzFb0w1hg?=
 =?us-ascii?Q?J/YpRvSs1Jrl00EmttdRDzvrllRejRD04EEvQtRcwAZcsO6Udo7SR+G6xFWj?=
 =?us-ascii?Q?wsW5xyrDrdm3NyOAdutIxAG3ZQvmzD6R2mhCYgPF5PYlJFAXqiEQ7lDv7uAY?=
 =?us-ascii?Q?kMJvKPrZBJuRARgRJ/pt8Sb0Kbzdw61IxMNMHPg/e8NdmKM+wdMB17afciN0?=
 =?us-ascii?Q?j7s27s7e9stIw8W09k+kVcg9JevF+z5ClPCsX62XjK3lRfoKMLSYA+rSBW0g?=
 =?us-ascii?Q?u4pNWjyN5iE4QTcYGCICHGjwBaIrf72y2OQ3Rrs61GZQZeQHZxd1UodvgmSu?=
 =?us-ascii?Q?G4aC2RaNm+yutRLq6AKP8J8DQ8JwQnhqmgalhlRxdIG03/9Xi/mAdOP6JsWB?=
 =?us-ascii?Q?tdU/m6+H19g6muQLqu5cG1gCqht131+JkTpFCKOvICFOYxmVI7eGTwO+9iss?=
 =?us-ascii?Q?gQvAGyIYmsW/mxnjU+rdoi2+/9RRFj5/QQgTMgv2VfFU0b1ozGL40eKNDLhK?=
 =?us-ascii?Q?CVHvEAmc6B5fzHCyx0eW1Tg6nXtqmTZFdhVUUCEx1ibvTFwTfwxycqefQ/pL?=
 =?us-ascii?Q?6+IEg896b2b6rTrqqGsp1Y9KW8U9rJBcISHyvuHfU8lHIMchwsz+BWnMlTlU?=
 =?us-ascii?Q?gesqumKDpDNQa36vkKgz7vGf2WlWOUmj3rqd5ZcYLaHQ4CdUlwO/vzucy3jr?=
 =?us-ascii?Q?KIo8QHMylKzW/jIjJxx+eNBOCjS2nE7UtoXeieVQYI4yWOJwooj4z1QYLnvq?=
 =?us-ascii?Q?kf1+sDYXqBijj/1tvYA+Uj2jHn2SHe8CNx4noK+WzrLk3LwoUbzc6NCb92Yo?=
 =?us-ascii?Q?fr5dd8NGmXWFqi8ugQ6py/FzOR9eCb+B/3buynSZ7xz55/aPSX4MbNLs9YUm?=
 =?us-ascii?Q?3Xn8KM1HcmJ8V+Pum8yo7BZ2EyUfdc70Oc3U7sEBeUH1qwI/yOFs8osGZT5F?=
 =?us-ascii?Q?Bswyt4YIEPfIxF5Wd9sqlGtTgJYprvkR0HSKTgC1/id6ddZjp6+tyXzyLEB4?=
 =?us-ascii?Q?vDUhIaqhIlo4hinaUbnSZQM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92095b0e-3f1f-491e-c9cb-08d9f6d4f755
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:19.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8g47/QmpVxU0u7lcqxrQx2qeRwLTBe2zol8xYURmzezIOW5cE6WKK51o0xu2bWe4r1FxjBBWj1LizdYf5dmBNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
v4->v5:
- none
v3->v4:
- remove the "void *ctx" left over in struct dsa_switchdev_event_work
- make sure the dp->lag assignment is last in dsa_port_lag_create()
v2->v3:
- leave iteration among DSA slave interfaces that are members of
  the LAG bridge port to switchdev_handle_fdb_event_to_device()
- reorder some checks that previously resulted in the access of an
  uninitialized "ds" pointer

 include/net/dsa.h  |   6 +++
 net/dsa/dsa_priv.h |  13 ++++++
 net/dsa/port.c     |  27 +++++++++++
 net/dsa/slave.c    |  43 +++++++++++-------
 net/dsa/switch.c   | 109 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 81ed34998416..01faba89c987 100644
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
 
@@ -944,6 +946,10 @@ struct dsa_switch_ops {
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
index f2364c5adc04..1ba93afdc874 100644
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
@@ -67,6 +69,13 @@ struct dsa_notifier_fdb_info {
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
@@ -214,6 +223,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 774ac3f9c9d8..e48c1f126412 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -458,6 +458,8 @@ static int dsa_port_lag_create(struct dsa_port *dp,
 		return -ENOMEM;
 
 	refcount_set(&lag->refcount, 1);
+	mutex_init(&lag->fdb_lock);
+	INIT_LIST_HEAD(&lag->fdbs);
 	lag->dev = lag_dev;
 	dsa_lag_map(ds->dst, lag);
 	dp->lag = lag;
@@ -475,6 +477,7 @@ static void dsa_port_lag_destroy(struct dsa_port *dp)
 	if (!refcount_dec_and_test(&lag->refcount))
 		return;
 
+	WARN_ON(!list_empty(&lag->fdbs));
 	dsa_lag_unmap(dp->ds->dst, lag);
 	kfree(lag);
 }
@@ -845,6 +848,30 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
+}
+
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
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
index 4aeb3e092dd6..089616206b11 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,6 +2398,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_add(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_add(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2415,6 +2418,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_del(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_del(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2457,25 +2463,20 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dp->lag)
-		return -EOPNOTSUPP;
-
 	if (ctx && ctx != dp)
 		return 0;
 
-	if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
-		return -EOPNOTSUPP;
-
-	if (dsa_slave_dev_check(orig_dev) &&
-	    switchdev_fdb_is_dynamically_learned(fdb_info))
-		return 0;
+	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
+		if (dsa_port_offloads_bridge_port(dp, orig_dev))
+			return 0;
 
-	/* FDB entries learned by the software bridge should be installed as
-	 * host addresses only if the driver requests assisted learning.
-	 */
-	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
-	    !ds->assisted_learning_on_cpu_port)
-		return 0;
+		/* FDB entries learned by the software bridge or by foreign
+		 * bridge ports should be installed as host addresses only if
+		 * the driver requests assisted learning.
+		 */
+		if (!ds->assisted_learning_on_cpu_port)
+			return 0;
+	}
 
 	/* Also treat FDB entries on foreign interfaces bridged with us as host
 	 * addresses.
@@ -2483,6 +2484,18 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
+	/* Check early that we're not doing work in vain.
+	 * Host addresses on LAG ports still require regular FDB ops,
+	 * since the CPU port isn't in a LAG.
+	 */
+	if (dp->lag && !host_addr) {
+		if (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del)
+			return -EOPNOTSUPP;
+	} else {
+		if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
+			return -EOPNOTSUPP;
+	}
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return -ENOMEM;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0bb3987bd4e6..0c2961cbc105 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -385,6 +385,75 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
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
@@ -451,6 +520,40 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
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
@@ -904,6 +1007,12 @@ static int dsa_switch_event(struct notifier_block *nb,
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

