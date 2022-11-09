Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FCB6232B3
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiKISl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiKISlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DEF15719
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49A7EB81F8F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE114C433D7;
        Wed,  9 Nov 2022 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019264;
        bh=cJ4O9zUr7RZpt/tIi/YXJFbxs6v4hTnrk23xPcjXV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIhZPaNMpLp/FbBKrs9vUUFNi+IDJioAdDzHT2sIUJ/vmZtB16dWnKxphYsoRX5nE
         BlejCWY+MMe9NOzjHhoLyskP6/GwGV4v4TogsC5Sj/YVjLv6XdhIoEtjCA1HUQ0C5j
         eaT/2TGIbB1rE9N6zUJTBCaqEyf6Owvzuy6mCDyVWvi+PxcDp83amkTAmmcwNGuj2W
         nnBOYUcZdsrwHnu+BHth7wqC0pQvLql0yt+ChlqwOfiz2pautVFIYOw2YCgfBr6L/v
         Mc/s8iTu5kZ0gNTZTpIJLYwH7PxiR5biBCe0+XkPm1JcICatD6jThCuxpXVpuXeSXo
         00oOaVs91gzVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V3 net 08/10] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
Date:   Wed,  9 Nov 2022 10:40:48 -0800
Message-Id: <20221109184050.108379-9-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

In the bellow commit, we added support for PPS policing without
removing the check which block offload of such cases.
Fix it by removing this check.

Fixes: a8d52b024d6d ("net/mlx5e: TC, Support offloading police action")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dd6fea9e9a5b..372dfb89e396 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4758,12 +4758,6 @@ int mlx5e_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.rate_pkt_ps) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "QoS offload not support packets per second");
-		return -EOPNOTSUPP;
-	}
-
 	return 0;
 }
 
-- 
2.38.1

