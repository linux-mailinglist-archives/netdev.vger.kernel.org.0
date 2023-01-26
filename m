Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B4E67D271
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjAZRCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjAZRCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E987A65344
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpFLZEMKGKXFkS330YUCb4BZG4PHFzljSraqLoxDO1rOinxrF7EpbzXL9eUvje4czmUaZsFqffqrQnxfVajaddcPh6ywxeS/XaY+nzsnM9Mkjg+AnGREDoB6/N2uVC8b/z2EdxqCpHgvu7XehOgdIFs8oPS+yKZu14rOe8Tx6lzsEkFTiSC0fN7DIIGI2VKSAdOZctZmglt8n2R8rk4t5DcoPLKNA6RkSg2oFkJP9hd+Lx0DWOIbB4BtR4hbFmhpVFjA3lvUYPUVyqUDEGKMGbttcGgwOCUGBYe9fkcgQNJ+GPVKtH/m/89Y8u9PSP4JAwMGD3xfVAwEWXTesxMbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X029sGX27cDJhgLDWLZ6c3TK6OixRSGUfP5bG6mE5Cc=;
 b=JSBOk/q5dxpetcJoSCYI4DM/Lfk4AQORvfgclnLOeQJQyUE51kNeD4iaTZifXHTUslAnyBvLFPwAjlHrA+NxQW+d+S8XYD5YjTYVcPaHa5tenCl4z+/h5hvKFrAyAzNh4CxUd8pgLMo6HJIZ06Ep0/Us4tT42HvW75KH4+p1HHwmDm7Jiv4xGDJJCP2Yk8gaOlY4lDeszT9PfOk5XvDiczsLZN37ZTXVcQmqdMVLVeaY7FBX4LC+2BayjGjFqrsnFa6Zz8NMvSC2gNmwBKOwyLl0/o1EzVBxlgArK5xnwFefULIaiZyHQXzETQsl1GePhYajASKJWFUXqoVkLoB9nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X029sGX27cDJhgLDWLZ6c3TK6OixRSGUfP5bG6mE5Cc=;
 b=VRWQ/1rn8239O6a3+mBWPo4oAjOA7zD/RoW82krzuPCDVmjnnRmF7SrcExd7tJ/AyCgEejMBRawp/NdYzAiR6n+a5j7sssaUWwNAFWGuzjaK2tO8RtpK45ynGbqpzn0YG8ou1oKKeJswFup0W6xYJ8BA7LCe6yZeNWIpzcjbAYJiifT3hShCTU3Tjnmi5MIZ4lAzdaCrUrwkjoFHANcO1BM+5UgBabHo67nWAA0D7aFHPL0mKWSUZY2t1gHWyIN6E7lsjF6CuBPRmrHlQ2Jq/aISNzxa3ekw5ll+yWCaR9QSh9QOBp6EnyBTzKA02tIbKM+YZ4lyerfp9s8C4/FdcA==
Received: from MW4PR04CA0070.namprd04.prod.outlook.com (2603:10b6:303:6b::15)
 by MN0PR12MB6343.namprd12.prod.outlook.com (2603:10b6:208:3c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:25 +0000
Received: from CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::ad) by MW4PR04CA0070.outlook.office365.com
 (2603:10b6:303:6b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT091.mail.protection.outlook.com (10.13.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:13 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:10 -0800
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
Subject: [PATCH net-next 08/16] net: bridge: Add netlink knobs for number / maximum MDB entries
Date:   Thu, 26 Jan 2023 18:01:16 +0100
Message-ID: <1bb4bfeaeb14e4b484c6d71adef0b21686468153.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT091:EE_|MN0PR12MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e02a4b-1c9f-4add-898a-08daffbf18ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zega1avAN2p/gL4P8gv8GJQJYw6A0raHG9zhyE3Q7LrL2NBL3MdfKZBszZjH4VDNogEh7GM4jrZfK0ZjkY2DbSi8f8XezKJ4NjFyX1g6TDCEn9HVX2jxnJ4vqnwS0NwOBHenuoSA3APGxXSN4BakUUOrCdkAuDJ+yEQvMP0JcCYHAHOGoAAugljDeSgU29p2t3BnYCOsYLk2QALSFJeni8xNUnEG358yzo1gCfS1oC3H/E1+O1XC0BmdG/auWz/0HoxYqJ28Gn6gBHRs4T1Qm6IBQwScVFrjHHyEGC1DNJgxwDY7VgVGIZlCnnPtfULR63jj87DNyt7tGUaxUUAhkfp4esFoZdb6ZiwjT1UwRtuFO6OwlgT0+VoXtLt6EBZJNd9keVYVvHoYS8S2mem9lyCh6SwJPP8LoRs+18oIL/sMCvsJ3DuuXbqHxZG5JWzVWZ7ZoS/nBBR+osZjRec2jWwuMaBtS7KvOwaAoB8YPo1xO9ojpY7EUz75ZFABJ2UJzxk5VXqD6T3ZO5OhFROD4e0a/xn/tR0Uc+QJIaBc8LbVIdOYPLl31F3MIyEgkbIb63sz66+wXrOeJBHpp8xBkyLOryJy3sFjDCQyVk+pl0jxb9T89P9St7pkY2bVOsnmvpoc8cZda8tRg52hLFe9v2gsaIX+nFEawy8Kg9Wp9gHZEu1FKjRqIYGtv0r9HQ0/18LxQyQmiQ565DjI9P/LLg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(5660300002)(8936002)(30864003)(2906002)(41300700001)(4326008)(70206006)(70586007)(8676002)(82310400005)(54906003)(316002)(110136005)(186003)(16526019)(40460700003)(26005)(36756003)(107886003)(2616005)(478600001)(83380400001)(7636003)(426003)(47076005)(36860700001)(66574015)(336012)(356005)(40480700001)(86362001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:24.7400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e02a4b-1c9f-4add-898a-08daffbf18ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6343
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch added accounting for number of MDB entries per port and
per port-VLAN, and the logic to verify that these values stay within
configured bounds. However it didn't provide means to actually configure
those bounds or read the occupancy. This patch does that.

Two new netlink attributes are added for the MDB occupancy:
IFLA_BRPORT_MCAST_N_GROUPS for the per-port occupancy and
BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS for the per-port-VLAN occupancy.
And another two for the maximum number of MDB entries:
IFLA_BRPORT_MCAST_MAX_GROUPS for the per-port maximum, and
BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS for the per-port-VLAN one.

Note that the two new IFLA_BRPORT_ attributes prompt bumping of
RTNL_SLAVE_MAX_TYPE to size the slave attribute tables large enough.

The new attributes are used like this:

 # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
                                      mcast_vlan_snooping 1 mcast_querier 1
 # ip link set dev v1 master br
 # bridge vlan add dev v1 vid 2

 # bridge vlan set dev v1 vid 1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
 # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
 Error: bridge: Port-VLAN is already a member in mcast_max_groups (1) groups.

 # bridge link set dev v1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
 Error: bridge: Port is already a member in mcast_max_groups (1) groups.

 # bridge -d link show
 5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
     [...] mcast_n_groups 1 mcast_max_groups 1

 # bridge -d vlan show
 port              vlan-id
 br                1 PVID Egress Untagged
                     state forwarding mcast_router 1
 v1                1 PVID Egress Untagged
                     [...] mcast_n_groups 1 mcast_max_groups 1
                   2
                     [...] mcast_n_groups 0 mcast_max_groups 0

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  2 +
 include/uapi/linux/if_link.h   |  2 +
 net/bridge/br_multicast.c      | 96 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        | 19 ++++++-
 net/bridge/br_private.h        | 16 +++++-
 net/bridge/br_vlan.c           | 11 ++--
 net/bridge/br_vlan_options.c   | 33 +++++++++++-
 net/core/rtnetlink.c           |  2 +-
 8 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index d9de241d90f9..d60c456710b3 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -523,6 +523,8 @@ enum {
 	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
 	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1021a7e47a86..1bed3a72939c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -564,6 +564,8 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
 	IFLA_BRPORT_MAB,
+	IFLA_BRPORT_MCAST_N_GROUPS,
+	IFLA_BRPORT_MCAST_MAX_GROUPS,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de531109b947..04261dd2380b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -766,6 +766,102 @@ static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
 	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
 }
 
+static int
+br_multicast_pmctx_ngroups_set_max(struct net_bridge_mcast_port *pmctx,
+				   u32 max, struct netlink_ext_ack *extack)
+{
+	if (max && max < pmctx->mdb_n_entries) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Can't set mcast_max_groups=%u, which is below mcast_n_groups=%u",
+				       max, pmctx->mdb_n_entries);
+		return -EINVAL;
+	}
+
+	pmctx->mdb_max_entries = max;
+	return 0;
+}
+
+u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port)
+{
+	u32 n;
+
+	spin_lock_bh(&port->br->multicast_lock);
+	n = port->multicast_ctx.mdb_n_entries;
+	spin_unlock_bh(&port->br->multicast_lock);
+
+	return n;
+}
+
+int br_multicast_vlan_ngroups_get(struct net_bridge *br,
+				  const struct net_bridge_vlan *v,
+				  u32 *n)
+{
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
+		return -EINVAL;
+
+	spin_lock_bh(&br->multicast_lock);
+	*n = v->port_mcast_ctx.mdb_n_entries;
+	spin_unlock_bh(&br->multicast_lock);
+
+	return 0;
+}
+
+int br_multicast_port_ngroups_set_max(struct net_bridge_port *port, u32 max,
+				      struct netlink_ext_ack *extack)
+{
+	int err;
+
+	spin_lock_bh(&port->br->multicast_lock);
+	err = br_multicast_pmctx_ngroups_set_max(&port->multicast_ctx, max,
+						 extack);
+	spin_unlock_bh(&port->br->multicast_lock);
+
+	return err;
+}
+
+int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
+				      struct net_bridge_vlan *v, u32 max,
+				      struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multicast snooping disabled on this VLAN");
+		return -EINVAL;
+	}
+
+	spin_lock_bh(&br->multicast_lock);
+	err = br_multicast_pmctx_ngroups_set_max(&v->port_mcast_ctx, max,
+						 extack);
+	spin_unlock_bh(&br->multicast_lock);
+
+	return err;
+}
+
+u32 br_multicast_port_ngroups_get_max(const struct net_bridge_port *port)
+{
+	u32 max;
+
+	spin_lock_bh(&port->br->multicast_lock);
+	max = port->multicast_ctx.mdb_max_entries;
+	spin_unlock_bh(&port->br->multicast_lock);
+
+	return max;
+}
+
+int br_multicast_vlan_ngroups_get_max(struct net_bridge *br,
+				      const struct net_bridge_vlan *v,
+				      u32 *max)
+{
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
+		return -EINVAL;
+
+	spin_lock_bh(&br->multicast_lock);
+	*max = v->port_mcast_ctx.mdb_max_entries;
+	spin_unlock_bh(&br->multicast_lock);
+
+	return 0;
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a6133d469885..063c1646dfe8 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -202,6 +202,8 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size_64bit(sizeof(u64)) /* IFLA_BRPORT_HOLD_TIMER */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_N_GROUPS */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_MAX_GROUPS */
 #endif
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
@@ -298,7 +300,11 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 			p->multicast_eht_hosts_limit) ||
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
-			p->multicast_eht_hosts_cnt))
+			p->multicast_eht_hosts_cnt) ||
+	    nla_put_u32(skb, IFLA_BRPORT_MCAST_N_GROUPS,
+			br_multicast_port_ngroups_get(p)) ||
+	    nla_put_u32(skb, IFLA_BRPORT_MCAST_MAX_GROUPS,
+			br_multicast_port_ngroups_get_max(p)))
 		return -EMSGSIZE;
 #endif
 
@@ -883,6 +889,8 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_MAB] = { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
+	[IFLA_BRPORT_MCAST_N_GROUPS] = { .type = NLA_REJECT },
+	[IFLA_BRPORT_MCAST_MAX_GROUPS] = { .type = NLA_U32 },
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -1017,6 +1025,15 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+
+	if (tb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
+		u32 max_groups;
+
+		max_groups = nla_get_u32(tb[IFLA_BRPORT_MCAST_MAX_GROUPS]);
+		err = br_multicast_port_ngroups_set_max(p, max_groups, extack);
+		if (err)
+			return err;
+	}
 #endif
 
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 49f411a0a1f1..86b7a221e806 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -978,6 +978,19 @@ void br_multicast_uninit_stats(struct net_bridge *br);
 void br_multicast_get_stats(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
 			    struct br_mcast_stats *dest);
+u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port);
+int br_multicast_vlan_ngroups_get(struct net_bridge *br,
+				  const struct net_bridge_vlan *v,
+				  u32 *n);
+int br_multicast_port_ngroups_set_max(struct net_bridge_port *port,
+				      u32 max, struct netlink_ext_ack *extack);
+int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
+				      struct net_bridge_vlan *v, u32 max,
+				      struct netlink_ext_ack *extack);
+u32 br_multicast_port_ngroups_get_max(const struct net_bridge_port *port);
+int br_multicast_vlan_ngroups_get_max(struct net_bridge *br,
+				      const struct net_bridge_vlan *v,
+				      u32 *max);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1761,7 +1774,8 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 			   const struct net_bridge_vlan *range_end);
-bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
+		       const struct net_bridge_port *p);
 size_t br_vlan_opts_nl_size(void);
 int br_vlan_process_options(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bc75fa1e4666..8a3dbc09ba38 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1816,6 +1816,7 @@ static bool br_vlan_stats_fill(struct sk_buff *skb,
 /* v_opts is used to dump the options which must be equal in the whole range */
 static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts,
+			      const struct net_bridge_port *p,
 			      u16 flags,
 			      bool dump_stats)
 {
@@ -1842,7 +1843,7 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 		goto out_err;
 
 	if (v_opts) {
-		if (!br_vlan_opts_fill(skb, v_opts))
+		if (!br_vlan_opts_fill(skb, v_opts, p))
 			goto out_err;
 
 		if (dump_stats && !br_vlan_stats_fill(skb, v_opts))
@@ -1925,7 +1926,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		goto out_kfree;
 	}
 
-	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags, false))
+	if (!br_vlan_fill_vids(skb, vid, vid_range, v, p, flags, false))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -2030,7 +2031,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
 					       range_end->vid, range_start,
-					       vlan_flags, dump_stats)) {
+					       p, vlan_flags, dump_stats)) {
 				err = -EMSGSIZE;
 				break;
 			}
@@ -2056,7 +2057,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 		else if (!dump_global &&
 			 !br_vlan_fill_vids(skb, range_start->vid,
 					    range_end->vid, range_start,
-					    br_vlan_flags(range_start, pvid),
+					    p, br_vlan_flags(range_start, pvid),
 					    dump_stats))
 			err = -EMSGSIZE;
 	}
@@ -2131,6 +2132,8 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
 	[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]	= { .type = NLA_REJECT },
+	[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]	= { .type = NLA_U32 },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a2724d03278c..43d8f11ce79c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -48,7 +48,8 @@ bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 	       curr_mc_rtr == range_mc_rtr;
 }
 
-bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
+		       const struct net_bridge_port *p)
 {
 	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE, br_vlan_get_state(v)) ||
 	    !__vlan_tun_put(skb, v))
@@ -58,6 +59,20 @@ bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 		       br_vlan_multicast_router(v)))
 		return false;
+	if (p && !br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
+		u32 mdb_max_entries;
+		u32 mdb_n_entries;
+
+		if (br_multicast_vlan_ngroups_get(p->br, v, &mdb_n_entries) ||
+		    nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+				mdb_n_entries))
+			return false;
+		if (br_multicast_vlan_ngroups_get_max(p->br, v,
+						      &mdb_max_entries) ||
+		    nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
+				mdb_max_entries))
+			return false;
+	}
 #endif
 
 	return true;
@@ -70,6 +85,8 @@ size_t br_vlan_opts_nl_size(void)
 	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_TINFO_ID */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	       + nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_MCAST_ROUTER */
+	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS */
+	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS */
 #endif
 	       + 0;
 }
@@ -212,6 +229,20 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 			return err;
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]) {
+		u32 val;
+
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't set mcast_max_groups for non-port vlans");
+			return -EINVAL;
+		}
+
+		val = nla_get_u32(tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]);
+		err = br_multicast_vlan_ngroups_set_max(p->br, v, val, extack);
+		if (err)
+			return err;
+		*changed = true;
+	}
 #endif
 
 	return 0;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 64289bc98887..e786255a8360 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -58,7 +58,7 @@
 #include "dev.h"
 
 #define RTNL_MAX_TYPE		50
-#define RTNL_SLAVE_MAX_TYPE	40
+#define RTNL_SLAVE_MAX_TYPE	42
 
 struct rtnl_link {
 	rtnl_doit_func		doit;
-- 
2.39.0

