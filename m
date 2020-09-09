Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8243E262677
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgIIEvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:18 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:57634
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbgIIEvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixzNi1KlqO494NHYi/xTSzsw+Wh85OiBWeS8g7XrtfBGpGToe4FFsVlvDqhbjTC66gLF7CClsosC0JbQ8sjg/ICQ2GM7hALb392IuV+eAHYbj7QAeCJ8vRu517knZfUhjfW+FBrWUqqRao2d8/NlhQUYzmPfbe1VPX9ioOPe6SiFI34kOFHxwwiOmfYNsSzah1QPMPAVakwktJ7tZpHMTAPftkY5RjYznsb7CAodbtcHl9QOLVWrQvrq3Zn6dLI0maCnbl8mfSzZK8Uidv2dA3K3Zqtfq+A2QPKp4PiytavTVRAUPnikRvzlCYz0s5b2RqF8Hk741zF3vt3mDaDn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSVIp5U1kSAv7+3GQEyfDd9ho/84r7x/HedE7a1jg8U=;
 b=bTMHLwmQgKA+ApJzB2IYAspgnxtDQ0LiYFOJJTmKwK2hT2ctS7YrKnVXQMhN76fhE6Nt519ZWYcJ/O8M8j+DnhYRwEnBAs4bpGj7FDLrDI91OBUaRuPH+4QJN/PlI+ETAHnYeuETSrLTwcAV7PhuA+KJ938EYa68XKa32jNzLpHAaJDa726ThzN/dMF+DKICxPDBDjurPPMghZE7pgVCk9QuSSv5fxOW5a9Hx12SrajXyWi5LxTyz9KxI05kXHPAu7Tk8jHW7GBJloaCB8+i1nalJAc2yJPdYHZB2DujzN/lCtOkv2jYIMS02cfkuX+HYBJ8FFiXIsvQfUMlTN/z6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSVIp5U1kSAv7+3GQEyfDd9ho/84r7x/HedE7a1jg8U=;
 b=raE5V3JPwAxQEl/XZ/idY5XA7evK3/Wws4Cf6A+TWh0fLXVkIMrhPvucQ6opcK7sWsAIYTKYzV+Hdi+SHiUldqkxLa57xLiYH/YhA+oEQfskyZ/FVA/nYpPaAJE7m9AAcBEUx+qJNB0/j/LL4fTx6C8Vcu3oQui1nDOeAWV199I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3650.eurprd05.prod.outlook.com (2603:10a6:208:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 04:51:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:06 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v3 1/6] net/mlx5: E-switch, Read controller number from device
Date:   Wed,  9 Sep 2020 07:50:33 +0300
Message-Id: <20200909045038.63181-2-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909045038.63181-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200909045038.63181-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc192df9-c6c6-44a6-7101-08d8547bf61c
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3650:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3650475FB0227F9C4936E996D1260@AM0PR0502MB3650.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uS3GDQldvtAqTOzf1kCcijD/4QHmJ5Pyu+4zm089CE7dLes7f4XO2C/2zk+2RZd+XuVkeD3TPmrKPQ59vOMHXR/WwtF9viLp2g0DUNfo+u4dpkDK/31FUiPN66UeOpi+So2Xse32TvFv/9aXWrbsxgkocZWi8pJEcU2IGGX4DPwopW89EW9AAVR6na/E5/hArmCvyno2QfziCbO28Ubo6L1gQxk3a6FLXuZb1Cau532jdWYo04r1uddry3YheQZI/ya34Lj/xXzw8G86aHcEO9AN0CUT5bNTICuJh+DB3sbBRA7R8ltfz1uv5QmYqazGT+jKMXlG088N8Z9W37xzbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(8936002)(6506007)(186003)(16526019)(956004)(2616005)(26005)(6512007)(316002)(4326008)(54906003)(508600001)(6486002)(8676002)(5660300002)(36756003)(2906002)(52116002)(66946007)(83380400001)(1076003)(66476007)(66556008)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k0cVFvGnGcxM0PUgoDS7nZysVv62EC+X3UzyV3RNcJQFChiM1PwdydQfKUJ6DJ93b0i06dgs3c0RLh07pegBS0ktr4+y+eoDQ5+HOVPMw5mNAPJGBtUGAfCVf69ittfqtXEjWy19f3ImG7FtgGChoEequEosNxsJC//31bn0bgbybWTKfoLcf1oFqCDQaxsrZApM1tGM4c8xPcPqEU7fPaYOZiXGcvGqGUURobtqVIk3M7Vd86yHQxXjmdjTJv8bE7II5jQzpPv737Qymb71XH3YxxEdgig2pUSsdKMK1T28Rhtdp9F+MK95daSNoSuY7vVuhL6/ie06qStzzG0UwsIjSKzRajZLOBQRBLH39XaFAz0Yk3Gm64lQWBNnlQ4nYaEbDQj0kKaA/atMczRO/+8dO7+/nVy0/fjcFncH3mgdTneB5lQI91hfKafPtFfyMpPnTlYdZd8XFwt9/1fMwZRvoTuj7uEKITx/vwMUWRurAUpex8AJ1kMk6ngX1mPhCIQA6W5HdBv3BCpNYubjZwzjvV4POO83C1j6Eknr6efPxC1AVPR+zAjK+oTyaH1my+EDfUiaD+ey/uFX/rJ/1lf0nU9oP5wSK1vGwS/4TE1h22U+Y5d55ciZ08jf83FR6/2+xniVpvGJ4vfyJ6bhKQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc192df9-c6c6-44a6-7101-08d8547bf61c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:06.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIy7kALifEJ0meSks9/3Wad8rq53sSKi10n+0zvRmvsXrvS7MAYCiqbmjBJKoFryEotpvV5oBhlB+vnZrSx3LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

ECPF supports one external host controller. Read controller number
from the device.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
Changelog:
v1->v2:
 - Removed controller number setting invocation as it
   is part of different API
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 867d8120b8a5..7455fbd21a0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -217,6 +217,7 @@ struct mlx5_esw_offload {
 	atomic64_t num_flows;
 	enum devlink_eswitch_encap_mode encap;
 	struct ida vport_metadata_ida;
+	unsigned int host_number; /* ECPF supports one external host */
 };
 
 /* E-Switch MC FDB table hash node */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d2516922d867..b381cbca5852 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2110,6 +2110,24 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type
 	return NOTIFY_OK;
 }
 
+static int mlx5_esw_host_number_init(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	/* Mark non local controller with non zero controller number. */
+	esw->offloads.host_number = MLX5_GET(query_esw_functions_out, query_host_out,
+					     host_params_context.host_number);
+	kvfree(query_host_out);
+	return 0;
+}
+
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
@@ -2124,6 +2142,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 
+	err = mlx5_esw_host_number_init(esw);
+	if (err)
+		goto err_vport_metadata;
+
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
-- 
2.26.2

