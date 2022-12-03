Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C298C641965
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiLCWOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiLCWNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A861CB1C
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6B9B60C63
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0ADC43470;
        Sat,  3 Dec 2022 22:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105629;
        bh=6N5998hJr4Ndu8+TW1sKhyLvTndqPYb+YTdE2GoMRFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY7jtvogYze7pEnCvhTcnaK/1DmU1fkSHto/fvD+Wzw+y+JaeFe/0olirSKRFWQB4
         Sm7dJysqZTB6aeYsy7K/A17058WkGDhcvvfEZromQygWH1VM1PIcmWto84bTrJnJ4S
         hNafIqw92woRlf4r5XTPMQEToXtDbKbJ5KiOYTnhkd1tXylDTUMYvGns0EcfKOcTg7
         Gv/rmrb6FW1vSR0VEirIg6DFmnWfY+IQ0dYdOH1LvFAFP82REBDwtl+ybSqRbb5MX1
         hhSLk/36s3F2wFv7qsUh5c55jskbD58PskqgDjGzFjHIAqJlGW/WxVz9pQs8tv5LFQ
         DTUQf22QSbNiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: TC, set control params for branching actions
Date:   Sat,  3 Dec 2022 14:13:28 -0800
Message-Id: <20221203221337.29267-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

Extend the act tc api to set the branch control params aligning with
the police conform/exceed use case.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  9 +++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 8ede44902284..8346557eeaf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -32,6 +32,11 @@ struct mlx5e_tc_act_parse_state {
 	struct mlx5_tc_ct_priv *ct_priv;
 };
 
+struct mlx5e_tc_act_branch_ctrl {
+	enum flow_action_id act_id;
+	u32 extval;
+};
+
 struct mlx5e_tc_act {
 	bool (*can_offload)(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
@@ -61,6 +66,10 @@ struct mlx5e_tc_act {
 	int (*stats_action)(struct mlx5e_priv *priv,
 			    struct flow_offload_action *fl_act);
 
+	bool (*get_branch_ctrl)(const struct flow_action_entry *act,
+				struct mlx5e_tc_act_branch_ctrl *cond_true,
+				struct mlx5e_tc_act_branch_ctrl *cond_false);
+
 	bool is_terminating_action;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index c8e5ca65bb6e..81aa4185c64a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -147,6 +147,19 @@ tc_act_police_stats(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static bool
+tc_act_police_get_branch_ctrl(const struct flow_action_entry *act,
+			      struct mlx5e_tc_act_branch_ctrl *cond_true,
+			      struct mlx5e_tc_act_branch_ctrl *cond_false)
+{
+	cond_true->act_id = act->police.notexceed.act_id;
+	cond_true->extval = act->police.notexceed.extval;
+
+	cond_false->act_id = act->police.exceed.act_id;
+	cond_false->extval = act->police.exceed.extval;
+	return true;
+}
+
 struct mlx5e_tc_act mlx5e_tc_act_police = {
 	.can_offload = tc_act_can_offload_police,
 	.parse_action = tc_act_parse_police,
@@ -154,4 +167,5 @@ struct mlx5e_tc_act mlx5e_tc_act_police = {
 	.offload_action = tc_act_police_offload,
 	.destroy_action = tc_act_police_destroy,
 	.stats_action = tc_act_police_stats,
+	.get_branch_ctrl = tc_act_police_get_branch_ctrl,
 };
-- 
2.38.1

