Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0777A573FDC
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiGMW7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGMW72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5252A977
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC5D61A7E
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF84C3411E;
        Wed, 13 Jul 2022 22:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753162;
        bh=P9PJgLyWP9t3YNyWvg7ZzDY7SRlOTTUtn6sH3uhu4DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5kYU9FxUkqgtjOdqu12cpmecC44k7v1VeKctGcRMDS6JRhitu1e/tjkX40eIwVeV
         Y166nGEvlvjJTKV0jug8QWD9s/8qESGRSKV6Q9X3ZSn1qwg8xAvSaOMNKTaaHI/pdo
         Vu5n98hKcOuwTwtwK9h9ZXuFd0wkMGwEP30dpWGkdriU5FjSIBIPNWwchmg3YMVLyB
         tYWXj5x0O0u/e6hozTJBM9g+ykt9lsu1KaewIuxQrjpQ6tn0kzkGstvQ15n+DHlH5k
         YOpQJ1REkqB9V/hbk3lhjBY02PuV+cRoPvd2KXtZ69yP4lnt0zfWwy++CgGu8CxZPs
         RkWehZ0yNQegQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Extend flower police validation
Date:   Wed, 13 Jul 2022 15:58:57 -0700
Message-Id: <20220713225859.401241-14-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

Recent net commit 4d1e07d83ccc ("net/mlx5e: Fix matchall police parameters
validation") removed notexceed action id validation from
mlx5e_police_validate() and left it up to callers. However, since
tc_act_can_offload_police() only exists in net-next its validation is
extended in this dedicated followup patch.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index ab32fe6a2e57..4bd9c04a49e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -10,6 +10,12 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
 			  int act_index,
 			  struct mlx5_flow_attr *attr)
 {
+	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(parse_state->extack,
+				   "Offload not supported when conform action is not pipe or ok");
+		return false;
+	}
 	if (mlx5e_policer_validate(parse_state->flow_action, act,
 				   parse_state->extack))
 		return false;
-- 
2.36.1

