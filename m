Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010424A6B3A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiBBFG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiBBFGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F608C061751
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CBAB83017
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C604C340EB;
        Wed,  2 Feb 2022 05:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778398;
        bh=pVweSGCIjIPH1CT9G8ovF7LlyDzsawSef5EVe3W+fKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EARwtxFHH1i3bhIe1uaaogBN3oaUdoOpfkey8N560e8efgSZXyvIsYWLcJ5zKR77A
         DMZ35AFXDC6FDOvt2vVPF/3bLd68DtkCN4vGrPhuu6fXvz9BVMxR3frwgAOZw2t7mt
         JoxVlhr09llQuxnJjsHrMFC61T9FJx5PHcK2nNqMR39+EVegldpuCpH2StuFgymYkM
         3TqBp9VaQnvCCA6qcB+O8LG08v+Ww0ibJ33ihfNg0+TaeYSS/AgxmTyL5dqkypIPOX
         LWZ7rBdXvndSty5xl0yj5/FdyxUL/f44qwXw4y8k9kEov4R+F9AHZyqOsk5hKhMRQE
         sArzA5R9bMiIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/18] net/mlx5: E-Switch, Fix uninitialized variable modact
Date:   Tue,  1 Feb 2022 21:03:58 -0800
Message-Id: <20220202050404.100122-13-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The variable modact is not initialized before used in command
modify header allocation which can cause command to fail.

Fix by initializing modact with zeros.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index e94233a12a32..df58cba37930 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -212,7 +212,7 @@ static int
 create_chain_restore(struct fs_chain *chain)
 {
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
-	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
+	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
 	enum mlx5e_tc_attr_to_reg chain_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;
-- 
2.34.1

