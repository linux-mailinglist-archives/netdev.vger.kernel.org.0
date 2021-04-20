Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29B83650C7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhDTDVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhDTDVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E282613B2;
        Tue, 20 Apr 2021 03:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888835;
        bh=uWOdTBMgq4Bh2ancVM2WHxoQ91S18wYp5UT58ns/7Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx5ldA+Hn4H4T3vta0XaqSGQwzm7U70apBeagqpatfN6R9EW/qfl2C6a4CnSc+bhN
         M8fZs2xQ7sgq6AdKwYrDNSvtsOlcdoakz/JQRik/hje7R491OENgsvDXcJuvbSoKbY
         gD0zybYW2FJBe8FbzyN8BR7kD79VhFy3NNsQUogaGYTfGVMCDgmFaxy/LywGnJCjlO
         MJwsQfdLJNQxtdAfFoPl/J6og3PfdWw8dHsRN6HQRiBitRPm/3xZNp0YK8lfCkFGI0
         /A1tuNarEoHPNGZAFmyOUyaHaG4m0wkloGMhM88L5Q+7nz+F2zpff2DY1bWH0kenf9
         8Ve6tA7ox/LnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: DR, Fix SQ/RQ in doorbell bitmask
Date:   Mon, 19 Apr 2021 20:20:08 -0700
Message-Id: <20210420032018.58639-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

QP doorbell size is 16 bits.
Fixing sw steering's QP doorbel bitmask, which had 20 bits.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 1f2e9fee96bc..37377d668057 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -213,7 +213,7 @@ static void dr_destroy_qp(struct mlx5_core_dev *mdev,
 static void dr_cmd_notify_hw(struct mlx5dr_qp *dr_qp, void *ctrl)
 {
 	dma_wmb();
-	*dr_qp->wq.sq.db = cpu_to_be32(dr_qp->sq.pc & 0xfffff);
+	*dr_qp->wq.sq.db = cpu_to_be32(dr_qp->sq.pc & 0xffff);
 
 	/* After wmb() the hw aware of new work */
 	wmb();
-- 
2.30.2

