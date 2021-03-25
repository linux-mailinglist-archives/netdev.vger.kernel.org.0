Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2934882B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCYFFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCYFEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6809661A24;
        Thu, 25 Mar 2021 05:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648685;
        bh=+IdPbWs7MYobGyl22tW3H3PzIM4BslGgGn5MjbmJmvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIzvKeM026qCkjnMjxrXS7p+gSR+rAPsEh4djPaMqXwoGpCzRzOMlrls66ltQJWFN
         SEGynT9uTTg22IhaeGr9Rf2SjzbDJ1t8sMTHwJq1MclZqE71C4x9R/clLs3MwEeS/E
         iIbDRyIFgY3Fmt1QV+O4BsKp4B143i3V2xxwQqwZ8XnyqwrIjSqCYPx9yc2JkzDCRo
         /rokoAN2mAOznRispCxNWv5vczJHS5xF1QJ74kXtZFXrkwV3foe1TbPYPCm71ZEDFh
         g58lIPie+dv+nDpczx9SgjJC1CeaNlvdSGk9PqiuG0x99OqEMMBDl8/AztMO9fSQ2z
         85QYtNX1IF7Tg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [net-next 03/15] net/mlx5e: alloc the correct size for indirection_rqt
Date:   Wed, 24 Mar 2021 22:04:26 -0700
Message-Id: <20210325050438.261511-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The cited patch allocated the wrong size for the indirection_rqt table,
fix that.

Fixes: 2119bda642c4 ("net/mlx5e: allocate 'indirection_rqt' buffer dynamically")
CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 730f33ada90a..251941d3a8d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -447,11 +447,11 @@ static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
 
 static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
 {
-	u32 *indirection_rqt, rqn;
 	struct mlx5e_priv *priv = hp->func_priv;
 	int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
+	u32 *indirection_rqt, rqn;
 
-	indirection_rqt = kzalloc(sz, GFP_KERNEL);
+	indirection_rqt = kcalloc(sz, sizeof(*indirection_rqt), GFP_KERNEL);
 	if (!indirection_rqt)
 		return -ENOMEM;
 
-- 
2.30.2

