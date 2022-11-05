Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A4761D822
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiKEHLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKEHLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EADB2F67F
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB909B81645
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66196C433D6;
        Sat,  5 Nov 2022 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632244;
        bh=Vd56ekN04I5yWVLjGwPX3iqBCBsZTm95ln4Eu0/PCfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgN4ZpoMmvY/ykBo3SZKcNYUuFQPTU6ooi9l3m2brgoaGwuioCTlw4MrA2YhAah40
         Aj3jOXAQUeMGyKOKC2Gha3MaUnoXLZbrNwOBhJl5J/eQX3gH8b0afOCGbMHdwdKgRM
         8btpmqT+CiOMcVivIoOhsasdH7IBqdoCPN2Gh/4bx1MDbZ9ZSTQnzllhjWfJxl+cwI
         61W1vkT+kf3FTbOAGunBDxqsicBR6Q9xV2Z/5P4MBAyLwW3eYtjPYL7+TDZO4z2jC1
         RcgCJw1tK3UVsN1lLgXfkvOsxf6Wu3rOXPDGGrcZdf3txRzqkz4LqSnPEyMVngurFg
         325+T2WfMJ0IA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>
Subject: [V2 net 10/11] net/mlx5e: E-Switch, Fix comparing termination table instance
Date:   Sat,  5 Nov 2022 00:10:27 -0700
Message-Id: <20221105071028.578594-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
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

