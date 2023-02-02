Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C376885DF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjBBSBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjBBSBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:00 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6247777533;
        Thu,  2 Feb 2023 10:00:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs8usWvWf404Tkfdz5/M7FndzIoPAVOPSbOIgeLM3yCUU3ZtWURFTVzPAFDPDC8RNm+AYpB3gackK/wk8m58rTnYsCQhb3MOeUiph+WPlDJtvzCps1S4//Z2zKFnSVWTebpF6XWCqCRLDximsEftFxUEM5+D18AcIxIUoZP/pFdXNmv8LPg+wNWQFKLW0jJJZ/QUOEVcgP2hiqhXdsvhE6Uvw+bwXx3wcI4r6nAPMLuktGJB9dxFzlksw2kVqR02Y63Wj+zhE4tJKSSeYg58v323x2sltCIklLiY+c4GYG50R/G32ChKEenrKSs9Yu5ldyiM8Co1UuV3y+r3m4kQWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by4AOKNu1BZIJeuhiEry/2hyHg4ZEiC2FFZdYRj4ZRU=;
 b=XL+JJdGKx7v9wvNLaclVMzszcHBMkApqfmA29paGDheJ52iB6b7r+a2BMa/Ukfabkt5SDiwWxD1PF6u/GKXC6kxFkp3Wvj24ddQkhJ5mulWovjkqmqRdBrg4/ToLnw3ToMxg1nNRZRHBjbwlyb2h1oAeLrYQ1ErczsL0gwHbdSvratUjG9Kupx5xwJkcxaXKCGxLw0i3IbLmhTqDJbzVULsvGv7faodA14sTzJJzfo+qJcKDOdBKXCEcKTcraZX5pOg5ZRjeWcx+6bidmrAvkSZxenPorsnYhVBYk/u+Xm6kkz3uk0v0vgPL5AonfbHAi3RC+7oeilt/C1UPuDKJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by4AOKNu1BZIJeuhiEry/2hyHg4ZEiC2FFZdYRj4ZRU=;
 b=kqGMYNb/QqES64s/5zl8t3mnnoTcz3e52WEkbM4YkMCxiF/tx/FVbG4ZccxKyDDkCe/8EFvmo+KvoK2zTOhi4+o0P48udgXls3mxdfQ+KUJnuR4Goolm4xuEMiAWqAU1c27IZA5plYYvm3LuGFG0WP9R5oBouALUuYC4pP+ASso0OSU1QgK+/wez95DqHzy8+l0Lfbk7P20L66UZAM4IgbRm0tKMsIRIsnRYgMulAFEPBVVc/mjYN8bq/m4NEIFI3x0tSwkcC2jBPQWakBqAyI9uc7nQNJGlVXG3ux9kpKkoWWsnQEtolA7OIPOZURZng0i6vT9KTz+/N9UjdL6FtA==
Received: from MW4PR03CA0181.namprd03.prod.outlook.com (2603:10b6:303:b8::6)
 by SJ2PR12MB7944.namprd12.prod.outlook.com (2603:10b6:a03:4c5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 18:00:50 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::53) by MW4PR03CA0181.outlook.office365.com
 (2603:10b6:303:b8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 18:00:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:30 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:27 -0800
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
        "Ido Schimmel" <idosch@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        <linux-trace-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 06/16] net: bridge: Add a tracepoint for MDB overflows
Date:   Thu, 2 Feb 2023 18:59:24 +0100
Message-ID: <a01c188bcbbb0f5f53e333ed9175f938eb2736be.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|SJ2PR12MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2cdc21-c401-4341-1779-08db05476a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0P7p3pyHxD5sH26e7VEX4LBzF4zKa6tqiwXTm1OwNcEMHsp8LoMWH/+dIYoFbqFyfGgkW98F7XGBPKogmPKJ5YqbyJapfSTb8WHnu5cA82FWs2lrPTn2Sc+nMTdIlUn/xt54gBN7JsWD1ZT4vJJbMEOjNvsEOV9WTYzhWEYmP+VcAyfOLH6j4yyer5MMU4n864sgdiy7GcTZwD+MlVLCbGjcUETEkb3IxjMZzAe94QhVZ8u/DdqpppJoWcTSkVaM4k1Qw2h/R2ACkm6ZmSD1kIt/dgatWBO4Z7L/tRXEedDCKCS11IKF9vC2Do733jCSBlQArtCmng0XtNRLLz+UVD7tEsgAiLQ3qgNgu/Gnihen0EGGgyW9F3Jefh3L5s9D44YU2xCfnoZHgNquyvX/IYMCadmI0g7weVjNL0AuJgJypSa5a1WLB16TEC/q2Lfb+tzqNnawPU3E6hXzprGeGRU160SDD1JVzHHBt9mH9P79I93EBeq9YH7mm0NC2O5I0Cq39K6n9+5nMPOnwP6IX47Ka+GB5qg5iHJyUBLnn8CI1OyyYUyAogyD177gT8hKww2jZNR3uFWQsKBHWClGjse0C52LjJ6mEHwPhBvVy8HyNQoVmdXiEyRDS7OOe6x1C/fokAYbyhr9pgegql4dp7gudDcbbTw9v9ZxlhLumZZI0/Yka9cj3PiNGkDU1L104llUzHC9FdAhGYktrPH8Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(7636003)(36860700001)(36756003)(82740400003)(70206006)(70586007)(54906003)(110136005)(5660300002)(82310400005)(8936002)(316002)(4326008)(8676002)(47076005)(426003)(2906002)(336012)(40480700001)(83380400001)(2616005)(478600001)(40460700003)(26005)(186003)(16526019)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:48.8960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2cdc21-c401-4341-1779-08db05476a7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7944
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch will add two more maximum MDB allowances to the global
one, mcast_hash_max, that exists today. In all these cases, attempts to add
MDB entries above the configured maximums through netlink, fail noisily and
obviously. Such visibility is missing when adding entries through the
control plane traffic, by IGMP or MLD packets.

To improve visibility in those cases, add a trace point that reports the
violation, including the relevant netdevice (be it a slave or the bridge
itself), and the MDB entry parameters:

	# perf record -e bridge:br_mdb_full &
	# [...]
	# perf script | cut -d: -f4-
	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 0
	 dev v2 af 10 src :: grp ff0e::112/00:00:00:00:00:00 vid 0
	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 10
	 dev v2 af 10 src 2001:db8:1::1 grp ff0e::1/00:00:00:00:00:00 vid 10
	 dev v2 af 2 src ::ffff:192.0.2.1 grp ::ffff:239.1.1.1/00:00:00:00:00:00 vid 10

CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-trace-kernel@vger.kernel.org
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

Notes:
    v2:
    - Report IPv4 as an IPv6-mapped address through the IPv6 buffer
      as well, to save ring buffer space.

 include/trace/events/bridge.h | 58 +++++++++++++++++++++++++++++++++++
 net/core/net-traces.c         |  1 +
 2 files changed, 59 insertions(+)

diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
index 6b200059c2c5..a6b3a4e409f0 100644
--- a/include/trace/events/bridge.h
+++ b/include/trace/events/bridge.h
@@ -122,6 +122,64 @@ TRACE_EVENT(br_fdb_update,
 		  __entry->flags)
 );
 
+TRACE_EVENT(br_mdb_full,
+
+	TP_PROTO(const struct net_device *dev,
+		 const struct br_ip *group),
+
+	TP_ARGS(dev, group),
+
+	TP_STRUCT__entry(
+		__string(dev, dev->name)
+		__field(int, af)
+		__field(u16, vid)
+		__array(__u8, src, 16)
+		__array(__u8, grp, 16)
+		__array(__u8, grpmac, ETH_ALEN) /* For af == 0. */
+	),
+
+	TP_fast_assign(
+		struct in6_addr *in6;
+
+		__assign_str(dev, dev->name);
+		__entry->vid = group->vid;
+
+		if (!group->proto) {
+			__entry->af = 0;
+
+			memset(__entry->src, 0, sizeof(__entry->src));
+			memset(__entry->grp, 0, sizeof(__entry->grp));
+			memcpy(__entry->grpmac, group->dst.mac_addr, ETH_ALEN);
+		} else if (group->proto == htons(ETH_P_IP)) {
+			__entry->af = AF_INET;
+
+			in6 = (struct in6_addr *)__entry->src;
+			ipv6_addr_set_v4mapped(group->src.ip4, in6);
+
+			in6 = (struct in6_addr *)__entry->grp;
+			ipv6_addr_set_v4mapped(group->dst.ip4, in6);
+
+			memset(__entry->grpmac, 0, ETH_ALEN);
+
+#if IS_ENABLED(CONFIG_IPV6)
+		} else {
+			__entry->af = AF_INET6;
+
+			in6 = (struct in6_addr *)__entry->src;
+			*in6 = group->src.ip6;
+
+			in6 = (struct in6_addr *)__entry->grp;
+			*in6 = group->dst.ip6;
+
+			memset(__entry->grpmac, 0, ETH_ALEN);
+#endif
+		}
+	),
+
+	TP_printk("dev %s af %u src %pI6c grp %pI6c/%pM vid %u",
+		  __get_str(dev), __entry->af, __entry->src, __entry->grp,
+		  __entry->grpmac, __entry->vid)
+);
 
 #endif /* _TRACE_BRIDGE_H */
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index c40cd8dd75c7..c6820ad2183f 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -41,6 +41,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_external_learn_add);
 EXPORT_TRACEPOINT_SYMBOL_GPL(fdb_delete);
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_update);
+EXPORT_TRACEPOINT_SYMBOL_GPL(br_mdb_full);
 #endif
 
 #if IS_ENABLED(CONFIG_PAGE_POOL)
-- 
2.39.0

