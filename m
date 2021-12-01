Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C8F46473F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbhLAGkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346950AbhLAGkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5EBC061748
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FDDB81DE7
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C0EC53FAD;
        Wed,  1 Dec 2021 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340644;
        bh=0XFKlng1J8tde4votAg7WsG2hmhMlFOHED2KpQszQvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dk3gKU6eXvDBCv/V0IiaLBHtL7g5Z7ivS5OVdy3aQ1J96UdoqHMpBvbLQbiwRvBPs
         AXgSvgvzROGNlZAXbarNiRZSYMkGg+cevqcXEDxM+HIsKpOBO3tUptcnzRs8RR1pOI
         sVTzQn3Hvf98c3PhqVWp7N8x6Ajac8R619N/1yrvH+7NviQ4JRACTeGTO7qMW1Yi3C
         0ok8GLaUDlhLl+T2MZJZoiNiqFN4IllseZri1cPyMD3SnLGqTw99WA8wbXYpi82JTF
         CRJCMmLqgM3WwcrI3OVUrbabvkqFz222XpgT14O5DaDwymoLEWBBG4sXP4XykE52Nn
         DRE03VFAV/zPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/13] net/mlx5: E-switch, Respect BW share of the new group
Date:   Tue, 30 Nov 2021 22:37:02 -0800
Message-Id: <20211201063709.229103-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

To enable transmit schduler on vport FW require non-zero configuration
for vport's TSAR. If vport added to the group which has configured BW
share value and TX rate values of the vport are zero, then scheduler
wouldn't be enabled on this vport.
Fix that by calling BW normalization if BW share of the new group is
configured.

Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index c6cc67cb4f6a..4501e3d737f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -423,7 +423,7 @@ static int esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 		return err;
 
 	/* Recalculate bw share weights of old and new groups */
-	if (vport->qos.bw_share) {
+	if (vport->qos.bw_share || new_group->bw_share) {
 		esw_qos_normalize_vports_min_rate(esw, curr_group, extack);
 		esw_qos_normalize_vports_min_rate(esw, new_group, extack);
 	}
-- 
2.31.1

