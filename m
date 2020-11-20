Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30522BB9A6
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgKTXEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:31 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12666 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgKTXEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690006>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:57 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 03/16] net/mlx5: Check dr mask size against mlx5_match_param size
Date:   Fri, 20 Nov 2020 15:03:26 -0800
Message-ID: <20201120230339.651609-4-saeedm@nvidia.com>
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
        t=1605913450; bh=yLKPGy4CVZOt8m4iHf1ZN0MUSg/Z3q23njyQrd10gYY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=FDgm3yd0xGx2I3yKKLIoCKYBqBfWyKGRfjT3DVm3okrsDhphHwlzFjsqql8YyAHiz
         k8NwBjv7Ko1xwAnNYepct40Uxy5SUmbmzJuMnI4qf7/YsLjqVBI4I7Z0u6fXmMp0f5
         3Ri8+wrqaOjICajlEfIPLswBkyfa1bg4xBppeL24OdMaBzGlTh5LunAI5kDp+hWDif
         p6j0b8GxZyLbwa2l5LZPpw0rVgQH2AvAHzcgJvQdaJiq7xUI4ljT6CduSqvwFIqku2
         k+qh30IGNhhtfMzGVq731C4TyBPLdOi/6dm/uIvmTsmiNvkyxFy2iefPxISWMFD4QX
         jdIR2UBYqlpWA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

This is to allow passing misc4 match param from userspace when
function like ib_flow_matcher_create is called.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c    | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h   | 1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 7df883686d46..1b3b2acd45c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -630,7 +630,7 @@ static int dr_matcher_init(struct mlx5dr_matcher *match=
er,
 	}
=20
 	if (mask) {
-		if (mask->match_sz > sizeof(struct mlx5dr_match_param)) {
+		if (mask->match_sz > DR_SZ_MATCH_PARAM) {
 			mlx5dr_err(dmn, "Invalid match size attribute\n");
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b3c9dc032026..6d73719db1f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -874,8 +874,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *match=
er,
 	u32 s_idx, e_idx;
=20
 	if (!value_size ||
-	    (value_size > sizeof(struct mlx5dr_match_param) ||
-	     (value_size % sizeof(u32)))) {
+	    (value_size > DR_SZ_MATCH_PARAM || (value_size % sizeof(u32)))) {
 		mlx5dr_err(matcher->tbl->dmn, "Rule parameters length is incorrect\n");
 		return false;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index f50f3b107aa3..937f469ec678 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -17,6 +17,7 @@
 #define WIRE_PORT 0xFFFF
 #define DR_STE_SVLAN 0x1
 #define DR_STE_CVLAN 0x2
+#define DR_SZ_MATCH_PARAM (MLX5_ST_SZ_DW_MATCH_PARAM * 4)
=20
 #define mlx5dr_err(dmn, arg...) mlx5_core_err((dmn)->mdev, ##arg)
 #define mlx5dr_info(dmn, arg...) mlx5_core_info((dmn)->mdev, ##arg)
--=20
2.26.2

