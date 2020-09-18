Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E947C270354
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgIRR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgIRR2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:52 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44AD2311A;
        Fri, 18 Sep 2020 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450132;
        bh=FyBS1w7w6BDRvZdUON4OStsEK2rGR18u90f2mhP0YZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3mvZikckcEzEYo5zRA4TW3BP8g2IXA6c9J/x9zwuox6ROyraiPPymfZ0fWXLZDBh
         66cjpG2swQAJ1loC1VNnqzesZNDctbkCs1URidTNYYn7EsHv3sqKSNjEtXWrDViZ7/
         2q0e85Qo8Rk7X1KmM81XyxsOPlY0vAYlkJrBAjt4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/15] net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready
Date:   Fri, 18 Sep 2020 10:28:28 -0700
Message-Id: <20200918172839.310037-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

When deleting vxlan flow rule under multipath, tun_info in parse_attr is
not freed when the rule is not ready.

Fixes: ef06c9ee8933 ("net/mlx5e: Allow one failure when offloading tc encap rules under multipath")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fd53d101d8fd..7be282d2ddde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1290,11 +1290,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	mlx5e_put_flow_tunnel_id(flow);
 
-	if (flow_flag_test(flow, NOT_READY)) {
+	if (flow_flag_test(flow, NOT_READY))
 		remove_unready_flow(flow);
-		kvfree(attr->parse_attr);
-		return;
-	}
 
 	if (mlx5e_is_offloaded_flow(flow)) {
 		if (flow_flag_test(flow, SLOW))
-- 
2.26.2

