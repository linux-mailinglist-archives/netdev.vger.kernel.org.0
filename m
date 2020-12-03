Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3842CCE07
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgLCElP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:41:15 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18720 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgLCElP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:41:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc86c420000>; Wed, 02 Dec 2020 20:40:34 -0800
Received: from sx1.vdiclient.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:40:34 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/4] net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering
Date:   Wed, 2 Dec 2020 20:39:46 -0800
Message-ID: <20201203043946.235385-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203043946.235385-1-saeedm@nvidia.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606970434; bh=PAvGolED6alVuyhCdaElAfzXQxtsCRZQk5SaikbaWhE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kdGQSKiMAGVi8KxLAcDoXRBEzZWMQOnbGuJJ5uM9yo6jJyQU0NKijgRTdq3+AZcJL
         76Br3Neu8DAw7mjP7aF5gaBFMYxFqqG2MkCHp7O0nipDE5pVhJNfgGNjGOQBR7TG3g
         VUtsK25DN7s6q9C+P5pg2FJ43JMcpxJLAwUZviGchlWqtB9/9WFfaQxM9+TEnJByXb
         Wwy5kZeKw3iM2Fo74LlqGNyYAJuOJ7tQjyrFHl9Gij+11Ngfj1h6Gjx247MHkUJcLn
         Gcj2IG8g265CBqnd/8NamxYBXhBxV6zEbcV61zXPFTwiJIMl/4MsOa+u79nbeDR/jr
         mR3lkwr+nj0xA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

STEs format for Connect-X5 and Connect-X6DX different. Currently, on
Connext-X6DX the SW steering would break at some point when building STEs
w/o giving a proper error message. Fix this by checking the STE format of
the current device when initializing domain: add mlx5_ifc definitions for
Connect-X6DX SW steering, read FW capability to get the current format
version, and check this version when domain is being created.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c    | 1 +
 .../net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 5 +++++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h  | 1 +
 include/linux/mlx5/mlx5_ifc.h                            | 9 ++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 6bd34b293007..51bbd88ff021 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -92,6 +92,7 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->eswitch_manager	=3D MLX5_CAP_GEN(mdev, eswitch_manager);
 	caps->gvmi		=3D MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	=3D MLX5_CAP_GEN(mdev, flex_parser_protocols);
+	caps->sw_format_ver	=3D MLX5_CAP_GEN(mdev, steering_format_version);
=20
 	if (mlx5dr_matcher_supp_flex_parser_icmp_v4(caps)) {
 		caps->flex_parser_id_icmp_dw0 =3D MLX5_CAP_GEN(mdev, flex_parser_id_icmp=
_dw0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 890767a2a7cb..aa2c2d6c44e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -223,6 +223,11 @@ static int dr_domain_caps_init(struct mlx5_core_dev *m=
dev,
 	if (ret)
 		return ret;
=20
+	if (dmn->info.caps.sw_format_ver !=3D MLX5_STEERING_FORMAT_CONNECTX_5) {
+		mlx5dr_err(dmn, "SW steering is not supported on this device\n");
+		return -EOPNOTSUPP;
+	}
+
 	ret =3D dr_domain_query_fdb_caps(mdev, dmn);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index f50f3b107aa3..cf62ea4f882e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -625,6 +625,7 @@ struct mlx5dr_cmd_caps {
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 num_esw_ports;
+	u8 sw_format_ver;
 	bool eswitch_manager;
 	bool rx_sw_owner;
 	bool tx_sw_owner;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a092346c7b2d..233352447b1a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1223,6 +1223,11 @@ enum mlx5_fc_bulk_alloc_bitmask {
=20
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum=
))
=20
+enum {
+	MLX5_STEERING_FORMAT_CONNECTX_5   =3D 0,
+	MLX5_STEERING_FORMAT_CONNECTX_6DX =3D 1,
+};
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x30];
 	u8         vhca_id[0x10];
@@ -1521,7 +1526,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
=20
 	u8         general_obj_types[0x40];
=20
-	u8         reserved_at_440[0x20];
+	u8         reserved_at_440[0x4];
+	u8         steering_format_version[0x4];
+	u8         create_qp_start_hint[0x18];
=20
 	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
--=20
2.26.2

