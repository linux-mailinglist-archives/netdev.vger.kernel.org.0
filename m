Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F1F1F7098
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgFKWsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:48:06 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:48:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmpmcEOA54d1nEt1wnpQi/7o1Q+pL17BVPu6p2MRM4DMGqQGD8xA32l8UN3Yqjx0l+mKsmSbV/GXnuCghYuxB5hZQD/aa6L/r4NjaRdNf8evFwj7snw/j7kLSN5AY0kxRasE/xVajbUW0r1nrwjxFzixZG4BQVffF8a7bE8QVpj7dzALooqY87JXRo+oVrSpQj+WvZ6vmq8I1vJ/ARaImQl17AXzzuTkCePcI1yCpOimHFWpXo+Gi55L9OwVxDUESUvKcgtswhLk2wgvjZgx+yXAGIv6G/+0qqeDDaJ4k6ipyKUZdXv232XnmKxvpm7VvaqjXli6CRkKA64uVOAMVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oqwWL6DsMLfWdGRAWRRyOUQDW0ifNDuNSCBToXltNI=;
 b=iV6OHEbfsi5Oj00Vbr9tHiBuCx04ajvzt4nXvfiSe8OdfPp5ifkhM83TWoQJbrkbdri2BNusSXwdk2VIxYkybWkRFD4RaZBPF27ImdhbMveIbiW17AM0fGuzycBmZ9hzUtzo0wf61Niwg1EnYxDo/FJCY3UQucG9G7srmjsxRj+Z/2bqWh+qTljphroVCZNd2XNbwRCTqQeLwXt+M/zmbxqBlpeKFQrsnKzO/o2VLDrgKo25CtbBKGmExgDkcGeTe8Q6Amotl5hqRRUFZdCsUil+B3/6rgI1Tjyr0Y3TRKh2IDGGL0MIz0BPDzu66+1mCohk4ovgBvLMTZuTQdmt7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oqwWL6DsMLfWdGRAWRRyOUQDW0ifNDuNSCBToXltNI=;
 b=j+FXy5NmR0fy1UUcb7ABTfc2lrdF3Quabu4PJCudMLuIbzsE9Li2WxsDSncghzNx9vsWWskHakiFJ24rhHbVHWs0dhE8LLYWNxiUdYIHda9l0eTukcFmbEBF5goQpH/NJO2+j1AUnvzRPLT+Wfoxf0CMIRcJB7JUv+U5wuJvRyk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/10] net/mlx5e: CT: Fix ipv6 nat header rewrite actions
Date:   Thu, 11 Jun 2020 15:47:06 -0700
Message-Id: <20200611224708.235014-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:53 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1258490c-7971-403e-daf2-08d80e597b0c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB44641344F0A610CF9A6436AFBE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5XKy1sNYQD+Btev5NgR2egqmxbjS5/ij7LQ8lXkKLUUI7zefaKbZsxvGBLNVlyUlMWRAGOupDCDd+EtDW8a/5QKOztb7pmpkiCkTiKzlPrEgNj7rxomPUBACrYhci+pRYs3RCZCjyHPYsoBv6sljNbKsermYHxe/nyz6dQIAkxcWLWdxyg/U6oQGqzDDCbeL3TOs1rndmXaHyv3hbT6CG8hCfF8ylVuP05WQtDW/keRxAk+iRXLHdFe2dvsuVZAbKwWLXGpjC91plJH4snzzJ7WpKrnGSz5gUElmu8VS8MM1dyG8j7922/ab0+w/4o2XG+B2qSbtQxS2Y3mMByewdJDxpIuBiDME28LS5Bxu46fFB66+BUDOi1t/L1qSFngm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BsGx/zEI1LcdpzrUejeCcNWyl6UpCwnc6bd9/DQiKBO+HIMqMOg+Hzmz+tSTdTTMMdl5oZn51Hotd34/cYqVWxhaseUYCGO4XKXV4n2MpWRpxiyEihvrTNf7hrjSKw+PnUkwor5CH8N6ca+mIk6wyb3QKxt8ftxSazvx2c/hGv7D84gQv2od2IGPEW9MM14vtiQyab4oSmqE+qcEpVz4fk5dpPVSguAF4K+zJTM9Xy5jnkYeM1vP4Y2wB8v0hDHHLLd6NSqIHk0LiD+3QathZbyny7eJl93Ex4V3WDo0tblXanfeSWgoPrLbn5TtUhBlYUHqjVygshpJfH3n/w+zQ37kNqSa3+G3Yw0/p3XKyKwhGjscxv86eo3rG3G6Pz2WX45e8Iyz1vdM8dygef8EBZAdPAubE2WpWYZq8OzBeTNP2fXphJ3Mo4et1tj8nVrIoLv5aKHjIty9l3aNCYWYBVkmdCh/MoVEAVltSXsvLEQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1258490c-7971-403e-daf2-08d80e597b0c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:55.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SviS3pvMvTedcxBJ/nkIssjVslls75fhNNY834ktXkK4o3a21uHj7YHdV9ZNYrOKy9ZgVxeEdLJyDymo/gW3xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@mellanox.com>

Set the ipv6 word fields according to the hardware definitions.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index afc19dca1f5f0..430025550fad2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -328,21 +328,21 @@ mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
 
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		MLX5_SET(set_action_in, modact, length, 0);
-		if (offset == offsetof(struct ipv6hdr, saddr))
+		if (offset == offsetof(struct ipv6hdr, saddr) + 12)
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0;
-		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
-			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
 		else if (offset == offsetof(struct ipv6hdr, saddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64;
-		else if (offset == offsetof(struct ipv6hdr, saddr) + 12)
+		else if (offset == offsetof(struct ipv6hdr, saddr))
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96;
-		else if (offset == offsetof(struct ipv6hdr, daddr))
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0;
-		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
-			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
 		else if (offset == offsetof(struct ipv6hdr, daddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64;
-		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
+		else if (offset == offsetof(struct ipv6hdr, daddr))
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96;
 		else
 			return -EOPNOTSUPP;
-- 
2.26.2

