Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C30658679
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiL1ToV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiL1ToE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:44:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640F412770
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12E3B818F0
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDD8C433EF;
        Wed, 28 Dec 2022 19:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256629;
        bh=CUWDwUBZMehbfOmD2cVf892WPUqgebKqkH+PRiTefFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfHEltBMwmDW5qWTKCVhsahyNXjcPRRyfh/U7fWYy9hSxoYI539qE+HHc0XoThbHi
         psMS0VhvwHNAb4UJD9tMFGa0qcOBCdVgm/eclvhnJVca7gdPJVwJI2BKxCqvlzwI0L
         5qr69gXW3WhzXQEqsNmlhvWW9Z6wsoc/z6+SWglOq1UFr4Yre/tnlm136n1ZwcJILk
         qhIQ1LPqhBHL6Fzzt06AV9rIDFZLyv7kP4Dzilj1WANV0cbI9c0RW9Ci0wLHa/jTYC
         9FMW6XN8agqGhEfQfSklRMYAh10uYPjsWBFeMh9oXMYpZrzJEQBxMo+ZFND4yMul/L
         dW0XzrWxpN3cA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 11/12] net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option
Date:   Wed, 28 Dec 2022 11:43:30 -0800
Message-Id: <20221228194331.70419-12-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

The cited patch added support of matching on geneve option by setting
geneve_tlv_option_0_data mask and key but didn't set geneve_tlv_option_0_exist
bit which is required on some HWs when matching geneve_tlv_option_0_data parameter,
this may cause in some cases for packets to wrongly match on rules with different
geneve option.

Example of such case is packet with geneve_tlv_object class=789 and data=456
will wrongly match on rule with match geneve_tlv_object class=123 and data=456.

Fix it by setting geneve_tlv_option_0_exist bit when supported by the HW when matching
on geneve_tlv_option_0_data parameter.

Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index f5b26f5a7de4..054d80c4e65c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -273,6 +273,11 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 		 geneve_tlv_option_0_data, be32_to_cpu(opt_data_key));
 	MLX5_SET(fte_match_set_misc3, misc_3_c,
 		 geneve_tlv_option_0_data, be32_to_cpu(opt_data_mask));
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
+				       ft_field_support.geneve_tlv_option_0_exist)) {
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc_c, geneve_tlv_option_0_exist);
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc_v, geneve_tlv_option_0_exist);
+	}
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
 
-- 
2.38.1

