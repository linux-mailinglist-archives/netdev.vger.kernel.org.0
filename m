Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE164C2070
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245190AbiBXANF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245173AbiBXAMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD05F4E4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4348160C4E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A2EC340E7;
        Thu, 24 Feb 2022 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661541;
        bh=sMNnaBhHrJxhLhgkhKxTNmWwYE/paHhEfrkjZeIpTC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dp7EWDO3xaBIoxuBuPRsq3vP4UBpzOsJBA6GKVbalkgHQ0OjX7YNgXT6ObjVZ62ul
         BjPgbmwoqONm947oUVtyGt1CwYFNLkz5iceQwoFpLZ8SMpbe96RKsGQS4RKwIDN4OV
         aspZ0+1z0ZUoitdUa57LsMLDSNIrizi1HQEfoqBTQj3lc4QXR7jDLVd4P5Bv0go9Vb
         b0oVdLIWX3VQpgE8H2p5HtfocDUoMaSEfLB1vIHuf2hCjXxNpiCmnYTURpUTf2C0oB
         o72Ot3Yzc0EzEL8sI6ZdAb1QPF0vjJTD9Ac/QQmH/uF8tjvJfIXvVwGNm8IzEw5huf
         VX+knEorHt65g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 08/19] net/mlx5: Fix tc max supported prio for nic mode
Date:   Wed, 23 Feb 2022 16:11:12 -0800
Message-Id: <20220224001123.365265-9-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Only prio 1 is supported if firmware doesn't support ignore flow
level for nic mode. The offending commit removed the check wrongly.
Add it back.

Fixes: 9a99c8f1253a ("net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index df58cba37930..1e8ec4f236b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,6 +121,9 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
-- 
2.35.1

