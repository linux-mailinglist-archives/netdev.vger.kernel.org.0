Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9884A6176FF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKCG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKCG4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:56:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2B811821
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18D97B82675
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4103C433D6;
        Thu,  3 Nov 2022 06:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667458573;
        bh=cJ4O9zUr7RZpt/tIi/YXJFbxs6v4hTnrk23xPcjXV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8Tdp6JrHytNRpkv4UBOxm+tqCAYo64R1fkzSd5+SeCZmypS8rBWN9eR9W0qjEa27
         yK+EFZA7oSbu9OeLzly/NQP9Q7b/ZBNu6zF6FQ58NnjtQSS2U9fyvKJnTZoof5y7CS
         URn6gwfwJiX39wEWgGpqmb5AazXmdudhtiYqnlU7rBCVflooTJM/OTAFLeGbvYglj9
         0OcjvCmG/7j6bYkylXM/OeVrM77lAlrK0+J/yiY96orz+ExkyTMDQi4K2NSnMouQ/P
         eBLtZLV4IoQNf7gHJaB4uqSTd67is0TmJbZOgU9KA8nBMUZjMr2dFoc42TiqZ/Alwi
         /TO47x917l07g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 09/11] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
Date:   Wed,  2 Nov 2022 23:55:45 -0700
Message-Id: <20221103065547.181550-10-saeed@kernel.org>
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

