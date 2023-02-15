Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB37E6974FF
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbjBODoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjBODoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E2631E00
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39970B81FAC
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BCEC4339C;
        Wed, 15 Feb 2023 03:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676432644;
        bh=/rmBoYJ9Sf9kHrfLUqHxkYjkXa9C5XbYRkxIoSaVCCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quJxvQT3oDuvLUqDwjTwX2/gW+zdh1PeXnF/44tXOMNlgK/rDnkOVQyGU5umW1NcB
         xaZQdidBlMfbqaYOCLL1uEo9VNwdmazgpA34wzGeLhwQ4sjWju0pzf91mxhVYznyAf
         TpjAAIAZwzfFqC9yVTL47kits++YndC2XIB10u9YJ5lkrWssS6qlZw022micbhnRjz
         W03Ni92wooSqZaqVtEP09bap6HxHnvoEO6yhZT2YjNWas/KrlDp/nOHKCUU21UDcWH
         hwDH0LEmaAu5U+sZmYUuRXeHxcSVOOgJ7Yn5NwH/SnW/h4sUWbY43shYcKgiRC+XDU
         URPEBfNwzLHlg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, Jakub Kicinski <kuba@kernel.org>,
        saeedm@nvidia.com, leon@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, roid@nvidia.com,
        ozsh@nvidia.com, paulb@nvidia.com
Subject: [PATCH net-next 3/3] net: create and use NAPI version of tc_skb_ext_alloc()
Date:   Tue, 14 Feb 2023 19:43:55 -0800
Message-Id: <20230215034355.481925-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215034355.481925-1-kuba@kernel.org>
References: <20230215034355.481925-1-kuba@kernel.org>
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

Try to use the cached skb_ext in the drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: jhs@mojatatu.com
CC: xiyou.wangcong@gmail.com
CC: jiri@resnulli.us
CC: roid@nvidia.com
CC: ozsh@nvidia.com
CC: paulb@nvidia.com
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 +-
 include/net/pkt_cls.h                               | 9 +++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 3b590cfe33b8..ffbed5a92eab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -770,7 +770,7 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
 		struct mlx5_eswitch *esw;
 		u32 zone_restore_id;
 
-		tc_skb_ext = tc_skb_ext_alloc(skb);
+		tc_skb_ext = tc_skb_ext_alloc_napi(skb);
 		if (!tc_skb_ext) {
 			WARN_ON(1);
 			return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2d06b4412762..3d9da4ccaf5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5643,7 +5643,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
 		chain = mapped_obj.chain;
-		tc_skb_ext = tc_skb_ext_alloc(skb);
+		tc_skb_ext = tc_skb_ext_alloc_napi(skb);
 		if (WARN_ON(!tc_skb_ext))
 			return false;
 
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ace437c6754b..82821a3f8a8b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -764,6 +764,15 @@ static inline struct tc_skb_ext *tc_skb_ext_alloc(struct sk_buff *skb)
 		memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
 	return tc_skb_ext;
 }
+
+static inline struct tc_skb_ext *tc_skb_ext_alloc_napi(struct sk_buff *skb)
+{
+	struct tc_skb_ext *tc_skb_ext = napi_skb_ext_add(skb, TC_SKB_EXT);
+
+	if (tc_skb_ext)
+		memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
+	return tc_skb_ext;
+}
 #endif
 
 enum tc_matchall_command {
-- 
2.39.1

