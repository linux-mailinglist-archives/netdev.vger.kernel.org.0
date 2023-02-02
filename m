Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C266885D1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjBBSAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBBSAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:00:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0136A6A714
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PU6S+M1xu57qMDH5FdbQ/el8mrCmAmo1rWklpQrpLKoQP1wiIap7IV4jwEOTgwi3x0YN9C0OY7nsQye6NYB5AWeikCiZEOOnLWxqH3TEpFKBmNOEX2utwm8aW7eb1GtcMwBMH0WZ/I5gcoxHZhonw9szojkEjBPWxms5XusvTVbUCMgO4wM0C6mARm9b+RYoJ6IWp/k7AO8RRWk6g4yPfv1GplkhBI9S2g8XClgLJTeo9CiHRGwe8k771Gw6uZ6+/BQ4mOy3YOyAgTNTOCpZt/nXyn1GKJFn548hR91C4dn/Dv8BvAyHGALHgsOh4ZITOpurTujLaMxXfFg6kYhqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upzR7VV2sJ9tAyioqhC27xFIDvYZi0sCsX60QZBE1Go=;
 b=KHQ9LDAvAdz5En1Nz8VxpyHHmlnFH/+ivvvEzWNynnFxXQRR5E7qaQAnLIPZ3Q4ZPU+g/QcIvGmQ0NwZVNadX3zsvzmVXNT6CYo7KCvOlGNeUC0Jt8QD5pJBEh6SB5KEJvGzSeVbwQR8oFf2CKbDC9lKTrKx6LBjeFmyEjH6DC5+dLqnRbJnNRW8g1dDx+y00dDq20gRDLHdx5pf6/Y3pZH9wxndckR8FZ5SV3guMfzcVACfIgDPFohqXyHwSBfY5fCJxsGqBSsw6UPHg8JLZomJW50KXzCj1lChcHfq1sCUp+u2HuJ724cpbifZmuvKM42Jvcu+yo7y5slVqvOI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upzR7VV2sJ9tAyioqhC27xFIDvYZi0sCsX60QZBE1Go=;
 b=QmN/5ZGWcWQrOje4vIhts5CK7sEfHJafrVzeCjrDiONe+vDScF7q+RAEenkEGMhe8YfiAuBP7ZNeZeCCct+V2D5DT1w56m/XhwXT2C9dtKcPnmylICJ7OewAy/pquCWs5Ol30S1mrSFTjweLBXdnmDtLVc8/SQldqpo+Aic4QYySuubHX8tM9EO/UL8zESYLd7z/XZoSqTM1QL+1acV908GG+nmfNzWXf3XNrD+VIx/IhkAnmNm2y4sZMR/Woy2H7T40VJnaGM7GsQNeBFFlwR2kMz4JBAXPxAqTeEpAAREr5Cz28IunzKlUlj+TcdMV28SkvnTH0ZOvl8uUwmyjAQ==
Received: from DM6PR03CA0030.namprd03.prod.outlook.com (2603:10b6:5:40::43) by
 BL0PR12MB4963.namprd12.prod.outlook.com (2603:10b6:208:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 18:00:39 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::38) by DM6PR03CA0030.outlook.office365.com
 (2603:10b6:5:40::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 18:00:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:19 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:16 -0800
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
Subject: [PATCH net-next v3 02/16] net: bridge: Add extack to br_multicast_new_port_group()
Date:   Thu, 2 Feb 2023 18:59:20 +0100
Message-ID: <62e07d61d15a3113ccbd85ef85d0fdd74a87762d.1675359453.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|BL0PR12MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: dff2c921-658e-493b-60ae-08db0547649a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWOXlz4KlqFSaB7D7iGQ61Dn6PiZDBuwsJn8amd7ks1FKyNJNCUa4OwniT/g/YM615XP/XjpXeV9kN/3gslPOTugRC5NKq1E94r4aGM2r1Udr4YBumFpsjYPKqnIGWCkc6cHmaRUau7qTO7xvZTG7Jq1X0JH1twYizQ2OD8h3kfH1hv7L8COwzumrbd9FJmlR8Uokk1WpdcSD8HVsESvsiDZ+Jxum2XPQna48Otqy+Cs/5p8UhDkd1/CK7EaxCveDKP/ucS/0pnRk3C4HMvD3xf1mydyqEFolJuDAdCORt7hkDP+GCP4trJiWc3681vYh1bsQDlsuyOJl/MYaBPbFeLrVHtoSwPwCmKnTKWGTNbO77NgAplkf7AKs7n2vr9kXUJJOcpCAYM9dQqHghCclGr+MFAkR4Ib1espgqCeYWlJAvN0b0aEvzfDpugrpvmooMsDDpMTGuflzIhFEbuwxQkoRn1glfnAk2oXNCXJ7yXPDCkHV5v/ifrVtQL+wrckkcANkidCjs8712/x7OuATrI9tc2xkWURWgqBALXXDgQ0F1GsZdr9xrwlUpyzNXvv280CqY9oxbKhADvrLwLdWa13JcYKL17ayDkyJJLjGRgMdiY+YzHLB2uevCZtg7VRHs08GPsCjovNC/82yE7/LJWJxgxW+p6ltLP0eoZVIkPFMoIG5wldBcpxmZPQGBDfH07+I/ibeW7jlORd0ehm6Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(5660300002)(86362001)(47076005)(478600001)(110136005)(83380400001)(336012)(40460700003)(36756003)(82740400003)(426003)(7636003)(36860700001)(2906002)(40480700001)(316002)(54906003)(2616005)(4326008)(70586007)(70206006)(26005)(356005)(186003)(16526019)(107886003)(82310400005)(41300700001)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:39.0150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dff2c921-658e-493b-60ae-08db0547649a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to set an extack in br_multicast_new_port_group().
Eventually, this function will check for per-port and per-port-vlan
MDB maximums, and will use the extack to communicate the reason for
the bounce.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c       | 5 +++--
 net/bridge/br_multicast.c | 5 +++--
 net/bridge/br_private.h   | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 00e5743647b0..069061366541 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -849,7 +849,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_INCLUDE, cfg->rt_protocol);
+					MCAST_INCLUDE, cfg->rt_protocol, extack);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
 		return -ENOMEM;
@@ -1075,7 +1075,8 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					cfg->filter_mode, cfg->rt_protocol);
+					cfg->filter_mode, cfg->rt_protocol,
+					extack);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index dea1ee1bd095..de67d176838f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1284,7 +1284,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 			unsigned char flags,
 			const unsigned char *src,
 			u8 filter_mode,
-			u8 rt_protocol)
+			u8 rt_protocol,
+			struct netlink_ext_ack *extack)
 {
 	struct net_bridge_port_group *p;
 
@@ -1387,7 +1388,7 @@ __br_multicast_add_group(struct net_bridge_mcast *brmctx,
 	}
 
 	p = br_multicast_new_port_group(pmctx->port, group, *pp, 0, src,
-					filter_mode, RTPROT_KERNEL);
+					filter_mode, RTPROT_KERNEL, NULL);
 	if (unlikely(!p)) {
 		p = ERR_PTR(-ENOMEM);
 		goto out;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 15ef7fd508ee..1805c468ae03 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -956,7 +956,8 @@ br_multicast_new_port_group(struct net_bridge_port *port,
 			    const struct br_ip *group,
 			    struct net_bridge_port_group __rcu *next,
 			    unsigned char flags, const unsigned char *src,
-			    u8 filter_mode, u8 rt_protocol);
+			    u8 filter_mode, u8 rt_protocol,
+			    struct netlink_ext_ack *extack);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
-- 
2.39.0

