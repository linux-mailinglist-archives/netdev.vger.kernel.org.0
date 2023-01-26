Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1167D260
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAZRC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAZRCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:22 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A045569511
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0tnmDFZ4LwEz85KsYiXItf8Zj8NDBF3XrI8S+jKkElvqxFplPzxrc5arBXJHpnYSBXNsgSEnvcCDD3UQgwxNteo6mwekG8P6l8DzV5ePxtrnxPBoqXHE3weJ45xd+uGTmdLIiJf2tFontExjBFzjWP2i69e/FIf+jXPCWE8jaBDQ5tX1Kam67b5nEFBGfe7E6hEABOt5ChT4Dg2R9a814qiRYkGJtYP7JzyQ4Jb8lL898SuizJrP5jwsWtBpGj68WEd+FYvsd8lgCvwaarLQE3GrGAnaoSUEHa0zwbYi5CZSL2T53W6pIRGE4moEn2cCcoIW35IYDb8gqS6YuzD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vC12Kv3SPanRuHArnowX+WkNaI2Qb5ZPbGEQodn4mA=;
 b=hQ/BeP2m4l6ZOqzM3blOx7Jtf/HHrr4f8Lx5YL1ISAAamHP80cPZESPf7OgkK8HQVqTQyQsqquDkJMM2KDXn7ANj5Anvt32OMBOJQlLJcLYrOzIJf2RC1ErQ+SvhF/ZnBusdp9cFIUUETrNx/mc9j+uoW2l9z6nmp763sy+6Q4tG8Y4K1hW6tF+7vbjBstlFn+agtQ1+vhGWYkmQkbwVXSNWuA7iCnxQTS7+mTdJKmBTNMMTcuIurP5/tPLTEEzCKEQ1pvaB1bMfkcD8c4eYntb466OTA+/iLkC3hCjjsQphltYqeYyhJmgDfRQucUJnl0jZuQ/q7Cd/5vfPFKmLeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vC12Kv3SPanRuHArnowX+WkNaI2Qb5ZPbGEQodn4mA=;
 b=jm86lm83qe9i7AI5bLQD+As8zMzZaAAnU5cCbvYkfw1ApWt3FTPrI0s9/knsz59AP8bUnHKU8zGAelVX5rM+WepBpyDrByjE77gt8+P4RdFSljKsbqicjq6r2Odd/OVcH33yf/FBGu54Z+b4btUfYpNpsPnbfKLhl3pym/PxtGtQ6z2NGNT70kSjV10Ojp/jMPSUGmmSG4StqS2FYV983vrmjC/R86Nk/9vkJuMgVf9a4fpCk5j/jzyF0U0BzezQOi8MKms7H442hmDYTXOUZWRClfYxxk15OJWnTcrvJQAGfH2QrDSU+xshOK+ebNrXWObJ4LhYTBbZ7d8c3Xqxrg==
Received: from MW4PR04CA0140.namprd04.prod.outlook.com (2603:10b6:303:84::25)
 by SA1PR12MB7151.namprd12.prod.outlook.com (2603:10b6:806:2b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:14 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::f2) by MW4PR04CA0140.outlook.office365.com
 (2603:10b6:303:84::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:02 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:59 -0800
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
Subject: [PATCH net-next 04/16] net: bridge: Add br_multicast_del_port_group()
Date:   Thu, 26 Jan 2023 18:01:12 +0100
Message-ID: <982c17c28b513bd3e6dd670fa2db13ec76bc4460.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT063:EE_|SA1PR12MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: cab6e052-0611-4131-f7aa-08daffbf123e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOThhtogqXdAl7P4Cq053H7r4hRWLfRHQGozZi1hfyMj5AyTIMm7dMlQlolCGHiwfAf0P/ttIcZTS9WBNoHYWLMelY6MQkez9TG3zrcTpi8qdob7vW+g6s0bpau90pf/ccFLsOKB+1UqpW4NvQoU4xSk8fGZ2BiPsXB3c6w8lv8QZzcO6OItoqMJdmSTjvyTW0ZMZ2wACXGhooUFl4SsuO9v/ixZNIYrXLt/kB0TFGr6c9SqWNRAmpGQSXEkmdJp8AQhCG+9gVSqxMGm3gwNC0ct8NmNcprH4Tkwgnf0HKSBRNDG11EH4046E2iQ4prB90//akHQo9JAD8lHUfXT7DTpVGmGn7NQYgbE/RcKtpg6WeceERLHUIbnfoAB3htNK1orjI9PX6gGHT22eUSg3VnYwpGB3y7VBiVcHcLgiFHQf+boAFd3oU0fYY7C4RAu2XRyjNnldO+SH4VE8gE3K7MoGKa0QYGyPv/6BzFB+THsa/lfFBZzYN15fsFyzzxE5aViiblpUshOt0yWlCsNxcp+EZuTxdQcX3A/Nv4t2RTKqMx/rR/MczHsrpaliej2R4AWPGCWMZLvFturu//k00gZlYnOjtyE2ukoVmyawZyN7RHKclH/a8kz4Zptzc/SE0SUoHHzy9MISwtrsRxcTTXaJnANSiS9VRHrOE7Yn07ey2+RmPRSDjHwTTRFaWP6hc3Qx2kipvhNQx7w6HKI2w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(356005)(83380400001)(336012)(426003)(86362001)(40480700001)(40460700003)(107886003)(82310400005)(70206006)(70586007)(478600001)(6666004)(36860700001)(2616005)(186003)(26005)(16526019)(47076005)(7636003)(36756003)(316002)(54906003)(110136005)(41300700001)(8936002)(4326008)(8676002)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:13.5361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cab6e052-0611-4131-f7aa-08daffbf123e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7151
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since cleaning up the effects of br_multicast_new_port_group() just
consists of delisting and freeing the memory, the function
br_mdb_add_group_star_g() inlines the corresponding code. In the following
patches, number of per-port and per-port-VLAN MDB entries is going to be
maintained, and that counter will have to be updated. Because that logic
is going to be hidden in the br_multicast module, introduce a new hook
intended to again remove a newly-created group.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c       |  3 +--
 net/bridge/br_multicast.c | 11 +++++++++++
 net/bridge/br_private.h   |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 139de8ac532c..9f22ebfdc518 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1099,8 +1099,7 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	return 0;
 
 err_del_port_group:
-	hlist_del_init(&p->mglist);
-	kfree(p);
+	br_multicast_del_port_group(p);
 	return err;
 }
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f9f4d54226fd..08da724ebfdd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1326,6 +1326,17 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	return p;
 }
 
+void br_multicast_del_port_group(struct net_bridge_port_group *p)
+{
+	struct net_bridge_port *port = p->key.port;
+
+	hlist_del_init(&p->mglist);
+	if (!br_multicast_is_star_g(&p->key.addr))
+		rhashtable_remove_fast(&port->br->sg_port_tbl, &p->rhnode,
+				       br_sg_port_rht_params);
+	kfree(p);
+}
+
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
 			    struct net_bridge_mdb_entry *mp, bool notify)
 {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1805c468ae03..e4069e27b5c6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -958,6 +958,7 @@ br_multicast_new_port_group(struct net_bridge_port *port,
 			    unsigned char flags, const unsigned char *src,
 			    u8 filter_mode, u8 rt_protocol,
 			    struct netlink_ext_ack *extack);
+void br_multicast_del_port_group(struct net_bridge_port_group *p);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
-- 
2.39.0

