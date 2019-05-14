Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD21C7EF
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 13:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfENLoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 07:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENLoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 07:44:24 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7501F20818;
        Tue, 14 May 2019 11:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557834264;
        bh=35oBFZSldviLua8EdqgxA23baQw8l7OwiHxmZXoknIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdW0+AAl59KPNml4mJugdCsh/DMmAmol8rVEnnOEuXc3mAU3cdeYfUY5dUCoJm43G
         Pd5iK2quoWRlHaFV6MATJZWRJLs25Bu/Ox7sVEvN3g1Fn3+VoM2zLalUlL8DRiV+kR
         tNjxYv4iolvxaQan8X2uJ3BSBk87KmcBjgWP++KA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 2/2] net/mlx5: Set completion EQs as shared resources
Date:   Tue, 14 May 2019 14:44:12 +0300
Message-Id: <20190514114412.30604-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190514114412.30604-1-leon@kernel.org>
References: <20190514114412.30604-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Mark completion EQs as shared resources so that they can be used by CQs
with uid != 0.

Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 +++
 include/linux/mlx5/mlx5_ifc.h                | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 5aac97847721..23883d1fa22f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -291,6 +291,9 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, const char *name,
 	mlx5_fill_page_array(&eq->buf, pas);
 
 	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
+	if (!param->mask && MLX5_CAP_GEN(dev, log_max_uctx))
+		MLX5_SET(create_eq_in, in, uid, MLX5_SHARED_RESOURCE_UID);
+
 	MLX5_SET64(create_eq_in, in, event_bitmask, param->mask);
 
 	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9be13e2c5a20..9c9979cf0fd5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7346,7 +7346,7 @@ struct mlx5_ifc_create_eq_out_bits {
 
 struct mlx5_ifc_create_eq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.20.1

