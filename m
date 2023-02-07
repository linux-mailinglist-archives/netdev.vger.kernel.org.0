Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7668D42D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBGK3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjBGK3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:29:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9562331E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoDCjF/LqD86gdUoXiPsAtlgcZhxT+rKlheDsuLz0nwW0M7vi+0oPJHj2IMGuYrPe+o7cX5ty9O+hNkDM6e+Y85Wfa7hdGtJJazj/Bq7092NnwYyWf6ymdk2EzeKAUq8e437F+wcYAgpltV8eREOz2sOhnfq6IaM4prGPSlRSTw287WJw/Geruk5VOngf3vrpdkno2YOGkVghM82vkg/Mcxxy9w4yieq/Qf1oK9/+gWNvgYvoaVhQuTF5kI8XY/p9hvHWjPw4BUPgjtzUtOi0XDyZj3C0C/EAduwT14fgig2iwMcX7SxtoMFtMxlzbHJdrHuL1sz54BO+W5pJa6rFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciCP2+eX726LTk4d1hqd2cR0o7KnodWBIwuVPv9/dJg=;
 b=LS50uYtbUTUD3fPS5slHYk/DGhpqFIgaX1p+6uC+MoCL+GD6Yf+PjHhZAZJAA2Oc6P5mvN4Xj+ZyZ0KnLajqfKeTgDfmlqAc+DJt6hCFmBGBeAKZkTcGbtzho8RvGLqoIsMIte2+P9y058AQKlPFx8JZZQeN6TepPHAMPcOOVkLWc7a3bF+zFyofmv/E9DmKLivusogIgpbxNr3Mne556DqCI3VP9r6RA4MB2Rx7vDaXtIsZWrEo3/SAUluzaBQD1DiTdFgU+TAlCEiVZMBky3ObJ51Zk/tNeT28PeuKm9QVDD8xQsrzgDu5VC2TzBJPeWaWNhDajMDl7OSURmLhsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciCP2+eX726LTk4d1hqd2cR0o7KnodWBIwuVPv9/dJg=;
 b=NY7gnk4V7OStLqr7/kMoMo5gsmhxZ2YK8XvNy6ygNHIomfmlGFJDrqsvnb2f3Erfc6aATCviHlCCvsfUPVQg38SJvlsr0ZwMnUxUhQNL+vLoCotCOTFz8oUO8qRZeE+SHmfeJvIuNmJiSn356k/0BHm3JXbV/+FHgkmbJl4kWD28lNh/TFL2/xLFvNBO50XVw9QlQ+qtn1Vu1JPDEPrYCmBLRmDoqmcswiMufTSDVI4q0rq56vZr/48ySgjdwYWIka53XpVFtwgJsyJ63aRiqMNPMOU5mip1oR5mcLy9OXz50cBUc81lciUmY3aICRTFA1cdIlbryJ/f5XWKKm6IVQ==
Received: from DM6PR17CA0014.namprd17.prod.outlook.com (2603:10b6:5:1b3::27)
 by PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 10:29:26 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::69) by DM6PR17CA0014.outlook.office365.com
 (2603:10b6:5:1b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Tue, 7 Feb 2023 10:29:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35 via Frontend Transport; Tue, 7 Feb 2023 10:29:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:13 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:11 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 2/3] bridge: Add support for mcast_n_groups, mcast_max_groups
Date:   Tue, 7 Feb 2023 11:27:49 +0100
Message-ID: <c0c38c4991999a35ea562e0b6185e14d035d6ff1.1675765297.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675765297.git.petrm@nvidia.com>
References: <cover.1675765297.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|PH8PR12MB6938:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a89448d-867c-4066-f550-08db08f63007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sc9zFpiy2dPWSrmCoXhBGYNzJdyfVW5VsUhS2jzyPma/PzqRNYeupIsh8XuHw2Wli9n+ysuge32TnQKR5+zebkSsJPZfxmnqLKAyFiIcDAXBRuodyWwfjxRVlRNrfEythYol4Zi/L+2LZZk4u8Mr7twshEC0Lm1HHWNghq1ybu+yoVcnoJ8aa7axQpB2oBKqYnjppbk7Tf1OVnhx9XdHTu9FTTUdCBZv4BKO2emF4rgmj4i+X3rmThAOJAZ+Uqy+Xy0NBIQ21OoSkJ5tuSwCjak+6ZTSSOER945eIpQTJWa4FwRzmUVe8MN0hpBighHkRmGfc3ByMB3MkqasrNuGE/taMz2Qr3jR9wgNi/x7Jpa23PRfKAKfw4Y9nNSceaSSRR/9bAAiWtZay6/QnxPQ7WuRNcR3PW+J61pcY0R+hLJluundYw/xy5xHPDEtke+1nFueae4VOuAZ4UXHDJMzbiIusjzBZSFGMa3xJVrN6fu7CKHRSbWAyn30rhtPzaST5gWB8XgYKWhVhMsGWr4Skesf0h5q1LesyqVuMPH/zxKkZpW3D9+sPGq8jmcMWJ9TuOuZPd4hdIapiITt4KXVgvenacNl+lgwj1TvOrVS/BrCd/OVm4eYC7pf71bo5nOc3MGiyZMYC0TD3YbeFVG/nXrOp7tiuumSJGXOMRkRkFyr60AHs5T71lpx+DrRzZtR+dKlKw1PtVS7lNv1cLU+tA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(4326008)(7636003)(70206006)(70586007)(54906003)(16526019)(110136005)(26005)(186003)(316002)(82740400003)(8676002)(478600001)(47076005)(83380400001)(426003)(66574015)(336012)(36860700001)(107886003)(40460700003)(2616005)(6666004)(82310400005)(5660300002)(86362001)(356005)(8936002)(41300700001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:29:26.2299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a89448d-867c-4066-f550-08db08f63007
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6938
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A total of four new bridge attributes are being added to the kernel:
mcast_n_groups and mcast_max_groups, as link and vlan attributes. Add
to the bridge tool the support code to enable setting and querying
these attributes. Example usage:

 # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
                                      mcast_vlan_snooping 1 mcast_querier 1
 # ip link set dev v1 master br
 # bridge vlan add dev v1 vid 2

 # bridge vlan set dev v1 vid 1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
 # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
 Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.

 # bridge link set dev v1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
 Error: bridge: Port is already in 1 groups, and mcast_max_groups=1.

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

This is how the JSON dump looks like:

 # bridge -j -d link show dev v1 | jq
 [
   {
     "ifindex": 4,
     "link": "v2",
     "ifname": "v1",
     "flags": [
       "BROADCAST",
       "MULTICAST"
     ],
     "mtu": 1500,
     "master": "br",
     "state": "disabled",
     "priority": 32,
     "cost": 2,
     "hairpin": false,
     "guard": false,
     "root_block": false,
     "fastleave": false,
     "learning": true,
     "flood": true,
     "mcast_flood": true,
     "bcast_flood": true,
     "mcast_router": 1,
     "mcast_to_unicast": false,
     "neigh_suppress": false,
     "vlan_tunnel": false,
     "isolated": false,
     "locked": false,
     "mab": false,
     "mcast_n_groups": 0,
     "mcast_max_groups": 0
   }
 ]

 # bridge -j -d vlan show dev v1 | jq
 [
   {
     "ifname": "v1",
     "vlans": [
       {
         "vlan": 1,
         "flags": [
           "PVID",
           "Egress Untagged"
         ],
         "state": "forwarding",
         "mcast_router": 1,
         "mcast_n_groups": 0,
         "mcast_max_groups": 1
       }
     ]
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/link.c | 21 +++++++++++++++++++++
 bridge/vlan.c | 20 ++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 337731dff26b..9dd7475d6e4a 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -187,6 +187,18 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_MAB])
 			print_on_off(PRINT_ANY, "mab", "mab %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_MAB]));
+		if (prtb[IFLA_BRPORT_MCAST_N_GROUPS]) {
+			struct rtattr *at = prtb[IFLA_BRPORT_MCAST_N_GROUPS];
+
+			print_uint(PRINT_ANY, "mcast_n_groups",
+				   "mcast_n_groups %u ", rta_getattr_u32(at));
+		}
+		if (prtb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
+			struct rtattr *at = prtb[IFLA_BRPORT_MCAST_MAX_GROUPS];
+
+			print_uint(PRINT_ANY, "mcast_max_groups",
+				   "mcast_max_groups %u ", rta_getattr_u32(at));
+		}
 	} else
 		print_stp_state(rta_getattr_u8(attr));
 }
@@ -282,6 +294,7 @@ static void usage(void)
 		"                               [ mcast_flood {on | off} ]\n"
 		"                               [ bcast_flood {on | off} ]\n"
 		"                               [ mcast_to_unicast {on | off} ]\n"
+		"                               [ mcast_max_groups MAX_GROUPS ]\n"
 		"                               [ neigh_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
@@ -317,6 +330,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 mcast_flood = -1;
 	__s8 bcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
+	__s32 max_groups = -1;
 	__s8 locked = -1;
 	__s8 macauth = -1;
 	__s8 isolated = -1;
@@ -389,6 +403,10 @@ static int brlink_modify(int argc, char **argv)
 			mcast_to_unicast = parse_on_off("mcast_to_unicast", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "mcast_max_groups") == 0) {
+			NEXT_ARG();
+			if (get_s32(&max_groups, *argv, 0))
+				invarg("invalid mcast_max_groups", *argv);
 		} else if (strcmp(*argv, "cost") == 0) {
 			NEXT_ARG();
 			cost = atoi(*argv);
@@ -505,6 +523,9 @@ static int brlink_modify(int argc, char **argv)
 	if (mcast_to_unicast >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MCAST_TO_UCAST,
 			 mcast_to_unicast);
+	if (max_groups >= 0)
+		addattr32(&req.n, sizeof(req), IFLA_BRPORT_MCAST_MAX_GROUPS,
+			  max_groups);
 	if (learning >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LEARNING, learning);
 	if (learning_sync >= 0)
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 13df1e845ea5..44e1ba39f01d 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -37,6 +37,7 @@ static void usage(void)
 		"                                                     [ self ] [ master ]\n"
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"                                               [ mcast_router MULTICAST_ROUTER ]\n"
+		"                                               [ mcast_max_groups MAX_GROUPS ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
@@ -344,6 +345,15 @@ static int vlan_option_set(int argc, char **argv)
 			addattr8(&req.n, sizeof(req),
 				 BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 				 mcast_router);
+		} else if (strcmp(*argv, "mcast_max_groups") == 0) {
+			__u32 max_groups;
+
+			NEXT_ARG();
+			if (get_u32(&max_groups, *argv, 0))
+				invarg("invalid mcast_max_groups", *argv);
+			addattr32(&req.n, sizeof(req),
+				  BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
+				  max_groups);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -1021,6 +1031,16 @@ static void print_vlan_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_router", "mcast_router %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS];
+		print_uint(PRINT_ANY, "mcast_n_groups", "mcast_n_groups %u ",
+			   rta_getattr_u32(vattr));
+	}
+	if (vtb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS];
+		print_uint(PRINT_ANY, "mcast_max_groups", "mcast_max_groups %u ",
+			   rta_getattr_u32(vattr));
+	}
 	print_nl();
 	if (show_stats)
 		__print_one_vlan_stats(&vstats);
-- 
2.39.0

