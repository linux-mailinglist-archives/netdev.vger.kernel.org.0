Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0E686CEC
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjBAR3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjBAR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:44 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBEE77DCC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJVJ8NaRJLhkQ9lSz9cukT5Zl53vz7yTPSF8QxQ6JjGi70QlCMb18IooCucqCdBBmmGuAfNHLRX0gmig4f9BoTkzmqsF7WbwUVIdBgHOO4F8d04o4vIDblv+c1FBbtP9LdaVlLPt1i9FoA9L1IJhsBmA00xVH3jmnLACXxCapjkisriUMfD7TNAZZuazMHjAHZvIyKH+w8RKX3p/QygUlxXEuSSibJvn9GTMGiKhXgaftLcalK0rbJcHeqSbpzOAmvIJCX9LkmdlTxvv06NvrYHECSgAbhVdFIsJCaXqHGsXEjujylVVM1VurolDsXEgQ4KEZxTlOuw5S8yiHQyn7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+NJeWcOmij5psAkJAqdrH2P6nPDnqGi6LDk27x/pKI=;
 b=lUe9UrD4mDqvea5uiN2IfcYs+qUzswt2wQJPnGmqw27OwOT6H6ix/Suwmvp6MX/SFefQRDVWDwCf7tDCgvaKVLHixl8BqoUB14EQIl2xscQ/mqzJwpa7bD/2WryvAYSmPQ+LTu9Vg9t6LVIOIDGtWmbRA4fkv4lSufIBmsoMqVYnUaZjWxSdkNbNfGzp1wBMh7HmmJ9MAWRgNAjr6gF4fxy75KEWrEP/8RQ/9VqCj/WDysSHhrSK+7kbUKYIW/bzQrca/PMQRjjCcj21YbPJO/haEdrkCYZmc8HOWB36gxokqA0ag9AHs/htF7PF/odfm6Rg8TjJV4IoCYCJ8tbW+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+NJeWcOmij5psAkJAqdrH2P6nPDnqGi6LDk27x/pKI=;
 b=Uh3T/KCWtVO/ngzORu+K4j+UxCKTj8LXiAcV9ul7mqrAQfJ6hayth9QCvYKLQOSo4yvYJDSAyBxZjO3mqlLf9p2pQnmXiLC8hhUnVRWRbL0h16MIeBORGHSq9jVpxf7PFs2hXg0mBYwVjnrq3eOSCzFKVdxHA3nq8jT2IbqHz9eF4+C5Cg56Q+lOEf9mszoVazSbuYyCbuGSHrQGa9ww86LrQEZR4rg91TwCGKadSUVoHLxAQhUEBKdWPBfUs0vwY1cciFLo/z5LuuIulwyzz/k7GTM4s+ePRoTpQw2TKCxjhoc1p97tPQcS8RalQBOs8UCb0Qjqj/gTDiVGSDovgQ==
Received: from DM6PR02CA0158.namprd02.prod.outlook.com (2603:10b6:5:332::25)
 by CY8PR12MB7268.namprd12.prod.outlook.com (2603:10b6:930:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:33 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::67) by DM6PR02CA0158.outlook.office365.com
 (2603:10b6:5:332::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:18 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:15 -0800
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
Subject: [PATCH net-next mlxsw v2 04/16] net: bridge: Add br_multicast_del_port_group()
Date:   Wed, 1 Feb 2023 18:28:37 +0100
Message-ID: <29092300b63495d45cdee68f3c59f5477ca6be12.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|CY8PR12MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: 07eb4d6c-bd39-43e4-ea1f-08db0479e1d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xn5DMdM17/wHp/67hp8Ctz1obDs2bAnNYJRza8sbk/i6XQ6ZRI7YjifClI8+jnw+jE8xLvmmkbEdCOGuNYjEAreBhEPzyDz2mqkmcp+56iUk5sGkZk3BYpZhMc3eZFtt89DFwgUrVi7r7GyX76DEJKhgpW40uMoEy6HcSPNq/KQkBNqe5qZ8HF5V5RqgzoGE4eDb6hKX/hwnQ7qesxraCuzJLIMzJ3hJqcrbB5VWNexU2DoBDjhCa4hu6z5iLqyXcvlm7QmrTQpWf3HWaHL/UJ9yAWNqFV7NsRP8q9a05lE13iA2AVH+QrIUfVVBBAqnJvUId6JPfsEDPiaUH4k10UnXCNKnfR1+XC2lJ2/FnbxdWobwg4kLx17KpAOXp8Vtozd4suyZ3Wb7sV+4Qh9u4gFqmWQOJdIJke9JrIx2AnAYBZyWk3DvNO5QBCjmzr40TxGgCvmGQZOVRv2BulTdU7nIKFsBK5XIFenVfMsj4W3TaWx8Y0Vf/bTFYRmx+V7x1Y+NEDfcPD18r+7tHfwplYKrFVezS8h4t4d1wLBU1ZhNpW/duohd9g9wL26Mf+Mnu8U8jofczD3fluCLnL6oVQRAZNoeJd0KeOlmyNgbh5KW+gMpco7X5Y49OpdQEK2Gb4qS6gB/WF6YPwEABiJscSIJ/SUYR3z2waV6ZsvoIyizZj8ZRQF2Te94ZQ1HH7DwFcd4xv48IyX9Az04Iy2wdA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(46966006)(36840700001)(40470700004)(26005)(54906003)(186003)(83380400001)(426003)(2616005)(107886003)(40460700003)(16526019)(336012)(82310400005)(86362001)(36756003)(2906002)(70206006)(6666004)(36860700001)(41300700001)(47076005)(7636003)(4326008)(110136005)(316002)(5660300002)(70586007)(8676002)(478600001)(8936002)(40480700001)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:32.8097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07eb4d6c-bd39-43e4-ea1f-08db0479e1d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7268
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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

