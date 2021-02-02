Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF91830B830
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhBBG6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232292AbhBBG4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCCCE64EF1;
        Tue,  2 Feb 2021 06:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248923;
        bh=L15FatajAyy3rvAPGIPPQz372ewQ6y+1gWvpCt84AmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuJ7Ksk+KlIP6nzFdi79SKWnD+QHhRHuHuHqCVIPE/Qys8mJ5r5ehwmY0SahuaUdz
         ig78229EnhdcLEqigBe3nYeeT0hLfE5pvcJOMHpSqkcH/hv/azzHtLfsjNqbeMqPaG
         cGtU9EM7aRKb//LnpTYz5ceMjHdzOVtHbWi2wDvQQrHhABoGDCvgIko+siJCHAxz2K
         KFAMIXHBl6cinZygHSv7dt6sl3Rv8FdjbYOZYQDVztHLnK5B/NapEUNE/RGzyJ56q7
         ET7NKYnfcuV+wL3omcMQu9hek7gJRiAPmB6xOD+gSIqIYTC+QdboYjAuxuMOg0u1xq
         eZuIDIxPuZesg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5e: CT: remove useless conversion to PTR_ERR then ERR_PTR
Date:   Mon,  1 Feb 2021 22:54:56 -0800
Message-Id: <20210202065457.613312-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Just return the ptr directly.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e417904ae17f..40aaa105b2fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -770,7 +770,6 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_counter *shared_counter;
 	struct mlx5_ct_entry *rev_entry;
 	__be16 tmp_port;
-	int ret;
 
 	/* get the reversed tuple */
 	tmp_port = rev_tuple.port.src;
@@ -804,10 +803,8 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	mutex_unlock(&ct_priv->shared_counter_lock);
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);
-	if (IS_ERR(shared_counter)) {
-		ret = PTR_ERR(shared_counter);
-		return ERR_PTR(ret);
-	}
+	if (IS_ERR(shared_counter))
+		return shared_counter;
 
 	shared_counter->is_shared = true;
 	refcount_set(&shared_counter->refcount, 1);
-- 
2.29.2

