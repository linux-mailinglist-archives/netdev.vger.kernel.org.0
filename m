Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD81047E7E3
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349936AbhLWTEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37672 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349899AbhLWTEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4728A61F3F
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E275C36AEC;
        Thu, 23 Dec 2021 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286289;
        bh=R54urKv5SKkq9+4bwdg/bmaYR+eb1LICW5jKG402pso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1wuGBtnafo5WALYWyZPwcsXqXFtPBiJJ4pMYeGj+IxMBQrPmMOFhXyaAeiqxNK+y
         btJZpc0ld/aW7SJEkGAWnoxFmFlAEkkqHRqFCTbotbuzkOk4yW1kIl8qAy1GPSOtST
         7Lyqf3H9DI5ZKEZk+49s0fuwHA02DVluNzMcVkYHV6im0mi7/EHP+ciXMO3SPJTXg+
         q7Im4+LEcy+I5jPR5wLuDJq/XIm8fJ8azcAR9BdLbSB/BTAjKgc9R2x9evAsMXX6Zk
         wosTfjHg5pfFs0bVmDzWsNUjVJjdOvwYTRqtVty0r6LOrBukGl6NS5Svm3Lpi3dN1B
         SIyaonGOT34Cw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 06/12] net/mlx5: Fix tc max supported prio for nic mode
Date:   Thu, 23 Dec 2021 11:04:35 -0800
Message-Id: <20211223190441.153012-7-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Only prio 1 is supported if firmware doesn't support ignore flow
level for nic mode. The offending commit removed the check wrongly.
Add it back.

Fixes: 9a99c8f1253a ("net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 97e5845b4cfd..d5e47630e284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,6 +121,9 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
-- 
2.33.1

