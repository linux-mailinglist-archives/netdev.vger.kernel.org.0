Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3F1E763E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE2G5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:24 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:29351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgE2G5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzI6j03savATXm0lLNmQY13L5aL746Yo8Aq6dGQkDppIYiu696oKnoMs7qTMygyFqBgn5oApYRvvsqlU/kS8JaKrerYKveyxIa8D3E5Prt3m2dJ78ElgRvVqxK5gJNbnTODhJA1gSL7bc72+syAk4p21ABTtge0mF2iyYZpB/Wn49sMuPE0NlyLdQTgfxVsCj3yXs2NeUlaX4iTGu+Znvf8Cz/5nRXCSbC0LP8g2LUXHK/Ko6btN7g8kSuD+zrFNe8mmTZ+aF2bRLDro/VzOqO+u066PQQNf4XNAmEwuvqOghjS483IldMqhH+PIEKJaCqz3t+1cvdVblNhutL/H3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ/awVnXvKtJtcY0Lg6aKk/mePRFEgyNKxUfBuyXXv8=;
 b=GimypxHFVbci1Jc4AJoFSf+fGnNXGgpf+R/yGyl+aMlziJp2XCDtAB5qTZbaEnd6hQ9uzATUhEGyBaloZlkNOcDllCLm8JyB/MwugFY9YbxVAMSfa95hb7pkHvV0ZNL+TmMWlqxP0QyrbD0z/l6j4MeaoBzat3VgzO49O0gNpnfNFZsxpChzemWMY/8oKZ5NWWwKYYeY/Ef/+Q5mhQGiF0meChEF7HRdj2QdxMiPTq9H2vzgNu1ZSE1RBpAHGimD9QtUV0zH3oRP5jmZWd8NfcmPeEU1wXM2CzYXwPyh3yEwoq0/TzmD44drvUOSEwjigQ3ftJ9JpQpvW0+X3XxFVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ/awVnXvKtJtcY0Lg6aKk/mePRFEgyNKxUfBuyXXv8=;
 b=PBNBLkqFpv+s5397HFbjmSFlIPfBVD3GXlhSOcGXtRbFHqvjtBfEuY/03vh08mo1G9jaHpFt2B3FeprzpgRCa+Mg9NaenX6WhimeVQtCcb3J73OmMQYT2ILZNFfRXsmC+sWiha75NTCoZSH3vY7qt8GcUetwGmqTxVu3yyxW77g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4189.eurprd05.prod.outlook.com (2603:10a6:803:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:57:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/6] net/mlx5e: Fix stats update for matchall classifier
Date:   Thu, 28 May 2020 23:56:41 -0700
Message-Id: <20200529065645.118386-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a7191001-a23b-4dc6-ed62-08d8039d86e6
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189E2D20E81658B2CA6B07EBE8F0@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqxbEvvjO8zWhAjX8I+VDmw1Zxl9NYNvQ59owI4FMicuJBoRJkMLOyrge+ggWSscGJ8ntuHNx9TDY4dcPqA/VZheYPPeCFmPeTjb1UYsSRpinjZPJrKUQk7gXRD9m+E/wilobJtxktzfOh6n90kZ9gVFwFSMcFZ0x9efgJsKD6owPh56bFkcy4JKY6u+3J1Eeb+XB7CyM9P63AEwM3VHq+gQuQp3hZPZ2R2sokFIqwdF9a1eoNJ7hoRHmijjKYj+vhes0mkA4dcaB1qpr5YrE1sVBxoyVfITpuUA5AQPrWnVbp+XefSCRiFuGqyuTW9i8CAsBWb/URkZKKHC3hphYd97hIeUDbQI7Ux21F5llC41TzouRIkyrxgNeGEUQXj2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(26005)(1076003)(66476007)(8676002)(54906003)(8936002)(66946007)(66556008)(2616005)(107886003)(5660300002)(956004)(83380400001)(6486002)(6512007)(186003)(16526019)(52116002)(4326008)(36756003)(6506007)(2906002)(86362001)(6666004)(478600001)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eAi5pFzUHqius3Yi0GvtFOMuUa+GJ7XVvBvYxVBfjjYeqznOs9eHUfs4E69OM8keKN68ss/DhHcUdD4acHC58lZ6fiw4aCW8WrCJnYvxKYfkrI9+/PNB5MGVLcJCbZZKokdP8BgAsMxKbxhgf4lsO0qWDXlrVT4wP8TiMDcawIkchUer4f+wFO/CY9b51M9d8Hc5zZfCL7hXQxojj6m+cHOgP5S2lrDk0gNOHkh9wDTYZNFb9oWC/8hZSU9u2hjRqx/uoIl/uxfdKjhlwn7FV/BYZYpDVtEd86KzVscn36jfHCYYhr5JpsPetybwsn92DUryl/NoLkfl4Ol6a/uuTxkeoRKrgSwQ9ZQexRnKXuIrIf6r9G/r0EUY4jDQhjKdbIKQpnrnhBygmCa4tvrFICNssBw+ecprPPbdTe5UEPmAMtsU3kD8OmCxRUMhY8bwRI4VJwoHhLKIdBSCPfWKx1H+5oLgIjplO/wlRFfo9S4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7191001-a23b-4dc6-ed62-08d8039d86e6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:18.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuSFB4wU4MH5yIWIRv9PmV999tFghuy/p7sBLtmp/pF17KMmxKrh47zt97nsG2SRTjFlCNl75Z6MYa7XL0J2rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
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

