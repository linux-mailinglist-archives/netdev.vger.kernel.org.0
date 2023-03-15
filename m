Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF46BC04C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjCOW7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjCOW7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:59:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC177A226C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7053EB81F93
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4DCC433EF;
        Wed, 15 Mar 2023 22:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921134;
        bh=OhCG+HoqPYpf382jXR9O8a+Pon3qXkWhaZMmPLQLyOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cylVNQnW+D7yL4njSmKTFs0vMZx3VB1XHca0/oU43KsT9QPsB0G9Up3jOhQk+2Nsd
         ngbzkszXPuahWDy59OF+LOPuIrO5gruwt4SxDwhu4vX1alsLqLGqNT8Txs0frSRZ+3
         qNk0/R9PHbKWNZqxxCgU7l1NF4Xyos43zRvEkOm8ZetiYFa5fJKTOzF7OG5DglWmqG
         e9f7nZjna4Y9lFi8KAhhpOmau9CzcMGGfb3sCxhc/zTWdufTriBsXSCgoGeQqcmFOd
         gRF4ujBO3AoiVUypFJxpMo8QLlbRWF7m2yTO7ntC2ct6WNFomIiQacYxymSUm8bUeZ
         ONsawltdwYrsw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net V2 06/14] net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port
Date:   Wed, 15 Mar 2023 15:58:39 -0700
Message-Id: <20230315225847.360083-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

Rules with mirror actions are split to two FTEs when the actions after the mirror
action contains pedit, vlan push/pop or ct. Forward to ovs internal port adds
implicit header rewrite (pedit) but missing trigger to do split.

Fix by setting split_count when forwarding to ovs internal port which
will trigger split in mirror rules.

Fixes: 27484f7170ed ("net/mlx5e: Offload tc rules that redirect to ovs internal port")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 70b8d2dfa751..90944bf271ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4304,6 +4304,7 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 
 	esw_attr->dest_int_port = dest_int_port;
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	esw_attr->split_count = out_index;
 
 	/* Forward to root fdb for matching against the new source vport */
 	attr->dest_chain = 0;
-- 
2.39.2

