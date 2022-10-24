Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D20609A52
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiJXGNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJXGNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768B15F138
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 590D96100F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6BEC433D6;
        Mon, 24 Oct 2022 06:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666592008;
        bh=ZjZLsaoUuMO8lKf/X5F3+6tJohQ0Q5mJBaOeKHqz1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6BXedfmN31BmMq9KQcniKtj3E7+fXPo2KwEFYIlXV+gipX6FH28KOJnjgFbpqEhM
         iXnGyLIVGN8xcdCrpP2Vd7Bu0lWqcXGiAqn6eDAzGjRhQ2kCgR7qZ77eBvdC0vif3X
         OhKEHGKUPCe7xVbThWyVLCXnkA6c2x2afrU1H0HEoYa4YTSUvRvUDYTY6Khk+6MluA
         mLvJlswoMcW1onpbV7L+4G59qs0Qvq7LP2h9vnLpPv5MN7wp0zQgKy2QbX+nCOcxe9
         0CAWVuK2MQGYuELNrP4pwI5u9CZBK831Rj+O0DUxc31bIGUcG1MQtdwob8M6KqJ1mf
         5elibkCKBGt4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V2 net 10/16] net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed
Date:   Mon, 24 Oct 2022 07:12:14 +0100
Message-Id: <20221024061220.81662-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024061220.81662-1-saeed@kernel.org>
References: <20221024061220.81662-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

On multi table split the driver creates a new attr instance with
data being copied from prev attr instance zeroing action flags.
Also need to reset dests properties to avoid incorrect dests per attr.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 73f91e54e9d0..dd6fea9e9a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3633,6 +3633,10 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->action = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
+	attr2->esw_attr->out_count = 0;
+	attr2->esw_attr->split_count = 0;
+	attr2->dest_chain = 0;
+	attr2->dest_ft = NULL;
 	return attr2;
 }
 
-- 
2.37.3

