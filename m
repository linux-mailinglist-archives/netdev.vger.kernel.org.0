Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D2E686CF4
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBARaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjBAR36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:58 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C1315C99
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxZJWl+fvKuYqyzVcRb4uReGfDXF7vf/K0LB9mhA7nnVHk/jDRXlLpZAq4KG/Lvna+LqLMSR2B16W4p58Mais+xfE5V/Yz22gDlUwE+2Dl3gHA3z9nF9WVMfTYm5AzwkE9ahFBHxWIz52N2yGfL/69tSMoIk+ko2kUXZRKqbCkgoba+F2rq7O+sG5fnllG76yUuMQUEb+oL2eRrICxYhyrJXgnNsE/LJAgQnWJBTjjO1SzXAf1fhd4ik7a4sil5LIuLnBZtExBrZf/WmamYW9N3+y45Eb3FbCFQ6aKoF9W2mS9KmV10dVoqUk5Yvbv3csQUismjflOivRfId16WBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iMJv5HbTQCreuk4/fhO/OibPvECQCMZHfD/LrjSlIw=;
 b=ByYTjt8vm4kNsTrcGeUYygQHemGu0ChzPMg3jfGoVtpp4bcOTTmsdmR364fCG6zQSkb6rjN5sVQl06aws274nJ9LrhYki7LnCfvw8WyRJ8XX7vUC7/3QkxZ78gqRoF8qvTVw+CLdgU+SU+cj3z+Li9Ed0eoY2qRTKnIixoK0796JxzEkBkdTLAYlvKS/WxO9sqsaGRGUADeHxOH2geaAY3WhjtopOClh7TiAkSX5kehSN7caSGi3+15GjwciuCtvRqSNGER/8a/5Psa/lGF4fnsGRQWOb4jdg98WcQeZ+I00dhrDx1Nl0MqysDjh6PrTlKd2JrVjwimw3gAQJiF3aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iMJv5HbTQCreuk4/fhO/OibPvECQCMZHfD/LrjSlIw=;
 b=DwaFb9lFmexfGItUT6/3dsFBsZs2C3MsA4Y4lHohtOwNpGQwLqn3L+ELkcj6S93wbYcRqXoZP8Y/1oIXgpP95/EUAI86ja1ZZYNaHBjj1UxrpOXMQ/k1WDkLnT7+ymteMy8goByzxoe1Ca/yUEIuJ7Xd+PwGTVM1RLEDzQaD5fafTiXPLeGsRFiN5vx1NRna5J2CQHlEdcor42WRwNi88VdFr/EeyQI1xAKNdrJnTYIWJztObu193qGIIGvmJOBx1JAbfSdPD/o+hn+CLCmiH02MbZ4pfDEf2XPU4VdI8g0snF6RfmAp4E1iP0YaX8WEA2NbPefFuBQ6xtbPYvZ3RQ==
Received: from MN2PR12CA0020.namprd12.prod.outlook.com (2603:10b6:208:a8::33)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:43 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:208:a8:cafe::54) by MN2PR12CA0020.outlook.office365.com
 (2603:10b6:208:a8::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:30 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:27 -0800
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
Subject: [PATCH net-next mlxsw v2 08/16] net: bridge: Add netlink knobs for number / maximum MDB entries
Date:   Wed, 1 Feb 2023 18:28:41 +0100
Message-ID: <7b9f6524716a9e2ce33b9383e3216fed2f432201.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|BL1PR12MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b7606a-828d-4a29-4794-08db0479e833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Bg3BKBQ/fbkUwFP9qE6+NvdqWR8gqb73FGuWR0fYWW5dAQAwL/onKsBs3EB2/ZqJKqHVW2UAS0dz/XfA1MnFm6PEI3jWWQPYPWRPobv8egVfoPY3HTTPVeGf/KeLRuwJ301sAcPUQ8cg2BNt+ZW+oC74VGLUXOYLd+f9taZ3k9nIG5RCrgdDaXwt7LM/yzO+sk8biyIYzSWyErESgZQ9PLxAJvq+IXwjGkFprtbhp9RZ8oZxxB+Oy3+yqPgHncgNZfGDr42WiX+tZnLFv5gn8Wa8NVDi2aEx4mxPuO5FyD7zk+/tQ/loqQQtOkMgDj+wDvsoEwByUCeRBhzukXSWHQW7HFzM8aK2yJBbpjwIpR/eMvAq1gj+1+JV2OTLNJ6TBjIrX9NohDkvlPTL8QaD+3yVEZmUX8TIAXWtlyDYdOP4+bYi4sfMN2mnflJogau8m1/AXu0n+6pb+dQBSrTowYxiWsuYK0UxorwSs86F8P1C7gTpMD579KplE0Vo/pw3oUXo6M7buXqPaBqfa0L0ti2PJ15NnUTbKKaNt8wto+Y0/MXeY7ZaYYBcTk2scsMJf/hEDhtDoAqhrNxkiXts5Fnnx9BqdH0AvlHHo99Y733Te+rgF5TnNIDTldU7muUdm5OzHypnJKKkNu2o4xHq+rw4AnMUaNsgEUd9FnMYMOxR6prvWsGIGFPxIh1FeRAJ7Qd4RHcUes56Au9wVV5Dw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(46966006)(36840700001)(40470700004)(356005)(86362001)(36860700001)(82740400003)(36756003)(41300700001)(70206006)(70586007)(5660300002)(110136005)(7636003)(316002)(8676002)(4326008)(54906003)(8936002)(82310400005)(40460700003)(30864003)(66574015)(2906002)(336012)(40480700001)(426003)(2616005)(47076005)(83380400001)(478600001)(186003)(26005)(16526019)(107886003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:43.4254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b7606a-828d-4a29-4794-08db0479e833
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
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
---

Notes:
    v2:
    - Drop locks around accesses in
      br_multicast_{port,vlan}_ngroups_{get,set_max}(),
    - Drop bounces due to max<n in
      br_multicast_{port,vlan}_ngroups_set_max().

 include/uapi/linux/if_bridge.h |  2 ++
 include/uapi/linux/if_link.h   |  2 ++
 net/bridge/br_multicast.c      | 50 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        | 17 +++++++++++-
 net/bridge/br_private.h        | 15 +++++++++-
 net/bridge/br_vlan.c           | 11 +++++---
 net/bridge/br_vlan_options.c   | 33 +++++++++++++++++++++-
 net/core/rtnetlink.c           |  2 +-
 8 files changed, 124 insertions(+), 8 deletions(-)

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
index e7ae339a8757..393ffc21c3e8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -768,6 +768,56 @@ static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
 	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
 }
 
+u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port)
+{
+	return READ_ONCE(port->multicast_ctx.mdb_n_entries);
+}
+
+int br_multicast_vlan_ngroups_get(struct net_bridge *br,
+				  const struct net_bridge_vlan *v,
+				  u32 *n)
+{
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
+		return -EINVAL;
+
+	*n = READ_ONCE(v->port_mcast_ctx.mdb_n_entries);
+	return 0;
+}
+
+void br_multicast_port_ngroups_set_max(struct net_bridge_port *port, u32 max)
+{
+	WRITE_ONCE(port->multicast_ctx.mdb_max_entries, max);
+}
+
+int br_multicast_vlan_ngroups_set_max(struct net_bridge *br,
+				      struct net_bridge_vlan *v, u32 max,
+				      struct netlink_ext_ack *extack)
+{
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multicast snooping disabled on this VLAN");
+		return -EINVAL;
+	}
+
+	WRITE_ONCE(v->port_mcast_ctx.mdb_max_entries, max);
+	return 0;
+}
+
+u32 br_multicast_port_ngroups_get_max(const struct net_bridge_port *port)
+{
+	return READ_ONCE(port->multicast_ctx.mdb_max_entries);
+}
+
+int br_multicast_vlan_ngroups_get_max(struct net_bridge *br,
+				      const struct net_bridge_vlan *v,
+				      u32 *max)
+{
+	if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx))
+		return -EINVAL;
+
+	*max = READ_ONCE(v->port_mcast_ctx.mdb_max_entries);
+	return 0;
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a6133d469885..968d0963d9a9 100644
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
@@ -1017,6 +1025,13 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+
+	if (tb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
+		u32 max_groups;
+
+		max_groups = nla_get_u32(tb[IFLA_BRPORT_MCAST_MAX_GROUPS]);
+		br_multicast_port_ngroups_set_max(p, max_groups);
+	}
 #endif
 
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 49f411a0a1f1..98f3836efb84 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -978,6 +978,18 @@ void br_multicast_uninit_stats(struct net_bridge *br);
 void br_multicast_get_stats(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
 			    struct br_mcast_stats *dest);
+u32 br_multicast_port_ngroups_get(const struct net_bridge_port *port);
+int br_multicast_vlan_ngroups_get(struct net_bridge *br,
+				  const struct net_bridge_vlan *v,
+				  u32 *n);
+void br_multicast_port_ngroups_set_max(struct net_bridge_port *port, u32 max);
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
@@ -1761,7 +1773,8 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
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

