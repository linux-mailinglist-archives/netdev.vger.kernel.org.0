Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F84B0DEE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241840AbiBJMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241828AbiBJMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:33 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9952652
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKDtk1VPBnuEFhqs59AEqYtGoImQehbz8bQPAvk9DIOAWH7hNebOnLHMG416ZorZugtUj1Y3erLFEsO0it7lLYOqaymuybw2PAlr4mt3PFxh9D187OHheiYT2bk5kiktKGf/BmfByt1xFzbw1y92QY2SiEa3NAhyflPs3ENg04QvwP+ZQsdvMdXDSzpDXFsJVarV6qLsLK9fTwmA+xbXzZ2quxFk6j4XUriOyW3/agZErMO73ThJxzzkGxdW9rw6ELkfYihplpFohLlhulJWe6tuHjQULZ7ZZ0yno3bmPZxN/ogOjZdG6ZbuvvKC3dE2UeRa0AfmnmEGeDMfaGPYyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uc2rQoJT0lNDwF57fViCbLnOGtZuqNdzzmwrAJtLRzM=;
 b=iJzlmypWgn3Vqoj7NfugTT1jT1l01ufI7iTBLVegiDlidJEdf5jrY6b5r9GmR7mW59TM7cLoBgaZ+wu0IkduRF1khDW8YY2wFYfB86MnKby5VKoJGdgdegxn3VDoqA1jY/J3kSKu08apKiVLML70yvec0Jk2zyY2UOPut8wNS4iu3IAgtRIC+b19PuI+Y1WQq0UOKyaVGBLfZTvX/C0IqS79499bYMOTwQ/K/IJps+aSqIVAbfcdj9/vqcA+sfeTvK/U0HJFhhjbQbMNSObTicWzYd7uFnQYeagytWpTMLe1bmPSgiaD561ZOPauhHCcmfMjmMstbZy9rUJoe5bVWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uc2rQoJT0lNDwF57fViCbLnOGtZuqNdzzmwrAJtLRzM=;
 b=fteFj36QbdRBZvNOYaYrEtZKkw05k4dAPxapgQFolHkjS45xBAbMFrktDuOqyWHx/YuD3hjNuCifnqKMrv1FAx0CGmP2h3MMimtlpm/QIj6bIQnDc/pM3r+2RuBCm6J0Im0bk5Cj0tc4OYwv0mDpOSdjKzypGeUpo36YIhDeKd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 11/12] net: dsa: support FDB events on offloaded LAG interfaces
Date:   Thu, 10 Feb 2022 14:52:00 +0200
Message-Id: <20220210125201.2859463-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d33ccfe-785f-4dbd-c9f6-08d9ec943273
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB88063F5A9C9BA0A596FEFF6CE02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDnAfWJ9UXHS8uSKTQIrSPj3LxGjJfBip2LSW0Qd1AflAgUHJlrM12GzqmEduYtUpIaG8j0KO/xjHtoMqCvq/CesTXuIBzTh+daCK5ALHis2X0d1yHc0ONunoapzKESVwEAdB+RbUIobSCs28r5PmGY0F8f2VvYF4SZ9AiDAbeNugFj1O18oXTtW7ONLICnHRZiK/DaVAvDhoCXSrbdjeOHhHN8eWjHnaVtYR+/dkktSbfIDhhwMHfjOUIKKWtZADwVRxrvi55T06bltA+G1Yf+t0FGv95yi8qkrvGEn+rFpCROjDwR5XS77kwOG2Qb21pTZGbghn8IvlSGJhbjUpU4Yi5ZaNdCEIzKz+Ub5JurpbTHqxUfYKozqu2mBHWoC3o2mq5Q19PP1h1GsDEz+0dmlbVRPfgfFRfOXlHZhxdfEFeXSR76DCGTd/2CWIkle/X/tRcc69Q9lJBN37mLGvRrdtHiSxFy01rb/sqmN5cWWe7KSfi+esOwopxmhW5YRPSSxH2syyL9DHu9zxctQ2uzgZRXQVqwEoxMb7dPvNhi9reKwik29U4DB4A5BtI8XT0g8NcK0D5cwdoQyMY8KZOiV7YH5OFteq9v8vJzvta1O26SPyR3UR6PNUO69SeIbItv9YJnvmYxAdsIWjG/qKHidf7jywX18YMnt76/RZGJ89OY52K+js5X1eWeBMNqwFHJffmrNzShx0JT0y4VdLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(30864003)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sOOqpAbNC6eqMS40sZPV17ugOFT7w7Vnq2optexTW69mQfOmg/bWIaXRyC7X?=
 =?us-ascii?Q?CpAWCP/reOwmSpj0kAtl0EWiAalxHbCkDFCEcSg7DR8qqAr7/RWPkjRmXG0m?=
 =?us-ascii?Q?1RKgbO4lfSoSARnw1an6i04syCxDWCrpoo7dVJkBFUYfKpqS3NV1UuT2S6Pj?=
 =?us-ascii?Q?e5/VNQDaeSFon4g5goZOzBoo4MnX12E2iZe8MwpvEWXm4jlBa06T+SkZ5MWD?=
 =?us-ascii?Q?3lPexns8KahWr07jM/2p7iDjkw3Hdu2oo+5SsiugVbZiO5Z28oP9r8s86iw2?=
 =?us-ascii?Q?4tZxg64nAqEK/CkC5DD2zA5LqBIFjhCpCXL3Ke2f9o+RMf6fal42XxfQQo1M?=
 =?us-ascii?Q?698/1JnVVvhoDHXp0+YgbyElmOJCFz0ZaXYNPePbPNxXa60w6SRfg+3FU1EH?=
 =?us-ascii?Q?ARDxFGsMxMjuyJ0sZTSKfIT+TNAQYtwJIixlmz6BMSNm93g2t+CgcZhm1Lk2?=
 =?us-ascii?Q?iNvpvgeT3a8xAuJnPr+dnYZyHOUEaOpstIHPE+qnICBY7/VXeUX/u/ge4EEG?=
 =?us-ascii?Q?RgJPkuxBO5QXWh6p+MMTV3tYpVQNHQvHy5FCVmLs2SjINZIydym/q/2xauM7?=
 =?us-ascii?Q?XC7IlBh/sYw8S3FTvf2QgMS2Ve23v+oPwNTg3SIxqcbY0zHlRXAh9zKQs1W9?=
 =?us-ascii?Q?jG7K9x20YjepmBOoGu5D8BT8ksYCJjUFcMIwhj+5KVomVQMDmWI0GwPCJxfv?=
 =?us-ascii?Q?tt1oFp6ohUy2tLiijOzHrUitT9LRvImyyykJ5VwERGQ1gLhWjN/dQlU67sjR?=
 =?us-ascii?Q?GGgc5cbSJ6WP1YR500XXohcDwLVbzoDyhOvYeajwHfF0g7XQMc05ve3xmGNz?=
 =?us-ascii?Q?WqBMubgNV73shPD0p1ktpXRtfVvAoWLkp/ZFDKmwF2ji7nVThdoVaUXtyUjG?=
 =?us-ascii?Q?M0XRXWwCqWwAzKbAgGUC+JHb8OALoFGMmThlXq5X+mdYHrCcz1u0agq+eDXH?=
 =?us-ascii?Q?zPT7hOcX8YnYtRd5sbpLLQAmzDLcNJ82x/VQJNTXRIyl9KxTXsARrZYNHAfI?=
 =?us-ascii?Q?FyU4pxTA1mOAl9YybMYTJU0cWLoeu8uKMJ5eY+h2J/pCWUq7OiCwck0ttHvW?=
 =?us-ascii?Q?vSelu9cr3OoMVkCYsoVySR1XygFYvd+50mqMIDgQGVobacfPUqJX4xC3yCm2?=
 =?us-ascii?Q?tvHe46pigkSb7pdZElU5gOCxl0b3yhvBXrD+J1DvRDIQDJgt/zqE36mFYAGd?=
 =?us-ascii?Q?X9enO+6jbwU45433o6ZslmijlJfdOADd4w8827R21hDVcnbsOsvbbdg9ItqN?=
 =?us-ascii?Q?wPtQ5gKS//rcqLvnBZvTxnyvPfGwWE/NlvVaW/2xqnkJvTM+TH3m/pkDzG2p?=
 =?us-ascii?Q?IrcBf1WENZjLW/RjC/swSz9a4o6j3RHKmjN+4s6kodaL81sYacR5SXw3md3z?=
 =?us-ascii?Q?j/tMorwRKhbSJUOEvWScgWBx/uXI7nZEznazdD1BPPvewwiYrcZQGoZDhuZh?=
 =?us-ascii?Q?44p5O61uZM6gQjQpo3FS/pZsOK0SliYzOuVayLicpev9N9nNZfn4syXwjdI8?=
 =?us-ascii?Q?mIheOiCo9FEjiqB8OhvZnksf4Kv7772snh9y5laSMFgOGlBQbZehLS/8Hz0U?=
 =?us-ascii?Q?XGzQGoRc0BKj4xBZm8kntQ9zhQq79qI+Gd76fpp1t1KQiktcp+6HU1tkh/3J?=
 =?us-ascii?Q?76BOjWPxp0RhBLxY068CNIM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d33ccfe-785f-4dbd-c9f6-08d9ec943273
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:29.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8cvhbdpMtz+fHT6h1546C5KcealwkHpmMrTaOTlIUj/QbK7VhznNXsPROYX/KYB6+Q4yW76DrT3sTk5A5c6Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
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
 include/net/dsa.h  |   6 ++
 net/dsa/dsa_priv.h |  14 +++++
 net/dsa/port.c     |  27 ++++++++
 net/dsa/slave.c    | 152 ++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/switch.c   | 109 ++++++++++++++++++++++++++++++++
 5 files changed, 305 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1f3a5ac3fb96..b2a02e43ad8d 100644
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
 
@@ -936,6 +938,10 @@ struct dsa_switch_ops {
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
index 885cc8df0c4e..95d0408d7aab 100644
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
@@ -65,6 +67,13 @@ struct dsa_notifier_fdb_info {
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
@@ -126,6 +135,7 @@ struct dsa_switchdev_event_work {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	bool host_addr;
+	const void *ctx;
 };
 
 struct dsa_slave_priv {
@@ -212,6 +222,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
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
index e5e22486a831..89387099e10f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2475,7 +2475,80 @@ static void dsa_slave_fdb_event_work(struct net_device *dev,
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
@@ -2487,6 +2560,13 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
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
 
@@ -2532,7 +2612,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   orig_dev->name, fdb_info->addr, fdb_info->vid,
 		   host_addr ? " as host address" : "");
 
-	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
+	INIT_WORK(&switchdev_work->work, dsa_fdb_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
@@ -2545,6 +2625,72 @@ static int dsa_slave_fdb_event(struct net_device *dev,
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
@@ -2564,7 +2710,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 							   dsa_slave_dev_check,
 							   dsa_foreign_dev_check,
 							   dsa_slave_fdb_event,
-							   NULL);
+							   dsa_lag_fdb_event);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4866b58649e4..dd0e0c9ae0de 100644
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
@@ -737,6 +840,12 @@ static int dsa_switch_event(struct notifier_block *nb,
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

