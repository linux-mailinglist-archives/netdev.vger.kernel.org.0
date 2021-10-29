Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE1440484
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJ2U7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231346AbhJ2U7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D05E61056;
        Fri, 29 Oct 2021 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541009;
        bh=9VQCaSmeQWZZkaRFP5Yq4RFLw2QWblyhCEGp9Gr0Qx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfs/TE49WxMeNyZKh8w9mtDr+NoInQ8xNuTnckqhRQRtrUe5Mof0aiqVOSmnjI6E7
         437sjChxkhP2utXEyYWeb0uKhgssLwJPuj2RMbYx8txEYrAzJN+v9Acc5Y0BXiTrnV
         oE90qJdTy3p+8lVgPFpKThWknIvucOnrk39NQ2ObNgk+rVIb8AJGT++waiCOZVeLJN
         o/wEiqs5Mqt31rC9bzky/RIMa8kiwikZoCVQNBE5HrzEdZ6g/yfVtuCzARy5NZKjOs
         e0LjUWGapvjbPeF90bcNQvyIsr2YM1TtoEWqPnNLtVz2lig+1OoYHAV78ztGVCzl6l
         +FwKOE+WsewuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5e: Term table handling of internal port rules
Date:   Fri, 29 Oct 2021 13:56:31 -0700
Message-Id: <20211029205632.390403-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Adjust termination table logic to handle rules which
involve internal port as filter or forwarding device.

For cases where the rule forwards from internal port
to uplink, always choose to go via termination table.
This is because it is not known from where the packet
originally arrived to the internal port and it is possible
that it came from the uplink itself, in which case
a term table is required to perform hairpin.
If the packet arrived from a vport, going via term
table has no effect.

For cases where the rule forwards to an internal port
from uplink the rep pointer will point to the uplink rep,
avoid going via termination table as it is not required.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index d0407b369f6f..182306bbefaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -220,7 +220,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
 	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level) ||
 	    mlx5_esw_attr_flags_skip(attr->flags) ||
-	    !mlx5_eswitch_offload_is_uplink_port(esw, spec))
+	    (!mlx5_eswitch_offload_is_uplink_port(esw, spec) && !esw_attr->int_port))
 		return false;
 
 	/* push vlan on RX */
@@ -229,7 +229,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 
 	/* hairpin */
 	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
-		if (esw_attr->dests[i].rep &&
+		if (!esw_attr->dest_int_port && esw_attr->dests[i].rep &&
 		    esw_attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
 			return true;
 
-- 
2.31.1

