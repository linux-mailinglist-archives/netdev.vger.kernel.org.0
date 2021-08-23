Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120813F500F
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhHWSD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:03:56 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:4129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231917AbhHWSDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 14:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5pO2LP3RukBGPBTDYvEOy808VeL+dNlpKrUagx+Ep+lglYUoknaQ+TVdQDVBmYyqAxbZ52O+e2uyrkDIzipFjSLCYja3ZLrOwOwovZR3FOJ09HCtQkH0tu4hrAyTyTDPK1tEmFkKAZY2uJmRGAGmL4AKo3xuxh3x1rtIcG1J/UFDKxcRxwSTyosl0naNuq9bfQV+61EGgtVmSdEBQhA8UqC98h3vrxgqqYm6bxz4GMKsSkeUpBv2ek6oo8FarZ/c422RuIfWxNeeBhR0fD/sMD5r/wZtcHcVaB/OXWj3JxotLsJguiLIjoF0ckd4sViGiji8IjVG/dua671BacfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY+8iXK39Xf5bhdrodKALnITxND45e8yXK7nXo5wNCg=;
 b=QYtjcHz7IufQFCM70ydMonugzTxWeaBT9/zH6XOQmByVZxHi3/W4e3asY7uQaigAJA2I8CJ4BBgkB3548RFFZMB41Ne+fDwN96x9HolIfqAsi8s9Rro7TA6x2e5aY4WbiZFFjUZoOkCZZLLaxrzdXw6lXsf+r7CtdpOUmR3w9ud9hEqRLxrgtRJBrlSA8Qj0NkLVZJQu0qhA3iKsJ1O9/hL7NQJyTjNNRwrVUzf3+RYFVz4IKqb95h1ZRop1YfUUq8x1k8l875AARO0ysqD8zzYwz54pr+ScYwscFtJc3wzLLinqkmjs+FL7T5x0zZrnD+VCnGbp9gQVQoW0kiyyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY+8iXK39Xf5bhdrodKALnITxND45e8yXK7nXo5wNCg=;
 b=L+iS5BL4sRsDK6YFtTjtEch+xLF1rr7YH7ddcNgoDdH8o1dAfb80WfLRUIBJ/8XkRc5hs33w2kUTYjic1kZB7hiqBr0cefJCr82+KnSCzgprBLtkd3tVfAHBH5M0Cdl4uTvWbtQmBi5erah0flvndQstZzjIDcq7NbBWqWilhyo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Mon, 23 Aug
 2021 18:03:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 18:03:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 3/3] net: dsa: let drivers state that they need VLAN filtering while standalone
Date:   Mon, 23 Aug 2021 21:02:42 +0300
Message-Id: <20210823180242.2842161-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
References: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P193CA0007.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P193CA0007.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 18:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 149ad2b0-4808-454b-af72-08d966603f4a
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6639F6BE916C57D68E40D79DE0C49@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7LXllFQn7ZUUVl9LlZLu6/uPm2RS4LH0kveWz9mrCf40VvrqC3WfywtAqJOxTZAtXNSizCFab+ygrgadv7SD7+AljnPJ1Ewox7FnLvT6lzGfHnBC+/YSojVHXTd+KMfhvsFEdx0+QLjLEKhFeHTcoKi6kIhJxWtd2FwgOtyU6A2F6eUZfsuig+mCNOKDvTzaFXmgbeeyUZA5Q55mE0TnX53tmlNsJBFxVgjnMOzazwg52Nh9AvA8+9pLgpyiaDxmnvRWhwkMC2F5t6yaABvcYTZyOHckmzfqqvAYbAoa2f69uTeelNd+LIp80Gi+GJLkRVGgGka/Co3tIlTGOgn1ZHEpzLmq4n9Cpab0sH6G4uhIaA8j2hHEJELJ53p1uqY+zzaot+nSJ6L6YZOAVlIT7UNO2JXGMJ3kyC1jof3gw8pT9tLDIbXS1FpxrtHvcogHqT4K/CRt9NBSDGDdAPnei5WtUHgh/VL3pMCml9wnlwRqCJe7SG/ZWmgXZ4hUUcQtUsMeq3ECvZ0RETuwL3vMeyvSthPF5LE74qc1XqA7/rWNtBBydIXQljjfDWUpTolGCMszYME9eTAdSyaaucS50O0JPCiCb174CnuBfOOkJ30V4Os0vukJFwckgfxV4Asur8qLHZLSaO4sxThQSS3IzTpCCTwHVXxDjItqfiAG8s8ZC10uDr9gVzvQ7l+erKh8Od3/N+kHoudy2XMV+K+qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(36756003)(478600001)(1076003)(5660300002)(66476007)(6512007)(6916009)(6506007)(86362001)(38100700002)(38350700002)(26005)(66556008)(83380400001)(2906002)(2616005)(316002)(54906003)(4326008)(6666004)(186003)(52116002)(8676002)(66946007)(8936002)(6486002)(956004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t4KsY8+YxE1GLnltrLReFrw7SmLnj9+OdU0iaK+O1Q43hkaQ/OQutS3mk1MU?=
 =?us-ascii?Q?2EFmYYyOlRQHB2NvR6aBPJDlt5mY+o5zoztA72z3XlSblspbDqKfRVmpVbqb?=
 =?us-ascii?Q?qwZNvew0/SfVZTUUwXw9Wvwr3UjA5XxUY3Boba6tY/Pa9lLPsOFPSbzdQtQN?=
 =?us-ascii?Q?hdFsLBPdCrJecIcQfhqlBZN2RezXt6ADAjNpTBKLc/IwWHqU5FvfZJHHrEV4?=
 =?us-ascii?Q?DJPHFF1T/nW+T/ByYKgPnNdhjelbru0G3leX19+NlfGST1Zb1+N5QW1fxuV+?=
 =?us-ascii?Q?5MTOEvJ1KUK4c4tqWn5xkz83OWTISinEbu/SpGmn/LlbvSYEhvaQKb8MwdSJ?=
 =?us-ascii?Q?u6hR+yia1cxI0IXFP4ApvKVrK7Du4K6mxJ70FaRewcAYPIP7pXMKq5ELfT6R?=
 =?us-ascii?Q?ly4Unl3QKHSbi1/NZQJiRJEtSb3V8HMGo1DzpOTIKpA6KkVXRmBpAOOxb9s9?=
 =?us-ascii?Q?FjRhqXjxm1xa0YdPwfKifqN8kWDttQc+rtCTksDDy+tHuQvRPVfa2qkZvm3/?=
 =?us-ascii?Q?gSJnCPfaosjH/AtHJ5my2JahL1530iwOcbHeKlPU0GvzC51+OnuuQNjcuqgI?=
 =?us-ascii?Q?qmNkYoZ7Cg+UohEuJVKsL9dnO9HEPz31DgXuqasGT2OX2P2Ud/UpPcxVQNVe?=
 =?us-ascii?Q?Je99ZgZk+8Q6JrAfkbr+/3VXErei930xFRFTxh6fXpD3DIj0ZwcZE/qc3IJZ?=
 =?us-ascii?Q?GVVJTKrNSpjHqN13FKddFV5rND79elAbRFKYYHEVPrhM7Sl5uL5g8MdJv+TS?=
 =?us-ascii?Q?XZxh+Wm6wsXkBvkXS8pwUD9bXXBb1ZRLMQJwz4LMB9Z3Xz/mZtOf0dUngTcT?=
 =?us-ascii?Q?O9HdXFhBEaBwc6OPQJDbtvxRRrwnfxYuSkiU3AiY2htXaB1cFPi2pwntsqjd?=
 =?us-ascii?Q?TDQfXvFJInGcO1/gg9dCTLj1IWEhQt3rFxuDGlXF5JhNCx3LF74PtyI0XGSs?=
 =?us-ascii?Q?jxXtglykopj3I4QjXMeJO6MIWKdA/JWbUybjaEKGjUCsa4swSqThasZOq5Vx?=
 =?us-ascii?Q?myl2bvdaCaP21Rv6JZQcg2Hu1/OndRGL9N3aeiInSkMas+U2P1IQDUMv0X3U?=
 =?us-ascii?Q?792DRfqh34LTNa19F5VCLxsRQkxHZzlCH5LS8wl4VF32hYHRSacEXa2CRi9/?=
 =?us-ascii?Q?qrSWSL6PmlxypFqinTRtt0D+LfZPci2R8MR+4Zoes9OfwT97L1ffgnGK4ug7?=
 =?us-ascii?Q?KDfF3N3mgt4DJdVMxXQRdX4D/AmWPcG0PSg8QCgsxyI5lXKdG/1f+/ttf0Cc?=
 =?us-ascii?Q?8zEgWqis1k7qKiTRQX9FFgcBwaodUvzbhlUvDYeb6AEgXSNMm1XGPvuz0pfH?=
 =?us-ascii?Q?reEYscQMaVYfn6O3r3RABMOl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 149ad2b0-4808-454b-af72-08d966603f4a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 18:03:01.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INFeMs1YYUmXMqBsSwcZBo6fpJF4XjRiS8tdUQuPNZkgRd8VTJ+WPh/4GMRWNgInImV1nGvwyLmFP/z3v4bzDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in commit e358bef7c392 ("net: dsa: Give drivers the chance
to veto certain upper devices"), the hellcreek driver uses some tricks
to comply with the network stack expectations: it enforces port
separation in standalone mode using VLANs. For untagged traffic,
bridging between ports is prevented by using different PVIDs, and for
VLAN-tagged traffic, it never accepts 8021q uppers with the same VID on
two ports, so packets with one VLAN cannot leak from one port to another.

That is almost fine*, and has worked because hellcreek relied on an
implicit behavior of the DSA core that was changed by the previous
patch: the standalone ports declare the 'rx-vlan-filter' feature as 'on
[fixed]'. Since most of the DSA drivers are actually VLAN-unaware in
standalone mode, that feature was actually incorrectly reflecting the
hardware/driver state, so there was a desire to fix it. This leaves the
hellcreek driver in a situation where it has to explicitly request this
behavior from the DSA framework.

We configure the ports as follows:

- Standalone: 'rx-vlan-filter' is on. An 8021q upper on top of a
  standalone hellcreek port will go through dsa_slave_vlan_rx_add_vid
  and will add a VLAN to the hardware tables, giving the driver the
  opportunity to refuse it through .port_prechangeupper.

- Bridged with vlan_filtering=0: 'rx-vlan-filter' is off. An 8021q upper
  on top of a bridged hellcreek port will not go through
  dsa_slave_vlan_rx_add_vid, because there will not be any attempt to
  offload this VLAN. The driver already disables VLAN awareness, so that
  upper should receive the traffic it needs.

- Bridged with vlan_filtering=1: 'rx-vlan-filter' is on. An 8021q upper
  on top of a bridged hellcreek port will call dsa_slave_vlan_rx_add_vid,
  and can again be vetoed through .port_prechangeupper.

*It is not actually completely fine, because if I follow through
correctly, we can have the following situation:

ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0 # lan0 now becomes VLAN-unaware
ip link set lan0 nomaster # lan0 fails to become VLAN-aware again, therefore breaking isolation

This patch fixes that corner case by extending the DSA core logic, based
on this requested attribute, to change the VLAN awareness state of the
switch (port) when it leaves the bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 +++
 net/dsa/slave.c                        | 11 +++++++----
 net/dsa/switch.c                       | 21 ++++++++++++++++-----
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 5c54ae1be62c..3faff95fd49f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1345,6 +1345,7 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	 * filtering setups are not supported.
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->needs_standalone_vlan_filtering = true;
 
 	/* Intercept _all_ PTP multicast traffic */
 	ret = hellcreek_setup_fdb(hellcreek);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index c7ea0f61056f..f9a17145255a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -363,6 +363,9 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Keep VLAN filtering enabled on ports not offloading any upper. */
+	bool			needs_standalone_vlan_filtering;
+
 	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
 	 * that have vlan_filtering=0. All drivers should ideally set this (and
 	 * then the option would get removed), but it is unknown whether this
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index cabfe3f9b2c6..662ff531d4e2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1435,11 +1435,12 @@ static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
  * To summarize, a DSA switch port offloads:
  *
  * - If standalone (this includes software bridge, software LAG):
- *     - if ds->vlan_filtering_is_global = true AND there are bridges spanning
- *       this switch chip which have vlan_filtering=1:
+ *     - if ds->needs_standalone_vlan_filtering = true, OR if
+ *       (ds->vlan_filtering_is_global = true AND there are bridges spanning
+ *       this switch chip which have vlan_filtering=1)
  *         - the 8021q upper VLANs
- *     - else (VLAN filtering is not global, or it is, but no port is under a
- *       VLAN-aware bridge):
+ *     - else (standalone VLAN filtering is not needed, VLAN filtering is not
+ *       global, or it is, but no port is under a VLAN-aware bridge):
  *         - no VLAN (any 8021q upper is a software VLAN)
  *
  * - If under a vlan_filtering=0 bridge which it offload:
@@ -1889,6 +1890,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
 		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+	if (ds->needs_standalone_vlan_filtering)
+		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index dd042fd7f800..1c797ec8e2c2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -116,9 +116,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
-	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
+	bool change_vlan_filtering = false;
+	bool vlan_filtering;
 	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
@@ -131,6 +132,15 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->br);
 
+	if (ds->needs_standalone_vlan_filtering && !br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = true;
+	} else if (!ds->needs_standalone_vlan_filtering &&
+		   br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = false;
+	}
+
 	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
 	 * event for changing vlan_filtering setting upon slave ports leaving
 	 * it. That is a good thing, because that lets us handle it and also
@@ -139,21 +149,22 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * vlan_filtering callback is only when the last port leaves the last
 	 * VLAN-aware bridge.
 	 */
-	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
+	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
 		for (port = 0; port < ds->num_ports; port++) {
 			struct net_device *bridge_dev;
 
 			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
 
 			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
-				unset_vlan_filtering = false;
+				change_vlan_filtering = false;
 				break;
 			}
 		}
 	}
-	if (unset_vlan_filtering) {
+
+	if (change_vlan_filtering) {
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false, &extack);
+					      vlan_filtering, &extack);
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-- 
2.25.1

