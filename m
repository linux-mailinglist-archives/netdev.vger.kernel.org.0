Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50F36BC049
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjCOW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjCOW64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:58:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9D898D7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA46B81F9A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5257DC433EF;
        Wed, 15 Mar 2023 22:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921133;
        bh=x6CV/3OdSvRFn/Xvzq9Jya0GwJV9HxqPxRl8VsWaBB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3tiaL0hTHzzIBcSBXPNtC3UTb4YRZ1xQfTE8J9kHDzIihIhcHe1OjMqVTzppMUH4
         PFhWQftsPpKlrxvaWWMCRTVVsEmuEDyJlvPyWuczQW16eheeSW5o23sXYBETj13Yjh
         nPRMKy8TH7R+xYL7M6mYxY6ox6/YJsHoKI85WX/rMyS+/xa/r+dM1qVj2N3fPkCwNM
         mSzPNKWglPz/nsmIq6UAIRANI+J8mHfWVfkJ1XAKIS9IPX8apKDeSqtEgvYE5oTaSK
         vVySQ0bSknPH+iSW6EhdgwepaYLXTr3OZ+dtiYLcCD1gD+fRj7hHBVWfG8SGpLiMUq
         h0iHqzCycR6Lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net V2 05/14] net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
Date:   Wed, 15 Mar 2023 15:58:38 -0700
Message-Id: <20230315225847.360083-6-saeed@kernel.org>
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

In few cases, rules with mirror use case are split to two FTEs, one which
do the mirror action and forward to second FTE which do the rest of the rule
actions and the second redirect action.
In case of mirror rules which do split and forward to ovs internal port or
VF stack devices, source port rewrite should be used in the second FTE but
it is wrongly also set in the first FTE which break the offload.

Fix this issue by removing the wrong check if source port rewrite is needed to
be used on the first FTE of the split and instead return EOPNOTSUPP which will
block offload of rules which mirror to ovs internal port or VF stack devices
which isn't supported.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Fixes: a508728a4c8b ("net/mlx5e: VF tunnel RX traffic offloading")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d766a64b1823..22075943bb58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -723,11 +723,11 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	for (i = 0; i < esw_attr->split_count; i++) {
-		if (esw_is_indir_table(esw, attr))
-			err = esw_setup_indir_table(dest, &flow_act, esw, attr, false, &i);
-		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
-			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
-							       &i);
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			/* Source port rewrite (forward to ovs internal port or statck device) isn't
+			 * supported in the rule of split action.
+			 */
+			err = -EOPNOTSUPP;
 		else
 			esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
 
-- 
2.39.2

