Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD15418941D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCRCsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:11 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCRCsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ehvm/npErR6P9q62MK4h2AzVU+VKv6QHjgvLbqoaKJkGSLxdwSWcaJAZgzOm9ZpnZbm5fTNeUBHwPiBeayYdYm3haKb6pGtvuqgEJmfidGbxQ18npp3Ah/FxMvuRZGnwGSDxTF8+mXIp2F0tHhsa65tzWtYsFKEHHhROvtcEO4uwRj2miMKujV7G/Z4EWToY0B8QBsobXYLRCFpff0MV3WP4E2IiNgFj/yMPaxoGoZRru2Agm44cTsVfy8T3hGhTChOu8ftP1Hu8P1uJgpkRA31kkVes4IxO7fQoEP9op1y5/HchUubfivpGbmq0xi2/2azbjNSdXdrs0duxalyipg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/0JDZtwIt7Z09Uh3u1+DMfO2KQlwIWAB89RWPlrmhI=;
 b=a5BC0E2hRhQXDFSGiIebc6ho7HGSzzFLAC8aLbplmDXJaHYtm8/AGgRXA1tLmO79lHKtabTBni7xRZVXj+8f8QvjOZ2N1u7sVIN2S9EB/ZdUexlJN8PhdQ/0Wh/Q4tsNHacTFXzK8mFUUxIwk6VxW/EcYJ5AJ/jGxIlRGb0XmlGLuLs1oivFL5JmeS88KXNOgbPdWKxalvEGw+4GDVjdOQN/pr3bwMGxhGrLe5Dr5I2H9MrEtcu91mvMKPI2XFi5X7WX0lSJYaQJKWEgu1MDJCrUYBxGWeW8w+USCx/wVANZ4x+KmQc4i/USJ6fEuVTG2r33L0HeR8dACTdmvdfEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/0JDZtwIt7Z09Uh3u1+DMfO2KQlwIWAB89RWPlrmhI=;
 b=jWjspd9LRANNW4cTie2yUVJHyN/wTFU0KIz9X7M5YSV0L5aPFGkngplekGJXLr1ctC/jp8BkwC7CAorlT6B3BKeZuWRq8pqbYk8ug5oruxUahhEvY7eKWskwLf3BEew2WzRk8sHN29MfoNa81XSWPh1OdAsGW8teKwls8gUDfkQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/14] net/mlx5: E-Switch, Skip restore modify header between prios of same chain
Date:   Tue, 17 Mar 2020 19:47:11 -0700
Message-Id: <20200318024722.26580-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:01 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3aeb8cce-acc8-4962-4a99-08d7cae6c740
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109688FE1564C2042B49BF7BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8s/sN+dfIDwr4WD1obV9j47q0dUb31aAZzVsHnVOJXOqdm0QodLRVqyIR1SPtv0SoKeITS8sTtmm29gFVTrA+RDahLrmyS2VVfI6IzDkK//8NLhMQjzb5EUbLxLkJjGKYsfRj/38bMC5z18xMOtCqKMaQBr+X0Spb06iHn6UrRvlIRK6ypDYwW3KW47C84bAhyduvSF/j3/pDN+jhCRb12zvrZhVX9R3fBlWeB3m/2cDRnpLBb1aKdogg5OXdpq/INlZ6cJxgLGY8Su6oSAhLV83taQbhyXa3jaLwxINXwlJshpMa7YOnVIUAJESPn/k+cv1n3bGocuTkPQ+RikLeqWoEU4w4+ABNQv0ZX63YmI5VGzBxVdTnBMLgtq80zw98f1sIyzu3yPmA4UValfu9fyZduQN9zst1vddYOWhfpqMDefgHlalxkUx53FRko/ulCcOOjXWcd7MujAYCKdfOqfBwfBa8NUagT3yM8XheazEUxiEjf8Y6PobT0lafP1g8eC7Wh0bLPOpkE0SEAqfvCf0bwemuf+HQ9chLwDM5w=
X-MS-Exchange-AntiSpam-MessageData: zALYTfe83kS2/DN6z3LUn/4P54DuYhMSBDXWj+t9hYg7YLrjIHDmTIaomKXLXxhfKg7gDeFOB17wknQFHX15xYUWGWHczbYa+WHsm+hQFyW/LptZ23PcwVc9eLQvEQFkLSGOKNm42dBbRMBW1eotgw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aeb8cce-acc8-4962-4a99-08d7cae6c740
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:03.2881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8aXKp1NPz+ZAU4kgpGmVH+3BplnfhIuX/Qv0lHvOspdIhfCI6MM2bHkvVyUaxBPbXvkTTbPurJfgCrjaHQlug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Restore modify header writes the chain mapping on the packet.
This modify header and action is added on all prios connections,
and gets overwritten with the same value consecutively in prios
of the same chain.

Use the chain's modify header only for the last prio of a given tc
chain.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index e1d3dc31311a..1e275a8441de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -422,7 +422,7 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
 	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = next_fdb;
 
-	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw) &&
+	if (next_fdb == tc_end_fdb(esw) &&
 	    fdb_modify_header_fwd_to_table_supported(esw)) {
 		act.modify_hdr = fdb_chain->miss_modify_hdr;
 		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-- 
2.24.1

