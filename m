Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5888A17A55F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCEMip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgCEMip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 07:38:45 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A45C520848;
        Thu,  5 Mar 2020 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583411925;
        bh=1LGhhgAlwDCpE68Td/PxvgyI3TodD1hw/F0l2H3jg+A=;
        h=From:To:Cc:Subject:Date:From;
        b=USpPPOZ/N5yQ//arl6flShAOl459xqXVb02U3ZTuQkixDJys6BHmH/euAtwBa7iI2
         tFU1LAtCEqnTNgppx+SEuG0hww1VRNY4+45ouKXvqdvYynb5sZ+VKYBbpWcsFJ+6j+
         am+jhr4bEGV1LDVuT7WQk+w7RIiQNV+OGclHBH64=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        linux-rdma@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-rc] IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads
Date:   Thu,  5 Mar 2020 14:38:41 +0200
Message-Id: <20200305123841.196086-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Until now flex parser was used in ib_query_device to indicate
tunnel_offloads_caps support for mpls_over_gre/mpls_over_udp.
These inaccurate capability bits will not work on newer devices.

This should not brake backward compatibility since tunnel_stateless
caps and flex_parser_protocols caps were added together.

Cc: <stable@vger.kernel.org> # 4.17
Fixes: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++----
 include/linux/mlx5/mlx5_ifc.h     | 6 +++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e4bcfa81b70a..4d0780d9114c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1192,12 +1192,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_GRE)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_UDP)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_udp))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ff8c9d527bb4..ac72c944c26d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -872,7 +872,11 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
 	u8         cqe_checksum_full[0x1];
-	u8         reserved_at_24[0x5];
+	u8         tunnel_stateless_geneve_tx[0x1];
+	u8         tunnel_stateless_mpls_over_udp[0x1];
+	u8         tunnel_stateless_mpls_over_gre[0x1];
+	u8         tunnel_stateless_vxlan_gpe[0x1];
+	u8         tunnel_stateless_ipv4_over_vxlan[0x1];
 	u8         tunnel_stateless_ip_over_ip[0x1];
 	u8         reserved_at_2a[0x6];
 	u8         max_vxlan_udp_ports[0x8];
-- 
2.24.1

