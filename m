Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346993726B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfFFLGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfFFLGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:06:21 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6662420883;
        Thu,  6 Jun 2019 11:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559819181;
        bh=CvqbHKleLHjrzzlgjNnvg0hqRbQZoOuKz8ED6/lrYPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Vha5tg4naOHvUbcpsd0bDdGR9W6MWD9g2BQ9GLfxFQ058P3vZWlmcozco82VFKpk
         j7LCoGtI53I9aUe9gLw9I1rx/3caybcg2oAdR95OYrAy82cb8aR+pQt/GziaL6TVDy
         ekPirZj5njlaTvv5hBr5EecqCZit9szZoIIDGYgg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Enable decap and packet reformat on FDB
Date:   Thu,  6 Jun 2019 14:06:09 +0300
Message-Id: <20190606110609.11588-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606110609.11588-1-leon@kernel.org>
References: <20190606110609.11588-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

If FDB flow tables support decap operation, enable it on creation,
This allows to perform decapsulation of tunnelled packets by steering
rules. If FDB flow tables support reformat operation, enable it on
creation as well.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 70d565283508..cd0c005d1120 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3917,6 +3917,11 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		max_table_size = BIT(
 			MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, log_max_ft_size));
+		if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, decap) && esw_encap)
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
+		if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, reformat_l3_tunnel_to_l2) &&
+		    esw_encap)
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		priority = FDB_BYPASS_PATH;
 	}
 
-- 
2.20.1

