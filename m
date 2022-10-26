Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70A160E2A9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiJZNy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiJZNw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55CD100489
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F5D0B82257
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E53DC433C1;
        Wed, 26 Oct 2022 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792358;
        bh=ZjZLsaoUuMO8lKf/X5F3+6tJohQ0Q5mJBaOeKHqz1sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZNe/aCVqEVwxl2I1AouYvX1ITAp1LClwiVINRj2BHuFJiOggaiFwkpf/V3UlJjJU
         DV4xq4VNK61LuKc/b1P8bfwMDc62p3lmZPPTY8csigmDcpnRPqpe4ZiqEiH4y6PWDC
         9ROpTpFCyCjx2MziRcA7sZZ5zxcCLdlwHvXx+iifR+DhIhil210/H3vIap0jJXVoZ5
         CWwZKUkCej6oS6cMf3cgOmd5s9MIM15ywGGm+AyrZdjG4eKBbbF3DB5wtdQ7YnhQve
         /htgdveDmegEx/a/Ca3x1PaoZ88gWhKfmfPU99F8G5xEsYEUR8weWwsodioI4kSk7l
         4/gI011jlWDvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V4 net 09/15] net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed
Date:   Wed, 26 Oct 2022 14:51:47 +0100
Message-Id: <20221026135153.154807-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
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

