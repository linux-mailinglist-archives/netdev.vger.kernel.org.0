Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A402EB5C9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbhAEXFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhAEXFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC37722EBF;
        Tue,  5 Jan 2021 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887905;
        bh=oruuDsFJFuqcWLNk1FF8NvgWnnpANrHVBFzAkuDyzu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENttg+7n1wrtxe7ZVeZM3M87ZRIJyO9vaSeBfKfx1MOdId7sqhKmeWmajRVbY4mGV
         c+s/B2NVf5RfdIHOVOaPNh9iJLYVJf0ndM4EgCbO6if7ohTU6/EFSP6vIQlfdpyTJS
         ZrFD6VZ4ysO+yFIOJvDwJw+3P9nGjOyqIGIDn7n1RsiROd6Ropf29rIjYE17kp3kb/
         2BEsk1cemnQ6Sm7A8ADImi+G9d3vYlPpaURpSDHel3aQVnVOr+vLK9onb0dcNi9p6Y
         9IfbPO9VtplwMFueeu1bMizAw07KJPeZIUx/2ApHF9W9e3mEIReQuELmMHeJsR/FQE
         +VhbDAvg5IRlg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: DR, Add infrastructure for supporting several steering formats
Date:   Tue,  5 Jan 2021 15:03:18 -0800
Message-Id: <20210105230333.239456-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add a struct of device specific callbacks for STE layer below dr_ste.
Each device will implement its HW-specific function, and a comon logic
from the DR code will access these functions through the new ste_ctx API.

More callbacks will follow in the subsequent patches.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      |  2 +-
 .../mellanox/mlx5/core/steering/dr_ste.h      | 36 +++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index d275823bff2f..171f7836fb23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/crc32.h>
-#include "dr_types.h"
+#include "dr_ste.h"
 
 #define DR_STE_CRC_POLY 0xEDB88320L
 #define STE_IPV4 0x1
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
new file mode 100644
index 000000000000..59850925ebd2
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef	_DR_STE_
+#define	_DR_STE_
+
+#include "dr_types.h"
+
+#define DR_STE_CTX_BUILDER(fname) \
+	((*build_##fname##_init)(struct mlx5dr_ste_build *sb, \
+				 struct mlx5dr_match_param *mask))
+
+struct mlx5dr_ste_ctx {
+	void DR_STE_CTX_BUILDER(eth_l2_src_dst);
+	void DR_STE_CTX_BUILDER(eth_l3_ipv6_src);
+	void DR_STE_CTX_BUILDER(eth_l3_ipv6_dst);
+	void DR_STE_CTX_BUILDER(eth_l3_ipv4_5_tuple);
+	void DR_STE_CTX_BUILDER(eth_l2_src);
+	void DR_STE_CTX_BUILDER(eth_l2_dst);
+	void DR_STE_CTX_BUILDER(eth_l2_tnl);
+	void DR_STE_CTX_BUILDER(eth_l3_ipv4_misc);
+	void DR_STE_CTX_BUILDER(eth_ipv6_l3_l4);
+	void DR_STE_CTX_BUILDER(mpls);
+	void DR_STE_CTX_BUILDER(tnl_gre);
+	void DR_STE_CTX_BUILDER(tnl_mpls);
+	int  DR_STE_CTX_BUILDER(icmp);
+	void DR_STE_CTX_BUILDER(general_purpose);
+	void DR_STE_CTX_BUILDER(eth_l4_misc);
+	void DR_STE_CTX_BUILDER(tnl_vxlan_gpe);
+	void DR_STE_CTX_BUILDER(tnl_geneve);
+	void DR_STE_CTX_BUILDER(register_0);
+	void DR_STE_CTX_BUILDER(register_1);
+	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
+};
+
+#endif  /* _DR_STE_ */
-- 
2.26.2

