Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4013464743
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346970AbhLAGlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:41:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37288 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhLAGks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4FBA7CE1D74
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D6EC56748;
        Wed,  1 Dec 2021 06:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340645;
        bh=zunc0sqNSQqjG5x+nbShZzFhad8YPasPuHVEYKzUiHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1qNBT0kfKXkswB5Nq8eOPLNddbXplTwfpxBJFNyo9w1keQV70S3Xr3eh9JB5abNe
         E+Bo5tMcSPKbjE0pyokN/ez705cMmXUUAnoCCsM1+M4UZ4YXjPd+QRtO+4Vn6O/Ypo
         sBu+R2E7pS61JyWBgc0sh8Hz/2oaQXR/lTfHJc0u9fpwBh/EPR6bRyOUqeTkM9AuX5
         dWbEbVtdpSRFF6XGuEW4yj2T5GcpmpzcC/UfrR+R5y/wN99kAvF/9GOpX1S31e6hHL
         w5ciCnOUIO0Oqj9QMjaZ2IjE7sm3Ky7TUA9a/mbVbpes6lmsgW+yvDVAXWRag/od24
         DmGu/1J+dFqsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/13] net/mlx5: E-Switch, Use indirect table only if all destinations support it
Date:   Tue, 30 Nov 2021 22:37:05 -0800
Message-Id: <20211201063709.229103-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

When adding rule with multiple destinations, indirect table is used for all of
the destinations if at least one of the destinations support it, this can cause
creation of invalid indirect tables for the destinations that doesn't support it.

Fixed it by using indirect table only if all destinations support it.

Fixes: a508728a4c8b ("net/mlx5e: VF tunnel RX traffic offloading")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 275af1d2b4d3..32bc08a39925 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -329,14 +329,25 @@ static bool
 esw_is_indir_table(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	bool result = false;
 	int i;
 
-	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
+	/* Indirect table is supported only for flows with in_port uplink
+	 * and the destination is vport on the same eswitch as the uplink,
+	 * return false in case at least one of destinations doesn't meet
+	 * this criteria.
+	 */
+	for (i = esw_attr->split_count; i < esw_attr->out_count; i++) {
 		if (esw_attr->dests[i].rep &&
 		    mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
-						esw_attr->dests[i].mdev))
-			return true;
-	return false;
+						esw_attr->dests[i].mdev)) {
+			result = true;
+		} else {
+			result = false;
+			break;
+		}
+	}
+	return result;
 }
 
 static int
-- 
2.31.1

