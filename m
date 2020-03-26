Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6518B1938B8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCZGii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:38 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:59543
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbgCZGid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lskYZjw31fY/+ojKQJQ8gi/kINtevt0BJq+5Egu1DhMEx8VoQdKFLo0NOG+xDBvq2BwfLf8pJJ1vugBydNbw2IgtnfVMPICVNE6kHm7bqxxfvHfGAZuupdSVkaRJKaCrE4N/aAQwgV1STMQXnr4ow05JR67A2QrBotM5oS8ukb78uSphu45smIZjhVRBFOVwmRYmtClgAOFR0feTboiXMMeUE0EEIyxjyO6UK7ZOOR2YVJ1Xe7+dOu0lWL0pU1rNL6fBAGEElbT6tfoTipGMaabBPtdQJCRjFgNbnXff8IYZVrIw0cIpG9LawRPQmutGVRPntqYiYlsnVxvnWt7tRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+/iqBQSWTZOqPKOiJ6O1lINWegx0IqDguSVb1gkD3Q=;
 b=gtBHYVWLDUhK/2iIRrCqzUyWu80/whw8VX1SPKlRJIAbb3FP3hcI3AKttYd5JgGTZzSP5CJ0q4yg7nJi1LPvu7nPXRVirwILdYVwfiKfGUQt9muzARenBIhzE29vZsc6EOeWpXVLPGq3s0/utaw48sA0/OzJEJhgL3IFa6swMomzjS7wnFLr6RULhl6IpFUM0RUCLzyBCNnaYtQAC7CiPhZzEpnZz4k/srVV0g6VGI84zmJqR3JlJ3Nxy+31KUWSeQrRTQExGkGghFADacwxu+rBAbRVXxUFSFDVzR/0SwyPL3rLrkujtjogFUIdyXDBN52GPz2frko1rKJ3hILyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+/iqBQSWTZOqPKOiJ6O1lINWegx0IqDguSVb1gkD3Q=;
 b=cK+TNFypDynhgAUTKRebh1n++q4RMA8NVxIdxnDMM4GpE9N68xuWLNKnkG9Wd56+qNieXetMOK+Nvt2/HLM77YArTJp/XK/uwRWHhpFtLT+jJMwwc1Un6NMRqnoMu9BionulnNH16QKLbTFhxnBJeYkgLr4DtafFqsCo966hXk0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/16] net/mlx5e: Fix actions_match_supported() return
Date:   Wed, 25 Mar 2020 23:37:54 -0700
Message-Id: <20200326063809.139919-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:27 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 924a8d55-4201-44b3-185c-08d7d1504bb1
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64791DC51591702684425EC4BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BVoa82beQ+7aq5p/TYIGECpRBl05FHjR3nFrLrRs0qKvQBBDOcdB5OxpzMD3kQLbu0RFlMt6B+cxcKzZsLh0jkAlxioWM7WN3kfVP2jmgfPtEZq0NIEoh1K9fjpX7k0habqB9Qg6j0EMfmSaSA8DpnqPJHlynei4fw6PEOnog0OFvc/v6owU7zabPJkob4FwZdrLWYnagHD5g1jnq79ciaiR7HAwGtKS3rgk0VSXbb4GW1nqGPF+aXYXyHMWMgc2ZDglafotD5c2wBm7yyaVF/i9eIBeylgvM2PzlMjCaRsyYeu6mki90vVYLNaDJsH/Yc8wefeHYkSiGHQuqrbhSG+UYSkHCyNV9ZRKFd/rvGwWGHYBemkcP0kMx67f4tDLyolanBEkoS5vXULJwsAMOmRDnYFLLNryuDvJTBw5dsCtSTMXskfAlY8ukMlJQnzDQCVPgWIzcWO+D6kIcPKzQLQvD4vDTeFdXPAPaUCUS4scAOb6u30n3CMd8mhLHrk
X-MS-Exchange-AntiSpam-MessageData: jVANMDWjJ++lWj+V9eBXwyVeW1wRtwBZOv1dm5hyB5QZ9zXxoJoOwibgkAsRjQzXagupCUXUN8lQpyiEqiA3sX2nehM6cOPFLNpqkUbiO45nnzps3zjVDZYhRu2a8cr7cWVymQhKxU7a2GCCFSWpFg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 924a8d55-4201-44b3-185c-08d7d1504bb1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:30.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECBXye9xFSVL215H/rKoAe3bHomrZqCOvLXI069qaZ0OIzlhtllvuENRGhYlxUi9HtMsp2a9gut4Epn4ilZMdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The actions_match_supported() function returns a bool, true for success
and false for failure.  This error path is returning a negative which
is cast to true but it should return false.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 901f88a886c8..c7ed468db3e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3057,7 +3057,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 			 */
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Can't offload mirroring with action ct");
-			return -EOPNOTSUPP;
+			return false;
 		}
 	} else {
 		actions = flow->nic_attr->action;
-- 
2.25.1

