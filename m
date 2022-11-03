Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919296176FE
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKCG4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiKCG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF39A5FB0
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C39461D4E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC94C43143;
        Thu,  3 Nov 2022 06:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667458574;
        bh=Vd56ekN04I5yWVLjGwPX3iqBCBsZTm95ln4Eu0/PCfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwK6lxrteiHv3STrd9i1BlvzEHOmIFh5bwzu9gM/x23q/dq++Q5ZJ44s9l4tr45bu
         r5HrQOXwQaZaOdZUX6YF+A575h5acnCAukxiC5xtHswUB/u7aqif4jDSpFYsNnRCNb
         HJLdTYWSGIFrdoe/b8UZWAY71/37lI5vFM0gLUbHDpJvGKH33jzIiTYKoL8wuj6PkL
         x90qo4VQruhjfAIbPS8zpohs/IzCsXSF2SBOULY9emJz3y8NHx6s/nOHJLYrftYNQ0
         cjuRN35q/cap0aXARYV225wUKYEasUZvikIoBdKQdkA/1eM0lCnYjT8CIVNszMuD9O
         rmLi7KIMUYLaw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>
Subject: [net 10/11] net/mlx5e: E-Switch, Fix comparing termination table instance
Date:   Wed,  2 Nov 2022 23:55:46 -0700
Message-Id: <20221103065547.181550-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103065547.181550-1-saeed@kernel.org>
References: <20221103065547.181550-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

