Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C09453AE6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhKPU0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhKPU0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A52761AE2;
        Tue, 16 Nov 2021 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094217;
        bh=G0ctW+V/0cfKMZMu3fnVvH3FmXEyy7Cr0ksKl1n2npc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8QRWTIhip30QyQgiKZ5AY0E4wmKD1p4bAEBFlDmtkQa39mS9o9nWwYhv08CO7M9G
         cEmYEA3sHHbH1KYHe0P1jDD2j25OI3Y6/FdOlV0AdRQZ3QpKRXg4bsEY+W3fRwp7yX
         6gj54GW+bNunQFlVr37mzpont1FFCoZYjR4kyFnFsp6hNlLG+zSCvAA71ENUOr6w8v
         yaPliz6Cz2tus5FH3f9CN4PURGu67gOHaJxP06jUmR+kIfQ9VAxCRAELzUOg5U7ipl
         fzwef3KZbc+neSiV47E3elWJOnFBvBRIcmQ1ZHAeFrd+xMTwW7F2eQKeMg+WqoQdf9
         z25Scp/B/Kqzw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/12] net/mlx5: DR, Fix check for unsupported fields in match param
Date:   Tue, 16 Nov 2021 12:23:15 -0800
Message-Id: <20211116202321.283874-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The existing loop doesn't cast the buffer while scanning it, which
results in out-of-bounds read and failure to create the matcher.

Fixes: 941f19798a11 ("net/mlx5: DR, Add check for unsupported fields in match param")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 75c775bee351..793365242e85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -924,11 +924,12 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 
 	/* Check that all mask data was consumed */
 	for (i = 0; i < consumed_mask.match_sz; i++) {
-		if (consumed_mask.match_buf[i]) {
-			mlx5dr_dbg(dmn, "Match param mask contains unsupported parameters\n");
-			ret = -EOPNOTSUPP;
-			goto free_consumed_mask;
-		}
+		if (!((u8 *)consumed_mask.match_buf)[i])
+			continue;
+
+		mlx5dr_dbg(dmn, "Match param mask contains unsupported parameters\n");
+		ret = -EOPNOTSUPP;
+		goto free_consumed_mask;
 	}
 
 	ret =  0;
-- 
2.31.1

