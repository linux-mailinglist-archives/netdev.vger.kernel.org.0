Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA86D8D30
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbjDFCDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbjDFCDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF597EE6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D43F462C26
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F3DC433EF;
        Thu,  6 Apr 2023 02:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746571;
        bh=UhhyR2ADQ3IBwK41L5bnGARCJ+9lje7wfOQGJvfIzvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5+R2YV3AKQvfGjjn83I/A7U+1cOdDgx6seJ7m0figjPUFMJGorwOqmg7PluJzqpV
         TSAOQQddjKK4P8TMy/BqI+t22uflM44QMhnocCF7Wts1FHTDB93+uQb6Qfz/e+DRaC
         uLBWzujtWMQqJyy5GhU7DCimhL7oAyvmmPrx7Qh7ydDWelW2XE9zTzXZ6nfeXzuHD2
         fBEKSbab/+bpLXKFA0rQ2MgBez9QTZasHxq2Yyl1wdraXlOgX9AiaSjxxH9gIvg+7R
         Og5Ucs9PJGCxdmM7s3ou5nxYulINKiRzeTGsC9rqgIh1Jkk9mKqx6LQprnf9FlMXZ3
         /dDszx22LJKxQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: TC, Remove mirror and ct limitation
Date:   Wed,  5 Apr 2023 19:02:26 -0700
Message-Id: <20230406020232.83844-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Mirror action before a ct nat action was not supported when only
chain was restored on misses. As to work around that limitation,
ct action was reordered to be first (so if hw misses on ct
action, packet wasn't modified). This reordering wasn't possible
if there was mirror action before the ct nat action, as we had to
mirror the packet before the nat operation.

Now that the misses continue from the relevant tc ct action
in software and ct action is no longer reordered, this case
is supported.

Remove this limitation.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b6469abc7012..728b82ce4031 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3507,19 +3507,6 @@ actions_match_supported_fdb(struct mlx5e_priv *priv,
 			    struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_flow_attr *esw_attr = flow->attr->esw_attr;
-	bool ct_flow, ct_clear;
-
-	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
-	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-
-	if (esw_attr->split_count && ct_flow &&
-	    !MLX5_CAP_GEN(esw_attr->in_mdev, reg_c_preserve)) {
-		/* All registers used by ct are cleared when using
-		 * split rules.
-		 */
-		NL_SET_ERR_MSG_MOD(extack, "Can't offload mirroring with action ct");
-		return false;
-	}
 
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
-- 
2.39.2

