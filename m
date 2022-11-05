Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB94961D820
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKEHLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKEHKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21022F3B7
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4980460010
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59918C433C1;
        Sat,  5 Nov 2022 07:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632243;
        bh=cJ4O9zUr7RZpt/tIi/YXJFbxs6v4hTnrk23xPcjXV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcfT9vFD0VM02cP+2LmHFOMovKBPXCRszGgBHmyyedcBlEcaSRXGwPdIh/l3+OQIb
         WvxK5yeGpRxd/SWxfpMJOTm102CCEhF9IB3QrYBn1Hsm240pd5IautGLWJaQ47jFx9
         26dzLkUBN4/bHCN1paDg/pHqGfti3csG+jIa873LTscT5psR15w9lzkb+HbW/AeG7g
         vbLJoheUDSTi6nTYZrQk4S4OjvFKLa5piVxX/aA2iPj74a+Z/qhWXKJtd5Nn0OKJUf
         WCckxzd2BWKDpMaOm2NjSWZ2iVnoLTba6xJigJZ9Q54yefgURscTD/CTIed50Y/rpG
         YfHKel9oZ8LwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V2 net 09/11] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
Date:   Sat,  5 Nov 2022 00:10:26 -0700
Message-Id: <20221105071028.578594-10-saeed@kernel.org>
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

