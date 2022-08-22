Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936A559C970
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiHVUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiHVT7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC82052FFA
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72CBDB818C0
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144F6C433B5;
        Mon, 22 Aug 2022 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198376;
        bh=2jWYnQHgN7lVmWgt3jvsN+o6WZguDvZAp7dSd+vP5hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEuFJ9PnQQREWxa4ysSPnSYXdrCUaynu+dJKMza96K9Fn6BRgk03jGetB4hFfXK7+
         XnFuD92QirlwiZpnuW/WImKu8kjV0kkw16a8Uo4tWrBo61SFxkKwcirsD6ITe4KVmM
         uTWgXx+IxgSbmIWEOY5F9Cvkc7T4Fr99jrD1DLAiRMK3cJpLilfeFnYTu8SnfB3ElQ
         qrOCXwAIKs4SN1NZCgFwzAECBGBErUcPZlHc7wB8sUr85/3Bneh+iETuoirhdM4YeJ
         doo8ZNf0IcFmhqGmz92k/nKWx5t0HVn6AO5dbuqmji7QeLO/KIMDuEdttEh5FFjqgt
         mN/TP2OooDpiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net 08/13] net/mlx5e: TC, Add missing policer validation
Date:   Mon, 22 Aug 2022 12:59:12 -0700
Message-Id: <20220822195917.216025-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

There is a missing policer validation when offloading police action
with tc action api. Add it.

Fixes: 7d1a5ce46e47 ("net/mlx5e: TC, Support tc action api for police")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index 37522352e4b2..c8e5ca65bb6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -79,6 +79,10 @@ tc_act_police_offload(struct mlx5e_priv *priv,
 	struct mlx5e_flow_meter_handle *meter;
 	int err = 0;
 
+	err = mlx5e_policer_validate(&fl_act->action, act, fl_act->extack);
+	if (err)
+		return err;
+
 	err = fill_meter_params_from_act(act, &params);
 	if (err)
 		return err;
-- 
2.37.1

