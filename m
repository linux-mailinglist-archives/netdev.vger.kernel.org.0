Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1AE275168
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgIWGZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgIWGYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:46 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063342376E;
        Wed, 23 Sep 2020 06:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842286;
        bh=5tw0nXmsDP0NkQXvrbQ0j9R/hmeShcu2Ue7agG3AUWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/srya11o0crvoK735UAM1ifLjHOn0VnkcShfVt6lrOrztqhjxMJNhIRRV2i6DJoh
         eUUyPkO/4RyS0hQyI3K40QvxeDLjkh68X/BQKQrWz9lHw4ERgvwLoLES3pSRANYJbD
         WzMz2DimfwubyPt5IzEWAzTouwlma5qo6TiP6mFU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Use kfree() to free fd->g in accel_fs_tcp_create_groups()
Date:   Tue, 22 Sep 2020 23:24:36 -0700
Message-Id: <20200923062438.15997-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Memory ft->g in accel_fs_tcp_create_groups() is allocaed with kcalloc().
It's excessive to free ft->g with kvfree(). Use kfree() instead.

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 4cdd9eac647d..97f1594cee11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -191,7 +191,7 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 	ft->g = kcalloc(MLX5E_ACCEL_FS_TCP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

