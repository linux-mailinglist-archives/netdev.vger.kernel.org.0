Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65D254A4DE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351638AbiFNCLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352745AbiFNCLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC22C340D6;
        Mon, 13 Jun 2022 19:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2920560C15;
        Tue, 14 Jun 2022 02:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A9BC36AFF;
        Tue, 14 Jun 2022 02:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172411;
        bh=wlx8IVpnV3uzgVLiWFw1A/YnWrKtwDyrE7/A0OAGLxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6FxctM/LtYmB3TimmVDv+xTGHBU34pUzm9Ao1p70Z1ygjVy7uVoyL1mmnhRstIDj
         rguoOG4VtEzh5DEXGRA5ix3oDl+SNqINGrI9ToNd2EPIxV3Dppcmg/t50vufug6YKY
         KO9kLmgVYaBDgYX08rSeJcO40qvgLKcdVeGbm2dUeS0G+svdZEvvRz9s9ylt5IukuQ
         IlVafT0HfsDmw4DXoBewxcdKYNkByHsLM26Gx5ecO37sANtJBbVdnOJnpQ74KPSGM1
         cJtEltwWhJ7NfBewwjdJ5XvTQlPGsvtdKuOR8jsy58+rXZt/9MLfzuyownYmMxRalt
         gZsT+iXpI6YXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 33/43] mellanox: mlx5: avoid uninitialized variable warning with gcc-12
Date:   Mon, 13 Jun 2022 22:05:52 -0400
Message-Id: <20220614020602.1098943-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 842c3b3ddc5f4d17275edbaa09e23d712bf8b915 ]

gcc-12 started warning about 'tracker' being used uninitialized:

  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c: In function ‘mlx5_do_bond’:
  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: warning: ‘tracker’ is used uninitialized [-Wuninitialized]
    786 |         struct lag_tracker tracker;
        |                            ^~~~~~~

which seems to be because it doesn't track how the use (and
initialization) is bound by the 'do_bond' flag.

But admittedly that 'do_bond' usage is fairly complicated, and involves
passing it around as an argument to helper functions, so it's somewhat
understandable that gcc doesn't see how that all works.

This function could be rewritten to make the use of that tracker
variable more obviously safe, but for now I'm just adding the forced
initialization of it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4ddf6b330a44..f61b846d43f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -485,7 +485,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = { };
 	bool do_bond, roce_lag;
 	int err;
 
-- 
2.35.1

