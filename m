Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0109A2BB98C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgKTXEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12663 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbgKTXEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690003>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 05/16] net/mlx5: Add ts_cqe_to_dest_cqn related bits
Date:   Fri, 20 Nov 2020 15:03:28 -0800
Message-ID: <20201120230339.651609-6-saeedm@nvidia.com>
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
        t=1605913449; bh=CCGWpDtXxqoygsnIR7vhCC37Ppe39mjFJh+AdZfJYWg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=FujR3Ca0Zdoq1ysZQq5LLB/MGi5Q3vnGcD3M/GK7CKMjACm2bw65Z+PDRQy9TtpXd
         ep457Xph9mx5Fndr3aGfASUc5ByY4hxrwVr0EZjxp21/5UgAWzBNOCo+1qfEM9Pk3M
         I1t0ie5mHJf0X4E9IHZEvx3a0QXVwlYyQed3Y9wrrk2Ie0baA+qTWVmm9v7azfB3JU
         VXNuw5DVvKZSumY0wlsY0izbu5miBd6Qr85ZzjXdjVHHuuT+gQBn5QsdxM5KcJAAG7
         sr1mhvo5l/RodJnWcoGIQCGqmITMZ94nnabogfypGgxM81Yah5rIn2QI4d+E+KvSKk
         lAiuY/uvUmhKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

Add a bit in HCA capabilities layout to indicate if ts_cqe_to_dest_cqn is
supported.

In addition, add ts_cqe_to_dest_cqn field to SQ context, for driver to
set the actual CQN.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 11c24fafd7f2..632b9a61fda5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1261,7 +1261,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   ece_support[0x1];
 	u8	   reserved_at_a4[0x7];
 	u8         log_max_srq[0x5];
-	u8         reserved_at_b0[0x10];
+	u8         reserved_at_b0[0x2];
+	u8         ts_cqe_to_dest_cqn[0x1];
+	u8         reserved_at_b3[0xd];
=20
 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
@@ -3312,8 +3314,12 @@ struct mlx5_ifc_sqc_bits {
 	u8         reserved_at_80[0x10];
 	u8         hairpin_peer_vhca[0x10];
=20
-	u8         reserved_at_a0[0x50];
+	u8         reserved_at_a0[0x20];
=20
+	u8         reserved_at_c0[0x8];
+	u8         ts_cqe_to_dest_cqn[0x18];
+
+	u8         reserved_at_e0[0x10];
 	u8         packet_pacing_rate_limit_index[0x10];
 	u8         tis_lst_sz[0x10];
 	u8         reserved_at_110[0x10];
--=20
2.26.2

