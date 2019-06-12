Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077D14256D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438796AbfFLMUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438820AbfFLMUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:20:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04A721721;
        Wed, 12 Jun 2019 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560342030;
        bh=zt65VgfxKQvQ+uAkmElwoWTzQZJV+r2K3y2D73RGgiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWl3Vwh0KgQ0tO2G2cOmSDt9zVlnntFrTrJSE6QzrbjR3mSepZG/jKrZOrSUXTwNM
         IHS4ssnbCLM0DU2NAxO2fxyhsTBF3oH+3BxY33/fAfwy4yGHwUHcTwT3NyYRj7FOJV
         9I0K1iRVOklHki2As0hOjL2pDvf1e7ce8yk3SKZc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH rdma-next v1 4/4] RDMA/mlx5: Enable decap and packet reformat on FDB
Date:   Wed, 12 Jun 2019 15:20:14 +0300
Message-Id: <20190612122014.22359-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612122014.22359-1-leon@kernel.org>
References: <20190612122014.22359-1-leon@kernel.org>
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
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a6e2e0210ebb..33709fd93ab2 100644
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

