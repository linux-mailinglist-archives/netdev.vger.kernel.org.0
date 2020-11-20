Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A32BB98A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgKTXEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12658 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgKTXEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690001>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:56 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Chris Mi <cmi@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH mlx5-next 02/16] net/mlx5: Add sampler destination type
Date:   Fri, 20 Nov 2020 15:03:25 -0800
Message-ID: <20201120230339.651609-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913449; bh=wX4wDsmenS/hXn2rtqxUHixdfOqvKuM1oPPd5O8RNtY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bocDmEnwFS+zGDQtmwBZSPHJGBoxwtRNVxbcZ1ZuFRfKx8M/b2UM5LdEYIUXctKFV
         UwUuQcXX3Z1EPHHDbB+H0uvB2RFeVg6ouPxkUKTvb4ArlYalWODR0lpD7vAmgvkAWH
         LdKOxZyjDMq3K2Bf2GJ2SO7+8zNcF+jxWlJMR9yl/g0Yqf9lLdLjui+5m3GPyJH+qC
         /I51zHIQsjtyrKgf504V8wes8XvU2se1qCvBQ5Fj+vNkrcL2gZJy8Jypp9HumKtRHL
         WO/rFGMe6Fg6Sv2ZMQQ+lmgXh8UQ5CJqVVab3fX2ibXyWExNLC1Z+2hgl+BEztVKmM
         WnRrdt0NWsplA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

The flow sampler object is a new destination type. Add a new member
for the flow destination.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c             | 3 +++
 include/linux/mlx5/fs.h                                      | 1 +
 include/linux/mlx5/mlx5_ifc.h                                | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b=
/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index a700f3c86899..87d65f6b5310 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -247,6 +247,9 @@ const char *parse_fs_dst(struct trace_seq *p,
 	case MLX5_FLOW_DESTINATION_TYPE_TIR:
 		trace_seq_printf(p, "tir=3D%u\n", dst->tir_num);
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
+		trace_seq_printf(p, "sampler_id=3D%u\n", dst->sampler_id);
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_COUNTER:
 		trace_seq_printf(p, "counter_id=3D%u\n", counter_id);
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index babe3405132a..c2fed9c3d75c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -515,6 +515,9 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 						 dst->dest_attr.vport.pkt_reformat->id);
 				}
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
+				id =3D dst->dest_attr.sampler_id;
+				break;
 			default:
 				id =3D dst->dest_attr.tir_num;
 			}
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 846d94ad04bc..35d2cc1646d3 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -132,6 +132,7 @@ struct mlx5_flow_destination {
 			struct mlx5_pkt_reformat *pkt_reformat;
 			u8		flags;
 		} vport;
+		u32			sampler_id;
 	};
 };
=20
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 65ea35af0527..2f2add4bd5e1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1616,6 +1616,7 @@ enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_VPORT        =3D 0x0,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE   =3D 0x1,
 	MLX5_FLOW_DESTINATION_TYPE_TIR          =3D 0x2,
+	MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER =3D 0x6,
=20
 	MLX5_FLOW_DESTINATION_TYPE_PORT         =3D 0x99,
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER      =3D 0x100,
--=20
2.26.2

