Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588CA1F3044
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbgFIA5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728265AbgFHXIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF4E21475;
        Mon,  8 Jun 2020 23:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657731;
        bh=oFIdwIPcbSh6WjyfTNz2t9h1mlmA98OxWyFA46v78Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYe+7FSqRXpY6YsctQaifpSRtMogA1eMZzVPVqMl1GwL9W28tucxa26OlXgyLdM8G
         7glcAxO5Ncom+3iuS1M5R+FTVqtoia1cG/FCLh9Grw/SqcRZk5FKJzi5VnluMT58jG
         y21DT7En6uE8V6iGoyELbo1tAgnznFkbpbX+eg3c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 122/274] net/mlx4_core: Add missing iounmap() in error path
Date:   Mon,  8 Jun 2020 19:03:35 -0400
Message-Id: <20200608230607.3361041-122-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit c90af587a9eee697e2d89683113707cada70116a ]

This fixes the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx4/crdump.c:200:2-8: ERROR: missing iounmap;
ioremap on line 190 and execution via conditional on line 198

Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 73eae80e1cb7..ac5468b77488 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -197,6 +197,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		mlx4_err(dev, "crdump: devlink get snapshot id err %d\n", err);
+		iounmap(cr_space);
 		return err;
 	}
 
-- 
2.25.1

