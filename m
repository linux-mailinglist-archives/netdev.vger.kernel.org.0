Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C324273779
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgIVAbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgIVAbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:13 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3407223AA7;
        Tue, 22 Sep 2020 00:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734673;
        bh=FyBS1w7w6BDRvZdUON4OStsEK2rGR18u90f2mhP0YZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9vgMyHG7aorABvDTTR2GZL+aWbEr/iuH2wLm9rZLOPgAGvZnyBR4bnHEl1v+hLID
         1GXVX8Va2gTmuWzxoB7XSJeBiPrEs/Dv0ThPbp+hQuhbjFz+GZJw31g2htOkcozfm5
         T7uqiQYGIURf/eIPmnf/LpZGc7ZLmAHbPHUV38UA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 04/15] net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready
Date:   Mon, 21 Sep 2020 17:30:50 -0700
Message-Id: <20200922003101.529117-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
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

