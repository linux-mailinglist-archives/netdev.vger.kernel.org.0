Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7FF686CE4
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjBAR3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjBAR3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:29:33 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555E49E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgdcUYEapcY36IcIkr/34mLbvajN0TcNpw1acLrahDQgq0rIknokm3a4UJvRCuj279Zr5/rd+MfzRYOKroMfbK1EawCUvEgRbF08RQSPrw/ZrualFifGo70lwT5VDDfuJ1HMSvCJetDv4R4XnDyzpUbQsU+uGvqr6uEeT+m8zwVDfuUHppdyUGMwZR4H6/2uKJolDFneCf31JLobuw/4D0yj0AK5c9KfxCqpwiktzSdxp6N5OBX+BlkXfMq1BKcANQIA1WjhXsbxlFzZ7E8elX87gWcQyeuprzKG3FXAjwyqKqgaUpFzGBJEj6Lap48rIPtrMaHgSEToU0PMKkGGHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mi0HcXRfnxCn0D4PZfey/Z5aFAVAe+BWvbAoqyeXuE0=;
 b=Ipxbzovh0x/tp2wLJxPWGihldN3HeV1OymEMGDDI4u0iCx9KhuWLxoutLnMA9kRvNslCQcmQafoCVdIBCMynPVEy4WO6LUZ9V2E/iFGO0nJAfELTYXPTU/usa0K5hepnpuWJ04mLaxKEgbTG6BrpoZ4zHyq2sLSlwylk8M0q8YTj+vB3lNJvBHMZLwXwqlDSWFIel3gtVVA5mUPIhyJmvF+4b5SFGbASY5m5dm3P+rOczalxCYYD3EbFm6GRR/Zg1OLh6bc/X51SEpGJAym+S37HGTMuKcpXntUj7Dkb1WuUN1ggGUjRwc6AnSQbRBk6ssnp6u0kNyHkBia33tNEbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mi0HcXRfnxCn0D4PZfey/Z5aFAVAe+BWvbAoqyeXuE0=;
 b=fhpguygsyazt8rMdiIwfDkj2YC2pLjt8qHXNulRYB3sgPb8pPy7WXDtJfgW2OR1FbLL/+uxuYCZPT7v2x18+/Nrhu8jRI913MWQQfzPm/1+rnPVjTHZbv1sLZ3AKAK3ITn8UCv0KXRoOfPLMtZnXUTh//Hpprnm1J+hlemMqpOJtNJZGYjN5niN/m1nIIOl5+nhN9xXRRuoiw4AXnPSYaEQOZplTnlt28bVssKEvDdkDCsGZWO4JJcG5WcFwepGnoFAMJ15RuUM+Ic62NyERSNLygcAQ2VSMJCUwuGWmpNIDh4iOlbfTiEXUmoXm/gfZ33D9gc5habaFGYDT4u/Otw==
Received: from DS7PR06CA0013.namprd06.prod.outlook.com (2603:10b6:8:2a::13) by
 DM6PR12MB4233.namprd12.prod.outlook.com (2603:10b6:5:210::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Wed, 1 Feb 2023 17:29:30 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::c6) by DS7PR06CA0013.outlook.office365.com
 (2603:10b6:8:2a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:15 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:12 -0800
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
Subject: [PATCH net-next mlxsw v2 03/16] net: bridge: Move extack-setting to br_multicast_new_port_group()
Date:   Wed, 1 Feb 2023 18:28:36 +0100
Message-ID: <8b4d7b2d66415a87e81a2e40c1d38111c67922b5.1675271084.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|DM6PR12MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b8ff77-6ecb-4722-ce80-08db0479e027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsZQd4CG6//GJx/phEtUx+c1Xiz+3UHQqk7diYlY7YHSluEJnVBg+pGpzJwPRAx4LK2k+t5LIoCChFRjHbGgdgP0k2z97Jkf5WRda2jqJHvPyCQ6mX82iJ+KZbzJmzrIAp+RNAsilUHt3U86qChJRN5ylScxQ3UH/1mhWWl/UDCjVuFImUCEin9pz3MEHww2E1xN8jD+B+1tRY78/FQvP7jYwVzeYHGKJmLHrK4+0kOZPMvlbQLv1mOCPVfycABOuEZYofwhdzTvUB/oPh2FXf4Fs1nxvgsp5TQi9eVhnT+I2hQJ011dsQDEaYRGCnvHV5+gpdWs629B90YtU1t1S9xaEpf9TBbUKLMA72NSdZcrACWfAJw7WWlbYc5ROdAp94xV1msUIo6jFFYUkrAp6lFfk47H32I/IzYQi8yw8J1OYg9bppfYE+2RoCrsynHX8xxrkhOtFf59k2y3LFNxF+1gWgZQbK8IXpIMN2+1ZvjbNylvlrZDO4jNIZLniwIUSHdM96hhJqSGGmxUWs7DCsqZF62DlHgPmVmrjneS2gWNugz41n9gUn672Dm1qZo0AmzIbdorL1X23HbLaN/jkpniaDRRP4xZUm1vLa+krakLw09RFLcWbb96shYgYqRweYxQYQB1ypZW0dZ11iPd342OsxIhMtlQfhbLEF5k2QwN4VB3wfh4pvjYaP3eUxqyl9bN3S676pWMF/NuFi4pcw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(356005)(7636003)(2906002)(36860700001)(41300700001)(8936002)(82740400003)(5660300002)(40480700001)(4326008)(83380400001)(426003)(316002)(110136005)(336012)(47076005)(2616005)(8676002)(70206006)(70586007)(107886003)(16526019)(86362001)(36756003)(478600001)(6666004)(40460700003)(54906003)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:29.9753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b8ff77-6ecb-4722-ce80-08db0479e027
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4233
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

