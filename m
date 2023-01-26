Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A53267D25D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjAZRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjAZRCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:14 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD46D63869
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EztqQFZ9R07sv8IA43dvnOJREi6XWzcR+b8N2yiCFUijzxz9fQfGhuyFkndI9Ux0EW0y49yQyFvIK6p7p9/xbd3pO4lUkJaUO8rqryCwCiuWH6aajsfOYxyJiQ+PAM43Z76squLNMw08rLZwKNCeL7WoQc5/MzXT7NQ7S4BcoNeHquNrPM9X5KQi66yuE5p7kvqmShhlG6dS9j7Irdt9DAM5qYJzuiiPG1X/pm10nZ+Zjh2lN9V+u79jdGKVKiPM9nT0vK7gwcn8K2TyOID65jOJqg8W4qP7SyfOJfeV47K+kto79Ytm4eRwaxw7s4Oeffcbi4EeLzGzlSn0J6stPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwEhCLoivGA09sh7DOR4jZ9EiM8HbtlamttGhnxlmvM=;
 b=VmcDebBKHJbIN1PQ57Ci+YngIKKvqyWLOV+aGONcAPzD1xjEhYYUKzoEFn5AQhR64P91DnhCoTThk1XjsltObuXZv+JrmwNmPg5tticP/TpBKCx8WC+q1rNlU4LWiVSg5PYVVMUCmZT7/J5K6cF3S1/YaCZGOAKSe67e1Rwa9ltJftUlUZz1G3+2zUxWJD91BDc5/yuye+hdSsAiIHW9MJmL0dfvfpJjcZqm/G6i+A310AObbikeHXh4VcLbjur/hZddnaVGOYCm5vRRGGN871XCruOqyLO/PtFymPrmY2fprNBbHKF4qaRIcRNNtYNgahaLfi3SrvyRMHvxFnhb8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwEhCLoivGA09sh7DOR4jZ9EiM8HbtlamttGhnxlmvM=;
 b=V4hPDKmN/S+0K2mZrITTCbmJt4QE58aWYbAgYZMJnYkselCi9e4gAGHQ7Q9EgTiFtHg8kOzB4l+nodyCdUgxQiSJFs7YY1wnsUnMi7yHYafXjqzJThlxNLKWMZGMNbN4vAD1GJUssvaGhqvC3tk7BfHbrZSJ1rSYTwP5J5Ki6R1InqMBEqRquVUzaAd7Xuv0gOiYuEqhpM3xhQdT6sfmEgCPEiItz8GEEu3O0i5RmRKgTWe8KDAePEo7edaw5PzFTUtEi7l8hcSzvqZA9R2wH4V85GEtUOQ9lbtcr5xRGHQ5ct9LADEIK2z8/3TIm4Tyv6xUU5CR0hqevWmWTmF/ww==
Received: from MW4PR03CA0324.namprd03.prod.outlook.com (2603:10b6:303:dd::29)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:10 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::38) by MW4PR03CA0324.outlook.office365.com
 (2603:10b6:303:dd::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Thu, 26 Jan 2023 17:02:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:59 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:56 -0800
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
Subject: [PATCH net-next 03/16] net: bridge: Move extack-setting to br_multicast_new_port_group()
Date:   Thu, 26 Jan 2023 18:01:11 +0100
Message-ID: <16e6b1f664e053bd5c057b7c5b0bd23e3d7652f9.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT012:EE_|LV2PR12MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f3663df-86bd-45aa-0496-08daffbf0f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pARAH3Bz0pq3vqPVDiZxZ8VoalyLD5VjtIHLvZlIV3qe6Gwj7eKagLP32j7mcOedSP229s6EdEfL7JOEnWovrEV8t+neKyHUIQYtg5F7hTZT0llRiquehe1Vi2OWlurAoC/8w+mhCCVWtbpaoxDIUbpIiu0QPg50Tfz4QmWDwKuT95bhewXCTG0BE6VoAr/j2kGnO6OMf0ej5LwaW4D99MmZsW5OnvstkIWXa0OL7K/7JX+n2STiOj6XRRNFZObIzw1c2U3JNtcocR/EAr4woU37AqHuxrYAjpI1V8ufRN3V90Nma8CXTkX7DJ+xMvGuY1/TOqVDyaQDgCMmb9JRv+PWSqtUTNUwKJ1VaMG2oxnTcY3l8cpLrrD0rJWBDBf1rJi+zenqVUtM9MbH1oUVsZnc1gBXb3RCPQfyPfOIsqvsYaMrzOgifNMO+Y6HxeOM0IdT53rjDypzfSPgiDh/SkxHaeOvasWD/IZEomc5AKsBuy9k4QK9LXAdbK2Ixo9kupCFKm0ZTubvvBkWxw6SysX59a0yTVrrZSADcFBrFh2F1L+jFUHwK/CZJLUYNlP2Anca6F+o/krbEVjZXRFCHMWKYRunVuPH0TEeDHicwe2XRHDB0wA2xf5rcBlTaM/2jPc+m9cKXVbRvsUFQ15unBlJJWj7Y/2v3HO43ZWVDAFFjdOvNL3g8o351fKgHC0sSHVZSy4Zj0eRS2WDGLIug==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(356005)(83380400001)(336012)(426003)(86362001)(40480700001)(40460700003)(107886003)(82310400005)(70206006)(70586007)(478600001)(6666004)(36860700001)(2616005)(186003)(26005)(16526019)(47076005)(7636003)(36756003)(316002)(54906003)(110136005)(41300700001)(8936002)(4326008)(8676002)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:08.8703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3663df-86bd-45aa-0496-08daffbf0f77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that br_multicast_new_port_group() takes an extack argument, move
setting the extack there. The downside is that the error messages end
up being less specific (the function cannot distinguish between (S,G)
and (*,G) groups). However, the alternative is to check in the caller
whether the callee set the extack, and if it didn't, set it. But that
is only done when the callee is not exactly known. (E.g. in case of a
notifier invocation.)

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c       | 9 +++------
 net/bridge/br_multicast.c | 5 ++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 069061366541..139de8ac532c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -850,10 +850,9 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
 					MCAST_INCLUDE, cfg->rt_protocol, extack);
-	if (unlikely(!p)) {
-		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
+	if (unlikely(!p))
 		return -ENOMEM;
-	}
+
 	rcu_assign_pointer(*pp, p);
 	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
 		mod_timer(&p->timer,
@@ -1077,10 +1076,8 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
 					cfg->filter_mode, cfg->rt_protocol,
 					extack);
-	if (unlikely(!p)) {
-		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
+	if (unlikely(!p))
 		return -ENOMEM;
-	}
 
 	err = br_mdb_add_group_srcs(cfg, p, brmctx, extack);
 	if (err)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de67d176838f..f9f4d54226fd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1290,8 +1290,10 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	struct net_bridge_port_group *p;
 
 	p = kzalloc(sizeof(*p), GFP_ATOMIC);
-	if (unlikely(!p))
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
 		return NULL;
+	}
 
 	p->key.addr = *group;
 	p->key.port = port;
@@ -1306,6 +1308,7 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	if (!br_multicast_is_star_g(group) &&
 	    rhashtable_lookup_insert_fast(&port->br->sg_port_tbl, &p->rhnode,
 					  br_sg_port_rht_params)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't insert new port group");
 		kfree(p);
 		return NULL;
 	}
-- 
2.39.0

