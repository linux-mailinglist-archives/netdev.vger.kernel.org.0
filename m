Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB193D64F5
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhGZQRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241130AbhGZQP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF8E60F6B;
        Mon, 26 Jul 2021 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318554;
        bh=KShrqARKA9SqA/+dQldppIu2zDZu5nAEAd3T3jl/AgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTcbxHU6ftUGE1o1W2R+aEserkVPLhiTEqBr864VNodbHpn9dFkBiLWYBmqgBHGQt
         y1Da9WjmeoeSeb/wUVDH1E6fq4rgDE1rgbKaxe/rMowo+W/mH4rW5BnWMfO/LIvHuU
         m1aUuLXtgbZkjTELIsQFfXkUgx6670+I4+jqj0AbYCrelw2jAWeVSLrVCvrLmi64/6
         o/p85NTdM58SugBuEiWJZkjvnyrmWto9MrGpdjjz/dFi6nHpq8jmhwtAeIXJg2OOPH
         l43YY/MCkaME8NY5IoEy7KEcP7VGitckZEWGyKoH0XYuAw8evf3n10656hj1adK2lr
         MsfUtIwnm+lKg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: Take TIR destruction out of the TIR list lock
Date:   Mon, 26 Jul 2021 09:55:31 -0700
Message-Id: <20210726165544.389143-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

res->td.list_lock protects the list of TIRs. There is no point to call
mlx5_core_destroy_tir() and invoke a firmware command under this lock.
This commit moves this call outside of the lock and puts it after
deleting the TIR from the list to ensure that TIRs are always alive
while in the list.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 8c166ee56d8b..f3bdd063051a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -58,9 +58,10 @@ void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 
 	mutex_lock(&res->td.list_lock);
-	mlx5_core_destroy_tir(mdev, tir->tirn);
 	list_del(&tir->list);
 	mutex_unlock(&res->td.list_lock);
+
+	mlx5_core_destroy_tir(mdev, tir->tirn);
 }
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
-- 
2.31.1

