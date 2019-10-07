Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E052CE106
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfJGL6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGL6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:58:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F89206C0;
        Mon,  7 Oct 2019 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570449510;
        bh=174nUUEc39BnPNjnjG3coCMSkyWpv0morokgjS6xmCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQyjhP5sTjEa8oBLYvTVoVwye+tzXNIKFfNZLpE/mILCo+Gd8D5B8Eubp3qW8PypO
         ImS1DDgMVwjOnA1UStsoYPY5f94ejrLSxirBHajVT8Fy0ZrzUGo6aIPyX6hyf/rnMl
         riUU2IhyJaSafhu+itpY3Qqfp+oJZi3J15AAssfU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v1 3/3] RDMA/mlx5: Add capability for max sge to get optimized performance
Date:   Mon,  7 Oct 2019 14:58:19 +0300
Message-Id: <20191007115819.9211-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007115819.9211-1-leon@kernel.org>
References: <20191007115819.9211-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

Allows the IB device to provide a value of maximum scatter gather entries
per RDMA READ.

In certain cases it may be preferable for a device to perform UMR memory
registration rather than have many scatter entries in a single RDMA READ.
This provides a significant performance increase in devices capable of
using different memory registration schemes based on the number of scatter
gather entries. This general capability allows each device vendor to fine
tune when it is better to use memory registration.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fa23c8e7043b..39d54e285ae9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1012,6 +1012,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
 	props->max_pi_fast_reg_page_list_len =
 		props->max_fast_reg_page_list_len / 2;
+	props->max_sgl_rd =
+		MLX5_CAP_GEN(mdev, max_sgl_for_optimized_performance);
 	get_atomic_caps_qp(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
--
2.20.1

