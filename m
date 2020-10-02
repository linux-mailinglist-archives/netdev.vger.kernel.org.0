Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CAC281A7D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbgJBSHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgJBSHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 14:07:06 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C470C208B6;
        Fri,  2 Oct 2020 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601662026;
        bh=U8P41oSAqhaQ7HCq8VzIHFjjhCogaVVfm4fsuFKd1Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wamQAP6qFZ/ywFxwDe/NztDvDFn90DsdsZgtV2nH1WxtTqm8cSbXrR1m5T7zildZV
         SoXKDK8KDQf9Uz3MGCy7SWLO/RJfoMldnFiRvQEahr8lJ5ntA9s0EHejwwwfDUA7sK
         DgHxUvAeUZlWeeVPLXwUwQV3y5mfcPOY/DplzJi8=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V3 01/14] net/mlx5: Fix a race when moving command interface to polling mode
Date:   Fri,  2 Oct 2020 11:06:41 -0700
Message-Id: <20201002180654.262800-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002180654.262800-1-saeed@kernel.org>
References: <20201002180654.262800-1-saeed@kernel.org>
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

