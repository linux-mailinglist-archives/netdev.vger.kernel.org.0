Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E4C17EE1C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgCJBn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:29 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:6098
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbgCJBn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAaLE0duYqmfvjCFg3icv1//QxqNaMK8n2rndLZj1bDFHI8pi+/5xvaTHm0IRHPPwPG+UYp451Lr8Cv4eB2PME4gpZfkoe4BC3oX1i2zrT5W/x2u2jvA63OvwQtOgv/trOth2/YSPcxryFxIoDus3t5zYrrYJD1mewUa9OOEbzKy/ijP5EE5PR81P+LbjTH4XB+GNtTLngvIjLYCIZb7sXK19g9L0y59iFz1rt2Q2Iks2daXDWN74d2V2b7/CfgmVafssgVlNjZ0k886k/fsVWRNxNU9YYTvs3kvQV8TkYzkmfiUzpA8ezhBNr8I91sEmKyeTrFHceYqAiBIOk2F6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cgh2qi/zipeIxhsBdFWKfYjJEOqsWUcm7qKLY/D/0Kk=;
 b=g47MGAGubZAYV59TiXaKo9HJTSreogaRbDQdrvThA8mjwRtWf6IKQfWq489XUpVgMfR9OSOPGYn+N6zSSXF2t9HSeAkpHBL9TaE+GdfWiBLspdenWdGg26EHcoI+AVrJzk+dnMlW3mKDgPBvSCiwTsjHLqQq4IDpRkVxcm6f+R9pMJuwvtTeEK6FhBO41SRau3w964p0TguYttzsWuGJIt4uD7IrshAjMn353FVjqiGdZoMBuuGBgERs7uQJcHzJKGrVHkwJcD4ngJ+9uP0W4+QLhikUBplLzjE51Xre/P4M2qIy/6MNbBF7g0+tSqB56gAz0Bmxa5Ou8znBYMCIOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cgh2qi/zipeIxhsBdFWKfYjJEOqsWUcm7qKLY/D/0Kk=;
 b=AJTU2FnG5Ho5JLxfVS0sEqsZhizu6/5LtrosJoHKaUUvpwVr7NfXQyzgntRrHRE4Rmiyko6FHQ2u8Hv73NJDMoRhMXRpnuKE6x9U9S25pKyvXqVsVavQUIFWUaeTqoUN1nM8L4iqLMEUYHuBae30HVdieqLB5ACIGUbxdkBbnnc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/11] net/mlx5: Allocate smaller size tables for ft offload
Date:   Mon,  9 Mar 2020 18:42:41 -0700
Message-Id: <20200310014246.30830-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:14 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 514de392-9d18-486b-5ef7-08d7c4946701
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55338F11BA2C54EFAF898DCEBEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZCIjbs1qnKK2chBJxb7/mOZV7PxVAPMIizV/QjT84ghCTupyQMVXgENFd8KnguPXUk5NBt4zcM+5K68v5kvC7liJxTIax0hZmE2T8j8oylxupowJgG50W5l1rGzLe9JyElISP9Y/BkQQMwbX94s674bZfWOny77XLMJEtAgrf/S02Nwx69+GX0RQTc1vw6zkkSPe90/UI3weec9aze21jcAmYjXqUZgimQm0TiEz17zNemsqwN7yTe84/J6MG9LQ25AnboDZt9rC01tvikXP7J8J2vZpDj21ArxGcDFovjyhHLuZuSjiGdNO91l7Uxg2AKPuwvFHMCRcdlDFBygYZqgYhu9YxTU46wcgEsCmkrg/rH41RaNSICuYn5V0aDiR1/BscJdFe7MyXXNuE+Haxna4ANjpSotecvCUr6d1p9qdkLGRnuwUhRq9J3RdyT0nZ92p4Jzdodo5Gm4Mri4AqShVb8pAWFrM/ON2jvztwz9LwqVO8G0wDFP59AXFu3PSah4y6n4yv0n1lTgU8iVSRe6LfEgWCaGs1Y4YIygkn4=
X-MS-Exchange-AntiSpam-MessageData: AKlgsWlU7n3kXLkV7phRhZSGLBWT0T3Siqw4zeVjbZLz9SV+E9VIQcvNf6kOvbJPjP9fliHfOuMPkxPSdzfI8Hfo31/aMZM5KGjnMaN7mBpsqEpu31jE8DBktUvRz8Kbal2S1RlP6UDlW7lb0yrJrA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514de392-9d18-486b-5ef7-08d7c4946701
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:16.0200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g629bTAXoQyvG3IogVZ2lVKR//1mXOxnBllXn3yTAZceUKTCB7Zol0NaSip0u8Nely1tvFNYLOmxP+W6W5HncA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Instead of giving ft tables one of the largest tables available - 4M,
give it a more reasonable size - 64k. Especially since it will
always be created as a miss hook in the following patch.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c    | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index d41e4f002b84..8bfa53ea5dd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -34,6 +34,7 @@ static const unsigned int ESW_POOLS[] = { 4 * 1024 * 1024,
 					  1 * 1024 * 1024,
 					  64 * 1024,
 					  128 };
+#define ESW_FT_TBL_SZ (64 * 1024)
 
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
@@ -201,7 +202,9 @@ mlx5_esw_chains_create_fdb_table(struct mlx5_eswitch *esw,
 		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	sz = mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
+	sz = (chain == mlx5_esw_chains_get_ft_chain(esw)) ?
+	     mlx5_esw_chains_get_avail_sz_from_pool(esw, ESW_FT_TBL_SZ) :
+	     mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
 	if (!sz)
 		return ERR_PTR(-ENOSPC);
 	ft_attr.max_fte = sz;
-- 
2.24.1

