Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F3266391A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjAJGMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjAJGMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5002441A79
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02D1FB81110
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96585C433F0;
        Tue, 10 Jan 2023 06:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331106;
        bh=RifqGCwF7vazld07f/Zzr3CRbpk9qxE3OhOJ1i7phH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X733gNvFx/JgQ6BoMkgTrThcYi9C4YD6bcjXxybWWQW1U0mGGljQE+MnYS6AAIJZT
         fLFugp4B1SDsDQ8Cjg/FeeSodtI8WUQsGywJyuK8YA9/5csoxdZ6V3gDR0FpzZ0jVk
         EBOGqFhfTr6UVvb7Cx/LtukJGdjXr3BsWqK+WcbdMxSpcU7OBa5eH+d5UWKTo8TwgB
         I1V59ygT9MaXlAiiZRStL2trdkf7FQTLEtPY3LpyGDAlb315YiICzUw68jE/bHyK2h
         Q4I7PYmglGA3XL4Nz+tk4tKuVzslWrktBq1ud2m+rCXFa35kWtHGpHBJvAjck4qqvd
         fCGwLUc26ru4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 10/16] net/mlx5e: TC, Restore pkt rate policing support
Date:   Mon,  9 Jan 2023 22:11:17 -0800
Message-Id: <20230110061123.338427-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

The offending commit removed the support for all packet rate metering.
Restore the pkt rate metering support by removing the restriction.

Fixes: 3603f26633e7 ("net/mlx5e: TC, allow meter jump control action")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index 512d43148922..c4378afdec09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -34,12 +34,6 @@ static int police_act_validate(const struct flow_action_entry *act,
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
2.39.0

