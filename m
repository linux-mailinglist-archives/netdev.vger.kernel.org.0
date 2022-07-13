Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0E573FE2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiGMW75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiGMW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEE2A725
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F96EB821FF
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A4EC34114;
        Wed, 13 Jul 2022 22:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753161;
        bh=u3q18l0UrDi5oqxP/4Oeosvi/btvtydfUWY0P40E2kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLArKXUC03c/pxuG3lPA/qd8qDlclUSUInj9MPjBalt07W3yMhP4uiQxfNwUfSX+E
         A6yipmEgdWxmcb5RLXutufw2oebROMqM8x0coadoOlxAN7jxQ1GETbb+aof0T3p93U
         jtC567pnj4g302PhjA1XFFGP+y6eVnaWWGMUFWH2iCpaMWIzNY9RqYjgniZpM8wiph
         Jv0EeLLE827pjUV8Jm7XAWHc93peNRip3S6qj9h7gqH1DJP4TfKPzWhuzbpl6J6v+C
         27FgdmUwT3fgWojGgdJLMdgWdRWWBjW4rMPRTVv8oqGf5k+sy6lMYdQTlHoOKYRDTq
         70XRsePJP89fg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: configure meter in flow action
Date:   Wed, 13 Jul 2022 15:58:56 -0700
Message-Id: <20220713225859.401241-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

After police action is parsed, set meter data in flow action,
so they can be used when adding FTE.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 85b3aa4d7955..da1959caae41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -512,6 +512,20 @@ esw_cleanup_dests(struct mlx5_eswitch *esw,
 	}
 }
 
+static void
+esw_setup_meter(struct mlx5_flow_attr *attr, struct mlx5_flow_act *flow_act)
+{
+	struct mlx5e_flow_meter_handle *meter;
+
+	meter = attr->meter_attr.meter;
+	flow_act->exe_aso.type = attr->exe_aso_type;
+	flow_act->exe_aso.object_id = meter->obj_id;
+	flow_act->exe_aso.flow_meter.meter_idx = meter->idx;
+	flow_act->exe_aso.flow_meter.init_color = MLX5_FLOW_METER_COLOR_GREEN;
+	/* use metadata reg 5 for packet color */
+	flow_act->exe_aso.return_reg_id = 5;
+}
+
 struct mlx5_flow_handle *
 mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
@@ -579,6 +593,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
+	if ((flow_act.action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) &&
+	    attr->exe_aso_type == MLX5_EXE_ASO_FLOW_METER)
+		esw_setup_meter(attr, &flow_act);
+
 	if (split) {
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
-- 
2.36.1

