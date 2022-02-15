Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27844B7631
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242127AbiBORDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:03:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242090AbiBORCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:49 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E8511941C
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaaS33gCNh4ovZ+kPfcEe9Z4BGmWEYdNjavvVLNOILz11SgdUh1Ocq4rnnJ/ItjSNfyIR6Cf8p5Aw0ftnClsSI2Mc5IKH9s0wOVnGtpIo1QacEEj8faAfaXAj3ISMTVS1SgX9I3m7UY2lriakhjGhxTDn1yRw6h1DJkhJo+HYc1qrhfbW8LLVPQJjbZDJ4PNecV2k6SIYAyMy1uMREY9zj5gZGH4cufCe9miDudL76xK0Z4eao6nCTpGAeEpvIlMh9OXtQUaLC/rCVh0+nE5MPI+ZYfscY5/ShKV52a3PQ18aH8HvrPO9r1T3lEbE5vSLkgsgSeTiAXMJQVY/AUW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Sv5W3P370XA+tZ55ADTPx2ydzBmsfzfXLeyxjsjUiE=;
 b=G9Mz6CRWdLpNlQlzJeKozGLYKgScJXeqrxURhWMY2PxMM1/116mbasLhUnoHtfsRzS1ei2jJksgi426HCPeceM2DcZTP1Flc31/2uQxUaAxhZ8/6Aa9sd4LppvDlD/xeBV+2S7uFPei/5l63qZNlro6/97bcaYoiFy8z0yfQw8dp5pc+8J9gQwNra8AF7wiPBJdNPoIdlcUtdDkVdh+NlahzGq7HEbRtTGP12aE/sfIBoSPEIhYAO7U54jmV3twJl/MqVpsZ3F0nP5ed1wlkiWo+plHwUBqTdklVRNnPB//bNvaZeX1xjr/H2Hpi4W9+FdzQnGGgCEDnnD6kPPJb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Sv5W3P370XA+tZ55ADTPx2ydzBmsfzfXLeyxjsjUiE=;
 b=CGiT3LioIj0jo44zkAtl90TGbeCcQ4mQ4y3zTjHnZLr+zUY2cpNRDpYM7XOwYEXq9+0gZkvniDwC+HUZSzRjsfkbl+HsR34NPgBERXiUIsxULkuFBkc0l9AKkMX8SVUNAHmlRDlYQgGyxmNAPrx2nLwKm+NwYhWWHPuhq8v8aic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 10/11] net: dsa: add explicit support for host bridge VLANs
Date:   Tue, 15 Feb 2022 19:02:17 +0200
Message-Id: <20220215170218.2032432-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2e8c9eb-b5c6-4d15-a5e1-08d9f0a4f575
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB53429642FEC9EBCE34ECA442E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BV9OYX0h34fI47n8psg4XLoEk+47HzKAEYLy94bi5+xBayUaiPTSo7gRcHoJt7idznMeXEP+zyGQWbj2NM951d9JVam7FSPmZxrNOThd5Idfh4MGAE6R1atO8NMOXDxLSm1mouTTQdWpnhRHzFd7ChCo76NTPa0C1XpasIzqfFBwqTT0KhF/SBBQClm1mzE9+wU9ym7eG65AyMDMCbTJPwnGV49FDxlTIWhXxJ8rgjY4acmKlfbiUtuPvmpDHP8v1xrQ0/Cki0zNIOFWrjqvFBUkqNXmh+6o+FsajkR5b3JVicB/6ur34gJYP4Swi/CA+mEIKrs+NTAntnTr1nYuzV6w/oiFZMqXRyVaiyY2dLIPhbgbBVkHloquYHxtMJXcxJMxo63AmjKphGyrfgoUFl6nVBMdPvzldvTLEbSRjlV84IDrj2S9e9bxA2LTtoIqluqkj78FrSGRj8q5rLsAkDJtR/K+FDxFxt7MeVzZqbLGfIhRqTB6xGBmJKg4C/SP7ldR5nEO8Ksma3Hn6MLl1AX+atefTfftjMJQdSGnayQmm9hhdM52WN4LyISHswxx7bDz3idEyyBVCtaWP641cyJAp3SNQYSkaGuIfASKjZjBOAohEuKPHVQ+25oDrOMbJhdOWznYQpgXa0DWM1+O5XXtgUFwX3zKL2CjOWCcjaLSWmgpQwn878LGt9JSwzYnSRV1mPUrlrJGfJigHeBPkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(30864003)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1VNIhb+vigWfSGBAYAuAl1W/t3HmJznS6/QjqB/JinFU4pQ5+jC2aROIydin?=
 =?us-ascii?Q?e5flEc2gM3RbvE2BOx4o2kXaPgcEnOqQCIGhyCDosGKKPvFBJgn5lMThp38Z?=
 =?us-ascii?Q?5N9TKUdZfGMVq6x+9PxIAB83VVTCVsLy5IzJQjssSnYLB3dwdnHMniKC/mN/?=
 =?us-ascii?Q?0wZh5vTEXrZpCJOXQW5bzgQ4GZJ16k2V/mH8Wfnl5yAwbkwSbqvM2q6FCoy5?=
 =?us-ascii?Q?gFXBhWD8v9vPFaw8+5bHmC0qSE7rIPbY+l/1UL/9Y3s+37KHx0IBYjv4chUH?=
 =?us-ascii?Q?HW+uaXxuZ6wo8q2ae5J5xFFeiekWXdb/TNuvF+JBVvqg59iebxbYAv5H0dOV?=
 =?us-ascii?Q?fH7jYcYSY+Ovvfxh5eY+bfvO9XMcdtTbqIxgSSjDkMG0PS3Vs/0XsiZuuy5c?=
 =?us-ascii?Q?DA8CaT9TMc/PPS+G70scwGeUVLD4tpYf4Z0dU964tTvDziZEJzyvWWMJb0PE?=
 =?us-ascii?Q?H5HgHG7Ti42jFo5iP4vNxDpu6QucVmv7O7EjXGdnr2lrV7FRfvxlHmVXvWw9?=
 =?us-ascii?Q?vYwvufGnnHbh94uqmVYcDRYC1vCdhj6vEofHqS+VcocutLvxN0HsEU6AXWCM?=
 =?us-ascii?Q?SarvEjmK1uzVfL/MLkZw2hSw24C0iDJc956ogZSi5b1ACoUtPe8NZpjdEUGN?=
 =?us-ascii?Q?9tGzWUZ5vhQm65F9PHknIez/6gZzXwgspqa5ZRF9qclzSO/Kj4Fw9Nkb29Lx?=
 =?us-ascii?Q?6rSJ/2rwIlUqz+/qjNxXVpapleFtmL6iochTfVDTea7lcBZ+WbDhK07IaVMN?=
 =?us-ascii?Q?8gOeVIr94oPSUepah9ta75Fkq0HYjGQiuxdIr2SmRF0F/Dt8KgZ8Staacyzx?=
 =?us-ascii?Q?LFrom0LQ6WSY1DqKioQTcan3CrqYZwtX8b81kjaCPJCHQsgh4zkMBXPJwc3G?=
 =?us-ascii?Q?pxMHAQjA3+/np9iTrSc4IgtTXqHnL+h9D+q+t4eZtDCpN1I3uts+uxGL1Ygk?=
 =?us-ascii?Q?z2gtaCEIqTmP3nmGsVmcWIe2ZQAg7NEHhNGtQeJciZZsXOKC/ZSJrR+s7OW1?=
 =?us-ascii?Q?6asHzSDfL0X9bVEs4W49XYOh+hG9D2FTdlp0xDHNvIzQfVP+4wiuv6POQTpJ?=
 =?us-ascii?Q?c/fEXPM/Cq+gUWn9k8JmkKrPSl0FQakeKKMbuIbqRLXvbcxL23uYkOuKncBR?=
 =?us-ascii?Q?sYfzOfpEyJXKpjQjMYC7JnVqET6GuqYT4vdsiuXScRBAfAeMtuN82RYOUJeM?=
 =?us-ascii?Q?tuNcao6FXhnu0mYo3e2K30phEkqoxtZmqaXmjXxQUlCRN/qOPzh8Okd1ecXy?=
 =?us-ascii?Q?YlLSQTNeh+7AKsZzetNKfkTg/s0wBtb5nktfh/Z2YIVgcXlncoE/jUXilbHT?=
 =?us-ascii?Q?76fgi0hJc3zBOZghRKd1Vs4of7hNkzPMAQNRZs1rs5MuKBTa6Z6uo2QjyoUe?=
 =?us-ascii?Q?D4eNhvWYE4/6SzJd6EyVL2nKCtLVUu5mhmasTUNNsGOp97CzHqrnTascebKm?=
 =?us-ascii?Q?z7AKpfdMq4q6RO4+uGAdq2hUXpEIZScxmfSqY/zQw8Q2kHkcC2UbxmxWetkN?=
 =?us-ascii?Q?Mz2869M9YFSYxoPyV+XA7LUGBim0xEqE1F9PWmCGr39jXNzHq8Jo8Fol+yhq?=
 =?us-ascii?Q?2BPneasL8qYO/EeqqlQf2cO4OtrOS26ANrJVTkFzNwSaSqDcsJ1ZGMn6O/UW?=
 =?us-ascii?Q?xgJDxBu8r4eNwaiK8M676L4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e8c9eb-b5c6-4d15-a5e1-08d9f0a4f575
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:33.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44581YMdjBgZNGWxg40xwspsTd0FIQtcHo+ooZqqZonUH7Qch9fCIV8VN4oSwmvcslyz8ii4Y0j6sZGgFmGq2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, DSA programs VLANs on shared (DSA and CPU) ports each time it
does so on user ports. This is good for basic functionality but has
several limitations:

- the VLAN group which must reach the CPU may be radically different
  from the VLAN group that must be autonomously forwarded by the switch.
  In other words, the admin may want to isolate noisy stations and avoid
  traffic from them going to the control processor of the switch, where
  it would just waste useless cycles. The bridge already supports
  independent control of VLAN groups on bridge ports and on the bridge
  itself, and when VLAN-aware, it will drop packets in software anyway
  if their VID isn't added as a 'self' entry towards the bridge device.

- Replaying host FDB entries may depend, for some drivers like mv88e6xxx,
  on replaying the host VLANs as well. The 2 VLAN groups are
  approximately the same in most regular cases, but there are corner
  cases when timing matters, and DSA's approximation of replicating
  VLANs on shared ports simply does not work.

- If a user makes the bridge (implicitly the CPU port) join a VLAN by
  accident, there is no way for the CPU port to isolate itself from that
  noisy VLAN except by rebooting the system. This is because for each
  VLAN added on a user port, DSA will add it on shared ports too, but
  for each VLAN deletion on a user port, it will remain installed on
  shared ports, since DSA has no good indication of whether the VLAN is
  still in use or not.

Now that the bridge driver emits well-balanced SWITCHDEV_OBJ_ID_PORT_VLAN
addition and removal events, DSA has a simple and straightforward task
of separating the bridge port VLANs (these have an orig_dev which is a
DSA slave interface, or a LAG interface) from the host VLANs (these have
an orig_dev which is a bridge interface), and to keep a simple reference
count of each VID on each shared port.

Forwarding VLANs must be installed on the bridge ports and on all DSA
ports interconnecting them. We don't have a good view of the exact
topology, so we simply install forwarding VLANs on all DSA ports, which
is what has been done until now.

Host VLANs must be installed primarily on the dedicated CPU port of each
bridge port. More subtly, they must also be installed on upstream-facing
and downstream-facing DSA ports that are connecting the bridge ports and
the CPU. This ensures that the mv88e6xxx's problem (VID of host FDB
entry may be absent from VTU) is still addressed even if that switch is
in a cross-chip setup, and it has no local CPU port.

Therefore:
- user ports contain only bridge port (forwarding) VLANs, and no
  refcounting is necessary
- DSA ports contain both forwarding and host VLANs. Refcounting is
  necessary among these 2 types.
- CPU ports contain only host VLANs. Refcounting is also necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- no BRIDGE_VLAN_INFO_BRENTRY flag checks and manipulations in DSA
  whatsoever, use the "bool changed" bit as-is after changing what it
  means.
v1->v2:
- figure out locally within DSA whether to bump the refcount or not for
  a VLAN, based on the new "changed" and "old_flags" properties.

 include/net/dsa.h  |  10 +++
 net/dsa/dsa2.c     |   2 +
 net/dsa/dsa_priv.h |   7 ++
 net/dsa/port.c     |  42 ++++++++++
 net/dsa/slave.c    |  97 +++++++++++++----------
 net/dsa/switch.c   | 187 +++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 298 insertions(+), 47 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3f683773aaf6..1456313a1faa 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -312,6 +312,10 @@ struct dsa_port {
 	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
+
+	/* List of VLANs that CPU and DSA ports are members of. */
+	struct mutex		vlans_lock;
+	struct list_head	vlans;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
@@ -332,6 +336,12 @@ struct dsa_mac_addr {
 	struct list_head list;
 };
 
+struct dsa_vlan {
+	u16 vid;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	struct device *dev;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e498c927c3d0..1df8c2356463 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -453,8 +453,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 		return 0;
 
 	mutex_init(&dp->addr_lists_lock);
+	mutex_init(&dp->vlans_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
+	INIT_LIST_HEAD(&dp->vlans);
 
 	if (ds->ops->port_setup) {
 		err = ds->ops->port_setup(ds, dp->index);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6076d695a917..a37f0883676a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -34,6 +34,8 @@ enum {
 	DSA_NOTIFIER_HOST_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
+	DSA_NOTIFIER_HOST_VLAN_ADD,
+	DSA_NOTIFIER_HOST_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
 	DSA_NOTIFIER_TAG_PROTO_CONNECT,
@@ -233,6 +235,11 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct netlink_ext_ack *extack);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
+int dsa_port_host_vlan_add(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan,
+			   struct netlink_ext_ack *extack);
+int dsa_port_host_vlan_del(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp);
 int dsa_port_mrp_del(const struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..cca5cf686f74 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -904,6 +904,48 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
+int dsa_port_host_vlan_add(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan,
+			   struct netlink_ext_ack *extack)
+{
+	struct dsa_notifier_vlan_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vlan = vlan,
+		.extack = extack,
+	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+
+	return err;
+}
+
+int dsa_port_host_vlan_del(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_notifier_vlan_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vlan = vlan,
+	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+
+	return err;
+}
+
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f6caf5d037e..734c381f89ca 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -348,9 +348,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct netlink_ext_ack *extack)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct switchdev_obj_port_vlan vlan;
+	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
 	if (dsa_port_skip_vlan_configuration(dp)) {
@@ -358,14 +357,14 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 		return 0;
 	}
 
-	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
 	if (br_vlan_enabled(dsa_port_bridge_dev_get(dp))) {
 		rcu_read_lock();
-		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
+		err = dsa_slave_vlan_check_for_8021q_uppers(dev, vlan);
 		rcu_read_unlock();
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -374,21 +373,29 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 		}
 	}
 
-	err = dsa_port_vlan_add(dp, &vlan, extack);
-	if (err)
-		return err;
+	return dsa_port_vlan_add(dp, vlan, extack);
+}
 
-	/* We need the dedicated CPU port to be a member of the VLAN as well.
-	 * Even though drivers often handle CPU membership in special ways,
+static int dsa_slave_host_vlan_add(struct net_device *dev,
+				   const struct switchdev_obj *obj,
+				   struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan;
+
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
+		return 0;
+	}
+
+	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	/* Even though drivers often handle CPU membership in special ways,
 	 * it doesn't make sense to program a PVID, so clear this flag.
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
-	if (err)
-		return err;
-
-	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
+	return dsa_port_host_vlan_add(dp, &vlan, extack);
 }
 
 static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
@@ -415,10 +422,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_host_vlan_add(dev, obj, extack);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_add(dev, obj, extack);
+			err = dsa_slave_vlan_add(dev, obj, extack);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -444,26 +458,29 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
-	int err;
 
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	/* Do not deprogram the CPU port as it may be shared with other user
-	 * ports which can be members of this VLAN as well.
-	 */
-	err = dsa_port_vlan_del(dp, vlan);
-	if (err)
-		return err;
+	return dsa_port_vlan_del(dp, vlan);
+}
 
-	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
+static int dsa_slave_host_vlan_del(struct net_device *dev,
+				   const struct switchdev_obj *obj)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
 
-	return 0;
+	if (dsa_port_skip_vlan_configuration(dp))
+		return 0;
+
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	return dsa_port_host_vlan_del(dp, vlan);
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
@@ -489,10 +506,17 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_del(dev, obj);
+			err = dsa_slave_host_vlan_del(dev, obj);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_vlan_del(dev, obj);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -1347,7 +1371,6 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
@@ -1367,7 +1390,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	}
 
 	/* And CPU port... */
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &extack);
+	ret = dsa_port_host_vlan_add(dp, &vlan, &extack);
 	if (ret) {
 		if (extack._msg)
 			netdev_err(dev, "CPU port %d: %s\n", dp->cpu_dp->index,
@@ -1375,13 +1398,12 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
-	return vlan_vid_add(master, proto, vid);
+	return 0;
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid = vid,
@@ -1390,16 +1412,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	};
 	int err;
 
-	/* Do not deprogram the CPU port as it may be shared with other user
-	 * ports which can be members of this VLAN as well.
-	 */
 	err = dsa_port_vlan_del(dp, &vlan);
 	if (err)
 		return err;
 
-	vlan_vid_del(master, proto, vid);
-
-	return 0;
+	return dsa_port_host_vlan_del(dp, &vlan);
 }
 
 static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4866b58649e4..0bb3987bd4e6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -558,6 +558,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	return err;
 }
 
+/* Port VLANs match on the targeted port and on all DSA ports */
 static bool dsa_port_vlan_match(struct dsa_port *dp,
 				struct dsa_notifier_vlan_info *info)
 {
@@ -570,6 +571,126 @@ static bool dsa_port_vlan_match(struct dsa_port *dp,
 	return false;
 }
 
+/* Host VLANs match on the targeted port's CPU port, and on all DSA ports
+ * (upstream and downstream) of that switch and its upstream switches.
+ */
+static bool dsa_port_host_vlan_match(struct dsa_port *dp,
+				     struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *targeted_dp, *cpu_dp;
+	struct dsa_switch *targeted_ds;
+
+	targeted_ds = dsa_switch_find(dp->ds->dst->index, info->sw_index);
+	targeted_dp = dsa_to_port(targeted_ds, info->port);
+	cpu_dp = targeted_dp->cpu_dp;
+
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+		return dsa_port_is_dsa(dp) || dp == cpu_dp;
+
+	return false;
+}
+
+static struct dsa_vlan *dsa_vlan_find(struct list_head *vlan_list,
+				      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_vlan *v;
+
+	list_for_each_entry(v, vlan_list, list)
+		if (v->vid == vlan->vid)
+			return v;
+
+	return NULL;
+}
+
+static int dsa_port_do_vlan_add(struct dsa_port *dp,
+				const struct switchdev_obj_port_vlan *vlan,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	struct dsa_vlan *v;
+	int err = 0;
+
+	/* No need to bother with refcounting for user ports. */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_vlan_add(ds, port, vlan, extack);
+
+	/* No need to propagate on shared ports the existing VLANs that were
+	 * re-notified after just the flags have changed. This would cause a
+	 * refcount bump which we need to avoid, since it unbalances the
+	 * additions with the deletions.
+	 */
+	if (vlan->changed)
+		return 0;
+
+	mutex_lock(&dp->vlans_lock);
+
+	v = dsa_vlan_find(&dp->vlans, vlan);
+	if (v) {
+		refcount_inc(&v->refcount);
+		goto out;
+	}
+
+	v = kzalloc(sizeof(*v), GFP_KERNEL);
+	if (!v) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ds->ops->port_vlan_add(ds, port, vlan, extack);
+	if (err) {
+		kfree(v);
+		goto out;
+	}
+
+	v->vid = vlan->vid;
+	refcount_set(&v->refcount, 1);
+	list_add_tail(&v->list, &dp->vlans);
+
+out:
+	mutex_unlock(&dp->vlans_lock);
+
+	return err;
+}
+
+static int dsa_port_do_vlan_del(struct dsa_port *dp,
+				const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	struct dsa_vlan *v;
+	int err = 0;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_vlan_del(ds, port, vlan);
+
+	mutex_lock(&dp->vlans_lock);
+
+	v = dsa_vlan_find(&dp->vlans, vlan);
+	if (!v) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (!refcount_dec_and_test(&v->refcount))
+		goto out;
+
+	err = ds->ops->port_vlan_del(ds, port, vlan);
+	if (err) {
+		refcount_set(&v->refcount, 1);
+		goto out;
+	}
+
+	list_del(&v->list);
+	kfree(v);
+
+out:
+	mutex_unlock(&dp->vlans_lock);
+
+	return err;
+}
+
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
@@ -581,8 +702,8 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_vlan_match(dp, info)) {
-			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
-						     info->extack);
+			err = dsa_port_do_vlan_add(dp, info->vlan,
+						   info->extack);
 			if (err)
 				return err;
 		}
@@ -594,15 +715,61 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 static int dsa_switch_vlan_del(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
+	struct dsa_port *dp;
+	int err;
+
 	if (!ds->ops->port_vlan_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_del(dp, info->vlan);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int dsa_switch_host_vlan_add(struct dsa_switch *ds,
+				    struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *dp;
+	int err;
+
+	if (!ds->ops->port_vlan_add)
+		return -EOPNOTSUPP;
+
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_add(dp, info->vlan,
+						   info->extack);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int dsa_switch_host_vlan_del(struct dsa_switch *ds,
+				    struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *dp;
+	int err;
+
+	if (!ds->ops->port_vlan_del)
+		return -EOPNOTSUPP;
+
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_del(dp, info->vlan);
+			if (err)
+				return err;
+		}
+	}
 
-	/* Do not deprogram the DSA links as they may be used as conduit
-	 * for other VLAN members in the fabric.
-	 */
 	return 0;
 }
 
@@ -764,6 +931,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_VLAN_DEL:
 		err = dsa_switch_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_VLAN_ADD:
+		err = dsa_switch_host_vlan_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_VLAN_DEL:
+		err = dsa_switch_host_vlan_del(ds, info);
+		break;
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
-- 
2.25.1

