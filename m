Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3446039E2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiJSGjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiJSGi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF146E8AC
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F088B82223
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1816FC433C1;
        Wed, 19 Oct 2022 06:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161524;
        bh=ZjZLsaoUuMO8lKf/X5F3+6tJohQ0Q5mJBaOeKHqz1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJ01fqFMnA0k12YnADuv+Bso6Hr7pUNDVZqcgDCc8D+uIqSBU6nWBIBZvTX3N+pOs
         Hb3yETJr10ZdO6n73JljNB97kf7TnpTq6hMQrwo6tU1nNsL9WQyEv0TITSovbb1Tb+
         XdEvFhFoNBedCO9JP0qFGF/NKM1vWaB2qbJowjPD/FSfvF861YGdbM/i2Ec0qXaSYZ
         bRn+WV9vJ6LQ6cgy861FAICJLnIsO7EFflrSfgjTn5epKfYFjW7r37SgF+76lvQkJt
         XjEg6hl1PQAagLRnJXG7/dDv/1TH+SNQIzdzwvdYgu8aYMbB6aHf+CfBqo/pQY/TID
         dQBzlJ6gCoxPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 10/16] net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed
Date:   Tue, 18 Oct 2022 23:38:07 -0700
Message-Id: <20221019063813.802772-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

