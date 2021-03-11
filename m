Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4603380A9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCKWht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhCKWhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA2D64F98;
        Thu, 11 Mar 2021 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502256;
        bh=sTMmWBPsNWumApF+ei17PukFgrUm2DXrklariCo/2/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvzYZZA/lcR5sbmGjuKL657Tl9uhBuhDFRZv75rYqg5NNxSlD0D2m3pAXFNSlOuNO
         OuyVaNEJBGS0G1Lqetq91G67tU2n1uCjo6IcANlnfKnWRtTIJQ/50c/r5erC2/1cjq
         q1EjZ2R2xcxGX+qLJ4wSyMPPCnir6hPBnrf5oUlgn3GIjtCyT7rkeiQjiTMosXKNyZ
         uLOmdls1PoYOlb1eEPIQdVJ/2lf8tISOay5nv+ufOtKudK9n9rPMvnH7szyhQV6kzI
         082EqK70uFshCQkibY0ha5cLmQvGFvRlhfChoHsBAhdbDggbQPWNufhbusx6kojdAy
         EUpG7fReGX7dw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Don't rely on interface state bit
Date:   Thu, 11 Mar 2021 14:37:13 -0800
Message-Id: <20210311223723.361301-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The check of MLX5_INTERFACE_STATE_UP is completely useless, because
the FW tracer cleanup is called on every change of the interface
and it ensures that notifier is disabled together with canceling
all the pending works.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 49e106719392..01a1d02dcf15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1126,8 +1126,7 @@ static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void
 
 	switch (eqe->sub_type) {
 	case MLX5_TRACER_SUBTYPE_OWNERSHIP_CHANGE:
-		if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state))
-			queue_work(tracer->work_queue, &tracer->ownership_change_work);
+		queue_work(tracer->work_queue, &tracer->ownership_change_work);
 		break;
 	case MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE:
 		if (likely(tracer->str_db.loaded))
-- 
2.29.2

