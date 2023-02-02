Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F026885D3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjBBSAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBBSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:00:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFB46A333
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJinetUz7MbgYBRlItW20wcMSau4XafckKNBAWWpmXgDVtNkz93aZTxZWTx6p1S9Mg0ph1cFokB+6eJvjtwBOGoEI215hE17Kau+Eu1UC+t1SIf6Yqmie+AK6/Yoqf19wHEslG7WaXx8I9+6sCzyALPHPOC1POp7Exsiv+cpZugv53aLaJeXQ/BWyof6GGG6Sw3wm/OJiJMpl3oX3Ldbw8YmUg+JsCamWvbIVEjawyKym03MNcv5cdsm/C2G+pTQCDiN500D1hthC7N26t40D/a96aa/ZyJITHtX2pucwuMSbTB0Y6/9TlvnP8tHyuSFJWuIhS/5KL+5Z8YnN7Faag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mi0HcXRfnxCn0D4PZfey/Z5aFAVAe+BWvbAoqyeXuE0=;
 b=i7L4RSv405thPp21UIneMo2TBrQICLhs7aC6XNBCKLN23UFJlOJaWH6mN+JsDeBnab+0VPEmDhlOf8SorS0vqBFuP/glRGcpPGqWj3KSQ9lJ15kGOTSDl4GgZ3MeXxbN3sOzr3BSZK5NWN0aQls30ftajN3tlSD5wfXDln5zNrGA7BL+IF0TROfUNWQUIcwvEj9hfp4Vl5M98zQvwjlLxO/Tsw1pD+0nvWajkuL+Zi8kUozgtBOOJwgrXg+T5KPX8jKe0t2daxCCfsnji9U2iQ79eblv0CqPHwDi8sxsvbb0ccUVhOJKBeWGhgqAih6Rp0s5z7SlEtdQp8xlijE7kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mi0HcXRfnxCn0D4PZfey/Z5aFAVAe+BWvbAoqyeXuE0=;
 b=ejV5C2Yeu44Qnv/qAANUJzUV+psW229AoHmlC7GnVt4g8WARFWNnfMD/4TKG7Z458SHdyJfcR8sv9LUivP3wNdqUd9ulfs2UVAwZPrtlEPJd3gSpkJagORj364QrtZBvodctebKv1OhfUYAPHPDzJtLdRNrqRcM0Wm48kE8ftZzF0ERMvz0QNg1OjsCPbC4MWNVU3ogsrl6dIT0HBRgwacLDygna/0U9Pl7X91rsNi0rOLSGAoOQMG+pjbspHqIe0IppEbt4mBtG/iVUjmTj2yZOqnaEPUhLtaSOCIi+iqxI0TT/AGHDqQJugUakuQyy84VlAm6GAL7mwRccOaElvQ==
Received: from MW4PR03CA0274.namprd03.prod.outlook.com (2603:10b6:303:b5::9)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 18:00:41 +0000
Received: from CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::d6) by MW4PR03CA0274.outlook.office365.com
 (2603:10b6:303:b5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT106.mail.protection.outlook.com (10.13.175.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 18:00:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:22 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:19 -0800
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
Subject: [PATCH net-next v3 03/16] net: bridge: Move extack-setting to br_multicast_new_port_group()
Date:   Thu, 2 Feb 2023 18:59:21 +0100
Message-ID: <8b4d7b2d66415a87e81a2e40c1d38111c67922b5.1675359453.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT106:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 22be72b5-8051-4a21-b5d9-08db054765a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yHp6xgLtWlqhkJW+BR2OE6kohyfNEF7jfHuQCHaeScXxkwsejUY3MmJILf5hBEaOpYSWJrZSKXW14DlhftUCfI1NMNPTfkhZppQ5nXr/NvirxzGiKRKfnBClQmP3Z6/twI3PlhJ9Ewzu5eDFpCrmipUdnUUFNFWAaFVbZJhwoXZ02VLK9DLhsUT0DPbBUQisqO7xkP5cPG6sSt7qeLNuiGrIgfT0i/YJViL3HUWldP4EXjIZVrxFZzMibZxHM2DKxoXDrBOtDIlkPG5vpMj/cfXnXHstpdjQ6THhmJfBaXNXPBCwvxVB4xJQxsL3vGbzHeuewIEr5Na8dMnMSwM+mJXBatyEaQ2tTbqZ1MTyqZP1kTaRBtmrMbTj3JOcpTnsbWe7h9iUAoDRyan5COCEmI6Uut0cGHyNyHLDHVEbo1MyuWvne7HymYhveM1pY3AP7jjteZxrZKHrLqePUvEaVaYK4ez97ivDJMeqIiTeQAMmOgy7vQSVxlU31KCJPfNybFlvdIqWo1yKq1N0HesVkmgqtMOWiUhLEUMKSLBUVebVhWTe2tlHHkzc0xvxxApKpJ+zl8ytWiKEFZSAL4I8x9Z/LLEt5JMK2zbWUsAaRHrzvLYB21dRuRFWXg+pA5p7Hk3D5wBQpvjTa5Stf+sCrGQzmUTMF2yUSvDuBbIvuWmi0+MKdOqXwxdL5ZYwsWy3peHmc6xddVFtLastCCXRVw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(46966006)(36840700001)(40470700004)(110136005)(36756003)(40460700003)(107886003)(478600001)(40480700001)(2906002)(54906003)(5660300002)(6666004)(86362001)(316002)(36860700001)(336012)(70586007)(83380400001)(4326008)(70206006)(47076005)(186003)(356005)(26005)(426003)(16526019)(41300700001)(7636003)(8936002)(82310400005)(2616005)(82740400003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:40.8295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22be72b5-8051-4a21-b5d9-08db054765a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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

