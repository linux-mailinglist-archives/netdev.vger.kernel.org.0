Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A66E8730
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjDTBKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjDTBK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13906A1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40AC64433
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CF9C433EF;
        Thu, 20 Apr 2023 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953024;
        bh=o5IAyXnbDrtMk5vhAYVDPVz5ufRdjLAQ0NhfaGoiJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9GeUNuENSkgneOs1uEyJIeVIkjFXQHPNQZRE43HiLtZ8eMB6/ssxww6z96zCcPWZ
         ClrXQHWKj17pcPY7vuaUWf5QLPeg2FrICfLaxIuj97Xs2zpOk/V9CE7cuAStKLvbxd
         klSDa6KlQyxfnmexcvQgbbUE4l04zfARpj3oldIw2YwE2+T3H2dxYhmalMdRamDXYt
         eDgYzyoty2c37DjgT19EqMcBsydMaoUQjxM+Y2TXSJbg4H5EJQ3R0r7HL+cuFIc5kR
         XCBjWPx/BXXDMmwkTYeXTxmZ+HMLjp2UJn+EKqQCpnRQrkkkqxLdNrYGvZQDw1waNA
         7SoULzdg7Ka7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net 04/10] net/mlx5: E-switch, Don't destroy indirect table in split rule
Date:   Wed, 19 Apr 2023 18:09:53 -0700
Message-Id: <20230420010959.276760-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420010959.276760-1-saeed@kernel.org>
References: <20230420010959.276760-1-saeed@kernel.org>
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

Source port rewrite (forward to ovs internal port or statck device) isn't
supported in the rule of split action. So there is no indirect table in
split rule. The cited commit destroyes indirect table in split rule. The
indirect table for other rules will be destroyed wrongly. It will cause
traffic loss.

Fix it by removing the destroy function in split rule. And also remove
the destroy function in error flow.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 706746cd10af..c99d208722f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -760,7 +760,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	kfree(dest);
 	return rule;
 err_chain_src_rewrite:
-	esw_put_dest_tables_loop(esw, attr, 0, i);
 	mlx5_esw_vporttbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
@@ -803,7 +802,6 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	if (fwd_rule)  {
 		mlx5_esw_vporttbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
-		esw_put_dest_tables_loop(esw, attr, 0, esw_attr->split_count);
 	} else {
 		if (split)
 			mlx5_esw_vporttbl_put(esw, &fwd_attr);
-- 
2.39.2

