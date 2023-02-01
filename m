Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB52686CF0
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBARaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjBAR3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:46 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C5A7642F;
        Wed,  1 Feb 2023 09:29:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPWuhXraanKTH8HKsw/SlSgR+OatjUo+GyMdwofw2gtrutqOqbj/z+trnp9W+KWg24jVVhsg4NKN7pnTq8AKfoT+8uqYvLDZakzSvEjX0GuHt1OfFulNkGwnCmBZO7lysXWjLZlfG4vzQCVSqRQlfKC7LiutZYy0VRX0wXvDPFGHbUosu9V38KN1apTvpu9MsH/i4slXl4d+5TsA9eadWd7FqFFxG5f68gQ1dYZ1u4SDD6sgg27cTvJ5yE1Cjbm4v8Iwst2XgQ50N6fTvQm3Cifk1L2uaXvT3rPeCUsCiTOhZ7ErgA3b1JlPJsTOLV7icR8PJQy4ah68j/dMRthsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtyG76Sjp31H3X92EqJlwwB5OXXJLBKMJptF4lhixlo=;
 b=JHxfIkQ/NjMkWDHpos7h6HEFqyywamB1lh7aCs1pT5zIuTfe/LEt+3sBFLzcNoa5tmlY61pyYOSjiKSo3xL77MR5SMnK2ORs34jvp9CUjSioQF0edQfePZk9zPhQpjGlpbAB037bE7zRo1E1h54fUqOkfD7YOoJdD3BMjQcQkZQcmJirqRmmLZfVpWPvu+X7hF8cXim3CWjNBNoORIX4yVeTtnXcu+b3vFVdgXC9Y6clN9XDiqDppUNMMrixS3dfWDbnozEaVq/sSm4ra/XhCuzOiJffFRR6mnLTYERCLo6Y8Jcu7YR4D8dTBHQlsLgagzTL52hsBWOZ9S18rRy7Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtyG76Sjp31H3X92EqJlwwB5OXXJLBKMJptF4lhixlo=;
 b=U32P2LhkbERxLqqG7f/zSaTOXFNLhyZKMtSdcaxZThQYkmBpFIeiVMzEJ+RpiWOllEZCyDtRG0uLyVt5RXXyICUnw/cXXLvF3gV8RKSXvuDpoT4tlsUxMrkpZb3QmNHRmTur89SXSLO8BlXWnmkvlvsqovKQNnOS193aRw1qpXlqkqUQw9ug9gxAeiOH5whZJUR67zoxbm2Ot+Y5rsMKlK/A9J4bSO+r2eoMD+5YRL5DPholAFvJjlLQLElaYUvrDvnzbMW7t1hdbHI5aiZZ6NgxqrAnDlP5K7fSKxEQC5/JfybhQDUpFzcWcbNgBqlCWneTs2OkUjbrxnNOEiz5ng==
Received: from BLAPR03CA0165.namprd03.prod.outlook.com (2603:10b6:208:32f::9)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 17:29:37 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:32f:cafe::7f) by BLAPR03CA0165.outlook.office365.com
 (2603:10b6:208:32f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:24 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:21 -0800
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
Subject: [PATCH net-next mlxsw v2 06/16] net: bridge: Add a tracepoint for MDB overflows
Date:   Wed, 1 Feb 2023 18:28:39 +0100
Message-ID: <008620de41985a3a757c7099bc712ae75739db27.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d803dbf-b6a8-468d-22c7-08db0479e476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTTOHb8Ugy0xIiQyoSZA2Cb1NOVry+wqDt5nmgr1gPosZzoZFSMRqUfTK7bxWY7WbZlLFI2AMptPbovQ6Gv5CFoa5Xx7r+dDBvr6Hiawt9OMVx+DrQhGFtev+S0xONRjSrfOMc+7owQx8Fm9va5QhoDu1RdOEwqOlttxTtedANPBQOPXdJJflBBTW69Zghoi311eGXokzDPIB5uEDOzuXh0WkJ9k6TK5SaOjgveGAXBVY8rjazSMOfOfu9N0EuGliVh3rDLyc8DPqx4cMBHhTdCmBdPBj6iHuk4iezcSj7xR/2Hu66DOEmqpHwFr+JlX1NfqyP0Htw32kQxryUdsXMuhAuRrm7YpyIJTarT/L3KI8TRrxF56xMwq1Gn0VLsEpHENcG3titIGRzJJ0BWLg0uS6qQMlBsEAgSiLD+9bzOE6AMz/8a7Pl9yXrnkjXBKrmJsbwnUr839mhh7bsDzI6DhElQFEzX3ZJ1IeyHnOzvB74/3zzdekj3Im/qvqv0T2XJDJS/iiAmA3mRS42HCg+6NRLszbS1wpXKM6YVEWoUo4FcEOA65ExUuE0d8JbwJkTF7gm43m190cKmi+V3QJPLV1VLYFFN0nksGeysPbmqVYqY0U7hw8/YpjVn+/nSrPD7t4qkBDhzuzlJrKfLlD2PrQ2j9bgKD05QvJBwcZLtPSRBbfeoG8bIOUEuK6D7gI+HNAgxxPlybUqNWTk87Sw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(41300700001)(4326008)(8676002)(110136005)(8936002)(316002)(70586007)(70206006)(40480700001)(5660300002)(6666004)(54906003)(83380400001)(40460700003)(36860700001)(26005)(478600001)(16526019)(186003)(426003)(2906002)(36756003)(47076005)(336012)(86362001)(2616005)(356005)(82740400003)(82310400005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:37.1527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d803dbf-b6a8-468d-22c7-08db0479e476
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
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

