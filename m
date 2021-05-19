Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703D2388749
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbhESGHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238432AbhESGH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F7B613AF;
        Wed, 19 May 2021 06:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404368;
        bh=6epX1fCO4rTxz8QyIHchnL9gEokCrDZwnEhuQ8A4X8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJp4BFN9FIvtIPFp+jfmzcCRdVjezY5CYpxEQMpz0pHYZI+UKhKJJn+2CjF3LhRfc
         PDj69jUjTGXelITPNNzVvoy6KKUIieP8/AOy0KMLA1D2qimJ4++QXnrc/SfqUx7wzL
         cAIzFAK2ibJU7aNpAokHBs9jlJIqHEZwGiZX7cJ4KttcGyL/wapvMUdkka4my1KlaR
         7GyiR5NkD53Hv/piEMPtOUtsF/B8T/PMUiYowaqfdQn9IR3F0+deb93Xd7J5jMXZdX
         6n/aeH0WinWoaVkKCSR6JmZHkHlwp8kllUpDDMhC3OBSOt1jFnU+9DF0NY5afnbtG0
         oaiMJNWqfaKQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/16] net/mlx5e: Fix null deref accessing lag dev
Date:   Tue, 18 May 2021 23:05:14 -0700
Message-Id: <20210519060523.17875-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

It could be the lag dev is null so stop processing the event.
In bond_enslave() the active/backup slave being set before setting the
upper dev so first event is without an upper dev.
After setting the upper dev with bond_master_upper_dev_link() there is
a second event and in that event we have an upper dev.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 95f2b26a3ee3..9c076aa20306 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -223,6 +223,8 @@ static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *pt
 	rpriv = priv->ppriv;
 	fwd_vport_num = rpriv->rep->vport;
 	lag_dev = netdev_master_upper_dev_get(netdev);
+	if (!lag_dev)
+		return;
 
 	netdev_dbg(netdev, "lag_dev(%s)'s slave vport(%d) is txable(%d)\n",
 		   lag_dev->name, fwd_vport_num, net_lag_port_dev_txable(netdev));
-- 
2.31.1

