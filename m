Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFCE6E4783
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjDQMVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjDQMVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D34977E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/BWFUSEE48JcWuTrmASzH1PNkmHIYXJ9oSQxsg9dasuTEFktOA74BQEWRwmSUn0kxF4biwLQaNMSvRdE2rId1IjiTiERp744imKU1CD7u3USpAfMR9t7KMf1KYCMAdEqg5+kipB8kOtopI2pbqQfsL+iFmqCzSHC40Xnzb2AL9SSLiMUc82xJLmgPX26bqrCyQRSavTt5UGbOE9f44TajIBrG308eXxbZrWyn0zLwTw5J0fjjIu5Q7pjUbnivF2iK4vHzz9bq0C/0IITSPBELZDlSkBeSM6RcpKQcfy0/lVlPa6V9E9JuE6iKEC5vG2OCeDk5rv/IQyshrMz73tag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0hwg1lxZDIPaM7shl4zn1cy5P0ReW29IVBmA00E5C8=;
 b=fm/7Eyt1G/lhANuHCiBTOrKkWe6QXVgXtvFd085hBbCcKbnSevOZdcXnMkI7sDMVFI1qePCaL/l5QhvtN5H+LAIPbH+YEYbSgQ1nZhWt+bGO0S6FSzGDVniM9hBO3Isr+0CS8QxP8ljLY4FwenR9oKuKg5rUkqTavqVrw4gtdEVyblic0k0QpQ8q6orrtm0DqJdGkUocKvUGmgdwH6ELom28s7XV9fgCEVFoFIZo/7IZUL4IfFVIHmNomodfyruYjMphyL1/fZs8pZM0LYqg5mOWbSagXIcg/4FGSKYVtbRBbgHvH6XUNzGFSyIgoOOIDvWevSDeujwbLERvwq/N9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0hwg1lxZDIPaM7shl4zn1cy5P0ReW29IVBmA00E5C8=;
 b=Kwac0wBMBoXIEH1fNiuai4JzMxPpZtesaXQDRnkX4e4gbCMOoHEkv2VsKxx2y6cmTHAPs3BMXV2fNIr+RCW7qaMPbsd/6t1IrZDcbBO5LtKAJnsapoTq2fx9Fh9TWj5XA3/w0m37BHpkO5V49SV74ce05oM1bnjhfS0rRJsba5GdcL7Fx/MQZkZFp+KwUjcM2Zaz7iMlhd2uTPp+YciFWvV4n46hzILc/bmRZCpuWf1yXD/shhXCUJNQkhYR/wESVvBdcaJAmA0RHiS5AkE67UCUBsSQbAcECwJ8sanBvzrAGcdkrNG7DR5nvwE/tBn7GORfx21ISHTqRkajVn7AKw==
Received: from DS7PR03CA0111.namprd03.prod.outlook.com (2603:10b6:5:3b7::26)
 by MW6PR12MB8834.namprd12.prod.outlook.com (2603:10b6:303:23c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:39 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::76) by DS7PR03CA0111.outlook.office365.com
 (2603:10b6:5:3b7::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Mon, 17 Apr 2023 12:20:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:27 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:24 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 11/15] net/mlx5e: XDP, Allow non-linear single-segment frames in XDP TX MPWQE
Date:   Mon, 17 Apr 2023 15:18:59 +0300
Message-ID: <20230417121903.46218-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|MW6PR12MB8834:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db88547-5ef4-4525-f9b8-08db3f3e27f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QY2KfRIqMUW9s/tZx0aLCBdhBIsp4Bh7eNEyMok/w/n6KnlzDwbf0NIwimCIRT1WKH6bBQYRmtccdGm76MEfLneNYGoESox4bra0AV/UrLGvs1VBTr76UzCyo4/ts+qd+ujSuQYtZ4TBU9LesbCCRwRGR7vRBFdpWzBgLXdCzyn7Z8JLqbOYVRVjfR4bj+R+Z+DTweqMG8KpZ1CpKEy3eaiinLard1NceL+ptzlyudBFFzLH28KMl1skcUeyGChykOzwaH/o4jR1wNykjBCSOIhKZkugGuSPFOMX7KIDzk4s6cVP9O16D9di+D+CMoVL6zshxZE7ctpsLMYycE8MNhvJkTTgg6s/m9VfOB49t7KxKAO3ZTZKO/mXM1QUJSmcpFtyNCfwD9AWQcxUpVkOSiC65jo1oiZBzLsyQQdj4xdSxglAzIirEhhkNYB8O2QNJuGBLxSm0T4+b6AS2BQOwxC6slNRHX+Srm1oDoEVEpDxafoImlg7OF4pYhRO4JWjyTaDnRJvJkHo70Nhm+VCI+2feZZZNXFsgIjKJMVzIkH3zCJq8LLbkm2xUXMmgPXqBzp4JEdu9Wv3Q0n9X2DLCsKsO5avyTdRwG/QqMQsAk/X0TqcQu660DAZKy2QEu9Vm3CiklRvxqMMxHBgzKzDpLQGwhtWmx3b+zj2Nf+E97XUbpxONm2bwJJj6RvZ3qXrhjP20Kof6MPbDOmEvF1aqxPwj6eX0ur4NG9zrcGMPhNsP3KNoXAeGlcHYfZTAW7zI6RkOLCnOvf/qm+ONgagpg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(110136005)(70586007)(82740400003)(70206006)(4326008)(478600001)(316002)(54906003)(5660300002)(8676002)(8936002)(41300700001)(7416002)(356005)(7636003)(186003)(83380400001)(2616005)(426003)(336012)(47076005)(36860700001)(6666004)(34020700004)(7696005)(107886003)(26005)(1076003)(86362001)(82310400005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:39.2277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db88547-5ef4-4525-f9b8-08db3f3e27f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8834
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under a few restrictions, TX MPWQE feature can serve multiple TX packets
in a single TX descriptor. It requires each of the packets to have a
single scatter entry / segment.

Today we allow only linear frames to use this feature, although there's
no real problem with non-linear ones where the whole packet reside in
the first fragment.

Expand the XDP TX MPWQE feature support to include such frames. This is
in preparation for the downstream patch, in which we will generate such
non-linear frames.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index d89f934570ee..f0e6095809fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -405,18 +405,35 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
+	struct mlx5e_xmit_data *p = xdptxd;
+	struct mlx5e_xmit_data tmp;
 
 	if (xdptxd->has_frags) {
-		/* MPWQE is enabled, but a multi-buffer packet is queued for
-		 * transmission. MPWQE can't send fragmented packets, so close
-		 * the current session and fall back to a regular WQE.
-		 */
-		if (unlikely(sq->mpwqe.wqe))
-			mlx5e_xdp_mpwqe_complete(sq);
-		return mlx5e_xmit_xdp_frame(sq, xdptxd, 0);
+		struct mlx5e_xmit_data_frags *xdptxdf =
+			container_of(xdptxd, struct mlx5e_xmit_data_frags, xd);
+
+		if (!!xdptxd->len + xdptxdf->sinfo->nr_frags > 1) {
+			/* MPWQE is enabled, but a multi-buffer packet is queued for
+			 * transmission. MPWQE can't send fragmented packets, so close
+			 * the current session and fall back to a regular WQE.
+			 */
+			if (unlikely(sq->mpwqe.wqe))
+				mlx5e_xdp_mpwqe_complete(sq);
+			return mlx5e_xmit_xdp_frame(sq, xdptxd, 0);
+		}
+		if (!xdptxd->len) {
+			skb_frag_t *frag = &xdptxdf->sinfo->frags[0];
+
+			tmp.data = skb_frag_address(frag);
+			tmp.len = skb_frag_size(frag);
+			tmp.dma_addr = xdptxdf->dma_arr ? xdptxdf->dma_arr[0] :
+				page_pool_get_dma_addr(skb_frag_page(frag)) +
+				skb_frag_off(frag);
+			p = &tmp;
+		}
 	}
 
-	if (unlikely(xdptxd->len > sq->hw_mtu)) {
+	if (unlikely(p->len > sq->hw_mtu)) {
 		stats->err++;
 		return false;
 	}
@@ -434,7 +451,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 		mlx5e_xdp_mpwqe_session_start(sq);
 	}
 
-	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
+	mlx5e_xdp_mpwqe_add_dseg(sq, p, stats);
 
 	if (unlikely(mlx5e_xdp_mpwqe_is_full(session, sq->max_sq_mpw_wqebbs)))
 		mlx5e_xdp_mpwqe_complete(sq);
-- 
2.34.1

