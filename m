Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5662B1E8926
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgE2UrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:47:02 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2UrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:47:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxed8P2x74XDemWtwRcwh0ZXX8umZE3B7MpsJvcUOnLviwwW+lOOuM6MZaoMOmCvBu0K3MBycTPJquFtmBYKE4JNczpqPibvMtc0ruaurIFVJfRDZ9F4Pm4EwdFq+HlZMlJJ9ePp3FDyQkWQpwtT+JdLchpsEE30TqEaDqEoI99SMLOodNO95Z/o+nJwNBqelqGhSB+yQK0Ov+2P8vdzU9+5GzA9pNTVWvPiMDz4PbhHyAvTq+BBp+AuDVCyu6+skEolNIzZbPxIkc/7tykyccJMlxIGPOq4sqnlMTgGpCgR9ZdkrDzO1cHcJiihJ9psW9FfsQU0M4t7W6tSZMHSTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQlWUT61fbhYKqM6r+Haofk/+fdl5bDfZSmt9Y8fXh0=;
 b=dwLSaAqx59Qktz0f/NFSUWygQSyqbtdDVklb10PXIVnAwniTvQ3b0dfr3VnbXW0L03d2OqIIutuk9oxPIDdVqlGEesRc7/RPhcA6Go0+KylUvqpRrSCczpG4+gJyjQNyYLkjNaESKXIJHZA9EF7R+MlXimji4LYjrthtUbwesJhzKXxesTSc5gOg2qFHzDoJpKYdth3d8rnv754hSvW+mVjx/mQmEi3V5e4R5aPctVlRUrX7e5rSu+X4032YVhu5jKTyOrG3ssDDgLDb5PJVAOqTioVp8P+Ohv9k8IE0DjW7p7KEd95pl13Ykpom+CINwxB43lva0qQLGpgh2Ci2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQlWUT61fbhYKqM6r+Haofk/+fdl5bDfZSmt9Y8fXh0=;
 b=rGjZ/MBaTSONXmZxiAYJfo1oegNJjfhbO+StH3GMlwdZuAwu3mCNFN8B51E10v3WLkgsp94cCQD4h76jLfcirgcSZJyVn66WFQccoQw+XDVM2FLhzVg7QDPw+1kSLHpYv9sn1x+rmb0N8c8HMcgsDfKmuWZXwiqAbFmfcZp4Nkk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 6/7] net/mlx5e: Fix MLX5_TC_CT dependencies
Date:   Fri, 29 May 2020 13:46:09 -0700
Message-Id: <20200529204610.253456-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da59df2f-e10a-4c07-85b3-08d804116b73
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359E374A77E4C979CA5E16BBE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Wm75rvW2NBLxyMKlzgF+xEXSr0f3COFwp9p4yKoLdfHhIONihoX3sT7eO2tqfO3TkxXXbZmzwZAwyjyBHz//KJRS5BZXcY86Ww3rozUGZpxYifw2Nw1oS1Pn2fNxRWjWGkwYKe/e/CChHC4uyinDIhhNW54hMXFL5GMw70nyE3M+24XDFX5xzkL1EF23Ex2jqhWfru4o67WuUpWE5lZiObSm5OzO8z8K5I+ythtXE9DAVO5uhwqSqh7A4eqlZAwMqU+dR4+bv1nnKo2Skgee7MAoNKWUTuGtDztMS9tt8YOlEtyQDj2Pe2TBJpK5YDwHbDPPNWRzhk23RKKgxDpNKg1N5LrfoeRkOW/C9gZBmsMBnVWX5Z+nYWGp/gjLwQ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9WEpiRT38Wi9F9gwYpf72Fn8ju91UP/aCdK/150mDwUztUfFDtokytt+TZdfxJ4N4nu6nLPS0JvwgwNUJabFTYUiCBQaqCFvuQYR9hWSafcH9A+GvP7T46jOvYK8WpNhhIKN/fCMJSeAb9qyV+Erwk0nAR/2e2MFq1+ar9cnpW+RxDMOtXVxcM+6/DedqGhywnvTav4KLiNVZV5J9u7JwOMJqgwEUV+wmXccK/yxGJmuSfiA9AbmTdVRHHrACSxOZ8zwSisMuTmtuxI21VgqI06V1NsQa/ogLsBRTNHl6W+hkiNImfjbX/Ku1JhyY/wsroJPiD35qQEZezwn6HVptuA+T2pJwHAe1mI8e8u0uKTqzC5wx9cdpdbhan4GeckUaATnkbUouTL61z2AujWhnGXln04FscLpmJDVFiLQditzBLy6mZsd1HBr+3SAwEdsr5EuuSgPvt2J8HJXdMej4j3sR+ooKhcw8yXQnNlyIw0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da59df2f-e10a-4c07-85b3-08d804116b73
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:54.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTeeTt5X/FAdFwlVzoS8Aujwjm8q/s+MrCkyuIHQuZR7heIZfqA8+uDOSV5ULaGZo/kAdR2cjrbzY7mOMLNJ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Change MLX5_TC_CT config dependencies to include MLX5_ESWITCH instead of
MLX5_CORE_EN && NET_SWITCHDEV, which are already required by MLX5_ESWITCH.
Without this change mlx5 fails to compile if user disables MLX5_ESWITCH
without also manually disabling MLX5_TC_CT.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 7d69a3061f178..fd375cbe586e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -80,7 +80,7 @@ config MLX5_ESWITCH
 
 config MLX5_TC_CT
 	bool "MLX5 TC connection tracking offload support"
-	depends on MLX5_CORE_EN && NET_SWITCHDEV && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
+	depends on MLX5_ESWITCH && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
 	default y
 	help
 	  Say Y here if you want to support offloading connection tracking rules
-- 
2.26.2

