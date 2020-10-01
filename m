Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A927F8B6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgJAEdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgJAEdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:21 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF01622262;
        Thu,  1 Oct 2020 04:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526799;
        bh=AfCbCNMcm4Cnqwur5wZ5dTXGN+JuPjOHx71khz22Qt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRrtmSgrqjcoI42rctLbnKUxq+nf6a/boey4tcmJgw1WaWq2Iz6LY2xPLdt7SLQ6c
         0sAf//UfIdsCOLuWSnM0VK0V3hLNWf9eeF2JFzpkOsG4dHh/K/JK0ZAIirs7qnAINx
         50KkBfIulpurqxh40B63VwnzeZkrBuluq1y4KbSc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Fix a use after free on error in mlx5_tc_ct_shared_counter_get()
Date:   Wed, 30 Sep 2020 21:33:01 -0700
Message-Id: <20201001043302.48113-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This code frees "shared_counter" and then dereferences on the next line
to get the error code.

Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b5f8ed30047b..cea2070af9af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -739,6 +739,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_ct_entry *rev_entry;
 	__be16 tmp_port;
+	int ret;
 
 	/* get the reversed tuple */
 	tmp_port = rev_tuple.port.src;
@@ -778,8 +779,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	shared_counter->counter = mlx5_fc_create(dev, true);
 	if (IS_ERR(shared_counter->counter)) {
 		ct_dbg("Failed to create counter for ct entry");
+		ret = PTR_ERR(shared_counter->counter);
 		kfree(shared_counter);
-		return ERR_PTR(PTR_ERR(shared_counter->counter));
+		return ERR_PTR(ret);
 	}
 
 	refcount_set(&shared_counter->refcount, 1);
-- 
2.26.2

