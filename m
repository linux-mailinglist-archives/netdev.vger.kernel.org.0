Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8A61BEC3A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgD2Wzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:36 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgD2Wzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWeZo4vbUHZRxO12qV1no7cQmpjlhsggDcmX7hqS/50XP9Z2c05Vh3eToqoUFuIs5HHfhjpGuwcxajfvTcd+tLe2aVE2f5zOztMnLNJ+w2/xb21Onhx9QJr9p4lxqeMkgRS04xrMWeIrZhpzTFBFZ2Vyuz2d4vkwt3dNHxAfNtG9cYgMZHHXvvuxWAvUkGrq2S2YSfNdA80UaLBjcmmfXXuKeONTrpX8zjMzIGyYYo8Va7SjjSIJ10hTQlxO6TvEBy9lH1IgWtjNkKrC36Kd2GUezrBbi3mXkKi2Q/Cmz8od9j/eydaB7/bB3UF+WYK50pQ/SfngeW+be4sTkirj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OTtUiRkkxCXZot63MFRXM8FIhhj7QEossWMro4dok4=;
 b=hYoyP2xuCZUMZ79bsOBndrGU+EXwI5LPZkHP2XZcoYBd9osp4t7GuMaEPahsrNAFGCkRrI7tS9Sh2suGVbzGKXwRYOaludKAMiLJ7g8adoafZXFmX5KKabUEbJNwSYFosF4UAVvs+nl0Zk303PBC6k+iSIMdAdZ+dBCuV/bgd2VcFs7Gzpgx6DkznmPsCAdoy03zO1agos0htVs4puuHVdjj7MyYvQ6h6lp+/LhTZgr5RmpDuQ+LLuI3zdiCfq+1mBccRCEvvG8LnvSCBh4oaeTfQYi1TmieFKT76RykOmB9q1GOBZb1X1e7JfjV1f3dhfwQXjuBzHR0iWfPNN4+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OTtUiRkkxCXZot63MFRXM8FIhhj7QEossWMro4dok4=;
 b=BY9MDLxjXpeSL5+FrDPdYWkY5a8e5fDjNP5kDX0pg6cttBwAEm4rw54OFtvRoCpuD8ngUi5gzPscNpHfDZyWglfA4fmeIhEMgGOgqzgsS+nruQIdn0xB1pkVDa8h10bMYj9Wc11K16tzRzb/1dw6rJms6zyb89eK4JAPMTTnzro=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/8] net/mlx5: Fix command entry leak in Internal Error State
Date:   Wed, 29 Apr 2020 15:54:47 -0700
Message-Id: <20200429225449.60664-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:21 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2bb2418b-e79c-42da-0f72-08d7ec90661b
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5247E4467C2C32B9540BD3F0BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: um66TF8KCwn3cxqp6BLFdOZOUKg6ed0nxY5btZ52jFy5JdNUVtBKL55i4bUQV9B+FkzU0u+NPPUqPeEpYpI1VpCzB8RS2MTI+zWpY55Mo5Sb3Fqgxbp9Vzo+k1rKa2TDFjIlIQdQY/OvKl0TKftoEAwV1g4fC4+BMw1uURmrOGwfpjMqYaariYdAIAroPMvxXc03DuB5RLzaRUGsu7dwe6WtLPJzatezvGsTfZbg7/OKB0YShDQt5BKR56cgNgePq7GUGczsOqbs4bUKaabKTgleU/7UhcHkyfcQPC77GQJpFIsSyGHwTt2pCH3NEEPgo+MtJHcodFkwtxU0uNf7LbBlPZBUqDxqjdGp7Mb/iZEK4/Jekfu9ACVy8lt2eBAGo97vL3zJRyX+R4VgtJU/HcF16MuWHZl0/fuPYg9+pr18ofk+GA0/pu+otGCgj7Wtx/A+RDdEr0NXYcXzvw+eo9lqCXPVUFtROSrmp989AvHNmRE8oLflNM4CihRU5+f/
X-MS-Exchange-AntiSpam-MessageData: jv/5Kn4UHWyLPzXhQBNVEFvTiIY+h/DkKAxXbatJpA9te5v2BjI4NaqgnM4KXHKJ/rcwgPI9HC3JBOFi8NMDQk+kP1jTH5YEF+1zUnN/ED/fDq740lMWHFDUKdo//WzX5Hmc7GxWVQ7bAv67bzdack4ndXo1jpAxWiQTG+jBLPEFkbnWRew4oUgtXpyekTt9oI7feJh1RwBbvwpNccCak5e0pgifxkir4UtD+vVcEs5KBi79rcV0gKNACoNguxv5OH9/uAWvURE4tXbSeU26dQPEq8/YqI7k+cKk0ZbZCVvH8fumcOrhTz0JB347ChyEbCGQOZX4s4o78s8VeMlOf5fs3+VV8Aa2BVYRe3ljHdFd458d4FAD6M2YFTt/amwZSObpXxcO6LVkbPwB//Mgqfkd+HeUYfCbb1WkEW5MZLiZ4ELvI4qMtul5ax9NgrJjYLnOaLlZv8PEF+L+8+X53Z5++dOI7Nq0h/jRFRY5gKsw+WsAA92KA5NuQ4OMIiNHZ7xzAyUQzFONPCCLxZEpesbFWHaKWxS6OanB0kIGczRITV9tWk2QLi8L+fsUgEgxxvKHSqWZEdJFIgX0YYr8RNMWq7chUVO/krUCh1veVU4H0HMXXSwo24nAzsO/MVyO4bHSAiurgGNAP5BE8HpzJIhkGwxV3WXnbz6G7kCJLAqBa7yT8M6qfCaO8jjwHDVmK8HlqI598wLtw3Of/BegVh/JpPC3Ji4VmoIHejnnrv+L7w7l1v+kyZpyCQmjaKFCnQw8gQzUjqzqHbuR5mDKNqQD3LNaquygD9Xsgisrt0Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb2418b-e79c-42da-0f72-08d7ec90661b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:23.2797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TcOF8gTr40VsR8O5AE9OVb1m11ciSpOV6G75O2YODLN1GSZwCTUFtKDKdKu72DcZnhwaz/+imjk1ra1YO3zGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Processing commands by cmd_work_handler() while already in Internal
Error State will result in entry leak, since the handler process force
completion without doorbell. Forced completion doesn't release the entry
and event completion will never arrive, so entry should be released.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d7470f8d355e..cede5bdfd598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -922,6 +922,10 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		/* no doorbell, no need to keep the entry */
+		free_ent(cmd, ent->idx);
+		if (ent->callback)
+			free_cmd(ent);
 		return;
 	}
 
-- 
2.25.4

