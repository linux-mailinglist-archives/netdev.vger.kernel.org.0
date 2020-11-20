Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CB2BB991
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgKTXEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1185 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgKTXEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0001>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH mlx5-next 10/16] net/mlx5: Expose other function ifc bits
Date:   Fri, 20 Nov 2020 15:03:33 -0800
Message-ID: <20201120230339.651609-11-saeedm@nvidia.com>
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
        t=1605913439; bh=L5wQxV4HrSLh4QxQn9oBdIRroggeioHKAWIUpUh1xPc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Chjj3hXqEj8sFYPLjUkddjS+cPZpnujYxxPH0it3amYNj8bfeyZgVgvjj9cZHocQW
         hRb0V6luXWKuyk/ZJzyGRruK6MnZO+S/8h6ta+KczQbJO6KFZ0Wej5MY7vzM2pXDCr
         +Y20FuPGH69JG36HLxP+wj9yTNNQBQzqf7eZOBnYRRxsXq2EvVA1l0DiRyWasPWLma
         rCSG0Ds8nCkW+iHYZIi96HGRfacwhk6FSKoX5HKyckI06ujt1uWfuAZH78hflopOHE
         NJAKabaVUIZJJsQYsP0brMSzTmBeyaMb9r+twJC7so2bYP/s59TRHT/2mVbfGrzMA4
         D8kAi8g14v6hQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Expose other function ifc bits to enable setting HCA caps on behalf of
other function.

In addition, expose vhca_resource_manager bit to control whether the
other function functionality is supported by firmware.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 96888f9f822d..3e337386faa8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1249,7 +1249,8 @@ enum mlx5_fc_bulk_alloc_bitmask {
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum=
))
=20
 struct mlx5_ifc_cmd_hca_cap_bits {
-	u8         reserved_at_0[0x20];
+	u8         reserved_at_0[0x1f];
+	u8         vhca_resource_manager[0x1];
=20
 	u8         reserved_at_20[0x3];
 	u8         event_on_vhca_state_teardown_request[0x1];
@@ -4247,7 +4248,11 @@ struct mlx5_ifc_set_hca_cap_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
=20
-	u8         reserved_at_40[0x40];
+	u8         other_function[0x1];
+	u8         reserved_at_41[0xf];
+	u8         function_id[0x10];
+
+	u8         reserved_at_60[0x20];
=20
 	union mlx5_ifc_hca_cap_union_bits capability;
 };
--=20
2.26.2

