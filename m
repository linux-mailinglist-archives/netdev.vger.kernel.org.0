Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2278A28081B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbgJATxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJATxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:11 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE62208A9;
        Thu,  1 Oct 2020 19:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581991;
        bh=47AqJ9bOirvvIl5MOY371gcFLcge/PiH7u9Slh5Fx/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERx3APJdZbMOQ6R/K8kut+Uo7MK3P+7TzKQf/zBoD4ilPghfkhq6hZFXTRsq+7A8b
         7NSg56trqRbKRNT1uzWXDAvBo7ZUqt+WM2N5mLswyR4YD4L2+/cQlJcSB8+ieh2lD4
         xpCmDlgutZJlarx6xkZtgSSLyHPwLG5CPHJz863s=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 02/15] net/mlx5: Fix a race when moving command interface to polling mode
Date:   Thu,  1 Oct 2020 12:52:34 -0700
Message-Id: <20201001195247.66636-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

As part of driver unload, it destroys the commands EQ (via FW command).
As the commands EQ is destroyed, FW will not generate EQEs for any command
that driver sends afterwards. Driver should poll for later commands status.

Driver commands mode metadata is updated before the commands EQ is
actually destroyed. This can lead for double completion handle by the
driver (polling and interrupt), if a command is executed and completed by
FW after the mode was changed, but before the EQ was destroyed.

Fix that by using the mlx5_cmd_allowed_opcode mechanism to guarantee
that only DESTROY_EQ command can be executed during this time period.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 31ef9f8420c8..1318d774b18f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -656,8 +656,10 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 
 	cleanup_async_eq(dev, &table->pages_eq, "pages");
 	cleanup_async_eq(dev, &table->async_eq, "async");
+	mlx5_cmd_allowed_opcode(dev, MLX5_CMD_OP_DESTROY_EQ);
 	mlx5_cmd_use_polling(dev);
 	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 }
 
-- 
2.26.2

