Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB4D6232B2
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiKISlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKISlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011E02B255
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9136D61C7B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0318C433C1;
        Wed,  9 Nov 2022 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019266;
        bh=Vd56ekN04I5yWVLjGwPX3iqBCBsZTm95ln4Eu0/PCfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRr+61fOqNZ/LkAjhDu2MSHVU49ei4V6kPKuTbBykF7I9s2Ks/pMizX0pMamtS3Yk
         on1zzzu6RuOEgGB8DLa/LK764Q3y+MKgPjA0K6YL+SMb6ijJulcvuK/2lBlwPzimRY
         /vEtywr2HWib9JZUFSBvbvnvQKu5xSG0YdUw5sUGtXYvF49tKMqu8tkfpyG4RL+cq0
         F0E5riTjJCqIOQ54wqcGeu0cd6dKVWoE3hiaYpTmPG6h/tXTVBgxZ4RMX5L1zzRGsP
         vhUVVJIQGknjegfwR/dluuOfMrJNpfwhYYStFjywSux34umPO/LQmSWuYWv1qVI/iv
         23y6VTgsGbqFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>
Subject: [V3 net 09/10] net/mlx5e: E-Switch, Fix comparing termination table instance
Date:   Wed,  9 Nov 2022 10:40:49 -0800
Message-Id: <20221109184050.108379-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109184050.108379-1-saeed@kernel.org>
References: <20221109184050.108379-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The pkt_reformat pointer being saved under flow_act and not
dest attribute in the termination table instance.
Fix the comparison pointers.

Also fix returning success if one pkt_reformat pointer is null
and the other is not.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index ee568bf34ae2..108a3503f413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -30,9 +30,9 @@ mlx5_eswitch_termtbl_hash(struct mlx5_flow_act *flow_act,
 		     sizeof(dest->vport.num), hash);
 	hash = jhash((const void *)&dest->vport.vhca_id,
 		     sizeof(dest->vport.num), hash);
-	if (dest->vport.pkt_reformat)
-		hash = jhash(dest->vport.pkt_reformat,
-			     sizeof(*dest->vport.pkt_reformat),
+	if (flow_act->pkt_reformat)
+		hash = jhash(flow_act->pkt_reformat,
+			     sizeof(*flow_act->pkt_reformat),
 			     hash);
 	return hash;
 }
@@ -53,9 +53,11 @@ mlx5_eswitch_termtbl_cmp(struct mlx5_flow_act *flow_act1,
 	if (ret)
 		return ret;
 
-	return dest1->vport.pkt_reformat && dest2->vport.pkt_reformat ?
-	       memcmp(dest1->vport.pkt_reformat, dest2->vport.pkt_reformat,
-		      sizeof(*dest1->vport.pkt_reformat)) : 0;
+	if (flow_act1->pkt_reformat && flow_act2->pkt_reformat)
+		return memcmp(flow_act1->pkt_reformat, flow_act2->pkt_reformat,
+			      sizeof(*flow_act1->pkt_reformat));
+
+	return !(flow_act1->pkt_reformat == flow_act2->pkt_reformat);
 }
 
 static int
-- 
2.38.1

