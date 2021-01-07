Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356C12EE6E4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbhAGUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbhAGUaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 670BD235FA;
        Thu,  7 Jan 2021 20:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051357;
        bh=OdKoz1arEP7iap2o2AyJ2AHvTY2yJJbfIaitguX/GsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UP8ZYqW8SiAkbD6uvkrMQivJ6oi90Zka1HzdaKn1xbN5cyhMThfe4Bqd3Rz1moMoc
         IFrDJIanL6+KIl3bi8ZqCX034T5ao+vqN1I5DIDtiBmuF0L/zXoDRmrokURL+KyuUu
         zptOjLAlsC9dP8A9XHejAiiGADjg5nCOOViWmjc29AwNQWvxaY1aiqVTP//cC4k2lb
         5wPNHknOz5QPXDyVW7GONa+mmRFDYabr/N9HUIdtGHoBsoL8Lqq6nw/anv/j0lPBQ3
         ZsiL00NWMuLuiLKvqqcSAVyyHb1/DAEib2KnWzowElLz9mrxlwYG1bfs6gKxfAhZJ9
         wIQ5uS71T+cBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/11] net/mlx5e: Fix two double free cases
Date:   Thu,  7 Jan 2021 12:28:44 -0800
Message-Id: <20210107202845.470205-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

mlx5e_create_ttc_table_groups() frees ft->g on failure of
kvzalloc(), but such failure will be caught by its caller
in mlx5e_create_ttc_table() and ft->g will be freed again
in mlx5e_destroy_flow_table(). The same issue also occurs
in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
kfree() to avoid double free.

Fixes: 7b3722fa9ef6 ("net/mlx5e: Support RSS for GRE tunneled packets")
Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index fa8149f6eb08..44a2dfbc3853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -942,6 +942,7 @@ static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1087,6 +1088,7 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.26.2

