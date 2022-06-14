Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7829D54A564
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353428AbiFNCQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354927AbiFNCPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:15:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B7D3CFF9;
        Mon, 13 Jun 2022 19:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5710FB8169A;
        Tue, 14 Jun 2022 02:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329C6C385A9;
        Tue, 14 Jun 2022 02:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172535;
        bh=3URXF5M3vcnkfz10ois3e+5aTzkVfZWqV/ln18/fkC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVKP8KWb5isZLQeRo2B9wruO4Ny6pacFVXVmMJLzxHq+hKxIQViJgpmYRxlCXcaIG
         mmNbBwMzLzRCiimJldE6X9vuFr9k6W7lsIz/sxahFzPgCjGHSWIcwgDGOWQ6T0ecbx
         MEdR7eUKIh/dstbSoM7o423q4+CSIeZ/h//yteEKewaYJgAzo7p6orz9mVUZgyy0F4
         cUWA+GD7+QVHRc7TxR5HIOKRHg/G5CnqdHYPevjxLsAo2q0OBSi+oqaXQsdHFgB9rU
         N3qpGudWRYpP90sLoMYiqWrGDqnsITwx6KaKk6CVJSlLmxPH9V5nYbsChlsCggAqXh
         XzyoCHOmX1X1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/29] mellanox: mlx5: avoid uninitialized variable warning with gcc-12
Date:   Mon, 13 Jun 2022 22:08:12 -0400
Message-Id: <20220614020815.1099999-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 11cc3ea5010a..9fb3e5ec1da6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -274,7 +274,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = { };
 	bool do_bond, roce_lag;
 	int err;
 
-- 
2.35.1

