Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6824686CE1
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjBAR3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjBAR32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8B46E41A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cswri6oNWYKCD2T2FTie/SCZQ7HKPk+a2ve4KZu3ySC/owt/n9IVe6I+RHJlmv6g0n8+euQrON6ghlUMQwHwCN8Mb/bzS55VLbuU/KgmE/EXo1jcEMXuvfyjCFcMgxa8Q9JbUo7bk83JcA7eO/Jok3KWTVdGrPVvnU/owvwQWBW13/H4obCMx93lZB2W4ShJLXCu0vpXwk7fAyt00ijzR4LEOZRw/5o1R+lRPFL0Zzp0VFJMLzi4qFicFVBUHh4Bu47wRCKQVZ3TexM5v9zCVRlZcq8JTm/gIaxkEWW+U8G9HgKQ8x3/phLgcQebSyJ3Pp6Vaz53+u3z0c8wbaLV7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDXzltQ499SFSA5wC5YjpprEG2qUTXpMLp0Yjy56ozQ=;
 b=fSiZp8RxBbPjtWxcaZusPmX5pZhYR8DBAC1oacbes8Qp2XRH04J4PWJEez8K+6MYWri4oisggbFfBmIThjUVc9XgOyOxVKIplDCpLhtN0VGlBLoXvOjgMvmHGgjnq3KvlQicHcWfHx/ge7lDHei5hrI+Y6HDorquW1QEDa4uRFfX2A5tGZFjqAo/nZ1w1giM1+6rBU3u3NgDTrptaUWwczEMAGyAB8QAeRZyc6yJ4ZATbyRAeX+RZE9vagZ0WcZKMHX8tY+SeuLp44sBt4xZTJbh/IrLQh8sBBKHlGefwkspC9y00ln77hUhrHvREWaDb+NxqNA5fup6/JvqiH+jBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDXzltQ499SFSA5wC5YjpprEG2qUTXpMLp0Yjy56ozQ=;
 b=t80atC86r7wNS1hhbMLO0L7S48n7WaIA9IfYn/ZblcRuvUh52rfA10fB0s2h2ivcD6qRkS7ClovVaYRH6Q1e9GSu//vxvFUI1jtAA5ZErUJw2CSt4foYfut7M/3C9MsUjmBnZetZU31pCJAgQIU2+9KMlRWkSU+gGmE9ZVIgTYiMsN0nNkY/OYqNax5WzWOYWgwlb23Jzt84T3/liKRhC+r+2WO7mCtxY0hpSU8mE2a+C1QSYDBjSSAiUaBT8E8fZ7O0wB6qfb6L0PJF6WnyUuguh7XK+CW7+FPtNpDk2Zrk8meZSL2OijvtCFpi63d6O0VOVo1bdfYDqq0fVwew1A==
Received: from DS7PR06CA0010.namprd06.prod.outlook.com (2603:10b6:8:2a::17) by
 CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Wed, 1 Feb 2023 17:29:26 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::d7) by DS7PR06CA0010.outlook.office365.com
 (2603:10b6:8:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:08 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:06 -0800
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
Subject: [PATCH net-next mlxsw v2 01/16] net: bridge: Set strict_start_type at two policies
Date:   Wed, 1 Feb 2023 18:28:34 +0100
Message-ID: <af9d9613a3febdb0210d15106e48766bf190b0a8.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|CH2PR12MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: 5775d0e4-23c6-4fb2-144e-08db0479dd66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tothgIIlNQlb+uKNcf2TGX0XppCfo3HfO/RM/LmVRrehHACC37w9QlieYY7haDlV9gJzMQGAipI7GUcJRF1dFo9+N/ztbo9X2cW3GUBhPxclX8yuaGxyweLas/pS8Kz/OC6LtZ79d2MJ1zNjD1ZMHngEDst/bpvpnYVDo6Qy277TcuLKQXLjrlTh0814NHH6408GkEgVTuCWURuHtMilLF1gl9rwaf/zdPRhErFJhFmJdTFFDu+NJ/sZ6S9J3hNseJ+A5NbJHR/xxrZLgL5A68ii63JL/M7NGFdTl/esvWpPDs4WJwk9ZYCLJbbnFbo03vuYi5Slp23YtZwk7ZzItHoXwS6PMmeMQd+EpIfml2w89/uQmtO3XHUqdPMw9w5VMMjhPrclsqYypAu1L4w9Kx4qx9Ix+IdnP4MgUGhs2QEmJ+ZQqNUtdosY/9ICIgTOCUU37liT5/o0HQzm0uoewX8KkXPff+9bat1z4XL3IFbxv2MYnLeRcoYK0DZZRaGV50vXQ1AHokGN2bw5ZKlPoERCngjIIs8cbcxMoraZObBaLdPOl4JaYzm6FkNmsVDoV6OXRKrbPC2HeZpsytkbfs7jNjEQjx1FYCMr600W2q4ULWeYQsMmXmNXsSr5SrlraLfIVtDFStSU5ZLziTjtYxnkjJNbAS5cu+R3rrEaDRXLSBV966Ga/wbP9w+Klaiz465mNWf11h8BgNBvdqJGvQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(5660300002)(16526019)(186003)(54906003)(110136005)(2616005)(26005)(86362001)(40480700001)(40460700003)(478600001)(2906002)(36756003)(6666004)(36860700001)(107886003)(7636003)(4326008)(356005)(70586007)(82310400005)(82740400003)(426003)(83380400001)(47076005)(316002)(336012)(70206006)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:25.3503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5775d0e4-23c6-4fb2-144e-08db0479dd66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make any attributes newly-added to br_port_policy or vlan_tunnel_policy
parsed strictly, to prevent userspace from passing garbage. Note that this
patchset only touches the former policy. The latter was adjusted for
completeness' sake. There do not appear to be other _deprecated calls
with non-NULL policies.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_netlink.c        | 2 ++
 net/bridge/br_netlink_tunnel.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4316cc82ae17..a6133d469885 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -858,6 +858,8 @@ static int br_afspec(struct net_bridge *br,
 }
 
 static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
+	[IFLA_BRPORT_UNSPEC]	= { .strict_start_type =
+					IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT + 1 },
 	[IFLA_BRPORT_STATE]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_COST]	= { .type = NLA_U32 },
 	[IFLA_BRPORT_PRIORITY]	= { .type = NLA_U16 },
diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index 8914290c75d4..17abf092f7ca 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -188,6 +188,9 @@ int br_fill_vlan_tunnel_info(struct sk_buff *skb,
 }
 
 static const struct nla_policy vlan_tunnel_policy[IFLA_BRIDGE_VLAN_TUNNEL_MAX + 1] = {
+	[IFLA_BRIDGE_VLAN_TUNNEL_UNSPEC] = {
+		.strict_start_type = IFLA_BRIDGE_VLAN_TUNNEL_FLAGS + 1
+	},
 	[IFLA_BRIDGE_VLAN_TUNNEL_ID] = { .type = NLA_U32 },
 	[IFLA_BRIDGE_VLAN_TUNNEL_VID] = { .type = NLA_U16 },
 	[IFLA_BRIDGE_VLAN_TUNNEL_FLAGS] = { .type = NLA_U16 },
-- 
2.39.0

