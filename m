Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE201E7642
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgE2G5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:39 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:29351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgE2G5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vyev2Kwa7VMZNRCLKXxwnKM4FxDLAZxlIOb+XzrzLJVdisB00czO+iL/pJT0lxZnqHGVTsw+RpGAAoEo3nUbVBlJpRE9ta64VmemUNOFpw1NIxtgGlcE4lMpWNfegzX7X+NwtI5bZn9038I092wnoZOM0ixeXs8RQG/mjPcIVmvcy1+4CHpajXbdtN1acGEIf89lMGqn32kovO4/F0QBl0fdRvxMEaKMuCBbkdeLGy8OhDZSUFn7XnGieIXcJQjwxJPdyYFl518D2eo9x1YHL2xADueLMNol42ynBz8CY2rdz4cTbk09w8yTF8QIS9XWzZvD2rnqoN71tT3kuRMSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQlWUT61fbhYKqM6r+Haofk/+fdl5bDfZSmt9Y8fXh0=;
 b=FPm4DV3bnha6KY2tvgWIP9QbGouTqA/7CkDYVoLOctPQg0261jnJ0S+g1Nrc5EsPrR/UdJpc8riUIJTsS4MbbePOIf0wN4IqQrAflbAA0CrHLrL0yrLasAYGlSBztX/Vnz6ubIQoz1ZjqpaL1jVRgWACeXpKFsQVOFR604fMVdW8Rs/1j/eE1J+GvJQS+qEo2CFExig7ZubjqPEhjKi0obWRrYXMyjB69Sns61sko5Rj3c8rNHt14oxUNaV3BITpLFUjxBHCnSJysrXa1tU7RMMc+ApxnnAND0QXBNXZ7d/M9i68iHH/H9YitIua5NQLndNyPaJv08fZd4W6DxMBEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQlWUT61fbhYKqM6r+Haofk/+fdl5bDfZSmt9Y8fXh0=;
 b=M1UsRHhnaqXojDG+HO/mPWifWxyvIgzVFZfNB3qzFtRtrH23BHXxGo2IcXqZ/hRojEnbkFrZ/qSfIEXsyc+4TSRfILXHdTFUT7h8KRhzCLgD/6xvUJYj9pVQiGGQgMuc0GZRsFSEVOtyNHkM6NU8Oy5h5kVMMLBiBT8S4Jg3/R8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4189.eurprd05.prod.outlook.com (2603:10a6:803:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:57:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/6] net/mlx5e: Fix MLX5_TC_CT dependencies
Date:   Thu, 28 May 2020 23:56:45 -0700
Message-Id: <20200529065645.118386-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529065645.118386-1-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:25 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be18cc37-bb6d-433a-0796-08d8039d8c9c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189B4390A2341A20187711CBE8F0@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4do6D6VhCl1CYaDHZqQvXuERLq3rDTOTB1mzoTQWsYonWTqOvkNc+zLNNPG3VdHPIqlS21rHd7t0BEaAetdYYstjGK/1z+akdwwN5E7v8KeVE5o0LqG8i1si7WLsNv5d7zzjGqnp3yPByRYSPjBsOulubRHuQF4yGyLEVSoFnyDj1mq9GvC5TMlsAFTlVdDsGYJfzJMRxhP+2edPdFoLQXAmYyRVReCzXIqjOiPtGYEJ3AiKwmn68f8Utwh6L+jju3HEJwgogwY0Mz5xMNb/d8KMDubIqxw6GTjRwlVtSFLIMmxtKWyav1J9VM6Pu6vvAqnFQw2r/MBdDI/fq3adnTCeDy48R0ofVbWhZSTejoFJv21Eie8Aqv9Dp+5MkpgR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(26005)(1076003)(66476007)(8676002)(54906003)(8936002)(66946007)(66556008)(2616005)(107886003)(5660300002)(956004)(83380400001)(6486002)(6512007)(186003)(16526019)(52116002)(4326008)(36756003)(6506007)(2906002)(86362001)(6666004)(478600001)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 04EuRmXZFmBXAlu2DkPySoEoSmCHvWHpLynCWgWpEU7nVtR4SXJnzb33Q1omenpzPCEwrLHCKNyPqrQSgaOT4mfYHI3vU2Y57EhJvupXiozJlw0biDmDci4bcFmGMj7v6E+qyECC6tjPCPdSpLPbFtchgkgpoLyjr90V1Cpu93Z1wCMMhUz9DcLdfzI4pr6f0IyBlpghOO8a/j9en4sl3WPQj6xH+u5XH9CxlGGeHsHQTZVKSq1408XavbjEmJLZPDtZ7uJ4/e8GQ4G7rHFZvZBbANa2UIr5L9us0wZPX6AhQrCRIV9lNAi/9hERQTSklSufMQTnc8I+/+yzNdL9qK3VMioxY4NfdpupqrTOMzDWtUnIMzSrZqS0OTzH1QDN+xV4FgPaytPV53R4MSmR4WnU8pOvYo3IqBfKrweWG93wA5c/+A/TBd6EWvockPEBMVAc7oQN9T9D0HQgmkr+3ZbAZOeBvWIQ7gm97SaGIZw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be18cc37-bb6d-433a-0796-08d8039d8c9c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:27.9678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pj2D7vMyscBdMwYfyew4HH4vktQ0VCKXXBVEUhxxVqa3XXXC2Fg1k1HpQfab93YrEKoJdP5xIPWd/7j0wp+ANA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
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

