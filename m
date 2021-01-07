Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A452EE6E2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbhAGUaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbhAGUaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D9E235E4;
        Thu,  7 Jan 2021 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051350;
        bh=gpn3EOXUylGk4VvsEbqeSdLMl+yhj2SrwRanSTb0V1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG/BwYpb8EZhpZ34l2TpDstNdLU8P+0K5iZvxdgewlJYFcY22ZJLCbuMqFsC7U4sE
         w5aRnFGQKIjcAwPSGL3eLF5+bZx11BUIVS33Qofg8sYZ5ruvwPN3QMe1obLT8lymAL
         V55sQscVjM63bvcfRcRjh6Mi1T49nLxkowZ4pzKag6out2NtD3bTN11Y3vjvU/UB6T
         2ERMRfyGNgxIPmrMcL0IwR4weAE1fKrW1hxw9l70/3YG7mzjNStZW8OvB1cwt6Gwkw
         KbzyWvs8SVHr89N7NPeSFhirMdPmC7hIejtQV9e1XPsbUfOgrQ6i10Ro8476XzEBbr
         DulZ2Uhgcf6yw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/11] net/mlx5e: In skb build skip setting mark in switchdev mode
Date:   Thu,  7 Jan 2021 12:28:41 -0800
Message-Id: <20210107202845.470205-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

sop_drop_qpn field in the cqe is used by two features, in SWITCHDEV mode
to restore the chain id in case of a miss and in LEGACY mode to support
skbedit mark action. In build RX skb, the skb mark field is set regardless
of the configured mode which cause a corruption of the mark field in case
of switchdev mode.

Fix by overriding the mark value back to 0 in the representor tc update
skb flow.

Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index d29af7b9c695..76177f7c5ec2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -626,6 +626,11 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	if (!reg_c0)
 		return true;
 
+	/* If reg_c0 is not equal to the default flow tag then skb->mark
+	 * is not supported and must be reset back to 0.
+	 */
+	skb->mark = 0;
+
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 
-- 
2.26.2

