Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90454686CF3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjBARaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjBAR3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16086783EF
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8/+BGth+GOTA6W1BRYeXNJgvI1gg2T/iq4CUmbnLrxWDRVB7EEOmwXq2tLezK1wnD6GxlVKYzyziGLYnzCHiyv44TQ/k4l9KM8LmiUEcu8DIC5JqwWaJCma/A26cIaHlxP94hEVv9e452nkR9EdLANmzu8QteW1yo8XKaXqY+vQoOeOhHn4avmrWNrtpf/fD+lu26a6Hz5jOMnZpHkuzqtvAiQ85bgVttzTM7yLZhfTWmFjE3enPAHhgN8boaazHZwSrXSBRXnJqz9Dlr0nvKZ4YAWBxUBnyKj1ssRLv2kYvv4453vknvE1Pq3rirO3sxLXeSIziryH6RCetgSdOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdxOT8hga45jvdVP19SiFKaS4BJtGLG/uAo2D7DDn6U=;
 b=K/Zy+tZMBtLIcXNfxD2qitxA2fU1wT4y1vsEKmdLRxnp2dRQmZ6IDhEVhV5ZZmkqeAiMyjr/BXFLIo7RTeNmkgTNMKIkGnfmFQDMcf+ntrBeJzMh6FBhKs+Qg2cNFLhU9fpziMXaKPpsrWVCclUKbewKTEx6MG9ybj3HD3Ux1k4l5E7AxKWb1ooBi1k+KQ/0B13QPr8uWoMfXNTaw9mPhcyGIjpqiCahbpPSneQu7Q3c4lNr8C7sqqTqM1bVmNCIFQG9l50nuScK8Tg8Fk77F/YqZNiJmVYYXkR7Y5C3xlkFx37XuCenVyU367N2dR5NSDkEcHUG9EHAD79m7H0BMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdxOT8hga45jvdVP19SiFKaS4BJtGLG/uAo2D7DDn6U=;
 b=hwTdo+1aX4nqJCKU9TgbtoSsKKfw4I+TKYr0KfVf9ac8YAETEY+A8SkmonmzVfifLRqMmLqtZEVcutjc+d+k0NdUley62/8Dcarzu7WiM081eo42StuQJr+5IyBcY7gT/y59XrZ1VvxD5aAyahsUvMdIHQ0hbUu4CIv5PLdDlMV7c3hqzGXSU50tk94GQImDGyHvOpBZZ2Pd11pUyn1XoXA+OYrp63JyUtcPzLW6QL+z+lupvfgGzkEqi8tAMTMTZJ1E3ow/iR+k2gASw4W9fPziHoS/5hoZRlgnst9MJ+9/I2i/22yTv++R30+mJ24DGbukoNvzHGdncKI2/J/xRA==
Received: from DM6PR02CA0168.namprd02.prod.outlook.com (2603:10b6:5:332::35)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:40 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::6f) by DM6PR02CA0168.outlook.office365.com
 (2603:10b6:5:332::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:27 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:24 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next mlxsw v2 07/16] net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
Date:   Wed, 1 Feb 2023 18:28:40 +0100
Message-ID: <706d902460b69454ffeb57908beb8dce46e9b064.1675271084.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675271084.git.petrm@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|MN0PR12MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ab05b5-e4de-48a1-1a9c-08db0479e5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSNQixTeXr1gQ0nGib2JYh8Jp9mBNfOnalFBv3RApteqzz6eqQPYGq5+yKrzXljG4oZqXU/bYvl930nnOdOXaT5k2eZw1sqvWK+qGtLFOWxZ5WVGniYV83A+cDt6xz4tvXEW9DvvilEhu4n/6Oi4jmEdHtRX91hX+M02zAYKfR7E4KKVeUxChblz2s1YpyIZ13l3m1Ufqqvj1IS21JOKtxlNR2pF80AdkLE+T+qmx0ljUN++KnRoF/QZSQc/o6QcIKbhTa/4csENMlHSFTzYHNTkEL2v9NSFkccZ9G0vUuNBUcGcGy+jlPQp+FwZBGtzB+Xp+cuGMGuxyhSwP8tMhJa8hBbEs00eVvVekNBb3loTQ/UFwAMyQzxK5VEBByUJHW43luyDNibOcrmuxDdbUCvr51USxtYfLsTdKvT7pOYO4Vbxpi71wLRdUvVYvuAggdqmmQc8mpfxaTEK+PegfWUXW6AIhs9/90HmM8E8nfTv7e8Cj4Bp2DcaASkYOg52TO8ppCjgB6Py2gFOfTQ5SJZFux2QpL4HBYYBmPrqQ7h5CKv5YfoBN5o49QT6NW+dQytZEnpc871TiTmRlg3j03xIITm2z0ATidgkF/87K5eMDrdGmS+wIxobaIJToAvzfAMs0WvlsVH3GmMcb+s7KjWpRVeZnmdM2uW9pk2L/ShSBplNcMf0gJlbWIqwd+J7qaNKNYMpLuEfPscwtDgx0w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(46966006)(40470700004)(36840700001)(110136005)(5660300002)(54906003)(16526019)(82310400005)(356005)(316002)(36860700001)(82740400003)(7636003)(41300700001)(2616005)(186003)(70206006)(26005)(107886003)(36756003)(6666004)(83380400001)(8936002)(40480700001)(86362001)(478600001)(8676002)(426003)(70586007)(336012)(40460700003)(66574015)(47076005)(4326008)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:39.7315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ab05b5-e4de-48a1-1a9c-08db0479e5f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB maintained by the bridge is limited. When the bridge is configured
for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
capacity. In SW datapath, the capacity is configurable through the
IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
similar limit exists in the HW datapath for purposes of offloading.

In order to prevent the issue of unilateral exhaustion of MDB resources,
introduce two parameters in each of two contexts:

- Per-port and per-port-VLAN number of MDB entries that the port
  is member in.

- Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
  per-port-VLAN maximum permitted number of MDB entries, or 0 for
  no limit.

The per-port multicast context is used for tracking of MDB entries for the
port as a whole. This is available for all bridges.

The per-port-VLAN multicast context is then only available on
VLAN-filtering bridges on VLANs that have multicast snooping on.

With these changes in place, it will be possible to configure MDB limit for
bridge as a whole, or any one port as a whole, or any single port-VLAN.

Note that unlike the global limit, exhaustion of the per-port and
per-port-VLAN maximums does not cause disablement of multicast snooping.
It is also permitted to configure the local limit larger than hash_max,
even though that is not useful.

In this patch, introduce only the accounting for number of entries, and the
max field itself, but not the means to toggle the max. The next patch
introduces the netlink APIs to toggle and read the values.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - In br_multicast_port_ngroups_inc_one(), bounce
      if n>=max, not if n==max
    - Adjust extack messages to mention ngroups, now that
      the bounces appear when n>=max, not n==max
    - In __br_multicast_enable_port_ctx(), do not reset
      max to 0. Also do not count number of entries by
      going through _inc, as that would end up incorrectly
      bouncing the entries.

 net/bridge/br_multicast.c | 132 +++++++++++++++++++++++++++++++++++++-
 net/bridge/br_private.h   |   2 +
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 51b622afdb67..e7ae339a8757 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -31,6 +31,7 @@
 #include <net/ip6_checksum.h>
 #include <net/addrconf.h>
 #endif
+#include <trace/events/bridge.h>
 
 #include "br_private.h"
 #include "br_private_mcast_eht.h"
@@ -234,6 +235,29 @@ br_multicast_pg_to_port_ctx(const struct net_bridge_port_group *pg)
 	return pmctx;
 }
 
+static struct net_bridge_mcast_port *
+br_multicast_port_vid_to_port_ctx(struct net_bridge_port *port, u16 vid)
+{
+	struct net_bridge_mcast_port *pmctx = NULL;
+	struct net_bridge_vlan *vlan;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	if (!br_opt_get(port->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		return NULL;
+
+	/* Take RCU to access the vlan. */
+	rcu_read_lock();
+
+	vlan = br_vlan_find(nbp_vlan_group_rcu(port), vid);
+	if (vlan && !br_multicast_port_ctx_vlan_disabled(&vlan->port_mcast_ctx))
+		pmctx = &vlan->port_mcast_ctx;
+
+	rcu_read_unlock();
+
+	return pmctx;
+}
+
 /* when snooping we need to check if the contexts should be used
  * in the following order:
  * - if pmctx is non-NULL (port), check if it should be used
@@ -668,6 +692,82 @@ void br_multicast_del_group_src(struct net_bridge_group_src *src,
 	__br_multicast_del_group_src(src);
 }
 
+static int
+br_multicast_port_ngroups_inc_one(struct net_bridge_mcast_port *pmctx,
+				  struct netlink_ext_ack *extack)
+{
+	if (pmctx->mdb_max_entries &&
+	    pmctx->mdb_n_entries >= pmctx->mdb_max_entries)
+		return -E2BIG;
+
+	pmctx->mdb_n_entries++;
+	return 0;
+}
+
+static void br_multicast_port_ngroups_dec_one(struct net_bridge_mcast_port *pmctx)
+{
+	WARN_ON_ONCE(pmctx->mdb_n_entries-- == 0);
+}
+
+static int br_multicast_port_ngroups_inc(struct net_bridge_port *port,
+					 const struct br_ip *group,
+					 struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mcast_port *pmctx;
+	int err;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	/* Always count on the port context. */
+	err = br_multicast_port_ngroups_inc_one(&port->multicast_ctx, extack);
+	if (err) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Port is already in %u groups, and mcast_max_groups=%u",
+				       port->multicast_ctx.mdb_n_entries,
+				       port->multicast_ctx.mdb_max_entries);
+		trace_br_mdb_full(port->dev, group);
+		return err;
+	}
+
+	/* Only count on the VLAN context if VID is given, and if snooping on
+	 * that VLAN is enabled.
+	 */
+	if (!group->vid)
+		return 0;
+
+	pmctx = br_multicast_port_vid_to_port_ctx(port, group->vid);
+	if (!pmctx)
+		return 0;
+
+	err = br_multicast_port_ngroups_inc_one(pmctx, extack);
+	if (err) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Port-VLAN is already in %u groups, and mcast_max_groups=%u",
+				       pmctx->mdb_n_entries,
+				       pmctx->mdb_max_entries);
+		trace_br_mdb_full(port->dev, group);
+		goto dec_one_out;
+	}
+
+	return 0;
+
+dec_one_out:
+	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
+	return err;
+}
+
+static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
+{
+	struct net_bridge_mcast_port *pmctx;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	if (vid) {
+		pmctx = br_multicast_port_vid_to_port_ctx(port, vid);
+		if (pmctx)
+			br_multicast_port_ngroups_dec_one(pmctx);
+	}
+	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
@@ -702,6 +802,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
+	br_multicast_port_ngroups_dec(pg->key.port, pg->key.addr.vid);
 	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 
@@ -1165,6 +1266,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		trace_br_mdb_full(br->dev, group);
 		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
@@ -1288,11 +1390,16 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 			struct netlink_ext_ack *extack)
 {
 	struct net_bridge_port_group *p;
+	int err;
+
+	err = br_multicast_port_ngroups_inc(port, group, extack);
+	if (err)
+		return NULL;
 
 	p = kzalloc(sizeof(*p), GFP_ATOMIC);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
-		return NULL;
+		goto dec_out;
 	}
 
 	p->key.addr = *group;
@@ -1326,18 +1433,22 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 
 free_out:
 	kfree(p);
+dec_out:
+	br_multicast_port_ngroups_dec(port, group->vid);
 	return NULL;
 }
 
 void br_multicast_del_port_group(struct net_bridge_port_group *p)
 {
 	struct net_bridge_port *port = p->key.port;
+	__u16 vid = p->key.addr.vid;
 
 	hlist_del_init(&p->mglist);
 	if (!br_multicast_is_star_g(&p->key.addr))
 		rhashtable_remove_fast(&port->br->sg_port_tbl, &p->rhnode,
 				       br_sg_port_rht_params);
 	kfree(p);
+	br_multicast_port_ngroups_dec(port, vid);
 }
 
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1951,6 +2062,25 @@ static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 		br_ip4_multicast_add_router(brmctx, pmctx);
 		br_ip6_multicast_add_router(brmctx, pmctx);
 	}
+
+	if (br_multicast_port_ctx_is_vlan(pmctx)) {
+		struct net_bridge_port_group *pg;
+		u32 n = 0;
+
+		/* The mcast_n_groups counter might be wrong. First,
+		 * BR_VLFLAG_MCAST_ENABLED is toggled before temporary entries
+		 * are flushed, thus mcast_n_groups after the toggle does not
+		 * reflect the true values. And second, permanent entries added
+		 * while BR_VLFLAG_MCAST_ENABLED was disabled, are not reflected
+		 * either. Thus we have to refresh the counter.
+		 */
+
+		hlist_for_each_entry(pg, &pmctx->port->mglist, mglist) {
+			if (pg->key.addr.vid == pmctx->vlan->vid)
+				n++;
+		}
+		pmctx->mdb_n_entries = n;
+	}
 }
 
 void br_multicast_enable_port(struct net_bridge_port *port)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e4069e27b5c6..49f411a0a1f1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -126,6 +126,8 @@ struct net_bridge_mcast_port {
 	struct hlist_node		ip6_rlist;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 	unsigned char			multicast_router;
+	u32				mdb_n_entries;
+	u32				mdb_max_entries;
 #endif /* CONFIG_BRIDGE_IGMP_SNOOPING */
 };
 
-- 
2.39.0

