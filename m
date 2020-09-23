Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A263827641E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIWWsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWWsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:37 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3492311E;
        Wed, 23 Sep 2020 22:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901317;
        bh=HztPav7PzQCDTI2H2uiVLinSY1eGp/WyexoEeDWKO2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqAy6PjGSK2IXsaid++x9C5ZriE0sxWAzkQlxJwbnfsvegPJ4d+1bQV7abkXOwS4l
         zVllcY86353Jf/AXi2QBGIfEVW0N0/SRHoA/4VmEEAPSFT/Q2AIcty3NEc0hIj3jcb
         2Q+wTz5OcDHWRzlGgioWu7jX1wi1Q0dHXxT3pTas=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/15] net/mlx5: Allow ft level ignore for nic rx tables
Date:   Wed, 23 Sep 2020 15:48:11 -0700
Message-Id: <20200923224824.67340-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Allow setting a flow table with a lower level
as a rule destination in nic rx tables.
This is required in order to support table chaining
of tc nic flows.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 75fa44eee434..6141e9ec8190 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1595,11 +1595,12 @@ static bool dest_is_valid(struct mlx5_flow_destination *dest,
 		return true;
 
 	if (ignore_level) {
-		if (ft->type != FS_FT_FDB)
+		if (ft->type != FS_FT_FDB &&
+		    ft->type != FS_FT_NIC_RX)
 			return false;
 
 		if (dest->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
-		    dest->ft->type != FS_FT_FDB)
+		    ft->type != dest->ft->type)
 			return false;
 	}
 
-- 
2.26.2

