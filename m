Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD36B9D6F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCNRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCNRt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4BB9F054
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 063B1B81ACB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA226C433D2;
        Tue, 14 Mar 2023 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816191;
        bh=x6CV/3OdSvRFn/Xvzq9Jya0GwJV9HxqPxRl8VsWaBB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf8bXhMykd0DZGhMPc1WQPyTpvgIzWFjtU6DcxtCklQF9sgMTLidmvhqTfazQlvJe
         jCfEtf1mZnfEVgO1/LNM077eEzhfQLe7T+dUZx47mZAw1teyblDDHZlFOB0TTkWVPt
         gHBFW+Ej9MdVmsMlc8RJDjlDeGm8OF9WAMmtc5k1c/G4HH9GKxkOlDPNh5p6S8VwIX
         p2EDHqIOwDmcxc+Adug5d4HLHTsOp163mJHWH7GyxxmITNMjyCD4vvW5kWk//FmC4F
         2l08mmornZxR+oP9ht+K268Qgx1x4/rSc+nSu1pqnO3BqF/s53KxlkHw9GMlk359tC
         j2fXALBmIBPSg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 05/14] net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
Date:   Tue, 14 Mar 2023 10:49:31 -0700
Message-Id: <20230314174940.62221-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

