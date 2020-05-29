Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E2A1E8922
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgE2Uqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:48 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Uqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEi5mi9gGPdAr4YJbh6K4+k8sNzVcMMspuciSsYGJS7hOHXg78iTHOja1E84f/Y6W0hkvX8wP9+ChxFKEIRKKStKAjUKF9dkpnJJmzuMq5XfitFCcpTppv9KqzojszQvlaFGLxOaR3qs3gsksytx+6OJC8pV34slPIihAPTeDtSeAUlwgErxhUqSW+1I9TRQXVZJh9mdG5mMNpUA1FeIO+m/Cttndrpot4Pi3aS36DrurRf0TbAW+eEzmAPze9Q0+XK1Sl/BVcjkq/x3NIuK9k5KTPS/Zc1PD0Ihbj8JY/6vZk6qrV2KjW/g+ewQnP3Hh6K5TPTOC5sWsmvZkcZVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ/awVnXvKtJtcY0Lg6aKk/mePRFEgyNKxUfBuyXXv8=;
 b=RbcfMST8MrsWbGlIQSkO1BbBfTm1+PuVkNjAiyDt8vJK+6mAUyzISonzBXrph1+azqqh5mIfBowIyxTCtj3Tf/7kH4zq84KLRpd1Lj1pk29IdK2J1WYoYikPvPwZPuNrrOQpTnZtvmZJTL3Cc2mWgXPb9Q16kMwko1Mgg0DPdzeBM/yDBNntzMslPhS7czaEdg5lEw6uWfpYUqsFjhn5wewCSCvrreB5WD1tXzF7HFFnz8rw8e7Wmn9447fGxLZztWy5V93deW9pL4vdRyi1OWHDkEng7FebwFpuPPoCzMu/iprQ8IXkDUfTcy9oFLMnMl4kx80795qhQF8Ii6O7kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ/awVnXvKtJtcY0Lg6aKk/mePRFEgyNKxUfBuyXXv8=;
 b=R9yVZ2Xaymw59c/86wgBc7YjespdaSe93UqfiDnXEQfiBQnIZvrzsah9QmzC7kIdjwIu3Hp3j8qUYazcjU/EJxTKV/qrZhKZrCHz1SQT8zYB6s02pWiUFfhi2TbiBO+yxY8LIVv1YEwBm10UvXpW1YHkAw5edsblVVeVV4nQI2o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 2/7] net/mlx5e: Fix stats update for matchall classifier
Date:   Fri, 29 May 2020 13:46:05 -0700
Message-Id: <20200529204610.253456-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:41 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0665722d-18eb-4653-6ff1-08d804116530
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB335963EC7ABCDCF4408C6C45BE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETRDlRHGW6s5Dk4RG4ZwwM7AZiTB6Ybe9E1V2uDscCvCh1g4NFQwJTTP8MId2WJZulqwnsstnHdaJvH+IzjHUHJEYRr373O4QXqeC0yk2WOjSLgt4AFen9H+2/VSEOgzpPj6qSmEf0Hs1UHohwCtBQcALe5yWol+RIu0XwVm5klT1dTUkkQPZhdnkhyZZlNns84ycnmymaJFBjUSCFWFs/UY5utg3I/uOMWXVfuV7pOeRW/n2enLfRfEAtDKBKBJBbscin9t1xPHIdPOsbUEYnnquCfJvXaoHrMpyiSvJFdc+Q5w6/V6A5bzna5giZXuJRt+eKGR9rmVXKeICB8RDt1dPEQ7xataWSIVM9fJNgmE2ujW8/daSkf68Z96nwD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hIYyHyeb6dB4HkTUmo1JsB5fHFsqbR+hkpRNZxHve5fcFiFCwWKS+/fwGOuRGUF3A+24g97wJUWpWx6uL/gZ4KoA21q+dq0PT5jnZfWeUpnEcjPiIoJP161hNGzNDwZlb3xyNwpl8A11o84mGPAXX5DOiHYisZaQOU2mZ1o/5IJKBdQRwbYjt+uO9V2DE58dKTtyxMyX6vUyBooANEFSxWCrPTrvC6GFdUSFYRtbl7EKhCp4BVGteSI0Ca8aF/Jfgou3EpH7o700X1tNOBnbqrqHlclgGn4wG/iUuMWitNYkm5t2JfNiphMrdUefeHF1od9SN+85mkfe9o3IoTmfMV8b5O9zWLIpA42t5uTKFRhkY0PTp0UqaAUXrXsWXUgcK1hjl0lPJNmCRh/YqzqH+LrU2qqsV5ARvqd3zRbzB+L8TecB7qq/cQWvOKUyTF++y/F9m8slm2MCxZTl17hjTtPUG2HuLhzWCxKaHDP41dU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0665722d-18eb-4653-6ff1-08d804116530
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:43.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s90YFHPuGiVvr0545NSQumHUMRT7NeP9/U5Y+Ibuj1A7FFbloIjUtfcGO9N5vw5zobVb7YsGmB+O+DFP4sQdwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

It's bytes, packets, lastused.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5bcf95fcdd59f..cac36c27c7fa4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4614,7 +4614,7 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 	dpkts = cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
 	dbytes = cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
 	rpriv->prev_vf_vport_stats = cur_stats;
-	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies,
+	flow_stats_update(&ma->stats, dbytes, dpkts, jiffies,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 }
 
-- 
2.26.2

