Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0E67D267
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjAZRCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAZRCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4CB627AB;
        Thu, 26 Jan 2023 09:02:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G74Wccb1vKJ1+e5iQggM1j8q6OUwERHI66smmJRIwA94lVaV0YXEL4EQeHj2/t+ZLnoq6mNkN4oKpGRySrxueT3Nw2fzRIvN28l/X8Ui8Zq+mRzXJ00ujBWccaVbx3ncYVfcK6dGwFpzATmCI48G8JzAahsN0yqCA0syphRRePleZr9fxumxh1wh1MF9HersKhiOqTq5Repq+Vf4y7138p9yHLUx047ztgURhYyUmJ/m1nlFAXervz3suRoDEkzolSl5dhP353o+STbMdO5QzHmVEYP3Wa2jWMT3D+4wOU2N6OCsDmJ/6eTQ1n6FAazat2/4Otlvi0EjhSD9JkAFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XGSeSqpbeKmuOlOmAqvCcULsRstgABL80DNrjXF1a4=;
 b=E+dGpTqLR4TAdT/IZQ+6U6K+56VQBGQJbS8bR3fUsQ4+OlKAHCGl4+2aoh7G8V6Qq/FVm6BrEyFlZ2f6dLqIpkwi1MFPGc1pOdhWg2GA2m0dqlPNH8vChSF53eVCZz8jzjaOC4WKjlaLhABhXg04nphJ7d7bd8x/PSiIu0jWWgzX4XcsMOWbGUtFXgDISlMZ3QhpMiZdq+bEYvwjqFNZ0HP5qTFMqJSJvKGpJWSnX8sYDfIEsg7i6QEY/1JZW/QwdqfXFBi5nHV9xRwUKU9Edw3KNhsH1XGqbkQgL2r/LguP/zF/9kuio9Xl2qj7Z6I09RwmwQ0sZADScGj1RGUuAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XGSeSqpbeKmuOlOmAqvCcULsRstgABL80DNrjXF1a4=;
 b=Ah0OzJUKlNTCInhibvKo7PQ1eaAIyVJJYkQffymbeDqlkC5fq3rqGjtPPpbBylZxJf/rOuk3NEaNKt4RscDng9Uio9Dn0gIpR7jTHgIpFZtFluC5yZ/5O6xCC80zmcNnUU6jHJodJCmInvvD2DfgYzYBQTjk8FkZ3EXq8l5oHXJqo+8XAA6wGg6dsflu1bfkwe7hnCZc7cOsBWBwEv/DNQfdYrGt8nAh3WrJ6Q86R091XKwiPTEitTW2OQWym26ENWYK4sqywntot/pFXpPP4eX55ccQkXhl3/JvtK6wkkP6Kr9ViXcmeAACIZcDJjRDIpf1eSlWWNcqzDsWgk3Hnw==
Received: from MW4PR03CA0304.namprd03.prod.outlook.com (2603:10b6:303:dd::9)
 by SA1PR12MB6993.namprd12.prod.outlook.com (2603:10b6:806:24c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 17:02:20 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::a1) by MW4PR03CA0304.outlook.office365.com
 (2603:10b6:303:dd::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Thu, 26 Jan 2023 17:02:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:07 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:04 -0800
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
Subject: [PATCH net-next 06/16] net: bridge: Add a tracepoint for MDB overflows
Date:   Thu, 26 Jan 2023 18:01:14 +0100
Message-ID: <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|SA1PR12MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da694ef-b6c2-4002-1131-08daffbf164a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Dzp+IkgyhcQLEktxPtUPFbXNF55jHs/MuIrsR5e/SpCsGYHs2JWVOkdXv78UBSZPH8sat7ujombZbzP04Nj4W848jU2beUDmnEvBOrWQYo1WTFfiq5E3aGiL9MSiwb2YlAenNSPLI1kMPqgewX3+CZJ8RuIJj1qIpf3Ne7uYgsuMzBQ77K1cWYON19xCTaxIk3Du9WmQJq4RzyHdTw97l8LuWYBs6jKgNPn12wimOKTMqpEsmzDfLi1iNpMJPGK3Xfi83e1+MfAvSRibJbvOUoBk6ie7hp8+Ovb7WGHOApyJuhk/WxxHbknRtHxHHYb+jFSxBJhTlo9K3wkG7RfhE5j/0LEi9DzQPuFOhMcpLVz0whNkZPtdwjzadl6FLy4P8owVfoDbCCnhjMP1tlsE9sriiS84EsXFrVjUsbwlkdGaEyx5/Ls3RZuXyJ/8uNn1KJKdj1Hmx1gqevGPizzexciZ661969/jkcFDNy/943lFxeme1y9EDZij1gqlk7aQurhEroKmJXD8N2FVDxRjbItDl8ykmn5hZ9ukjsVdLFu08YrXT6HrfG8Ulw+N5s1fKwn8QxeLCOJgZNa09isKnv6TZCQ9IeGHj7FZtYGzAEqFSk24FRlKLiVf5gjYjHwbsatr9ODh0K3HWQtUFX7R/mKfEcfrEN3n/ZDRTAzkp2Nii1NPIwZlCDfNp0fo3eo/8nCi+vFfGhtSao2xj9h0Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(16526019)(70586007)(41300700001)(426003)(2616005)(8936002)(47076005)(86362001)(8676002)(478600001)(2906002)(316002)(4326008)(36860700001)(82310400005)(336012)(6666004)(5660300002)(54906003)(36756003)(186003)(110136005)(26005)(70206006)(40460700003)(7636003)(356005)(82740400003)(83380400001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:20.2573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da694ef-b6c2-4002-1131-08daffbf164a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6993
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
	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 0
	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 0
	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 10
	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 10

CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-trace-kernel@vger.kernel.org
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/trace/events/bridge.h | 67 +++++++++++++++++++++++++++++++++++
 net/core/net-traces.c         |  1 +
 2 files changed, 68 insertions(+)

diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
index 6b200059c2c5..00d5e2dcb3ad 100644
--- a/include/trace/events/bridge.h
+++ b/include/trace/events/bridge.h
@@ -122,6 +122,73 @@ TRACE_EVENT(br_fdb_update,
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
+		__array(__u8, src4, 4)
+		__array(__u8, src6, 16)
+		__array(__u8, grp4, 4)
+		__array(__u8, grp6, 16)
+		__array(__u8, grpmac, ETH_ALEN) /* For af == 0. */
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev->name);
+		__entry->vid = group->vid;
+
+		if (!group->proto) {
+			__entry->af = 0;
+
+			memset(__entry->src4, 0, sizeof(__entry->src4));
+			memset(__entry->src6, 0, sizeof(__entry->src6));
+			memset(__entry->grp4, 0, sizeof(__entry->grp4));
+			memset(__entry->grp6, 0, sizeof(__entry->grp6));
+			memcpy(__entry->grpmac, group->dst.mac_addr, ETH_ALEN);
+		} else if (group->proto == htons(ETH_P_IP)) {
+			__be32 *p32;
+
+			__entry->af = AF_INET;
+
+			p32 = (__be32 *) __entry->src4;
+			*p32 = group->src.ip4;
+
+			p32 = (__be32 *) __entry->grp4;
+			*p32 = group->dst.ip4;
+
+			memset(__entry->src6, 0, sizeof(__entry->src6));
+			memset(__entry->grp6, 0, sizeof(__entry->grp6));
+			memset(__entry->grpmac, 0, ETH_ALEN);
+#if IS_ENABLED(CONFIG_IPV6)
+		} else {
+			struct in6_addr *in6;
+
+			__entry->af = AF_INET6;
+
+			in6 = (struct in6_addr *)__entry->src6;
+			*in6 = group->src.ip6;
+
+			in6 = (struct in6_addr *)__entry->grp6;
+			*in6 = group->dst.ip6;
+
+			memset(__entry->src4, 0, sizeof(__entry->src4));
+			memset(__entry->grp4, 0, sizeof(__entry->grp4));
+			memset(__entry->grpmac, 0, ETH_ALEN);
+#endif
+		}
+	),
+
+	TP_printk("dev %s af %u src %pI4/%pI6c grp %pI4/%pI6c/%pM vid %u",
+		  __get_str(dev), __entry->af, __entry->src4, __entry->src6,
+		  __entry->grp4, __entry->grp6, __entry->grpmac, __entry->vid)
+);
 
 #endif /* _TRACE_BRIDGE_H */
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index ee7006bbe49b..805b7385dd8d 100644
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

