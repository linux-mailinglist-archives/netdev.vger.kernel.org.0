Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA5E172D99
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgB1ApX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:23 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730120AbgB1ApX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIabMDQnT5UE0pPxZ0GVIWsEwnPCsae5PQsU9KOOrK7QB/Vg+uf9L3T3SVljpyLYwEh48Kzg0KoyN9SxJtPskLLNsDLv2zV+6yJXc19bv3Ro5qxhs/vCAu9y1MfBzmy2+0HLT3pv7SiPU7qldwUo2YNfasj8WiRNnvxQfc8212H+Y4VAe+GPGjWoEMy0uq/zV+ygUjE7vDSrcw7IxjKPqvo1eellQHSKVQfCIKtV7wck9rjyy2saKMZMyYr0+Yyy45B7Xgwb+I2DZ04nC6juGg+Nh2RGEYoA/2265dHgA91cp/b3n/CboxczC4blL5ns50fhRmqL1lF7Ce9w4qsOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO1D+jTWeIRgEx6ROv93OBQlddbbIemJK9EWlTNFyRo=;
 b=j6lIQyISGDj9PlI2r/q5wAGABPuEWvRNK63TAiO81rXFKt3WUnyS3VJo8PE2LZMpwKOCROnCt9+Xe2wksoO0ra2M3CHonNj0fgMHoKzvYYv6jhNaHGQkEr92x4IRC1w6g0sx9ps+ll4mPN/xRvOZznBVs7FC3emu4jtdKAXBOK5SgBoeuzswaZwFNWJO/dAuklz+APkRs1Nn/PefieyBiFj8BzF2fqQ+N2ogVuS8/7lSQJCZZLpKbRY/gf7rCpywXXXmycxT2IhTdbXT+peJfCLJ4iW2jIdPJTbv7Ey+t+JhhiyDFx1yvtvlSnk0XOlhsc9h0/ET704pBX8EM1w2dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO1D+jTWeIRgEx6ROv93OBQlddbbIemJK9EWlTNFyRo=;
 b=he40kU7Isl+ZlpGt5y6ahNQ62+tz+0grmi197XZEyK6Y1hVISR1LfIQMQEM/MHLqfvz8NKlX/aIFbq97su5eSbvT3WJxaIvK2ROxmzTK2GpP8SB7q0u4o53E9OCvSUoJpQnvQlTwEq6TJ2k+O0lAApIy+HpP08qGqFxH8mHnL9g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/16] net/mlx5: Eswitch, avoid redundant mask
Date:   Thu, 27 Feb 2020 16:44:32 -0800
Message-Id: <20200228004446.159497-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:13 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52b0957d-6f70-4790-3da3-08d7bbe779ba
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41892908BE82A34F71F3EFBDBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5d7tBUkqk/1xcR1kwqFOSACoeJTYOYMp1nTsQLtk7wFjEbTIgnU9C/tPyUTjy4ypwWucwn/3q/4kDQcGPnZODSwk0EXsKZuZlOwNyya81xRJu9SbTKUDlVVXDfytr5vzj8eh0Z2OLQebKuJsMXh8JeTTeuJbG4Lctcl6aoLWvJN49JnVM88GvysecAXFEZTjeFutANO/jpfd9TDOUHwX6d3yWPyMCLEKzSXCQVLcaztV1HR94iaGF43faS3KQ6HU0ObC9aIu7rixH2ekFHasO7O1wwMXFKGo0Waq17+pElEfHSy3iI2FtbIKEOfy4EyKzsVpja2hLSwEaGeERiR7v7OG++lB8XQtbL6kQjIgEXAF9zsNSg+GwY2KslEAtPEgiNZG3wWqkESQJbVjiwdNeHym2UGqjqvPSd8ug5T2Janlqq7XgLAfaURkpaukdCc/Lba3nwkPX+j3R8/ecrfdzAsEZ6ZPEBQdcPrTFkRJ+AOjcZeb/vLUAMUS439ZkYdDaudhmQZzThOPv5CSgzvytCIF+6vAvph+8L7XgU0dBI8=
X-MS-Exchange-AntiSpam-MessageData: q9bjzzPfMbfwZyEH02JIQv9bvu0Ij4FsLpqADCdqPzf+Gpi2fEA2G7yG5kJfKzURIXG1ZLNodtBPbKTRpzh8xQVnBcwirjzxXv0zEeRpV+gnfmi91H4D9Zey2mQC+wPjOOqf6DZaf3PnD+Arj44P5A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b0957d-6f70-4790-3da3-08d7bbe779ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:15.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHkB16t0ftZ1BmROEaQ5PNNadN+OoLDun7xBEJYVZ0JGRl2BXrPHg/OSdvHdZbUimDNRb3nw9S61QKm19l3Gxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

misc_params.source_port is a 16 bit field already so no need for
redundant masking against 0xffff. Also change local variables type to
u16.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index dc08ed9339ab..f3a925e5ba88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -181,7 +181,7 @@ mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_act *src,
 static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 						const struct mlx5_flow_spec *spec)
 {
-	u32 port_mask, port_value;
+	u16 port_mask, port_value;
 
 	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
 		return spec->flow_context.flow_source ==
@@ -191,7 +191,7 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 			     misc_parameters.source_port);
 	port_value = MLX5_GET(fte_match_param, spec->match_value,
 			      misc_parameters.source_port);
-	return (port_mask & port_value & 0xffff) == MLX5_VPORT_UPLINK;
+	return (port_mask & port_value) == MLX5_VPORT_UPLINK;
 }
 
 bool
-- 
2.24.1

